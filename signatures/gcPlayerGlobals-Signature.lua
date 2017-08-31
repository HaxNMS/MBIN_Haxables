-- gcPlayerGlobals-Signature.lua
-- Author: Gaticus Hax
-- License: Public Domain

require("Scripts.HaxablesMonitor")

local mbinFile      = "GCPLAYERGLOBALS.GLOBAL.MBIN"
local dataSignature = "01 00 00 00 00 00 16 44 00 00 48 44 9A 99 59 3F 00 00 C8 43 00 00 C8 43 9A 99 59 3F 00 00 00 00"
local dataOffset    = 0x0000

defineMBIN(mbinFile, dataSignature, dataOffset)
