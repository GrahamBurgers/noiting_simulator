SCENE = {
    {["track"] = 1, ["text"] = [[test test test]]},
    {["track"] = 1, ["behavior"] = "function", ["function"] = function() end},
    {["track"] = 1, ["text"] = [[this text is auto]], ["behavior"] = "auto"},
    {["track"] = 1, ["text"] = [[BOO]], ["style"] = {["red"] = true}},
    {["track"] = 1, ["text"] = [[this is a choice]], ["behavior"] = "choice",
        ["choices"] = {
            {["name"] = "right", ["location"] = "right", ["gototrack"] = 3},
            {["name"] = "left", ["location"] = "left", ["gototrack"] = 2},
            {["name"] = "top", ["location"] = "top", ["gototrack"] = 4},
            {["name"] = "bottom", ["location"] = "bottom", ["gototrack"] = 3},
            {["name"] = "center", ["location"] = "center", ["gototrack"] = 3},
            {["name"] = "top left", ["location"] = "topleft", ["gototrack"] = 4},
            {["name"] = "top right", ["location"] = "topright", ["gototrack"] = 4},
            {["name"] = "bottom right", ["location"] = "bottomright", ["gototrack"] = 4},
            {["name"] = "bottom left", ["location"] = "bottomleft", ["gototrack"] = 4},
        }},
}