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
	{text = [[`Back]], click = {{id = "main", line = 1}}}
}},

{id = "cute", texts = {
	{text = [[Cute damage is simple, but very effective.`On hit, each point of Cute damage on a projectile grants ]]}, {text = [[+1% crit chance.]], style = {"cute"}},
	{text = [[`Back]], click = {{id = "dmg", line = 1}}}
}},

{id = "charming", texts = {
	{text = [[Charming damage excels when combined with other damage types.`On hit, each point of Charming damage will increase your ]] ..
		ModSettingGet("noiting_simulator.crush_name") .. [['s non-Charming damage multipliers by ]]}, {text = [[1% of their base values.]], style = {"charming"}},
	{text = [[`This caps at ]]}, {text = [[+100%.]], style = {"charming"}},
	{text = [[`Dealing non-Charming damage will decrease this boost by the same amount.]]},
	{text = [[`Back]], click = {{id = "dmg", line = 1}}}
}},

{id = "clever", texts = {
	{text = [[Clever damage is useful if you just need some time to think.`On hit, Clever damage will ]]}, {text = [[decrease the TEMPO of the encounter]], style = {"clever"}}, {text = [[, rather than increasing it.]]},
	{text = [[`However, the TEMPO will then ]]}, {text = [[increase slightly faster]], style = {"clever"}}, {text = [[ until it reaches its normal value again.]]},
	{text = [[`Back]], click = {{id = "dmg", line = 1}}}
}},

{id = "comedic", texts = {
	{text = [[Comedic damage is the embodiment of risk and reward.`On hit, Comedic damage will ]]}, {text = [[heal you]], style = {"comedic"}}, {text = [[ for ]] .. GlobalsGetValue("COMEDIC_HEAL_FACTOR", "0.5") .. [[x the damage dealt.]]},
	{text = [[`If you miss a Comedic projectile, though, you will instead ]]}, {text = [[take damage]], style = {"red"}}, {text = [[ for ]] .. GlobalsGetValue("COMEDIC_HURT_FACTOR", "0.5") .. [[x the damage dealt.]]},
	{text = [[`Be careful!!]]},
	{text = [[`Back]], click = {{id = "dmg", line = 1}}}
}},

{id = "back", purgetips = 1},

}