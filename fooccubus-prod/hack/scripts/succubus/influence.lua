-- Modify attributes based on a set of actions

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID and a domain.') end

local args = {...}
local unit, domain

if not args[1] then qerror('Influence: No domain entered') end
if not args[2] then qerror('Influence: No unit entered') end

domain = args[1]
unit = df.unit.find(tonumber(args[2]))

-- Traits change, more bad thoughts and rage prone
local function wrath(unit)
	unit.status.current_soul.traits.ANGER = math.min(100, unit.status.current_soul.traits.ANGER + 20)
	unit.status.current_soul.traits.LIBERALISM = math.min(100, unit.status.current_soul.traits.LIBERALISM + 10)
	unit.status.current_soul.traits.ALTRUISM = math.max(0, unit.status.current_soul.traits.ALTRUISM - 10)
end

-- Trait changes
local function lust(unit)
	unit.status.current_soul.traits.IMMODERATION = math.min(100, unit.status.current_soul.traits.IMMODERATION + 20)
	unit.status.current_soul.traits.EXCITEMENT_SEEKING = math.min(100, unit.status.current_soul.traits.EXCITEMENT_SEEKING + 20)
	unit.status.current_soul.traits.GREGARIOUSNESS = math.min(100, unit.status.current_soul.traits.GREGARIOUSNESS + 10)
	-- todo add lover
end

-- Traits changes
local function pride(unit)
	unit.status.current_soul.traits.MODESTY = math.max(0, unit.status.current_soul.traits.MODESTY - 10)
	unit.status.current_soul.traits.ALTRUISM = math.min(100, unit.status.current_soul.traits.ALTRUISM + 10)
	unit.status.current_soul.traits.STRAIGHTFORWARDNESS  = math.max(0, unit.status.current_soul.traits.STRAIGHTFORWARDNESS - 10)
end

-- Gain cooking/brewing skills, makes fatter, empties stomach and add hunger + thirst
local function gluttony(unit)
	dfhack.run_script('trainskill', unit.id, 'BREWING', 5)
	dfhack.run_script('trainskill', unit.id, 'COOK', 5)
	unit.counters2.stored_fat = unit.counters2.stored_fat * 1.4
	unit.counters2.stomach_content = unit.counters2.stomach_content * 0.1
	unit.counters2.stomach_food = unit.counters2.stomach_content * 0.1
	if unit.counters2.hunger_timer < 50000 then unit.counters2.hunger_timer = 50000 end
	if unit.counters2.thirst_timer < 25000 then unit.counters2.thirst_timer = 25000 end
end

-- Trait changes
local function envy(unit)
	unit.status.current_soul.traits.LIBERALISM = math.min(100, unit.status.current_soul.traits.LIBERALISM + 20)
	unit.status.current_soul.traits.ALTRUISM = math.max(0, unit.status.current_soul.traits.ALTRUISM - 20)
	unit.status.current_soul.traits.TRUST = math.max(0, unit.status.current_soul.traits.TRUST - 20)
	unit.status.current_soul.traits.ANXIETY = math.min(100, unit.status.current_soul.traits.ANXIETY + 10)
end

-- Chance to have a siege TODO personnality
local function greed(unit)
	dfhack.run_script('succubus/callsiege', 5)
end

if domain == 'wrath' then
	wrath(unit)
elseif domain == 'lust' then
	lust(unit)
elseif domain == 'gluttony' then
	gluttony(unit)
elseif domain == 'envy' then
	envy(unit)
elseif domain == 'pride' then
	pride(unit)
elseif domain == 'sloth' then
	-- todo
elseif domain == 'greed' then
	greed(unit)
else
	print('Influence: Wrong domain entered')
end
