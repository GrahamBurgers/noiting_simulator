SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[Moving downhill through the snowy terrain, you notice a small door tucked into the hillside.`Bright lights shine out from beyond the door...]]}}, onlyif = not Data.firstentry_arcade, data = "firstentry_arcade"},
{id = "main", location = "arcade", texts = {{text = [[You're in the Arcade.`]], style = {"location"}},
{text = [[Bright lights shine out from the machines in every direction.`]]},
{text = [[Fighting-game cabinet`]], click = {
	{id = "bot_arcade2", onlyif = Data.bot_arcade == true},
	{id = "bot_arcade"},
}},

{navigator = {
	up = {id = "market"},
}}
}, sprites = {bot_arcade = {preset = "slide_left_and_die"}}},



{id = "bot_arcade", texts = {{text =
	[[Four familiar drones are plugged into this machine.`It's some sort of intense free-for-all shooter game...`They seem pretty immersed.]]},
}, sprites = {bot_arcade = {file = "bot_arcade.png", preset = "slide_in_from_left"}}},

{id = "bot_arcade", texts = {{text =
	[[...Each robot is playing perfectly, never taking damage.`The timer is maxed out at 59:59.`Just how long have they been doing this for?`]]},
	{text = [[Watch`]], click = {{id = "bot_watch"}}},
	{text = [[Back`]], click = {{line = 1, id = "main"}}},
}, sprites = {bot_arcade = {file = "bot_arcade.png"}}},



{id = "bot_arcade2", texts = {{text =
	[[...The bots are still going.`]]},
	{text = [[Watch]], click = {{id = "bot_watch2"}}},
	{text = [[`Interrupt]], click = {{id = "bot_interrupt"}}},
	{text = [[`Back]], click = {{line = 1, id = "main"}}},
}, sprites = {bot_arcade = {file = "bot_arcade.png", preset = "slide_in_from_left"}}},



{id = "bot_watch", texts = {{text =
	[[You lean on one of the bots and simply watch the screen for a while.`It's mesmerizing. Each player aims and dodges flawlessly...`It's a dance of bullets that never connect.]]},
}, sprites = {bot_arcade = {file = "bot_arcade2.png"}}},

{id = "bot_watch", texts = {{text =
	[[...You begin to wonder if it'll ever end.`A little while later, your vision begins to slowly blur...`A moment after that, you force yourself to step away.`...Don't want to overdose on video games now.]]},
}, data = "bot_arcade", sprites = {bot_arcade = {file = "bot_arcade.png"}}, sendto = {{line = 1, id = "main"}}},



{id = "bot_watch2", texts = {{text =
	[[You sit atop one of the bots, and simply stare at the screen until your eyes begin to sting.`...Ouch. What was that for?]]},
}, sprites = {bot_arcade = {file = "bot_arcade2.png"}}, sendto = {{line = 1, id = "main"}}},


{id = "bot_interrupt", texts = {{text =
	[[You take a cautious step closer to the arcade cabinet.`The robots interface with the console through their plugs here.`It looks like it'll be easy, but...`]]},
	{text = [[You have a bad feeling about this.`]], style = {"red"}},
	{text = [[Unplug`]], click = {{line = 1, id = "bot_unplug"}}},
	{text = [[Nevermind`]], click = {{line = 1, id = "bot_arcade2"}}},
}, sprites = {bot_arcade = {file = "bot_arcade2.png"}}},

}