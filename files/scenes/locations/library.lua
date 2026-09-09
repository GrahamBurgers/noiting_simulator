SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[A well-maintained path leads you to a well-worn building...]]}}, onlyif = not Data.firstentry_library, data = "firstentry_library"},
{id = "main", location = "library", texts = {{text = [[You're in the Library.`]], style = {"location"}},

{navigator = {
	down = {id = "park"},
}}}}


}