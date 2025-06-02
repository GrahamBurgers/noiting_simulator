dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {

{id = "main", texts = {{text = [[
You're in the park.
]], style = {"location"}},
{text = [[The Old Sun shines brightly.
]], style = {"interact"}}, {text = [[Something]], style = {"interact"}}, {text = [[ is interactible!
]], style = {"info"}}, {text = [[Something else]], style = {"interact"}}, {text = [[ is interactible!
]], style = {"info"}}},
choices = {
    {name = "Something", position = "left", gotoid = "aaa"},
    {name = "Something else", position = "middle", gotoid = "bbb"},
    {name = "AAaahh", position = "right", gotoid = "ccc"},
}},
{id = "bbb", texts = {{text = [[thingy]], style = {"blue"}}}},

}