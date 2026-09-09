SCENE = {

{id = "main", texts = {{text = [[You make your way onto a path that takes you deeper into the Snowy Wasteland.`The architecture here is distinctly Hiisi.]]}}, onlyif = not Data.firstentry_market, data = {{set = {firstentry_market = true}}}},
{id = "main", location = "market", texts = {{text = [[You're in the Plaza.`]], style = {"location"}},
{text = [[Along the pathway, various booths are set up with products for sale.`]]},

{navigator = {
	left = {id = "lakeside"},
	up = {id = "apartments"},
	down = {id = "arcade"},
	right = {id = "plaza"},
}}}}

}