return {
    ["sprites"] = {
        {["image_file"] = "background.png", ["z_index"] = 1.0},
    },
    ["tiles"] = {
        {coords = "8,7", tile = "wall"},
        {coords = "9,8", sendto = {name = "plaza", x = 8, y = 3, freeze = 20}},
        {coords = "10,7", tile = "wall"},
        {coords = "8,8", tile = "wall"},
        {coords = "9,7", tile = "wall"},
        {coords = "10,8", tile = "wall"},
    }
}