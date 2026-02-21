local ITEMS = {
	["firestone"] = {},
	["thunderstone"] = {},
	["waterstone"] = {},
	["stonestone"] = {},
	["poopstone"] = {},
	["gourd"] = {},
	["roofkey"] = {},
	["medickey"] = {},
}
for i, j in pairs(ITEMS) do
	ITEMS[i].name = "$ns_name_" .. i
	ITEMS[i].desc = "$ns_desc_" .. i
	ITEMS[i].sprite = "mods/noiting_simulator/files/items/" .. i .. ".png"
	ITEMS[i].inhand = "mods/noiting_simulator/files/items/" .. i .. "_small.png"
end
function SpawnItem(id)

end