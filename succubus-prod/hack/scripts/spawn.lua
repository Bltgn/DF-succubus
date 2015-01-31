--create unit at pointer or given location and with given civ (usefull to pass -1 for enemy). Usage e.g. "spawnunit DWARF 0 Dwarfy"

args={...}
local spawnunit = require 'spawnunit'
local argPos, caste

if #args > 1 then
	caste = args[2]
end
 
if #args>3 then
    argPos={}
    argPos.x=args[4]
    argPos.y=args[5]
    argPos.z=args[6]
end

spawnunit.race = args[1]
spawnunit.caste = caste
spawnunit.position = argPos

spawnunit.place()
