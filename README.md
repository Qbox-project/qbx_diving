![image-2](https://github.com/Qbox-project/qbx_diving/assets/3579092/7619ca8c-ba4e-4c55-a5ba-7d889473934e)

# qbx_diving

Collect and sell coral with qbx_diving, a coral/item collection resource that's easy to modify and build on.

Recommended Resources:
- [qbx_divegear](https://github.com/Qbox-project/qbx_divegear) (if you want to be able to breathe underwater...)

# Features

- 17 unique coral collection areas (all collection points tied to actual coral models)
- Larger coral reefs split into smaller patches (marked in config if you'd like to combine them)
- Debug mode for showing coral box zones for adjusting target area
- Variable chance for coral spawns
- Limits on coral harvesting before zones change
- Automatic zone changes if a zone isn't harvested

https://github.com/alberttheprince/qbx_diving/assets/85725579/8e2cbdd1-6786-462d-9a48-741977098283

# Ox_Inventory items

Add the following items to your items.lua file if you don't have them already in ox_inventory:

```
    ['antipatharia_coral'] = {
        label = 'Antipatharia',
        weight = 1000,
        stack = true,
        close = true,
        description = "Also known as black corals or thorn corals."
    },

    ['dendrogyra_coral'] = {
        label = 'Dendrogyra',
        weight = 1000,
        stack = true,
        close = true,
        description = "Also known as a pillar coral."
    },
```

# Images

How debug zones appear when turned on:

![image-3](https://github.com/Qbox-project/qbx_diving/assets/3579092/2189e9ed-367a-4d88-9850-a5e80c152955)

How the blip appears on the world map:

![image-4](https://github.com/Qbox-project/qbx_diving/assets/3579092/b7fc3ccc-b694-4cfb-9b89-35964f1102f2)
