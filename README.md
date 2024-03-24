
# Visualz Blips

Thanks for the purchase - remember this is a Developer resource.


Lets start with our server events.

To trigger onDuty use the following
```lua
  TriggerServerEvent('visualz_blips:server:goOnDuty', "police")
```

OffDuty:
```lua
  TriggerServerEvent('visualz_blips:server:goOffDuty', "police")
```

AddBlip for vehicle:
```lua
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  local netVeh = NetworkGetNetworkIdFromEntity(vehicle)
  TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "vehicle", netVeh)
```

AddBlip for player:
```lua
  local ped = PlayerPedId()
  local netPed = NetworkGetNetworkIdFromEntity(ped)
  TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "player", netPed)
```

RemoveBlip:
```lua
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  local netVeh = NetworkGetNetworkIdFromEntity(vehicle)
  TriggerServerEvent('visualz_blips:server:removeEntityFromGroup', "police", netVeh)
```