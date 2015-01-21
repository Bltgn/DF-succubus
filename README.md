# Succubus Dungeon #

Succubus Dungeon is a mod for vanilla and Masterwork Dwarf Fortress featuring a new evil civ.

# Features #
* A new race
* Fast and fire immune citizens
* Spawning magma at will
* Generating slade blocks to build an authentic spire

# Installation #
* Install DF 40.23 with DFHack r1
* Extract the archive in your DF folder, preserving the folder structure.
* Make sure the temperature feature is activated. It should be by default on most versions of DF.
* Generate a new world
* To uninstall, simply delete the new txt files from your raws folder and the succubus folder from your hack/script folder.

# Chosing your civ at the embark screen #
* Press tab before embarking until seeing a list of civilization name.
* Press + and - to chose a civ using the 'cabinet' tile to display its colonies on the map.
* Pressing tab again until seeing the lis ton neighbors will confirm you chose, your selected race is at the top.

## Dwarves and goblins ##
These two entities lack the tags needed to interact with you in fortress mode. To have them pay a visit, replace the
entity_default with the one included in the 'optional' folder of the archive. The changes will not affect your play as a dwarf civ.

If this conflict with another mod, you can add the tags manually :
* Add the following to the MOUNTAIN entity :
[PROGRESS_TRIGGER_POPULATION:3]
[PROGRESS_TRIGGER_PRODUCTION:2]
[PROGRESS_TRIGGER_TRADE:2]
[PROGRESS_TRIGGER_POP_SIEGE:4]
[PROGRESS_TRIGGER_PROD_SIEGE:3]
[PROGRESS_TRIGGER_TRADE_SIEGE:3]

* Add the following to the EVIL entity :
[COMMON_DOMESTIC_PACK]

# Known issues #
* Upon leaving, traders will "kidnap" their own pets, this has little incidence to your fort.
* Sold creatures does not count towards the export values.

# Contact #
If you have trouble using this mod, please post a message on the mod thread in the Bay 12 forum :
http://www.bay12forums.com/smf/index.php?topic=124135.0
