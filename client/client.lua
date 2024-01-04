local groupBlips = {}

RegisterNetEvent('visualz_blips:client:updateBlip')
AddEventHandler('visualz_blips:client:updateBlip', function(blipData)
  for networkId, data in pairs(blipData) do
    local blipExist = DoesBlipExist(groupBlips[networkId])

    if blipData[networkId] == false then
      if blipExist then
        RemoveBlip(groupBlips[networkId])
        groupBlips[networkId] = nil
        break
      end
    end

    if NetworkDoesNetworkIdExist(networkId) then
      local entity = NetworkGetEntityFromNetworkId(networkId)
      if DoesEntityExist(entity) then
        if GetBlipFromEntity(entity) == 0 then
          SetBlipAlpha(GetMainPlayerBlipId(), 255)
          RemoveBlip(groupBlips[networkId])
          groupBlips[networkId] = AddBlipForEntity(entity)
          SetBlipSettings(networkId, data)
        end
        SetBlipName(networkId, data)
      end
    else
      if not blipData[networkId] == false then
        if blipExist then
          SetBlipCoords(groupBlips[networkId], data.coords.x, data.coords.y, data.coords.z)
          SetBlipName(networkId, data)
        else
          groupBlips[networkId] = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
          SetBlipSettings(networkId, data)
        end
      end
    end
  end
end)

RegisterCommand('blip', function(source, args)
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  local netVeh = NetworkGetNetworkIdFromEntity(vehicle)
  TriggerServerEvent('visualz_blips:server:addEntityToGroup', args[1], "vehicle", netVeh)
end, false)

RegisterCommand('blipPlayer', function(source, args)
  local ped = PlayerPedId()
  local netPed = NetworkGetNetworkIdFromEntity(ped)
  TriggerServerEvent('visualz_blips:server:addEntityToGroup', args[1], "player", netPed)
end, false)

RegisterCommand('onDuty', function(source, args)
  TriggerServerEvent('visualz_blips:server:goOnDuty', args[1])
end, false)

RegisterCommand('offDuty', function(source, args)
  TriggerServerEvent('visualz_blips:server:goOffDuty', args[1])
end, false)

RegisterCommand("removeBlip", function(source, args)
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  local netVeh = NetworkGetNetworkIdFromEntity(vehicle)
  TriggerServerEvent('visualz_blips:server:removeEntityFromGroup', args[1], netVeh)
end, false)

function SetBlipSettings(networkId, data)
  SetBlipSprite(groupBlips[networkId], data.blip.sprite)
  SetBlipColour(groupBlips[networkId], data.blip.color)
  SetBlipScale(groupBlips[networkId], data.blip.scale)
  SetBlipCategory(groupBlips[networkId], 1)
end

function SetBlipName(networkId, data)
  AddTextEntry('blipName', data.name)
  BeginTextCommandSetBlipName('blipName')
  AddTextComponentSubstringPlayerName('me')
  EndTextCommandSetBlipName(groupBlips[networkId])
end

RegisterCommand("stress_test", function(source, args)
  for i = 0, 40 do
    ESX.Game.SpawnVehicle('police', vector3(-1452.6903 + (i * 3), -2398.4209 + (i * 5), 13.9452), 100.0,
      function(vehicle)
        local netVeh = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "vehicle",
          netVeh)
      end)
    Wait(100)
  end
end, false)
