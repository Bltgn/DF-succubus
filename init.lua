-- Succubus fortress
-- This file will run fixes and tweaks when you load your saves

-- Make sure that commands are only run if you play as a succubus
function isFooccubus()

	for k, entity in pairs(df.global.world.entities.all) do
		if entity.id == df.global.ui.civ_id then
			return entity.entity_raw.code == 'CULT' or entity.entity_raw.code == 'DECADENCE'
		end
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