-- Wrapper script for commands used in summoning reactions
-- First parameter is the worker id, then a serie of commands

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Missing parameters.') end

local args = {...}
local unitId = args[1]

-- Loop through the args and call for other scripts as needed
function runCommands()
	local k, command

	for k, command in ipairs(args) do

		if command == 'untame' then
			dfhack.run_script('fooccubus-untame', unitId)
		elseif command == 'skills' then
			dfhack.run_script('fooccubus-skills')
		end

	end

end
 
runCommands()
