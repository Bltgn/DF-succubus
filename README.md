Succubus Dungeon
================

Succubus Dungeon is a mod for vanilla and Masterwork Dwarf Fortress featuring a new evil civ. It is developed one feature at a time and new features is added regularly.

Features
--------

* A new race.
* Fast and fire immune citizens.
* Generate magma anywhere, make magma forges, traps, waterfalls...
* Generating slade blocks to build an authentic demonic spire.
* Generate fuel for your forges out of thin air.
* Capture invaders and turn them into half demons.
* Summon powerful creatures to your side, some are intelligent and can join your military.

Installation
------------

* Install Dwarf Fortress 44.12 with dfhack, using a starter pack is recommended.
* Extract the archive in your DF folder, preserving the folder structure.
* Generate a new world and select a succubus civ to play.

### IMPORTANT: Selecting your race at the embark screen
* By default, only the succubi are playable, but if you add other mods, you may have several choices.
* Press tab before embarking until seeing a list of civilization names.
* Press + and - to chose a civ that uses the cabinet tile (π) to display its colonies on the map.
* Pressing tab again until seeing the list of neighbors will confirm your choice, your selected race is the first one.

Playing as Succubi
------------------

### Nobles and Positions

Here are the administratives positions and their dwarven equivalents :
* Dungeon matron and Spire matriarch -> Expedition Leader and Mayor
* Keeper of Secrets -> Both Book Keeper and Manager, enable accounting and the job manager
* Greedy Dealer -> Broker
* Lady of Pain -> Militia commander, enable military orders
* Battle Guide -> Militia captain
* Enforcer and Oppressor -> Sheriff and Captain of the guard, enable justice
* Whipper -> Hammerer, they also handle unhappy workers
* Wound Mender -> Chief medial dwarf

The civiliation nobles are as usual with a monarch, a general and priestess plus local regents who can designate champions.

### Magma

Magma is a major resource for this race. Succubi are immune to heat and many of their workshops are powered by molten rock. Buildings marked with a star in its name must be powered by magma. You can easily provide magma to your dungeon by building a magma well. With this workshop, a pump operator create a magma "aquifer". To do so, channel a canal in one direction from the well and run the appropriate reaction. The same magma well can also stop all those flows anytime you wish.

Here's an example :
```
  Z       Z-1
+++++    +++++ 
+WWW+    +++++
+WWW.    ++++~ -> After channeling the east side, the well created a flow in this direction.
+WWW+    +++++
+++++    +++++
```

The game being designed for creatures that die in magma, movement and pathing may behave strangely. Succubi may walk into magma and their clothing will not be affected, but hauled items or wagons will burn. If you construct a magma moat, it is best to fill at 6 or 7 levels deep or else caravans will got for a dip.

### Magma or water used in reactions

Some jobs will claim to consume magma or water. This means that it will draw liquid from a tile located one z-level below or nest to the workshop.

Those two configurations are valid :
```
+ = floor
W = workshop
~ = water/magma
. = open space

  Z       Z-1
+++++    +++++ 
+WWW+    +~~~+
+WWW+    +~~~~ -> 3x3 workshop built over a reservoir.
+WWW+    +~~~+
+++++    +++++


  Z         Z-1
++++++   ++++++ 
+WWW++   ++++++
+WWW..   ++++~~ -> 3x3 workshop next to a channel filled with liquid
+WWW++   ++++++
++++++   ++++++
```

### Construction materials

Slade can be generated at no cost in an underworld drill to help you build your spires. However, its extreme weight implies that slade projects will take more time and builders to complete. A smart usage of stockpiles and wheelbarrows is recommended.

If you wish to make a glass tower instead, glass blocks can easily be produced using the Floating Glass Furnace, built using a tin bar. This workshop is ten times more efficient than a regular glass furnace.

### Summoning

You can spawn pets in your fort by building a summoning portal over a magma pit. Evil pets are useful for various tasks or can be butchered for food. A description of each pets abilities will be displayed while selecting the jobs from the summoning portal itself. Some creatures summoned from the portal are also intelligent and can perform civilian tasks or join the military.

### Corruption

An unique feature from the succubi is their ability to twist the bodies and souls of their guests at their image. Their victims are turned into hybrids with various abilities depending of their former race. This is done at the den of iniquity. Running the 'Corrupt prisoners' job will transform nearby sentients and have them join your civilization. This include caged invaders if their cages are visible and close enough. Merchants and their guards can also join your forces in the process, but their pack animals will flee or go insane.

### Giving powers to your succubi

The Altar of Sin provides give additional interactions to your succubi. Those are seperated in major and minor categories with major providing several buffs and interactions and minor providing single spells. Each succubus can only acquire one minor and one major spell so you will have to discover the best combos and spread your upgrades among the key citizens of your fort.

To select the target of an upgrade, you must use the workshop profile (Shift + P after selecting a Keeper of Secrets) and restrict the usage to only one worker. If the target is in the military, you will need to put the squad off duty until the target has acquired the power.

#### Major powers

Major powers act as secrets like necromancy does in vanilla and, in rare cases, will be researched by historical figures. While the succubi are already immortal, member from other races will be granted immortality upon acquiring one of those.

The secrets of lust: a crowd control focused power. The user becomes a courtesan and gain immununity to fear plus the following interactions:
* Release pheromones: Emit a cloud of pheromones that render nearby succubi immune to pain while stunning and paralyzing enemies.
* Entice targets: Drop the targets strength and sometimes cause them to drop their weapons. Only work on intelligent targets.
* Sing an alluring song: Make the enemy slow and crazy for a short time, causing them to hit each other for a short time. The target may also flee in terror afterwards. Only work on intelligent targets.
* Draining kiss: Drop the target's attributes while buffing the user. The target may also fall asleep. The user must touch the enemy.
* A periodic 'lusty' bonus is indicated by a blinking purple question mark and allow the user to "release" themselves, gaining a big boost in speed and strength.

The secrets of Hellfire: a destructive power. The user becomes a pyromaniac and gain immunity to fear, increased aggressiveness and the following interaction:
* Breath flames: Emit a cone of fire.
* Throw fireball: A longer range fire attack.
* Raise cloud of ash: Help breaking lines of sight while escaping.
* Spray dragonfire from magma: An cone of dragonfire, the user must stand in a square of magma that is not full to be able to do this.

The secrets of depravity: a support oriented power that empower allies at the cost of the user's own abilities. The user becomes a debauchee and lose 20% of its attributes permanently in exchange of paralysis, pain, nausea and fever immunity plus the following:
* Release pheromones: Emit a cloud of pheromones that render nearby succubi immune to pain while stunning and paralyzing enemies (same as the secrets of lust).
* Loving Caress: Touch the target and increase their attributes. The buff is contagious, meaning that the target can spread the buff to someone else for a short time and is indicated by a blinking question mark.
* Healing Kiss: Touch the target to heal it entirely. This interaction is also contagious, meaning that the target can in turn kiss other succubi to heal them.
* Resurrect a succubus: Target a succubus corpse to bring it back to life and fully healed.

#### Minor powers

* Dimensional phasing: The user can teleport themselves and any nearby allies towards a combat target. This allow movement through windows and fortifications.
* Face melter: Cause a lot of pain, terror and melting to the enemies around the user.
* Abyssal Gravity: Slam the target to the ground, causing wounds, stuns and sometimes death.

Adventuring as a succubus
-------------------------

Civilizations living in dark fortresses are not as well developed than dwarven or human ones for adventure. As a result, a succubus begin their journey in an empty pit without the ability to fast travel. It is recommended that you start playing as a succubus assimilated into another civilization, preferably human (# tiles on the world map) or dwarven (Ω tiles on the world map).

If you start in a pit, you can open the regional map (shift + Q) to spot the nearest dark fortress then travel by foot in this direction to find people to talk to. Wandering around, you may also find dungeons with equipment and towers with population on its roof. If you are unable to reach the roof, try pressing alt+direction to open the hatch above your head.

You can also play as a Frog Demon. Try biting people!

Known issues
------------

* Embarking as dwarves? See "Selecting your race at the embark screen" above.
* Changing graphics in the Lazy Newb Pack deletes the mod. You'll have to reinstall it afterwards.
* Upon reaching your site's edge, traders will "kidnap" their own pets, this has no consequenses to your fort.
* If a frog demon refuses to work or join the military, wait 3 days of game time and try again.

Contact
-------

If you have trouble using this mod, please post a message on the mod thread in the Bay 12 forum :
http://www.bay12forums.com/smf/index.php?topic=124135.0

Credits
-------

This mod has been assembled with the help of many contributions from the bay12 community:
* Obsidian tileset and color palette
* Phoebus color palette and creature sprite set
* dfhack maintained by Peterix and contributors
* K33N elves
* Falconne's UI improvements (mousequery, hotkeys and dwarfmonitor)
* Warmist's spawnunit script
* Teleport by Putnam
* Bits of Masterwork DF by Meph
* Dwarf chocolate by SethCreiyd
* Roses scripts and spells
* Scripts by IndigoFenix
* The demon mod by Naryar
* Chiptune arrangements by Smoip
* PeridexisErrant's cutting-edge pack
* Bugfixes and various QoL maintenance work from Amostubal, thanks!
* Extra graphics sets by Meph, Nopal and Taffer
* And of course, Dwarf Fortress by Tarn and Zach Adams

Special thanks for proof reading:
* jwoodward48df
* Meph
* chaosfiend