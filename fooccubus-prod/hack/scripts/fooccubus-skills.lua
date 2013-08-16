-- Check for a set of creatures and see if they have their naturals skills
-- The effect is delayed to allow the summoning interactions to complete first
-- Will skip creature who already received their minimum skills
 
if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
 
local utils = require 'utils'
 
-- The list of creatures supported by this script
local validUnit = {
	'BASILISK',
	'NIGHTMARE', 
	'HELLHOUND', 
	'TENTACLE_MONSTER',
	'NAHASH'
} 

-- Scan the units table for targeted creatures
function naturalSkills()
	local unitList = df.global.world.units.active
	local i
 
	-- Check through the list for the right units
	for i = #unitList - 1, 0, -1 do
		if isSumonnedCreature(unitList[i]) then
			fixSkills(unitList[i])
		end
	end
end
 
-- Returns true is the creature belong to our set
function isSumonnedCreature(unit)
	local k, id
	local raw = df.global.world.raws.creatures.all[unit.race]
 
	for k, id in ipairs(validUnit) do
		if raw.creature_id == id then
			return true
		end
	end
 
end

-- Check if the unit has the skill and its rating high enough
function hasSkill(unit, skillId, rating)
	local k, skill, currentSkill

	for k, skill in ipairs(unit.status.current_soul.skills) do

		if skill.id == skillId then
			currentSkill = skill
			break
		end

	end

	if currentSkill then
		return currentSkill.rating >= rating
	end

	return false

end
 
-- Search the creatures for a select set, ensure those have their natural skills
function fixSkills(unit)
	local raw = df.global.world.raws.creatures.all[unit.race].caste[unit.caste]
	local k, skill, rating
 
	for k, skill in ipairs(raw.natural_skill_id) do
		rating = raw.natural_skill_lvl[k]
 
		if hasSkill(unit, skill, rating) == false then
			newSkill = df.unit_skill:new()
			newSkill['id'] = skill
			newSkill['experience'] = raw.natural_skill_exp[k]
			newSkill['rating'] = rating
 
			utils.insert_or_update(unit.status.current_soul.skills, newSkill, 'id')
		end
	end
end
 
dfhack.timeout('1000', 'ticks', function() naturalSkills() end)
