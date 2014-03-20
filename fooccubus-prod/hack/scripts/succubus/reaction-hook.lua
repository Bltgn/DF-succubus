-- Captures custom reactions and make the appropriate dfhack calls.

local eventful = require 'plugins.eventful'

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

-- Chances of siege from the deep succubi
local function paybackSiege(chance, domain)
	if math.random(0, 100) <= chance then
		dfhack.run_script('force', 'siege', 'CULTS')

		if domain == 'pride' then
			dfhack.gui.showAnnouncement("Your pride has attracted some unwanted attention!", COLOR_LIGHTRED, true)
		elseif domain == 'greed' then
			dfhack.gui.showAnnouncement("Your greed has attracted some unwanted attention!", COLOR_LIGHTRED, true)
	end
end

-- Search the site for a creature
local function hasCreature(creatureId)
	local unitRaw
	for k, unit in ipairs(df.global.world.units.all) do
		unitRaw = df.global.world.raws.creatures.all[fnUnit.race]
		if unitRaw.creature_id == creatureId then return true end
	end

	return false
end
-- Make sure that we have the right creature on the site, add the effect
local function slothCreature(creatureId, reaction, unit, input_reagents)
	if hasCreature(creatureId) == false then
		cancelReaction(reaction, unit, input_reagents, "no creature in the area")
		return nil
	end

	if creatureId == 'TENTACLE_MONSTER' then
		dfhack.run_script('succubus/protective-tentacles', unit.id)
	end
end

-- Search the site for an invader
local function hasInvader()
	for k, unit in ipairs(df.global.world.units.all) do
		if unit.flags1.active_invader then return true end
	end
	return false
end

-- Manages effects targeting invaders
local function invadersEffect(code, reaction, unit, input_reagents)
	if hasInvader == false then
		cancelReaction(reaction, unit, input_reagents, "no invaders in the area")
		return nil
	end

	if code == 'SOW_DISCORD' then
		dfhack.run_script('succubus/crazed-invader', unit.id, 'DECADENCE')
	elseif code == 'LURE_INVADERS' then
		dfhack.run_script('succubus/lure-invader')
	elseif code == 'DIMENSION_PULL' then
		dfhack.run_script('succubus/dimension-pull') -- todo catch the reagent's value
	end
end

-- Add a random skill from a defined set
local function addSkill(set, unit)

	local skillSet, roll

	if(set == 'BROKER') then
		dfhack.run_script('trainskill', unit.id, 'APPRAISAL', 15)
		skillSet = {'LIAR', 'FLATTERY', 'RECORD_KEEPING'}
	if(set == 'CRAFTER') then
		skillSet = {'WOODCRAFT', 'STONECRAFT', 'METALCRAFT', 'GLASSMAKER', 'LEATHERWORK'}
	if(set == 'FARMER') then
		skillSet = {'PLANT', 'COOK', 'BREWING'}
	if(set == 'SOLDIER') then
		skillSet = {'SIEGEOPERATE', 'DODGING', 'ARMOR', 'MELEE_COMBAT', 'RANGED_COMBAT'}
	end

	roll = math.random(1, #skillSet)
	dfhack.run_script('trainskill', unit.id, skillSet[roll], 15)

end

-- Reaction hook
eventful.onReactionComplete.fooccubusSummon = function(reaction, unit, input_items, input_reagents, output_items, call_native)
	-- site effects
	if reaction.code == 'LUA_HOOK_FOOCCUBUS_RAIN_FIRE' then
		dfhack.run_script('syndromeweather', firebeath, 100, 20, 5)
		dfhack.gui.showAnnouncement('The sky darkens and fireballs strikes the earth.', COLOR_YELLOW)

	-- citizen effects
	elseif reaction.code == 'LUA_HOOK_FORGET_DEATH' then
		dfhack.run_script('succubus/forget-death', unit.id)
		dfhack.run_script('succubus/influence', unit.id, 'pride')
		paybackSiege(10, 'pride')

	-- pet effects
	elseif raction.code == 'LUA_HOOK_PROTECTIVE_TENTACLES' then
		slothCreature('TENTACLE_MONSTER', reaction, unit, input_reagents)
		dfhack.run_script('succubus/influence', unit.id, 'sloth')

	-- invader effects
	elseif reaction.code == 'LUA_HOOK_SOW_DISCORD' then invadersEffect('SOW_DISCORD', reaction, unit, input_reagents)
	elseif reaction.code == 'LUA_HOOK_LURE_INVADERS' then invadersEffect('LURE_INVADERS', reaction, unit, input_reagents)
	elseif reaction.code == 'LUA_HOOK_DIMENSION_PULL' then invadersEffect('DIMENSION_PULL', reaction, unit, input_reagents)

	-- Skill trainers
	elseif reaction.code == 'LUA_HOOK_NIGHTMARE_BROKER' then addSkill('BROKER', unit)
	elseif reaction.code == 'LUA_HOOK_NIGHTMARE_CRAFTER' then addSkill('CRAFTER', unit)
	elseif reaction.code == 'LUA_HOOK_NIGHTMARE_FARMER' then addSkill('FARMER', unit)
	elseif reaction.code == 'LUA_HOOK_NIGHTMARE_SOLDIER' then addSkill('SOLDIER', unit)
	-- Misc
	elseif reaction.code == 'LUA_HOOK_CALL_SIEGE' then dfhack.run_script('fooccubus/callsiege', 100)
	elseif reaction.code == 'LUA_HOOK_CALL_BEAST' then dfhack.run_script('force', 'megabeast')
	elseif reaction.code == 'LUA_HOOK_WEATHER_RAIN' then dfhack.run_script('weather', 'rain')
	end
end