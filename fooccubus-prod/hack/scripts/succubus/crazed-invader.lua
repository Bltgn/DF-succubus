-- Render x invaders opposed to lige, the effect is more important if the worker has positions
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Please enter a creature ID.') end

local args = {...}
local sourceUnit = df.unit.find(tonumber(args[1]))
if not sourceUnit then qerror('crazed-invaders : Unit not found.') end

local invaders = {}
local targetId

-- Todo more effects depending of the worker's position
local function rating(unit)
	local number = math.random(1, 3)
	return number
end

-- Gets all the invaders, not their leaders
for k, unit in ipairs(df.global.world.units.all) do
	if unit.flags1.active_invader and unit.relations.group_leader_id > -1 and not unit.flags1.caged and dfhack.units.isAlive(unit) then
		table.insert(invaders, unit.id)
	end
end

if #invaders == 0 then qerror('crazed-invaders : No invader found.') end

for i = 0, rating(unit) do
	targetId = invaders[math.random(1, #invaders)]
	dfhack.run_script('addsyndrome2', 'SYNDROME_OPPOSED_TO_LIFE', targetId)
end