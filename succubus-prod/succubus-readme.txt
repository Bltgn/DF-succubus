# Succubus Dungeon #

Succubus Dungeon is a mod for vanilla Dwarf Fortress featuring a new 'evil' civ.

# Features #
* A new race.
* 2 new civilizations to play with in both fort and adventurer mode.
* A workshop, the summoning circle, where you can call on various beasts.
* Converting your caged prisoners to your side.
* 2 new metals : Stygian Bronze and Orichalcum.
* Temples : Provides upgrades, interactions and spells that can affect the entire site.
* Ranged weapons with explosive ammo.
* The ability to build whips.
* Dwarven sieges.

# Installation #
* Install dfhack r4 if you do not have it already (available at http://dffd.wimbli.com/)
* Extract the archive in your DF folder, preserving the folder structure.
* Overwrite the entity_default file in the optional folder with the one provided to add dwarven sieges (see below).
* Make sure the temperature feature is activated. It should be by default on most versions of DF.
* Generate a new world and select a succubus civilization to start playing.
* To uninstall, simply delete the new txt files from your raws folder and the succubus folder from your hack/script folder.

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

# The civilizations #
* Royalist Succubi
A caste of demons that escaped hell and fell in love with the surface. They value crafting and arts above anything else. Their
ties with hell allow them to summon various creatures to their help and infuse bronze with unnatural properties. Even prisoners
will be tempted to embrace their ways.

* Deep succubi
Small cults of succubi who believe that the world is doomed and must be prepared for the return of the ancient gods. Each cult
must survive on its own against all the other civilizations. As a result they rely on their dark powers to turn members of other
races into half breeds to strengthen their numbers.

# Summoning a creature #
* In order to summon a creature, you must build a summoning circle using a totem and a construction material.
* Various jobs require different items, selecting an unavailable task will give your a list.
* When applicable, the resulting gender of the summoned creature will be chosen randomly.
* Most creatures are not tamed but act friendly.

# Taming the summoned creatures #
* To train those creatures, you must first build a cage within an animal training activity zone.
* Assign the creature to the cage.
* In the animal screen assign a trainer. She will get to work.
* You can release the creature one it is tamed by linking a cage to a lever and pulling it.

## Summons for both civs ##
* Nahash : Vermin hunting snake. It can be bred for its eggs.
* Tentacle monster : Excellent wrestler. Can be milked for slime.

## Royalist succubi summons ##
* Hellhound : An aggressive cousin of the dog, can be trained to serve as a bodyguard.
* Nightmare : A tireless grazer, can be milked or trained for war. Beware of its powerful kick.
* Fire imp : A small humanoid surrounded by fire they can hurl at their enemies.
* Pain elemental : A weak creature that will explode when attacked.
* Basilisk : A large reptile breathing poisonous vapors. Its horn can be sheared for orichalcum.

## Deep succubi summon ##
* Rat thing : A large rate that hunts vermin and can teleport towards enemies.
* Sothoth spawn : An huge monster that will turn itself invisible to its enemies. Its slime will damage its victims bodies.

# Turning prisoners in you side #
Both civs have access to a special building allowing them to turn citizen of other civilization to your fort.
* The deep succubi variant is more powerful as it also transform prisoners who will act as full citizens.
* To turn prisoners, install their cages near a den of iniquity or a torture chamber then execute the charm/corrupt prisoner job.
* These jobs use the alchemy labor.
* Prisoners within line of sight will be made member of your civilization.

The deep succubi will also transform prisoners into half breeds :
* Humans and elfves become cambions : They are more enduring and have a better animal training skill.
* Dwarves become devils : They can enter martial trances and have good mechanics skill. They are however, shorter.
* Goblins become hellions : They are more enduring and do not need to eat.
* Kobolds become imps : They are small but are great at dodging and using knives.

## New materials ##
* Stygian bronze : Made from bronze and flux stone. It is much lighter then regular bronze.
* Basiliskine : A light and very solid metal. Can be made at a smelter using basilisk horns.

# Known issues #
* Upon leaving, traders will "kidnap" their own pets, this has little incidence to your fort.
* Sold creatures does not count towards the export values.
* The harvest soul jobs sometimes fails. In this case, queuing the job twice will fix the issue.

# Contact #
If you have trouble using this mod, please post a message on the mod thread in the Bay 12 forum :
http://www.bay12forums.com/smf/index.php?topic=124135.0
