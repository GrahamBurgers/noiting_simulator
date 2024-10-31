
WORLD_X = 256
WORLD_Y = -728
TILE_SIZE = 16

function Load_location(name, x, y, folder)
    x, y = x or 1, y or 1
    local world = EntityGetWithName("ns_world_handler")
    local player = EntityGetWithName("ns_player_overworld")
    EntitySetTransform(world,     WORLD_X + (TILE_SIZE / 2), WORLD_Y + (TILE_SIZE / 2))
    EntitySetTransform(player,    WORLD_X + (x * TILE_SIZE), WORLD_Y + (y * TILE_SIZE))

    local location
    folder = (folder or "mods/noiting_simulator/files/overworld/") .. name .. "/"
    location = dofile(folder .. "def.lua")
    GlobalsSetValue("NS_LOCATION_FILE", folder .. "def.lua")
    if location and world and player then
        -- position player properly
        local vs = EntityGetFirstComponent(player, "VariableStorageComponent")
        if vs then
            ComponentSetValue2(vs, "name", tostring(x))
            ComponentSetValue2(vs, "value_string", tostring(y))
            ComponentSetValue2(vs, "value_int", 2)
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