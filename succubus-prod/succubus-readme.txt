Succubus Dungeon
================

Succubus Dungeon is a mod for vanilla and Masterwork Dwarf Fortress featuring a new evil civ. It is developed one feature at a time and new features is added regularly.

Features
--------

* A new race.
* Fast and fire immune citizens.
* The reintroduction of classic lore into Dwarf Fortress such as 40d demons.
* Generate magma anywhere, make magma forges, traps, waterfalls...
* Generating slade blocks to build an authentic demonic spire.
* Generate fuel for your forges out of thin air.
* Capture invaders and turn them into half demons.
* Summon powerful creatures to your side, some are intelligent and can join your military.

Installation
------------

* Install Dwarf Fortress 44.05, using a starter pack is recommended.
* Install dfhack for the appropriate DF version.
* Extract the archive in your DF folder, preserving the folder structure.
* Generate a new world and select a succubus civ to play.

### IMPORTANT: Selecting your race at the embark screen
* By default, only the succubi are playable, but if you add other mods, you may have several choices.
* Press tab before embarking until seeing a list of civilization names.
* Press + and - to chose a civ that uses the cabinet tile (π) to display its colonies on the map.
* Pressing tab again until seeing the list of neighbors will confirm your choice, your selected race is the first one.

Playing as Succubi
------------------

### Magma

Magma is a major resource for this race. Succubi are immune to heat and many of their workshops are powered by molten rock. Buildings marked with a star '*' in its name must be powered by magma. You can easily provide magma to your dungeon by building a magma well. With this workshop, a pump operator create a magma "aquifer". To do so, channel a canal in one direction from the well and run the appropriate reaction. The same magma well can also stop all those flows anytime you wish.

Here's an example :
```
  Z       Z-1
+++++    +++++ 
+WWW+    +++++
+WWW.    ++++~ -> After channeling the east side, the well created a flow in this direction.
+WWW+    +++++
+++++    +++++
```

Unfortunatly the game does not allow your citizens to walk in magma. If a succubus is stuck because a puddle is in her way, you can wait for it to evaporate or dig around. Succubi inside magma will still evacuate without burning clothing or weapons but hauled items will be likely destroyed. Also, remember that magma is a liquid and someone can drown in it.

If your succubi are running out of drinks, you can dig a magma channel next to a still and create a special drink.

### Magma or water used in reactions

Some jobs will claim to consume magma or water. This means that it will draw one level of the liquid from a tile located one z-level below the workshop. This will also work if the liquid is located next to the workshop one z-level below (ie after channeling a canal to it).

For example, those two configurations are valid :

```
+ = floor
W = workshop
~ = water/magma
. = open space

  Z       Z-1
+++++    +++++ 
+WWW+    +~~~+
+WWW+    +~~~+ -> 3x3 workshop built over a 3x3 reservoir
+WWW+    +~~~+
+++++    +++++


  Z         Z-1
+++++++   +++++++ 
+WWW+++   +++++++
+WWW...   ++++~~~ -> 3x3 workshop next to a channel filled with liquid
+WWW+++   +++++++
+++++++   +++++++
```

### Construction materials

Slade can be generated at no cost in an underworld drill to help you build your spires. However, its extreme weight implies that slade projects will take more time and builders to complete. A smart usage of stockpiles and wheelbarrows is recommended.

If you wish to make a glass tower instead, glass blocks can easily be produced using the Floating Glass Furnace, built using a tin bar. This workshop is ten times more efficient than a regular glass furnace.

### New metals

Because the succubi wish to reshape the world in their image, you will obtain of new materials to build with:
* Afelsteel: This corrupted steel is extremely dense, making it great for weaponsmithing.
* Stygium: An unaturally light bronze providing your succubi a decent protection without reducing their speed.

These materials are acquired through trading.

### Summoning

You can spawn pets in your fort by building a summoning portal over a magma pit. Evil pets are useful for various tasks or can be butchered for food. A description of each pets abilities will be displayed while selecting the jobs from the summoning portal itself. Some creatures summoned from the portal are also intelligent and can perform civilian tasks or join the military.

### Corruption

An unique feature from the succubi is their ability to twist the bodies and souls of their guests at their image. Their victims are turned into hybrids with various abilities depending of their former race. This is done at the den of iniquity. Running the 'Corrupt prisoners' job will transform nearby sentients and have them join your civilization. This include caged invaders if their cages are visible and close enough. Merchants and their guards can also join your forces in the process, but their pack animals will flee or go insane.

Corrupting prisoners is compatible with the Fortress Defense mod.

### Adventuring as a succubus

Civilizations living in dark fortresses are not as well developed than dwarven or human ones for adventure. As a result, a succubus starts at an empty pit without the ability to fast travel. It is recommended that you start playing as a succubus assimilated into another civilization, preferably human (# tiles on the world map) or dwarven (Ω tiles on the world map).

If you start in a pit, you can open the regional map (shift + Q) to spot the nearest dark fortress then travel by foot in this direction to find people to talk to. Wandering around, you may also find dungeons with equipment and towers with population on its roof. If you are unable to reach the roof, try pressing alt+direction to open the hatch above your head.

You can also play as a Frog Demon. Try biting people!

### Known issues

* Embarking as dwarves? See "Selecting your race at the embark screen" above.
* Changing graphics in the Lazy Newb Pack deletes the mod. You'll have to reinstall it afterwards.
* Upon reaching your site's edge, traders will "kidnap" their own pets, this has no consequenses to your fort.
* If a frog demon refuses to work or join the military, wait 3 days of game time and try again.

### Contact

If you have trouble using this mod, please post a message on the mod thread in the Bay 12 forum :
http://www.bay12forums.com/smf/index.php?topic=124135.0
