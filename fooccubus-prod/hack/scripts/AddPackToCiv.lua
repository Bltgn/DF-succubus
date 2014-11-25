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
			for kk,vv in pairs(v.resources.animals.pack_animal_races) do
				--print(kk,vv,v.resources.animals.pack_animal_castes[kk])
				local checkrace = df.creature_raw.find(vv)
				local checkcaste = checkrace.caste[v.resources.animals.pack_animal_castes[kk]]
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
					v.resources.animals.pack_animal_races:insert('#',racenum)
					v.resources.animals.pack_animal_castes:insert('#',castenum)
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
-- insertPet("MOUNTAIN","TUSKOX_MOUNTAIN_DDD","MALE")
-- insertPet("MOUNTAIN","TUSKOX_MOUNTAIN_DDD","FEMALE")

-- --elves

-- --humans
-- insertPet("PLAINS","HORSE","MALE")
-- insertPet("PLAINS","HORSE","FEMALE")
-- insertPet("PLAINS","ARMORED_HORSE","MALE")
-- insertPet("PLAINS","ARMORED_HORSE_IRON","MALE")

-- --gnomes

--succubi
insertPet("DECADENCE","CAUCHEMAR","MALE")
insertPet("DECADENCE","CAUCHEMAR","FEMALE")

-- --warlocks
-- insertPet("WARLOCK","PRISONER_HUMAN","MALE")
-- insertPet("WARLOCK","PRISONER_DWARF","MALE")
-- insertPet("WARLOCK","PRISONER_ELF","MALE")
-- insertPet("WARLOCK","PRISONER_GOBLIN","MALE")
-- insertPet("WARLOCK","PRISONER_KOBOLD","MALE")
-- insertPet("WARLOCK","PRISONER_ORC","MALE")
-- insertPet("WARLOCK","PRISONER_DROW","MALE")
-- insertPet("WARLOCK","PRISONER_GNOME","MALE")

-- --orcs
-- insertPet("TAIGA","SHAGGY_MUMAK","MALE")
-- insertPet("TAIGA","SHAGGY_MUMAK","FEMALE")
-- insertPet("TAIGA","STEPPE_AUROCHS","MALE")
-- insertPet("TAIGA","STEPPE_AUROCHS","FEMALE")

-- --kobolds
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD_GIANT","MALE")
-- insertPet("KOBOLD_CAMP","RAT_KOBOLD_GIANT","FEMALE")

-- --frostgiants
-- --- no trading for frost giants.

-- --goblins
-- insertPet("EVIL","TROLL","MALE")

-- --drow
-- insertPet("DROW","RHENAYAS_DROW_ROTHE","MALE")
-- insertPet("DROW","RHENAYAS_DROW_ROTHE","FEMALE")

--automatons
-- no trading for them.