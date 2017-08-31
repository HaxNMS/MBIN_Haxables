-- gcRobotGlobals-Signature.lua
-- Author: Gaticus Hax
-- License: Public Domain

require("Scripts.HaxablesMonitor")

local mbinFile      = "GCROBOTGLOBALS.MBIN"
local dataSignature = "00 00 A0 42 00 00 40 3F 00 00 00 3F CD CC CC 3D 01 00 00 00 33 33 B3 3F 00 00 00 40 00 00 40 40"
local dataOffset    = 0x0000

defineMBIN(mbinFile, dataSignature, dataOffset)
