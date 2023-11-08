local currentDivingArea = math.random(1, #Config.CoralLocations)

local function getItemPrice(amount, price)
    for i = 1, #Config.PriceModifiers do
        local modifier = Config.PriceModifiers[i]
        local shouldModify = i == #Config.PriceModifiers and
            amount >= modifier.minAmount or
            amount >= modifier.minAmount and
            amount <= modifier.maxAmount
        if shouldModify then
            price /= 100 * math.random(modifier.minPercentage, modifier.maxPercentage)
            price = math.ceil(price)
        end
    end

    return price
end

local function hasCoral(src)
    local availableCoral = {}

    for i = 1, #Config.CoralTypes do
        local coralType = Config.CoralTypes[i]
        if exports.ox_inventory:Search(src, 'count', coralType.item) > 0 then
            availableCoral[#availableCoral + 1] = coralType
        end
    end

    return availableCoral
end

RegisterNetEvent('qb-diving:server:CallCops', function(coords)
    for _, player in pairs(exports.qbx_core:GetQBPlayers()) do
        if player.PlayerData.job.type == 'leo' and player.PlayerData.job.onduty then
            local msg = Lang:t("info.cop_msg")
            TriggerClientEvent('qb-diving:client:CallCops', player.PlayerData.source, coords, msg)
            local alertData = {
                title = Lang:t("info.cop_title"),
                coords = coords,
                description = msg
            }
            TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
        end
    end
end)

RegisterNetEvent('qb-diving:server:SellCoral', function()
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    local availableCoral = hasCoral(src)
    if #availableCoral == 0 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_coral"), 'error')
        return
    end

    for i = 1, #availableCoral do
        local coral = availableCoral[i]
        local amount = exports.ox_inventory:Search(src, 'count', coral.item)
        local price = amount * coral.price
        local reward = getItemPrice(amount, price)
        exports.ox_inventory:RemoveItem(src, coral.item, amount)
        player.Functions.AddMoney('cash', math.ceil(reward / amount), "sold-coral")
    end
end)

--- TODO: do not modify Config
RegisterNetEvent('qb-diving:server:TakeCoral', function(area, coral, bool)
    local src = source
    local coralType = Config.CoralTypes[math.random(1, #Config.CoralTypes)]
    local amount = math.random(1, coralType.maxAmount)

    exports.ox_inventory:AddItem(src, coralType.item, amount)
    if Config.CoralLocations[area].maxHarvestAmount - 1 == 0 then
        for _, v in pairs(Config.CoralLocations[currentDivingArea].corals) do
            v.PickedUp = false
        end
        Config.CoralLocations[currentDivingArea].maxHarvestAmount = #Config.CoralLocations[currentDivingArea].corals
        local newLocation = math.random(1, #Config.CoralLocations)
        while newLocation == currentDivingArea do
            newLocation = math.random(1, #Config.CoralLocations)
        end
        currentDivingArea = newLocation
        TriggerClientEvent('qb-diving:client:NewLocations', -1)
    else
        Config.CoralLocations[area].corals[coral].PickedUp = bool
        Config.CoralLocations[area].maxHarvestAmount -= 1
    end

    TriggerClientEvent('qb-diving:client:UpdateCoral', -1, area, coral, bool)
end)

RegisterNetEvent('qb-diving:server:removeItemAfterFill', function()
    exports.ox_inventory:RemoveItem(source, 'diving_fill', 1)
end)

--- TODO: config should be static. Client shouldn't need a config update
lib.callback.register('qb-diving:server:GetDivingConfig', function()
    return Config.CoralLocations, currentDivingArea
end)

exports.qbx_core:CreateUseableItem("diving_gear", function(source)
    TriggerClientEvent("qb-diving:client:UseGear", source)
end)

exports.qbx_core:CreateUseableItem("diving_fill", function(source)
    TriggerClientEvent("qb-diving:client:setoxygenlevel", source)
end)
