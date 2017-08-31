require("Scripts.CommonFunctions")

local mbinPath = "X:\\GameLibrary\\No Mans Sky\\GAMEDATA"

local stdout = nil

function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function string.split(s, sep)
  return s:split(sep)
end

function getCurrentDirectory()
  stdout = io.popen("cd")
  local output = stdout:read('*all')
  stdout:close()
  return output
end

function createDirectory(path)
  if os.execute("dir /b \"" .. path .. "\"") ~= nil then
    -- already exists
    return true
  end

  -- create directory
  return (os.execute("mkdir \"" .. path .. "\"") ~= nil)
end

function mbinGetList(path)
  local list = {}
  local stdout = io.popen("dir /b \"" .. path .. "\\*.MBIN\"")
  local lines = stdout:lines()
  local count = 0
  for line in lines do
    list[count] = line
    count = count + 1
  end
  stdout:close()
  return list
end

function mbinReadFile(path)
  local file = io.open(path, "rb")
  local data = file:read('*all')
  file:close()
  return data
end

function string.toHex(s)
  local hex = ""
  for c=1, string.len(s) do
    hex = hex .. string.format("%02X ", s:byte(c))
  end
  return string.sub(hex,0, -2) -- trim trailing space
end

function mbinScanSignature(memScan, startAddress, hexString)
  memScan.newScan()
  memScan.setOnlyOneResult(true)
  memScan.firstScan(
      soExactValue, vtByteArray, 0
    , hexString, ""
    , startAddress, 0xffffffffffffffff
    , ""
    , fsmNotAligned, ""
    , true, false, false, false
  )
  memScan.waitTillDone()

  return memScan.getOnlyResult()
end

-- EXECUTION -------------------------------------------------------------------

printf("")

local currentDir = getCurrentDirectory()
printf("Current Directory = %s", currentDir)

-- remove \\scripts directory from path
local baseDir = currentDir
if string.sub(currentDir, -10, -1) == "\\scripts" then
  baseDir = string.sub(currentDir, 0, -10)
end
printf("Base Directory = %s", baseDir)

local tmpDir = baseDir .. "\\tmp\\signatures"
printf("Temp Signatures Directory = %s", tmpDir)
if createDirectory(tmpDir) then
  printf("Created tmp directory: %s", tmpDir)
else
  printf("Unable to create tmp directory: %s", tmpDir)
end

printf("")

local mbinList = mbinGetList(mbinPath)
for i=0, #mbinList do
  printf("%s", mbinList[i])
end

printf("")
printf("%d MBIN files detected.", #mbinList+1)


function generateSignatures(first, last)
  printf("GENERATING SIGNATURES ...")
  local ms = createMemScan()
  local failed = 0
  for i=first, last do -- mbinCount-1 do
    printf("")
    printf("Generating signature for %s", mbinList[i])
    data = mbinReadFile(mbinPath .. "\\" .. mbinList[i])
    printf("File Size: %d bytes", string.len(data))

    -- replace .MBIN extension with .txt
    local outputFileName = string.sub(mbinList[i], 0, -5) .. "txt"
  --  local outputFile = io.open(tmpDir .. "\\" .. outputFileName, "w")
  --  outputFile:write(string.format());
  --  outputFile:close()

    local offset = 0x60
    local signature = string.sub(data, offset+1, offset+32)
    local hex = string.toHex(signature)
  --  for c=1, string.len(data)-1 do
  --    hex = hex .. string.format("%02X", data:byte(c)) .. " "
  --  end
  --  hex = string.sub(hex, 0, -2) -- strip trailing space
    printf("")
    printf("Trying [offset 0x%08X] \"%s\" ...", offset, hex)

    local result = mbinScanSignature(ms, 0, hex)
    if result ~= nil then
      -- try a second scan starting from the first found location
      -- to make sure the result is unique
      local duplicate = mbinScanSignature(ms, result + string.len(signature))
      if duplicate == nil then
        printf("Unique signature found at 0x%08X", offset)
      else
        printf("Signature is not unique!")
        failed = failed + 1
      end
    else
      printf("Signature not found!")
      failed = failed + 1
    end

    --local results=createFoundList(ms)
    --results.initialize()
--    if results.Count == 1 then
--      printf("Unique signature found at 0x%08X", offset)
--    else
--      if results.Count > 1 then
--        printf("Signature is not unique!")
--      else
--        printf("Signature not found!")
--      end
--      failed = failed + 1
--    end

    -- replace .MBIN extension with .lua
  --  local fileName = string.sub(mbinList[0], 0, -5) .. "lua"
  end

  printf("")
  if failed > 0 then
    printf("Unable to find unique signatures for %d MBIN files!", failed)
  else
    printf("Unique signatures found for all MBIN files.")
  end
end

generateSignatures( 0,  2)
--generateSignatures( 5,  9)
--generateSignatures(10, 14)
--generateSignatures(15, 19)
--generateSignatures(20, 24)
--generateSignatures(25, 26)
