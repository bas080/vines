local property, gen = luanti_check()
local range = 40

property("Spawns vines", function(t)
    local player = gen.player_pos({
        pos = { y = range * 2 },
    })

    t.on_emerge(function()
        t.done(player)
    end, range)
end, function(t, player)
    local _, node_pos = gen.node_pos({ player = player, radius = range, nodenames = "group:vines" })

    gen.player_pos({
        player = player,
        pos = node_pos,
    })

    t.done(player, node_pos)
end, function(t, player, node_pos)
    -- find all nodes in range and check that they follow certain rules by iterating over them.
    -- vine nodes should always  b
    -- must always have either a node above or below.

    local found = core.find_nodes_in_area(vector.add(node_pos, -range), vector.add(node_pos, range), { "group:vines" })

    gen.where(#found > 0)

    for _, pos in ipairs(found) do
        local down = vector.add(pos, { y = -1, x = 0, z = 0 })
        local up = vector.add(pos, { y = 1, x = 0, z = 0 })

        if core.get_node(down).name == "air" and core.get_node(up).name == "air" then
            player:set_pos(pos)

            -- t.ok(core.get_node(down).name ~= "air" or core.get_node(up).name ~= "air",
            error("Should not have dangling vines. This check is not good enough though.")
        end

        -- "Must have a node either above or below the vine")
    end

    t.done()
end)
