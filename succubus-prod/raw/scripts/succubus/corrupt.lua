-- Sets the units within line of sight of the unit as non hostiles, members of your civ and transform them
--[[
	This script is called by the conversion dens.
	It will perform makeown on the target unit and perform some more fix to prevent loyalty cascades.
	It will also remove flags related to invasions and mounting.
	Merchants will give up trading and their dragged animals join as well, their wagons will be scuttled.
	The targets will be let out of their cages

	These units should be ready to act as citizen once transformed.

	If you wish to implement this feature to your race, add a creature to caste set at the end of the file.

	arguments
	    -help
	        print this help message
	    -unit <number>
	        The unit at the source of the corruption
	    -set <string>
	        One of the available creature sets, currently only succubus

	@requires fov
	@author Boltgun
]]
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end

-- Dependancies
local fov = dfhack.script_environment('modtools/fov')
local mo = require 'makeown'
local utils = require 'utils'

-- The range of the check FOV
local range = 10

-- Will print debug messages if set to true
local debug = true

-- Announcement
local announceMerchant = false

-- Misc
local unitSource, targetRace, creatureSet

--
-- Functions
--

-- Announcement a hint if you corrupted a merchant
local function marchantAnnouncement()
	if not announceMerchant then return end
	dfhack.timeout(
		3,
		'ticks',
		function() 
			dfhack.gui.showAnnouncement("Deconstruct the trade depot to seize the merchants goods.", COLOR_WHITE) 
		end
	)
end

-- Check boundaries and field of view, z level must be the same
local function validateCoords(unit, view)
	local pos = {dfhack.units.getPosition(unit)}

	if 
		pos[1] < view.xmin or pos[1] > view.xmax or
		pos[2] < view.ymin or pos[2] > view.ymax or
		view.z ~= pos[3]
	then
		return false
	end

	return view[pos[2]][pos[1]] > 0
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

	-- Post process
	marchantAnnouncement()
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

-- Clears dragging and riding of mounts/wagons, draggees also join your civ
function clearMerchant(unit)
	local draggee

	-- Free the draggee as well and makeown + tame it
	if -1 ~= unit.relations.draggee_id then
		dragee = utils.binsearch(df.global.world.units.active, unit.relations.draggee_id, 'id')

		if dragee then
			mo.make_own(dragee)
			dragee.relations.dragger_id = -1
			dragee.flags1.tame = true
			dragee.training_level = df.animal_training_level.Domesticated
		end
	end

	unit.relations.draggee_id = -1
	unit.relations.rider_mount_id = -1
	unit.relations.mount_type = 0
	unit.flags1.rider = 0

	
end

-- Take the creature out of its cage
function clearCage(unit)
	local cage = dfhack.units.getContainer(unit)
	
	if -1 ~= cage then
		position = xyz2pos(dfhack.units.getPosition(unit))
		unit.pos:assign(position)
		unit.flags1.caged = false
	end

end

-- Takes down any hostility flags that mo didn't handle
function clearHostile(unit)
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
end

-- Change the creature race, take down hostility and  merchant flags, free cages and trading
function corrupt(unit)
	local origRace = tostring(df.global.world.raws.creatures.all[unit.race].creature_id)
	local suffix, targetCaste, position

	-- Setting announcements
	if unit.flags1.merchant == true then 
		announceMerchant = true 
	end

	mo.make_own(unit)
	mo.make_citizen(unit)

	-- Removes all the previous behaviour
	clearHostile(unit)
	clearMerchant(unit)
	clearCage(unit)
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

--
-- Action
--

validArgs = validArgs or utils.invert({
    'help',
    'unit',
    'set',
})

local args = utils.processArgs({...}, validArgs)

if args.help then
 print([[scripts/succubus/corrupt.lua
arguments
    -help
        Print this help message
    -unit <number>
        The unit at the source of the corruption
    -set <string>
        One of the available creature sets, currently only "succubus" is accepted
]])
 return
end

-- The source unit
if not args.unit then qerror('Not unit provided, check succubus/corrupt -help') end

unitSource = df.unit.find(tonumber(args.unit))
if not unitSource then qerror('Unit not found.') end

-- The transformation set, syntax is {RACE = 'TARGET_CASTE'}
-- TARGET_CASTE can be false, then no transformation occur
-- The played fort's race must contain the castes 
if args.set == 'succubus' then
	creatureSet = {
		WARLOCK_CIV = 'DEVIL',
		HUMAN = 'DEVIL',
		DWARF = 'FIEND',
		ELF = 'CAMBION',
		GNOME_CIV = 'KORRIGAN',
		KOBOLD = 'IMP',
		GOBLIN = 'HELLION',
		ORC_TAIGA = 'ONI',
		SUCCUBUS = false,
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
else
	qerror("Invalid set, check succubus/corrupt -help")
end

-- Starts the corruption process
targetRace = df.global.world.raws.creatures.all[df.global.ui.race_id].creature_id
findLos(unitSource)
