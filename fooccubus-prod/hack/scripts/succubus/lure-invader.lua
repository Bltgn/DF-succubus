-- Cause siegers to stop loitering around their campfire and attack.
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

-- Gets all the leaders
for k, unit in ipairs(df.global.world.units.all) do
	if unit.flags1.active_invader and unit.relations.group_leader_id == -1 then	
		unit.flags1.invades = true
	end
end

dfhack.gui.showAnnouncement('Your enemies started moving towards your settlement.', COLOR_YELLOW)
