local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua")
local child = EntityGetWithName("ns_text_handler")
local this = EntityGetFirstComponentIncludingDisabled(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local player, px, py, cc, invgui, chdata, inv2, wallet, dmg = nil, 0, 0, 0, 0, 0, 0, 0, 0
PIXEL_FONT = "mods/noiting_simulator/files/gui/fonts/font_pixel_noshadow.xml"
local bookmark_path = "NS_BOOKMARKS"
local img_shrink_pixels = 4

Gui1 = Gui1 or GuiCreate()

function RecalcPlayer()
    player = nil
    local players = EntityGetWithTag("player_unit") or {}
    if #players > 0 then
        player = players[1]
        px, py = EntityGetTransform(player)
        cc = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent") or 0
        invgui = EntityGetFirstComponentIncludingDisabled(player, "InventoryGuiComponent") or 0
        chdata = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent") or 0
        inv2 = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component") or 0
        wallet = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent") or 0
        dmg = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent") or 0
    end
    print("RECALC PLAYER")
end
RecalcPlayer()

function RecalcSettings()
    MAX_LINES = 99 -- ModSettingGet("noiting_simulator.max_lines")
    SHADOW_OFFSET = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_offset"))
    DEFAULT_FONT = tostring(ModSettingGetNextValue("noiting_simulator.font"))
    DEFAULT_SIZE = tonumber(ModSettingGetNextValue("noiting_simulator.text_size"))
    DEFAULT_TICKRATE = math.floor(tonumber(ModSettingGetNextValue("noiting_simulator.speed")) or 2)
    LINE_SPACING = DEFAULT_SIZE * ModSettingGetNextValue("noiting_simulator.line_spacing")
    SHADOWDARK = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_darkness"))
    FONT = DEFAULT_FONT
    TEXT_SIZE = DEFAULT_SIZE
    TICKRATE = DEFAULT_TICKRATE
    GUI_SCALE = tonumber(ModSettingGetNextValue("noiting_simulator.ui_scale")) or 2
    print("RECALC SETTINGS")
end
RecalcSettings()

Margin = 4

function RecalcScreen()
    SCREEN_W, SCREEN_H = GuiGetScreenDimensions(Gui1)
    LONGEST_WIDTH = (SCREEN_W * 0.8)
    LONGEST_HEIGHT = (SCREEN_H * 0.4)
    BW, BH = LONGEST_WIDTH, LONGEST_HEIGHT
    BX, BY = (SCREEN_W * 0.5) - (BW * 0.5), (SCREEN_H * 1) - BH - Margin
    BX_DEFAULT, BY_DEFAULT = BX, BY
    print("RECALC SCREEN")
end
RecalcScreen()

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui1, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE, LINE_SPACING, FONT)
    return w
end

---@param text string
---@return number
local function heightof(text)
    local w, h = GuiGetTextDimensions(Gui1, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE, LINE_SPACING, FONT)
    return h
end

---@param input table
---@param add any
-- Adds a thing to a table unless it already exists, also turns nil into {}
local function addToTable(input, add)
    input = input or {}
    local go = true
    for i = 1, #input do
        if input[i] == add then
            go = false
        end
    end
    if go then
        input[#input+1] = add
    end
    return input
end

--[[ scrapped overworld
local player2 = EntityGetWithName("ns_player_overworld")
local vs = EntityGetFirstComponent(player2, "VariableStorageComponent")
function LockPlayer(bool)
    if vs then ComponentSetValue2(vs, "value_bool", bool) end
end
]]--

function NewLine(serialized)
    -- remove lines that are too old
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local age = ComponentGetValue2(comps[i], "value_float")
        ComponentSetValue2(comps[i], "value_float", age + 1)
        if age > MAX_LINES then
            EntityRemoveComponent(child, comps[1])
        elseif age == MAX_LINES then
            local current = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
            current["full"] = "[...]"
            current["texts"] = {{text = "[...]", style = {"white", "grey"}}}
            ComponentSetValue2(comps[i], "value_string", smallfolk.dumps(current))
        end
    end
    EntityAddComponent2(child, "VariableStorageComponent", {
        _tags="noiting_sim_line",
        value_string=serialized,
        name="",
        value_float=1,
    })
end

---@return string file
---@return number line
function GetScene()
    local file = ComponentGetValue2(this, "script_inhaled_material")
    local line = tonumber(ComponentGetValue2(this, "script_throw_item")) or 1
    return file, line
end

local function greyLines()
    -- turn previous lines grey when new lines are added
    -- also auto because it should be skipped anyway
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local current = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
        -- current["behavior"] = "auto"
        for j = 1, #current["f"] do
            current["f"][j]["style"] = addToTable(current["f"][j]["style"], "grey")
            current["f"][j]["done"] = (current["f"][j]["done"] or 0) + 1
        end
        ComponentSetValue2(comps[i], "value_string", smallfolk.dumps(current))
    end
end

---@param where table Where to go to, if not next line
function ValidateLine(where)
	print("ValidateLine")
    where = where or {}
    for i = 1, #where do
        if where[i].onlyif ~= false then
            FindLine(where[i])
			return
        end
    end
    FindLine()
end

---@param where table? Where to go to, if not next line
function FindLine(where)
	print("FindLine")
    -- print("FINDING LINE: FILE: " .. tostring(where and where.file):gsub("mods/noiting_simulator/files/scenes", "../scenes") .. ", ID: " .. tostring(where and where.id) .. ", LINE: " .. tostring(where and where.line))
    -- default function for most lines
    local file = (where and where.file) or ComponentGetValue2(this, "script_inhaled_material")
    local line = (where and where.line) or (where and where.file and 1) or tonumber(ComponentGetValue2(this, "script_throw_item")) + 1
    local id = (where and where.id)
    local bookmarks = smallfolk.loads(GlobalsGetValue(bookmark_path, "{}")) or {}
    file = (file:sub(0, 5) ~= "mods/") and ("mods/noiting_simulator/files/scenes/" .. file) or file
	dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
    dofile(file)
    -- print("FINAL: FILE: " .. tostring(file):gsub("mods/noiting_simulator/files/scenes", "../scenes") .. ", ID: " .. tostring(id) .. ", LINE: " .. tostring(line))
    while line <= #SCENE do
		SCENE[line].passtime = SCENE[line].passtime or 0
		for i = 1, SCENE[line].passtime do
			dofile("mods/noiting_simulator/files/scripts/time.lua")
			OnTimePassed()
		end
        if (SCENE[line].onlyif ~= false) and (id == nil or SCENE[line].id == id) then
            if SCENE[line].bookmark then
                table.insert(bookmarks, {file = file, line = line + 1})
                GlobalsSetValue(bookmark_path, smallfolk.dumps(bookmarks))
                ValidateLine(SCENE[line].bookmark)
                return
            elseif SCENE[line].bookmarkreturn then
                local data = {}
                for i = 1, SCENE[line].bookmarkreturn do
                    if bookmarks[#bookmarks] then
                        data = bookmarks[#bookmarks] or data
                        table.remove(bookmarks, #bookmarks)
                    end
                end
                GlobalsSetValue(bookmark_path, smallfolk.dumps(bookmarks))
                FindLine(data)
                return
            else
                SetScene(file, line)
                return
            end
        end
        line = line + 1
    end
end

local function checkforspell(category, req)
	dofile("mods/noiting_simulator/files/spells/__gun_actions.lua")
	local storage = GlobalsGetValue("NS_STORAGE_BOX_SPELLS", "") or ""
	local spellstorage = string.len(storage) > 0 and smallfolk.loads(storage) or {}

	local count = 0
	for i = 1, #actions do
		if actions[i].ns_category == category then
			count = count + (spellstorage[actions[i].id] or 0)
		end
	end
	-- print("CHECK: " .. tostring(category) .. ", FOUND: " .. tostring(count) .. ", REQ: " .. tostring(req))
	return count >= req
end
local function deletespell(category, req)
	local storage = GlobalsGetValue("NS_STORAGE_BOX_DESTROY", "") or ""
	local destroy = string.len(storage) > 0 and smallfolk.loads(storage) or {}

	if GlobalsGetValue("NS_BOX_FREE", "YES") ~= "NO" then
		GlobalsSetValue("NS_STORAGE_BOX_BACKUP", GlobalsGetValue("NS_STORAGE_BOX_SPELLS") or "")
		local cx, cy = tonumber(GlobalsGetValue("NS_CAM_X", "nil")) or 0, tonumber(GlobalsGetValue("NS_CAM_Y", "nil")) or 0
		local entity_interacted = EntityLoad("mods/noiting_simulator/files/spells/storage_box/storage_box.xml", cx, cy + 30)
		local sprite = EntityGetFirstComponentIncludingDisabled(entity_interacted, "SpriteComponent", "box") or 0
		local interact = EntityGetFirstComponentIncludingDisabled(entity_interacted, "InteractableComponent") or 0
		local move = EntityGetFirstComponentIncludingDisabled(entity_interacted, "VelocityComponent") or 0
		GlobalsSetValue("NS_STORAGE_BOX_FRAME", tostring(GameGetFrameNum()))
		GlobalsSetValue("NS_BOX_FREE", "NO")
		ComponentSetValue2(sprite, "rect_animation", "open")
		ComponentSetValue2(interact, "radius", 100000)
		EntityRefreshSprite(entity_interacted, sprite)
		EntitySetComponentIsEnabled(entity_interacted, move, false)
	end
	destroy[category] = (destroy[category] or 0) + req

	GlobalsSetValue("NS_STORAGE_BOX_DESTROY", smallfolk.dumps(destroy))
end

local costs = {
	{id = "staminacost", style = {"stamina"}, img = "mods/noiting_simulator/files/gui/cost_stamina.png", img_apply_style = false,
	-- STAMINA -------------------------------
	checkfunc = function(req)
		dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
		return GetStamina() >= req
	end,
	setfunc = function(req, id)
		dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
		return SubtractStamina(req)
	end},
	{id = "goldcost", style = {"gold"}, img = "mods/noiting_simulator/files/gui/cost_gold.png", img_apply_style = false,
	-- GOLD -------------------------------
	checkfunc = function(req)
		return ComponentGetValue2(wallet, "money") >= req
	end,
	setfunc = function(req, id)
		ComponentSetValue2(wallet, "money", ComponentGetValue2(wallet, "money") - req)
	end},
	-- HEALTH -------------------------------
	{id = "healthcost", style = {"health"}, img = "mods/noiting_simulator/files/gui/cost_health.png", img_apply_style = false,
	checkfunc = function(req)
		return ComponentGetValue2(dmg, "hp") - 0.04 >= req / 25
	end,
	setfunc = function(req, id)
		ComponentSetValue2(dmg, "hp", ComponentGetValue2(dmg, "hp") - req / 25)
	end},
	-- CUTE -------------------------------
	{id = "cutecost", style = {"cute"}, img = "mods/noiting_simulator/files/gui/dmg_cute.png", img_apply_style = true, apply_before = true,
	checkfunc = function(req)
		return checkforspell("CUTE", req)
	end,
	setfunc = function(req, id)
		deletespell("CUTE", req)
		HELDID = id
	end},
	-- CHARMING -------------------------------
	{id = "charmingcost", style = {"charming"}, img = "mods/noiting_simulator/files/gui/dmg_charming.png", img_apply_style = true, apply_before = true,
	checkfunc = function(req)
		return checkforspell("CHARMING", req)
	end,
	setfunc = function(req, id)
		deletespell("CHARMING", req)
		HELDID = id
	end},
	-- CLEVER -------------------------------
	{id = "clevercost", style = {"clever"}, img = "mods/noiting_simulator/files/gui/dmg_clever.png", img_apply_style = true, apply_before = true,
	checkfunc = function(req)
		return checkforspell("CLEVER", req)
	end,
	setfunc = function(req, id)
		deletespell("CLEVER", req)
		HELDID = id
	end},
	-- COMEDIC -------------------------------
	{id = "comediccost", style = {"comedic"}, img = "mods/noiting_simulator/files/gui/dmg_comedic.png", img_apply_style = true, apply_before = true,
	checkfunc = function(req)
		return checkforspell("COMEDIC", req)
	end,
	setfunc = function(req, id)
		deletespell("COMEDIC", req)
		HELDID = id
	end},
	-- TYPELESS -------------------------------
	{id = "typelesscost", style = {"typeless"}, img = "mods/noiting_simulator/files/gui/dmg_typeless.png", img_apply_style = true, apply_before = true,
	checkfunc = function(req)
		return checkforspell("TYPELESS", req)
	end,
	setfunc = function(req, id)
		deletespell("TYPELESS", req)
		HELDID = id
	end},
}

---@param input table Should have a texts field
function AddLines(input)
    local f = {}
    local x, y, line_len = 0, 0, 0

    if input["infunc"] then
        input["infunc"]()
        input["infunc"] = nil
    end
    input["outfunc"] = nil
    if input["battle"] then
        GlobalsSetValue("NS_BATTLE_STATE", "INBATTLE")
        dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
        StartBattle(input["battle"])
        input["texts"] = {{text = [[]]}}
    end
    if input["meet"] then
        ModSettingSet("noiting_simulator.met_" .. input["meet"], true)
        ModSettingSet("noiting_simulator.RELOAD", (ModSettingGet("noiting_simulator.RELOAD") or 0) + 1)
    end
    local defaultwidth, defaultheight = GuiGetTextDimensions(Gui1, " ", DEFAULT_SIZE, LINE_SPACING, FONT)

    local i = 1
    local texts = ""
	local imgadder, imgadder2 = 0, 0
    if input["texts"] then
        greyLines()
        GlobalsSetValue("NS_SCROLL", "0")
        while i <= #input["texts"] do
			local cost = {}
            local text = input["texts"]
			local img = text[i]["img"]
			if img then
				text[i]["text"] = text[i]["text"] or " "
				local imgw, imgh = GuiGetImageDimensions(Gui1, img.path, GUI_SCALE)
				img.scale = img.scale or (defaultheight / (imgh + img_shrink_pixels))
				img.scalew = (img.scalew or img.scale or 1) * GUI_SCALE
				img.scaleh = (img.scaleh or img.scale or 1) * GUI_SCALE
				img.width  = imgw * img.scalew
				img.height = imgh * img.scaleh
				imgadder2 = (img.width / 2) - defaultwidth / 2
			end
            if text and text[i]["text"] then
                text[i]["text"] = text[i]["text"]:gsub("`", "\n"):gsub("\n", " \n "):gsub("\n ", "\n"):gsub(" ", "!S! ")
                texts = ""
                local words = text[i]["text"] or ""
                local style = text[i]["style"] or {"white"}
                local hover = text[i]["hover"]
                local color, name, box
				local character = text[i]["character"]
                if character then
                    for j = 1, #CHARACTERS do
                        if CHARACTERS[j].id == character then
                            color = CHARACTERS[j].color
                            name = CHARACTERS[j].id
							if ModDoesFileExist("mods/noiting_simulator/files/gui/boxes/" .. character .. ".png") then
								box = "mods/noiting_simulator/files/gui/boxes/" .. character .. ".png"
							end
                            break
                        end
                    end
                end
                TEXT_SIZE = DEFAULT_SIZE * (text[i]["size"] or 1)
				cost["reqs_met"] = true
				for j = 1, #costs do
					local source = costs[j]
					if text[i][source.id] then
						cost[source.id] = text[i][source.id]
						cost[source.id .. "go"] = source.checkfunc(text[i][source.id])
						if cost[source.id .. "go"] == false then
							cost["reqs_met"] = false
						end
					end
				end
				local function push_line(trim)
					f[#f+1] = {
						text = trim and texts:gsub('%s*$', '') or texts, style = style,
						x = x - sizeof(texts), y = (y + heightof(texts) / defaultheight),
						hover = hover, size = TEXT_SIZE, forcetickrate = text[i]["forcetickrate"], dontcut = text[i]["dontcut"],
						click = text[i]["click"], character = character,
                        color = color, name = name, img = img, box = box,
						costs = cost,
					}
				end
                for word in words:gmatch("[^ ]+") do
                    word = word:gsub("!S!", " ")
                    local cur_len = sizeof(word)
					line_len = line_len + imgadder
					imgadder = imgadder2
					imgadder2 = 0
                    if line_len + cur_len >= LONGEST_WIDTH or word:find("\n") then
                        -- Start a new line if line is too long or we hit a newline character
						push_line(true)

                        y = y + LINE_SPACING
                        line_len = cur_len
                        texts = word:gsub("\n", "")
                        x = line_len
                    else
                        -- Add a word to the current line
                        line_len = line_len + cur_len
                        texts = texts .. word
                        x = line_len
                    end
                end
				push_line(false)
            end

			local has_cost = false
			local extrai = i
			local function exi()
				extrai = extrai + 1
				return extrai
			end
			for j = 1, #costs do
				local source = costs[j]
				if text[i][source.id] then
					table.insert(input["texts"], exi(), {text = has_cost and "," or " [", style = cost["reqs_met"] and {"white"} or {"red"}})
					table.insert(input["texts"], exi(), {img = {path = source.img, style = source.img_apply_style and source.style}})
					table.insert(input["texts"], exi(), {text = tostring(text[i][source.id]), style = cost[source.id .. "go"] and source.style or {"red"}})
					has_cost = true
				end
			end
			if has_cost then
				table.insert(input["texts"], exi(), {text = "]", style = cost["reqs_met"] and {"white"} or {"red"}})
			end

            x = 0
            i = i + 1
        end
    end

    if (f and #f > 0) then
        NewLine(smallfolk.dumps({f = f, battle = input["battle"]}))
    end
end

---@param file string? Source file for dialogue
---@param line number? Source line in the file
function SetScene(file, line)
    local file2, line2 = GetScene()
    print("SetScene: FILE: " .. (file or "nil"):gsub("mods/noiting_simulator/files/scenes", "../scenes") .. ", LINE: " .. (line or "nil"))
    if file then ComponentSetValue2(this, "script_inhaled_material", file) else file = file2 end
    if line then ComponentSetValue2(this, "script_throw_item", tostring(line)) else line = line2 end
    dofile(file)
    if SCENE and SCENE[line] then
        AddLines(SCENE[line])
    end
end

local emphasis1 = ModSettingGetNextValue("noiting_simulator.color1")
local emphasis2 = ModSettingGetNextValue("noiting_simulator.color2")
local function hue(color)
    color = (color / 360) % 1
    local segment = math.floor(color * 6) + 1
    local progress = (color * 6) % 1

    local things = {
        {1, progress, 0},
        {1 - progress, 1, 0},
        {0, 1, progress},
        {0, 1 - progress, 1},
        {progress, 0, 1},
        {1, 0, 1 - progress}
    }
    return things[segment][1], things[segment][2], things[segment][3], 1
end
local color_presets = {
    -- general
    ["white"]     = function(r2, g2, b2, a2) return 1.00, 1.00, 1.00, 1.00 end,
    ["red"]       = function(r2, g2, b2, a2) return 0.80, 0.00, 0.00, 1.00 end,
    ["green"]     = function(r2, g2, b2, a2) return 0.00, 1.00, 0.40, 1.00 end,
    ["location"]  = function(r2, g2, b2, a2) return 0.55, 0.90, 1.00, 1.00 end,
    ["info"]      = function(r2, g2, b2, a2) return 0.25, 0.45, 0.65, 1.00 end,
    ["interact"]  = function(r2, g2, b2, a2) return 0.10, 0.80, 0.70, 1.00 end,
    ["gold"]      = function(r2, g2, b2, a2) return 0.98, 0.88, 0.49, 1.00 end,
    ["health"]    = function(r2, g2, b2, a2) return 0.87, 0.40, 0.40, 1.00 end,
    ["stamina"]   = function(r2, g2, b2, a2) return 0.23, 0.77, 0.25, 1.00 end,
    ["cute"]      = function(r2, g2, b2, a2) return 0.93, 0.64, 0.94, 1.00 end,
    ["charming"]  = function(r2, g2, b2, a2) return 0.88, 0.81, 0.47, 1.00 end,
    ["clever"]    = function(r2, g2, b2, a2) return 0.64, 0.74, 0.94, 1.00 end,
    ["comedic"]   = function(r2, g2, b2, a2) return 0.47, 0.85, 0.56, 1.00 end,
    ["typeless"]  = function(r2, g2, b2, a2) return 0.60, 0.56, 0.57, 1.00 end,
    ["yellow"]    = function(r2, g2, b2, a2) return 1.00, 1.00, 0.69, 1.00 end, -- closest to the color used by the game for hover
    ["emphasis1"] = function(r2, g2, b2, a2) return hue(emphasis1)         end,
    ["emphasis2"] = function(r2, g2, b2, a2) return hue(emphasis2)         end,
    -- modifiers
    ["grey"]    = function(r2, g2, b2, a2) return r2 * 0.7, g2 * 0.7, b2 * 0.7, a2 end,
    ["shadow"]  = function(r2, g2, b2, a2) return r2 * SHADOWDARK, g2 * SHADOWDARK, b2 * SHADOWDARK, a2 end,
    ["black"]   = function(r2, g2, b2, a2) return r2 * 0.0, g2 * 0.0, b2 * 0.0, a2 end,
    ["invis"]   = function(r2, g2, b2, a2) return 0, 0, 0, -1 end, -- 0 doesn't work for alpha for some reason
}
local function getColors(input, r, g, b, a)
    r, g, b, a = r or 1, g or 1, b or 1, a or 1

    input = input or {"white"}
    for i = 1, #input do
        if color_presets[input[i]] then
            r, g, b, a = color_presets[input[i]](r, g, b, a)
        else
            print("error: no color '" .. input[i] .. "'")
        end
    end

    return
    (r > 1 and 1) or (r < 0 and 0) or r,
    (g > 1 and 1) or (g < 0 and 0) or g,
    (b > 1 and 1) or (b < 0 and 0) or b,
    (a > 1 and 1) or a
end

CANSCROLLUP, CANSCROLLDOWN = false, false
SKIP, NEXT, LEFT, RIGHT, UP, DOWN = 0, 0, 0, 0, 0, 0
BATTLETWEEN = 0
TICKCOUNTER = -1
HELDID = nil

return function()
    if (not cc) or
	(ComponentGetTypeName(cc) ~= "ControlsComponent") or
	(ComponentGetTypeName(invgui) ~= "InventoryGuiComponent") or
	(ComponentGetTypeName(chdata) ~= "CharacterDataComponent") or
	(ComponentGetTypeName(dmg) ~= "DamageModelComponent") or
	(ComponentGetTypeName(wallet) ~= "WalletComponent") or
	(ComponentGetTypeName(inv2) ~= "Inventory2Component") then
        RecalcPlayer()
    end
    if not player then return end
    local inbattle = GlobalsGetValue("NS_IN_BATTLE", "0") == "1"
    if inbattle then
        BATTLETWEEN = BATTLETWEEN + (1 - BATTLETWEEN) / 10
        EntitySetComponentIsEnabled(player, invgui, true)
        EntitySetComponentIsEnabled(player, chdata, true)
		local inv = EntityGetWithName("inventory_quick2")
		if inv and inv > 0 then
			EntitySetName(inv, "inventory_quick")
			local helditem = ComponentGetValue2(inv2, "mActiveItem")
			local ability = helditem and helditem > 0 and EntityGetFirstComponentIncludingDisabled(helditem, "AbilityComponent")
			if ability then
				local mana_max = ComponentGetValue2(ability, "mana_max")
				ComponentSetValue2(ability, "mana_max", -mana_max)
				ComponentSetValue2(ability, "mana", -mana_max)
			end
		end
    else
        BATTLETWEEN = BATTLETWEEN + (0 - BATTLETWEEN) / 10
		ComponentSetValue2(invgui, "mActive", false)
        EntitySetComponentIsEnabled(player, chdata, false)
		local inv = EntityGetWithName("inventory_quick")
		if inv and inv > 0 then
			EntitySetName(inv, "inventory_quick2")
			local helditem = ComponentGetValue2(inv2, "mActiveItem")
			local ability = helditem and helditem > 0 and EntityGetFirstComponentIncludingDisabled(helditem, "AbilityComponent")
			if ability then
				local mana_max = ComponentGetValue2(ability, "mana_max")
				ComponentSetValue2(ability, "mana_max", -mana_max)
				ComponentSetValue2(ability, "mana", -mana_max)
			end
		end
    end
    BY = BY_DEFAULT + ((BH + Margin * 2) * BATTLETWEEN)
    local sw, sh = GuiGetScreenDimensions(Gui1)
    if sw ~= SCREEN_W or sh ~= SCREEN_H then
        RecalcScreen()
        SCREEN_W, SCREEN_H = sw, sh
    end
    if GlobalsGetValue("NS_SETTING_RECALC", "0") == "1" then
        RecalcSettings()
        GlobalsSetValue("NS_SETTING_RECALC", "0")
    end
    local _id = 20
    local function newid()
        _id = _id + 1
        return _id
    end
	local box_is_open = GlobalsGetValue("NS_STORAGE_BOX_FRAME", "0") ~= "0"

    GuiStartFrame(Gui1)
    GuiOptionsAdd(Gui1, 8) -- HandleDoubleClickAsClick; spammable buttons
    local file, line = GetScene()
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    if cc and GameGetFrameNum() % 2 == 0 then
        -- hold to zoooom
        if (ComponentGetValue2(cc, "mButtonDownRight")) and (ComponentGetValue2(cc, "mButtonFrameRight") < GameGetFrameNum() - 30) then
            RIGHT = 1
        end
        if (ComponentGetValue2(cc, "mButtonDownLeft")) and (ComponentGetValue2(cc, "mButtonFrameLeft") < GameGetFrameNum() - 30) then
            LEFT = 1
        end
        if (ComponentGetValue2(cc, "mButtonDownDown")) and (ComponentGetValue2(cc, "mButtonFrameDown") < GameGetFrameNum() - 30) then
            DOWN = 1
        end
        if (ComponentGetValue2(cc, "mButtonDownUp")) and (ComponentGetValue2(cc, "mButtonFrameUp") < GameGetFrameNum() - 30) then
            UP = 1
        end
    end
    local keybinds = {
        ["skip"]  = (not inbattle) and (SKIP  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonDownKick") or ComponentGetValue2(cc, "mButtonDownThrow")) or false)),
        ["next"]  = (not inbattle) and (NEXT  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameInteract") == GameGetFrameNum()) or false)),
        ["left"]  = (not inbattle) and (LEFT  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameLeft") == GameGetFrameNum()))),
        ["right"] = (not inbattle) and (RIGHT > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameRight") == GameGetFrameNum()))),
        ["up"]    = (not inbattle) and (UP    > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameUp") == GameGetFrameNum()))),
        ["down"]  = (not inbattle) and (DOWN  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameDown") == GameGetFrameNum()))),
    }
    SKIP, NEXT, LEFT, RIGHT, UP, DOWN = SKIP - 1, NEXT - 1, LEFT - 1, RIGHT - 1, UP - 1, DOWN - 1

    local done = true
    local tick = math.max(1, TICKRATE)
    LINES = {}
    for i = 1, #comps do
        -- advance the text of only the topmost unfinished line
        local thing = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
        local src = ""
        for j = 1, #thing["f"] do
            src = src .. thing["f"][j]["text"]
        end
        local amount = ComponentGetValue2(comps[i], "value_int")
        local full = utf8.len(src)
        if amount < full then
            if (TICKCOUNTER <= TICKRATE or keybinds["skip"]) then
                if thing["behavior"] == "instant" or keybinds["skip"] then
                    amount = full
                elseif tick > 0 then
                    done = false
                    local reallen = utf8.len(utf8.sub(src, amount + 1, amount + tick))
                    amount = amount + reallen
                    tick = tick - reallen
                    TICKCOUNTER = -1
                end
                ComponentSetValue2(comps[i], "value_int", amount)
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_select", px, py)
            else
                done = false
                TICKCOUNTER = TICKCOUNTER - 1
            end
        end
        LINES[#LINES+1] = {["table"] = thing, ["amount"] = amount}
    end
    -- if we reach the end and not ticked, we know we've reached the end of text
    local character, name, box
    local color = {113, 113, 113, 255}

    GuiZSetForNextWidget(Gui1, 10)
    GuiOptionsAddForNextWidget(Gui1, 9) -- GamepadDefaultWidget
    -- draw container
    local last = #LINES

    local yadd = 0
    local history = tonumber(GlobalsGetValue("NS_HISTORY", "0"))
    local scroll = tonumber(GlobalsGetValue("NS_SCROLL", "0"))
    if done then
        if keybinds["left"] and history + 1 < last then
            history = history + 1
            GlobalsSetValue("NS_HISTORY", tostring(history))
            GlobalsSetValue("NS_SCROLL", "0")
            keybinds["left"] = false
        elseif keybinds["right"] and history > 0 then
            history = history - 1
            GlobalsSetValue("NS_HISTORY", tostring(history))
            GlobalsSetValue("NS_SCROLL", "0")
            scroll = 0
            keybinds["right"] = false
        end
    end

    if CANSCROLLUP and keybinds["up"] then
        scroll = scroll + 1
        GlobalsSetValue("NS_SCROLL", tostring(scroll))
    end
    if CANSCROLLDOWN and keybinds["down"] then
        scroll = scroll - 1
        GlobalsSetValue("NS_SCROLL", tostring(scroll))
    end
    local canscrolluplast, canscrolldownlast = CANSCROLLUP, CANSCROLLDOWN
    CANSCROLLUP, CANSCROLLDOWN = false, false

    local topline_y = BY + LINE_SPACING + Margin
    local bottomline_y = BY + LONGEST_HEIGHT - (LINE_SPACING + Margin)

    local cango = false
    for q = 1, last do
        local f = LINES[q]["table"]["f"] or {}

        -- text rendering
        local charc = LINES[q]["amount"]
        local hasclick = false
        for i = 1, #f do
            if f[i]["click"] then hasclick = true break end
            f[i]["text"] = f[i]["text"]:gsub([[`]], [["]])
        end

        -- behavior
        -- GamePrint("charc: " .. tostring(charc))
        if q == last - history and not box_is_open then
            local lastline = LINES[q]["table"]
            local behavior = lastline["behavior"] or "nextline"
            if done then -- text is done typing, this runs continuously
                -- go to next line if enter pressed
                if history == 0 and not hasclick then
                    if lastline["battle"] then
                        TICKRATE = -1
                        if (GlobalsGetValue("NS_BATTLE_STATE", "0") ~= "INBATTLE") then
                            if SCENE[line]["outfunc"] then SCENE[line]["outfunc"]() end
                            ValidateLine(SCENE[line].sendto)
                        end
                    elseif behavior == "wait" then
                        -- advance when conditional
                        -- can't serialize functions so have to dofile unfortunately
                        dofile(file)
                        TICKRATE = -1
                        if (SCENE[line]["waitfor"] ~= false) then
                            if SCENE[line]["outfunc"] then SCENE[line]["outfunc"]() end
                            ValidateLine(SCENE[line].sendto)
                        end
                    elseif (not canscrolldownlast) or (q < last) then
                        if ((behavior == "nextline" and keybinds["right"]) or behavior == "auto") then
                            -- normal advancement
                            dofile(file)
                            TICKRATE = -1
                            if SCENE[line]["outfunc"] then SCENE[line]["outfunc"]() end
                            ValidateLine(SCENE[line].sendto)
                            GamePlaySound("data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                        else
                            cango = true
                        end
                    end
                end
            end

            --[[debug: gui pointer cursor
            Qx, Qy = Qx or 0, Qy or 0
            local speed = 2
            if InputIsKeyDown(225) or InputIsKeyDown(229) then speed = speed * 2 end
            if InputIsKeyDown(224) or InputIsKeyDown(228) then speed = speed * 0.25 end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownDown") then Qy = Qy + speed end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownUp") then Qy = Qy - speed end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownLeft") then Qx = Qx - speed end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownRight") then Qx = Qx + speed end
            GuiImage(Gui1, newid(), Qx, Qy, "mods/noiting_simulator/files/gui/1px_white.png", 1, 1, 1)
            GuiText(Gui1, Qx, Qy, tostring(Qx) .. ", " .. tostring(Qy), 1, FONT)
            GuiText(Gui1, Qx, Qy + LINE_SPACING, "BX: " .. tostring(BX) .. ", BY: " .. tostring(BY), 1, FONT)
            GuiText(Gui1, Qx, Qy + LINE_SPACING * 2, "BW: " .. tostring(BW) .. ", BH: " .. tostring(BH), 1, FONT)
            ]]--

            for j = 1, #f do
                f[j]["x"] = f[j]["x"] + BX
                f[j]["y"] = f[j]["y"] + BY + Margin / 2 + LINE_SPACING + (scroll * LINE_SPACING)
                local click = f[j]["click"]
                -- Typing animation
                local invis = f[j]["text"]
                if not (f[j]["dontcut"]) then
                    local ocharc = charc
                    f[j]["text"] = utf8.sub(f[j]["text"], 1, charc)
                    charc = charc - utf8.len(f[j]["text"])
                    if charc == 0 and ocharc > 0 and not done then
                        -- this is the text we're currently on
                        TICKRATE = f[j]["forcetickrate"] or DEFAULT_TICKRATE
                        local char = f[j]["text"]:sub(-1)
                        if char == "!" or char == "," or char == "." or char == "-" then
                            TICKRATE = TICKRATE - 15
                        end
                    end
                end
                GuiZSet(Gui1, 8)

                -- Text display
                if (f[j]["done"] or 0) == history then -- display correct text or history if specified
                    character = f[j]["character"] or character
                    color = f[j]["color"] or color
                    name = f[j]["name"] or name
					box = f[j]["box"] or box
                    local wid_x, wid_y = GuiGetTextDimensions(Gui1, f[j]["text"], f[j]["size"], LINE_SPACING, FONT)
                    local toolow = f[j]["y"] + wid_y / 4 + LINE_SPACING / 2 > bottomline_y
                    local toohigh = f[j]["y"] - wid_y / 4 + LINE_SPACING / 2 < topline_y

                    if not (toolow or toohigh) then -- only display if not over lines
                        local r, g, b, a = getColors(f[j]["style"])
                        GuiColorSetForNextWidget(Gui1, r, g, b, a)
                        if click then
                            -- THIS IS CLICKABLE
                            if history ~= 0 then
                                GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
                                r, g, b, a = getColors({"interact", "grey"})
                            else
                                r, g, b, a = getColors({"interact"})
                            end
                            GuiColorSetForNextWidget(Gui1, r, g, b, a)
							if GlobalsGetValue("NS_BOX_FREE", "GOGOGO") == "YES" then
								HELDID = nil
								GlobalsSetValue("NS_BOX_FREE", "GOGOGO")
							end
							local myid = newid()
                            local lmb, rmb = GuiButton(Gui1, myid, f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
                            if lmb or rmb or HELDID == myid then
                                if (HELDID == myid) or (f[j]["clickif"] ~= false and f[j]["costs"]["reqs_met"] ~= false) then -- always true if not specified
									local costful = false
									if not HELDID then
										-- apply the actual costs
										for i = 1, #costs do
											local source = costs[i]
											if f[j]["costs"][source.id] then
												costful = true
												if source.apply_before then source.setfunc(f[j]["costs"][source.id], myid) end
											end
										end
									end
									if GlobalsGetValue("NS_BOX_FREE", "GOGOGO") == "GOGOGO" then
										if HELDID or costful then
											for i = 1, #costs do
												local source = costs[i]
												if f[j]["costs"][source.id] and not source.apply_before then
													source.setfunc(f[j]["costs"][source.id], myid)
													costful = true
												end
											end
											GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/shop_item/create", px, py)
										end
										HELDID = nil
										local data = {}
										for i = 1, #click do
											if click[i].onlyif ~= false then
												data = click[i]
												break
											end
										end
										FindLine(data)
										if rmb then SKIP = 3 end
									end
                                else
                                    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", px, py)
                                end
                            else
                                -- display clicker box
                                GuiZSet(Gui1, 11)
                                local _, _, hover, lx, ly, w, h = GuiGetPreviousWidgetInfo(Gui1)
                                if history == 0 then
                                    if hover and click["clickableif"] ~= false then
                                        r, g, b, a = getColors({"yellow"})
                                    elseif hover then
                                        r, g, b, a = getColors({"red"})
                                    end
                                end

                                local wx, wy = lx, ly + h - (f[j]["size"] * 2)
                                GuiColorSetForNextWidget(Gui1, r, g, b, a)
                                GuiImage(Gui1, newid(), wx, wy, "mods/noiting_simulator/files/gui/1px_white.png", 1, w, f[j]["size"])

                                GuiColorSetForNextWidget(Gui1, getColors({"shadow"}, r, g, b, a))
                                GuiZSet(Gui1, 12)
                                wx, wy = wx + f[j]["size"] * SHADOW_OFFSET, wy + f[j]["size"] * SHADOW_OFFSET
                                GuiImage(Gui1, newid(), wx, wy, "mods/noiting_simulator/files/gui/1px_white.png", 1, w, f[j]["size"])
                            end
                        else
                            -- DEFAULT BEHAVIOR
                            GuiText(Gui1, f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
                            --[[ debug: text alignment bars
                            local _, _, hover = GuiGetPreviousWidgetInfo(Gui1)

                            local alpha = 0.2
                            if hover then GuiColorSetForNextWidget(Gui1, 1, 0.8, 0.8, 1) alpha = 1 else GuiColorSetForNextWidget(Gui1, 1, 0.6, 0.6, 1) end
                            GuiImage(Gui1, newid(), x, f[j]["y"] + wid_y / 4 + LINE_SPACING / 2, "mods/noiting_simulator/files/gui/1px_white.png", alpha, BW, f[j]["size"])
                            if hover then GuiColorSetForNextWidget(Gui1, 0.8, 0.8, 1, 1) alpha = 1 else GuiColorSetForNextWidget(Gui1, 0.6, 0.6, 1, 1) end
                            GuiImage(Gui1, newid(), x, f[j]["y"] - wid_y / 4 + LINE_SPACING / 2, "mods/noiting_simulator/files/gui/1px_white.png", alpha, BW, f[j]["size"])
                            ]]--
                        end

                        -- Hover text (implemented even if we might not use it)
                        -- GuiTooltip(Gui1, tostring(j) .. f[j]["text"], "x: " .. tostring(f[j]["x"]) .. ", y: " .. tostring(f[j]["y"]) .. ", yadd: " .. tostring(yadd))
                        if f[j]["hover"] then
                            GuiTooltip(Gui1, f[j]["hover"], "")
                        end

                        -- Text invis (so box doesn't bump)
                        GuiColorSetForNextWidget(Gui1, getColors({"invis"}))
                        GuiZSet(Gui1, 9)
                        GuiText(Gui1, f[j]["x"], f[j]["y"], invis, f[j]["size"], FONT)

                        -- Text shadow
                        GuiColorSetForNextWidget(Gui1, getColors({"shadow"}, r, g, b, a))
                        GuiZSet(Gui1, 12)
                        GuiText(Gui1, f[j]["x"] + f[j]["size"] * SHADOW_OFFSET, f[j]["y"] + f[j]["size"] * SHADOW_OFFSET, f[j]["text"], f[j]["size"], FONT)
                        yadd = yadd + LINE_SPACING
                        -- y = y + LINE_SPACING

						-- Image (if applicable)
						local img = f[j]["img"]
						if img and utf8.len(f[j]["text"]) > 0 then
							if img.color then
								GuiColorSetForNextWidget(Gui1, img.color[1] or 1, img.color[2] or 1, img.color[3] or 1, img.color[4] or 1)
							end
							if img.style then
								GuiColorSetForNextWidget(Gui1, getColors(img.style))
							end
							GuiImage(Gui1, newid(), f[j]["x"], f[j]["y"] + img_shrink_pixels / 2, img.path, 1, img.scalew, img.scaleh)
						end
                    else
                        if toohigh then CANSCROLLUP = true end
                        if toolow then CANSCROLLDOWN = true end
                    end
                end

            end
        end
    end

    TEXT_SIZE = DEFAULT_SIZE

    local r, g, b, a = color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255

    -- draw black background and box
    GuiZSetForNextWidget(Gui1, 30)
	if box_is_open then
   		GuiZSetForNextWidget(Gui1, 9999)
	end
    GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
	GuiColorSetForNextWidget(Gui1, r, g, b, a)
    GuiImageNinePiece(Gui1, newid(), BX - Margin / 2, BY - Margin / 2, BW + Margin, BH + Margin, 1, box or "mods/noiting_simulator/files/gui/boxes/box.png")

    -- additional box elements

	if not box_is_open then
		GuiColorSetForNextWidget(Gui1, r, g, b, a)
		GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
		GuiImage(Gui1, newid(), BX, bottomline_y - 1, "mods/noiting_simulator/files/gui/boxes/1px_white.png", 1, LONGEST_WIDTH, 1)
		GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
		GuiColorSetForNextWidget(Gui1, r, g, b, a)
		GuiImage(Gui1, newid(), BX, topline_y - 1, "mods/noiting_simulator/files/gui/boxes/1px_white.png", 1, LONGEST_WIDTH, 1)

		local nx, ny = BX + Margin / 2, topline_y
		local w, h = GuiGetTextDimensions(Gui1, "<", TEXT_SIZE * 1.25, LINE_SPACING, FONT)
		local bigw = GuiGetTextDimensions(Gui1, "-1", TEXT_SIZE * 1.25, LINE_SPACING, FONT)
		ny = ny - (h + 1)
		if name then
			for i = 1, #CHARACTERS do
				if CHARACTERS[i].id == name then
					local namew, nameh = GuiGetTextDimensions(Gui1, CHARACTERS[i].displayname, TEXT_SIZE * 1.25, 1, FONT)
					local iconw, iconh = GuiGetImageDimensions(Gui1, CHARACTERS[i].icon, 1)
					local iconscale = nameh / iconh
					GuiColorSetForNextWidget(Gui1, r, g, b, a)
					GuiText(Gui1, BX + Margin / 2 + BW / 2 + namew / -2 + iconw / 2, ny, CHARACTERS[i].displayname, TEXT_SIZE * 1.25, FONT)
					GuiImage(Gui1, newid(), BX + Margin / 2 + BW / 2 + namew / -2 - iconw, ny, CHARACTERS[i].icon, 1, iconscale, iconscale)
					break
				end
			end
		end

		_id = _id + 30
		if last - history > 1 and done then
			-- LEFT
			GuiColorSetForNextWidget(Gui1, r, g, b, a)
			local lmb, rmb = GuiButton(Gui1, newid(), nx, ny, "<", TEXT_SIZE * 1.25, FONT)
			LEFT = (lmb and 1) or (rmb and 5) or LEFT
		end
		nx = nx + w
		local rightid = newid()
		if history ~= 0 or cango then
			-- NUMBER
			local text = tostring(0 - history)
			if history == 0 then
				nx = nx + bigw
				GuiColorSetForNextWidget(Gui1, color_presets.emphasis1())
			else
				GuiColorSetForNextWidget(Gui1, r, g, b, a)
				GuiText(Gui1, nx, ny, text, TEXT_SIZE * 1.25, FONT)
				GuiColorSetForNextWidget(Gui1, r, g, b, a)
				w, h = GuiGetTextDimensions(Gui1, text, TEXT_SIZE * 1.25, LINE_SPACING, FONT)
				nx = nx + w
			end

			-- RIGHT
			local lmb, rmb = GuiButton(Gui1, rightid, nx, ny, ">", TEXT_SIZE * 1.25, FONT)
			RIGHT = (lmb and 1) or (rmb and 5) or RIGHT
		end
		nx, ny = BX + Margin / 2, bottomline_y

		w, h = GuiGetTextDimensions(Gui1, "^", TEXT_SIZE * 1.25, LINE_SPACING, FONT)
		if CANSCROLLDOWN then
			-- DOWN
			GuiColorSetForNextWidget(Gui1, r, g, b, a)
			local lmb, rmb = GuiButton(Gui1, newid(), nx, ny, "↓", TEXT_SIZE * 1.25, FONT)
			DOWN = (lmb and 1) or (rmb and 5) or DOWN
		end
		nx = nx + w

		if scroll < 0 then
			local text = tostring(0 - scroll)
			GuiColorSetForNextWidget(Gui1, r, g, b, a)
			GuiText(Gui1, nx, ny, text, TEXT_SIZE * 1.25, FONT)
			w, h = GuiGetTextDimensions(Gui1, text, TEXT_SIZE * 1.25, LINE_SPACING, FONT)
			nx = nx + w

			-- UP
			GuiColorSetForNextWidget(Gui1, r, g, b, a)
			local lmb, rmb = GuiButton(Gui1, newid(), nx, ny, "^", TEXT_SIZE * 1.25, FONT)
			UP = (lmb and 1) or (rmb and 5) or UP
		end
	end
end