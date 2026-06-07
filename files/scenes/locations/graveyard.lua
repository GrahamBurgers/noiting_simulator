SCENE = {

{id = "main", texts = {{text = [[You carefully unlock the gate with the key and set it aside.`Beyond the gate, large trees overhead are blocking any sunlight from seeping through.`Even the grass seems dead around here...]]}}, onlyif = not Data.firstentry_graveyard, data = {{set = {firstentry_graveyard = true}}}},
{id = "main", location = "graveyard", texts = {{text = [[You're in the Graveyard.`]], style = {"location"}},
}}

}