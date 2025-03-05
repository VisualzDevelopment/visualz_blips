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

RegisterNetEvent("visualz_blips:client:resetBlips")
AddEventHandler("visualz_blips:client:resetBlips", function()
  for networkId, blip in pairs(groupBlips) do
    RemoveBlip(blip)
    groupBlips[networkId] = nil
  end
end)

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
