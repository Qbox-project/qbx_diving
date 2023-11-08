AddEventHandler('qbx_diving:server:coralTaken', function(coords)
    if math.random() > Config.CopsChance then return end
    for _, player in pairs(exports.qbx_core:GetQBPlayers()) do
        if player.PlayerData.job.type == 'leo' and player.PlayerData.job.onduty then
            local msg = Lang:t("info.cop_msg")
            TriggerClientEvent('qbx_diving:client:addCrimeAlert', player.PlayerData.source, coords, msg)
        end
    end
end)