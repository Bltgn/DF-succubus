-- Captures custom reactions and make the appropriate dfhack calls.

local eventful = require 'plugins.eventful'

eventful.onReactionComplete.fooccubusSummon = function(reaction, unit, input_items, input_reagents, output_items, call_native)

	if reaction.code == 'LUA_HOOK_FOOCCUBUS_RAIN_FIRE' then
		-- Firejets outside
		dfhack.run_script('syndromeweather', firebeath, 100, 20, 5)
		dfhack.gui.showAnnouncement('The sky darkens and fireballs strikes the earth.', COLOR_YELLOW)
	end

end