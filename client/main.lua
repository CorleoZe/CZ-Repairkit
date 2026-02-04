local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("qb-repair:client:RepairVeh", function()
    local playerPed = PlayerPedId()
    
    if IsPedInAnyVehicle(playerPed, false) then
        QBCore.Functions.Notify('Exit your vehicle first.', 'error')
        return
    end

    -- 🔥 ULTRA-RELIABLE: Get entity you're aiming at (like qb-target)
    local rayHandle = StartShapeTestCapsule(
        GetEntityCoords(playerPed),
        GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0),
        0.4,
        10,
        playerPed,
        16
    )
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)

    if not hit or GetEntityType(entityHit) ~= 2 or IsThisModelABike(entityHit) then
        QBCore.Functions.Notify('look at a car to repair it.', 'error')
        return
    end

    local vehicle = entityHit
    local duration = math.random(5000, 10000)

    -- Play bum bin emote
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", -1, true)

    -- Progress bar
    QBCore.Functions.Progressbar("repair", "Repairing...", duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasksImmediately(playerPed)
        TriggerServerEvent("qb-repair:removeitem", "repairkit", 1)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        QBCore.Functions.Notify('Repaired!', 'success')
    end, function()
        ClearPedTasksImmediately(playerPed)
        QBCore.Functions.Notify('Canceled.', 'error')
    end)
end)