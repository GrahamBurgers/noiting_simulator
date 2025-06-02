dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {

{id = "main", texts = {{text = [[
You're in a place!
]], style = {"location"}},
{text = "You see a bird.", click = {gotoid = "bird", clickableif = false}}, {text = " Also a second bird.\n", click = {gotoid = "bird"}},
{text = "You see something that may or may not be a bird.", click = {gotoid = "notbird", appearif = true, clickableif = true}},}},
{id = "bird", texts = {{text = [[BIRD!]], style = {"white"}}}},
{id = "notbird", texts = {{text = [[WOW!]], style = {"white"}}}},
{id = "any", setscene = {id = "main", line = 1}},
}