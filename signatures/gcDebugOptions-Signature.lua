-- gcDebugOptions-Signature.lua
-- Author: Gaticus Hax
-- License: Public Domain

require("Scripts.HaxablesMonitor")

local mbinFile      = "GCDEBUGOPTIONS.GLOBAL.MBIN"
local dataSignature = "53 43 45 4E 45 53 2F 44 45 4D 4F 53 2F 55 53 45 52 45 58 50 45 52 49 45 4E 43 45 2F 4D 41 49 4E 53 45 54 54 49 4E 47 53 2E 4D 58 4D 4C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 43 45 4E 45 53 2F 44 45 4D 4F 53 2F 53 50 52 49 4E 47 45 56 45 4E 54 32 30 31 36"
local dataOffset    = 0x0238

defineMBIN(mbinFile, dataSignature, dataOffset)
