-- Apply a syndrome depending of its unhappy rating

local rating = require rating

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local args = {...}
local unit, power

if not args[1] then qerror('Berserk : No unit entered') end

unit = df.unit.find(tonumber(args[1]))
power = rating.unhappiness(unit)
name = dfhack.units.getVisibleName(unit)

-- Lets pick a syndrome tier
if power < 3 then
	-- Slight bonus
	dfhack.run_script('addsyndrome', 'FOOCCUBUS_BERSERK_1', args[1], '-1, -1, -1', 'civ')
elseif power < 5 then
	-- Anger adding strenght
	dfhack.run_script('addsyndrome', 'FOOCCUBUS_BERSERK_2', args[1], '-1, -1, -1', 'civ')
else
	-- Ouch!
	dfhack.gui.showAnnouncement(name .. ' is consumed by anger!', COLOR_YELLOW)
	dfhack.run_script('addsyndrome', 'FOOCCUBUS_BERSERK_3', args[1], '-1, -1, -1', 'civ')
end