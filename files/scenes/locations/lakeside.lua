SCENE = {

{id = "main", onlyif = GetStamina("ANY") < 1, bookmark = {{file = "time_check.lua", line = 1, id = "main"}}},

{id = "main", texts = {{text = [[The snowy hills taper off here. At the end of the path, serene waters come into view, alongside a familiar cabin.]]}}, onlyif = not Data.firstentry_lakeside, data = "firstentry_lakeside"},
{id = "main", location = "lakeside", texts = {{text = [[You're at the Lakeside.`]], style = {"location"}},

{name = "icemage", req = GetSchedule("icemage") == "fishing"}, {text = " is fishing.`", last_req = true},
{text = [[A cozy-looking ]]}, {text = [[hut]], click = {{id = "hut_inside"}}, style = {"travel"}}, {text = [[ sits on the edge of the water.]]},
{text = [[Dive]], click = {{file = "locations/diving.lua"}}, style = {"travel"}, req = CheckForItem("waterstone") == true},

{navigator = {
	right = {id = "market"},
}}}},


{id = "hut_inside", texts = {
{text = [[You're in the Lakeside Hut. There's a strong smell of fish in here.`A line of ]]},
{text = [[fishing rods]], click = {{id = "fishing_rods"}}}, {text = [[ are hung up along the far wall.`]]},

{text = [[In the corner of the room, a ]], onlyif = Data.mimic_left_hut ~= true}, {text = [[treasure chest]], lastreq = true, click = {{id = "hut_treasure_chest"}}}, {text = [[ sits.`]], lastreq = true},

{name = "icemage", req = GetSchedule("icemage") == "sleeping", click = {{id = "icemage_sleepy"}}}, {text = " is sleeping on the hut's bed.`", last_req = true},

{text = [[Outside]], style = {"travel"}, click = {{line = 1, id = "main"}}},
}},



{id = "hut_treasure_chest", texts = {{text =
	[[You approach the chest and crouch down to inspect it.`The lid doesn't budge. Must be locked.]],
},
{text = [[`Back`]], style = {"location"}, click = {{line = 1, id = "hut_inside"}}},
}},



{id = "icemage_sleepy", texts = {
	{text = [[You give ]]}, {name = "icemage"}, {text = [[ a light shake.`...Then a harder one.`No response. Must be fishing in ]] .. P("icemage", "THEIR") .. [[ dreams.]]}
}, sendto = {{line = 1, id = "hut_inside"}}},

}