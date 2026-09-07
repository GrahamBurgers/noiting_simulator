SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[The snowy hills taper off here. At the end of the path, serene waters come into view, alongside a familiar cabin.]]}}, onlyif = not Data.firstentry_lakeside, data = "firstentry_lakeside"},
{id = "main", location = "lakeside", texts = {{text = [[You're at the Lakeside.`]], style = {"location"}},

{img = {path = "mods/noiting_simulator/files/gui/arrow_right.png"}}, {text = [[Market]], click = {{file = "locations/market.lua"}}, style = {"travel"}},
}},


}