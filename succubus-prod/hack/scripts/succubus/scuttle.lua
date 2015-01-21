-- Set the target to be scuttled, ran on summoned souls to leave a 'soul' behind.
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local args = {...}
local unit = df.unit.find(args[1])
if not unit then qerror('Scuttle : Unit not found.') end

unit.flags3.scuttle = true
