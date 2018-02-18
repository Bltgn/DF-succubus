-- Will spawn the desired unit at another's position and make an announcement about it.
--[[
	scripts/succubus/summoning.lua
	arguments
    -help
        print this help message
    -source <number>
    	The source unit's id.
    -race <RACE_ID>
        The raw id of the creature's race

	Uses bits of hire-guards by Kurik Amudnil

	@author Boltgun
	@todo Reaction canceling if ther eis no demon generated
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

-- Simulates a canceled reaction message
local function cancelReaction(reaction, unit, message)
	local lines = utils.split_string(wrap(
			string.format("%s, %s cancels %s: %s.", dfhack.TranslateName(dfhack.units.getVisibleName(unit)), dfhack.units.getProfessionName(unit), reaction, message)
		) , NEWLINE)
	for _, v in ipairs(lines) do
		dfhack.gui.showAnnouncement(v, COLOR_RED)
	end

	-- @todo reimplement this if possible
	--[[for _, v in ipairs(input_reagents or {}) do
		v.flags.PRESERVE_REAGENT = true
	end]]

	--unit.job.current_job.flags.suspend = true
end

-- Summon a randomly generated demon. If there isn't any, cancels the reaction.
local function summonHfs(unit)
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
		cancelReaction(reaction, unit, "no such creature on this world")
		return
	end

	selection = math.random(1, #demonId)
	summonCreature(demonId[selection], unit)
end

-- Return the creature's raw data, there is probably a better way to select stuff from tables
local function getRaw(creature_id)
	local id, raw

	for id, raw in pairs(df.global.world.raws.creatures.all) do
		if raw.creature_id == creature_id then return raw end
	end

	qerror('Creature not found: '..creature_id)
end

-- Shows an announcement in the bottom of the screen
local function announcement(creatureId)
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

	dfhack.gui.showAnnouncement('You have summoned '..article..' '..name..'.', COLOR_WHITE)
end

function findRace(raceRawId)
  --find race
  for i,v in ipairs(df.global.world.raws.creatures.all) do
    if v.creature_id == raceRawId then
      return i
    end
  end

  return nil
end

-- Spawns a regular creature at one unit position, caste is random
function summonCreature(unitId, unitSource)
	local createUnit = dfhack.script_environment("modtools/create-unit")
	local raceIndex = findRace(unitId)
	local newUnitIndex

	-- Moving the spawn a little further south
	local location = {dfhack.units.getPosition(unitSource)}
	location[2] = location[2] + 2

	--Validation
	if not raceIndex then
		qerror("Summoning: Unknown race")
	end

	newUnitIndex = createUnit.createUnitInFortCivAndGroup(raceIndex, createUnit.getRandomCasteId(raceIndex), location)
	createUnit.domesticate(newUnitIndex, df.global.ui.group_id)
	createUnit.nameUnit(newUnitIndex, df.historical_entity.find(df.global.ui.civ_id).entity_raw.code, df.global.ui.civ_id)

	announcement(unitId)
end

-- Action
validArgs = validArgs or utils.invert({
    'help',
	'source',
    'race'
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
]])
	return
end

-- Args testing
if not args.source then
	qerror('No source unit provided for summoning!')
end

local unitSource = df.unit.find(tonumber(args.source))
if not unitSource then qerror('Unit not found.') end

if not args.race then
	qerror('No race provided for summoning!')
elseif 'HFS' == args.race then
	summonHfs(unitSource)
else
	summonCreature(args.race, unitSource)
end
