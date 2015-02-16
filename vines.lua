vines.register_vine( 'root', {
  description = "Roots",
  average_length = 9,
},{
  avoid_nodes = {"vines:root_rotten"},
  avoid_radius = 5,
  spawn_delay = 500,
  spawn_chance = 10,
  spawn_surfaces = {
    "default:dirt_with_grass",
    "default:dirt"
  },
  spawn_on_bottom = true,
  plantlife_limit = -0.1,
  temp_max = -0.6,
  temp_min = 0.2,
  humidity_max = -0.7,
  humidity_min = 0.2,
})

vines.register_vine( 'vine', {
  description = "Vines",
  average_length = 5,
},{
  avoid_nodes = {"group:vines"},
  avoid_radius = 5,
  spawn_delay = 500,
  spawn_chance = 100,
  spawn_surfaces = {
    "default:leaves",
    "default:jungleleave",
    "moretrees:jungetree_leaves_red",
    "moretrees:jungetree_leaves_yellow",
    "moretrees:jungetree_leaves_green"
  },
  spawn_on_bottom = true,
  plantlife_limit = -0.9,
  humidity_max = -1,
  humidity_min = 0.8,
  temp_max = -0.5,
  temp_min = 0.3,
})

vines.register_vine( 'side', {
  description = "Vines",
  average_length = 7,
},{
  avoid_nodes = {"group:vines"},
  avoid_radius = 5,
  spawn_delay = 500,
  spawn_chance = 100,
  spawn_surfaces = {
    "default:leaves",
    "default:jungleleave",
    "moretrees:jungetree_leaves_red",
    "moretrees:jungetree_leaves_yellow",
    "moretrees:jungetree_leaves_green"
  },
  spawn_on_side = true,
  plantlife_limit = -0.9,
  humidity_max = 1,
  humidity_min = 0.8,
  temp_min = 0.1,
  temp_max = 1,
})

vines.register_vine( 'jungle', {
  description = "Jungle Vines",
  average_length = 7,
},{
  avoid_nodes = {"group:vines"},
  avoid_radius = 5,
  spawn_delay = 500,
  spawn_chance = 100,
  spawn_surfaces = {
    "default:jungletree",
    "moretrees:jungletree_trunk"
  },
  spawn_on_side = true,
  plantlife_limit = -0.9,
  humidity_max = 1,
  humidity_min = 0.8,
  temp_min = 0.1,
  temp_max = 1,
})

vines.register_vine( 'willow', {
  description = "Willow Vines",
  average_length = 9,
},{
  avoid_nodes = { "vines:willow_middle" },
  avoid_radius = 5,
  near_nodes = { 'default:water_source' },
  near_nodes_size = 20,
  plantlife_limit = -0.7,
  spawn_chance = 10,
  spawn_delay = 500,
  spawn_on_side = true,
  spawn_surfaces = {"moretrees:willow_leaves"},
})
