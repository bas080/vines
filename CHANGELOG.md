# Changelog

## 0.0.5

- Place media license in LICENSE.txt.
- Format code with stylua.

## 0.0.4

- Fix spawning on mapgen again and try and improve it.
- Format code and fix luacheck errors.

## 0.0.3

- Updated project description in README.
- Added automated spawn check (`check.lua`) for vines.
- Refactored code to use shared helpers:
  - `wallmounted_to_facedir.lua`
  - `register_decoration.lua`
- Switched to custom `register_decoration` with `on_position` callback
  and simplified spawn so check can be removed because offset is good enough.
- Cleaned up unused variables and code paths
- Added `luanti_check` as optional dependency
- Updated screenshot

## 0.0.2

- Subtle visual tweaks to vine tiles and nodebox for improved aesthetics.

## 0.0.1

- Added automatic migration for legacy vine nodes and inventory items to new `_v2` node variants.
- Used helper from `luanti_utils` (`extend_group`, `migrate_node`, `migrate_inventory`).
- Added new vine growth system supporting sideways and downward growth with directional logic.
- Added metadata tracking between parent and child vine nodes to improve cleanup and structural consistency.
- Added internationalization using `.po` files with new languages.
- Added `.pot` translation template for translators.
- Added placement logic that determines vine orientation from player placement direction for facedir.
- Ported mod API usage from `minetest.*` to `core.*`.
- Increased average length of standard vines.
- Updated rope nodes with waving animation and minor logic improvements.
- Updated Luacheck configuration to support `core`, `vector`, `luanti_utils`, and `table.copy`.
- Replaced `spawn_on_bottom` / `spawn_on_side` with unified `flags` (`all_floors`, `all_ceilings`).
- Removed old unused module files.
- Removed old translation format (`.tr` files and template).
- Improved vine destruction handling to maintain proper vine ends.
- Improved dig logic to break entire vine chains cleanly.
- Added required dependency on `luanti_utils`.

## 0.0.0

- Rope block for spawning rope that slowly drops into the deep.
- Vines are climbable and slowly grow downward.
- Shears that allow the faster collecting of vines.
- Spawns vines on jungletree leaves.
- Roots on the bottom of dirt and dirt with grass nodes.
- Spawns vines on trees located in swampy area.
- Jungle vines that spawn on the side of jungletrees
