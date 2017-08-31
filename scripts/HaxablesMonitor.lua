-- _HaxablesMonitor.lua
-- Author: Gaticus Hax
-- License: Public Domain
--
-- This script will detect whenever the currently open file or process in CE
-- changes and adjust the CheatTable's baseAddress needed for file or RAM mode.
-- It will also detect if an invalid process has been opened and force the
-- user to change it or else automatically shutdown CE. Unfortunately it
-- can't detect if the MBIN is valid, only the NMS process.
--
-- This is meant to be used in conjunction with MBIN signature scripts
-- that are unique to each CheatTable and should not otherwise be needed.
--
-- A signature script should be run once when a CheatTable is loaded and
-- must call defineMBIN(). That's it.
--
-- All other functions are for internal use.
local modulePath = (...):match("(.-)[^%.]+$")

-- HAX_LOGDEBUG = true

require(modulePath .. "CommonFunctions")

local HAX_processName = "NMS.exe"
local HAX_mbinOffset = 0x0060
local HAX_onOpenProcessDelay = 3000 -- ms
local HAX_shutdownDelay = 30000 -- ms

local HAX_mbinFile      = ""
local HAX_dataSignature = ""
local HAX_dataOffset    = 0x00000000

local conflictTimer = nil

function findSignature(signature)
  local ms=createMemScan()
  logDebug("Searching for \"%s\" ...", signature)
  ms.firstScan(soExactValue, vtByteArray, 0, signature, "", 0, 0x7fffffffffffffff, "", fsmAligned, "1", true, false, false, true)
  ms.waitTillDone()

  local f=createFoundList(ms)
  f.initialize()

  if f.Count > 1 then
    local addresses = ""
    for i=0, f.Count-1 do
      addresses = string.format("%s%s\n", addresses, f.Address[i])
    end
    logMessage(
       "ERROR: More than one result (%d) found for the data signature!\n"
    .. "You're likely using a newer version of %s that has broken compatability"
    .. " with this Haxable.\n"
    .. "%s"
      ,f.Count
      ,HAX_processName
      ,addresses
    )
    return 0
  end

  local addr=f.Address[0]
  for i=0, f.Count-1 do
    logDebug("found=0x%s", f.Address[i])
  end

  f.destroy()
  ms.destroy()

  return addr
end

function findBaseAddress(signature, offset)
  local al=getAddressList()
  local base=al.getMemoryRecord(0)
  local addr=findSignature(signature)
  addr=tonumber(string.format("0x%s", addr))

  if addr == 0 then
    logMessage(
       "ERROR: Couldn't find the data signature!\n"
    .. "%s must be running and the process must be opened in CheatEngine.\n"
    .. "If %s is open in CheateEngine then try restarting CE.\n"
    .. "If it's still not working, your version of %s is probably not supported.\n"
    .. "Make sure that your version of %s is compatible with these CheatTables.\n"
      ,HAX_processName
      ,HAX_processName
      ,HAX_processName
      ,HAX_processName
    )
    return
  end

  addr = addr - offset
  --addr=string.format("%X", addr)
  return addr
end

function setBaseAddress(addr)
  addr = string.format("0x%X", addr)
  logDebug("addr=%s", addr)
  local al=getAddressList()
  local base=al.getMemoryRecord(0)
  base.setAddress(addr)
  logDebug("\n")
  logMessage("READY")
end

function conflictDetected()
  -- start/reset the conflictTimer
  local mf = getMainForm()
  conflictTimer = createTimer(mf)
  conflictTimer.Interval = HAX_shutdownDelay
  conflictTimer.OnTimer = onShutdownTimer
end

function conflictResolved()
  if conflictTimer == nil then return end

  conflictTimer.destroy()
  conflictTimer = nil

  logDebug("\n")
  logDebug("... Process conflict resolved. Shutdown aborted.")
end

function onShutdownTimer(timer)
  local ID = getOpenedProcessID()
  if (id ~= 0xFFFFFFFF) then
    if (process ~= HAX_processName) then
       logDebug("Invalid process: %s", process)
       logDebug("Closing CheatEngine...")
       closeCE()
       return
    end
  end

  conflictResolved()
end

function updateBaseAddress()
  logMessage(
     "Detected new process being attached.\n"
  .. "Please wait for the baseAddress to finish being updated before making changes!\n"
  )

  local ID = getOpenedProcessID()
  if (ID ~= 0xFFFFFFFF) then
    if (process == HAX_processName) then
      conflictResolved()
      -- calculate offset for process mode
      logDebug("%s process loaded. Calculating new base address.", process)
      setBaseAddress(findBaseAddress(HAX_dataSignature, HAX_dataOffset))
      return
    elseif (process ~= nil) then
      logMessage(
         "ERROR: Unsupported process loaded!\n"
      .. "%s is not compatible with these Haxables.\n"
      .. "This CheatTable will ONLY work with the %s process or the %s file.\n"
      .. "CheatEngine will automatically close in %d seconds.\n"
      .. "You can change the attached process to stop the shutdown.\n"
        ,process
        ,HAX_processName
        ,HAX_mbinFile
        ,(HAX_shutdownDelay / 1000)
      )
      conflictDetected()
      return
    end
  end

--  conflictResolved()

  -- reset offset for MBIN mode
  logDebug("MBIN mode detected. Resetting base address.")
  logDebug("\n")
  setBaseAddress(HAX_mbinOffset)
end

function onOpenProcessTimer(timer)
  timer.destroy()
  updateBaseAddress()
end

function onOpenProcessHandler(id)
  local mf = getMainForm()
  local t = createTimer()
  t.Interval = HAX_onOpenProcessDelay
  t.OnTimer = onOpenProcessTimer
end

function defineMBIN(mbinFile, dataSignature, dataOffset)
  HAX_mbinFile      = mbinFile
  HAX_dataSignature = dataSignature
  HAX_dataOffset    = dataOffset

  logDebug("MBIN FILE: %s", HAX_mbinFile)
  logDebug("DATA SIGNATURE: %s", HAX_dataSignature)
  logDebug("DATA OFFSET: %s", HAX_dataOffset)
  logDebug("\n")

  -- first run, set the address
  updateBaseAddress()

  -- watch for the open process to change
  onOpenProcess = onOpenProcessHandler
end
