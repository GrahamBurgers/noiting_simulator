SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[The snowy hills taper off here. At the end of the path, serene waters come into view, alongside a familiar cabin.]]}}, onlyif = not Data.firstentry_lakeside, data = "firstentry_lakeside"},
{id = "main", location = "lakeside", texts = {{text = [[You're at the Lakeside.`]], style = {"location"}},

{navigator = {
	right = {id = "market"},
}}}}


}