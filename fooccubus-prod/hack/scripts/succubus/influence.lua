-- Modify attributes based on a set of actions

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local args = {...}
local unit, domain

if not args[1] then qerror('Influence: No domain entered') end
if not args[2] then qerror('Influence: No unit entered') end

domain = args[1]
unit = df.unit.find(tonumber(args[2]))

local function wrath(unit)

	unit.status.current_soul.traits.ANGER = math.min(100, unit.status.current_soul.traits.ANGER + 20)
	unit.status.current_soul.traits.LIBERALISM = math.min(100, unit.status.current_soul.traits.ANGER + 10)
	unit.status.current_soul.traits.ALTRUISM = math.max(0, unit.status.current_soul.traits.ANGER - 10)

end

if domain == 'wrath' then
	wrath(unit)
else
	qerror('Influence: Wrong domain entered')
end
