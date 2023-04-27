#!/usr/bin/env lua

random = math.random
strfind = string.find
strsub = string.sub

SlashCmdList = {}
SLASH_WUMPUS1 = ""

-- import the addon file
includePath = "./"
addonName = "WUMPUS"
WUMPUS = {}

local loadedfile = assert( loadfile( includePath.."Wumpus_core.lua" ) )
loadedfile( addonName, WUMPUS )

WUMPUS.InitGame()

while WUMPUS.player and WUMPUS.wumpus do
	WUMPUS.PrintRoom()
	io.write( "> " )
	cmd = io.read("*line")
	WUMPUS.Command( cmd )
end
