-- Modify attributes based on a set of actions

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID and a domain.') end

local args = {...}
local unit, domain

if not args[1] then qerror('Influence: No domain entered') end
if not args[2] then qerror('Influence: No unit entered') end

domain = args[1]
unit = df.unit.find(tonumber(args[2]))

local function wrath(unit)
	unit.status.current_soul.traits.ANGER = math.min(100, unit.status.current_soul.traits.ANGER + 20)
	unit.status.current_soul.traits.LIBERALISM = math.min(100, unit.status.current_soul.traits.LIBERALISM + 10)
	unit.status.current_soul.traits.ALTRUISM = math.max(0, unit.status.current_soul.traits.ALTRUISM - 10)
end

local function lust(unit)
	unit.status.current_soul.traits.IMMODERATION = math.min(100, unit.status.current_soul.traits.IMMODERATION + 20)
	unit.status.current_soul.traits.EXCITEMENT_SEEKING = math.min(100, unit.status.current_soul.traits.EXCITEMENT_SEEKING + 20)
	unit.status.current_soul.traits.GREGARIOUSNESS = math.min(100, unit.status.current_soul.traits.GREGARIOUSNESS + 10)
	-- todo add lover
end

local function pride(unit)
	unit.status.current_soul.traits.MODESTY = math.max(0, unit.status.current_soul.traits.MODESTY - 10)
	unit.status.current_soul.traits.ALTRUISM = math.min(100, unit.status.current_soul.traits.ALTRUISM + 10)
	unit.status.current_soul.traits.STRAIGHTFORWARDNESS  = math.max(0, unit.status.current_soul.traits.STRAIGHTFORWARDNESS - 10)

end

if domain == 'wrath' then
	wrath(unit)
elseif domain == 'lust' then
	lust(unit)
else
	qerror('Influence: Wrong domain entered')
end
