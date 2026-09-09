SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[Moving downhill through the snowy terrain, you notice a small door tucked into the hillside.`Bright lights shine out from beyond the door...]]}}, onlyif = not Data.firstentry_arcade, data = "firstentry_arcade"},
{id = "main", location = "arcade", texts = {{text = [[You're in the Arcade.`]], style = {"location"}},

{navigator = {
	up = {id = "market"},
}}
}},


}