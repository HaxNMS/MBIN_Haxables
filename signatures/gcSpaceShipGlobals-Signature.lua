-- gcSpaceshipGlobals-Signature.lua
-- Author: Gaticus Hax
-- License: Public Domain

require("Scripts.HaxablesMonitor")

local mbinFile      = "GCSPACESHIPGLOBALS.GLOBAL.MBIN"
local dataSignature = "00 00 01 00 00 01 01 00 00 00 80 3F 00 00 8C 42 00 00 80 3F 00 00 40 40 00 00 A0 41 00 00 C0 40"
local dataOffset    = 0x0000

defineMBIN(mbinFile, dataSignature, dataOffset)
