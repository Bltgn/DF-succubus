# Succubus Dungeon #

Succubus Dungeon is a mod for vanilla and Masterwork Dwarf Fortress featuring a new evil civ.

# Features #
* A new race
* Fast and fire immune citizens.
* The reintroduction of classic lore into Dwarf Fortress such as 40d demons
* Spawning magma at will
* Generating slade blocks to build an authentic demonic spire.
* Corrupting enemies and allies, pushing them into joining your side.

# Installation #
* Install DF 40.24+ with DFHack r3
* Extract the archive in your DF folder, preserving the folder structure.
* Make sure the temperature feature is activated. It should be on most versions of DF.
* Generate a new world and select a succubus civ to play.

# Selecting your civ at the embark screen #
* Press tab before embarking until seeing a list of civilization names.
* Press + and - to chose a civ that uses the 'cabinet' tile to display its colonies on the map.
* Pressing tab again until seeing the list of neighbors will confirm your choice, your selected race is the first one.

## Dwarves ##
The dwarven entities lack the tags needed to interact with you in fortress mode. To have them pay a visit to your dungeons, replace the entity_default with the one included in the 'optional' folder of the archive. The changes will not affect your play as a dwarf civ.

If this conflict with another mod, you can add the tags manually :
* Add the following to the MOUNTAIN entity, in entity_default.txt
 [PROGRESS_TRIGGER_POPULATION:2]
 [PROGRESS_TRIGGER_PRODUCTION:2]
 [PROGRESS_TRIGGER_TRADE:2]
 [PROGRESS_TRIGGER_POP_SIEGE:4]
 [PROGRESS_TRIGGER_PROD_SIEGE:3]
 [PROGRESS_TRIGGER_TRADE_SIEGE:3]

# Magma #
Buildings marked with a star '*' must be powered by magma. Those are unlocked even if you did not reach the magma sea. Building a magma well (under the furnace menu) will allow you to spawn some at will. Be warned that spawning a large batch of magma will cause it to 'soak' walls and go through them.

Unfortunatly the game prevent your citizens from walking in magma, even if that does not harm them, and you might find yourself with stuck succubi in corridors. This is why it is best to separate your magma operations from your fort and dig evacuation paths beforehand.

If a succubus is stuck, you can wait for it to evaporate, dig around, or find a way to push her in the magma. Succubi inside magma will move as needed to reach a meeting area. Clothing and weapons will not burn off a succubus but hauled items will.

# Corrupting prisoners #
So you have caged enemies in your fort, why not put them into work? You can transform your enemies into demons by building a Den of iniquity. It has a reaction inside that will let the worker transform every human, elf, kobold, dwarf and even goblin in a range of 10 squares. Once changed, they will act as citizens and can join the ranks of the military, while retaining memories and skills of their former lives. This is also compatible with the fortress defense mod's races.

It is possible to convert traders too. A goblin caravan can join you if you build a den next to your depot. They'll bring their pack animals along and destroy their wagons in the process. However the trading inventory will stay in the trade depot. You will have to deconstruct it to seize the goods. Several of the trading animals will still be sent back home as a 'thank you' note.

# Known issues #
* Upon reaching your site's edge, traders will "kidnap" their own pets, this has no consequenses to your fort.
* Changing graphics in the Lazy Newb Pack deletes the mod, you'll have to reinstall it afterwards.

# Contact #
If you have trouble using this mod, please post a message on the mod thread in the Bay 12 forum :
http://www.bay12forums.com/smf/index.php?topic=124135.0
