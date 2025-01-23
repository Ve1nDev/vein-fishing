local QBCore = exports['qb-core']:GetCoreObject()



QBCore.Functions.CreateUseableItem(Config.OltaItem, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    TriggerClientEvent('ve1n-fishing:client:BalikTut', src)
end)

RegisterNetEvent('ve1n-fishing:server:BalikVer', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local sans = math.random(1, 100)
    local balikSecimi = nil
    
    for _, balik in pairs(Config.Baliklar) do
        if sans <= balik.sans then
            balikSecimi = balik
            break
        end
        sans = sans - balik.sans
    end
    
    if balikSecimi then
        Player.Functions.AddItem(balikSecimi.item, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[balikSecimi.item], 'add')
    end
end)

RegisterNetEvent('ve1n-fishing:server:OltaSatinAl', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if Player.PlayerData.money['cash'] >= 1000 then
        if Player.Functions.RemoveMoney('cash', 1000, "olta-satin-alma") then
            if Player.Functions.AddItem(Config.OltaItem, 1) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.OltaItem], 'add')
                TriggerClientEvent('QBCore:Notify', src, 'Olta satın aldın!', 'success')
            else
                Player.Functions.AddMoney('cash', 1000, "olta-satin-alma-iade")
                TriggerClientEvent('QBCore:Notify', src, 'Envanterinde yer yok!', 'error')
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli paran yok!', 'error')
    end
end)

RegisterNetEvent('ve1n-fishing:server:BalikSat', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local toplamPara = 0
    local toplamKarapara = 0
    
    for _, balik in pairs(Config.Baliklar) do
        if balik.illegal == data.illegal then
            local item = Player.Functions.GetItemByName(balik.item)
            if item then
                local miktar = item.amount
                toplamPara = toplamPara + (balik.fiyat * miktar)
                if data.illegal then
                    toplamKarapara = toplamKarapara + (balik.fiyat * miktar)
                end
                Player.Functions.RemoveItem(balik.item, miktar)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[balik.item], 'remove', miktar)
            end
        end
    end
    
    if toplamPara > 0 then
        if data.illegal then
            if Config.IllegalKaraParaMiVersin then
                Player.Functions.AddItem(Config.Karaparaitem, toplamKarapara)
                TriggerClientEvent('QBCore:Notify', src, 'Kaçak balıkları ' .. toplamPara .. '$ karşılığında sattın ve ' .. toplamKarapara .. ' karapara kazandın!', 'success')
            else
                Player.Functions.AddMoney('cash', toplamPara + toplamKarapara, "balik-satisi")
                TriggerClientEvent('QBCore:Notify', src, 'Kaçak balıkları ' .. toplamPara .. '$ karşılığında sattın ve ' .. toplamKarapara .. ' normal para kazandın!', 'success')
            end
        else
            Player.Functions.AddMoney('cash', toplamPara, "balik-satisi")
            TriggerClientEvent('QBCore:Notify', src, 'Balıkları ' .. toplamPara .. '$ karşılığında sattın!', 'success')
        end
    else
        if data.illegal then
            TriggerClientEvent('QBCore:Notify', src, 'Satılacak kaçak balığın yok!', 'error')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Satılacak balığın yok!', 'error')
        end
    end
end)


Config.LimitedTriggers = {
    ["ve1n-fishing:server:BalikSat"] = {limit = 1, seconds = 2},
    ["ve1n-fishing:server:BalikVer"] = {limit = 1, seconds = 5},
    ["ve1n-fishing:server:OltaSatinAl"] = {limit = 1, seconds = 2},--- ayarlayın bunları limitini ve saniyesini ayarlıyonuz örnepğin 2 saniye de 1 kere olabilir 2.sinde kick atıyor istediğiniz gibi ayarlayın limitleri
}

-- vein-fishing:server:BalikVer

local limitedTriggers = Config.LimitedTriggers
local triggerCounts = {}

for trigger, limitData in pairs(limitedTriggers) do
    RegisterServerEvent(trigger)
    AddEventHandler(trigger, function(...)
        local src = source
        if not triggerCounts[src] then
            triggerCounts[src] = {}
        end
        if not triggerCounts[src][trigger] then
            triggerCounts[src][trigger] = {count = 0, timestamp = os.time()}
        end

        local currentTime = os.time()
        local elapsedTime = currentTime - triggerCounts[src][trigger].timestamp

        if elapsedTime > limitData.seconds then
            triggerCounts[src][trigger].count = 0
            triggerCounts[src][trigger].timestamp = currentTime
        end

        triggerCounts[src][trigger].count = triggerCounts[src][trigger].count + 1

        if triggerCounts[src][trigger].count > limitData.limit then
            DropPlayer(src, "[VE1N] Yakaladım Seni Hileci Orospu Evladııı @everyone")
        end
    end)
end