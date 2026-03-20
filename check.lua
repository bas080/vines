local property, gen = luanti_check()
local range = 40

property("Spawns vines", function(t)
    local player = gen.player_pos({
        pos = { y = range * 2 },
    })

    t.on_emerge(function()
        t.done(player)
    end)
end, function(t, player)
    local pos = player:get_pos()
    local node_pos = core.find_node_near(pos, range, "group:vines", true)

    -- Retry if the node was a sea level node.
    gen.where(node_pos ~= nil)

    -- Jump to vine for inspection.
    gen.player_pos({
        player = player,
        pos = node_pos
    })

    t.done() -- Reached the end. It seems you have spawned a waterfall.
end)
