-- Apply a syndrome depending of its happiness rating, it is run on the target creature and use addsyndrome to simulate a self buff
local fov = require 'fov'

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end

local args = {...}
local debug = false
local syndrome, power, name, gender

if not args[1] then qerror('Berserk : No unit entered') end

unit = df.unit.find(args[1])
if not unit then qerror('Berserk : Unit not found.') end

-- Happiness, 5 for ecstatic
function happiness(unit)
	local happiness = unit.status.happiness

	if happiness > 150 then return 5
	elseif happiness > 124 then return 4
	elseif happiness > 75 then return 3
	elseif happiness > 26 then return 2
	else return 1 end
end

-- Addsyndrome may check for this, but I need to check first to prevent the announcement
function hasSyndrome(unitTarget)
	local actives = unitTarget.syndromes.active
	local syndromes = df.global.world.raws.syndromes.all
	local ka, kc, active, class

	for ka, active in ipairs(actives) do
		local synclass=syndromes[active.type].syn_class
		for kc, class in ipairs(synclass) do
			if class.value == 'EXCITATION' then return true end
		end
	end

	return false
end

-- @todo Support for last name maybe ?
function getName(unitTarget)
	local name = dfhack.units.getVisibleName(unit)

	if not name.has_name then return 'A creature' end
	if string.len(name.nickname) > 0 then return "'"..name.nickname.."'" end

	return string.gsub(name.first_name, '^(.)', string.upper)
end

power = happiness(unit)
if hasSyndrome(unit) then
	if debug then print('Berserk unit #'..unit.id..' rating '..power) end

	-- Lets pick a syndrome tier
	if power == 1 then
		-- nothing!
	elseif power < 3 then
		syndrome = 'FOOCCUBUS_EXCITATION_1'
	elseif power < 5 then
		syndrome = 'FOOCCUBUS_EXCITATION_2'
	else
		if unit.sex == 1 then
			gender = 'his'
		else
			gender = 'her'
		end
		dfhack.gui.showAnnouncement(getName(unit)..' has lost '..gender..' mind in battle!', COLOR_BLUE)
		syndrome = 'FOOCCUBUS_EXCITATION_3'
	end

	if syndrome then
		dfhack.run_script('addsyndrome2', syndrome, unit.id)
		if debug then print('- Apply '..syndrome) end
	else
		if debug then print('- Happiness is too low, no syndrome') end
	end
end
