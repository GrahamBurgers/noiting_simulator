SCENE = {
{id = "main", texts = {{text = [[You carefully levitate down from atop the peak of the Mountain, settling onto ground level.]]}}, onlyif = not Data.firstentry_plaza, data = {{set = {firstentry_plaza = true}}}},
{id = "main", location = "plaza", texts = {{text = [[You're in the plaza.`]], style = {"location"}},
{name = "miner", req = Time == "Morning" and Day == "Monday", click = {{id = "miner"}}}, {text = [[ stands at the entrance to the Mines, enthusiastically waving you over.`]], last_req = true},
{img = {path = "mods/noiting_simulator/files/gui/arrow_left.png"}}, {text = [[Market`]], click = {{file = "locations/market.lua"}}},
{img = {path = "mods/noiting_simulator/files/gui/arrow_right.png"}}, {text = [[Park`]], click = {{file = "locations/park.lua"}}},
{img = {path = "mods/noiting_simulator/files/gui/arrow_down.png"}}, {text = [[Graveyard]], click = {{file = "locations/graveyard.lua"}}, itemcost = "skullkey"},
{text = [[`Fly up]], style = {"location"}, click = {{file = "locations/mountain_altar.lua"}}}
}},


{id = "miner", texts = {{text = [[You approach ]]}, {name = "miner"}, {text = [[.]]}}, sendto = {{id = "miner_first", onlyif = not Data.miner_first}, {id = "miner_normal"}}},

{id = "miner_first", texts = {{character = "miner", text = [[Oi! Well, if that ain't a sight for sore eyes...`Knower to Be! How ya been?]],
	sprites = {miner = {file = "miner.png", x = 0.5, y = 0.5, tags = "character"}},
}}, data = {{set = {miner_first = true}}}},
{id = "miner_first", texts = {{character = "miner", text = [[Well... I guess they're just callin' you the Knower now, eh?`Everyone's been gossipin', wonderin' where you were at...`And comin' up with new nicknames for you, hah!]]}}},
{id = "miner_first", texts = {{character = "miner", text = [[...Ah, um, right. Somethin' I was s'posed to give ya.]]}}},
{id = "miner_first", texts = {{name = "kolmi"}, {character = "miner", text = [['s little ones have been handing these out.`Ended up givin' yours to me for safekeepin'.`Here.]]}}},
-- key item goes here
{id = "miner_first", texts = {{character = "miner", text = [[Somethin' called the First Party.`Big, celebration-type event...`Everyone's been buzzin' about it.]], giveitem = "letter"}}},
{id = "miner_first", texts = {{character = "miner", text = [[Askin' people on dates, clearin' their schedules...`Sheesh. Not my type-a thing.]]}}},
{id = "miner_first", texts = {{character = "miner", text = [[Everyone who's anyone has got an invite, though.`Dunno why they even bothered makin' one for you.`No one'd dare deny YOU at the door. Hah!]]}}},
{id = "miner_first", texts = {{character = "miner", text = [[So? You a fan of parties?`Must've been a bit dull, napping alone up there for so long...`Whatcha thinkin' about, Knower? Brain buzzin' already?]]}}},
{id = "miner_first", texts = {{character = "miner", text = [[Got an idea about who you might wanna take to the Party?`]]},
{text = [[Someone cute and sweet`]], style = {"cute"}, click = {{id = "cute"}}},
{text = [[Someone charming and suave`]], style = {"charming"}, click = {{id = "charming"}}},
{text = [[Someone clever and talented`]], style = {"clever"}, click = {{id = "clever"}}},
{text = [[Someone comedic and witty`]], style = {"comedic"}, click = {{id = "comedic"}}},
{text = [[Someone else`]], style = {"location"}, click = {{id = "else"}}},
{text = [[Don't know]], style = {"typeless"}, click = {{id = "other"}}},
}},

{id = "cute", texts = {{character = "miner", text = [[Hrm. Someone cute, eh...?`Sounds like ]]}, {name = "healer"}, {character = "miner", text = [[ to me.`Ain't nothing more endearing than someone with a heart that big.]]}}},
{id = "cute", texts = {{character = "miner", text = [[Problem is, ]]}, {name = "toimari"},
{character = "miner", text = [[ has been workin' ]] .. P("healer", {she = "her", he = "him", they = "them", it = "it"}) .. [[ to the bone lately.`Heaps of paperwork stackin' to the ceiling...`Yeesh.]]}
}, sendto = {{id = "after"}}},

{id = "charming", texts = {{character = "miner", text =
	[[Thinkin' about someone charming... Hrm.`That'd be ]]}, {name = "stendari"}, {character = "miner", text = [[, no question 'bout it.]]}
}},
{id = "charming", texts = {{character = "miner", text =
	P("stendari", {she = "She usually hangs ", he = "He usually hangs ", they = "They usually hang ", it = "It usually hangs "}) .. [[out 'round the Lake Island.`That's west of here.`...Wonder how a fire elemental makes it 'cross all that water.]]}
}, sendto = {{id = "after"}}},

{id = "clever", texts = {{character = "miner", text =
	[[Lookin' for someone with brains? Don't think I'm the right person to ask...`I ain't the sharpest tool in the box. But... ]]}, {name = "assassin"},
	{character = "miner", text = [[ just well might be.`And, if I go missin' tomorrow for calling ]] .. P("assassin", {she = "'er", he = "'im", they = "'em", it = "it"}) .. [[ a tool... well, you'll know who took me! Hah!]]}
}},
{id = "clever", texts = {{character = "miner", text =
	[[Only kiddin'. Mostly.`Still... I'd be careful goin' into alleyways. 'Specially at night.`You don't wanna end up on the wrong side of that blade.]]}
}, sendto = {{id = "after"}}},

{id = "comedic", texts = {{character = "miner", text =
	[[Someone to make ya chuckle, eh? Makes me think of... ]]}, {name = "shapechanger"},
	{character = "miner", text = [[. And that big toothy grin.`Spendin' enough time in that wizard graveyard has turned ]] ..
	P("shapechanger", {she = "her", he = "him", they = "them", it = "it"}) .. [[ into some sort of master mimic.]]}
}},
{id = "comedic", texts = {{character = "miner", text =
	[[Yup. Apparently ]] .. P("shapechanger", {she = "she only transforms herself", he = "he only transforms himself", they = "they only transform themself", it = "it only transforms itself"}) ..
	[[ nowadays.`I was surprised too! But I've heard that it makes for a damn good show.]]}
}, sendto = {{id = "after"}}},

{id = "else", texts = {{character = "miner", text =
	[[Someone else? Well, I'm no mind-reader, Knower...`You want me to guess what you're thinkin'? Fine.]]}
}},

{id = "after", texts = {{character = "miner", text =
	[[Anyway. What in the heck was I just talkin' about?]]}
}},
{id = "after", texts = {{character = "miner", text = [[...Ah, right. Party's on ]]}, {style = {"emphasis1"}, text = [[Sunday]]},
	{character = "miner", text = [[.`Prob'ly shouldn't spend that whole time talkin' to me, eh?]]}
}, sendto = {{id = "miner_normal"}}, feed = {icon = "mods/noiting_simulator/files/gui/battle_star.png", color = {185, 109, 40},
	lines = {"Look for the STAR icon to enter an ENCOUNTER with someone.", "Succeed to take them on a DATE.", "Your objective: Go on three DATES with any one character!", "Get it done before the party on Sunday!"}
}},

{id = "miner_normal", texts = {{character = "miner", text = [[Was there somethin' else you needed?`]]},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},
}},

}