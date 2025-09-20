-- If no next_animation then it is assumed to loop
PORTRAITS = {
    ["hamis_idle"] = {
        priority = 1,
        frames = {
            {file = "hamis/hamis1.png", duration = 8},
            {file = "hamis/hamis2.png", duration = 8},
            {file = "hamis/hamis3.png", duration = 8},
            {file = "hamis/hamis2.png", duration = 8},
        },
    },
    ["hamis_happy"] = {
        override_self = false,
        priority = 2,
        frames = {
            {file = "hamis/hamishappy1.png", duration = 8},
            {file = "hamis/hamishappy2.png", duration = 8},
        },
        next_animation = "hamis_idle"
    },
}