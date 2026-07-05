local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local _, y = EntityGetTransform(me)

if not EntityHasTag(me, "reroll_init") then
	EntityAddTag(me, "reroll_init")
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
			local valid = false
			local data
			local j = 0

			while not valid do
				valid = true
				data = Wand_list[Random(1, #Wand_list)]
				if data.id == "oldreliable" then
					valid = false
				end
				j = j + 1
				if j > 10000 then
					print("WAND PANIC!")
					valid = true
				end
			end
			local wand, cost = Generate_wand(data.id, x, y - 4)
			if Random(1, 8) == 1 then
				cost = cost / 2
				EntityAddComponent2(wand, "SpriteComponent", {
					image_file="data/ui_gfx/sale_indicator.png",
					offset_x=6,
					offset_y=8,
					update_transform=true,
					update_transform_rotation=false,
					z_index=-1,
					has_special_scale=true,
					special_scale_x=0.75,
					special_scale_y=0.75,
				})
			end
			addcost(wand, math.ceil(cost))
		end
	end

	addcost(me, 100)
end

local shop_wands_left = 0
local wands = EntityGetWithTag("wand") or {}
for i = 1, #wands do
	if EntityGetFirstComponent(wands[i], "ItemCostComponent") then
		shop_wands_left = shop_wands_left + 1
	end
end
dofile_once("mods/noiting_simulator/files/scripts/gui_feed.lua")
if shop_wands_left == 3 then
	CallFeedMessage("first_wand")
elseif shop_wands_left == 2 then
	CallFeedMessage("second_wand")
elseif shop_wands_left == 0 then
	EntityRemoveComponent(me, EntityGetFirstComponent(me, "ItemComponent") or 0)
	EntityRemoveComponent(me, EntityGetFirstComponent(me, "ItemCostComponent") or 0)
	EntityRemoveComponent(me, EntityGetFirstComponent(me, "SpriteComponent", "shop_cost") or 0)
	EntityRemoveComponent(me, this)
end