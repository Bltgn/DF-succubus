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

local fov = require 'fov'
local mo = require 'makeown'
local utils = require 'utils'

local args = {...}

local unitSource, targetRace, creatureSet
local range = 10
local debug = false

-- Check boundaries and field of view
local function validateCoords(unit, view)
	local pos = {dfhack.units.getPosition(unit)}

	if pos[1] < view.xmin or pos[1] > view.xmax then
		return false
	end

	if pos[2] < view.ymin or pos[2] > view.ymax then
		return false
	end

	return view.z == pos[3] and view[pos[2]][pos[1]] > 0
end

-- Check if the unit is seen and belong to the set
local function isSelected(unit, view)
	local creatureId = tostring(df.global.world.raws.creatures.all[unit.race].creature_id)

	if nil ~= creatureSet[creatureId] and
		not dfhack.units.isDead(unit) and
		not dfhack.units.isOpposedToLife(unit) then
			return validateCoords(unit, view)
	end

	return false
end

-- Find targets within the LOS of the creature
local function findLos(unitSource)
	local view = fov.get_fov(range, unitSource.pos)
	local i, hf, k, v
	local unitList = df.global.world.units.active

	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		unitTarget = unitList[i]
		if isSelected(unitTarget, view) then
			corrupt(unitTarget)
		end
	end
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
			if debug then print('deleted enemy link') end
		end
	end

	-- Make DF forget about the calculated enemies (ported from fix/loyaltycascade)
	if not (unit.enemy.enemy_status_slot == -1) then
		i = unit.enemy.enemy_status_slot
		unit.enemy.enemy_status_slot = -1
		if debug then print('enemy cache removed') end
	end
end

-- Find targets within the LOS of the creature
function corrupt(unit)
	local origRace = tostring(df.global.world.raws.creatures.all[unit.race].creature_id)
	local suffix, targetCaste

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
	if debug then print('origRace: '..origRace..', targetRace: '..targetRace) end

	if targetRace == origRace then return end

	targetCaste = creatureSet[origRace]
	if nil ~= targetCaste then
		if unit.sex == 1 then
			suffix = "_MALE"
		else
			suffix = "_FEMALE"
		end

		targetCaste = targetCaste..suffix
		if debug then print('selected caste: '..targetCaste) end

		dfhack.run_script('modtools/transform-unit', '-unit', unit.id, '-race', targetRace, '-caste', targetCaste, '-keepInventory', 1)
	end
end

-- Action
unitSource = df.unit.find(tonumber(args[1]))
if not unitSource then qerror('Unit not found.') end

-- Return the set of affected units, syntax is ['ORIGINAL_RACE'] = 'TARGET_CASTE' without MALE or FEMALE
-- This is optional, if the affected creature isn't listen, no tranformation occurs
if args[2] == 'succubus' then
	creatureSet = {
		WARLOCK_CIV = 'DEVIL',
		HUMAN = 'DEVIL',
		DWARF = 'FIEND',
		ELF = 'CAMBION',
		GNOME_CIV = 'PUCK',
		KOBOLD = 'IMP',
		GOBLIN = 'HELLION',
		ORC_TAIGA = 'ONI',
		-- FD
		FROG_MANFD = 'DEVIL',
		IMP_FIRE_FD = 'IMP',
		BLENDECFD = 'DEVIL',
		WEREWOLFFD = 'DEVIL',
		SERPENT_MANFD = 'CAMBION',
		TIGERMAN_WHITE_FD = 'CAMBION',
		BEAK_WOLF_FD = 'HELLION',
		ELF_FERRIC_FD = 'CAMBION',
		ELEPHANTFD = 'ONI',
		STRANGLERFD = 'HELLION',
		JOTUNFD = 'ONI',
		MINOTAURFD = 'ONI',
		SPIDER_FIEND_FD = 'DEVIL',
		NIGHTWINGFD = 'IMP',
		GREAT_BADGER_FD = 'IMP',
		PANDASHI_FD = 'FIEND',
		RAPTOR_MAN_FD = 'DEVIL'
	}
end

targetRace = df.global.world.raws.creatures.all[df.global.ui.race_id].creature_id
findLos(unitSource)
