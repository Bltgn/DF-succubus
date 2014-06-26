-- Sets the units within line of sight of the unit as non hostiles and members of your civ.
--[[

	This script is called by the conversion dens.
	It will perform makeown on the visible units and add a makecitizen for good measure.
	It will also remove flags related to invasions.
	These units should be ready to act as citizens, if they are of the same race of your fort.

	@author Boltgun

]]
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local fov = require 'fov'
local mo = require 'makeown'
local utils = require 'utils'

local unit, creatureSet
local args = {...}

-- Check if the unit is seen and valid
function isSelected(unit, view)
	local creatureId = df.global.world.raws.creatures.all[unit.race].creature_id

	if creatureSet[creatureId] and
		not dfhack.units.isDead(unit) and
		not dfhack.units.isOpposedToLife(unit) then
			return validateCoords(unit, view)
	end

	return false
end

-- Check boundaries and field of view
function validateCoords(unit, view)
	local pos = {dfhack.units.getPosition(unit)}

	if pos[1] < view.xmin or pos[1] > view.xmax then
		return false
	end

	if pos[2] < view.ymin or pos[2] > view.ymax then
		return false
	end

	return view.z == pos[3] and view[pos[2]][pos[1]] > 0

end

-- Erase the enemy links
function clearEnemy(unit)
	hf = utils.binsearch(df.global.world.history.figures, unit.hist_figure_id, 'id')
	for k, v in ipairs(hf.entity_links) do
		if df.histfig_entity_link_enemyst:is_instance(v) and
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
end

-- Find targets within the LOS of the creature
function findLos(unitSource)
	local view = fov.get_fov(10, unitSource.pos)
	local i, hf, k, v
	local unitList = df.global.world.units.active

	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		unitTarget = unitList[i]
		if isSelected(unitTarget, view) then
			mo.make_own(unitTarget)
			mo.make_citizen(unitTarget)

			-- Taking down all the hostility flags
			unitTarget.flags1.marauder = false
			unitTarget.flags1.active_invader = false
			unitTarget.flags1.hidden_in_ambush = false
			unitTarget.flags1.hidden_ambusher = false
			unitTarget.flags1.invades = false
			unitTarget.flags1.coward = false
			unitTarget.flags1.invader_origin = false
			unitTarget.flags2.underworld = false
			unitTarget.flags2.visitor_uninvited = false
			unitTarget.invasion_id = -1
			unit.relations.group_leader_id = -1
			unit.relations.last_attacker_id = -1

			clearEnemy(unitTarget)
		end
	end
end

-- Action
unit = df.unit.find(tonumber(args[1]))
if not unit then qerror('Unit not found.') end

-- Return the set of affected units
if not args[2] then qerror('Please enter a creature set.') end
if args[2] == 'succubus' then
	creatureSet = {
		['ANTMAN'] = true,
		['BLIND_CAVE_OGRE'] = true,
		['BANSHEE'] = true,
		['FROST_GIANT'] = true,
		['WARLOCK_CIV'] = true,
		['DWARF'] = true,
		['ELF'] = true,
		['GNOME_CIV'] = true,
		['HUMAN'] = true,
		['CENTAUR_FF'] = true,
		['KOBOLD_CAMP'] = true,
		['NAGA'] = true,
		['WEREWOLF'] = true,
		['DROW'] = true,
		['GOBLIN'] = true,
		['ORC_TAIGA'] = true,
		['FROG_MANFD'] = true,
		['IMP_FIRE_FD'] = true,
		['BLENDECFD'] = true,
		['WEREWOLFFD'] = true,
		['SERPENT_MANFD'] = true,
		['TIGERMAN_WHITE_FD'] = true,
		['BEAK_WOLF_FD'] = true,
		['ELF_FERRIC_FD'] = true,
		['ELEPHANTFD'] = true,
		['STRANGLERFD'] = true,
		['JOTUNFD'] = true,
		['MINOTAURFD'] = true,
		['SPIDER_FIEND_FD'] = true,
		['NIGHTWINGFD'] = true,
		['GREAT_BADGER_FD'] = true,
		['PANDASHI_FD'] = true,
		['RAPTOR_MAN_FD'] = true
	}
elseif args[2] == 'minotaur' then
	creatureSet = {['MINOTAUR'] = true}
else
	qerror('Unsupported creature set.')
end

findLos(unit)
