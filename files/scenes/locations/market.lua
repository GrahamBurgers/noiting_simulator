SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[You make your way onto a path that takes you deeper into the Snowy Wasteland.`The architecture here is distinctly that of the Hiisi.]]}}, onlyif = not Data.firstentry_market, data = "firstentry_market"},
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
},
sprites = {
	swampling = {preset = "slide_left_and_die"},
	friend = {preset = "slide_left_and_die"},
	friendbooth = {preset = "slide_left_and_die"},
	coward = {preset = "slide_left_and_die"},
}

},



{id = "friendlybooth", texts = {{text = [[You approach the greenish booth.`]]}, {name = "friend"}, {text = [[ stands idly behind the counter, while the little ones chase each other around the tree.]]}

}, sprites = {
	friend = {file = "friend.png", preset = "slide_in_from_left"},
	friendbooth = {file = "friend_booth.png", preset = "slide_in_from_left", z = 1},
}}, sendto = {{id = "friendlybooth2"}},



{id = "friendlybooth2", texts = {{name = "friend"}, {text =
	[[ stares blankly towards your general direction.`]],
},
{text = [[Tree`]], click = {{id = "friend_tree"}}},
{text = [[Offer]], goldcost = 20, click = {{id = "friend_gold"}}},
{text = [[`Offer]], staminacost = 2, click = {{id = "friend_stamina"}}},
{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},



{id = "friend_gold", texts = {{text = [[You reach out to cautiously place a few gold pieces atop the counter.`...`]]}, {name = "friend"}, {text = [[ doesn't seem to react.]]}},
data = {{set = {friend_offering_count = (Data.friend_offering_count or 0) + 1}}}, sendto = {{id = "friendlybooth2", line = 1}}},



{id = "friend_stamina", texts = {{text = [[You demonstrate a few jumping jacks and stretches in front of the booth.`...`]]}, {name = "friend"}, {text = [[ doesn't seem to react.]]}},
data = {{set = {friend_offering_count = (Data.friend_offering_count or 0) + 1}}}, sendto = {{id = "friendlybooth2", line = 1}}},



{id = "friend_tree", texts = {
	{text = [[Countless green gourds grow from the branches of this odd tree. They look refreshing.`Each ]]},
	{name = "horror"}, {text = [[ bounces and yips as they run laps around the tree.`]]},
	{text = [[Pick a gourd`]], click = {
		{id = "pick_gourd_fail", onlyif = (Data.friend_offering_count or 0) == 0},
		{id = "pick_gourd_succeed"},
	}},
	{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "friendlybooth2"}}},
}},


{id = "pick_gourd_fail", texts = {
	{text = [[You approach the tree, and strain yourself as you reach up towards the fruits...]]},
}},
{id = "pick_gourd_fail", texts = {
	{text = [[CRAK!]], size = 2}, {text = "` `", forcetickrate = -120}, {text = [[A green blur strongly impacts your arm from behind, forcing it back down.]]},
}},
{id = "pick_gourd_fail", texts = {
	{text = [[You turn around to confront ]]}, {name = "friend"},
	{text = [[...`But it doesn't seem like ]] .. P("friend", {they = "they've", she = "she's'", he = "he's", it = "it's"}) .. [[ moved an inch.`]] ..
	(Data.arm_hurty and "...And now your arm is beginning to hurt.`You take a step back." or "...`You take a step back.")},
}, data = "arm_hurty", sendto = {{id = "friend_tree", line = 1}}},


{id = "pick_gourd_succeed", texts = {
	{text = [[You approach the tree, and strain yourself as you reach up towards the fruits...]]},
}, data = {{set = {friend_offering_count = (Data.friend_offering_count or 0) - 1}}}},

{id = "pick_gourd_succeed", texts = {
	{text = [[Success! With a gentle tug, the gourd comes loose. It fits into your palm quite snugly.`...What sort of fruit is this, anyway?]]},
}, giveitem = "gourd", sendto = {{id = "friend_tree", line = 1}}},



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
}}, sendto = {{id = "mysticlist"}}},

{id = "swampling_booth_old", texts = {{character = "swampling", text =
	[[Knower. It brings feelings to see you once more.]],
}}, sendto = {{id = "mysticlist"}}},

{id = "mysticlist", texts = {{character = "swampling", text =
	[[Think carefully. State your wish.`]],
},
{text = [[Incantations`]], style = {"mystic"}, click = {{id = "incantations"}}},
{text = [[Knowledge`]], style = {"mystic"}, click = {{id = "advice"}}},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},





{id = "djbooth", texts = {{text =
	[[You approach the groovy booth.]]
}}, sendto = {
	{id = "djbooth_new", onlyif = not Data.djbooth},
	{id = "djbooth_old"}
}, sprites = {swampling = {file = "djbooth.png", preset = "slide_in_from_left"}}},



{id = "djbooth_new", texts = {{character = "coward", text =
	[[Knower! Yo-yo-YO!`Long time no see!]],
}}, data = "djbooth", sprites = {coward = {file = "djbooth.png"}}},

{id = "djbooth_new", texts = {{character = "coward", text =
	[[Glad to have a visit from our guest star before the big party on Sunday...`You'll be there, right? Better be!`I NEVER let my parties go unattended.]],
}}, sprites = {coward = {file = "djbooth.png"}}},

{id = "djbooth_new", texts = {{character = "coward", text =
	[[Feel free to stick around while I work.`I'll just be doin' my thing.`And cheering you on while you do yours.]],
}}, sprites = {coward = {file = "djbooth.png"}}, sendto = {{id = "djbooth_go"}}},



{id = "djbooth_old", texts = {{character = "coward", text =
	[[Knower! That's who I'm hyped for!]],
}}, sendto = {{id = "djbooth_go"}}},



{id = "djbooth_go", texts = {{text =
	[[Still starin' over at me... Got a song request or what?`]],
},
{text = [[Date me`]], click = {{id = "dj_date_me"}}},
{text = [[Play HEAL-4-U`]], click = {{id = "song_healer"}}},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},



{id = "dj_date_me", onlyif = Data.djbooth_date_me == true, texts = {{character = "coward", text =
	[[...Eh? Should I turn DOWN the music, or turn UP my voice?`That's a NO, K-NO-wer!`At least, as long as my heart still pounds to the beat.]],
}}, sendto = {{id = "djbooth_go", line = 1}}},




{id = "dj_date_me", texts = {{character = "coward", text =
	[[Hah! You serious, Knower?`No way! My heart's FULL already!`Full of a lifetime's worth of MUSIC!]],
}}},

{id = "dj_date_me", texts = {{character = "coward", text =
	[[My one true love! That's waves and tones, comin' from this booth right here!`But, if the spark ever fades, I'll be sure to call you up!`Hah!]],
}}, data = "djbooth_date_me", sendto = {{id = "djbooth_go", line = 1}}},





{id = "incantations", texts = {{character = "swampling", text =
	[[Powerful effects. Some permanent. Not to be misused.`]],
},
{text = [[`Incantation of tenacity]], style = {"mystic"}, click = {{id = "incantations"}}, goldcost = 20}, -- max mana + temp stamina
{text = [[`Incantation of vitality]], style = {"mystic"}, click = {{id = "incantations"}}, goldcost = 35}, -- max health + max stamina
{text = [[`Incantation of tempus]], style = {"mystic"}, click = {{id = "incantations"}}, goldcost = 200}, -- back a day
{text = [[`Back]], style = {"location"}, click = {{line = 1, id = "mysticlist"}}},
}},




}