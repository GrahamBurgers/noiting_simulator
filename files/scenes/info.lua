dofile("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {
{track = "main", texts = {{text = [[WAAH
waaah
waaaah
waaaaah
waaaaaah
waaaaaaah
waaaaaaaah
waaaaaaaaah
waaaaaaaaaah
waaaaaaaaaah!
waaaaaaaaaah!!
waaaaaaaaaah!!!
waaaaaaaaaah!!!!]]}}},
{track = "main", texts = {{text = [[waah
waaah
waaaah
waaaaah
waaaaaah
waaaaaaah
waaaaaaaah
waaaaaaaaah
waaaaaaaaaah
waaaaaaaaaah!
waaaaaaaaaah!!
waaaaaaaaaah!!!
waaaaaaaaaah!!!!]]}}},
{track = "main", onlyif = Name_caps ~= "", texts = {{text = [[Hello, ]] .. Name_caps .. [[!
]], style = {"location"}}, {text = [[Would you like to go through the tutorial?]]}},
choices = {
    {name = "[No tutorial]", position = "left", gototrack = "TutorialEnd"},
    {name = "[Yes tutorial]", position = "right", gototrack = "Tutorial2"},
}},

{track = "TutorialEnd", texts = {{text = [[Alright! Wakey wakey...]]}}},
{track = "Tutorial2", texts = {{text = [[Alright! Here we go...]]}}, gototrack = "main"},

{track = "main", texts = {{text = [[Welcome to Spellbound Hearts!
]], style = {"location"}}, {text = [[Press [INTERACT] to advance text when you see those three arrows.
You can also [CLICK] on the arrows to advance.]]}}},
{track = "main", texts = {{text = [[A SCROLLBAR will appear over there. ------>
Please pull it to the bottom.
...
...
...
...
...Good job! Scroll back up at any time to view the history of lines you've seen before.]]}}},
{track = "main", texts = {{text = [[[CLICK] on options to select them.]]}},
choices = {
    {name = "[Okay]", position = "middle"},
    {name = "[Acknowledged]", position = "right"},
    {name = "[Got it]", position = "left"},
}},
{track = "main", texts = {{text = [[Some options may also appear underlined, ]]}, {text = [[like this.]], click = {}}, {text = [[ Click it!]]} }},
{track = "main", texts = {{text = [[Press or hold [KICK] to fast-forward text.
]]}, {text = [[Yaaaaaaawn..........]], forcetickrate = -30}}},
{track = "main", texts = {{text = [[Now, please navigate to the [MOD SETTINGS].
Enter your name there to proceed.]]}}, behavior = "wait", waitfor = Name_caps ~= "", onlyif = Name_caps == ""},
{track = "main", texts = {{text = [[Welcome, ]] .. Name_caps .. [[!
Just some disclaimers to go through, and then we can begin...
Please read these carefully!]]}}},
{track = "main", texts = {{text = [[• This mod is ]]}, {text = [[no joke!]], style = {"location"}}, {text = [[ (Mostly.)
There will be a lot of reading. I hope you're into that.]]}}},
{track = "main", texts = {{text = [[• This mod contains only safe-for-work content. So don't make it weird, OK?]]}}},
{track = "main", func = function()
    if HasFlagPersistent("progress_ending2") then
        Track("NotFakeout")
    else
        Track("Fakeout")
    end
end},
{track = "Fakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
]]}, {text = [[Since you haven't reached that ending yet, you won't be able to play this mod until you]], forcetickrate = -2}, {text = [[...]], forcetickrate = -30},
{text = [[Nah, just kidding.]]}}, gototrack = "main"},

{track = "NotFakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
Some suspension of disbelief may be necessary...]]}}, gototrack = "main"},
{track = "main", texts = {{text = [[• This mod will, for the most part, not play like Noita!]]}}},
{track = "main", texts = {{text = [[• Someone's calling your name.]]}}},
{track = "main", texts = {{text = [[• They keep calling it. They sound distressed.]]}}},
{track = "main", texts = {{text = [[• ]] .. Name_caps .. [[! ]].. Name_caps .. [[! ]]}}, gototrack = "TutorialEnd"},

{track = "TutorialEnd", setscene = {file = "intro.lua"}}
}