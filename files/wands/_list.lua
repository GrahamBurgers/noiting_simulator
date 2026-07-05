--[[
dofile("mods/noiting_simulator/files/wands/_list.lua")
local x, y = EntityGetTransform(EntityGetWithTag("player_unit")[1])
Generate_wand("lovelove", x, y)

local x, y = EntityGetTransform(EntityGetWithTag("player_unit")[1])
local wands = {"pawn", "rook", "knight", "bishop", "queen", "king", "bishop", "knight", "rook", "pawn"}
for i = 1, #wands do
	dofile("mods/noiting_simulator/files/wands/_list.lua")
	Generate_wand(wands[i], x, y)
	x = x + 20
end
]]--
if GameGetFrameNum() <= 0 then
	function SetRandomSeed(x, y) return 0 end
	function Random(x, y) return 0 end
end
local function rand(min, max)
	local scale = 1000
	local wands_generated = tonumber(GlobalsGetValue("NS_WANDS_GENERATED", "0")) or 0
	SetRandomSeed(wands_generated, wands_generated)
	return Random(min * scale, max * scale) / scale
end
local base = {
	name = "Wand",

	sprite = "handgun.png",
	inhand_sprite = "handgun.png",
	hold_pos_x=0.15,
	hold_pos_y=0.5,
	shuffle = false,
	price = 15,

	preferred_category   = nil,
	prefer_cat_chance = 0.25,
	always_cast_chances  = 0.1,
	always_casts         = {},
	shuffle_curve        = {0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 1.0, 1.1, 1.25},
	capacity             = rand(4, 7),
	spells_per_cast      = rand(0.1, 0.2), -- percentage of wand capacity
	how_many_spells      = rand(0.1, 0.8), -- percentage of wand capacity
	speed_multiplier     = rand(0.9, 1.2),
	mana_regen           = rand(1, 10),
	mana_max             = rand(20, 40),
	cast_delay_frames    = rand(10, 20),
	reload_frames        = rand(45, 60),
}
Wand_list = {
	{
		id = "pawn", name = "Pawn", sprite = "pawn.png", set = "chess",

		price               = base.price * 0.5,
		always_casts        = {{id = "NS_CHECKMATE", chance = 0.1}},
		capacity            = base.capacity * 0.5,
	},
	{
		id = "rook", name = "Rook", sprite = "rook.png", set = "chess",

		always_casts        = {{id = "NS_CHECKMATE", chance = 0.1}},
		capacity            = base.capacity * 1.5,
	},
	{
		id = "knight", name = "Knight", sprite = "knight.png", set = "chess",

		always_casts        = {{id = "NS_CHECKMATE", chance = 0.1}},
		how_many_spells     = base.how_many_spells * 2,
		cast_delay_frames   = base.cast_delay_frames * 2,
	},
	{
		id = "bishop", name = "Bishop", sprite = "bishop.png", set = "chess",

		always_casts        = {{id = "NS_CHECKMATE", chance = 0.1}},
		spells_per_cast     = base.spells_per_cast * 1.5,
		cast_delay_frames   = base.cast_delay_frames * 0.5,
		reload_frames       = base.reload_frames * 0.5,
	},
	{
		id = "queen", name = "Queen", sprite = "queen.png", set = "chess",

		price               = base.price * 2,
		always_casts        = {{id = "NS_CHECKMATE", chance = 0.1}},
		capacity            = base.capacity * 1.25,
		spells_per_cast     = base.spells_per_cast * 1.25,
		how_many_spells     = base.how_many_spells * 1.25,
		speed_multiplier    = base.speed_multiplier * 1.25,
		mana_regen          = base.mana_regen * 1.25,
		mana_max            = base.mana_max * 1.25,
		cast_delay_frames   = base.cast_delay_frames * 0.75,
		reload_frames       = base.reload_frames * 0.75,
	},
	{
		id = "king", name = "King", sprite = "king.png", set = "chess",

		price               = base.price * 1.5,
		always_casts        = {{id = "NS_CHECKMATE", chance = 0.25}},
		mana_regen          = base.mana_regen * 2,
		mana_max            = base.mana_max * 2,
		reload_frames       = base.reload_frames * 1.5,
	},
	{
		id = "starrod", name = "Star Rod", sprite = "starrod.png", set = "kirby",

		preferred_category  = "CHARMING",
		always_casts        = {{id = "NS_CHERISH", chance = 0.1}},
		speed_multiplier    = base.speed_multiplier * 1.25,
	},
	{
		id = "lovelove", name = "Love-Love Stick", sprite = "lovelove.png", inhand_sprite = "lovelove_anim.xml", set = "kirby",

		preferred_category  = "CUTE",
		always_casts        = {{id = "NS_CHERISH", chance = 0.1}},
		speed_multiplier    = base.speed_multiplier * 0.75,
	},
	{
		id = "candyheart", name = "Candy Heart", sprite = "candyheart.png", set = "familiar",

		always_casts        = {{id = "NS_SUGAR", chance = 0.1}},
		capacity            = base.capacity * 0.75,
		cast_delay_frames   = base.reload_frames * 0.5,
	},
	{
		id = "glue", name = "Glue Stick", sprite = "glue.png", set = "familiar",

		preferred_category  = "CLEVER",
		price               = base.price * 0.75,
		always_casts        = {{id = "NS_ENTICE", chance = 0.1}},
		speed_multiplier    = base.speed_multiplier * 0.5,
		cast_delay_frames   = base.cast_delay_frames * 0.5,
	},
	{
		-- panic wand if you enter with no damage
		id = "oldreliable", name = "Ol' Reliable", sprite = "oldreliable.png", set = "familiar",

		ignore_rarity       = true,
		always_cast_chances = 0,
		preferred_category  = "TYPELESS",
		prefer_cat_chance   = 1,
		shuffle_curve       = {1, 1, 1, 1, 1, 1, 1, 1, 1},
		capacity            = 1,
		how_many_spells     = 1,

		spells_per_cast      = 1,
		speed_multiplier     = 1,
		mana_regen           = 8,
		mana_max             = 50,
		cast_delay_frames    = 0,
		reload_frames        = 18,
	},
	{
		id = "friendwand", name = "Friend Wand", sprite = "friendwand.png", set = "lucid",

		always_casts        = {{id = "NS_FRIENDLINESS", chance = 0.1}},
		spells_per_cast     = base.spells_per_cast * 1.5,
	},
	{
		id = "ballwand", name = "Ball Wand", sprite = "ballwand.png", set = "lucid",

		always_casts        = {{id = "NS_CARVER", chance = 0.1}},
		capacity            = base.capacity * 1.25,
		mana_regen          = base.mana_regen * 1.25,
	},
	{
		id = "hatewand", name = "Hate Wand", sprite = "hatewand.png", set = "lucid",

		always_casts        = {{id = "NS_CLEVER2", chance = 0.1}},
		capacity            = base.capacity * 1.25,
		mana_max            = base.mana_max * 1.5,
	},
	{
		id = "barehands", name = "Bare Hands", sprite = "barehands.png", set = "original",

		price               = base.price * 0.25,
		speed_multiplier    = base.speed_multiplier * 0.75,
		capacity            = base.capacity * 0.25,
		cast_delay_frames   = base.cast_delay_frames * 0.5,
		reload_frames       = base.reload_frames * 0.5,
		mana_regen          = base.mana_regen * 0.25,
		mana_max            = base.mana_max * 0.25,
	},
	{
		id = "pencil", name = "Pencil", sprite = "pencil.png", set = "writing",

		always_casts        = {{id = "NS_LETTER", chance = 0.1}},
		price               = base.price * 1.25,
	},
	{
		id = "pen", name = "Pen", sprite = "pen.png", set = "writing",

		always_casts        = {{id = "NS_LETTER", chance = 0.1}},
		price               = base.price * 1.5,
	},
}

Rarities = {500, 300, 100, 25}
function Choose_random_spell(type, is_always_cast, not_an_activate, preferred_category, prefer_cat_chance, ignore_rarity)
	local spells_generated = tonumber(GlobalsGetValue("NS_SPELLS_GENERATED", "0")) or 0
	GlobalsSetValue("NS_SPELLS_GENERATED", tostring(spells_generated + 1))
	SetRandomSeed(spells_generated, spells_generated)

	local target_rarity = Random(1, Rarities[1] + Rarities[2] + Rarities[3] + Rarities[4])
	if     target_rarity <= Rarities[1] then target_rarity = 1
	elseif target_rarity <= Rarities[1] + Rarities[2] then target_rarity = 2
	elseif target_rarity <= Rarities[1] + Rarities[2] + Rarities[3] then target_rarity = 3
	else target_rarity = 4 end

	dofile_once("mods/noiting_simulator/files/spells/__gun_actions.lua")
	local spell = {}
	local valid = false
	local i = 0
	while not valid do
		valid = true
		spell = actions[Random(1, #actions)]

		if (
			(not_an_activate and spell.type == ACTION_TYPE_ACTIVATE) or -- don't put more than one activate spell on the same wand
			(type ~= nil and (spell.type ~= type)) or -- forced type
			(not ignore_rarity and spell.rarity ~= target_rarity) or -- rarity randomness
			(preferred_category and preferred_category ~= spell.ns_category and Random(1, 1000) <= prefer_cat_chance * 1000) or -- cute/charming/clever/comedic randomness
			(is_always_cast and (spell.max_uses and spell.max_uses > 0)) -- don't put limited-charge as always casts
		)
		then valid = false end
		i = i + 1
		if i > 10000 then
			print("SPELL PANIC!")
			valid = true
		end
	end
	return spell
end

function Generate_wand(id, x, y)
	local wands_generated = tonumber(GlobalsGetValue("NS_WANDS_GENERATED", "0")) or 0
	GlobalsSetValue("NS_WANDS_GENERATED", tostring(wands_generated + 1))
	SetRandomSeed(x + wands_generated, y + wands_generated)

	local wand_list = Wand_list
	local wand = wand_list[1]
	for i = 1, #wand_list do
		if wand_list[i].id == id then
			wand = wand_list[i]
			break
		end
	end
	local shuffle_curve = wand.shuffle_curve or base.shuffle_curve
	local shuffle = {}
	while #shuffle_curve > 0 do
		local num = Random(1, #shuffle_curve)
		shuffle[#shuffle+1] = shuffle_curve[num]
		table.remove(shuffle_curve, num)
	end

	wand.name              = wand.name or base.name
	wand.shuffle           = wand.shuffle or base.shuffle
	wand.capacity          = math.max(1, shuffle[1] * (wand.capacity or base.capacity))
	wand.spells_per_cast   = math.min(wand.capacity, math.max(1, shuffle[2] * (wand.spells_per_cast or base.spells_per_cast) * wand.capacity))
	wand.how_many_spells   = math.max(1, math.min(wand.capacity, shuffle[3] * (wand.how_many_spells or base.how_many_spells) * wand.capacity))
	wand.speed_multiplier  = shuffle[4] * (wand.speed_multiplier or base.speed_multiplier)
	wand.mana_regen        = shuffle[5] * (wand.mana_regen or base.mana_regen)
	wand.mana_max          = shuffle[6] * (wand.mana_max or base.mana_max)
	wand.cast_delay_frames = (2 - shuffle[7]) * (wand.cast_delay_frames or base.cast_delay_frames)
	wand.reload_frames     = (2 - shuffle[8]) * (wand.reload_frames or base.reload_frames)
	wand.price             = (2 - shuffle[9]) * (wand.price or base.price)

	wand.image_file  = "mods/noiting_simulator/files/wands/" .. (wand.inhand_sprite or wand.sprite or base.sprite)
	wand.inhand_file = "mods/noiting_simulator/files/wands/" .. (wand.sprite or wand.inhand_sprite or base.sprite)

	wand.hold_pos_x = wand.hold_pos_x or base.hold_pos_x
	wand.hold_pos_y = wand.hold_pos_y or base.hold_pos_y

	wand.always_casts = wand.always_casts or base.always_casts
	wand.always_cast_chances = wand.always_cast_chances or base.always_cast_chances
	wand.preferred_category = wand.preferred_category or base.preferred_category
	wand.prefer_cat_chance = wand.prefer_cat_chance or base.prefer_cat_chance
	wand.ignore_rarity = wand.ignore_rarity or base.ignore_rarity

	local rarity_cost = {2, 4, 10, 30, 0}
	local max_rarity = 0
	local has_projectile = false
	local has_activate = false
	local always_cast_roll = Random(1, 1000)
	while always_cast_roll <= wand.always_cast_chances * 1000 do
		local spell = Choose_random_spell(nil, true, has_activate, wand.preferred_category, wand.prefer_cat_chance, wand.ignore_rarity)
		wand.price = wand.price + rarity_cost[spell.rarity]
		max_rarity = math.max(max_rarity, spell.rarity)
		if spell.type == ACTION_TYPE_ACTIVATE then has_activate = true end
		wand.always_casts[#wand.always_casts+1] = {id = spell.id, chance = 1}
		always_cast_roll = Random(1, 1000)
	end

	wand.capacity = math.max(wand.capacity, 1 + #wand.always_casts)

	local entity = EntityLoad("mods/noiting_simulator/files/wands/_wand.xml", x, y)

	local spells_in_wand = 0
	for i = 1, #wand.always_casts do
		if spells_in_wand > wand.capacity then break end
		if Random(1, 1000) <= wand.always_casts[i].chance * 1000 then
			local action_entity_id = CreateItemActionEntity(wand.always_casts[i].id)
			if action_entity_id then
				EntityAddChild(entity, action_entity_id)
				EntitySetComponentsWithTagEnabled(action_entity_id, "enabled_in_world", false)
				local item = EntityGetFirstComponentIncludingDisabled(action_entity_id, "ItemComponent")
				if item then ComponentSetValue2(item, "permanently_attached", true) end
			end
			spells_in_wand = spells_in_wand + 1
		end
	end

	for i = 1, wand.how_many_spells do
		if spells_in_wand > wand.capacity then break end
		local type = nil
		if (i + 1 > wand.how_many_spells) or (spells_in_wand + 1 > wand.capacity) and not has_projectile then
			-- make sure the wand has at least one projectile
			type = ACTION_TYPE_PROJECTILE
		end
		local spell = Choose_random_spell(type, true, has_activate, wand.preferred_category, wand.prefer_cat_chance, wand.ignore_rarity)
		wand.price = wand.price + rarity_cost[spell.rarity]
		max_rarity = math.max(max_rarity, spell.rarity)
		if spell.type == ACTION_TYPE_PROJECTILE then has_projectile = true end
		if spell.type == ACTION_TYPE_ACTIVATE then has_activate = true end
		local action_entity_id = CreateItemActionEntity(spell.id)
		if action_entity_id then
			EntityAddChild(entity, action_entity_id)
			EntitySetComponentsWithTagEnabled(action_entity_id, "enabled_in_world", false)
		end
		spells_in_wand = spells_in_wand + 1
	end

	local gui = GuiCreate()
	local w, h = GuiGetImageDimensions(gui, wand.inhand_file)
	GuiDestroy(gui)

	local sprite = EntityGetFirstComponent(entity, "SpriteComponent")
	if sprite then
		ComponentSetValue2(sprite, "image_file", wand.image_file)
		ComponentSetValue2(sprite, "offset_x", w * wand.hold_pos_x)
		ComponentSetValue2(sprite, "offset_y", h * wand.hold_pos_y)
		EntityRefreshSprite(entity, sprite)
	end

	if max_rarity > 0 and max_rarity <= 5 then
		EntityAddComponent2(entity, "SpriteComponent", {
			image_file="mods/noiting_simulator/files/wands/wand_glow_" .. tostring(max_rarity) .. ".png",
			offset_x=16 - h,
			offset_y=16,
			additive=true,
			alpha=0.35,
			has_special_scale=true,
			special_scale_x=0.85,
			special_scale_y=0.85,
		})
	end

	EntityAddComponent2(entity, "LuaComponent", {
		_enabled=false,
		_tags="enabled_in_inventory",
		remove_after_executed=true,
		script_source_file="mods/noiting_simulator/files/wands/_wand_first_pickup.lua"
	})

	local item = EntityGetFirstComponent(entity, "ItemComponent")
	if item then
		ComponentSetValue2(item, "item_name", wand.name)
		ComponentSetValue2(item, "always_use_item_name_in_ui", true)
		ComponentSetValue2(item, "play_hover_animation", true)
	end

	local hotspot = EntityGetFirstComponent(entity, "HotspotComponent")
	if hotspot then
		ComponentSetValue2(hotspot, "offset", w * (1 - wand.hold_pos_x), 0)
	end

	local ability = EntityGetFirstComponent(entity, "AbilityComponent")
	if ability then
		ComponentSetValue2(ability, "mana_charge_speed", wand.mana_regen)
		ComponentSetValue2(ability, "mana_max", wand.mana_max)
		ComponentSetValue2(ability, "ui_name", wand.name)
		ComponentSetValue2(ability, "sprite_file", wand.inhand_file)
		ComponentObjectSetValue2(ability, "gun_config", "deck_capacity", wand.capacity)
		ComponentObjectSetValue2(ability, "gun_config", "reload_time", wand.reload_frames)
		ComponentObjectSetValue2(ability, "gun_config", "shuffle_deck_when_empty", wand.shuffle)
		ComponentObjectSetValue2(ability, "gun_config", "actions_per_round", wand.spells_per_cast)
		ComponentObjectSetValue2(ability, "gunaction_config", "fire_rate_wait", wand.cast_delay_frames)
	end

	return entity, wand.price
end