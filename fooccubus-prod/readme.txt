# Succubus Dungeon #

Succubus Dungeon is a mod for vanilla Dwarf Fortress featuring a new 'evil' civ.

# Features #
* A new race.
* 2 new civilizations to play with in both fort and adventurer mode.
* A workshop, the summoning circle, where you can call on various beasts.
* 2 new metals : Stygian Bronze and Orichalcum
* The ablity to build whips.
* Dwarven sieges.

# Installation #
* Install dfhack r3 if you do not have it already (available at : http://www.bay12forums.com/smf/index.php?topic=91166.0)
* Extract the archive in your DF folder, preserving the folder structure.
* Overwrite the entity_default file in the optional folder with the one provided to add dwarven sieges (see below).
* Make sure the temperature feature is activated. It should be by default on most versions of DF.
* Generate a new world and select a succubus civilization to start playing.
* To uninstall, simply delete the *_fooccubus files from your raws folder.

## Dwarves and goblins ##
These two entities lack the tags needed to interact with you in fortress mode. To have them pay a visit, replace the entity_default 
with the one included in the 'optional' folder of the archive. The changes will not affect your play as a dwarf civ.

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

# Summoning a creature #
* You can embark with Soul Wisps, those pets are used as a fodder for summoning.
* Migrants and caravans will bring additional wisps.
* In order to summon a creature, you must install a summoning circle and a pasture next to each other.
* Pasture one or more soul wisp next to the circle.
* The soul wisp will be replaced with the target creature.

## Regular succubi summons ##
* Hellhound :  An aggressive cousin of the dog, can be trained to serve as a bodyguard.
* Nightmare : A tireless grazer, can be milked or trained for war. Beware of its powerful kick.
* Fire imp : A small humanoid surrounded by fire they can hurl at their enemies.
* Pain elemental : A weak creature that will explode when attacked.
* Basilisk : A large reptile breathing poisonous vapors. Its horn can be sheared for orichalcum.

## Summons for both civs ##
* Nahash : Vermin hunting snake. It can be bred for its eggs.
* Tentacle monster : Excellent wrestler. Can be milked for slime.

## New materials ##
* Stygian bronze : Made from bronze, flux stone and a secret ingredient. It is much lighter then regular bronze.
* Oricalchum : A light and very solid metal. Can be made at a smelter using basilisk horns.

# Known issues #
* Upon leaving, traders will "kidnap" their own pets, this has little incidence to your fort.
* Sold creatures does not count towards the export values.

# Contact #
If you have trouble using this mod, please post a message on the mod thread in the Bay 12 forum :
http://www.bay12forums.com/smf/index.php?topic=124135.0
