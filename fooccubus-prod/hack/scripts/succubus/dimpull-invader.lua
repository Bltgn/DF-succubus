-- Slam siegers to the ground
-- todo manage the case where only leaders remain
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local args = {...}
local unit = df.unit.find(tonumber(args[1]))
if not unit then qerror('crazed-invaders : Unit not found.') end

local invaders = {}
local targetId

-- Todo more effect depending of the originating civ and the quality of the craft
local function rating(unit)
	local number = math.random(1, 3)
	return number
end

-- Todo catch the reagent value
local function power(unit)
	local number = math.random(50000, 200000)
	return number
end

-- Gets all the invaders, not their leaders
for k, unit in ipairs(df.global.world.units.all) do
	if unit.flags1.active_invader and unit.relations.group_leader_id > -1 and not unit.flags1.caged and dfhack.units.isAlive(unit)  then
		table.insert(invaders, unit.id)
	end
end

if #invaders == 0 then qerror('dimension pull: No invader found.') end

for i = 0, rating(unit) do
	targetId = invaders[math.random(1, #invaders)]
	dfhack.run_script('slam', power(unit), targetId)
end