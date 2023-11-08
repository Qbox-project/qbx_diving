exports.qbx_core:CreateUseableItem("diving_gear", function(source)
    TriggerClientEvent("qb-diving:client:UseGear", source)
end)

exports.qbx_core:CreateUseableItem("diving_fill", function(source)
    TriggerClientEvent("qb-diving:client:setoxygenlevel", source)
end)

RegisterNetEvent('qb-diving:server:removeItemAfterFill', function()
    exports.ox_inventory:RemoveItem(source, 'diving_fill', 1)
end)