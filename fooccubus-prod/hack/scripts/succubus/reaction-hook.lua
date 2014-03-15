-- Captures custom reactions and make the appropriate dfhack calls.

local eventful = require 'plugins.eventful'
-- Succubus Dungeons : Reaction hooks

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
			dfhack.gui.showAnnouncement("The succubi queen found you!", COLOR_LIGHTRED, true)
		end
	end
end

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
	end
end