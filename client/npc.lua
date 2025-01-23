local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    RequestModel(GetHashKey(Config.NPCler.satici.model))
    while not HasModelLoaded(GetHashKey(Config.NPCler.satici.model)) do
        Wait(1)
    end
    
    local saticiNPC = CreatePed(4, Config.NPCler.satici.model, Config.NPCler.satici.coords.x, Config.NPCler.satici.coords.y, Config.NPCler.satici.coords.z - 1, Config.NPCler.satici.coords.w, false, true)
    FreezeEntityPosition(saticiNPC, true)
    SetEntityInvincible(saticiNPC, true)
    SetBlockingOfNonTemporaryEvents(saticiNPC, true)
    
    RequestModel(GetHashKey(Config.NPCler.oltaci.model))
    while not HasModelLoaded(GetHashKey(Config.NPCler.oltaci.model)) do
        Wait(1)
    end
    
    local oltaciNPC = CreatePed(4, Config.NPCler.oltaci.model, Config.NPCler.oltaci.coords.x, Config.NPCler.oltaci.coords.y, Config.NPCler.oltaci.coords.z - 1, Config.NPCler.oltaci.coords.w, false, true)
    FreezeEntityPosition(oltaciNPC, true)
    SetEntityInvincible(oltaciNPC, true)
    SetBlockingOfNonTemporaryEvents(oltaciNPC, true)
    
    RequestModel(GetHashKey(Config.NPCler.illegal.model))
    while not HasModelLoaded(GetHashKey(Config.NPCler.illegal.model)) do
        Wait(1)
    end
    
    local illegalNPC = CreatePed(4, Config.NPCler.illegal.model, Config.NPCler.illegal.coords.x, Config.NPCler.illegal.coords.y, Config.NPCler.illegal.coords.z, Config.NPCler.illegal.coords.w, false, true)
    FreezeEntityPosition(illegalNPC, true)
    SetEntityInvincible(illegalNPC, true)
    SetBlockingOfNonTemporaryEvents(illegalNPC, true)
    
    exports['qb-target']:AddTargetEntity(saticiNPC, {
        options = {
            {
                type = "client",
                event = "ve1n-fishing:client:BalikSatMenu",
                icon = "fas fa-fish",
                label = "Balik Sat",
            }
        },
        distance = 2.0
    })
    
    exports['qb-target']:AddTargetEntity(oltaciNPC, {
        options = {
            {
                type = "client",
                event = "ve1n-fishing:client:OltaMenu",
                icon = "fas fa-shopping-cart",
                label = "Olta Satin Al",
            }
        },
        distance = 2.0
    })
    
    exports['qb-target']:AddTargetEntity(illegalNPC, {
        options = {
            {
                type = "client",
                event = "ve1n-fishing:client:IllegalBalikSatMenu",
                icon = "fas fa-fish",
                label = "Kaçak Balik Sat",
            }
        },
        distance = 2.0
    })
    
    CreateThread(function()
        while true do
            local sleep = 1000
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)
            
            local saticiMesafe = #(pos - vector3(Config.NPCler.satici.coords.x, Config.NPCler.satici.coords.y, Config.NPCler.satici.coords.z))
            local oltaciMesafe = #(pos - vector3(Config.NPCler.oltaci.coords.x, Config.NPCler.oltaci.coords.y, Config.NPCler.oltaci.coords.z))
            local illegalMesafe = #(pos - vector3(Config.NPCler.illegal.coords.x, Config.NPCler.illegal.coords.y, Config.NPCler.illegal.coords.z))
            
            if saticiMesafe < 10.0 or oltaciMesafe < 10.0 or illegalMesafe < 10.0 then
                sleep = 0
                if saticiMesafe < 10.0 then
                    QBCore.Functions.DrawText3D(Config.NPCler.satici.coords.x, Config.NPCler.satici.coords.y, Config.NPCler.satici.coords.z + 1.0, Config.NPCler.satici.label)
                end
                if oltaciMesafe < 10.0 then
                    QBCore.Functions.DrawText3D(Config.NPCler.oltaci.coords.x, Config.NPCler.oltaci.coords.y, Config.NPCler.oltaci.coords.z + 1.0, Config.NPCler.oltaci.label)
                end
                if illegalMesafe < 10.0 then
                    QBCore.Functions.DrawText3D(Config.NPCler.illegal.coords.x, Config.NPCler.illegal.coords.y, Config.NPCler.illegal.coords.z + 1.0, Config.NPCler.illegal.label)
                end
            end
            
            Wait(sleep)
        end
    end)
end)

RegisterNetEvent('ve1n-fishing:client:BalikSatMenu', function()
    local BalikciMenu = {
        {
            header = "Balık Satış",
            isMenuHeader = true
        },
        {
            header = "Balık Sat",
            txt = "Tuttuğun balıkları satabilirsin",
            params = {
                isServer = true,
                event = "ve1n-fishing:server:BalikSat",
                args = {illegal = false}
            }
        }
    }
    exports['qb-menu']:openMenu(BalikciMenu)
end)

RegisterNetEvent('ve1n-fishing:client:IllegalBalikSatMenu', function()
    local KacakMenu = {
        {
            header = "Kaçak Balık Satış",
            isMenuHeader = true
        },
        {
            header = "Kaçak Balık Sat",
            txt = "Kaçak balıkları satabilirsin",
            params = {
                isServer = true,
                event = "ve1n-fishing:server:BalikSat",
                args = {illegal = true}
            }
        }
    }
    exports['qb-menu']:openMenu(KacakMenu)
end)

RegisterNetEvent('ve1n-fishing:client:OltaMenu', function()
    local OltaMenu = {
        {
            header = "Olta Satın Al",
            isMenuHeader = true
        },
        {
            header = "Olta Al",
            txt = "Fiyat: $1000",
            params = {
                isServer = true,
                event = "ve1n-fishing:server:OltaSatinAl",
            }
        }
    }
    exports['qb-menu']:openMenu(OltaMenu)
end) 