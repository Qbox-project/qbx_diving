local currentDivingArea = math.random(1, #Config.CoralLocations)

---@type table<integer, true> Set of coralIndex
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
    until newLocation ~= currentDivingArea or #Config.CoralLocations == 1
    return newLocation
end

RegisterNetEvent('qb-diving:server:TakeCoral', function(area, coralIndex)
    if pickedUpCoralIndexes[coralIndex] then return end
    local src = source
    local coralType = Config.CoralTypes[math.random(1, #Config.CoralTypes)]
    local amount = math.random(1, coralType.maxAmount)

    exports.ox_inventory:AddItem(src, coralType.item, amount)
    pickedUpCoralIndexes[coralIndex] = true
    TriggerClientEvent('qbx_diving:client:coralTaken', -1, coralIndex)
    if #pickedUpCoralIndexes == Config.CoralLocations[area].maxHarvestAmount then
        pickedUpCoralIndexes = {}
        currentDivingArea = getNewLocation()
        TriggerClientEvent('qbx_diving:client:newLocationSet', -1, currentDivingArea)
    end
end)

---@return integer areaIndex
---@return table<integer, true> pickedUpCoralIndexes
lib.callback.register('qbx_diving:server:getCurrentDivingArea', function()
    return currentDivingArea, pickedUpCoralIndexes
end)
