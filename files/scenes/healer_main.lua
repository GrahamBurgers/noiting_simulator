SCENE = {

{id = "main", texts = {{text = [[You approach ]]}, {name = "healer"}, {text = [[.]]}}, sendto = {
	{id = "healer_first", onlyif = not Data.healer_first},
	{id = "healer_generic"}
}, sprites = {healer = {file = "healer.png", preset = "slide_in_from_left"}}},

{id = "healer_first", texts = {{character = "healer", text = [[O-oh...! It's... you!]],
}}, data = "healer_first", sprites = {healer = {file = "healer.png"}}},

{id = "healer_first", texts = {{character = "healer", text = [[Knower... T-they all said you were sleeping on the Altar...!]],
}}}, sprites = {healer = {file = "healer.png"}},

{id = "main", bookmarkreturn = 1, sprites = {healer = {preset = "slide_left_and_die"}}},

}