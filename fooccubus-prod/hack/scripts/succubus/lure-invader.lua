-- Cause siegers to stop loitering around their campfire and attack.
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end

-- Gets all the leaders
for k, unit in ipairs(df.global.world.units.all) do
	if unit.flags1.active_invader and not unit.flags1.caged and dfhack.units.isAlive(unit)  then
		unit.flags1.marauder = true
		unit.flags1.invades = true
		unit.flags1.incoming = true
		unit.flags1.hidden_ambusher = true
	end
end

dfhack.gui.showAnnouncement('Your enemies started moving towards your settlement.', COLOR_YELLOW)
