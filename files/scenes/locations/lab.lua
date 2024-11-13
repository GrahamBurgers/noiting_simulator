dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
local k = Pronouns["Kolmi"]
SCENE = {

{track = "main", texts = {{text = [[
You're in The Laboratory.
]], style = {"location"}},
{text = [[Kolmisilmä looms above you.
Your Kammi is west of here. Jättimato is east of here.]], style = {"info"}}},
choices = {
    {name = "Kammi", location = "left", gototrack = "kammi", style={"location"}},
    {name = "Kolmisilmä", location = "top", gototrack = "kolmi"},
    {name = "Jättimato", location = "right", gototrack = "worm", style={"location"}},
}},
{track = "worm", setscene = {file = "intro2.lua"}},
{track = "kolmi", func = function()
    if Geterate("kolmi_wisdom", 2) > 1 then
        Track("kolmi2")
    else
        if GlobalsGetValue("NS_DAY", "1") then
            Track("kolmi1")
        else
            Track("kolmi2")
        end
    end
end },
{track = "kolmi1", texts = {{text = [[You approach Kolmisilmä. ]] .. k["They"] .. Plural(k["They"], " look ", " looks ") .. [[somewhat amused to see you approaching.]]}}},
{track = "kolmi1", texts = {{text = [["Eh...? Back so soon, Knower? If you're pining after me, I'm afraid you'll be sorely disappointed...]], style = {"kolmi"}}}},
{track = "kolmi1", texts = {{text = [[I'm rather too large to travel to any parties.
However, I won't simply be napping while you're off adventuring.
As usual, I've been gathering knowledge... This time, about our new world.]], style = {"kolmi"}}}},
{track = "kolmi1", setscene = {track = "kolmi2"}},
{track = "kolminext", texts = {{text = [[Ah! That made your eyes light up quite nicely.]], style = {"kolmi"}}}},
}