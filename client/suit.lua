local currentGear = {
    mask = 0,
    tank = 0,
    oxygen = 0,
    enabled = false
}

local isWearingSuit = false
local oxygenLevel = 0

RegisterNetEvent("qb-diving:client:setoxygenlevel", function()
    if oxygenLevel == 0 then
        oxygenLevel = Config.OxygenLevel
        exports.qbx_core:Notify(Lang:t("success.tube_filled"), 'success')
        TriggerServerEvent('qb-diving:server:removeItemAfterFill')
        return
    end

    exports.qbx_core:Notify(Lang:t("error.oxygenlevel", {oxygenlevel = oxygenLevel}), 'error')
end)

local function deleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, false, true)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end

	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, false, true)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

RegisterNetEvent('qb-diving:client:UseGear', function()
    if isWearingSuit then
        if lib.progressBar({
            duration = 5000,
            label = Lang:t("info.pullout_suit"),
            useWhileDead = false,
            canCancel = true,
            anim = {
                dict = "clothingshirt",
                clip = "try_shirt_positive_d",
                blendIn = 8.0
            }
        }) then
            SetEnableScuba(cache.ped, false)
            SetPedMaxTimeUnderwater(cache.ped, 50.00)
            currentGear.enabled = false
            deleteGear()
            exports.qbx_core:Notify(Lang:t("success.took_out"))
            TriggerServerEvent("InteractSound_SV:PlayOnSource", nil, 0.25)
            isWearingSuit = false
            oxygenLevel = oxygenLevel
        end

        ClearPedTasks(cache.ped)
    else
        if oxygenLevel <= 0 then
            exports.qbx_core:Notify(Lang:t("error.need_otube"), 'error')
            return
        end

        isWearingSuit = true

        if IsPedSwimming(cache.ped) or cache.vehicle then
            exports.qbx_core:Notify(Lang:t("error.not_standing_up"), 'error')
            return
        end

        if lib.progressBar({
            duration = 5000,
            label = Lang:t("info.put_suit"),
            useWhileDead = false,
            canCancel = true,
            anim = {
                dict = "clothingshirt",
                clip = "try_shirt_positive_d",
                blendIn = 8.0
            }
        }) then
            deleteGear()
            local maskModel = `p_d_scuba_mask_s`
            local tankModel = `p_s_scuba_tank_s`
            lib.requestModel(maskModel)
            lib.requestModel(tankModel)
            currentGear.tank = CreateObject(tankModel, 1.0, 1.0, 1.0, true, true, false)
            local bone1 = GetPedBoneIndex(cache.ped, 24818)
            AttachEntityToEntity(currentGear.tank, cache.ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, true, true, false, false, 2, true)
            currentGear.mask = CreateObject(maskModel, 1.0, 1.0, 1.0, true, true, false)
            local bone2 = GetPedBoneIndex(cache.ped, 12844)
            AttachEntityToEntity(currentGear.mask, cache.ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, true, true, false, false, 2, true)
            SetEnableScuba(cache.ped, true)
            SetPedMaxTimeUnderwater(cache.ped, 2000.00)
            currentGear.enabled = true
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
            CreateThread(function()
                while currentGear.enabled do
                    if IsPedSwimmingUnderWater(cache.ped) and oxygenLevel > 0 then
                        oxygenLevel -= 1
                        if oxygenLevel % 10 == 0 and oxygenLevel ~= Config.OxygenLevel then
                            TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                        elseif oxygenLevel == 0 then
                            SetEnableScuba(cache.ped, false)
                            SetPedMaxTimeUnderwater(cache.ped, 1.00)
                            currentGear.enabled = false
                            isWearingSuit = false
                            TriggerServerEvent("InteractSound_SV:PlayOnSource", nil, 0.25)
                        end
                    end
                    Wait(1000)
                end
            end)
        end

        ClearPedTasks(cache.ped)
    end
end)

local function DrawText(text)
	SetTextFont(4)
	SetTextProportional(true)
	SetTextScale(0.0, 0.45)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.45, 0.90)
end

CreateThread(function()
    while true do
        if currentGear.enabled and isWearingSuit then
            if IsPedSwimmingUnderWater(cache.ped) then
                DrawText(oxygenLevel..'⏱')
            end
        end
        Wait(0)
    end
end)
