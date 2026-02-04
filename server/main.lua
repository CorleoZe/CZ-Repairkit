local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("repairkit", function(source, item)
    TriggerClientEvent("qb-repair:client:RepairVeh", source)
end)

RegisterNetEvent('qb-repair:removeitem', function(itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.Functions.GetItemByName(itemName) then
        Player.Functions.RemoveItem(itemName, amount or 1)
    end
end)