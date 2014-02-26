-- Verify that there rendomly generated -clowns-. Pick one of them at random and pass it to the summoning script.
--[[
	sample reaction
	[REACTION:LUA_HOOK_SUMMON_HFS]
	[NAME:Summon an underworld demon]
	[BUILDING:SUMMONING_CIRCLE:NONE]
	regeants...
	[PRODUCT:100:3:BOULDER:NONE:INORGANIC:EERIE_SMOKE]
	[SKILL:ALCHEMY]

	Product is optional, here we create 3 boiling stones for XP.

	Note : If there is user defined creatures with raw IDs starting with DEMON_, those will be included in the set.

	Requires other scripts : succubus/summoning and lua librairies

	Uses bits of hire-guards by Kurik Amudnil

	@todo name the sentient demons
	@author Boltgun
]]

local eventful = require 'plugins.eventful'
local utils = require 'utils'

local function starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

--http://lua-users.org/wiki/StringRecipes  (removed indents since I am not using them)
function wrap(str, limit)--, indent, indent1)
	--indent = indent or ""
	--indent1 = indent1 or indent
	local limit = limit or 72
	local here = 1 ---#indent1
	return str:gsub("(%s+)()(%S+)()",	--indent1..str:gsub(
							function(sp, st, word, fi)
								if fi-here > limit then
									here = st -- - #indent
									return "\n"..word --..indent..word
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

local function summonHfs(reaction, unit, input_items, input_reagents, output_items, call_native)
	local selection
	local key = 1
	local demonId = {}

	for id, raw in pairs(df.global.world.raws.creatures.all) do
		if starts(raw.creature_id, 'DEMON_') then
			demonId[key] = raw.creature_id
			key = key + 1
		end
	end

	-- No demon to summon
	if #demonId == 0 then
		cancelReaction(reaction, unit, input_reagents, "no such creature on this world")
		return nil
	end

	selection = math.random(1, #demonId)
	dfhack.run_script('succubus/summoning', unit.id, demonId[selection], 1)

end

eventful.onReactionComplete.fooccubusSummon = function(reaction, unit, input_items, input_reagents, output_items, call_native)

	local creatureId
	local tame = 0

	if reaction.code == 'LUA_HOOK_SUMMON_HFS' then
		summonHfs(reaction, unit, input_items, input_reagents, output_items, call_native)
	elseif reaction.code:find('_SUMMON_') then
		creatureId = string.sub(reaction.code, 17)

		if creatureId == 'NAHASH' or creatureId == 'SOUL_WISP' or creatureId == 'RAT_THING' then
			tame = 1
		end

		dfhack.run_script('succubus/summoning', unit.id, creatureId, tame)
	else
		return nil
	end

end