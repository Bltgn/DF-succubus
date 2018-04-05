-- Slam a unit into the ground
-- Based on https://gist.github.com/IndigoFenix/8543557
local utils = require 'utils'
local strength, unit

validArgs = validArgs or utils.invert({
    'help',
    'unit',
    'velocity',
})

local args = utils.processArgs({...}, validArgs)

if args.help then
   print([[scripts/succubus/slam.lua
arguments
    -help
        Print this help message.
    -unit <number>
        The unit to slam to the ground.
    -velocity <number>
        The force used, higher numbers cause wounds.
]])
   return
end

-- Args processing
if not args.unit then 
   unit = dfhack.gui.getSelectedUnit()
else
   unit = df.unit.find(tonumber(args.unit))
end

if unit == nil then qerror('Not unit provided, check succubus/slam -help') end

local strength = args.velocity

if strength == nil then qerror('No argument for velocity found, check succubus/slam -help') end

-- Do the flop
if unit then
   local l = df.global.world.proj_list
   local lastlist=l
   l=l.next
   count = 0
     while l do
        count=count+1
         if l.next==nil then
               lastlist=l
         end
        l = l.next
      end

   unitTarget=unit

   newlist = df.proj_list_link:new()
   lastlist.next=newlist
   newlist.prev=lastlist
   proj = df.proj_unitst:new()
   newlist.item=proj
   proj.link=newlist
   proj.id=df.global.proj_next_id
   df.global.proj_next_id=df.global.proj_next_id+1
   proj.unit=unitTarget
   proj.origin_pos.x=unitTarget.pos.x
   proj.origin_pos.y=unitTarget.pos.y
   proj.origin_pos.z=unitTarget.pos.z
   proj.prev_pos.x=unitTarget.pos.x
   proj.prev_pos.y=unitTarget.pos.y
   proj.prev_pos.z=unitTarget.pos.z
   proj.cur_pos.x=unitTarget.pos.x
   proj.cur_pos.y=unitTarget.pos.y
   proj.cur_pos.z=unitTarget.pos.z
   proj.flags.no_impact_destroy=true
   proj.flags.piercing=true
   proj.flags.parabolic=true
   proj.flags.unk9=true
   proj.speed_x=0
   proj.speed_y=0
   proj.speed_z=strength
   unitoccupancy = dfhack.maps.getTileBlock(unitTarget.pos).occupancy[unitTarget.pos.x%16][unitTarget.pos.y%16]
   if not unitTarget.flags1.on_ground then 
         unitoccupancy.unit = false 
   else 
         unitoccupancy.unit_grounded = false 
   end
   unitTarget.flags1.projectile=true
   unitTarget.flags1.on_ground=false
end