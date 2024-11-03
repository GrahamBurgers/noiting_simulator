dofile_once("mods/noiting_simulator/files/overworld/locations.lua")

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetWithTag("player_unit")[1]
local vs = EntityGetFirstComponent(me, "VariableStorageComponent")
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")

if not vs then return end
local rx = tonumber(ComponentGetValue2(vs, "name"))
local ry = tonumber(ComponentGetValue2(vs, "value_string"))
local location = GetLocation(GlobalsGetValue("NS_LOCATION_FILE")) or {}
local canmove = #EntityGetInRadiusWithTag(x, y, TILE_SIZE / 4, "player_unit") > 0

---@param coords string A string of comma-sorted integers: i.e. "x,y"
local function gettile(coords)
    for i = 1, #location["tiles"] do
        if location["tiles"][i]["coords"] == coords then
            return location["tiles"][i]
        end
    end
    return {tile = "empty"}
end

---@param coords string A string of comma-sorted integers: i.e. "x,y"
---@param tile string Tile data. A table with coords and some other data.
local function settile(coords, tile)
    for i = 1, #location["tiles"] do
        if location["tiles"][i]["coords"] == coords then
            location["tiles"][i] = tile
            SetLocation(GlobalsGetValue("NS_LOCATION_FILE"), location)
        end
    end
end

local door = gettile(rx .. "," .. ry)["sendto"]
if door then
    if canmove then
        Load_location(door["name"], door["x"], door["y"], door["freeze"], door["folder"])
    end
else
    if controls and canmove and ComponentGetValue2(vs, "value_float") < 1 and not ComponentGetValue2(vs, "value_bool") then
        local direction = ComponentGetValue2(vs, "value_int")
        -- todo: keybinds in mod settings later?
        local interact = ComponentGetValue2(controls, "mButtonFrameInteract") == GameGetFrameNum()
        local k = {
            right = {button = ComponentGetValue2(controls, "mButtonDownRight"), x = 1, dir = 1},
            left = {button = ComponentGetValue2(controls, "mButtonDownLeft"), x = -1, dir = 2},
            down = {button = ComponentGetValue2(controls, "mButtonDownDown"), y = 1, dir = 3},
            up = {button = ComponentGetValue2(controls, "mButtonDownUp"), y = -1, dir = 4},
        }
        local fx, fy = rx, ry
        for i, j in pairs(k) do
            if j["button"] and not interact then
                fx = fx + (j["x"] or 0)
                fy = fy + (j["y"] or 0)
                direction = j["dir"] or direction
                -- don't walk into walls please
                if gettile(fx .. "," ..  fy)["tile"] ~= "wall" then
                    rx, ry = fx, fy
                end
                -- if this lag then stop doing this unnecessarily
                ComponentSetValue2(vs, "name", tostring(rx))
                ComponentSetValue2(vs, "value_string", tostring(ry))
                ComponentSetValue2(vs, "value_int", direction)
                break
            end
            if direction == j["dir"] and interact then
                -- if interacting, make sure to do it on the block we're actually facing
                local tile = rx + (j["x"] or 0) .. "," ..  ry + (j["y"] or 0)
                local interacted = gettile(tile)
                if interacted["id"] then
                    local file = GlobalsGetValue("NS_LOCATION_FILEPATH") .. location["interactibles"]
                    dofile_once(file)
                    dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")
                    interacted["interactions"] = math.min((interacted["interactions"] or 0) + 1, interacted["max_interactions"])
                    settile(tile, interacted)

                    GamePrint(tostring(interacted["interactions"]))
                    local track = Init(interacted["id"])
                    if track then
                        SetScene(file, 0, 1, track)
                        LockPlayer(true)
                    end
                end
                break
            end
        end
    end
    EntitySetTransform(me, WORLD_X + (rx * TILE_SIZE), WORLD_Y + (ry * TILE_SIZE))
end