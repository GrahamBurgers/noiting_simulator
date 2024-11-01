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

local function gettile(x2, y2)
    for i = 1, #location["tiles"] do
        if location["tiles"][i]["coords"] == (x2 .. "," .. y2) then
            return location["tiles"][i]
        end
    end
    return {tile = "empty"}
end

local door = gettile(rx, ry)["sendto"]
if door then
    if canmove then
        Load_location(door["name"], door["x"], door["y"], door["freeze"], door["folder"])
    end
else
    if controls and canmove and ComponentGetValue2(vs, "value_int") < 1 then
        if ComponentGetValue2(controls, "mButtonDownRight") and gettile(rx + 1, ry)["tile"] ~= "wall" then rx = rx + 1
        elseif ComponentGetValue2(controls, "mButtonDownLeft") and gettile(rx - 1, ry)["tile"] ~= "wall" then rx = rx - 1
        elseif ComponentGetValue2(controls, "mButtonDownDown") and gettile(rx, ry + 1)["tile"] ~= "wall" then ry = ry + 1
        elseif ComponentGetValue2(controls, "mButtonDownUp") and gettile(rx, ry - 1)["tile"] ~= "wall" then ry = ry - 1 end
        ComponentSetValue2(vs, "name", tostring(rx))
        ComponentSetValue2(vs, "value_string", tostring(ry))
    end
    EntitySetTransform(me, WORLD_X + (rx * TILE_SIZE), WORLD_Y + (ry * TILE_SIZE))
end