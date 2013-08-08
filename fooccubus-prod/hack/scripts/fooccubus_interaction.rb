# Succubus mod interaction manager, completing the mod's interactions
# Requires a command followed by a creature ID
 
# methods
 
# Fetch the unit
def getUnit unitId
	unit = df.unit_find(unitId)
	raise "No unit found" if not unit
	return unit
end
 
# Remove the tame flag from
def untame unit
	unit.flags1.tame = false
	unit.training_level = :WildUntamed
end
 
# Pull the natural skills from a creature's raw and set them
def naturalSkills unitId
	#...
end
 
# execution
raise "This script need a command followed by a creature ID." if $script_args.length < 2
unit = getUnit($script_args[1].to_i)
 
case $script_args[0]
	when "untame"
		untame(unit)
	when "naturalSkills"
		naturalSkills(unit)
	else
		raise "Unknown command: " + script_args[0]
end