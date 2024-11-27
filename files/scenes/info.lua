SCENE = {

{track = "main", texts = {{text = [[Welcome to Spellbound Hearts!
]], style = {"location"}}, {text = [[Press [INTERACT] to advance text when you see those three arrows.]]}}},
{track = "main", texts = {{text = [[[CLICK] on options to select them.
Would you like to play through the rest of the tutorial?]]}},
choices = {
    {name = "Yes tutorial!", location = "topleft", gototrack = "tutorial"},
    {name = "No tutorial!", location = "topright", gototrack = "notutorial"},
}},
{track = "tutorial", texts = {{text = [[Alright!
Press or hold [KICK] to fast-forward text.
]]}, {text = [[Yaaaaaawn...]], forcetickrate = -30}}},
}