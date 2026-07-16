lib.versionCheck('Qbox-project/qbx_diving')
assert(lib.checkDependency('ox_lib', '3.20.0', true))

local logger = require '@qbx_core.modules.logger'
local config = require 'config.server'
local sharedConfig = require 'config.shared'
local currentAreaIndex = math.random(1, #sharedConfig.coralLocations)

---@type table<integer, true> Set of coralIndex
local pickedUpCoralIndexes = {}
local harvestCooldowns = {}

---@param source number
---@param coords vector3
---@param maxDistance number
---@return boolean
local function isPlayerNear(source, coords, maxDistance)
    local ped = GetPlayerPed(source)
    if ped == 0 then return false end

    return #(GetEntityCoords(ped) - coords) <= maxDistance
end

---@param source number
---@return boolean
local function isNearSeller(source)
    for i = 1, #sharedConfig.sellLocations do
        if isPlayerNear(source, sharedConfig.sellLocations[i].coords.xyz, 5.0) then
            return true
        end
    end

    return false
end

local function getItemPrice(amount, price)
    for i = 1, #config.priceModifiers do
        local modifier = config.priceModifiers[i]
        local shouldModify = i == #config.priceModifiers and amount >= modifier.minAmount or
        amount >= modifier.minAmount and amount <= modifier.maxAmount
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
    if not player or not isNearSeller(src) then return end
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
        logger.log({
            source = src,
            event = 'qbx_diving:server:sellCoral',
            message = locale('logs.tried_sell'),
            webhook = config.discordWebhook,
        })
        return exports.qbx_core:Notify(src, locale('error.no_coral'), 'error')
    end

    logger.log({
        source = src,
        event = 'qbx_diving:server:sellCoral',
        message = locale('logs.sell_coral', payout),
        webhook = config.discordWebhook,
    })
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
    local src = source
    if type(coralIndex) ~= 'number' or coralIndex % 1 ~= 0 or pickedUpCoralIndexes[coralIndex] then return end

    local player = exports.qbx_core:GetPlayer(src)
    local area = sharedConfig.coralLocations[currentAreaIndex]
    local coral = area and area.corals[coralIndex]
    if not player or not coral or not isPlayerNear(src, coral.coords, 5.0) then return end

    local currentTime = GetGameTimer()
    if harvestCooldowns[src] and currentTime - harvestCooldowns[src] < 3000 then return end
    harvestCooldowns[src] = currentTime

    pickedUpCoralIndexes[coralIndex] = true
    local coralType = config.coralTypes[math.random(1, #config.coralTypes)]
    local amount = math.random(1, coralType.maxAmount)

    local added = exports.ox_inventory:AddItem(src, coralType.item, amount)
    if not added then
        pickedUpCoralIndexes[coralIndex] = nil
        return
    end

    TriggerClientEvent('qbx_diving:client:coralTaken', -1, coralIndex)
    TriggerEvent('qbx_diving:server:coralTaken', coral.coords)

    logger.log({
        source = src,
        event = 'qbx_diving:server:takeCoral',
        message = locale('logs.collect_coral', coralIndex),
        webhook = config.discordWebhook,
    })

    if qbx.table.size(pickedUpCoralIndexes) >= area.maxHarvestAmount then
        pickedUpCoralIndexes = {}
        currentAreaIndex = getNewLocation()
        TriggerClientEvent('qbx_diving:client:newLocationSet', -1, currentAreaIndex)
        logger.log({
            source = src,
            event = 'qbx_diving:server:takeCoral',
            message = locale('logs.new_location', currentAreaIndex),
            webhook = config.discordWebhook,
        })
    end
end)

---@return integer areaIndex
---@return table<integer, true> pickedUpCoralIndexes
lib.callback.register('qbx_diving:server:getCurrentDivingArea', function()
    return currentAreaIndex, pickedUpCoralIndexes
end)

AddEventHandler('playerDropped', function()
    harvestCooldowns[source] = nil
end)
