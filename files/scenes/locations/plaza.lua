dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {

{track = "main", texts = {{text = [[
You're in a place!
]], style = {"location"}},
{text = [[You see a bird.
]], style = {"interact"}}, {text = [[Something]], style = {"interact"}}, {text = [[ is interactible!
]], style = {"info"}}, {text = [[Something else]], style = {"interact"}}, {text = [[ is interactible!
]], style = {"info"}}},
choices = {
    {name = "Something", position = "left", gototrack = "aaa"},
    {name = "Something else", position = "middle", gototrack = "bbb"},
    {name = "AAaahh", position = "right", gototrack = "ccc"},
}},
{track = "bbb", texts = {{text = [[thingy]], style = {"blue"}}}},

}