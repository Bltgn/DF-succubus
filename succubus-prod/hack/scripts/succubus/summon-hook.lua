-- Will spawn an unit for each run of LUA_HOOK_SUMMON_<ID> reaction
--[[
	sample reaction
	[REACTION:LUA_HOOK_SUMMON_DOG]
	[NAME:Summon a dog]
	[BUILDING:SUMMONING_CIRCLE:NONE]
	[PRODUCT:100:1:BOULDER:NONE:INORGANIC:SMOKE_PURPLE]
	[SKILL:ALCHEMY]

	A product is needed. The creature will be friendly to your civ.

	Special cases :
	- LUA_HOOK_SUMMON_HFS: Will summon a clown, of any creature with the ID starting with DEMON.

	Optional parameters, those are added to the end of the reaction name, separated with spaces.
	- TAME: The creature will be fully tamed, non tamed creatures are not hostile but will require extra work to be trained.
	- NUM_X: WIll spawn x creatures instead of one.

	Ex : [REACTION:LUA_HOOK_SUMMON_DOG TAME NUM_4]

	Uses bits of hire-guards by Kurik Amudnil

	@author Boltgun
]]

local eventful = require 'plugins.eventful'
local utils = require 'utils'
local spawnunit = require 'spawnunit'

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

-- Summon a randomly generated clown. If there isn't any, cancels the reaction.
local function summonHfs(reaction, unit, input_reagents)
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
		cancelReaction(reaction, unit, input_reagents, "no such creature on this world")
		return nil
	end

	selection = math.random(1, #demonId)
	summonCreature(demonId[selection], unit)
	dfhack.run_script('succubus/fovunsentient', unit.id, demonId[selection])
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

	dfhack.gui.showAnnouncement('You have summonned '..article..' '..name..'.', COLOR_YELLOW)
end

-- Spawns a regular creature at one unit position, caste is random
local function summonCreature(unitId, unitSource)
	local codeArray = utils.split_string(unitId, ' ')
	local tame
	local units, code, unitPos
	local position = {}

	for _, code in ipairs(codeArray or {}) do
		if code == 'TAME' then
			tame = true
		elseif starts(code, 'NUM_') then
			spawnunit.ammount = tonumber(string.sub(code, 5))
		else
			unitId = code
		end
	end

	-- Spawning
	spawnunit.race = tostring(unitId)
	spawnunit.setPos({dfhack.units.getPosition(unitSource)})
	units = spawnunit.place()

	-- Post spawning processes
	--if tame then
	--[[	for _, unit in ipairs(units) do
			unit.flags2.resident = true
			unit.cultural_identity = unitSource.cultural_identity
			unit.population_id = unitSource.population_id

			unit.flags1.tame = true
			unit.training_level = df.animal_training_level.Domesticated
		end
	--end]]

	announcement(unitId)
end

-- Attaches the hook to eventful
eventful.onReactionComplete.succubusSummon = function(reaction, unit, input_items, input_reagents, output_items, call_native)
	local creatureId

	if reaction.code == 'LUA_HOOK_SUMMON_HFS' then
		summonHfs(reaction, unit, input_reagents)
	elseif starts(reaction.code, 'LUA_HOOK_SUMMON_') then
		summonCreature(string.sub(reaction.code, 17), unit)
	else
		return nil
	end
end

print("Summon hook activated")
