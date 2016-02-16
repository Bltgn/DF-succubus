-- Displaces a creature towards another.
--[[
	Displaces a creature towards another, both will be put on ground.

	arguments
	    -help
	        print this help message
	    -source <number>
	    	The source unit's id.
	    -target <number>
	        The target unit's id.

	@author Boltgun
]]

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
local utils = require 'utils'
local teleport = dfhack.script_environment('teleport')

local validArgs = validArgs or utils.invert({
	'help',
	'source',
	'target'
})

local args = utils.processArgs({...}, validArgs)

if args.help then
	print([[scripts/succubus/phasing.lua
arguments
    -help
        print this help message
    -source <number>
    	The source unit's id.
    -target <number>
        The target unit's id.
]])
	return
end

if not args.source then qerror('succubus/phasing: no source unit') end
if not args.target then qerror('succubus/phasing: no target unit') end

local sourceUnit = df.unit.find(args.source)
if not sourceUnit then qerror('succubus/phasing: source unit not found') end

local targetUnit = df.unit.find(args.target)
if not targetUnit then qerror('succubus/phasing: target unit not found') end

teleport.eleport(sourceUnit, targetUnit.pos)
