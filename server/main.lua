local currentDivingArea = math.random(1, #Config.CoralLocations)
local availableCoral = {}

-- Functions

local function getItemPrice(amount, price)
    for k, v in pairs(Config.PriceModifiers) do
        local modifier = #Config.PriceModifiers == k and amount >= v.minAmount or amount >= v.minAmount and amount <= v.maxAmount
        if modifier then
            price /= 100 * math.random(v.minPercentage, v.maxPercentage)
            price = math.ceil(price)
        end
    end

    return price
end

local function hasCoral(src)
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return false end

    availableCoral = {}

    for _, v in pairs(Config.CoralTypes) do
        local item = Player.Functions.GetItemByName(v.item)
        if item then
            availableCoral[#availableCoral + 1] = v
        end
    end

    return table.type(availableCoral) ~= 'empty'
end

-- Events

RegisterNetEvent('qb-diving:server:CallCops', function(coords)
    for _, Player in pairs(exports.qbx_core:GetQBPlayers()) do
        if Player then
            if Player.PlayerData.job.type == "leo" and Player.PlayerData.job.onduty then
                local msg = Lang:t("info.cop_msg")
                TriggerClientEvent('qb-diving:client:CallCops', Player.PlayerData.source, coords, msg)
                local alertData = {
                    title = Lang:t("info.cop_title"),
                    coords = coords,
                    description = msg
                }
                TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
            end
        end
    end
end)

RegisterNetEvent('qb-diving:server:SellCoral', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    if not hasCoral(src) then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_coral"), 'error')
        return
    end

    for _, v in pairs(availableCoral) do
        local item = Player.Functions.GetItemByName(v.item)
        local price = item.amount * v.price
        local reward = getItemPrice(item.amount, price)
        Player.Functions.RemoveItem(item.name, item.amount)
        Player.Functions.AddMoney('cash', math.ceil(reward / item.amount), "sold-coral")
        TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[item.name], "remove")
    end
end)

RegisterNetEvent('qb-diving:server:TakeCoral', function(area, coral, bool)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    local coralType = math.random(1, #Config.CoralTypes)
    local amount = math.random(1, Config.CoralTypes[coralType].maxAmount)
    local ItemData = exports.ox_inventory:Items()[Config.CoralTypes[coralType].item]
    if amount > 1 then
        for _ = 1, amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], amount)
    end
    if (Config.CoralLocations[area].TotalCoral - 1) == 0 then
        for _, v in pairs(Config.CoralLocations[currentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        Config.CoralLocations[currentDivingArea].TotalCoral = Config.CoralLocations[currentDivingArea].DefaultCoral
        local newLocation = math.random(1, #Config.CoralLocations)
        while newLocation == currentDivingArea do
            Wait(0)
            newLocation = math.random(1, #Config.CoralLocations)
        end
        currentDivingArea = newLocation
        TriggerClientEvent('qb-diving:client:NewLocations', -1)
    else
        Config.CoralLocations[area].coords.Coral[coral].PickedUp = bool
        Config.CoralLocations[area].TotalCoral -= 1
    end

    TriggerClientEvent('qb-diving:client:UpdateCoral', -1, area, coral, bool)
end)

RegisterNetEvent('qb-diving:server:removeItemAfterFill', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    Player.Functions.RemoveItem("diving_fill", 1)
end)

-- Callbacks

lib.callback.register('qb-diving:server:GetDivingConfig', function()
    return Config.CoralLocations, currentDivingArea
end)

-- Items

exports.qbx_core:CreateUseableItem("diving_gear", function(source)
    TriggerClientEvent("qb-diving:client:UseGear", source)
end)

exports.qbx_core:CreateUseableItem("diving_fill", function(source)
    TriggerClientEvent("qb-diving:client:setoxygenlevel", source)
end)
