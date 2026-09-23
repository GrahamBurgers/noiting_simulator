SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[There's a chill to the air here.`You tread carefully...]]}}, onlyif = not Data.firstentry_sunseed, data = "firstentry_sunseed"},
{id = "main", location = "sunseed", texts = {{text = [[You're in the Forgotten Grotto.`]], style = {"location"}},

{navigator = {
	right = {id = "forest", req = Data.vine_untangle_done == true},
}}
}},


}