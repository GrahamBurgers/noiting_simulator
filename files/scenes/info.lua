dofile("mods/noiting_simulator/files/scripts/characters.lua")
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
    {name = "No tutorial", position = "left", gototrack = "TutorialEnd"},
    {name = "Yes tutorial", position = "right", gototrack = "Tutorial2"},
}},

{track = "TutorialEnd", texts = {{text = [[Alright! Wakey wakey...]]}}},
{track = "Tutorial2", texts = {{text = [[Alright! Here we go...]]}}, gototrack = "Tutorial"},

{track = "Tutorial", texts = {{text = [[Welcome to Spellbound Hearts!
]], style = {"location"}}, {text = [[Press [INTERACT] to advance text when you see those three arrows.
You can also [CLICK] on the arrows to advance.]]}}},
{track = "Tutorial", texts = {{text = [[A SCROLLBAR will appear over there. ------>
Please pull it to the bottom.
...
...
...
...
...Good job! Scroll back up at any time to view the history of lines you've seen before.]]}}},
{track = "Tutorial", texts = {{text = [[[CLICK] on options to select them.]]}},
choices = {
    {name = "Okay", position = "middle"},
    {name = "Acknowledged", position = "right"},
    {name = "Got it", position = "left"},
}},
{track = "Tutorial", texts = {{text = [[Press or hold [KICK] to fast-forward text.
]]}, {text = [[Yaaaaaaawn..........]], forcetickrate = -30}}},
{track = "Tutorial", texts = {{text = [[Now, please navigate to the [MOD SETTINGS].
Enter your name there to proceed.]]}}, behavior = "wait", waitfor = Name_caps ~= ""},
{track = "Tutorial", texts = {{text = [[Welcome, ]] .. Name_caps .. [[!
Just some disclaimers to go through, and then we can begin...
Please read these carefully!]]}}},
{track = "Tutorial", texts = {{text = [[• This mod is ]]}, {text = [[no joke!]], style = {"location"}}, {text = [[ (Mostly.)
There will be a lot of reading. I hope you're into that.]]}}},
{track = "Tutorial", texts = {{text = [[• This mod contains only safe-for-work content. So don't make it weird, OK?]]}}},
{track = "Tutorial", func = function()
    if HasFlagPersistent("progress_ending2") then
        Track("NotFakeout")
    else
        Track("Fakeout")
    end
end},
{track = "Fakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
]]}, {text = [[Since you haven't reached that ending yet, you won't be able to play this mod until you]], forcetickrate = -2}, {text = [[...]], forcetickrate = -30},
{text = [[Nah, just kidding.]]}}, gototrack = "Tutorial"},

{track = "NotFakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
Some suspension of disbelief will be necessary.]]}}, gototrack = "Tutorial"},
{track = "Tutorial", texts = {{text = [[• This mod will, for the most part, not play like Noita!]]}}},
{track = "Tutorial", texts = {{text = [[• Someone's calling your name.]]}}},
{track = "Tutorial", texts = {{text = [[• They keep calling it. They sound distressed.]]}}},
{track = "Tutorial", texts = {{text = [[• ]] .. Name_caps .. [[! ]].. Name_caps .. [[! ]]}}, gototrack = "TutorialEnd"},

{track = "TutorialEnd", setscene = {file = "intro.lua"}}
}