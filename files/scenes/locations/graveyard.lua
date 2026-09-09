SCENE = {

{id = "main", texts = {{text = [[You carefully unlock the gate with the key and set it aside.`Beyond the gate, large trees overhead block the sunlight from seeping through.`Despite everything, there's a strange serenity to this place...]]}}, onlyif = not Data.firstentry_graveyard, data = "firstentry_graveyard"},
{id = "main", location = "graveyard", texts = {{text = [[You're in the Graveyard.`]], style = {"location"}},

{navigator = {
	up = {id = "plaza"},
}}}}

}