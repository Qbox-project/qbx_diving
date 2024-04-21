lib.versionCheck('Qbox-project/qbx_diving')
assert(lib.checkDependency('ox_lib', '3.20.0', true))

local config = require 'config.server'
local sharedConfig = require 'config.shared'
local currentAreaIndex = math.random(1, #sharedConfig.coralLocations)

---@type table<integer, true> Set of coralIndex
local pickedUpCoralIndexes = {}

local function getItemPrice(amount, price)
    for i = 1, #config.priceModifiers do
        local modifier = config.priceModifiers[i]
        local shouldModify = i == #config.priceModifiers and amount >= modifier.minAmount or amount >= modifier.minAmount and amount <= modifier.maxAmount
        if shouldModify then
            price = price / 100 * math.random(modifier.minPercentage, modifier.maxPercentage)
            break
        end
    end
    return price
end

RegisterNetEvent('qbx_diving:server:sellCoral', function()
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end
    local payout = 0

    for i = 1, #config.coralTypes do
        local coral = config.coralTypes[i]
        local count = exports.ox_inventory:GetItemCount(src, coral.item)

        if count and count > 0 then
            if exports.ox_inventory:RemoveItem(src, coral.item, count) then
                local price = count * coral.price
                local reward = getItemPrice(count, price)
                payout += math.ceil(reward)
            end
        end
    end
    if payout == 0 then
        return lib.notify(src, {
            type = 'error',
            description = 'No coral to sell!',
        })
    end
    player.Functions.AddMoney('cash', payout, 'sold-coral')
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
