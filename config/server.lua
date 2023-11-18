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
}