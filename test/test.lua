#!/usr/bin/env lua

require "wowTest"

ParseTOC( "../src/Wumpus.toc" )

test.outFileName = "testOut.xml"

-- addon setup
function test.before()
	WUMPUS.map = {}
	WUMPUS.InitGame()
end
function test.after()
end

function test.test_map_01()
	WUMPUS.PrintRoom()
	print(WUMPUS.wumpus)
	for i,_ in pairs(WUMPUS.pits) do
		print("pit: "..i)
	end
end

test.run()
