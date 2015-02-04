-- Will remove bad thoughts related to clothing on a regular basis
--[[

    This script remove the thought related to the lack of clothing (old clothing thoughts are skipped).
    It will call itself after x days of ingame time. (default, 7 days)
    This loop is cleared by dfhack when the save is unloaded.

    Based on fixnaked

    @author Boltgun
    @todo broken, need to look at the right place first
    @todo update the stress level
    @todo Support for multi race forts, should be done after the tavern arc

]]

-- Set to true to display the # of thoughts removed
local debug = true

-- The delay before another loop, higher for better performances, lower for faster removal
local delay = 7

function fixnaked()
    local total_fixed = 0
    local total_removed = 0

    for fnUnitCount,fnUnit in ipairs(df.global.world.units.all) do
        if fnUnit.race == df.global.ui.race_id then
            local listEvents = fnUnit.status.recent_events

            local found = 1
            local fixed = 0
            while found == 1 do
                local events = fnUnit.status.recent_events
                found = 0
                for k,v in pairs(events) do
                    if v.type == df.unit_thought_type.Uncovered
                       or v.type == df.unit_thought_type.NoShirt
                       or v.type == df.unit_thought_type.NoShoes
                       or v.type == df.unit_thought_type.NoCloak
                    then
                        events:erase(k)
                        found = 1
                        total_removed = total_removed + 1
                        fixed = 1
                        break
                    end
                end
            end

            if fixed == 1 then
                total_fixed = total_fixed + 1
                if(debug) then print(total_fixed, total_removed, dfhack.TranslateName(dfhack.units.getVisibleName(fnUnit))) end
            end
        end
    end

    if(debug) then print("Total Fixed: "..total_fixed) end
end

fixnaked()
dfhack.timeout(delay, 'days', function() dfhack.run_script('fixnakedregular') end)
