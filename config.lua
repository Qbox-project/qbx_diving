Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use ox_target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)
Config.CopsChance = 0.5 -- The chance of the cops getting called when a coral gets picked up, this ranges from 0.0 to 1.0

Config.CoralLocations = {
    {
        label = "Location #1",
        coords = {
            area = vec3(-2838.8, -376.1, 3.55),
            coral = {
                {
                    coords = vec3(-2850.4, -376.4, -40.1),
                    size = vec3(2.0, 2.0, 3.4),
                    rotation = 0.0
                }
            }
        },
        defaultCoral = 4,
        totalCoral = 4
    }
}

Config.CoralTypes = {
    {
        item = "dendrogyra_coral",
        maxAmount = math.random(1, 5),
        price = math.random(70, 100)
    },
    {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(50, 70)
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
        coords = vec4(-1684.13, -1068.91, 12.15, 100.0),
        model = 'a_m_m_salton_01',
        zone = { -- Only used when not using the target
            coords = vec3(-1684.0, -1069.0, 13.0),
            size = vec3(1, 1, 2),
            rotation = 321.0
        }
    }
}