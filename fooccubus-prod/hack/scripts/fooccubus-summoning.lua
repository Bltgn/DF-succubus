-- Wrapper script for commands used in summoning reactions
-- First parameter is the worker id, then a serie of commands

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Missing parameters.') end

local args = {...}
local unitId = args[0]

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


function runCommands()
	local k, command

	for k, command in ipairs(args) do

		if command == 'untame' then
			dfhack.run_script('fooccubus-untame', unitId)
		else if command == 'skills' then
			dfhack.run_script('fooccubus-skills')
		end

	end

end
 
runCommands()
