SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[The brush thickens in this direction.`You weave through the grass and trees as they grow taller...]]}}, onlyif = not Data.firstentry_forest, data = "firstentry_forest"},
{id = "main", location = "forest", texts = {{text = [[You're in the Forest.`]], style = {"location"}},

{text = [[The base of the ]]}, {text = [[Great Tree]], click = {{file = "locations/tree.lua"}}, style = {"travel"}}, {text = [[ is nearby.`]]},

{text = [[Search]], click = {{id = "search"}}, staminacost = 1, req = Data.searched_in_forest ~= true and Data.vine_untangle_done ~= true},
{text = [[Tangled Vines]], click = {{id = "vine_tangle"}}, req = Data.searched_in_forest == true and Data.vine_untangle_done ~= true},

{navigator = {
	up = {id = "park"},
	down = {id = "sunseed", req = Data.vine_untangle_done == true},
}}},

sprites = {vines = {file = "vine_tangle.png", preset = "slide_left_and_die"}}},

{id = "search", texts = {{text =
	[[Following an intuition, you look through the brush for something big...]],
}}, data = "searched_in_forest", sendto = {{id = "vine_tangle"}}},

{id = "vine_tangle", texts = {{text =
	[[There's a huge bundle of vines blocking the path here, far too thick to cut through.`They're ]],
},

{text = [[very tangled]], style = {"red"}, req = (Data.untangle_count or 0) == 0},
{text = [[quite tangled]], style = {"yellow"}, req = (Data.untangle_count or 0) == 1},
{text = [[slightly tangled]], style = {"green"}, req = (Data.untangle_count or 0) == 2},
{text = [[.`]]},

{text = [[Untangle]], style = {"location"}, staminacost = 3, click = {{id = "untangle"}}},
{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "main"}}},

}, sprites = {vines = {file = "vine_tangle.png", preset = "slide_in_from_left"}},
},

{id = "untangle", texts = {{text =
	[[You spend some time pulling the heavy vines to and fro...`That's a bit better.]],
}}, data = {{set = {untangle_count = (Data.untangle_count or 0) + 1}}}, sendto = {{id = "vine_untangle_done", onlyif = (Data.untangle_count or 0) > 2}, {id = "vine_tangle", line = 1}}},

{id = "vine_untangle_done", texts = {{text =
	[[In fact... the vines now seem loose enough to slip underneath.`It seems like you've opened a new path...]],
}}, data = "vine_untangle_done", sendto = {{id = "main", line = 1}}},

}