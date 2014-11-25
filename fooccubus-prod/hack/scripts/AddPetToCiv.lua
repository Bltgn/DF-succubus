--comment


local function insertPet(entity,creature,caste)
	local exists=false
	for k,v in pairs(df.global.world.entities.all) do
		--ENTITY TYPES
		--Civilization	0
		--SiteGovernment	1
		--VesselCrew	2
		--MigratingGroup	3
		--NomadicGroup	4
		--Religion	5
		--MilitaryUnit	6
		--Outcast	7
		if v.type==0 and v.entity_raw.code==entity then --exclude bandits
			--print(k)
			--printall(v.resources.animals)
			for kk,vv in pairs(v.resources.animals.pet_races) do
				--print(kk,vv,v.resources.animals.pet_castes[kk])
				local checkrace = df.creature_raw.find(vv)
				local checkcaste = checkrace.caste[v.resources.animals.pet_castes[kk]]
				--print(checkrace.creature_id, checkcaste.caste_id)
				if checkrace.creature_id == creature and checkcaste.caste_id == caste then exists=true end
			end
			if exists==true then
				print("ERROR- civilization ",entity," has creature ", creature, caste)
			else
				--the civ doesn't have the creature as a pet
				--add the creature as a pet
				local racenum=-1
				local castenum=-1
				for kk,vv in pairs(df.global.world.raws.creatures.all) do
					--print(vv.creature_id)
					if vv.creature_id==creature then 
						racenum=kk
						--print(kk)
						--printall(vv.caste)
						for kkk,vvv in pairs(vv.caste) do
							--print(vvv.caste_id)
							if vvv.caste_id==caste then castenum=kkk end
						end
						break
					end
				end
				if racenum > -1 and castenum > -1 then
					--print("success!!")
					--print(v)
					v.resources.animals.pet_races:insert('#',racenum)
					v.resources.animals.pet_castes:insert('#',castenum)
					print("Inserted ", creature, caste, " in civ ",k, entity)
				else
					print(creature, caste, " not found in raws")
				end
			end
		end
		exists=false
	end
end


-- --dwarves
-- insertPet("MOUNTAIN","CHANGELING","FEMALE")
-- insertPet("MOUNTAIN","CHANGELING","MALE")
-- insertPet("MOUNTAIN","PLUMP_HELMET_MAN_PHM","FEMALE")
-- insertPet("MOUNTAIN","PLUMP_HELMET_MAN_PHM","MALE")
-- insertPet("MOUNTAIN","WARD_CULT","MALE")
-- insertPet("MOUNTAIN","SCARECROW","MALE")
-- insertPet("MOUNTAIN","STONE_CRAB_DDD","FEMALE")
-- insertPet("MOUNTAIN","STONE_CRAB_DDD","MALE")
-- insertPet("MOUNTAIN","DEW_BEETLE_DDD","FEMALE")
-- insertPet("MOUNTAIN","DEW_BEETLE_DDD","MALE")
-- insertPet("MOUNTAIN","SHAGGY_BADGERDOG_DDD","FEMALE")
-- insertPet("MOUNTAIN","SHAGGY_BADGERDOG_DDD","MALE")
-- insertPet("MOUNTAIN","MOLEWEASEL_DDD","FEMALE")
-- insertPet("MOUNTAIN","MOLEWEASEL_DDD","MALE")
-- insertPet("MOUNTAIN","LEATHERWING_DDD","FEMALE")
-- insertPet("MOUNTAIN","LEATHERWING_DDD","MALE")
-- insertPet("MOUNTAIN","CAVERNKEET_BEARDED_DDD","FEMALE")
-- insertPet("MOUNTAIN","CAVERNKEET_BEARDED_DDD","MALE")
-- insertPet("MOUNTAIN","CRAGTOOTH_BOAR_DDD","FEMALE")
-- insertPet("MOUNTAIN","CRAGTOOTH_BOAR_DDD","MALE")
-- insertPet("MOUNTAIN","WOOLLY_GOAT_MOUNTAIN_DDD","FEMALE")
-- insertPet("MOUNTAIN","WOOLLY_GOAT_MOUNTAIN_DDD","MALE")
-- insertPet("MOUNTAIN","CAVE_TURTLE_HORNED_DDD","FEMALE")
-- insertPet("MOUNTAIN","CAVE_TURTLE_HORNED_DDD","MALE")
-- insertPet("MOUNTAIN","TUSKOX_MOUNTAIN_DDD","FEMALE")
-- insertPet("MOUNTAIN","TUSKOX_MOUNTAIN_DDD","MALE")
-- insertPet("MOUNTAIN","GOAT_BOOZE","FEMALE")
-- insertPet("MOUNTAIN","GOAT_BOOZE","MALE")
-- insertPet("MOUNTAIN","MASTIFF","FEMALE")
-- insertPet("MOUNTAIN","MASTIFF","MALE")
-- insertPet("MOUNTAIN","PEKYT","FEMALE")
-- insertPet("MOUNTAIN","PEKYT","MALE")
-- insertPet("MOUNTAIN","FRILLLIZARD","FEMALE")
-- insertPet("MOUNTAIN","FRILLLIZARD","MALE")
-- insertPet("MOUNTAIN","DRAKE","FEMALE")
-- insertPet("MOUNTAIN","DRAKE","MALE")
-- insertPet("MOUNTAIN","BEETLE_CAVE","FEMALE")
-- insertPet("MOUNTAIN","BEETLE_CAVE","MALE")
-- insertPet("MOUNTAIN","CAVE_TURTLE","FEMALE")
-- insertPet("MOUNTAIN","CAVE_TURTLE","MALE")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_ACID")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_DRYICE")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_FIRE")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_ICE")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_FLASH")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_DUST")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_FRAG")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_TOXIC")
-- insertPet("MOUNTAIN","LANDMINE","LANDMINE_HELLFIRE")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_ACID")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_STONE")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_FIRE")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_HELLFIRE")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_SLADE")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_WARPSTONE")
-- insertPet("MOUNTAIN","TURRET_OF_ACID","TURRET_OF_WEB")
-- insertPet("MOUNTAIN","GOLEM_TRADE","MALE_SPEAR")
-- insertPet("MOUNTAIN","GOLEM_TRADE","MALE_HAMMER")
-- insertPet("MOUNTAIN","GOLEM_TRADE","MALE_SWORD")
-- insertPet("MOUNTAIN","GENIE_TAME","FEMALE")
-- --elves
-- --- elves get pet exotic, eg use-all-pet-races, and get access to whatever they happen to tame in the worldgen. they are a wild card.

-- --humans
-- insertPet("PLAINS","SHEEP","MALE")
-- insertPet("PLAINS","SHEEP","FEMALE")
-- insertPet("PLAINS","HAWK","MALE")
-- insertPet("PLAINS","HAWK","FEMALE")
-- insertPet("PLAINS","DONKEY","MALE")
-- insertPet("PLAINS","DONKEY","FEMALE")
-- insertPet("PLAINS","PIG","MALE")
-- insertPet("PLAINS","PIG","FEMALE")
-- insertPet("PLAINS","CAVY","MALE")
-- insertPet("PLAINS","CAVY","FEMALE")
-- insertPet("PLAINS","BIRD_DUCK","MALE")
-- insertPet("PLAINS","BIRD_DUCK","FEMALE")
-- insertPet("PLAINS","WATER_BUFFALO","MALE")
-- insertPet("PLAINS","WATER_BUFFALO","FEMALE")
-- insertPet("PLAINS","GOAT","MALE")
-- insertPet("PLAINS","GOAT","FEMALE")
-- insertPet("PLAINS","BIRD_GUINEAFOWL","MALE")
-- insertPet("PLAINS","BIRD_GUINEAFOWL","FEMALE")
-- insertPet("PLAINS","RABBIT","MALE")
-- insertPet("PLAINS","RABBIT","FEMALE")
-- insertPet("PLAINS","BIRD_PEAFOWL_BLUE","MALE")
-- insertPet("PLAINS","BIRD_PEAFOWL_BLUE","FEMALE")
-- insertPet("PLAINS","BIRD_TURKEY","MALE")
-- insertPet("PLAINS","BIRD_TURKEY","FEMALE")
-- insertPet("PLAINS","DOG","MALE")
-- insertPet("PLAINS","DOG","FEMALE")
-- insertPet("PLAINS","CAT","MALE")
-- insertPet("PLAINS","CAT","FEMALE")
-- insertPet("PLAINS","HORSE","MALE")
-- insertPet("PLAINS","HORSE","FEMALE")
-- insertPet("PLAINS","BIRD_CHICKEN","MALE")
-- insertPet("PLAINS","BIRD_CHICKEN","FEMALE")
-- insertPet("PLAINS","BIRD_GOOSE","MALE")
-- insertPet("PLAINS","BIRD_GOOSE","FEMALE")
-- insertPet("PLAINS","COW","MALE")
-- insertPet("PLAINS","COW","FEMALE")
-- insertPet("PLAINS","CANNON","NORMAL")

-- --gnomes
-- --- indigos decision. So far its all pet-exotic, as before.
-- insertPet("GNOMES","CLOCKWORK_BEETLE_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_MOUSE_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_SCORPION_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_CUCKOO_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_CANARY_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_CHICKEN_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_CAT_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_RACCOON_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_TORTOISE_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_MONKEY_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_FALCON_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_BADGER_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_DOG_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_CARP_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_SHEEP_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_PANTHER_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_GORILLA_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_SHARK_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_SPIDERTANK_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_HORSE_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_BEAR_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_CROCODILE_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_BULL_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_ELEPHANT_GNOME","61")
-- insertPet("GNOMES","CLOCKWORK_DRAGON_GNOME","61")

--succubi
insertPet("DECADENCE","TENTACLE_MONSTER","MALE")
insertPet("DECADENCE","BASILISK_LESSER","MALE")
insertPet("DECADENCE","BASILISK_LESSER","FEMALE")
insertPet("DECADENCE","BRUTE_DECAY","DEFAULT")
insertPet("DECADENCE","SOUL_WISP","DEFAULT")
insertPet("DECADENCE","NAHASH","MALE")
insertPet("DECADENCE","NAHASH","FEMALE")
insertPet("DECADENCE","ORTHUS","MALE")
insertPet("DECADENCE","ORTHUS","FEMALE")
insertPet("DECADENCE","CAUCHEMAR","MALE")
insertPet("DECADENCE","CAUCHEMAR","FEMALE")
insertPet("DECADENCE","PAIN_ELEMENTAL","DEFAULT")
insertPet("DECADENCE","BASILISK_LESSER","MALE")
insertPet("DECADENCE","BASILISK_LESSER","FEMALE")
insertPet("DECADENCE","IMP_FIRE","DEFAULT")
insertPet("DECADENCE","DEVILKIN","DEFAULT")

-- --warlocks
-- insertPet("WARLOCK","MONOLITH","GENERIC")
-- insertPet("WARLOCK","CRYSTAL","GENERIC")
-- insertPet("WARLOCK","ANIMATED_SCYTHE","SCYTHE_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","ANIMATED_KNIFE","KNIFE_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","ANIMATED_SCOURGE","SCOURGE_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","ANIMATED_PITCHFORK","PITCHFORK_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","ANIMATED_SERRATED_AXE","SERRATED_AXE_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","ANIMATED_BONESAW","BONESAW_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","ANIMATED_SLEDGEHAMMER","SLEDGEHAMMER_RHENAYAS_DARKLIGHT_IRON")
-- insertPet("WARLOCK","MEPHIT","FEMALE_AIR")
-- insertPet("WARLOCK","MEPHIT","MALE_ACID")
-- insertPet("WARLOCK","MEPHIT","FEMALE_ICE")
-- insertPet("WARLOCK","MEPHIT","MALE_FIRE")
-- insertPet("WARLOCK","PRISONER_HUMAN","MALE")
-- insertPet("WARLOCK","PRISONER_HUMAN","FEMALE")
-- insertPet("WARLOCK","PRISONER_DWARF","MALE")
-- insertPet("WARLOCK","PRISONER_DWARF","FEMALE")
-- insertPet("WARLOCK","PRISONER_ELF","MALE")
-- insertPet("WARLOCK","PRISONER_ELF","FEMALE")
-- insertPet("WARLOCK","PRISONER_GOBLIN","MALE")
-- insertPet("WARLOCK","PRISONER_GOBLIN","FEMALE")
-- insertPet("WARLOCK","PRISONER_KOBOLD","MALE")
-- insertPet("WARLOCK","PRISONER_KOBOLD","FEMALE")
-- insertPet("WARLOCK","PRISONER_ORC","MALE")
-- insertPet("WARLOCK","PRISONER_ORC","FEMALE")
-- insertPet("WARLOCK","PRISONER_DROW","MALE")
-- insertPet("WARLOCK","PRISONER_DROW","FEMALE")
-- insertPet("WARLOCK","PRISONER_GNOME","MALE")
-- insertPet("WARLOCK","PRISONER_GNOME","FEMALE")

-- --orcs
-- insertPet("TAIGA","DIRE_WOLF_ORC","MALE")
-- insertPet("TAIGA","DIRE_WOLF_ORC","FEMALE")
-- insertPet("TAIGA","SHAGGY_MUMAK","MALE")
-- insertPet("TAIGA","SHAGGY_MUMAK","FEMALE")
-- insertPet("TAIGA","STEPPE_AUROCHS","MALE")
-- insertPet("TAIGA","STEPPE_AUROCHS","FEMALE")
-- insertPet("TAIGA","ARCTIC_CONDOR","MALE")
-- insertPet("TAIGA","ARCTIC_CONDOR","FEMALE")
-- insertPet("TAIGA","TAIGA_SABRECAT","MALE")
-- insertPet("TAIGA","TAIGA_SABRECAT","FEMALE")
-- insertPet("TAIGA","SQUIG","MALE")
-- insertPet("TAIGA","SQUIG","FEMALE")
-- insertPet("TAIGA","SQUIG","WOOLY")
-- insertPet("TAIGA","SQUIG","GROWLER")
-- insertPet("TAIGA","SQUIG","TERRIER")

-- --kobolds
-- insertPet("KOBOLD_CAMP","SPIRIT_BEAR_KOBOLD","MALE")
-- insertPet("KOBOLD_CAMP","SHALSWAR","MALE")
-- insertPet("KOBOLD_CAMP","SHALSWAR","FEMALE")
-- insertPet("KOBOLD_CAMP","OGRE_KOBOLD","MALE")
-- insertPet("KOBOLD_CAMP","OGRE_KOBOLD","FEMALE")
-- insertPet("KOBOLD_CAMP","SPIDER_KOBOLD","MALE")
-- insertPet("KOBOLD_CAMP","SPIDER_KOBOLD","FEMALE")
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD","MALE")
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD","FEMALE")
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD_GIANT","MALE")
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD_GIANT","FEMALE")
-- insertPet("KOBOLD_CAMP","PSYCHOACTIVE_TOAD","MALE")
-- insertPet("KOBOLD_CAMP","PSYCHOACTIVE_TOAD","FEMALE")
-- insertPet("KOBOLD_CAMP","FISHER_GREMLIN","MALE")
-- insertPet("KOBOLD_CAMP","FISHER_GREMLIN","FEMALE")
-- insertPet("KOBOLD_CAMP","BIRD_KEA","MALE")
-- insertPet("KOBOLD_CAMP","BIRD_KEA","FEMALE")
-- insertPet("KOBOLD_CAMP","KEA_MAN","MALE")
-- insertPet("KOBOLD_CAMP","KEA_MAN","FEMALE")
-- insertPet("KOBOLD_CAMP","GIANT_KEA","MALE")
-- insertPet("KOBOLD_CAMP","GIANT_KEA","FEMALE")
-- insertPet("KOBOLD_CAMP","HONEY BADGER","MALE")
-- insertPet("KOBOLD_CAMP","HONEY BADGER","FEMALE")
-- insertPet("KOBOLD_CAMP","HONEY BADGER MAN","MALE")
-- insertPet("KOBOLD_CAMP","HONEY BADGER MAN","FEMALE")
-- insertPet("KOBOLD_CAMP","HONEY BADGER, GIANT","MALE")
-- insertPet("KOBOLD_CAMP","HONEY BADGER, GIANT","FEMALE")

-- --frostgiants
-- --- dont need pets, as they dont trade, nor be playable

-- --goblins
-- insertPet("EVIL","TROLL","MALE")
-- insertPet("EVIL","TROLL","FEMALE")
-- insertPet("EVIL","TROLL_CAVE","MALE")
-- insertPet("EVIL","TROLL_CAVE","FEMALE")
-- insertPet("EVIL","TROLL_BROOK","MALE")
-- insertPet("EVIL","TROLL_BROOK","FEMALE")
-- insertPet("EVIL","TROLL_SWAMP","MALE")
-- insertPet("EVIL","TROLL_SWAMP","FEMALE")
-- insertPet("EVIL","TROLL_WOOD","MALE")
-- insertPet("EVIL","TROLL_WOOD","FEMALE")
-- insertPet("EVIL","TROLL_SCAVENGER","MALE")
-- insertPet("EVIL","TROLL_SCAVENGER","FEMALE")

-- --drow
-- insertPet("DROW","RHENAYAS_DROW_SPIDER_GIANT","MALE")
-- insertPet("DROW","RHENAYAS_DROW_SPIDER_GIANT","FEMALE")
-- insertPet("DROW","RHENAYAS_DROW_LIZARD_GIANT","MALE")
-- insertPet("DROW","RHENAYAS_DROW_LIZARD_GIANT","FEMALE")
-- insertPet("DROW","RHENAYAS_DROW_ROTHE","MALE")
-- insertPet("DROW","RHENAYAS_DROW_ROTHE","FEMALE")

-- --automatons
-- --- dont need pets, as they dont trade, nor be playable

-- --hermit
-- insertPet("HERMIT","DOG","MALE")
-- insertPet("HERMIT","CAT","MALE")
-- insertPet("HERMIT","HAWK","MALE")
-- insertPet("HERMIT","COW","FEMALE")
-- insertPet("HERMIT","SHEEP","FEMALE")
-- insertPet("HERMIT","CHICKEN","FEMALE")