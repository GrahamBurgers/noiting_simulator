dofile("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {
{track = "main", onlyif = string.len(Name_caps) > 0, texts = {{text = [[Hello, ]] .. Name_caps .. [[!
]], style = {"location"}}, {text = [[Would you like to go through the tutorial?
]]}, {text = [[Yes tutorial
]], click = {track = "Tutorial2"}}, {text = [[No tutorial]], click = {track = "TutorialEnd"}}}},

{track = "TutorialEnd", texts = {{text = [[Alright! Time for the main event...]]}}},
{track = "Tutorial2", texts = {{text = [[Alright! Here we go...]]}}, set = {track = "main"}},

{track = "main", texts = {{text = [[Welcome to Spellbound Hearts!
]], style = {"location"}}, {text = [[Press [RIGHT] to advance text when you see that golden arrow.
You can also click on the arrows.]]}}},
{track = "main", texts = {{text = [[Press [LEFT] to go back and view history.
[RIGHT] to come back here when you're done.]]}}},
{track = "main", texts = {{text = [[[CLICK] on underlined options to select them.
]]}, {text = "Got it!", click = {lineadd = 1}}}},
{track = "main", texts = {{text = [[Right-click or press [KICK] to fast-forward text.
]]}, {text = [[Yaaaaaaawn..........]], forcetickrate = -30}}},
{track = "main", texts = {{text = [[Especially long texts will give you [UP] and [DOWN] arrows to scroll with.




Scroll down!




Keep scrolling!




]]}, {text = "Victory!", click = {lineadd = 1}}}},
{track = "main", texts = {{text = [[Now, please navigate to the [MOD SETTINGS].
Enter your name there to proceed.]]}}, behavior = "wait", waitfor = Name_caps ~= "", onlyif = Name_caps == ""},
{track = "main", texts = {{text = [[Welcome, ]] .. Name_caps .. [[!
Just some disclaimers to go through, and then we can begin...
Please read these carefully!]]}}},
{track = "main", texts = {{text = [[• This mod is]]}, {text = [[ basically just a visual novel! ]], style = {"location"}}, {text = [[(Mostly.)
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
]]}, {text = [[Since you haven't reached that ending previously, you won't be able to play this mod until you]], forcetickrate = -2}, {text = [[...]], forcetickrate = -30},
{text = [[Nah, just kidding.]]}}, set = {track = "main"}},

{track = "NotFakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
Some suspension of disbelief may be necessary...]]}}, set = {track = "main"}},
{track = "main", texts = {{text = [[• This mod will, for the most part, not play like Noita!]]}}},
{track = "main", texts = {{text = [[Ok, that's all. You ready?
]]}, {text = "Go!", click = {track = "TutorialEnd"}}}},

{track = "TutorialEnd", setscene = {file = "intro.lua"}}
}