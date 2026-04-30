SCENE = {
{id = "main", texts = {
	{text = [[Welcome to the Tips List.]], forcetickrate = 2},
	{text = [[`Damage Types]], click = {{id = "dmg"}}, forcetickrate = 2},
	{text = [[`Exit]], click = {{id = "back"}}, forcetickrate = 2}
}},

{id = "dmg", texts = {
	{text = [[There are 4 main damage types:]]},
	{text = [[`Cute]], click = {{id = "cute"}}, style = {"cute"}},
	{text = [[`Charming]], click = {{id = "charming"}}, style = {"charming"}},
	{text = [[`Clever]], click = {{id = "clever"}}, style = {"clever"}},
	{text = [[`Comedic]], click = {{id = "comedic"}}, style = {"comedic"}},
	{text = [[`... and ]]}, {text = [[Colorless.]], click = {{id = "typeless"}}, style = {"typeless"}},
	{text = [[`Back]], click = {{id = "main", line = 1}}}
}},

{id = "cute", texts = {
	{text = [[Cute damage is simple, but very effective.`Each point of Cute damage on a projectile grants +1% crit chance.]]},
	{text = [[`Back]], click = {{id = "dmg", line = 1}}}
}},

{id = "charming", texts = {
	{text = [[Charming damage excels when used with other damage types.`Each point of Charming damage on a projectile grants +1% crit chance.]]},
	{text = [[`Back]], click = {{id = "dmg", line = 1}}}
}},

{id = "back", purgetips = 1},

}