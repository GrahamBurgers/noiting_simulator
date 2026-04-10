dofile_once("mods/noiting_simulator/files/scripts/time.lua")

SCENE = {

{texts = {{text = [[. . .`Out of energy, you take a moment to rest before continuing onwards.]]}}, sendto = {{id = "sleepy", onlyif = Time == "Evening"}, {id = "normal"}}},
{id = "sleepy", texts = {{text = [[It's getting late.`You're having trouble reopening your eyelids...]]}}},
{id = "sleepy", texts = {{text = [[Behind your closed eyes, a figure appears to you.`]] ..
	P("kummitus", {he = "He holds out his hand ", she = "She holds out her hand ", they = "They hold out their hand ", it = "It holds out its hand "}) ..
	[[in offering.`]]}, {text = [[You hear whispers of comfort and rest...`]], style = {"emphasis1"}},
	{text = [[Take hand`]], click = {{id = "yessleep"}}},
	{text = [[Do not`]], click = {{id = "nosleep"}}},
}},

{id = "normal", texts = {{text = [[When you reopen your eyes, the world around you has changed.`]]}, {text = [[Time has passed.]], style = {"info"}}}},
{bookmarkreturn = 1, passtime = 1},

}