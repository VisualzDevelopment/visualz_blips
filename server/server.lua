local groups = Config.groups

CreateThread(function()
  for groupName, groupData in pairs(groups) do
    groups[groupName].entities = {}
    groups[groupName].members = {}

    for entityModel, entityModelData in pairs(groupData.entitiyModels) do
      groups[groupName][entityModelData.name] = {
        nextUnitNumber = 1,
        availableUnitNumbers = {}
      }
    end
  end
end)

CreateThread(function()
  while true do
    Wait(1500)
    -- Loop trough all groups
    for jobName, groupData in pairs(groups) do
      local blipData = {}

      -- Loop trough all entities in the group
      for networkId, entityData in pairs(groupData.entities) do
        local entityNetworkId = NetworkGetEntityFromNetworkId(networkId)

        -- Check if the entity exists
        if groupData.entities[networkId] ~= nil then
          if DoesEntityExist(entityNetworkId) then
            -- Check if the entity needs to be deleted and break the loop
            if groupData.entities[networkId].delete == true then
              table.insert(groupData[groupData.entities[networkId].vehicleName].availableUnitNumbers,
                groupData.entities[networkId].unitNumber)
              groupData.entities[networkId] = nil
              blipData[networkId] = false
              UpdateServerEvent(jobName, groupData)
              return
            end

            local coords = GetEntityCoords(entityNetworkId)

            blipData[networkId] = {
              name = entityData.name,
              coords = coords,
              blip = groupData.entitiyModels[entityData.entityModelName].blip,
              model = entityData.entityModelName,
              entityModelGroupName = entityData.entityModelGroupName,
            }
          else
            table.insert(groupData[groupData.entities[networkId].entityModelGroupName].availableUnitNumbers,
              groupData.entities[networkId].unitNumber)
            groupData.entities[networkId] = nil
            blipData[networkId] = false
            UpdateServerEvent(jobName, g)
          end
        end
      end

      -- Loop trough all members in the group and send them the blip data
      for source, member in pairs(groupData.members) do
        TriggerClientEvent('visualz_blips:client:updateBlip', source, blipData)
      end

      -- Loop trough all shared_groups in the group and send them the blip data
      for _, shared_group in pairs(groupData.shared_groups) do
        -- Loop trough all members in the shared_groups
        if groups[shared_group] then
          for source, member in pairs(groups[shared_group].members) do
            TriggerClientEvent('visualz_blips:client:updateBlip', source, blipData)
          end
        end
      end

      blipData = nil
    end
  end
end)

RegisterNetEvent('visualz_blips:server:addEntityToGroup')
AddEventHandler('visualz_blips:server:addEntityToGroup', function(groupName, type, networkId)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  -- Check if the player has the job
  if player.job.name == groupName then
    if type == "vehicle" then
      local entityHandle = GetEntityFromNetworkIdFunc(networkId)
      if entityHandle == nil then
        return
      end
      local tempEntityModel = GetEntityModel(entityHandle)

      -- Loop trough all vehicles in the group
      for entityModel, entityModelData in pairs(groups[groupName].entitiyModels) do
        -- Check if the entity already exists
        if groups[groupName].entities[networkId] ~= nil then
          if groups[groupName].entities[networkId].unitNumber ~= nil then
            break
          end
        end

        if GetHashKey(entityModel) == tempEntityModel then
          local unitNumbers = GetEntityModelNumber(groupName, entityModelData.name)

          -- Add the entityModel and player to the group
          groups[groupName].entities[networkId] = {
            name = entityModelData.name .. " - " .. unitNumbers.displayNumber,
            entityModelGroupName = entityModelData.name,
            entityModelName = entityModel,
            unitNumber = unitNumbers.unitNumber,
          }
          UpdateServerEvent(groupName, entityModelGroupName)
          break
        end
      end
    elseif type == "player" then
      local entityHandle = GetEntityFromNetworkIdFunc(networkId)
      if entityHandle == nil then
        return
      end

      -- Check if the entity already exists
      if groups[groupName].entities[networkId] ~= nil then
        if groups[groupName].entities[networkId].unitNumber ~= nil then
          return
        end
      end

      if GetEntityType(entityHandle) == 1 then
        local entityModelData = groups[groupName].entitiyModels["player"]
        local unitNumbers = GetEntityModelNumber(groupName, entityModelData.name)

        -- Add the entityModel and player to the group
        groups[groupName].entities[networkId] = {
          name = entityModelData.name .. " - " .. unitNumbers.displayNumber,
          entityModelGroupName = entityModelData.name,
          entityModelName = "player",
          unitNumber = unitNumbers.unitNumber,
        }
      end
    end
  end
end)

RegisterNetEvent('visualz_blips:server:removeEntityFromGroup')
AddEventHandler('visualz_blips:server:removeEntityFromGroup', function(groupName, networkId)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  -- Check if the player has the job
  if player.job.name == groupName then
    -- Remove the entity from the group
    groups[groupName].entities[networkId] = {
      delete = true
    }
  end
end)

RegisterNetEvent('visualz_blips:server:goOnDuty')
AddEventHandler('visualz_blips:server:goOnDuty', function(groupName)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  if player.job.name == groupName then
    groups[groupName].members[source] = {
      onDuty = true
    }
  end
end)

RegisterNetEvent('visualz_blips:server:goOffDuty')
AddEventHandler('visualz_blips:server:goOffDuty', function(groupName)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  if player.job.name == groupName then
    groups[groupName].members[source] = {
      onDuty = false
    }
  end
end)

function GetEntityFromNetworkIdFunc(networkId)
  local timeout = 2

  local entity = NetworkGetEntityFromNetworkId(networkId)
  repeat
    Wait(500)
    timeout = timeout - 1
    entity = NetworkGetEntityFromNetworkId(networkId)
    if timeout == 0 then
      return nil
    end
  until
    entity > 0
  return entity
end

function GetEntityModelNumber(groupName, vehicleName)
  local groupData = groups[groupName][vehicleName]
  local entityUnitNumber
  local displayNumber

  if #groupData.availableUnitNumbers > 0 then
    print(json.encode(groupData.availableUnitNumbers))
    table.sort(groupData.availableUnitNumbers)
    print(json.encode(groupData.availableUnitNumbers))
    entityUnitNumber = table.remove(groupData.availableUnitNumbers, 1)
  else
    entityUnitNumber = groupData.nextUnitNumber
    groupData.nextUnitNumber = groupData.nextUnitNumber + 1
  end

  if tonumber(entityUnitNumber) < 10 then
    displayNumber = 0 .. entityUnitNumber
  else
    displayNumber = entityUnitNumber
  end

  return {
    unitNumber = entityUnitNumber,
    displayNumber = displayNumber
  }
end
