SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[Further down the snowy pathway, a tall steel building looms over you.`Through the heavy front door, the harsh colds of the Wasteland seem much further away.]]}}, onlyif = not Data.firstentry_apartments, data = {{set = {firstentry_apartments = true}}}},
{id = "main", location = "apartments", texts = {{text = [[You're in the Hiisi Apartments, 1F.`]], style = {"location"}},

{text = [[2F`]], click = {{id = "2F"}}, style = {"travel"}},
{text = [[Infirmary`]], click = {{id = "infirmary"}}, style = {"travel"}},

{img = {path = "mods/noiting_simulator/files/gui/arrow_down.png"}}, {text = [[Market]], click = {{file = "locations/market.lua"}}, style = {"travel"}},
}},

{id = "infirmary", texts = {
	{text = [[You're in the Hiisi Apartments, Infirmary.`]], style = {"location"}},
	{name = "healer", req = GlobalsGetValue("L_HEALER") == "medical", click = {{id = "healer"}}}, {text = [[ is working in the office.`]], last_req = true},
	{text = [[1F`]], click = {{line = 1, id = "main"}}, style = {"travel"}},
}},

{id = "2F", texts = {
	{text = [[You're in the Hiisi Apartments, 2F.`]], style = {"location"}},
	{text = [[3F`]], click = {{id = "3F"}}, style = {"travel"}},
	{text = [[1F`]], click = {{line = 1, id = "main"}}, style = {"travel"}},
}},

{id = "3F", texts = {
	{text = [[You're in the Hiisi Apartments, 3F.`]], style = {"location"}},
	{text = [[4F`]], click = {{id = "4F"}}, style = {"travel"}},
	{text = [[2F`]], click = {{line = 1, id = "2F"}}, style = {"travel"}},
}},

{id = "4F", texts = {
	{text = [[You're in the Hiisi Apartments, 4F.`]], style = {"location"}},
	{text = [[Penthouse`]], click = {{id = "penthouse"}}, style = {"travel"}},
	{text = [[3F`]], click = {{line = 1, id = "3F"}}, style = {"travel"}},
}},

{id = "healer", bookmark = {{file = "healer_main.lua"}}},
{id = "healer", sendto = {{line = 1, id = "infirmary"}}},



}