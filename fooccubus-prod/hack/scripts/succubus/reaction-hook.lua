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

		if domain == 'deep' then
			civ = 'DECADENCE'
		else
			civ = 'CULTS'
		end

		dfhack.run_script('force', 'siege', civ)

		if domain == 'pride' then
			dfhack.gui.showAnnouncement("Your pride has attracted some unwanted attention!", COLOR_LIGHTRED, true)
		elseif domain == 'greed' then
			dfhack.gui.showAnnouncement("Your greed has attracted some unwanted attention!", COLOR_LIGHTRED, true)
		elseif domain == 'deep' then
			dfhack.gui.showAnnouncement("The succubi queen has found your temple!", COLOR_LIGHTRED, true)
		end
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

end

-- Manages effects targeting invaders
local function invadersEffect(code, reaction, unit, input_reagents)
	if hasInvader == false then
		cancelReaction(reaction, unit, input_reagents, "no invaders in the area")
		return nil
	end

	if code == 'SOW_DISCORD' then
		dfhack.run_script('succubus/crazed-invader', unit.id, 'DECADENCE')
	end
end

-- Reaction hook
eventful.onReactionComplete.fooccubusSummon = function(reaction, unit, input_items, input_reagents, output_items, call_native)
	if reaction.code == 'LUA_HOOK_FOOCCUBUS_RAIN_FIRE' then
		-- Firejets outside
		dfhack.run_script('syndromeweather', firebeath, 100, 20, 5)
		dfhack.gui.showAnnouncement('The sky darkens and fireballs strikes the earth.', COLOR_YELLOW)
	else if reaction.code == 'LUA_HOOK_FORGET_DEATH' then
		-- Forget death
		dfhack.run_script('succubus/forget-death', unit.id)
		dfhack.run_script('succubus/influence', unit.id, 'pride')
		paybackSiege(10, 'pride')
	else if raction.code == 'LUA_HOOK_PROTECTIVE_TENTACLES' then
		-- Tentacle summon buff
		slothCreature('TENTACLE_MONSTER', reaction, unit, input_reagents)
		dfhack.run_script('succubus/influence', unit.id, 'sloth')
	else if reaction.code == 'LUA_HOOK_SOW_DISCORD'  then
		-- Render invaders crazed
		invadersEffect('SOW_DISCORD', reaction, unit, input_reagents)
	end
end