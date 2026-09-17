SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[The sandy terrain of the Desert is visible up ahead.`A curious building sits on the border between the dirt and sand...]]}}, onlyif = not Data.firstentry_theater, data = "firstentry_theater"},
{id = "main", location = "theater", texts = {{text = [[You're in the Theater of the Arts.`]], style = {"location"}},

{navigator = {
	left = {id = "park"},
}}}}


}