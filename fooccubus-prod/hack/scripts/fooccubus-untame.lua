-- Remove the tame flag from soul wisps within LOS
--[[
	
	This script is called when a summoning job completes
	@author Boltgun

]]
local fov = require 'fov'
local utils = require 'utils'

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local unit = nil
local unitList = df.global.world.units.active
local unitId = tonumber(...)
 
-- Finding the source unit
function findUnit(searchId)
	local k, _
 
	for k, _ in ipairs(unitList) do
		if unitList[k].id == searchId then
			return unitList[k]
		end
	end
 
	return nil
end
 
-- Check if the unit is seen and valid
function isSelected(unit, view)
	local unitRaw = df.global.world.raws.creatures.all[unitTarget.race]
	local pos = unit.pos

	if unitRaw.creature_id == "SOUL_WISP" and
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
	
	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		unitTarget = unitList[i]
		if isSelected(unitTarget, view) then
			untame(unitTarget)
		end
	end
end

function untame(unit)
	unit.flags1.tame = false
end

unit = findUnit(unitId)
if not unit then qerror('Unit not found.') end
 
findLos(unit)
