local currentAreaIndex = math.random(1, #Config.CoralLocations)

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

local function getCoralInInventory(src)
    local availableCoral = {}

    for i = 1, #Config.CoralTypes do
        local coralType = Config.CoralTypes[i]
        
        local count = exports.ox_inventory:GetItemCount(src, coralType.item)
        if count then
            availableCoral[coralType] = count
        end
    end

    return availableCoral
end

RegisterNetEvent('qbx_diving:server:sellCoral', function()
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    local availableCoral = getCoralInInventory(src)
    if #availableCoral == 0 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_coral"), 'error')
        return
    end

    for coral, amount in pairs(availableCoral) do
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
    until newLocation ~= currentAreaIndex or #Config.CoralLocations == 1
    return newLocation
end

RegisterNetEvent('qbx_diving:server:takeCoral', function(coralIndex)
    if pickedUpCoralIndexes[coralIndex] then return end
    local src = source
    local coralType = Config.CoralTypes[math.random(1, #Config.CoralTypes)]
    local amount = math.random(1, coralType.maxAmount)

    exports.ox_inventory:AddItem(src, coralType.item, amount)
    pickedUpCoralIndexes[coralIndex] = true
    TriggerClientEvent('qbx_diving:client:coralTaken', -1, coralIndex)
    TriggerEvent('qbx_diving:server:coralTaken', Config.CoralLocations[currentAreaIndex].corals[coralIndex].coords)
    if #pickedUpCoralIndexes == Config.CoralLocations[currentAreaIndex].maxHarvestAmount then
        pickedUpCoralIndexes = {}
        currentAreaIndex = getNewLocation()
        TriggerClientEvent('qbx_diving:client:newLocationSet', -1, currentAreaIndex)
    end
end)

---@return integer areaIndex
---@return table<integer, true> pickedUpCoralIndexes
lib.callback.register('qbx_diving:server:getCurrentDivingArea', function()
    return currentAreaIndex, pickedUpCoralIndexes
end)
