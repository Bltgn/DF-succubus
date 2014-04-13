args={...}

local function alreadyHasSyndrome(unit,syn_id) --taken from Putnam's itemSyndrome
    for _,syndrome in ipairs(unit.syndromes.active) do
        if syndrome.type == syn_id then return true end
    end
    return false
end

local function assignSyndrome(target,syn_id) --taken from Putnam's itemSyndrome
    if target==nil then
        return nil
    end
    if alreadyHasSyndrome(target,syn_id) then
        local syndrome
        for k,v in ipairs(target.syndromes.active) do
            if v.type == syn_id then syndrome = v end
        end
        if not syndrome then return nil end
        syndrome.ticks=1
        return true
    end
    local newSyndrome=df.unit_syndrome:new()
    local target_syndrome=df.syndrome.find(syn_id)
    newSyndrome.type=target_syndrome.id
    newSyndrome.year=df.global.cur_year
    newSyndrome.year_time=df.global.cur_year_tick
    newSyndrome.ticks=0
    newSyndrome.unk1=0
    for k,v in ipairs(target_syndrome.ce) do
        local sympt=df.unit_syndrome.T_symptoms:new()
        sympt.ticks=0
				sympt.unk1=0
				sympt.unk2=0
        sympt.flags=2
        newSyndrome.symptoms:insert("#",sympt)
    end
    target.syndromes.active:insert("#",newSyndrome)
    if itemsyndromedebug then
        print("Assigned syndrome #" ..syn_id.." to unit.")
    end
    return true
end

function effect(etype,unitTarget)
	local syndromes = dfhack.matinfo.find(etype).material.syndrome
	for j = 0, #syndromes -1, 1 do
		assignSyndrome(unitTarget,syndromes[j].id)
	end
end

local etype = args[1]
local unit = df.unit.find(tonumber(args[2]))

effect(etype,unit)
