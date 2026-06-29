dofile_once("mods/noiting_simulator/files/scripts/time.lua")

SCENE = {

{onlyif = Time == "Night", texts = {{text = [[. . .`You've exhausted yourself.`Out of energy, you see the figure appear before you again.]]}}},
{onlyif = Time == "Night", texts = {{text = [[You sway as you step, and fall into ]] .. P("kummitus", "THEIR") .. [[ open arms...]]}}, sendto = {{id = "sleepy"}}},

{texts = {{text = [[. . .`Out of energy, you take a moment to rest before continuing onwards.]]}}, sendto = {{id = "sleepy", onlyif = Time == "Evening"}, {id = "normal"}}},
{id = "sleepy", texts = {{text = [[It's getting late.`You're having trouble reopening your eyelids...]]}}},
{id = "sleepy", texts = {{text = [[Behind your closed eyes, a figure appears to you.`]] ..
	P("kummitus", {he = "He holds out his hand ", she = "She holds out her hand ", they = "They hold out their hand ", it = "It holds out its hand "}) ..
	[[in offering.`]]}, {text = [[You hear whispers of comfort and rest...`]], style = {"emphasis1"}},
	{text = [[Take hand`]], click = {{id = "yessleep"}}},
	{text = [[Do not`]], click = {{id = "nosleep"}}},
}},

{id = "nosleep", texts = {{text = [[With some effort, you turn away and dispel the figure from your mind.`]]}, {text = [[You'll stay up a bit longer.]], style = {"red"}}}, passtime = 1},
{id = "nosleep", bookmarkreturn = 1},

{id = "yessleep", texts = {{text = [[You reach out carefully to take the figure's hand.`Despite the ghostly appearance, ]] .. P("kummitus", "THEIR") .. [[ touch is surprisingly warm.]]}}, sendto = {{id = "sleepy"}}},

{id = "sleepy", texts = {{text = [[. . . . .`Time has passed.]], style = {"info"}}}},
{id = "sleepy", passtime = 99, bookmarkreturn = 1},

{id = "normal", texts = {{text = [[When you reopen your eyes, the world around you has changed.`]]}, {text = [[Time has passed.]], style = {"info"}}}, passtime = 1},
{bookmarkreturn = 1},

}