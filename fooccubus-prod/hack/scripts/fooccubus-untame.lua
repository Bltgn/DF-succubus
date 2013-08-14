-- Remove the tame flag from soul wisps within LOS
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
 
-- Check if the unit is seen
function isSeen(view, p)
	return view.z and p.z == view.z and view[p.y] and view[p.y][p.x] > 0
end
 
-- Find soul wisps within the LOS of the creature
function findLos(unitSource)
	local radius = 5
	local view = fov.get_fov(radius, unit.pos)
	local i, unitRaw
	
	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		unitTarget = unitList[i]
		unitRaw = df.global.world.raws.creatures.all[unitTarget.race]
		if unitRaw.creature_id == "SOUL_WISP" and isSeen(view, unitTarget.pos) then
			untame(unitTarget)
		end
	end
end
 
function untame(unit)
	unit.flags1.tame = false
end

print(...)
 
unit = findUnit(unitId)
if not unit then qerror('Unit not found.') end
 
findLos(unit)
