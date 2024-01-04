Config = {
  groups = {
    ["police"] = { -- Job name
      onDutySystem = true,
      shared_groups = {
        "ambulance"
      },
      categories = {
        ["Almen"] = { -- Category name
          ["police"] = { -- Køretøjet
            name = "[Bravo]", -- 
            blip = {
              sprite = 56,
              scale = 0.7,
              color = 26,
              showDistance = true,
            }
          },
          ["player"] = { -- Spilleren
            name = "[Charlie]",
            blip = {
              sprite = 1,
              scale = 1.0,
              color = 3,
              showDistance = true,
            }
          }
        }
      }
    },
    ["ambulance"] = {
      onDutySystem = true, -- If true, players will only be able to see blips if they are on duty
      shared_groups = {

      },
      entitiyModels = {
        ["jet"] = {
          name = "[Viktor]",
          blip = {
            sprite = 42,
            scale = 1.0,
            color = 1,
            showDistance = true,
          }
        },
      }
    }
  }
}
