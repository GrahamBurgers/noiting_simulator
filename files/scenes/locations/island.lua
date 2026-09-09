SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[?!]]}}, onlyif = not Data.firstentry_lakeside, data = "firstentry_island"},
{id = "main", location = "island", texts = {{text = [[You're on the Lake Island.`]], style = {"location"}},

{navigator = {
	right = {id = "lakeside"},
}}}}


}