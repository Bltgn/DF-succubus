

args={...}

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function eruption(args)
	local etype = args.type
	local unit = args.unit
	local radius = args.radius
	local depth = args.depth
	local elevation = args.elevation

	local i
	local rando = dfhack.random.new()
	local radiusa = split(args.radius,'/')
	local rx = tonumber(radiusa[1])
	local ry = tonumber(radiusa[2])
	local rz = tonumber(radiusa[3])

	local mapx, mapy, mapz = dfhack.maps.getTileSize()
	local xmin = unit.pos.x - rx
	local xmax = unit.pos.x + rx
	local ymin = unit.pos.y - ry
	local ymax = unit.pos.y + ry
	local zmax = unit.pos.z + rz + elevation
	local zmin = unit.pos.z + elevation
	if xmin < 1 then xmin = 1 end
	if ymin < 1 then ymin = 1 end
	if xmax > mapx then xmax = mapx-1 end
	if ymax > mapy then ymax = mapy-1 end
	if zmax > mapz then zmax = mapz-1 end

	local dx = xmax - xmin
	local dy = ymax - ymin
	local dz = zmax - zmin
	local hx = 0
	local hy = 0
	local hz = 0

	if dx == 0 then
		hx = depth
	else
		hx = depth/dx
	end

	if dy== 0 then
		hy = depth
	else
		hy = depth/dy
	end

	if dz == 0 then
		hz = depth
	else
		hz = depth/dz
	end

	for i = xmin, xmax, 1 do
		for j = ymin, ymax, 1 do
			for k = zmin, zmax, 1 do
				if (math.abs(i-unit.pos.x) + math.abs(j-unit.pos.y) + math.abs(k-unit.pos.z)) <= math.sqrt(rx*rx+ry*ry+rz*rz) then
					block = dfhack.maps.ensureTileBlock(i,j,k)
					dsgn = block.designation[i%16][j%16]
					if not dsgn.hidden then
						size = math.floor(depth-hx*math.abs(unit.pos.x-i)-hy*math.abs(unit.pos.y-j)-hz*math.abs(unit.pos.z-k))
						if size < 1 then size = 1 end
						dsgn.flow_size = size
						if etype == 'magma' then
							dsgn.liquid_type = true
						end
						flow = block.liquid_flow[i%16][j%16]
						flow.temp_flow_timer = 10
						flow.unk_1 = 10
						block.flags.update_liquid = true
						block.flags.update_liquid_twice = true
					end
				end
			end
		end
	end
end

-- Action
validArgs = validArgs or utils.invert({
    'help',
	'type',
    'unit',
    'radius',
    'depth',
    'elevation'
})

local args = utils.processArgs({...}, validArgs)

if args.help then
	print([[scripts/succubus/summoning.lua
arguments
    -help
        print this help message
    -type <water|magma>
    	The type of liquid to spawn.
    -unit <number>
    	The id of the unit serving as the center of the eruption.
    -radius <x/y/z>
    	The radius of the circle or ball of liquid that will be added.
    -depth <number>
    	A number from 1 to 7 of the depth of the liquid. Defaults to 7.
    -elevation <number>
    	A modifier for the z axis. Defaults to 0.
]])
	return
end

if not args.type then
	qerror('Eruption: Please enter the type, water or magma.')
end

if args.type != 'water' and args.type != 'magma' then
	qerror('Eruption: Invalid liquid type.')
end

if not args.unit then
	qerror('Eruption: No unit provided.')
end

if not args.radius then
	qerror('Eruption: A radius in the form of x/y/z is required.')
end

if not args.depth then
	args.depth = 7
end

if not args.elevation then
	args.elevation = 0
end

eruption(args)

-- Activating the magma forges
if(etype == 'magma') then
	dfhack.run_script('succubus/feature', 'magmaWorkshops')
end