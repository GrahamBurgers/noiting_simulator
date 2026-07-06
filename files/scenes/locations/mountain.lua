SCENE = {

{id = "main", texts = {{text = [[Further north, you find a small staircase, tucked away into the brush.`You step carefully down the mossy bricks, and enter a doorway to find...]]}},
	onlyif = not Data.firstentry_mountain, data = {{set = {firstentry_mountain = true}}}},
{id = "main", location = "mountain", texts = {{text = [[You're in the Holy Mountain.`]], style = {"location"}},

{img = {path = "mods/noiting_simulator/files/gui/arrow_down.png"}}, {text = [[Plaza`]], click = {{file = "locations/plaza.lua"}}, style = {"travel"}},
}}

}