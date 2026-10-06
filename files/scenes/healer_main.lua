SCENE = {

{id = "main", texts = {{text = [[You approach ]]}, {name = "healer"}, {text = [[.]]}}, sendto = {
	{id = "healer_first", onlyif = not Data.healer_first},
	{id = "healer_generic"}
}, sprites = {healer = {file = "healer.png", preset = "slide_in_from_left"}}},


{id = "healer_first", texts = {{character = "healer", text = [[O-oh...! H-hello there... Knower.]],
}}, data = "healer_first", sprites = {healer = {file = "healer.png"}}},

{id = "healer_first", texts = {{character = "healer", text = [[You were sleeping... up on the Altar, weren't you?`E-everyone's been waiting for you to come down.]],
}}, sprites = {healer = {file = "healer_timid.png"}}},

{id = "healer_first", texts = {{character = "healer", text = [[You were up there for a long time.`Was it, um... a good nap, then?`]]},
	{text = [[Yup`]], click = {{id = "yup"}}},
	{text = [[Nope`]], click = {{id = "nope"}}},
	{text = [[Where am I?]], click = {{id = "where_am_i"}}},
}, sprites = {healer = {file = "healer.png"}}},



{id = "yup", texts = {{character = "healer", text = [[H-heheh, that sounds about right.`Long naps are the best...`B-but I don't usually have the time for them.]],
}}, sprites = {healer = {file = "healer.png"}}, sendto = {{id = "busy"}}},



{id = "nope", texts = {{character = "healer", text = [[R-really? That's a shame...`Long naps are the best...`B-but I don't usually have the time for them.]],
}}, sprites = {healer = {file = "healer_tired.png"}}, sendto = {{id = "busy"}}},



{id = "busy", texts = {{character = "healer", text = [[Us Hiisi have all been working hard lately.`Moving up to the surface has been tough.`A few people have had... rocks dropped on them...]],
}}, sprites = {healer = {file = "healer_tired.png"}}, sendto = {{id = "where_am_i2"}}},



{id = "where_am_i", texts = {{character = "healer", text = [[O-oh! I guess it makes sense that you're... a little confused...]],
}}, sprites = {healer = {file = "healer_tired.png"}}},

{id = "where_am_i", texts = {{name = "miner"}, {character = "healer", text =
[[ told us that 'every square foot of the Hiisi Base consitutes an OSHA violation'.`Whatever that means!`]] .. P("miner", {she = "She seems", he = "He seems", they = "They seem", it = "It seems"}) .. [[ a lot more... responsible, nowadays.]],
}}, sprites = {healer = {file = "healer.png"}}, sendto = {{id = "where_am_i2"}}},

{id = "where_am_i", texts = {{character = "healer", text = [[So... we've all been moving up to the surface.`It's been a slow process...`And dangerous! A few people have had... rocks dropped on them...]],
}}, sprites = {healer = {file = "healer.png"}}},



{id = "where_am_i2", texts = {
	{character = "healer", text = [[But I've been... taking care of everyone. As usual.`As well as doing ]]},
	{name = "toimari"},
	{character = "healer", text = [['s paperwork...`And... t-taking care of the garden when I have the time.]]}
}, sprites = {healer = {file = "healer.png"}}},

{id = "where_am_i2", texts = {
	{character = "healer", text = [[O-oh, gosh...! I've been talking about myself for way too long...`Y-you're, um... a good listener.`]]},
	{name = "sniper"},
	{character = "healer", text = [[ would have... probably interrupted me by now to talk about guns...]]},
}, sprites = {healer = {file = "healer_tired.png"}}},

{id = "where_am_i2", texts = {
	{character = "healer", text = [[I-I should be, um...`Heading to work soon.`...Boss'll yell at me over radio if I'm late...]], req = Location ~= "apartments" and GetCharacterSchedule("healer", nil, 1) == "medical"},
	{character = "healer", text = [[I-I should, um... Get back to work soon.`...Boss'll yell at me over radio if I'm slacking off...]], req = Location == "apartments"},
	{character = "healer", text = [[I-I was... um, probably going to do... something...]], req = not ((Location == "apartments") or (GetCharacterSchedule("healer", nil, 1) == "medical"))},
}, sprites = {healer = {file = "healer_tired.png"}}, sendto = {{id = "hangout_base"}}},



{id = "hangout_base", texts = {
	{character = "healer", text = [[U-unless, um...`Did you need something from me?`]]},
	{text = [[Flowers`]], click = {{id = "flowers"}}},
	{text = [[Spend time together`]], click = {{id = "spendtime"}}},
	{text = [[Nope`]], click = {{id = "goodbye"}}},
}, sprites = {healer = {file = "healer.png"}}},



{id = "healer_generic", texts = {
	{character = "healer", text = [[Knower! There you are... again.`Did you need something...?`]]},
	{text = [[Flowers`]], click = {{id = "flowers"}}},
	{text = [[Spend time together`]], click = {{id = "spendtime"}}},
	{text = [[Nope`]], click = {{id = "goodbye"}}},
}, sprites = {healer = {file = "healer.png"}}},



{id = "spendtime", texts = {
	{character = "healer", text = [[R-really...? With me? I-I mean...`I'm really not sure if, um... I have the time to...`]]},
	{text = [[Convince`]], startbattle = "healer"},
	{text = [[Nevermind`]], click = {{id = "goodbye"}}},
}, sprites = {healer = {file = "healer_timid.png"}}},



{id = "goodbye", texts = {
	{character = "healer", text = [[A-ah...! Goodbye for now, Knower!`I-it was... nice to see you!]]},
}, sprites = {healer = {file = "healer.png"}}},

{id = "goodbye", bookmarkreturn = 1, sprites = {healer = {preset = "slide_left_and_die"}}},


{id = "battle_win", texts = {
	{character = "healer", text = [[!!!]]},
}, sprites = {healer = {file = "healer.png"}}},



{id = "battle_lose", texts = {
	{character = "healer", text = [[???]]},
}, sprites = {healer = {file = "healer.png"}}},



}