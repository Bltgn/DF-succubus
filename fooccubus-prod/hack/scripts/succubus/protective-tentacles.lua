-- Add an aoe buff to all tentacle monsters on the map

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end

for k, unit in ipairs(df.global.world.units.all) do
	unitRaw = df.global.world.raws.creatures.all[unit.race]
	if unitRaw.creature_id == 'TENTACLE_MONSTER' then
		dfhack.run_script('addsyndrome', 'PROTECTIVE_TENTACLES', unit.id)
	end
end

dfhack.gui.showAnnouncement('Tentacle monsters start spreading to defend your succubi.', COLOR_YELLOW)
