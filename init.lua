-- TODO: Instead of doing air check it might be better to create helpers to check if something is growable into or onto.

local modpath = core.get_modpath(core.get_current_modname())
local extend_group = luanti_utils.dofile('extend_group.lua')
local migrate_node = luanti_utils.dofile('migrate_node.lua')
local migrate_inventory = luanti_utils.dofile('migrate_inventory.lua')
local wallmounted_to_facedir = luanti_utils.dofile('wallmounted_to_facedir.lua')
local register_decoration = luanti_utils.dofile('register_decoration.lua')

local function tiles(tile)
	local r90= tile..'^[transformR90'
	local r180 = tile..'^[transformR180'
	local r270 = tile..'^[transformR270'

	return {tile, r180, r270, r90, tile, tile}
end


local one_px = 1 / 32

local emptyOrNil = function(x)
	return x == nil or x == ""
end

local node_box_fixed = {
  {-0.5, -0.5, -0.5, 0.5, -0.5 + one_px * 2, 0.5},
}

vines = {
	name = 'vines',
	recipes = {},
	modpath = modpath
}

local flat_to_down = {
	[0] = 4,
	[1] = 13,
	[2] = 10,
	[3] = 19,
}

local downs = {}
for i = 0, 3 do
    downs[#downs + 1] = flat_to_down[i]
end

local down_to_flat = {}
for k, v in pairs(flat_to_down) do
    down_to_flat[v] = k
end

local down = {x=0,y=-1,z=0}
local up   = {x=0,y=1,z=0}

-- settings

local enable_vines = core.settings:get_bool("vines_enable_vines", true)
local enable_rope = core.settings:get_bool("vines_enable_rope", true)
local enable_roots = core.settings:get_bool("vines_enable_roots", true)
local enable_standard = core.settings:get_bool("vines_enable_standard", true)
local enable_side = core.settings:get_bool("vines_enable_side", true)
local enable_jungle = core.settings:get_bool("vines_enable_jungle", true)
local enable_willow = core.settings:get_bool("vines_enable_willow", true)

local rarity_roots = tonumber(core.settings:get("vines_rarity_roots")) or 0.5
local default_rarity = 0.2
local rarity_standard = tonumber(core.settings:get("vines_rarity_standard")) or default_rarity
local rarity_side = tonumber(core.settings:get("vines_rarity_side")) or default_rarity
local rarity_jungle = tonumber(core.settings:get("vines_rarity_jungle")) or default_rarity
local rarity_willow = tonumber(core.settings:get("vines_rarity_willow")) or default_rarity

local growth_min = tonumber(core.settings:get("vines_growth_min")) or 180
local growth_max = tonumber(core.settings:get("vines_growth_max")) or 360

-- support for i18n
local S = core.get_translator("vines")

local dids = {}
local spawn_funcs = {}

-- ITEMS

if enable_vines ~= false then
	core.register_craftitem("vines:vines", {
		description = S("Vines"),
		inventory_image = "vines_item.png",
		groups = {vines = 1, flammable = 2}
	})
end

-- FUNCTIONS


local function on_dig(pos, node, player)
	if not player or core.is_protected(pos, player:get_player_name()) then
		return
	end
	local vine_name_end = node.name:gsub("_middle", "_end")
	local drop_item = "vines:vines"
	if enable_vines == false then
		drop_item = vine_name_end
	end

	local wielded_item = core.is_player(player) and player:get_wielded_item()
	if wielded_item then
		local node_def = core.registered_nodes[node.name]
		local dig_params = core.get_dig_params(
			node_def.groups,
			wielded_item:get_tool_capabilities(),
			wielded_item:get_wear()
		)
		if dig_params.wear then
			wielded_item:add_wear(dig_params.wear)
			player:set_wielded_item(wielded_item)
		end

		if wielded_item:get_name() == 'vines:shears' then
			drop_item = vine_name_end
		end
	end

	local break_pos = {x = pos.x, y = pos.y, z = pos.z}
	while core.get_item_group(core.get_node(break_pos).name, "vines") > 0 do
		core.remove_node(break_pos)
		core.handle_node_drops(break_pos, {drop_item}, player)
		break_pos.y = break_pos.y - 1
	end
end

vines.register_vine = function( name, defs, def )
	local groups = {vines = 1, snappy = 3, flammable = 2}

	local vine_name_end = 'vines:' .. name .. '_end_v2'
	local vine_name_middle = 'vines:' .. name .. '_middle_v2'

	local vine_name_end_v1 = 'vines:' .. name .. '_end'
	local vine_name_middle_v1 = 'vines:' .. name .. '_middle'

	-- Could add a setting for migration.
	if true then

	migrate_inventory(vine_name_end_v1, function(stack)
		stack:set_name(vine_name_end)
		return stack
	end)

	migrate_inventory(vine_name_middle_v1, function(stack)
		stack:set_name(vine_name_middle)
		return stack
	end)

	-- TODO: Find a server owner that has vines configured. Should test on an existing server.
	migrate_node(vine_name_end_v1, {vine_name_end_v1, vine_name_middle_v1}, function(pos, old)
		local new = table.copy(old)

		-- Pick a somewhat random direction for plantlike vines for the whole vertical column the value stays the same.
		if defs.flags == 'all_ceilings' then
			new.param2 = flat_to_down[(pos.x + pos.z) % 4]
		else
			new.param2 = wallmounted_to_facedir(old.param2)
		end

		new.name = old.name .. '_v2'

		core.swap_node(pos, new)
	end)

	end

	local vine_image_end = "vines_" .. name .. "_end.png^[transformR180"
	local vine_wield_image_middle = "vines_" .. name .. "_middle.png"
	local vine_wield_image_end = "vines_" .. name .. "_end.png"
	local vine_image_middle = "vines_" .. name .. "_middle.png^[transformR180"

	local function on_vine_destruct(pos)
		local meta = core.get_meta(pos)
		local parent_pos = meta:get_string('parent_pos')
		local child_pos = meta:get_string('child_pos')

		-- Not defined, most likely is the most parent of vines. The first vine node.
		if not emptyOrNil(parent_pos) then
			parent_pos = vector.from_string(parent_pos)
			local parent = core.get_node(parent_pos)

			if parent.name == vine_name_middle then
				core.swap_node(parent_pos, {
					name = vine_name_end,
					param2 = parent.param2,
				})
			end
		end

		-- Remove child vine if exists
		if not emptyOrNil(child_pos) then
			child_pos = vector.from_string(child_pos)
			local child_node = core.get_node(child_pos)
			if child_node.name == vine_name_middle or child_node.name == vine_name_end then
				core.remove_node(child_pos)
			end
		end
	end


	local on_grow = function(pos)
			if math.random(defs.average_length) == 1 then
				return nil
			end

       local node = core.get_node(pos)
        local dir = core.facedir_to_dir(node.param2)

        local grow = function(p, param2)

	        core.set_node(p, {
	            name = vine_name_end,
	            param2 = param2,
	        })

        	core.get_meta(p):set_string('parent_pos', vector.to_string(pos))

	        -- We swap so we keep the meta data of the vine end around.
	        -- This is later used to set a middle node to end node when node breaks.
	        core.swap_node(pos, {
	        	name = vine_name_middle,
	        	param2 = node.param2,
	        })

	        -- Store the child position in parent's metadata for cleanup on destruction
	        core.get_meta(pos):set_string('child_pos', vector.to_string(p))

	      	return p
        end

        if node.param2 > 3 then -- is growing downward
        	local bottom_pos = vector.add(pos, down)

        	if core.get_node(bottom_pos).name == 'air' then
        		return grow(bottom_pos, node.param2)
        	end

        	-- Someone or something has messed with the param2. Stop growth.
        	local flat = down_to_flat[node.param2]
        	if flat == nil then
        		return nil
        	end

        	-- otherwise we try to flip the vine or grow sideways.
        	local next_param2 = (flat + 2) % 4
        	local next_dir = core.facedir_to_dir(next_param2)
        	local next_pos = vector.add(pos, next_dir)
        	local next_bottom_pos = vector.add(next_pos, down)

        	if core.get_node(next_pos).name ~= 'air' then
        		return nil
        	end

        	-- specific case where should check if diag under is empty.
        	-- this shifts the vine one node to growing direction and makes it vertical.
					if core.get_node(next_bottom_pos).name == "air"  then
						return grow(next_bottom_pos, flat_to_down[next_param2])
					end

        	return grow(next_pos, next_param2)
        else -- is growing sideways
        	local next_pos = vector.add(pos, dir)
        	local diag_pos = vector.add(next_pos, down)

        	if core.get_node(next_pos).name ~= 'air' then
        		-- stop growing. Wall in the way
        		return nil
        	end

        	local diag_node = core.get_node(diag_pos)

        	if diag_node.name== 'air' then -- vine is wrapping down
        		local param2 = flat_to_down[node.param2]
        		return grow(diag_pos, param2)
        	end

        	-- Is the node strong enough to grow onto?
					if core.registered_nodes[diag_node.name].buildable_to == true then
        		return nil
        	end

        	-- Keep growing flat.
        	return grow(next_pos, node.param2)
        end
  end

	local spawn_plants = function(pos)
		local param2 = 0
		if def.flags == "all_floors" then
			param2 = math.random(0, 3) -- Consider using seed randomness.
			pos = vector.add(pos, up)
		elseif def.flags == "all_ceilings" then
			local newpos = vector.add(pos, down)

			-- (1) prevent floating vines; (2) is there even space?
			if core.get_node(pos).name == 'air' and core.get_node(newpos).name ~= "air" then
				return
			end

			pos = newpos
			param2 = downs[math.random(4)] -- Consider using seed randomness.
		else
			error("Must defined flags")
		end

		core.set_node(pos, {
			name = vine_name_end,
			param2 = param2,
		})

		local next_pos = pos

		while true do
			next_pos = on_grow(next_pos)
			if next_pos == nil then
				break
			end
		end
	end

	local function on_place(itemstack, placer, pointed_thing)
		local dir = vector.direction(pointed_thing.under, pointed_thing.above)
		local look_dir = placer:get_look_dir()
		local param2

		-- placing item on a wall
		if dir.y == 0 then
			param2 = flat_to_down[core.dir_to_facedir(dir)]
		else  -- is placing the item flat on the ground or ceiling.
			param2 = core.dir_to_facedir(look_dir)
		end

		return core.item_place(itemstack, placer, pointed_thing, param2)
	end

	core.register_node(vine_name_end, {
		description = defs.description,
		walkable = false,
		climbable = true,
		waving = 2,
		wield_image = vine_wield_image_end,
		drop = {},
		sunlight_propagates = true,
		use_texture_alpha = "clip",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		buildable_to = true,
		-- check what happens with the ugly vines. The end is flipped...
		tiles = tiles(vine_image_end),
		drawtype = 'nodebox',
		inventory_image = vine_wield_image_end,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		node_box = {
		    type = "fixed",
		    fixed = node_box_fixed,
		},

		on_place = on_place,

		after_place_node = function(pos, placer, itemstack, pointed_thing)
		    core.get_node_timer(pos):start(math.random(growth_min, growth_max))
		end,

		on_timer = function(pos)
				local newpos = on_grow(pos)

				if newpos == nil then
					return false
				end

	      core.get_node_timer(newpos):start(1 or math.random(growth_min, growth_max))
		end,

		on_dig = on_dig,

		on_destruct = function(pos)
			on_vine_destruct(pos)
		end,
	})

	core.register_node(vine_name_middle, {
		description = S("Matured") .. " " .. defs.description,
		walkable = false,
		climbable = true,
		waving = 2,
		drop = {},
		sunlight_propagates = true,
		use_texture_alpha = "clip",
		paramtype = "light",
		is_ground_content = false,
		paramtype2 = "facedir",
		buildable_to = true,
		tiles = tiles(vine_image_middle),
		wield_image = vine_wield_image_middle,
		drawtype = 'nodebox',
		inventory_image = vine_wield_image_middle,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),

		on_place = on_place,

		node_box = {
		    type = "fixed",
		    fixed = node_box_fixed,
		},

		on_dig = on_dig,

		on_destruct = function(pos)
			on_vine_destruct(pos)
		end,
	})

	register_decoration({
		name = "vines:" .. name,
		decoration = {'air'},
		fill_ratio = def.rarity,
		y_min = -16,
		y_max = 48,
		place_offset_y = 0,
		place_on = def.place_on,
		deco_type = "simple",
		flags = def.flags,
		on_position = spawn_plants,
	})
end

-- ALIASES

-- used to remove the old vine nodes and give room for the new.
core.register_alias( 'vines:root', 'air' )
core.register_alias( 'vines:root_rotten', 'air' )
core.register_alias( 'vines:vine', 'air' )
core.register_alias( 'vines:vine_rotten', 'air' )
core.register_alias( 'vines:side', 'air' )
core.register_alias( 'vines:side_rotten', 'air' )
core.register_alias( 'vines:jungle', 'air' )
core.register_alias( 'vines:jungle_rotten', 'air' )
core.register_alias( 'vines:willow', 'air' )
core.register_alias( 'vines:willow_rotten', 'air' )


-- ROPE
if enable_rope ~= false then
	core.register_craft({
		output = 'vines:rope_block',
		recipe = {
			{'group:vines', 'group:vines', 'group:vines'},
			{'group:vines', 'group:wood', 'group:vines'},
			{'group:vines', 'group:vines', 'group:vines'},
		}
	})

	if core.get_modpath("moreblocks") then
		core.register_craft({
			output = 'vines:rope_block',
			recipe = {
				{'moreblocks:rope', 'moreblocks:rope', 'moreblocks:rope'},
				{'moreblocks:rope', 'group:wood', 'moreblocks:rope'},
				{'moreblocks:rope', 'moreblocks:rope', 'moreblocks:rope'},
			}
		})
	end

	core.register_node("vines:rope_block", {
		description = S("Rope"),
		sunlight_propagates = true,
		paramtype = "light",
		is_ground_content = false,
		tiles = {
			"default_wood.png^vines_rope.png",
			"default_wood.png^vines_rope.png",
			"default_wood.png",
			"default_wood.png",
			"default_wood.png^vines_rope.png",
			"default_wood.png^vines_rope.png",
		},
		groups = {flammable = 2, choppy = 2, oddly_breakable_by_hand = 1},

		after_place_node = function(pos)

			local p = {x = pos.x, y = pos.y - 1, z = pos.z}
			local n = core.get_node(p)

			if n.name == "air" then
				core.add_node(p, {name = "vines:rope_end"})
			end
		end,

		after_dig_node = function(pos, node, digger)

			local p = {x = pos.x, y = pos.y - 1, z = pos.z}
			local n = core.get_node(p)

			while n.name == 'vines:rope' or n.name == 'vines:rope_end' do

				core.remove_node(p)

				p = {x = p.x, y = p.y - 1, z = p.z}
				n = core.get_node(p)
			end
		end
	})

	core.register_node("vines:rope", {
		description = S("Rope"),
		walkable = false,
		climbable = true,
		sunlight_propagates = true,
		paramtype = "light",
		is_ground_content = false,
		drop = {},
		tiles = {"vines_rope.png"},
		waving = 2,
		drawtype = "plantlike",
		groups = {flammable = 2, not_in_creative_inventory = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
		},
	})

	core.register_node("vines:rope_end", {
		description = S("Rope"),
		walkable = false,
		climbable = true,
		waving = 2,
		sunlight_propagates = true,
		is_ground_content = false,
		paramtype = "light",
		drop = {},
		tiles = {"vines_rope_end.png"},
		drawtype = "plantlike",
		groups = {flammable = 2, not_in_creative_inventory = 1},
		sounds = default.node_sound_leaves_defaults(),

		after_place_node = function(pos)

			local yesh = {x = pos.x, y = pos.y - 1, z = pos.z}

			core.add_node(yesh, {name = "vines:rope"})
		end,

		selection_box = {
			type = "fixed",
			fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
		},

		on_construct = function(pos)

			local timer = core.get_node_timer(pos)

			timer:start(1)
		end,

		on_timer = function( pos, elapsed )

			local p = {x = pos.x, y = pos.y - 1, z = pos.z}
			local n = core.get_node(p)

			if n.name == "air" then

				core.set_node(pos, {name = "vines:rope"})
				core.add_node(p, {name = "vines:rope_end"})
			else

				local timer = core.get_node_timer(pos)

				timer:start(1)
			end
		end
	})
end

-- SHEARS
core.register_tool("vines:shears", {
	description = S("Shears"),
	inventory_image = "vines_shears.png",
	wield_image = "vines_shears.png",
	stack_max = 1,
	max_drop_level = 3,
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times = {[3] = 0.2}, uses = 60, maxlevel = 3},
		}
	},
})

core.register_craft({
	output = 'vines:shears',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'group:stick', 'group:wood', 'default:steel_ingot'},
		{'', '', 'group:stick'}
	}
})

-- ROOT VINES
if enable_roots ~= false then
	vines.register_vine('root',
		{description = S("Roots"), average_length = 9}, {
		place_on = {
			"default:dirt_with_grass",
			"default:dirt"
		},
		flags = "all_ceilings",
		rarity = rarity_roots,
	})
else
	core.register_alias('vines:root_middle', 'air')
	core.register_alias('vines:root_end', 'air')
end

-- STANDARD VINES
if enable_standard ~= false then
	vines.register_vine('vine',
		{description = S("Vines"), average_length = 8}, {
		place_on = {
			"default:jungleleaves",
			"moretrees:jungletree_leaves_red",
			"moretrees:jungletree_leaves_yellow",
			"moretrees:jungletree_leaves_green"
		},
		flags = "all_ceilings",
		rarity = rarity_standard,
	})
else
	core.register_alias('vines:vine_middle', 'air')
	core.register_alias('vines:vine_end', 'air')
end

-- SIDE VINES
if enable_side ~= false then
	vines.register_vine('side',
		{description = S("Vines"), average_length = 6 }, {
		place_on = {
			"default:jungleleaves",
			"moretrees:jungletree_leaves_red",
			"moretrees:jungletree_leaves_yellow",
			"moretrees:jungletree_leaves_green"
		},
		flags = "all_floors",
		rarity = rarity_side,
	})
else
	core.register_alias('vines:side_middle', 'air')
	core.register_alias('vines:side_end', 'air')
end

-- JUNGLE VINES
if enable_jungle ~= false then
	vines.register_vine("jungle",
		{description = S("Jungle Vines"), average_length = 7}, {
		place_on = {
			"default:jungletree",
			"moretrees:jungletree_trunk"
		},
		flags = "all_floors",
		rarity = rarity_jungle,
	})
else
	core.register_alias('vines:jungle_middle', 'air')
	core.register_alias('vines:jungle_end', 'air')
end

-- WILLOW VINES (Note from 2024-06: Broken for years now, integration w/ new moretrees spawn mechanic needed)
if enable_willow ~= false then
	vines.register_vine("willow",
		{description = S("Willow Vines"), average_length = 9}, {
		flags = "all_floors",
		place_on = {"moretrees:willow_leaves"},
		rarity = rarity_willow,
	})
else
	core.register_alias('vines:willow_middle', 'air')
	core.register_alias('vines:willow_end', 'air')
end

extend_group('leaves', {
  on_destruct = function(next, pos)
    local neighbours = {
      {x = pos.x + 1, y = pos.y, z = pos.z},
      {x = pos.x - 1, y = pos.y, z = pos.z},
      {x = pos.x, y = pos.y + 1, z = pos.z},
      {x = pos.x, y = pos.y - 1, z = pos.z},
      {x = pos.x, y = pos.y, z = pos.z + 1},
      {x = pos.x, y = pos.y, z = pos.z - 1},
    }

    for _, npos in ipairs(neighbours) do
      local node = core.get_node(npos)
      local node_def = core.registered_items[node.name]
      if node_def and node_def.groups and node_def.groups.vines then
        core.remove_node(npos)
      end
    end

    if next then
      return next(pos)
    end
  end
})
