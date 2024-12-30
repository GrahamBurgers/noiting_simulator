dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
SCENE = {

{track = "main", texts = {{text = [[
You're in a place!
]], style = {"location"}},
{text = "You see a bird.", click = {gototrack = "bird", clickableif = false}}, {text = " Also a second bird.\n", click = {gototrack = "bird"}},
{text = "You see something that may or may not be a bird.", click = {gototrack = "notbird", appearif = true, clickableif = true}},}},
{track = "bird", texts = {{text = [[BIRD!]], style = {"white"}}}},
{track = "notbird", texts = {{text = [[WOW!]], style = {"white"}}}},
{track = "any", setscene = {track = "main", line = 1}},
}