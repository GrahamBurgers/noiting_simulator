local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua") --[[@as utf8]]

---The constants are stuck in the module because we need a few of them elsewhere and im lazy
---@class TranlationUpdater
local M = {}

M.ASCII_SIZE = 128
M.PUA_START = 0xE000

M.ICONS = {
	"CHARMING",
	"CUTE",
	"CLEVER",
	"COMEDIC",
	"TYPELESS",
}

M.ICON_MODE = "ICON"
M.ICONS_PREFIX = M.ICON_MODE .. "_"

M.SPECIAL_MODES = {
	CHARMINING = M.PUA_START + M.ASCII_SIZE * 0,
	CUTE = M.PUA_START + M.ASCII_SIZE * 1,
	CLEVER = M.PUA_START + M.ASCII_SIZE * 2,
	COMEDIC = M.PUA_START + M.ASCII_SIZE * 3,
	TYPELESS = M.PUA_START + M.ASCII_SIZE * 4,
	[M.ICON_MODE] = M.PUA_START + M.ASCII_SIZE * 5,
	NONE = 0,
}

M.SECTION = "§"

---Modifies data/translations/common.csv with the new translations including symbol handling
function M.update_translations()
	local translations = ModTextFileGetContent("data/translations/common.csv")
	M.new_translations = ModTextFileGetContent("mods/noiting_simulator/translations.csv")

	---@type string
	M.formatted = ""
	M.largest_follower = 0
	for k, _ in pairs(M.SPECIAL_MODES) do
		-- why can't luals infer this ?? stupid generics
		M.largest_follower = math.max(M.largest_follower, k:len()) --[[@as integer]]
	end
	for _, v in ipairs(M.ICONS) do
		M.largest_follower = math.max(M.largest_follower, v:len() + M.ICONS_PREFIX:len()) --[[@as integer]]
	end

	---@type integer?
	M.special = nil
	---@type integer
	M.i = 1

	while M.i <= M.new_translations:len() do
		local next_point = M.new_translations:find(M.SECTION, M.i) or M.new_translations:len()
		local sub = M.new_translations:sub(M.i, next_point - 1)
		if M.special then
			for char in sub:gmatch(".") do
				M.formatted = M.formatted .. utf8.char(char:byte() + M.special)
			end
		else
			M.formatted = M.formatted .. sub
		end
		M.i = next_point + M.SECTION:len()
		M.handle_format()
	end

	local updated_translations = translations .. M.formatted
	ModTextFileSetContent("data/translations/common.csv", updated_translations:gsub("\r", ""):gsub("\n\n", "\n"))
end

---@param follower string
function M.handle_icon(follower)
	for k, icon in ipairs(M.ICONS) do
		local name = M.ICONS_PREFIX .. icon
		if follower:sub(1, name:len()) == name then
			M.formatted = M.formatted .. utf8.char(M.SPECIAL_MODES[M.ICON_MODE] + k - 1) -- -1 because 1 indexing
			M.i = M.i + name:len() --[[@as integer]]
			return
		end
	end
end

---@package
---Mutates i, special, formatted
function M.handle_format()
	local follower = M.new_translations:sub(M.i, M.i + M.largest_follower)
	for mode, shift in pairs(M.SPECIAL_MODES) do
		if follower:sub(1, mode:len()) == mode then
			if mode == M.ICON_MODE then
				M.handle_icon(follower)
			else
				M.special = shift
				if M.special == 0 then M.special = nil end
				M.i = M.i + mode:len()
			end
			break
		end
	end
end

return M
