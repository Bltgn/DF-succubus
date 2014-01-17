-- Succubus fortress
-- This file will run fixes and tweaks when you load your saves

-- Make sure that commands are only run if you play as a succubus
function isFooccubus()

	for k, entity in pairs(df.global.world.raws.entities) do
		if entity.code == 'CULT' or entity.code == 'DECADENCE' then return true end
	end

	return false

end

function onStateChange(sc)

	if sc == SC_MAP_LOADED then

		print('Map loaded')
		if isFooccubus() then
			dfhack.run_script('fixnakedregular')
		end

	end

end