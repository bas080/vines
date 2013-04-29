local mod_name = "vines"
local average_height = 12
local spawn_interval = 90
-- Nodes
minetest.register_node("vines:rope_block", {
  description = "Rope",
  sunlight_propagates = true,
  paramtype = "light",
  drops = "",
  tile_images = {
    "vines_rope_block.png",
    "vines_rope_block.png",
    "default_wood.png",
    "default_wood.png",
    "vines_rope_block.png",
    "vines_rope_block.png"
  },
  drawtype = "cube",
  groups = {choppy=2,oddly_breakable_by_hand=1},
  after_place_node = function(pos)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.env:get_node(p)
    if n.name == "air" then
      minetest.env:add_node(p, {name="vines:rope_end"})
    end
  end,
  after_dig_node = function(pos, node, digger)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.env:get_node(p)
    while n.name == 'vines:rope' do
      minetest.env:remove_node(p)
      p = {x=p.x, y=p.y-1, z=p.z}
      n = minetest.env:get_node(p)
    end
    if n.name == 'vines:rope_end' then
      minetest.env:remove_node(p)
    end
  end
})

minetest.register_node("vines:rope", {
  description = "Rope",
  walkable = false,
  climbable = true,
  sunlight_propagates = true,
  paramtype = "light",
  tile_images = { "vines_rope.png" },
  drawtype = "plantlike",
  groups = {flammable=2, not_in_creative_inventory=1},
  sounds =  default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
  },
})

minetest.register_node("vines:rope_end", {
  description = "Rope",
  walkable = false,
  climbable = true,
  sunlight_propagates = true,
  paramtype = "light",
  drops = "",
  tile_images = { "vines_rope_end.png" },
  drawtype = "plantlike",
  groups = {flammable=2, not_in_creative_inventory=1},
  sounds =  default.node_sound_leaves_defaults(),
  after_place_node = function(pos)
    yesh  = {x = pos.x, y= pos.y-1, z=pos.z}
    minetest.env:add_node(yesh, "vines:rope")
  end,
  selection_box = {
	  type = "fixed",
	  fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
  },
})

minetest.register_node("vines:side", {
  description = "Vine",
  walkable = false,
  climbable = true,
  drop = 'vines:vines',
  sunlight_propagates = true,
  paramtype = "light",
  paramtype2 = "wallmounted",
  tile_images = { "vines_side.png" },
  drawtype = "signlike",
  inventory_image = "vines_side.png",
  groups = { snappy = 3,flammable=2, hanging_node=1, wood=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "wallmounted",
  },
  on_construct = function(pos, placer)
    local p = {x=pos.x, y=pos.y, z=pos.z}
    local n = minetest.env:get_node(p)
    local walldir = n.param2
    local down=-1
    
    while math.random(0,average_height) > 1.0 do
      local pt = {x = p.x, y= p.y+down, z=p.z}
      local nt = minetest.env:get_node(pt)
      if nt.name == "air" then
        minetest.env:add_node(pt, {name=n.name, param2 = walldir})
        down=down-1
      else
        return
      end
    end
  end,
})

minetest.register_node("vines:willow", {
  description = "Vine",
  walkable = false,
  climbable = true,
  drop = 'vines:vines',
  sunlight_propagates = true,
  paramtype = "light",
  paramtype2 = "wallmounted",
  tile_images = { "vines_willow.png" },
  drawtype = "signlike",
  inventory_image = "vines_willow.png",
  groups = { snappy = 3,flammable=2, hanging_node=1, wood=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "wallmounted",
  },
  on_construct = function(pos, placer)
    local p = {x=pos.x, y=pos.y, z=pos.z}
    local n = minetest.env:get_node(p)
    local walldir = n.param2
    local down=-1
    
    while math.random(0,average_height) > 1.0 do
      local pt = {x = p.x, y= p.y+down, z=p.z}
      local nt = minetest.env:get_node(pt)
      if nt.name == "air" then
        minetest.env:add_node(pt, {name=n.name, param2 = walldir})
        down=down-1
      else
        return
      end
    end
  end,
})

minetest.register_node("vines:root", {
  description = "Vine",
  walkable = false,
  climbable = true,
  drop = 'vines:vines',
  sunlight_propagates = true,
  paramtype = "light",
  tile_images = { "vines_root.png" },
  drawtype = "plantlike",
  inventory_image = "vines_root.png",
  groups = { snappy = 3,flammable=2, hanging_node=1, wood=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
  },
})

minetest.register_node("vines:vine", {
  description = "Vine",
  walkable = false,
  climbable = true,
  drop = 'vines:vines',
  sunlight_propagates = true,
  paramtype = "light",
  tile_images = { "vines_vine.png" },
  drawtype = "plantlike",
  inventory_image = "vines_vine.png",
  groups = { snappy = 3,flammable=2, hanging_node=1, wood=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = {-0.3, -1/2, -0.3, 0.3, 1/2, 0.3},
  },
  on_construct = function(pos, placer)
    local p = {x=pos.x, y=pos.y, z=pos.z}
    local n = minetest.env:get_node(p)
    local walldir = n.param2
    local down=-1
    
    while math.random(0,average_height) > 1.0 do
      local pt = {x = p.x, y= p.y+down, z=p.z}
      local nt = minetest.env:get_node(pt)
      if nt.name == "air" then
        minetest.env:add_node(pt, {name=n.name, param2 = walldir})
        down=down-1
      else
        return
      end
    end
  end,
})

minetest.register_node("vines:vine_rotten", {
  description = "Rotten vine",
  walkable = false,
  climbable = true,
  drop = 'vines:vines',
  sunlight_propagates = true,
  paramtype = "light",
  tile_images = { "vines_vine_rotten.png" },
  drawtype = "plantlike",
  inventory_image = "vines_vine_rotten.png",
  groups = { snappy = 3,flammable=2, hanging_node=1, wood=1},
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = {-0.3, -1/2, -0.3, 0.3, 1/2, 0.3},
  },
})

--ABM
minetest.register_abm({
  nodenames = {"vines:vine", "vines:root"},
  interval = 700,
  chance = 8,
  action = function(pos, node, active_object_count, active_object_count_wider)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.env:get_node(p)
    if n.name == "air" then
      walldir = node.param2
      minetest.env:add_node(p, {name=node.name, param2 = walldir})
    end
  end
})

minetest.register_abm({
  nodenames = {"vines:rope_end"},
  interval = 1,
  chance = 1,
  action = function(pos, node, active_object_count, active_object_count_wider)
    local p = {x=pos.x, y=pos.y-1, z=pos.z}
    local n = minetest.env:get_node(p)
    --remove if top node is removed
    if  n.name == "air" then
      minetest.env:set_node(pos, {name="vines:rope"})
      minetest.env:add_node(p, {name="vines:rope_end"})
    end 
  end
})
--Craft
minetest.register_craft({
  output = 'vines:rope_block',
  recipe = {
    {'', 'default:wood', ''},
    {'', 'vines:vines', ''},
    {'', 'vines:vines', ''},
  }
})

minetest.register_craftitem("vines:vines", {
  description = "Vines",
  inventory_image = "vines_item.png",
})
--spawning
plantslib:spawn_on_surfaces({
  avoid_nodes = {"vines:vine"},
  avoid_radius = 5,
  spawn_delay = spawn_interval,
  spawn_plants = {"vines:vine"},
  spawn_chance = 10,
  spawn_surfaces = {"default:dirt_with_grass","default:dirt"},
  spawn_on_bottom = true,
  plantlife_limit = -0.9,
})

plantslib:spawn_on_surfaces({
  avoid_nodes = {"vines:vine", "vines:side"},
  avoid_radius = 3,
  spawn_delay = spawn_interval,
  spawn_plants = {"vines:side"},
  spawn_chance = 10,
  spawn_surfaces = {"group:leafdecay"},
  spawn_on_side = true,
  near_nodes = {"default:water_source", "default:jungletree"},
  near_nodes_size = 10,
  near_nodes_vertical = 5,
  near_nodes_count = 1,
  plantlife_limit = -0.9,
})

plantslib:spawn_on_surfaces({
  spawn_plants = {"vines:willow"},
  spawn_delay = spawn_interval,
  spawn_chance = 3,
  spawn_surfaces = {"moretrees:willow_leaves"},
  spawn_on_side = true,
  near_nodes = {"default:water_source"},
  near_nodes_size = 2,
  near_nodes_vertical = 5,
  near_nodes_count = 1,
  plantlife_limit = -0.9,
})

print("[Vines] Loaded!")
