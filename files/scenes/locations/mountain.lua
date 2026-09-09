SCENE = {

{id = "main", texts = {{text = [[Further north, you find a small staircase, tucked away into the brush.`You step carefully down the mossy bricks, and push your way through an aged doorway...]]}},
	onlyif = not Data.firstentry_mountain, data = {{set = {firstentry_mountain = true}}}},
{id = "main", location = "mountain", texts = {{text = [[You're in the Holy Mountain.`]], style = {"location"}},

{navigator = {
	down = {id = "plaza"},
}}

}}

}