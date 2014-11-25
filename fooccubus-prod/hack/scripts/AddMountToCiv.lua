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
			for kk,vv in pairs(v.resources.animals.mount_races) do
				--print(kk,vv,v.resources.animals.mount_castes[kk])
				local checkrace = df.creature_raw.find(vv)
				local checkcaste = checkrace.caste[v.resources.animals.mount_castes[kk]]
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
					v.resources.animals.mount_races:insert('#',racenum)
					v.resources.animals.mount_castes:insert('#',castenum)
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
-- insertPet("MOUNTAIN","ARMORED_BEAR_GRIZZLY","MALE")
-- insertPet("MOUNTAIN","ARMORED_BEAR_GRIZZLY_IRON","MALE")
-- insertPet("MOUNTAIN","CRAGTOOTH_BOAR_DDD_IRON","MALE")
-- insertPet("MOUNTAIN","CRAGTOOTH_BOAR_DDD_STEEL","MALE")

-- --elves
-- insertPet("FOREST","DEER","FEMALE")
-- insertPet("FOREST","DEER","MALE")
-- insertPet("FOREST","UNICORN","FEMALE")
-- insertPet("FOREST","UNICORN","MALE")

-- --humans
-- insertPet("PLAINS","HORSE","MALE")
-- insertPet("PLAINS","HORSE","FEMALE")
-- insertPet("PLAINS","ARMORED_HORSE","MALE")
-- insertPet("PLAINS","ARMORED_HORSE_IRON","MALE")

-- --gnomes
-- insertPet("GNOMES","SKUNK","MALE")
-- insertPet("GNOMES","BOBCAT","MALE")

--succubi
insertPet("DECADENCE","TENTACLE_MONSTER","MALE")
insertPet("DECADENCE","BASILISK_LESSER","MALE")
insertPet("DECADENCE","SHOTHOTH_SPAWN","DEFAULT")
insertPet("DECADENCE","CAUCHEMAR","MALE")
insertPet("DECADENCE","CAUCHEMAR","FEMALE")

--warlocks
-- no mounts, because of opposed to life infighting. Warlocks are bad enough as is, without mounts

-- --orcs
-- insertPet("TAIGA","DIRE_WOLF_ORC","MALE")
-- insertPet("TAIGA","DIRE_WOLF_ORC","FEMALE")

-- --kobolds
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD_GIANT","MALE")
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD_GIANT","FEMALE")

-- --frostgiants
-- -- too large for mounts.

-- --goblins
-- insertPet("EVIL","JABBERER","MALE")
-- insertPet("EVIL","JABBERER","FEMALE")
-- insertPet("EVIL","RUTHERER","MALE")
-- insertPet("EVIL","RUTHERER","FEMALE")
-- insertPet("EVIL","VORACIOUS_CAVE_CRAWLER","MALE")
-- insertPet("EVIL","VORACIOUS_CAVE_CRAWLER","FEMALE")
-- insertPet("EVIL","HYENA","MALE")
-- insertPet("EVIL","HYENA","FEMALE")
-- insertPet("EVIL","BARGHEST","MALE")
-- insertPet("EVIL","BARGHEST","FEMALE")

-- --drow
-- insertPet("DROW","RHENAYAS_DROW_SPIDER_GIANT","MALE")
-- insertPet("DROW","RHENAYAS_DROW_SPIDER_GIANT","FEMALE")
-- insertPet("DROW","RHENAYAS_DROW_LIZARD_GIANT","MALE")
-- insertPet("DROW","RHENAYAS_DROW_LIZARD_GIANT","FEMALE")

-- --automatons
-- insertPet("AUTOMATON","CLOCKWORK_HORSE_GNOME","61")