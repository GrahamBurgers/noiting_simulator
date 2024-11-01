local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
WORLD_X = 256
WORLD_Y = -728
TILE_SIZE = 16

function GetLocation(file_name)
    -- first time we get the location, grab its data from file and store it
    -- every other time, grab the stored data
    -- this way we can make modifications to it in gameplay
    local world = EntityGetWithName("ns_world_handler")
    local v = EntityGetComponent(world, "VariableStorageComponent") or {}
    for i = 1, #v do
        if ComponentGetValue2(v[i], "name") == file_name then
            return smallfolk.loads(ComponentGetValue2(v[i], "value_string"))
        end
    end
    local thing = dofile(file_name)
    EntityAddComponent2(world, "VariableStorageComponent", {
        name = file_name,
        value_string = smallfolk.dumps(thing)
    })
    return thing
end

function Load_location(name, x, y, freeze_frames, folder)
    local world = EntityGetWithName("ns_world_handler")
    local player = EntityGetWithName("ns_player_overworld")
    x, y = x or 1, y or 1
    EntitySetTransform(world,     WORLD_X + (TILE_SIZE / 2), WORLD_Y + (TILE_SIZE / 2))
    EntitySetTransform(player,    WORLD_X + (x * TILE_SIZE), WORLD_Y + (y * TILE_SIZE))

    local location
    folder = (folder or "mods/noiting_simulator/files/overworld/") .. name .. "/"
    location = GetLocation(folder .. "def.lua")
    GlobalsSetValue("NS_LOCATION_FILE", folder .. "def.lua")
    if location and world and player then
        -- position player properly
        local vs = EntityGetFirstComponent(player, "VariableStorageComponent")
        if vs then
            ComponentSetValue2(vs, "name", tostring(x))
            ComponentSetValue2(vs, "value_string", tostring(y))
            ComponentSetValue2(vs, "value_int", freeze_frames or 2)
        end
        local s = EntityGetComponent(world, "SpriteComponent") or {}
        for i = 1, #s do
            EntityRemoveComponent(world, s[i])
        end

        local spr = location["sprites"]
        for i = 1, #spr do
            EntityAddComponent2(world, "SpriteComponent", {
                image_file = folder .. spr[i]["image_file"],
                z_index = spr[i]["z_index"],
            })
        end
    end
end