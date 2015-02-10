plantslib:spawn_on_surfaces({
  avoid_nodes = {"vines:vine"},
  avoid_radius = 5,
  spawn_delay = 500,
  spawn_plants = {"vines:vine"},
  spawn_chance = 10,
  spawn_surfaces = {"default:dirt_with_grass","default:dirt"},
  spawn_on_bottom = true,
  plantlife_limit = -0.9,
})

plantslib:spawn_on_surfaces({
  avoid_nodes = {"vines:root"},
  avoid_radius = 5,
  spawn_delay = 500,
  spawn_plants = {"vines:vine"},
  spawn_chance = 10,
  spawn_surfaces = {"default:dirt_with_grass","default:dirt"},
  spawn_on_bottom = true,
  plantlife_limit = -0.9,
})

plantslib:spawn_on_surfaces({
  avoid_nodes = {"vines:vine", "vines:side"},
  avoid_radius = 3,
  spawn_delay = 300,
  spawn_plants = {"vines:side"},
  spawn_chance = 10,
  spawn_surfaces = {}, --TODO
  spawn_on_side = true,
  near_nodes = {"default:jungletree"},
  near_nodes_size = 5,
  plantlife_limit = -0.9,
})

plantslib:spawn_on_surfaces({
  spawn_plants = {"vines:willow"},
  spawn_delay = 200,
  spawn_chance = 3,
  spawn_surfaces = {"moretrees:willow_leaves"},
  spawn_on_side = true,
  near_nodes = {"default:water_source"},
  near_nodes_size = 2,
  near_nodes_vertical = 5,
  near_nodes_count = 1,
  plantlife_limit = -0.9,
})
