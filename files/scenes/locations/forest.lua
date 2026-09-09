SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[The brush thickens in this direction.`You weave through the grass and trees as they grow taller...]]}}, onlyif = not Data.firstentry_forest, data = "firstentry_forest"},
{id = "main", location = "forest", texts = {{text = [[You're in the Forest.`]], style = {"location"}},

{navigator = {
	up = {id = "park"},
}}}}


}