SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[You make your way through the brush, finding yourself in a clearing.`Someone must be dedicated to maintaining this place...]]}}, onlyif = not Data.firstentry_park, data = {{set = {firstentry_park = true}}}},
{id = "main", location = "park", texts = {{text = [[You're in the Park.`]], style = {"location"}},

{name = "healer", req = GlobalsGetValue("L_HEALER") == "park", click = {{id = "healer"}}}, {text = [[ is watering the flowers.`]], last_req = true},

{img = {path = "mods/noiting_simulator/files/gui/arrow_left.png"}}, {text = [[Plaza]], click = {{file = "locations/plaza.lua"}}, style = {"travel"}}, {text = [[ | ]]},
{img = {path = "mods/noiting_simulator/files/gui/arrow_up.png"}}, {text = [[Library]], click = {{file = "locations/library.lua"}}, style = {"travel"}}, {text = [[ | ]]},
{img = {path = "mods/noiting_simulator/files/gui/arrow_down.png"}}, {text = [[Forest]], click = {{file = "locations/forest.lua"}}, style = {"travel"}}, {text = [[ | ]]},
{img = {path = "mods/noiting_simulator/files/gui/arrow_right.png"}}, {text = [[Theater`]], click = {{file = "locations/theater.lua"}}, style = {"travel"}},
}},

{id = "healer", bookmark = {{file = "healer_main.lua"}}},
{id = "healer", sendto = {{line = 1}}},

}