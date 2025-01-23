local QBCore = exports['qb-core']:GetCoreObject()
local balikTutuyor = false
local yakinBalikAlani = false

local function BalikTutmaAnimasyonu()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    local prop = CreateObject(`prop_fishing_rod_01`, coords, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

    RequestAnimDict('mini@tennis')
    while not HasAnimDictLoaded('mini@tennis') do
        Wait(0)
    end
    TaskPlayAnim(ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)

    Wait(1400)

    RequestAnimDict('amb@world_human_stand_fishing@idle_a')
    while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do
        Wait(0)
    end
    TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_a', 1.0, -1.0, -1, 49, 0, 0, 0, 0)

    return prop
end

local function BalikTutmaOyunu(callback)
    exports['ps-ui']:Circle(function(success)
        if success then
            QBCore.Functions.Notify('Balık tuttun!', 'success')
            TriggerServerEvent('ve1n-fishing:server:BalikVer')
        else
            QBCore.Functions.Notify('Balık kaçtı!', 'error')
        end
        callback(success)
    end, 2, 13)
end

RegisterNetEvent('ve1n-fishing:client:BalikTut', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local mesafe = #(coords - Config.BalikTutmaAlani.merkez)

    if mesafe <= Config.BalikTutmaAlani.radius then
        if not balikTutuyor then
            if not IsPedInAnyVehicle(ped, true) then
                balikTutuyor = true
                local oltaProp = BalikTutmaAnimasyonu()
                
                QBCore.Functions.Progressbar('balik_tut', 'Balık tutuyorsun...', 6000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() end)

                Citizen.Wait(3500)
                BalikTutmaOyunu(function(basarili)
                    TriggerEvent('progressbar:cancel')
                    ClearPedTasks(PlayerPedId())
                    DeleteObject(oltaProp)
                    balikTutuyor = false
                end)
            else
                QBCore.Functions.Notify('Araç içinde balık tutamazsın!', 'error')
            end
        else
            QBCore.Functions.Notify('Zaten balık tutuyorsun!', 'error')
        end
    else
        QBCore.Functions.Notify('Burada balık tutamazsın! Sahile git.', 'error')
    end
end)


CreateThread(function()
    for _, blipData in pairs(Config.Blips) do
        local blip = AddBlipForCoord(blipData.coords)
        SetBlipSprite(blip, blipData.sprite)
        SetBlipColour(blip, blipData.color)
        SetBlipScale(blip, blipData.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipData.label)
        EndTextCommandSetBlipName(blip)
    end
end)