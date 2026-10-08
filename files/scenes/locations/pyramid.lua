SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[You're finding it difficult to see ahead of you, through the sandy air of the Desert...`Eventually, though... you reach the front of a large structure.]]}}, onlyif = not Data.firstentry_pyramid, data = "firstentry_pyramid"},
{id = "main", location = "pyramid", texts = {{text = [[You're outside the Pyramid.`]], style = {"location"}},

{text = [[Search]], click = {
	{id = "desert_wall_search"}
}, staminacost = 1, req = Data.searched_in_pyramid ~= true},
{text = [[Behind]], click = {
	{id = "desert_secret_secret5", onlyif = Data.secret_secret5 == true},
	{id = "desert_secret_secret4", onlyif = Data.secret_secret4 == true},
	{id = "desert_secret_secret3", onlyif = Data.secret_secret3 == true},
	{id = "desert_wall"}
}, req = Data.searched_in_pyramid == true},

{navigator = {
	left = {id = "theater"},
}}}},


{id = "desert_wall_search", texts = {{text =
	[[Following an intuition, you slink behind the Pyramid, looking for something interesting...`But...]],
}}, data = "searched_in_pyramid", sendto = {{id = "desert_wall"}}},

{id = "desert_wall", texts = {
	{text = [[Behind the Pyramid is nothing but a wall of hardened rock.`It seems to stretch in every direction for miles.`Seems that there's nothing else here]]},
	{text = [[.]], style = {"white"}, click = {{id = "desert_secret_secret"}}},
	{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},

{id = "desert_secret_secret", behavior = "instant", texts = {
	{text = [[Behind the Pyramid is nothing but a wall of hardened rock.`It seems to stretch in every direction for miles.`Seems that there's nothing else here.]]},
	{text = [[.]], style = {"white"}, click = {{id = "desert_secret_secret2"}}},
	{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},


{id = "desert_secret_secret2", behavior = "instant", texts = {
	{text = [[Behind the Pyramid is nothing but a wall of hardened rock.`It seems to stretch in every direction for miles.`Seems that there's nothing else here..]]},
	{text = [[.]], style = {"white"}, click = {{id = "desert_secret_secret3"}}},
	{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},


{id = "desert_secret_secret3", data = "secret_secret3", texts = {
	{req = Data.secret_secret3 == true, text = [[There's a keypad set into the wall here.]]},
	{req = Data.secret_secret3 ~= true, text = [[You idly run your hand along the endless wall of rock as you walk along its length...`...Until your hand catches, just barely, on a smooth indent in the wall.`Feels like a keypad.]]},
	{text = [[`todo remove keypad code]], click = {{id = "desert_secret_secret4"}}},
	{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},


{id = "desert_secret_secret4", data = "secret_secret4", texts = {
	{text = [[There's some manner of inscription here, unlike anything you've ever seen before...]]},
	{text = [[`Unlock]], typelesscost = 1, click = {{id = "desert_secret_secret5"}}},
	{text = [[`Back]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},

{id = "desert_secret_secret5", data = "secret_secret5", texts = {
	{req = Data.secret_secret5 == true, text = [[There's a narrow square passageway here.]]},
	{req = Data.secret_secret5 ~= true, text = [[You fiddle with the panel for a while, and eventually stumble your way into opening it.`It swings open, revealing a narrow square passageway leading deep into the rock...]]},
	{text = [[`Enter]], click = {{id = "desert_secret_secret6"}}},
	{text = [[`Back]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},

}