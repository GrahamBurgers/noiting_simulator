SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[A ]]}, {text = [[pillow and blanket]], click = {
	{id = "pillow_pea", onlyif = Data.gold_under_pillow ~= true and Day == "Sunday"},
	{id = "pillow_gold", onlyif = Data.gold_under_pillow ~= true},
	{id = "pillow_pealess", onlyif = Day == "Sunday"},
	{id = "pillow"}}
}, {text = [[ lie beside you. Someone must have placed these here to accommodate you.`]]},
{text = [[A ]], req = not Data.item_shroom}, {text = [[large blue mushroom]], last_req = true, click = {{id = "mush"}}}, {text = [[ dangles over you in a planter-pot, shading you from the sun.`]], last_req = true},
{text = [[ yeees]], cutecost = 3, click = {{id = "mush"}}},

{img = {path = "mods/noiting_simulator/files/gui/arrow_out.png"}}, {text = [[Fly down`]], style = {"travel"}, click = {{file = "locations/plaza.lua"}}}

}},

{id = "mush", giveitem = "shroom", texts = {{text = [[Pluck! You take the mushroom from its pot, wielding it confidently over your shoulder... despite its odd smell.`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {item_shroom = true}}}},

{id = "pillow_gold", texts = {{text = [[Your sleeping arrangement.`...What's this?]]}}},
{id = "pillow_gold", givegold = 25, texts = {{text = [[There were 25 gold pieces scattered beneath your pillow!`You took them. It's only fair.`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {gold_under_pillow = true}}}},

{id = "pillow_pea", texts = {{text = [[Your sleeping arrangement.`...What the?!]]}}},
{id = "pillow_pea", giveitem = "pea", texts = {{text = [[There was a pea beneath your pillow!`The stories were true after all...`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {gold_under_pillow = true}}}},

{id = "pillow_pealess", texts = {{text = [[Your sleeping arrangement.`You give your pillow a brief look of betrayal.`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}},

{id = "pillow", texts = {{text = [[Your sleeping arrangement.`Thankfully, your pillow is free from both gold pieces and peas. For now.`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}},

}