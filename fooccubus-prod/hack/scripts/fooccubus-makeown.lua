-- Sets the units within line of sight of the unit
--[[

	This script is called by the conversion dens
	@author Boltgun

	@todo support for semi megabeasts such as minotaur
]]
local fov = require 'fov'
local mo = require 'makeown'

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local unit, creatureSet
local args = {...}

-- Check if the unit is seen and valid
function isSelected(unit, view)
	local creatureId = df.global.world.raws.creatures.all[unitTarget.race].creature_id
	local pos = unit.pos

	if creatureSet[creature_id] and
		not dfhack.units.isDead(unit) and
		not dfhack.units.isOpposedToLife(unit) then
			return validateCoords(pos, view)
	end

	return false
end

-- Check boundaries and field of view
function validateCoords(pos, view)

	if pos.x < view.xmin or pos.x > view.xmax then
		return false
	end

	if pos.y < view.ymin or pos.y > view.ymax then
		return false
	end

	return view.z == pos.z and view[pos.y][pos.x] > 0

end

-- Find soul wisps within the LOS of the creature
function findLos(unitSource)
	local view = fov.get_fov(5, unitSource.pos)
	local i
	local unitList = df.global.world.units.active

	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		unitTarget = unitList[i]
		if isSelected(unitTarget, view) then
			mo.make_own(unitTarget)
		end
	end
end

-- Action
unit = df.unit.find(tonumber(args[1]))
if not unit then qerror('Unit not found.') end

-- Return the set of affected units
if not args[2] then qerror('Please enter a creature set.') end
if args[2] == 'invaders-deep' then
	creatureSet = {['HUMAN'] = true, ['KOBOLD'] = true, ['ELF'] = true, ['DWARF'] = true, ['GOBLIN'] = true, ['FOOCCUBUS'] = true}
elseif args[2] == 'invaders' then
	creatureSet = {['HUMAN'] = true, ['KOBOLD'] = true, ['ELF'] = true, ['DWARF'] = true, ['GOBLIN'] = true, ['FOOCCUBUS_DEEP'] = true}
elseif args[2] == 'minotaur' then
	creatureSet = {['MINOTAUR'] = true}
else
	qerror('Unsupported creature set.')
end

findLos(unit)
