vines = {
  name = 'vines',
  groups = { vines=1, snappy=3, flammable=2 },
  recipes = {}
}

dofile( minetest.get_modpath( vines.name ) .. "/functions.lua" )
dofile( minetest.get_modpath( vines.name ) .. "/recipes.lua" )
dofile( minetest.get_modpath( vines.name ) .. "/crafts.lua" )
dofile( minetest.get_modpath( vines.name ) .. "/nodes.lua" )
dofile( minetest.get_modpath( vines.name ) .. "/shear.lua" )
dofile( minetest.get_modpath( vines.name ) .. "/vines.lua" )
dofile( minetest.get_modpath( vines.name ) .. "/spawning.lua" )

print("[Vines] Loaded!")
