-- Wumpus @VERSION@
WUMPUS_SLUG, WUMPUS = ...

-- Colours
COLOR_RED = "|cffff0000"
COLOR_GREEN = "|cff00ff00"
COLOR_BLUE = "|cff0000ff"
COLOR_PURPLE = "|cff700090"
COLOR_YELLOW = "|cffffff00"
COLOR_ORANGE = "|cffff6d00"
COLOR_GREY = "|cff808080"
COLOR_GOLD = "|cffcfb52b"
COLOR_NEON_BLUE = "|cff4d4dff"
COLOR_END = "|r"

function WUMPUS.OnLoad()
	SLASH_WUMPUS1 = "/WUMPUS"
	SlashCmdList["WUMPUS"] = function(msg) WUMPUS.Command(msg); end
	WUMPUS.InitGame()
end

function WUMPUS.InitGame()
	WUMPUS.map = {}
	WUMPUS.pits = {}
	WUMPUS.bats = {}
	WUMPUS.wumpus = nil
	WUMPUS.player = nil
	WUMPUS.arrows = 5

	WUMPUS.map[ 1] = { ["paths"] = { 2, 5, 8 } }
	WUMPUS.map[ 2] = { ["paths"] = { 1, 3,10 } }
	WUMPUS.map[ 3] = { ["paths"] = { 2, 4,12 } }
	WUMPUS.map[ 4] = { ["paths"] = { 3, 5,14 } }
	WUMPUS.map[ 5] = { ["paths"] = { 1, 4, 6 } }
	WUMPUS.map[ 6] = { ["paths"] = { 5, 7,15 } }
	WUMPUS.map[ 7] = { ["paths"] = { 6, 8,17 } }
	WUMPUS.map[ 8] = { ["paths"] = { 1, 7, 9 } }
	WUMPUS.map[ 9] = { ["paths"] = { 8,10,18 } }
	WUMPUS.map[10] = { ["paths"] = { 2, 9,11 } }
	WUMPUS.map[11] = { ["paths"] = {10,12,19 } }
	WUMPUS.map[12] = { ["paths"] = { 3,11,13 } }
	WUMPUS.map[13] = { ["paths"] = {12,14,20 } }
	WUMPUS.map[14] = { ["paths"] = { 4,13,15 } }
	WUMPUS.map[15] = { ["paths"] = { 6,14,16 } }
	WUMPUS.map[16] = { ["paths"] = {15,17,20 } }
	WUMPUS.map[17] = { ["paths"] = { 7,16,18 } }
	WUMPUS.map[18] = { ["paths"] = { 9,17,19 } }
	WUMPUS.map[19] = { ["paths"] = {11,18,20 } }
	WUMPUS.map[20] = { ["paths"] = {13,16,19 } }

	-- Place 2 pits
	local pits = 2
	while pits > 0 do
		roomNum = random(1,20)
		if not WUMPUS.pits[roomNum] then
			WUMPUS.pits[roomNum] = true
			pits = pits - 1
		end
	end

	-- Place 2 bats
	local bats = 2
	while bats > 0 do
		roomNum = random(1,20)
		if not WUMPUS.bats[roomNum] then
			WUMPUS.bats[roomNum] = true
			bats = bats - 1
		end
	end

	WUMPUS.wumpus = random(1,20)

	while not WUMPUS.player do
		roomNum = random(1,20)
		if not WUMPUS.pits[roomNum] and
		   not WUMPUS.bats[roomNum] and
		   WUMPUS.wumpus ~= roomNum then
			WUMPUS.player = roomNum
		end
	end
end

function WUMPUS.PrintRoom()
	-- smell a Wumpus, hear a bat, feel breeze from a pit
	local smell, feel, hear = "","",""
	for _,connectedroom in ipairs( WUMPUS.map[WUMPUS.player].paths ) do
		if WUMPUS.wumpus == connectedroom then
			smell = "\nYou can smell a Wumpus."
		end
		if WUMPUS.pits[connectedroom] then
			feel = "\nYou can feel a breeze from a pit."
		end
		if WUMPUS.bats[connectedroom] then
			hear = "\nYou can hear a bat."
		end
	end
	local rooms = WUMPUS.map[WUMPUS.player].paths
	print( string.format( "You are in room: %i, and have %i arrows.\nTunnels lead to rooms: %i, %i, and %i.%s%s%s",
		 WUMPUS.player, WUMPUS.arrows, rooms[1], rooms[2], rooms[3], smell, feel, hear) )
end
function WUMPUS.CanMove( currentRoom, targetRoom )
	for _, room in ipairs( WUMPUS.map[currentRoom].paths ) do
		if targetRoom == room then
			return true
		end
	end
end

function WUMPUS.Move( targetRoom )
	targetRoom = tonumber(targetRoom)
	local canMove = WUMPUS.CanMove( WUMPUS.player, targetRoom )
	if canMove then
		WUMPUS.player = targetRoom
		WUMPUS.TestRoom()
	else
		print( "That room is not connected to the current room." )
	end
end
function WUMPUS.TestRoom()
	if WUMPUS.pits[WUMPUS.player] then
		print( "You fell down a pit, to your death.\nGame Over.")
		WUMPUS.player = nil
		return
	end
	if WUMPUS.bats[WUMPUS.player] then
		print( "You found a bat. It drops you in a random room.")
		WUMPUS.player = random(1,20)
		return
	end
	if WUMPUS.player == WUMPUS.wumpus then
		WUMPUS.StartleWumpus()
	end
end
function WUMPUS.StartleWumpus()
	WUMPUS.wumpus = random(1,20)
	print( "You startled the Wumpus.")
	if WUMPUS.player == WUMPUS.wumpus then
		print( "The Wumpus has found and killed you.\nGame Over.")
		WUMPUS.player = nil
	end
end

function WUMPUS.Split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function WUMPUS.Shoot( roomList )
	if WUMPUS.arrows < 1 then
		print( "You are out of arrows." )
		return
	end
	print( "You shoot an arrow.")
	local rooms = WUMPUS.Split( roomList, "," )
	while #rooms > 5 do
		table.remove( rooms )
	end
	WUMPUS.arrow = WUMPUS.player  -- put the arrow in your room
	WUMPUS.arrows = WUMPUS.arrows - 1
	for _,room in ipairs( rooms ) do
		room = tonumber(room)
		local canMove = WUMPUS.CanMove( WUMPUS.arrow, room )
		--print( canMove and "true" or "false" )
		if canMove then
			WUMPUS.arrow = room
		else
			WUMPUS.arrow = WUMPUS.map[WUMPUS.arrow].paths[random(1,3)]
		end
		if WUMPUS.TestArrow() then
			return
		end
	end
	WUMPUS.StartleWumpus()
end

function WUMPUS.TestArrow()
	if WUMPUS.arrow == WUMPUS.wumpus then
		print( string.format("You hit the Wumpus in room %s. You win!", WUMPUS.wumpus ) )
		WUMPUS.wumpus = nil
		return 1
	end
	if WUMPUS.arrow == WUMPUS.player then
		print( "You hit yourself with the arrow. You lose.\nGame Over.")
		WUMPUS.player = nil
		return 1
	end
end

WUMPUS.commandList = {
	["help"] = {
		["func"] = WUMPUS.PrintHelp,
		["help"] = { "", "Print this help" },
	},
	["move"] = {
		["func"] = WUMPUS.Move,
		["help"] = { "<n>", "Move to room" },
	},
	["m"] = {
		["alias"] = "move",
	},
	["look"] = {
		["func"] = WUMPUS.PrintRoom,
		["help"] = { "", "Look around" },
	},
	["l"] = {
		["alias"] = "look",
	},
	["shoot"] = {
		["func"] = WUMPUS.Shoot,
		["help"] = { "n[,n,n,n,n]", "Shoot an arrow through rooms in given order." }
	},
	["s"] = {
		["alias"] = "shoot",
	}
}

function WUMPUS.PrintHelp()
	print()
	for cmd, info in pairs(WUMPUS.commandList) do
		if info.help then
			local cmdStr = cmd
			for c2, i2 in pairs(WUMPUS.commandList) do
				if i2.alias and i2.alias == cmd then
					cmdStr = string.format( "%s / %s", cmdStr, c2 )
				end
			end
			print(string.format("%s %s %s -> %s",
				SLASH_WUMPUS1, cmdStr, info.help[1], info.help[2]))
		end
	end
end

function WUMPUS.Command( msg )
	local cmd, param = WUMPUS.ParseCmd(msg)
	cmd = string.lower(cmd)
	if WUMPUS.commandList[cmd] and WUMPUS.commandList[cmd].alias then
		cmd = WUMPUS.commandList[cmd].alias
	end
	local cmdFunc = WUMPUS.commandList[cmd]
	if cmdFunc and cmdFunc.func then
		cmdFunc.func(param)
	else
		WUMPUS.PrintHelp()
	end
end

function WUMPUS.ParseCmd(msg)
	if msg then
		local a,b,c = strfind(msg, "(%S+)");  --contiguous string of non-space characters
		if a then
			return c, strsub(msg, b+2);
		else
			return "";
		end
	end
end

WUMPUS.OnLoad()