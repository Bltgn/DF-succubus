-- Displaces a creature towards another
--[[

	Displace a creature towards another

	@author Boltgun

]]

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Missing parameters.') end

local fov = require 'fov'

local args = {...}
local unitId = args[1]
local teleported = args[2]
local unitList = df.global.world.units.active

-- Check if the unit is seen and valid
function isSelected(unit, view)
	local unitRaw = df.global.world.raws.creatures.all[unitTarget.race]

	if unitRaw.creature_id == args[2] and not dfhack.units.isDead(unit) then
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

-- Find creatures within the LOS of the creature
function findLos(unitSource)
	local view = fov.get_fov(10, unitSource.pos)
	local i

	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		unitTarget = unitList[i]
		if isSelected(unitTarget, view) then
			dfhack.run_script('teleport', 'unit', unitTarget.id, 'x', unitSource.pos.x, 'y', unitSource.pos.y, 'z', unitSource.pos.z)
			return true
		end
	end

	return false
end

unit = df.unit.find(unitId)
if not unit then qerror('Unit not found.') end

findLos(unit)
