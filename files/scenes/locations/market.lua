SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[You make your way onto a path that takes you deeper into the Snowy Wasteland.`The architecture here is distinctly Hiisi.]]}}, onlyif = not Data.firstentry_market, data = "firstentry_market"},
{id = "main", location = "market", texts = {{text = [[You're in the Market.`]], style = {"location"}},
{text = [[Along the pathway, various booths are set up to sell goods and services.`]]},

{text = [[Friendly booth`]], click = {{id = "friendlybooth"}}},
{text = [[Mystic booth`]], click = {{id = "mysticbooth"}}},
{text = [[DJ booth`]], click = {{id = "djbooth"}}},

{navigator = {
	left = {id = "lakeside"},
	up = {id = "apartments"},
	down = {id = "arcade"},
	right = {id = "plaza"},
}}
}, sprites = {swampling = {preset = "slide_left_and_die"}}},

{id = "mysticbooth", texts = {{text =
	[[You approach the strangely-decorated booth.]]
}}, sendto = {
	{id = "swampling_booth_new", onlyif = not Data.swampling_booth},
	{id = "swampling_booth_old"}
}, sprites = {swampling = {file = "swampling_booth.png", preset = "slide_in_from_left"}}},

{id = "swampling_booth_new", texts = {{character = "swampling", text =
	[[...Aah. Knower.]],
}}, data = "swampling_booth", sprites = {swampling = {file = "swampling_booth.png"}}},

{id = "swampling_booth_new", texts = {{character = "swampling", text =
	[[You do not know my services yet.`...You will.]],
}}, sendto = {{id = "mysticbooth"}}},

{id = "swampling_booth_old", texts = {{character = "swampling", text =
	[[Knower. It brings feelings to see you once more.]],
}}, sendto = {{id = "mysticlist"}}},

{id = "mysticlist", texts = {{character = "swampling", text =
	[[You remain silent. State your wish.`]],
},
{text = [[Incantations`]], style = {"mystic"}, click = {{id = "incantations"}}},
{text = [[Knowledge`]], style = {"mystic"}, click = {{id = "advice"}}},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},

{id = "incantations", texts = {{character = "swampling", text =
	[[Powerful effects. Some permanent. Not to be misused.`]],
},
{text = [[`Incantation of tenacity]], style = {"mystic"}, click = {{id = "incantations"}}, goldcost = 20}, -- max mana + temp stamina
{text = [[`Incantation of vitality]], style = {"mystic"}, click = {{id = "incantations"}}, goldcost = 35}, -- max health + max stamina
{text = [[`Incantation of tempus]], style = {"mystic"}, click = {{id = "incantations"}}, goldcost = 200}, -- back a day
{text = [[`Back]], style = {"location"}, click = {{line = 1, id = "mysticlist"}}},
}},


}