-- Will spawn an unit at one unit's position
--[[
	sample reaction
	[REACTION:SUMMONING_DOG]
	[NAME:Summon a dog]
	[BUILDING:SUMMONING_CIRCLE:NONE]
	[PRODUCT:100:1:BOULDER:NONE:INORGANIC:SMOKE_PURPLE]
	[SKILL:ALCHEMY]

	A product is needed. The creature will be friendly to your civ.

	Special cases :
	- LUA_HOOK_SUMMON_HFS: Will summon a demon, or any creature with the ID starting with DEMON.

	Optional parameters, those are added to the end of the reaction name, separated with spaces.
	- NUM_X: WIll spawn x creatures instead of one.

	Ex : [REACTION:SUMMONING_DOG NUM_4]

	Uses bits of hire-guards by Kurik Amudnil

	@author Boltgun
]]

local eventful = require 'plugins.eventful'
local utils = require 'utils'

local function starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

--http://lua-users.org/wiki/StringRecipes
local function wrap(str, limit)
	local limit = limit or 72
	local here = 1 ---#indent1
	return str:gsub("(%s+)()(%S+)()",
		function(sp, st, word, fi)
			if fi-here > limit then
				here = st
				return "\n"..word
			end
		end)
end

-- Simulate a canceled reaction message, save the reagents
local function cancelReaction(reaction, unit, input_reagents, message)
	local lines = utils.split_string(wrap(
			string.format("%s, %s cancels %s: %s.", dfhack.TranslateName(dfhack.units.getVisibleName(unit)), dfhack.units.getProfessionName(unit), reaction.name, message)
		) , NEWLINE)
	for _, v in ipairs(lines) do
		dfhack.gui.showAnnouncement(v, COLOR_RED)
	end

	for _, v in ipairs(input_reagents or {}) do
		v.flags.PRESERVE_REAGENT = true
	end

	--unit.job.current_job.flags.suspend = true
end

-- Summon a randomly generated demon. If there isn't any, cancels the reaction.
local function summonHfs(unit, num)
	local selection
	local key = 1
	local demonId = {}

	for id, raw in pairs(df.global.world.raws.creatures.all) do
		if starts(raw.creature_id, 'DEMON_') then
			demonId[key] = raw.creature_id
			key = key + 1
		end
	end

	if #demonId == 0 then
		--cancelReaction(reaction, unit, input_reagents, "no such creature on this world")
		--todo reimplement this
		dfhack.gui.showAnnouncement("No demons in this world", COLOR_RED)
		return
	end

	selection = math.random(1, #demonId)
	summonCreature(demonId[selection], unit, num)
end

-- Return the creature's raw data, there is probably a better way to select stuff from tables
local function getRaw(creature_id)
	local id, raw

	for id, raw in pairs(df.global.world.raws.creatures.all) do
		if raw.creature_id == creature_id then return raw end
	end

	qerror('Creature not found : '..creature_id)
end

-- Shows an announcement in the bottom of the screen
local function announcement(creatureId, num)
	local cr = getRaw(creatureId)
	local name = cr.name[0]
	local letter = string.sub(name, 0, 1)
	local article = 'a'

	if 
		letter == 'a' or 
		letter == 'e' or
		letter == 'i' or 
		letter == 'o' or
		letter == 'u' 
	then
		article = 'an'
	end

	if num == 1 then
		dfhack.gui.showAnnouncement('You have summonned '..article..' '..name..'.', COLOR_WHITE)
	else
		name = cr.name[1]
		dfhack.gui.showAnnouncement('You have summonned '..num..' '..name..'.', COLOR_WHITE)
	end
end

-- Spawns a regular creature at one unit position, caste is random
function summonCreature(unitId, unitSource, num)
	local su = dfhack.script_environment('spawn')

	for i = 1, num do
		su.place({
			race = unitId,
			position = {dfhack.units.getPosition(unitSource)}
		})
	end

	announcement(unitId, num)
end

-- Action

validArgs = validArgs or utils.invert({
    'help',
	'source',
    'race',
    'num',
})

local args = utils.processArgs({...}, validArgs)

if args.help then
	print([[scripts/succubus/summoning.lua
arguments
    -help
        print this help message
    -source <number>
    	The source unit's id.
    -race <RACE_ID>
        The raw id of the creature's race
    -num <number>
        The ammount of creatures to summon, defaults to 1
]])
	return
end

-- Args testing
if not args.source then
	qerror('No source unit provided for summoning!')
end

if not args.num then
	args.num = 1
end

if not args.race then
	qerror('No race provided for summoning!')
elseif 'HFS' === args.race then
	summonHfs(args.unit, args.num)
else
	summonCreature(args.race, args.unit, args.num)
end
