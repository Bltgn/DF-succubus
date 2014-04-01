-- Remove the invader marks from an unit at the cost of a weird entity description
local unit = dfhack.gui.getSelectedUnit()
if not unit then qerror("No unit selected") end

local mo = require 'makeown'
local utils = require 'utils'

mo.make_own(unit)
mo.make_citizen(unit)
-- Taking down all the hostility flags
unit.flags1.marauder = false
unit.flags1.active_invader = false
unit.flags1.hidden_in_ambush = false
unit.flags1.hidden_ambusher = false
unit.flags1.invades = false
unit.flags1.coward = false
unit.flags1.invader_origin = false
unit.flags2.underworld = false
unit.flags2.visitor_uninvited = false
unit.invasion_id = -1
unit.relations.group_leader_id = -1
unit.relations.last_attacker_id = -1
print('removed invasion flags')

-- Replace the enemy links with "former prisoner"
hf = utils.binsearch(df.global.world.history.figures, unit.hist_figure_id, 'id')
for k, v in ipairs(hf.entity_links) do
	if 
		df.histfig_entity_link_enemyst:is_instance(v) and 
		(v.entity_id == df.global.ui.civ_id or v.entity_id == df.global.ui.group_id) 
	then
		newLink = df.histfig_entity_link_former_prisonerst:new()
		newLink.entity_id = v.entity_id
		newLink.link_strength = v.link_strength
		hf.entity_links[k] = newLink
		v:delete()
		print('deleted enemy link')

		
	end
end

-- Make DF forget about the calculated enemies (ported from fix/loyaltycascade)
if not (unit.enemy.enemy_status_slot == -1) then
	i = unit.enemy.enemy_status_slot
	unit.enemy.enemy_status_slot = -1
	print('enemy cache removed')
end
