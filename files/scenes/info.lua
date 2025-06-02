dofile("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {
{onlyif = string.len(Name_caps) > 0, texts = {{text = [[Hello, ]] .. Name_caps .. [[!
]], style = {"location"}}, {text = [[Would you like to go through the tutorial?
]]}, {text = [[Yes tutorial
]], click = {{id = "Tutorial2"}}}, {text = [[No tutorial]], click = {{id = "TutorialEnd"}}}}},

{id = "TutorialEnd", texts = {{text = [[Alright! Time for the main event...]]}}, sendto = {{file = "intro.lua"}}},
{id = "Tutorial2", texts = {{text = [[Alright! Here we go...]]}}, sendto = {{id = "Tutorial3"}}},

{id = "Tutorial3", texts = {{text = [[Welcome to Spellbound Hearts!
]], style = {"location"}}, {text = [[Press [RIGHT] to advance text when you see that golden arrow.
You can also click on the arrows.]]}}},
{texts = {{text = [[Press [LEFT] to go back and view history.
[RIGHT] to come back here when you're done.]]}}},
{texts = {{text = [[[CLICK] on underlined options to select them.
]]}, {text = "Got it!", click = {}}}},
{texts = {{text = [[Right-click or press [KICK] to fast-forward text.
]]}, {text = [[Yaaaaaaawn..........]], forcetickrate = -30}}},
{texts = {{text = [[Especially long texts will give you [UP] and [DOWN] arrows to scroll with.




Keep scrolling!




]]}, {text = "Victory!", click = {}, size = 1.5}}},
{texts = {{text = [[Welcome, ]] .. Name_caps .. [[!
Just some disclaimers to go through, and then we can begin...
Please read these carefully!]]}}},
{texts = {{text = [[• This mod is]]}, {text = [[ basically just a visual novel! ]], style = {"location"}}, {text = [[(Mostly.)
There will be a lot of reading. I hope you're into that.]]}}},
{texts = {{text = [[• This mod contains only safe-for-work content. So don't make it weird, OK?]]}}},
{infunc = function()
    if HasFlagPersistent("progress_ending2") then
        FindLine({id = "Fakeout"})
    else
        FindLine({id = "Fakeout"})
    end
end},
{id = "Fakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
]]}, {text = [[Since you haven't reached that ending previously, you won't be able to play this mod until you]], forcetickrate = -2}, {text = [[...
]], forcetickrate = -30}, {text = [[Nah, just kidding.]]}}, sendto = {{id = "NextFakeout"}}},

{id = "NotFakeout", texts = {{text = [[• This mod canonically takes place after the Peaceful Ending.
Some suspension of disbelief may be necessary...]]}}, sendto = {{id = "NextFakeout"}}},
{id = "NextFakeout", texts = {{text = [[• This mod will, for the most part, not play like Noita!]]}}},
{texts = {{text = [[Ok, that's all. You ready?
]]}, {text = "Go!", click = {{file = "intro.lua"}}}}},
}