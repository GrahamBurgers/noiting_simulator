SCENE = {

{id = "main", texts = {{text = [[You make your way through the brush, finding yourself in a clearing.`Someone must be dedicated to maintaining this place...]]}}, onlyif = not Data.firstentry_park, data = {{set = {firstentry_park = true}}}},
{id = "main", location = "park", texts = {{text = [[You're in the Park.`]], style = {"location"}},

{img = {path = "mods/noiting_simulator/files/gui/arrow_left.png"}}, {text = [[Plaza`]], click = {{file = "locations/plaza.lua"}}},
}}

}