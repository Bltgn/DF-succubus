-- Succubus Spire
-- This file will run fixes and tweaks when you load your saves

-- Make sure that commands are only run if you play as a succubus
function isCiv(civ)
    local entity = df.global.world.entities.all[df.global.ui.civ_id]
    return entity.entity_raw.code == civ
end

-- Attach a hook on the 'loaded' state change
dfhack.onStateChange.loadConstructCreature = function(code)
    if code == SC_MAP_LOADED then
        if not isCiv('SUCCUBUS') then
            return
        end

        -- They will not care about being naked :)
        dfhack.run_script('succubus/fixnakedregular')

        -- Immediate unlocking of magma workshops + hint in the announcement log
        if df.global.gamemode == df.game_mode.DWARF then
            dfhack.run_script('succubus/feature', 'magmaWorkshops')
        end
    end
end