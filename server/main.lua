local config = require 'config.server'
local sharedConfig = require 'config.shared'
local currentAreaIndex = math.random(1, #sharedConfig.coralLocations)

---@type table<integer, true> Set of coralIndex
local pickedUpCoralIndexes = {}

local function getItemPrice(amount, price)
    for i = 1, #config.priceModifiers do
        local modifier = config.priceModifiers[i]
        local shouldModify = i == #config.priceModifiers and
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

    for i = 1, #config.coralTypes do
        local coralType = config.coralTypes[i]
        
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
        exports.qbx_core:Notify(src, Lang:t('error.no_coral'), 'error')
        return
    end

    for coral, amount in pairs(availableCoral) do
        local price = amount * coral.price
        local reward = getItemPrice(amount, price)
        exports.ox_inventory:RemoveItem(src, coral.item, amount)
        player.Functions.AddMoney('cash', math.ceil(reward / amount), 'sold-coral')
    end
end)

local function getNewLocation()
    local newLocation
    repeat
        newLocation = math.random(1, #sharedConfig.coralLocations)
    until newLocation ~= currentAreaIndex or #sharedConfig.coralLocations == 1
    return newLocation
end

RegisterNetEvent('qbx_diving:server:takeCoral', function(coralIndex)
    if pickedUpCoralIndexes[coralIndex] then return end
    local src = source
    local coralType = config.coralTypes[math.random(1, #config.coralTypes)]
    local amount = math.random(1, coralType.maxAmount)

    exports.ox_inventory:AddItem(src, coralType.item, amount)
    pickedUpCoralIndexes[coralIndex] = true
    TriggerClientEvent('qbx_diving:client:coralTaken', -1, coralIndex)
    TriggerEvent('qbx_diving:server:coralTaken', sharedConfig.coralLocations[currentAreaIndex].corals[coralIndex].coords)
    if #pickedUpCoralIndexes == sharedConfig.coralLocations[currentAreaIndex].maxHarvestAmount then
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
