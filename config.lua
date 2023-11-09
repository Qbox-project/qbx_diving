Config = {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)
Config.CopsChance = 0.5 -- The chance of the cops getting called when a coral gets picked up, this ranges from 0.0 to 1.0
Config.Debug = false -- shows outline of box zones

---@class Coral
---@field coords vector3
---@field boxDimensions vector4

---@class CoralLocation
---@field blip vector3
---@field corals Coral[]
---@field maxHarvestAmount integer max number of coral that can be taken before the active coral location changes

---@type CoralLocation[]
Config.CoralLocations = {
    {
        blip = vec3(-2838.8, -376.1, 3.55),
        corals = {
            {
                coords = vec3(-2849.25, -377.58, -40.23),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-2838.43, -363.63, -39.45),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-2887.04, -394.87, -40.91),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-2808.99, -385.56, -39.32),
                boxDimensions = vec4(3, 3, 5, 100.0),
            }
        },
        maxHarvestAmount = 4,
    },
    {
        blip = vec3(-3288.2, -67.58, 2.79),
        corals = {
            {
                coords = vec3(-3275.03, -38.58, -19.21),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-3273.73, -76.0, -26.81),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-3346.53, -50.4, -35.84),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
        },
        maxHarvestAmount = 3,
    },
    {
        blip = vec3(-3367.24, 1617.89, 1.39),
        corals = {
            {
                coords = vec3(-3388.01, 1635.88, -39.41),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-3354.19, 1549.3, -38.21),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(-3326.04, 1636.43, -40.98),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
        },
        maxHarvestAmount = 3,
    },
    {
        blip = vec3(3002.5, -1538.28, -27.36),
        corals = {
            {
                coords = vec3(2978.05, -1509.07, -24.96),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(3004.42, -1576.95, -29.36),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(2951.65, -1560.69, -28.36),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
        },
        maxHarvestAmount = 3,
    },
    {
        blip = vec3(3421.58, 1975.68, 0.86),
        corals = {
            {
                coords = vec3(3421.69, 1976.54, -50.64),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(3424.07, 1957.46, -53.04),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(3434.65, 1993.73, -49.84),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(3415.42, 1965.25, -52.04),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
        },
        maxHarvestAmount = 4,
    },
    {
        blip = vec3(2720.14, -2136.28, 0.74),
        corals = {
            {
                coords = vec3(2724.0, -2134.95, -19.33),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(2710.68, -2156.06, -18.63),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(2702.84, -2139.29, -18.51),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(2736.27, -2153.91, -20.88),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
        },
        maxHarvestAmount = 4,
    },
    {
        blip = vec3(536.69, 7253.75, 1.69),
        corals = {
            {
                coords = vec3(542.31, 7245.37, -30.01),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(528.21, 7223.26, -29.51),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(510.36, 7254.97, -32.11),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
            {
                coords = vec3(525.37, 7259.12, -30.51),
                boxDimensions = vec4(3, 3, 5, 100.0),
            },
        },
        maxHarvestAmount = 4,
    },
}

Config.CoralTypes = {
    {
        item = "dendrogyra_coral",
        maxAmount = math.random(1, 5),
        price = math.random(70, 100),
    },
    {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(50, 70),
    }
}
Config.PriceModifiers = {
    {
        minAmount = 5,
        maxAmount = 10,
        minPercentage = 80,
        maxPercentage = 85
    },
    {
        minAmount = 11,
        maxAmount = 15,
        minPercentage = 70,
        maxPercentage = 75
    },
    {
        minAmount = 16,
        minPercentage = 50,
        maxPercentage = 55
    }
}
Config.SellLocations = {
    {
        coords = vec4(-1684.13, -1068.91, 13.15, 100.0),
        model = 'a_m_m_salton_01',
        zoneDimensions = vec3(3, 3, 3), -- Only used when not using the target
    }
}
