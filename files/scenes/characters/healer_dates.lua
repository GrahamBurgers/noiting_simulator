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


{id = "arcade", data = "date_done_healer_arcade", texts = {{text = [[Ehehe... I come here whenever I have spare time.]]}}},

{id = "park", data = "date_done_healer_park", texts = {{text = [[PARK!!!]]}}},


}