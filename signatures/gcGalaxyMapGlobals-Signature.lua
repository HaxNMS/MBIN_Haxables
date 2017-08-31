-- gcGalaxMapGlobals-Signature.lua
-- Author: Gaticus Hax
-- License: Public Domain

require("Scripts.HaxablesMonitor")

local mbinFile      = "GCGALAXYGLOBALS.GLOBAL.MBIN"
local dataSignature = "00 00 90 40 00 00 40 40 00 00 00 40 00 00 00 41 00 00 00 00 CD CC 4C 3F 00 00 80 3F 00 00 00 40"
local dataOffset    = 0x0000

defineMBIN(mbinFile, dataSignature, dataOffset)
