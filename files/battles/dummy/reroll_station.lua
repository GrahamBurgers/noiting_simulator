local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local _, y = EntityGetTransform(me)

if ComponentGetValue2(this, "mTimesExecuted") == 0 then
	local function addcost(entity, cost)
		local textwidth = 0
		local offsetx = 0
		local textcost = tostring(cost)

		for j=1,#textcost do
			local l = string.sub(textcost, j, j)
			textwidth = textwidth + (l == "1" and 3 or 6)
		end

		offsetx = textwidth * 0.5 - 0.5

		EntityAddComponent2(entity, "ItemCostComponent", {
			cost=cost
		})
		EntityAddComponent2(entity, "SpriteComponent", {
			_tags="shop_cost,enabled_in_world",
			image_file="data/fonts/font_pixel_white.xml",
			is_text_sprite=true,
			offset_x=offsetx,
			offset_y=entity == me and 35 or 25,
			update_transform=true,
			update_transform_rotation=false,
			text=textcost,
			z_index=-1
		})
	end

	local wands = EntityGetWithTag("wand")
	for i = 1, #wands do
		if EntityGetFirstComponent(wands[i], "ItemCostComponent") then
			EntityKill(wands[i])
			local wands_generated = tonumber(GlobalsGetValue("NS_WANDS_GENERATED2", "0")) or 0
			GlobalsSetValue("NS_WANDS_GENERATED2", tostring(wands_generated + 1))
			local x = EntityGetTransform(wands[i])

			SetRandomSeed(wands_generated + x, wands_generated + x)
			dofile("mods/noiting_simulator/files/wands/_list.lua")
			local id = Wand_list[Random(1, #Wand_list)].id
			local wand, cost = Generate_wand(id, x, y - 4)
			addcost(wand, math.ceil(cost))
		end
	end

	addcost(me, 100)
end

local kill_me = true
local wands = EntityGetWithTag("wand")
for i = 1, #wands do
	if EntityGetFirstComponent(wands[i], "ItemCostComponent") then
		kill_me = false
	end
end
if kill_me then
	EntityRemoveComponent(me, EntityGetFirstComponent(me, "ItemComponent") or 0)
	EntityRemoveComponent(me, EntityGetFirstComponent(me, "ItemCostComponent") or 0)
	EntityRemoveComponent(me, EntityGetFirstComponent(me, "SpriteComponent", "shop_cost") or 0)
	EntityRemoveComponent(me, this)
end