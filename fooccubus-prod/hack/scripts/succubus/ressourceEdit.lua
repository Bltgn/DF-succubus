-- Adds several creatures as pets to the civ
local my_entity=df.historical_entity.find(df.global.ui.civ_id)

--Display what pets are currently available
printall(my_entity.resources.animals)
for k,v in pairs(my_entity.resources.animals.pet_races) do
	print(k, v, df.creature_raw.find(v).creature_id)
end
printall(my_entity.resources.animals.pet_castes)



--Uncomment lines to activate code!

--ELF funny stuff (on vanilla raws at least)
--my_entity.resources.animals.pet_races:insert('#',my_entity.race+2)
--my_entity.resources.animals.pet_races:insert('#',my_entity.race+2)
--my_entity.resources.animals.pet_castes:insert('#',0)
--my_entity.resources.animals.pet_castes:insert('#',1)

--do the same for wagon_races and wagon_castes if you also want them as wagon-pullers


--adds WATER to the extracts list so you can buy barrels of water to dump into a cistern?
--my_entity.resources.misc_mat.extracts.mat_type:insert('#',6)
--my_entity.resources.misc_mat.extracts.mat_index:insert('#',0)
