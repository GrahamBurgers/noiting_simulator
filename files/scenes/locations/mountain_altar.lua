SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1}}},

{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[A pillow and blanket lie beside you. Someone must have placed these here to accommodate you.`]]},
{text = [[A ]], req = not Data.item_shroom}, {text = [[large blue mushroom]], last_req = true, click = {{id = "mush"}}}, {text = [[ dangles over you in a planter-pot, shading you from the sun.`]], last_req = true},
{text = [[Fly down`]], style = {"location"}, click = {{id = "plaza"}}}}},

{id = "mush", texts = {{text = [[Pluck! You take the mushroom from its pot, wielding it confidently over your shoulder... despite its odd smell.`]], giveitem = "shroom"},
{text = [[Back`]], style = {"location"}, click = {{line = 1, id = "main"}}}}, data = {{set = {item_shroom = true}}}},

{id = "plaza", texts = {{text = [[You carefully levitate down from atop the peak of the Mountain, settling onto ground level.]]}}, onlyif = not Data.plaza_firstentry, data = {{set = {plaza_firstentry = true}}}},
{id = "plaza", texts = {{text = [[You're in the plaza.`]], style = {"location"}},
{name = "miner", req = Time == "Morning" and Day == "Monday", click = {{id = "miner"}}}, {text = [[ stands at the entrance to the Mines, enthusiastically waving you over.`]], last_req = true},
{text = [[Fly up`]], style = {"location"}, click = {{line = 1, id = "main"}}}
}},


{id = "miner", texts = {{text = [[You approach ]]}, {name = "miner"}, {text = [[.]]}}},
{id = "miner", texts = {{character = "miner", text = [[Oi! Well, if that ain't a sight for sore eyes...`Knower to Be! How ya been?]], sprites = {
	miner = {file = "miner.png", x = 0.5, y = 0.5, tags = "character"},
}}}, onlyif = not Data.miner_first, data = {set = {miner_first = true}}},
{id = "miner", texts = {{character = "miner", text = [[Well... I guess they're just callin' you the Knower now, eh?`Everyone's been gossipin', wonderin' where you were at...`And comin' up with new nicknames for you, hah!]]}}},
{id = "miner", texts = {{character = "miner", text = [[...Ah, um, right. Somethin' I was s'posed to give ya.]]}}},
{id = "miner", texts = {{name = "kolmi"}, {character = "miner", text = [['s little ones have been handing these out.`Ended up givin' yours to me for safekeepin'.`Here.]]}}},
-- key item goes here
{id = "miner", texts = {{character = "miner", text = [[Somethin' called the First Party.`Big, celebration-type event...`Everyone's been buzzin' about it.]], giveitem = "letter"}}},
{id = "miner", texts = {{character = "miner", text = [[Askin' people on dates, clearin' their schedules...`Sheesh. Not my type-a thing.]]}}},
{id = "miner", texts = {{character = "miner", text = [[Everyone who's anyone has got an invite, though.`Dunno why they even bothered makin' one for you.`No one'd dare deny YOU at the door. Hah!]]}}},
{id = "miner", texts = {{character = "miner", text = [[So? You a fan of parties?`Must've been a bit dull, napping alone up there for so long...`Whatcha thinkin' about, Knower? Brain buzzin' already?]]}}},
{id = "miner", texts = {{character = "miner", text = [[Got an idea about who you might wanna take to the Party?`]]},
{text = [[Someone cute and sweet`]], style = {"cute"}, click = {{id = "cute"}}},
{text = [[Someone charming and suave`]], style = {"charming"}, click = {{id = "charming"}}},
{text = [[Someone clever and talented`]], style = {"clever"}, click = {{id = "clever"}}},
{text = [[Someone comedic and witty`]], style = {"comedic"}, click = {{id = "comedic"}}},
{text = [[Someone else`]], style = {"location"}, click = {{id = "else"}}},
{text = [[Don't know]], style = {"typeless"}, click = {{id = "other"}}},
}},

{id = "cute", texts = {{character = "miner", text = [[Hrm. Someone cute, eh...?`Sounds like ]]}, {name = "healer"}, {character = "miner", text = [[ to me.`Ain't nothing more endearing than someone with a heart that big.]]}}},
{id = "cute", texts = {{character = "miner", text = [[Problem is, ]]}, {name = "toimari"},
{character = "miner", text = [[ has been workin' ]] .. P("healer", {she = "her", he = "him", they = "them", it = "it"}) .. [[ to the bone lately.`Heaps of paperwork stackin' to the ceiling...`Yeesh.]]}}},

{id = "charming", texts = {{character = "miner", text =
	[[Thinkin' about someone charming... Hrm.`Sounds like ]]}, {name = "stendari"}, {character = "miner", text = [[, no question 'bout it.]]}
}},
{id = "charming", texts = {{character = "miner", text =
	P("stendari", {she = "She usually hangs ", he = "He usually hangs ", they = "They usually hang ", it = "It usually hangs "}) .. [[out 'round the Lake Island.`That's west of here.`...Wonder how a fire elemental makes it 'cross all that water.]]}
}},

{id = "clever", texts = {{character = "miner", text =
	[[Lookin' for someone with brains? Don't think I'm the right person to ask...`I ain't the sharpest tool in the box. But... ]]}, {name = "assassin"},
	{character = "miner", text = [[ just well might be.`And, if I go missin' tomorrow for calling ]] .. P("assassin", {she = "'er", he = "'im", they = "'em", it = "it"}) .. [[ a tool... well, you'll know who took me! Hah!]]}
}},
{id = "clever", texts = {{character = "miner", text =
	[[Only kiddin'. Mostly.`Still... I'd be careful goin' into alleyways. 'Specially at night.`You don't wanna end up on the wrong side of that energy blade.]]}
}},

}