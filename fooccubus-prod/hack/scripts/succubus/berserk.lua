-- Apply a syndrome depending of its unhappy rating, it is run on the target creature and use addsyndrome to simulate a self buff
local rating = require 'rating'
local fov = require 'fov'

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end

local args = {...}
local debug = true
local syndrome, power, name

if not args[1] then qerror('Berserk : No unit entered') end

unit = df.unit.find(args[1])
if not unit then qerror('Berserk : Unit not found.') end

power = rating.unhappiness(unit)
name = dfhack.units.getVisibleName(unit)

if debug then print('Berserk unit #'..unit.id..' rating '..power) end

-- Lets pick a syndrome tier
if power < 3 then
	syndrome = 'FOOCCUBUS_BERSERK_1'
elseif power < 5 then
	syndrome = 'FOOCCUBUS_BERSERK_2'
else
	dfhack.gui.showAnnouncement(name .. ' is consumed by anger!', COLOR_YELLOW)
	syndrome = 'FOOCCUBUS_BERSERK_3'
end

dfhack.run_script('addsyndrome', syndrome, unit.id, '-1,-1,-1', 'civ', 'NONE', 'NONE', 'BERSERK', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE')
if debug then print('- Apply '..syndrome) end
