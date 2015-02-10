vines.register_vine = function( name, defs )
  --different properties for bottom and side vines.
  local drawtype = ''
  local selection_box
  if ( defs.is_side_vine ) then
    selection_box = {
      type = "wallmounted",
    }
    drawtype = 'signlike'
  else
    selection_box = {
      type = "fixed",
      fixed = { -0.4, -1/2, -0.4, 0.4, 1/2, 0.4 },
    }
    drawtype = 'plantlike'
  end

  minetest.register_node("vines:"..name, {
    description = defs.description,
    walkable = false,
    climbable = true,
    wield_image = "vines_"..name..".png",
    drop = "",
    sunlight_propagates = true,
    paramtype = "light",
    paramtype2 = "wallmounted",
    buildable_to = true,
    tile_images = { "vines_"..name..".png" },
    drawtype = drawtype,
    inventory_image = "vines_"..name..".png",
    groups = vines.groups,
    sounds = default.node_sound_leaves_defaults(),
    selection_box = selection_box,
    on_construct = function( pos )
      local timer = minetest.get_node_timer( pos )
      timer:start( math.random(5, 10) )
    end,
    on_timer = function( pos )
      local node = minetest.get_node( pos )
      local bottom = {x=pos.x, y=pos.y-1, z=pos.z}
      local bottom_node = minetest.get_node( bottom )
      if bottom_node.name == "air" then
        if not ( math.random( defs.average_length ) == 1 ) then
          minetest.set_node( pos, { name = node.name..'_rotten', param2 = node.param2 } )
          minetest.set_node( bottom, { name = node.name, param2 = node.param2 } )
          local timer = minetest.get_node_timer( bottom_node )
          timer:start( math.random(5, 10) )
        end
      end
    end,
    after_dig_node = function(pos, node, oldmetadata, user)
      vines.dig_vine( pos, node, user )
    end
  })

  local name = name..'_rotten'

  minetest.register_node( "vines:"..name, {
    description = "Rotten "..defs.description,
    walkable = false,
    climbable = true,
    drop = "",
    sunlight_propagates = true,
    paramtype = "light",
    paramtype2 = "wallmounted",
    buildable_to = true,
    tile_images = { "vines_"..name..".png" },
    wield_image = "vines_"..name..".png",
    drawtype = drawtype,
    inventory_image = "vines_"..name..".png",
    groups = vines.groups,
    sounds = default.node_sound_leaves_defaults(),
    selection_box = selection_box,
    on_destruct = function( pos )
      local node = minetest.get_node( pos )
      local bottom = {x=pos.x, y=pos.y-1, z=pos.z}
      local bottom_node = minetest.get_node( bottom )
      if minetest.get_item_group( bottom_node.name, "vines") then
        minetest.remove_node( bottom )
      end
    end,
    after_dig_node = function(pos, node, oldmetadata, user)
      vines.dig_vine( pos, node, user )
    end
  })
end

vines.dig_vine = function( pos, node, user )
  --only dig give the vine if shears are used
  if not user then return false end
  local wielded = user:get_wielded_item()
  if 'vines:shears' == wielded:get_name() then 
    local inv = user:get_inventory()
    if inv then
      inv:add_item("main", ItemStack(node.name))
    end
  end
end
