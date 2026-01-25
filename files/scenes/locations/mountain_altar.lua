SCENE = {

{id = "main", texts = {{text = [[You're on the Mountain Altar.`]], style = {"location"}},
{text = [[The morning air blows coolly around you.]], onlyif = Time == "Morning"},
{text = [[The sun glares gently across the landscape.]], onlyif = Time == "Midday"},
{text = [[The day's warmth is beginning to fade away.]], onlyif = Time == "Evening"},
{text = [[You find yourself distracted by the stars that peek between the clouds.]], onlyif = Time == "Night"},
{text = [[A sense of weariness overtakes you.]], onlyif = Time == "Midnight"},
}},

}