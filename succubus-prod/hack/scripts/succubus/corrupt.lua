-- Sets the units within line of sight of the unit as non hostiles, members of your civ and transform them
--[[
	This script is called by the conversion dens.
	It will perform makeown on the target unit and perform some more fix to prevent loyalty cascades.
	It will also remove flags related to invasions.
	These units should be ready to act as citizens, if they are of the same race of your fort.

	@author Boltgun
]]
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local mo = require 'makeown'
local utils = require 'utils'

local unit, targetRace
local creatureSet = {}
local args = {...}

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
function corrupt(unit)
	local targetRace = df.global.world.raws.creatures.all[df.global.ui.race_id].creature_id
	local origRace = df.global.world.raws.creatures.all[unit.race_id].creature_id
	local suffix, targetCaste
	
	if not creatureSet[origRace] then
		return
	end

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

	clearEnemy(unit)

	-- After taking the enemy to your side, transform it
	if targetRace != origRace then
		if unit.gender = 'male' then
			suffix = "_MALE"
		else
			suffix = "_FEMALE"
		end

		targetCaste = creatureSet[origRace]..suffix

		dfhack.run_script('modtools/transform-unit', {unit=unitTarget.id, race=targetRace, caste=targetCaste, keepinventory=1})
	end
end

-- Action
unit = df.unit.find(tonumber(args[1]))
if not unit then qerror('Unit not found.') end

-- Return the set of affected units, syntax is ['ORIGINAL_RACE'] = 'TARGET_CASTE' without MALE or FEMALE
-- If the creature is not heren it will be unaffected by the script
if args[2] == 'succubus' then
	creatureSet = {
		['SUCCUBUS'] = true, -- tranformation will be skipped
		['WARLOCK_CIV'] = 'DEVIL',
		['HUMAN'] = 'DEVIL',
		['DWARF'] = 'FIEND',
		['ELF'] = 'CAMBION',
		['GNOME_CIV'] = 'PUCK',
		['KOBOLD'] = 'IMP',
		['GOBLIN'] = 'HELLION',
		['ORC_TAIGA'] = 'ONI',
		-- FD
		['FROG_MANFD'] = 'DEVIL',
		['IMP_FIRE_FD'] = 'IMP',
		['BLENDECFD'] = 'DEVIL',
		['WEREWOLFFD'] = 'DEVIL',
		['SERPENT_MANFD'] = 'CAMBION',
		['TIGERMAN_WHITE_FD'] = 'CAMBION',
		['BEAK_WOLF_FD'] = 'HELLION',
		['ELF_FERRIC_FD'] = 'CAMBION',
		['ELEPHANTFD'] = 'ONI',
		['STRANGLERFD'] = 'HELLION',
		['JOTUNFD'] = 'ONI',
		['MINOTAURFD'] = 'ONI',
		['SPIDER_FIEND_FD'] = 'DEVIL',
		['NIGHTWINGFD'] = 'IMP',
		['GREAT_BADGER_FD'] = 'IMP',
		['PANDASHI_FD'] = 'FIEND',
		['RAPTOR_MAN_FD'] = 'DEVIL'
	}
end

findLos(unit)
