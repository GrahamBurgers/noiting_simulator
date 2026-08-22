SCENE = {

{id = "main", texts = {{text = [[You approach ]]}, {name = "healer"}, {text = [[.]]}}, sendto = {
	{id = "healer_first", onlyif = not Data.healer_first},
	{id = "healer_generic"}
}},

{id = "healer_first", texts = {{character = "healer", text = [[O-oh...! It's... you!]]}}, data = "healer_first"},

{id = "main", bookmarkreturn = 1},


}