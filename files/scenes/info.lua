dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {

{track = "main", func = function()
    if ModSettingGet("noiting_simulator.name") ~= "" then
        Track("PlayedBefore")
    else
        Track("Tutorial")
    end
end},

{track = "PlayedBefore", texts = {{text = [[Hello, ]] .. Name_caps .. [[!
]] , style = {"location"}}, {text = [[Would you like to go through the tutorial?]]}},
choices = {
    {name = "No tutorial", location = "topleft", gototrack = "TutorialEnd"},
    {name = "Yes tutorial", location = "topright", gototrack = "Tutorial2"},
}},

{track = "TutorialEnd", texts = {{text = [[Alright! Wakey wakey...]]}}},
{track = "Tutorial2", texts = {{text = [[Alright! Here we go...]]}}},

{track = "Tutorial", texts = {{text = [[Welcome to Spellbound Hearts!
]], style = {"location"}}, {text = [[Press [INTERACT] to advance text when you see those three arrows.]]}}},
{track = "Tutorial", texts = {{text = [[[CLICK] on options to select them.]]}},
choices = {
    {name = "Okay", location = "top"},
    {name = "Acknowledged", location = "topright"},
    {name = "Got it", location = "topleft"},
}},
{track = "Tutorial", texts = {{text = [[Press or hold [KICK] to fast-forward text.
]]}, {text = [[Yaaaaaaawn..........]], forcetickrate = -30}}},
{track = "Tutorial", texts = {{text = [[Now, please navigate to the [MOD SETTINGS].
You'll need to enter your name there.]]}}},

{track = "TutorialEnd", setscene = {file = "intro.lua"}}
}