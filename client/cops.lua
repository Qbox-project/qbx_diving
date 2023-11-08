RegisterNetEvent('qbx_diving:client:addCrimeAlert', function(coords, msg)
    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', false, 0, true)
    TriggerEvent('chatMessage', Lang:t('error.911_chatmessage'), 'error', msg)
    local transG = 100
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, transG)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Lang:t('info.blip_text'))
    EndTextCommandSetBlipName(blip)

    repeat
        Wait(180 * 4)
        transG -= 1
        SetBlipAlpha(blip, transG)
    until transG == 0

    SetBlipSprite(blip, 2)
    RemoveBlip(blip)

    local alertData = {
        title = Lang:t("info.cop_title"),
        coords = coords,
        description = msg
    }
    TriggerEvent("qb-phone:client:addPoliceAlert", alertData)
end)