Config = {
  groups = {
    ["police"] = {
      shared_groups = {
        "ambulance"
      },
      entitiyModels = {
        ["police"] = {
          name = "[Bravo]",
          blip = {
            sprite = 56,
            scale = 0.7,
            color = 26,
          }
        },
        ["policeb"] = {
          name = "[Charlie]",
          blip = {
            sprite = 56,
            scale = 0.7,
            color = 26,
          }
        },
        ["player"] = {
          name = "[Player]",
          blip = {
            sprite = 1,
            scale = 1.0,
            color = 3,
          }
        }
      }
    },
    ["ambulance"] = {
      shared_groups = {

      },
      entitiyModels = {
        ["ambulance"] = {
          name = "[Ambulance]",
          blip = {
            sprite = 42,
            scale = 1.0,
            color = 1,
          }
        },
      }
    }
  }
}
