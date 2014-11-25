-- Wrapper script for commands used in summoning reactions
--[[

	Requires SpawnUnit, for the current version of dfhack.
	This will spawn the unit using a random caste and call a fov tame flag removal if needed.

	usage fooccubus-summoning <sourceUnit> <creatureRaw> [<tame>]
	* sourceUnit : The unit's id in the current site (ie: 128)
	* creatureRaw : The creature raw id (ie: DOG)
	* tame : If provided, will tame the creature

	@author Boltgun

]]

if not dfhack.isMapLoaded() then qerror('Map is not loaded.') end
if not ... then qerror('Missing parameters.') end

-- Variables
local args = {...}
local tame = false
local casteMax = 0

if not args[1] then qerror('Please enter a source unit ID number.') end
local unitId = args[1]
if not args[2] then qerror('Please enter a creature raw ID.') end
local creature = args[2]

if args[3] then
	tame = (args[3] == 1)
end

local creatureRaw, creatureName, creatureLetter, article;

-- Return the creature's raw data
function getRaw(creature_id)
	local id, raw

	for id, raw in pairs(df.global.world.raws.creatures.all) do
		if raw.creature_id == creature_id then return raw end
	end

	qerror('Creature not found : '..creature_id)
end

-- Getting the summoner
unit = df.unit.find(unitId)
if not unit then qerror('Unit not found.') end

-- Setting things up for the creature
creatureRaw = getRaw(creature)
casteMax = #creatureRaw.caste - 1

-- Picking a caste or gender at random
if casteMax > 0 then
	caste = math.random(0, casteMax)
else
	caste = 0
end

-- Spawning
dfhack.run_script('spawnunit', creature, caste, nil, dfhack.units.getPosition(unit))

-- Generating the message
creatureName = creatureRaw.name[0]
creatureLetter = string.sub(creatureName, 0, 1)

if creatureLetter == 'a' or creatureLetter == 'e' or
	creatureLetter == 'i' or creatureLetter == 'o' or
	creatureLetter == 'u' then
	article = 'an'
else
	article = 'a'
end

dfhack.gui.showAnnouncement('You have summonned '..article..' '..creatureName..'.', COLOR_YELLOW)

-- Tame creature
if tame then dfhack.run_script('fovtame', unitId, creature) end
-- Temporary measure
dfhack.run_script('naturalskills')
