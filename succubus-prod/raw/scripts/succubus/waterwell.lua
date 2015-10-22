--Lets you make reactions that require water or magma under the workshop.  Reactions must start with LUA_HOOK_USEWATER or LUA_HOOK_USEMAGMA.
local eventful = require 'plugins.eventful'
local utils = require 'utils'


function usewater(reaction,unit,job,input_items,input_reagents,output_items,call_native)
	local building = dfhack.buildings.findAtTile(unit.pos)
	local pos = {}
	pos.x1 = building.x1
	pos.x2 = building.x2
	pos.y1 = building.y1
	pos.y2 = building.y2
	pos.z = building.z
	for x = pos.x1-1, pos.x2+1, 1 do
		for y = pos.y1-1, pos.y2+1, 1 do
			baseBlock = dfhack.maps.ensureTileBlock(x,y,pos.z)
			liquidBlock = dfhack.maps.ensureTileBlock(x,y,pos.z-1)
			if liquidBlock.designation[x%16][y%16].flow_size > 0 and liquidBlock.designation[x%16][y%16].liquid_type == false then
				liquidBlock.designation[x%16][y%16].flow_size = liquidBlock.designation[x%16][y%16].flow_size - 1
				return
			end
		end
	end
	dfhack.gui.showAnnouncement( dfhack.TranslateName(unit.name).." cancels "..reaction.name..": Needs water." , COLOR_RED, true)
	for i=0,#input_items-1,1 do
		input_items[i].flags.PRESERVE_REAGENT = true
	end
	for i=0,#reaction.products-1,1 do
		reaction.products[i].probability = 0
	end
end


function usemagma(reaction,unit,job,input_items,input_reagents,output_items,call_native)
	local building = dfhack.buildings.findAtTile(unit.pos)
	local pos = {}
	pos.x1 = building.x1
	pos.x2 = building.x2
	pos.y1 = building.y1
	pos.y2 = building.y2
	pos.z = building.z
	for x = pos.x1-1, pos.x2+1, 1 do
		for y = pos.y1-1, pos.y2+1, 1 do
			baseBlock = dfhack.maps.ensureTileBlock(x,y,pos.z)
			liquidBlock = dfhack.maps.ensureTileBlock(x,y,pos.z-1)
			if liquidBlock.designation[x%16][y%16].flow_size > 0 and liquidBlock.designation[x%16][y%16].liquid_type == true then
				liquidBlock.designation[x%16][y%16].flow_size = liquidBlock.designation[x%16][y%16].flow_size - 1
				return
			end
		end
	end
	dfhack.gui.showAnnouncement( dfhack.TranslateName(unit.name).." cancels "..reaction.name..": Needs magma." , COLOR_RED, true)
	for i=0,#input_items-1,1 do
		input_items[i].flags.PRESERVE_REAGENT = true
	end
	for i=0,#reaction.products-1,1 do
		reaction.products[i].probability = 0
	end
end

dfhack.onStateChange.loadUseLiquid = function(code)
	local registered_reactions
	if code==SC_MAP_LOADED then
		--registered_reactions = {}
		for i,reaction in ipairs(df.global.world.raws.reactions) do
			if string.starts(reaction.code,'LUA_HOOK_USEWATER') then
				eventful.registerReaction(reaction.code,usewater)
				registered_reactions = true
			elseif string.starts(reaction.code,'LUA_HOOK_USEMAGMA') then
				eventful.registerReaction(reaction.code,usemagma)
				registered_reactions = true
			end
		end
		if registered_reactions then
			print('Use Liquid Reactions: Loaded.')
		end
	elseif code==SC_MAP_UNLOADED then
	end
end

if dfhack.isMapLoaded() then dfhack.onStateChange.loadUseLiquid(SC_MAP_LOADED) end
