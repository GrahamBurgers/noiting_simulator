SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[A ]]}, {text = [[pillow and blanket]], click = {{id = "pillow_gold", onlyif = Data.gold_under_pillow ~= true}, {id = "pillow"}}}, {text = [[ lie beside you. Someone must have placed these here to accommodate you.`]]},
{text = [[A ]], req = not Data.item_shroom}, {text = [[large blue mushroom]], last_req = true, click = {{id = "mush"}}}, {text = [[ dangles over you in a planter-pot, shading you from the sun.`]], last_req = true},

{img = {path = "mods/noiting_simulator/files/gui/arrow_out.png"}}, {text = [[Fly down`]], style = {"travel"}, click = {{file = "locations/plaza.lua"}}}

}},

{id = "mush", texts = {{text = [[Pluck! You take the mushroom from its pot, wielding it confidently over your shoulder... despite its odd smell.`]], giveitem = "shroom"},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {item_shroom = true}}}},

{id = "pillow_gold", texts = {{text = [[Your sleeping arrangement.`...What's this?]]}}},
{id = "pillow_gold", givegold = 25, texts = {{text = [[There are some gold pieces scattered beneath your pillow.`You took them. It's only fair.`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {gold_under_pillow = true}}}},

{id = "pillow", texts = {{text = [[Your sleeping arrangement.`Thankfully, your pillow is free from gold pieces and peas. For now.`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}},

}