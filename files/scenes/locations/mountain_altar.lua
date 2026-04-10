SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1}}},
{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[A pillow and blanket lie beside you. Someone must have placed these here to accommodate you.`]]},
{text = [[A ]]}, {text = [[large blue mushroom]], click = {{id = "mush"}}}, {text = [[ dangles over you in a planter-pot, shading you from the sun.`]]},
{text = [[Fly down`]], style = {"location"}, click = {{id = "plaza"}}},
}},

{id = "plaza", texts = {{text = [[You carefully levitate down from atop the peak of the Mountain, settling onto ground level.]]}}, onlyif = not Data.plaza_firstentry, data = {{set = {plaza_firstentry = true}}}},
{id = "plaza", texts = {{text = [[You're in the plaza.`]], style = {"location"}},
{name = "miner", req = Time == "Morning" and Day == "Monday", click = {{id = "miner"}}}, {text = [[ stands at the entrance to the Mines, enthusiastically waving you over.`]], req = Last_req_met},
{text = [[Fly up`]], style = {"location"}, click = {{line = 1, id = "main"}}}
}},


{id = "miner", texts = {{text = [[You approach ]]}, {name = "miner"}, {text = [[.]]}}},
{id = "miner", texts = {{character = "miner", text = [[Oi! Well, if that ain't a sight for sore eyes...`Knower to Be! How ya been?]], sprites = {
	miner = {file = "miner.png", x = 0.5, y = 0.5, tags = "character"},
}}}, onlyif = not Data.miner_first, data = {set = {miner_first = true}}},
{id = "miner", texts = {{character = "miner", text = [[Well... I guess they're just callin' you the Knower now, eh?`Everyone's been gossipin', wonderin' where you were at...`And comin' up with new nicknames for you, hah!]]}}},
{id = "miner", texts = {{character = "miner", text = [[...Ah, um, right. Somethin' I was s'posed to give ya.]]}}},
{id = "miner", texts = {{name = "kolmi"}, {character = "miner", text = [['s little ones have been handing these out.`Ended up givin' yours to me for safekeepin'.]]}}},
-- key item goes here
{id = "miner", texts = {{character = "miner", text = [[Somethin' called the First Party.`Big, celebration-type event...`Everyone's been buzzin' about it.]], giveitem = "letter"}}},
{id = "miner", texts = {{character = "miner", text = [[Askin' people on dates, clearin' their schedules...`Sheesh. Not my type-a thing.]]}}},
{id = "miner", texts = {{character = "miner", text = [[Everyone who's anyone has got an invite, though.`Dunno why I agreed to hold onto yours.`No one'd dare deny YOU at the door.]]}}},
{id = "miner", texts = {{character = "miner", text = [[What about you, though, eh? You a fan of parties?`Must've been a bit dull, napping alone up there for so long...]]}}},
{id = "miner", texts = {{character = "miner", text = [[Heh, your brain's buzzin' already, isn't it?`Even behind that hood, I can tell...]]}}},
{id = "miner", texts = {{character = "miner", text = [[Whatcha thinkin' about, Knower?`Thinkin' of who you might wanna take to the Party?`]]},
{text = [[Someone cute and sweet`]], style = {"cute"}, click = {{id = "cute"}}},
{text = [[Someone charming and suave`]], style = {"charming"}, click = {{id = "charming"}}},
{text = [[Someone clever and talented`]], style = {"clever"}, click = {{id = "clever"}}},
{text = [[Someone comedic and witty`]], style = {"comedic"}, click = {{id = "comedic"}}},
{text = [[Someone else`]], style = {"location"}, click = {{id = "else"}}},
{text = [[Don't know]], style = {"typeless"}, click = {{id = "other"}}},
}},

}