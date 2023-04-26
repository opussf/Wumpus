#!/usr/bin/env lua

require "wowTest"

ParseTOC( "../src/InterruptAware.toc" )

test.outFileName = "testOut.xml"

InterruptAwareFrame = CreateFrame()

-- addon setup
function test.before()
	InterruptAware_options = {
		["debugLevel"] = 4,
		["say"] = false,
		["pruneDays"] = 4,
	}
end
function test.after()
	for i, log in pairs( InterruptAware_log ) do
		for ts, msg in pairs( log ) do
			print( ts )
		end
	end
end
	-- timestamp,event,hideCaster,srcGUID,srcName,srcFlags,srcFlags2,
	--		targetGUID,targetName,targetFlags,targetFlags2,spellId = CombatLogGetCurrentEventInfo()

function test.notest_COMBAT_LOG_EVENT_UNFILTERED_01()
	CombatLogCurrentEventInfo = { 0, "SWING_DAMAGE", "unknown", "Player-3661-06DB0FE4", "testPlayer", 1297, 0,
			"Creature-0-3131-0-13377-2544-00004ACCAE", "Southern Sand Crawler", 68136, 0x0, 0 }
	InterruptAware.COMBAT_LOG_EVENT_UNFILTERED( )
end
function test.test_Prune_Empty()
	InterruptAware_log = {}
	InterruptAware.PruneLog( )
end
function test.test_Prune_01()
	InterruptAware_log = {
		{[1680572453] = "Hello"},
		["19700101"] = {{"Text"}},
		["1970041512"] = {{"Text"}},
		["1970010101"] = {{"Text"}},
	}
	InterruptAware.PruneLog( )
end

test.run()
