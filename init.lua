-- Succubus fortress
-- This file will run fixes and tweaks when you load your saves

-- Fix the summoned creatures skills
if dfhack.isMapLoaded() then
	dfhack.run_script('fooccubus-skills')
end