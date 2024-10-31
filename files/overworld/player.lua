dofile_once("mods/noiting_simulator/files/overworld/locations.lua")

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetWithTag("player_unit")[1]
local vs = EntityGetFirstComponent(me, "VariableStorageComponent")
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")

if not vs then return end
local rx = tonumber(ComponentGetValue2(vs, "name"))
local ry = tonumber(ComponentGetValue2(vs, "value_string"))

local function gettile(x2, y2)
    local location = dofile_once(GlobalsGetValue("NS_LOCATION_FILE"))
    for i = 1, #location["tiles"] do
        if location["tiles"][i]["x"] == x2 and location["tiles"][i]["y"] == y2 then
            return location["tiles"][i]["tile"]
        end
    end
    return "empty"
end

if controls and (#EntityGetInRadiusWithTag(x, y, TILE_SIZE / 4, "player_unit") > 0) and ComponentGetValue2(vs, "value_int") < 1 then
    if ComponentGetValue2(controls, "mButtonDownRight") and gettile(rx + 1, ry) ~= "wall" then rx = rx + 1
    elseif ComponentGetValue2(controls, "mButtonDownLeft") and gettile(rx - 1, ry) ~= "wall" then rx = rx - 1
    elseif ComponentGetValue2(controls, "mButtonDownDown") and gettile(rx, ry + 1) ~= "wall" then ry = ry + 1
    elseif ComponentGetValue2(controls, "mButtonDownUp") and gettile(rx, ry - 1) ~= "wall" then ry = ry - 1 end
    ComponentSetValue2(vs, "name", tostring(rx))
    ComponentSetValue2(vs, "value_string", tostring(ry))
end
EntitySetTransform(me, WORLD_X + (rx * TILE_SIZE), WORLD_Y + (ry * TILE_SIZE))