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
	- LUA_HOOK_SUMMON_HFS: Will summon a clown, or any creature with the ID starting with DEMON.

	Optional parameters, those are added to the end of the reaction name, separated with spaces.
	- NUM_X: WIll spawn x creatures instead of one.

	Ex : [REACTION:LUA_HOOK_SUMMON_DOG NUM_4]

	Uses bits of hire-guards by Kurik Amudnil

	@author Boltgun
	@todo Remove the LUA_HOOK prefix as designed in dfhack 40.24 r2
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
function summonCreature(unitId, unitSource)
	local codeArray = utils.split_string(unitId, ' ')
	local num = 1
	local _, code
	local unitpos = {dfhack.units.getPosition(unitSource)}

	for _, code in ipairs(codeArray or {}) do
		if starts(code, 'NUM_') then
			num = tonumber(string.sub(code, 5))
		else
			unitId = code
		end
	end

	-- Spawning
	local su = dfhack.script_environment('spawn')

	for i = 1, num do
		su.place({
			race = unitId,
			position = unitpos
		})
	end

	announcement(unitId, num)
end

-- Attaches the hook to eventful
eventful.onReactionComplete.succubusSummon = function(reaction, unit, input_items, input_reagents, output_items, call_native)
	local creatureId

	if reaction.code == 'LUA_HOOK_SUMMON_HFS' then
		summonHfs(reaction, unit, input_reagents)
	elseif starts(reaction.code, 'LUA_HOOK_SUMMON_') then
		summonCreature(string.sub(reaction.code, 17), unit)
	end
end

print("Summon hook activated")
