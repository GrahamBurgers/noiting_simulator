SCENE = {

{id = "main", texts = {{text = [[You approach ]]}, {name = "healer"}, {text = [[.]]}}, sendto = {
	{id = "healer_first", onlyif = not Data.healer_first},
	{id = "healer_generic"}
}, sprites = {healer = {file = "healer.png", preset = "slide_in_from_left"}}},



{id = "healer_first", texts = {{character = "healer", text = [[O-oh...! H-hello there, um... Knower.]],
}}, data = "healer_first", sprites = {healer = {file = "healer.png"}}},

{id = "healer_first", texts = {{character = "healer", text = [[You were sleeping... up on the Altar, weren't you?`E-everyone's been, um... waiting for you to come down.]],
}}, sprites = {healer = {file = "healer.png"}}},

{id = "healer_first", texts = {{character = "healer", text = [[...O-oh! You... probably need something, right?`S-since you... approached me, and all...`]],
},
{text = [[Need a date`]], click = {{id = "first_date"}}},
{text = [[Need healing`]], click = {{id = "first_heals"}}},
{text = [[Just saying 'hi'`]], click = {{id = "first_dontneed"}}},
}, sprites = {healer = {file = "healer.png"}}},



{id = "first_date", texts = {{character = "healer", text = [[A-a date? For the... First Party, you mean?`T-that's, um... I-I didn't know you would be so forward, Knower...]],
}}, sprites = {healer = {file = "healer_flustered.png"}}},




{id = "main", bookmarkreturn = 1, sprites = {healer = {preset = "slide_left_and_die"}}},

}