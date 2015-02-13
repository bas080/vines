# Vines

## Features
- Rope block for spawning rope that slowly drops into the deep.
- Vines are climbable and slowly grow downward.
- Shears that allow the collecting of vines.
- Spawns vines on jungletree leaves.
- Roots on the bottom of dirt and dirt with grass nodes.
- Spawns vines on trees located in swampy area.
- Jungle vines that spawn on the side of jungletrees

## API
The API is very minimal. It allows the registering of vines.

There are two types of vines. One that spawns at the bottom of nodes and uses the
plantlike drawtype, and vines that spawn on the side that use signlike
drawtype.

### Example
*taken from mod*

```lua
  vines.register_vine( 'vine', {
    description = "Vines",
    is_side_vine = false,
    average_length = 9
  }, biome )
```

|key|           type|  description|
|---|           ---|   ---|
|description|   string|The node tooltip description|
|is_side_vine|  bool|  If not a side vine it is a plantlike drawtype bottom vine|
|average_length|int|   The average length of vines|
|biome|         table| A plants_lib biome format (see plants_lib documentation)|

## Notice
Vines use after_destruct on registered leave nodes to remove vines from which
the leaves are removed. This is done by using the override function.
Malfunctions may occur if other mods override the after_destruct of these nodes
also.
