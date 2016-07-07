-- Check periodically for intelligents pets without historical figures
--[[
	In some cases, intelligent creatures will go in your fort without proper data to act as a citizen.
	As a result, they cannot join your military or perform labor.

	This script uses create-unit to general an historical figure for them.

	Only act on living, sane and non civ race creatures.

	@todo Check for intelligence, it currently create nemesis for all pets.
	@author Boltgun
]]

local createUnit = dfhack.script_environment('modtools/create-unit')
local debug = true

-- Create an historical figure out of an unit, related to the curent fort.
function createHistFig(unit)
	createUnit.createNemesis(unit, df.global.ui.civ_id, df.global.ui.group_id)
end

function scanForPetsWithNoNemesis()
	local cAffected = 0
	local unitList = df.global.world.units.active
	local unit, i

	for i = #unitList - 1, 0, -1 do
		unit = unitList[i]

		if(
			unit.civ_id == df.global.ui.civ_id and
			not dfhack.units.isDwarf(unit) and
			dfhack.units.isAlive(unit) and
			dfhack.units.isSane(unit) and
			not dfhack.units.getNemesis(unit)
		) then
			createHistFig(unit)
			cAffected = cAffected + 1
		end	
	end

	if(debug and 0 < cAffected) then
		print("smartpets: "..cAffected.." creatures fixed")
	end
end

scanForPetsWithNoNemesis()
dfhack.timeout(3, 'days', function() dfhack.run_script('fix/smartpets') end)
