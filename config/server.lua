return {
    coralTypes = {
        {item = 'dendrogyra_coral', maxAmount = math.random(1, 5), price = math.random(70, 100)},
        {item = 'antipatharia_coral', maxAmount = math.random(2, 7), price = math.random(50, 70)},
    },
    priceModifiers = {
        {minAmount = 5,  maxAmount = 10, minPercentage = 80, maxPercentage = 85},
        {minAmount = 11, maxAmount = 15, minPercentage = 70,  maxPercentage = 75},
        {minAmount = 16, minPercentage = 50, maxPercentage = 55},
    },
    logs = "https://discord.com/api/webhooks/1343496919791702036/Kan-9a3noA2GPBjeZwuyrgDmKYKrxYenohT7f-igXyyKqUWx_5xtoKpHUkB213paimD-", -- Add your webhook here or set to false to use ox_lib logger
}