SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", location = "forest", texts = {{text = [[You stand at the base of the Great Tree.`]], style = {"location"}},
{text = [[You crane your neck, but can't quite see the top from here.`]]},

{text = [[Back]], style = {"location"}, click = {{file = "locations/forest.lua"}}},

}},

}