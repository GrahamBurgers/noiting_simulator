SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}}, -- TIME CHECK!

{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[A pillow and blanket lie beside you. Someone must have placed these here to accommodate you.`]]},
{text = [[A ]], req = not Data.item_shroom}, {text = [[large blue mushroom]], last_req = true, click = {{id = "mush"}}}, {text = [[ dangles over you in a planter-pot, shading you from the sun.`]], last_req = true},
{text = [[Fly down`]], style = {"location"}, click = {{file = "locations/plaza.lua"}}}}},

{id = "mush", texts = {{text = [[Pluck! You take the mushroom from its pot, wielding it confidently over your shoulder... despite its odd smell.`]], giveitem = "shroom"},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {item_shroom = true}}}},


}