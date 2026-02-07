SCENE = {

{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[A pillow and blanket lie beside you. Someone must have placed these here to accommodate you.`]]},
{text = [[A ]]}, {text = [[large blue mushroom]], click = {{id = "mush"}}}, {text = [[ dangles over you in a planter-pot, protecting you from the sun.`]]},
{text = [[Fly down`]], style = {"location"}, click = {{id = "plaza"}}},
}},

{id = "plaza", texts = {{text = [[You carefully levitate down from atop the peak of the Mountain, settling onto ground level.]]}}, onlyif = not Data.plaza_firstentry, data = {set = {plaza_firstentry = true}}},
{id = "plaza", texts = {{text = [[You're in the plaza.`]], style = {"location"}},
{name = "Tappurahiisi", req = Time == "Morning" and Day == "Monday", click = {{id = "miner"}}}, {text = [[ stands at the entrance to the Mines, enthusiastically waving you over.`]], req = Last_req_met},
{text = [[Fly up`]], style = {"location"}, click = {{line = 1, id = "main"}}}
}},


{id = "miner", texts = {{text = [[You approach Tappurahiisi.]]}}},
{id = "miner", texts = {{character = "Tappurahiisi", text = [[Oi! Well, if that ain't a sight for sore eyes...`Knower to Be! How ya been?]]}}, onlyif = not Data.miner_first, data = {set = {miner_first = true}}},
{id = "miner", texts = {{character = "Tappurahiisi", text = [[Well... I guess they're just callin' you the Knower now, eh?`Guess you already know enough as is.`I feel that... Shorter, sweeter.]]}}},
{id = "miner", texts = {{character = "Tappurahiisi", text = [[Lemme tell ya, you looked like a right angel descending from that there altar.`...Er, that's not flirting.`Just... an observation, y'see.]]}}},
{id = "miner", texts = {{character = "Tappurahiisi", text = [[...Ah, um, right. Somethin' I was s'posed to give ya.]]}}},
{id = "miner", texts = {{name = "Kolmi"}, {character = "Tappurahiisi", text = [[ has been sending out minions all over with these.`Ended up givin' yours to me for safekeepin'.]]}}},
-- key item goes here
{id = "miner", texts = {{character = "Tappurahiisi", text = [[Yup. Pretty high-scale thing, looks like.`I think an invitation got handed to everyone who's anyone.]]}}},
{id = "miner", texts = {{character = "Tappurahiisi", text = [[Everyone's been buzzin' about it. ]]}}},

}