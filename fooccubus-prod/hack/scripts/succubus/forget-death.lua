-- Citizens forget then recent deaths (pet/friend/relative...), depending of the relations of the source unit
-- One event per citizen is removed.
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('forget-death : Missing parameters.') end

local args = {...}
local ratingMultiplier = 3 -- From 3 to 16 min-thoughts removed by this script
local cFixedToughts = 0
local debug = true

-- Returns a rating from 1 to 5
local function rating(unit)
	return math.min(math.ceil(#unit.status.acquaintances / 4), 2)
end

-- Action
local unit = df.unit.find(tonumber(args[1]))
if not unit then qerror('forget-death : Unit not found.') end

local cMaxToughts = rating(unit) * ratingMultiplier

for fnUnitCount, fnUnit in ipairs(df.global.world.units.all) do
	if fnUnit.race == df.global.ui.race_id then
		local events = fnUnit.status.recent_events

		if #events > 0 then
			for k,v in pairs(events) do
				if v.type == df.unit_thought_type.WitnessDeath
					or v.type == df.unit_thought_type.LostPet
					or v.type == df.unit_thought_type.LostPet2
					or v.type == df.unit_thought_type.LostTrainingAnimal
					or v.type == df.unit_thought_type.RageKill
					or v.type == df.unit_thought_type.SparringAccident
					or v.type == df.unit_thought_type.LostSpouse
					or v.type == df.unit_thought_type.LostFriend
					or v.type == df.unit_thought_type.LostLover
					or v.type == df.unit_thought_type.LostSibling
					or v.type == df.unit_thought_type.LostChild
					or v.type == df.unit_thought_type.LostMother
					or v.type == df.unit_thought_type.LostFather
					or v.type == df.unit_thought_type.LostGrudge
				then
					events:erase(k)
					cFixedToughts = cFixedToughts + 1
					break
				end
			end
		end

		if cFixedToughts >= cMaxToughts then
			break
		end
	end
end
if debug then print("Death thought removed: "..cFixedToughts) end

if cFixedToughts > 0 then
	dfhack.gui.showAnnouncement('The succubi forgot their recent tragedies.', COLOR_YELLOW)
end
--payback()