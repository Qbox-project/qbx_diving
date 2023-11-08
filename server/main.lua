local currentDivingArea = math.random(1, #Config.CoralLocations)

--- Maybe table<integer, boolean>
---@type integer[]
local pickedUpCoralIndexes = {}

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

local function getNewLocation()
    local newLocation
    repeat
        newLocation = math.random(1, #Config.CoralLocations)
    until newLocation ~= currentDivingArea
    return newLocation
end

--- TODO: do not modify Config
RegisterNetEvent('qb-diving:server:TakeCoral', function(area, coralIndex)
    local src = source
    local coralType = Config.CoralTypes[math.random(1, #Config.CoralTypes)]
    local amount = math.random(1, coralType.maxAmount)

    exports.ox_inventory:AddItem(src, coralType.item, amount)
    pickedUpCoralIndexes[#pickedUpCoralIndexes+1] = coralIndex
    if #pickedUpCoralIndexes == Config.CoralLocations[area].maxHarvestAmount then
        pickedUpCoralIndexes = {}
        currentDivingArea = getNewLocation()
        TriggerClientEvent('qb-diving:client:NewLocations', -1)
    end

    TriggerClientEvent('qbx_diving:client:coralTaken', -1, area, coralIndex)
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
