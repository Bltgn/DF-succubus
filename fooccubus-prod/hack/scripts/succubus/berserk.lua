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

-- Addsyndrome may check for this, but I need to check first to prevent the announcement
function isBerserk(unitTarget)
	local actives = unitTarget.syndromes.active
	local syndromes = df.global.world.raws.syndromes.all
	local ka, kc, active, class

	for ka, active in ipairs(actives) do
		local synclass=syndromes[active.type].syn_class
		for kc, class in ipairs(synclass) do
			if class.value == 'BERSERK' then return true end
		end
	end

	return false
end

-- @todo Support for last name maybe ?
function getName(unitTarget)
	local name = dfhack.units.getVisibleName(unit)
	printall(name.words)

	if not name.has_name then return '???' end
	if string.len(name.nickname) > 0 then return "'"..name.nickname.."'" end

	return string.gsub(name.first_name, '^(.)', string.upper)
end

power = rating.unhappiness(unit)

if isBerserk(unit) then
	if debug then print('Berserk unit #'..unit.id..' rating '..power) end

	-- Lets pick a syndrome tier
	if power < 3 then
		syndrome = 'FOOCCUBUS_BERSERK_1'
	elseif power < 5 then
		syndrome = 'FOOCCUBUS_BERSERK_2'
	else
		dfhack.gui.showAnnouncement(getName(unit) .. ' is consumed by anger!', COLOR_YELLOW)
		syndrome = 'FOOCCUBUS_BERSERK_3'
	end

	dfhack.run_script('addsyndrome', syndrome, unit.id, '-1,-1,-1', 'civ', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE')
	if debug then print('- Apply '..syndrome) end
end
