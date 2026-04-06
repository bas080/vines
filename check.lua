-- luacheck: read_globals luanti_check

local test, gen = luanti_check()

test("Spawns valid vines", function(t)
	local player = gen.player_pos({
		pos = { y = 45 },
	})

	local function on_emerge()
		local positions = gen.node_positions({ nodenames = "group:vines" })

		if #positions == 0 then
			return t.retry("Did not find vines")
		end

		for _, pos in pairs(positions) do
			local child_pos_str = core.get_meta(pos):get_string("child_pos")

			-- Not correct, needs more thought
			-- t.ok(
			-- 	core.get_node(vector.add(pos, down)).name ~= "air" or
			-- 	  core.get_node(vector.add(pos, up)).name ~= "air",
			-- 	"Vines at "..vector.to_string(pos).." has non air below or above it"
			-- )

			-- check if child_pos has parent pos and parent pos has child pos.
			-- check if end vine has no child pos

			if math.random(3) == 1 then
				if child_pos_str ~= "" then
					local child_pos = vector.from_string(child_pos_str)

					-- It is possible that child node was removed during mapgen.
					if core.get_node(child_pos).name ~= "air" then
						core.dig_node(pos, player)
						-- child pos is air after parent dig.
						-- cannot do a test like this because it allows for race-conditions. :( bad Luanti
						t.after(2, function()
							t.ok(
								core.get_node(child_pos).name == "air",
								"Node at " .. child_pos_str .. " is removed after parent is dug."
							)
						end)
					end
				end
			end
		end

		t.done()
	end

	t.emerge(on_emerge)
end)
