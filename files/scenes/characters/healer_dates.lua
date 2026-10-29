SCENE = {

{id = "main", texts = {
	{req = (Data.healer_times_chosen_date or 0) == 0, character = "healer", text = [[E-eh...? You're... letting me choose?`Gosh, u-uh, um...`Alright!]]},
	{req = (Data.healer_times_chosen_date or 0) == 1, character = "healer", text = [[H-hm? Letting me choose again?`O-oh, well... If it's what you want, I suppose.]]},
	{req = (Data.healer_times_chosen_date or 0) == 2, character = "healer", text = [[...P-pfft! Hahah!`Knower... you're so silly sometimes...`I would've thought the person who saved our world...`Would be a bit more creative.~]]},
	{req = (Data.healer_times_chosen_date or 0) >= 3, character = "healer", text = [[Hmph. Okay, okay, gosh, stop staring...`(Can you do anything without me? Ehehe...)]]},
}, data = {{set = {healer_times_chosen_date = (Data.healer_times_chosen_date or 0) + 1}}}},

{id = "main", texts = {
	{name = "healer"}, {text = [[ takes your arm...]]},
}, sendto = {
	{id = "arcade", onlyif = Data.date_done_healer_arcade ~= true},
	{id = "library", onlyif = Data.date_done_healer_library ~= true},
	{id = "theater", onlyif = Data.date_done_healer_theater ~= true},
	{id = "park", onlyif = Data.date_done_healer_park ~= true},
	{id = "lakeside", onlyif = Data.date_done_healer_lakeside ~= true},
	{id = "forest", onlyif = Data.date_done_healer_forest ~= true},
	{id = "done_every_date"},
}},



{id = "done_every_date", texts = {
	{character = "healer", text = [[H-hey, um... Wait a minute.`G-gimme that map of yours for a sec.]]},
}, sprites = {healer = {file = "healer.png"}}},
{id = "done_every_date", texts = {
	{character = "healer", text = [[E-ehehe... Hey, um, Knower...`It looks like we've, um... been everywhere.`...At least, everywhere I wanted to show you.]]},
}, sprites = {healer = {file = "healer_timid.png"}}},
{id = "done_every_date", texts = {
	{character = "healer", text = [[W-why don't we just, um... wait until Sunday night, okay?`We can spend time together then...!]]},
}, sprites = {healer = {file = "healer_loving.png"}}},
{id = "done_every_date", texts = {
	{name = "healer"}, {text = [[ rushes forward and tackles you into a hug for a moment...`Then releases you and jogs off before you can say anything else.]]},
}, sprites = {healer = {file = "healer.png"}}},
{id = "done_every_date", bookmarkreturn = 2, sprites = {healer = {preset = "slide_left_and_die"}}},




{id = "arcade", location = "arcade", data = "date_done_healer_arcade", texts = {
	{text = [[The Arcade isn't very populated when you arrive.`None of the other customers seem to pay you two much mind...]]},
}},

{id = "arcade", texts = {
	{character = "healer", text = [[Ehehe... I love visiting this place when I have time.`I don't even know who runs the place...`But it's, like... ALWAYS open.]]},
}, sprites = {healer = {file = "healer_excited.png"}}},

{id = "arcade", texts = {
	{name = "assassin"},
	{character = "healer", text = [[ comes here every now and then, too.`Doesn't talk much. Totally wipes me at the versus games.`A-also, um... never seems to have quarters.]]},
}, sprites = {healer = {file = "healer.png"}}},

{id = "arcade", texts = {
	{character = "healer", text = [[S-speaking of... u-um, do you...?`]]},
	{text = [[I got quarters]], click = {{id = "arcade_quarters"}}, goldcost = 30},
	{text = [[`Don't got quarters`]], click = {{id = "arcade_noquarters"}}},
}, sprites = {healer = {file = "healer_tired.png"}}},


{id = "arcade_quarters", texts = {
	{text = [[You reach out to take ]]}, {name = "healer"}, {text = [['s hand, dumping a small pile of gold coins into it.`]]..
	P("healer", {she = "She lets", he = "He lets", they = "They let", it = "It lets"}) .. [[ out a subtle sigh of relief.]]}
}, sprites = {healer = {file = "healer_tired.png"}}},

{id = "arcade_quarters", texts = {
	{character = "healer", text = [[I-I, um... appreciate that.`I promise... I'll win us some tickets, okay?]]}
}, data = "paid_for_healer_arcade", sprites = {healer = {file = "healer_loving.png"}}, sendto = {{id = "arcade2"}}},


{id = "arcade_noquarters", texts = {
	{name = "healer"}, {text = [[ sighs and reaches out, punching you gently on the shoulder.]]}
}, sprites = {healer = {file = "healer_tired.png"}}},

{id = "arcade_noquarters", texts = {
	{character = "healer", text = [[G-gosh... I-I guess you DID save the world and all...`B-but... if I'm paying...`You better seriously win us some tickets!]]}
}, sprites = {healer = {file = "healer.png"}}, sendto = {{id = "arcade2"}}},


{id = "arcade2", texts = {
	{character = "healer", text = [[...S-so, um... What are we playing first?`Thirty gold is enough to play... three games.`]]},
	{text = [[Co-op game`]], click = {{id = "arcade_coop"}}},
	{text = [[Versus game`]], click = {{id = "arcade_versus"}}},
}, sprites = {healer = {file = "healer_timid.png"}}},


{id = "arcade_versus", texts = {
	{character = "healer", text = [[G-gosh, alright...`I-I, um, totally suck at this one.]]}
}, sprites = {healer = {file = "healer_tired.png"}}},

{id = "arcade_versus", texts = {
	{character = "healer", text = [[U-usually, um... the person who wins takes all the tickets.`But, we're, um... together.`So I don't think it matters, right?`]]},
	{text = [[I'm gonna win`]], click = {{id = "arcade_gonnawin"}}},
	{text = [[That makes no sense]], click = {{id = "arcade_nosense"}}},
}, sprites = {healer = {file = "healer_timid.png"}}},


{id = "arcade_nosense", texts = {
	{character = "healer", text = [[W-what?! I-it's an honor-system thing!`That's what ]]}, {name = "assassin"}, {character = "healer", text = [[ said!`'Winner takes all'!]]}
}, sprites = {healer = {file = "healer_surprised.png"}}},

{id = "arcade_nosense", texts = {
	{character = "healer", text = [[...A-ah, gosh...`Don't stare, Knower, I get it...`L-let's just... play.]]}
}, sprites = {healer = {file = "healer_tired.png"}}, sendto = {{id = "arcade_versus_go"}}},


{id = "arcade_gonnawin", texts = {
	{character = "healer", text = [[O-oh! I suppose we'll see about that...!]] .. (Data.paid_for_healer_arcade and "" or [[`Maybe, since I'm paying...`I'll just hoard the tickets either way! Ehehe...]])}
}, sprites = {healer = {file = "healer_surprised.png"}}, sendto = {{id = "arcade_versus_go"}}},


{id = "arcade_versus_go", texts = {
	{character = "healer", text = [[...It's best out of three.]]}
}, sprites = {healer = {file = "healer_surprised.png"}}},



{id = "park", location = "park", data = "date_done_healer_park", texts = {{text = [[PARK!!!]]}}},


}