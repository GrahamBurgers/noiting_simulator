local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local cpc = EntityGetFirstComponentIncludingDisabled(me, "CharacterPlatformingComponent")
local cdc = EntityGetFirstComponentIncludingDisabled(me, "CharacterDataComponent")

local enabled = true -- TODO
if enabled then
    local follow = EntityGetWithName("ns_player_overworld")
    if not follow then return end
    local x2, y2 = EntityGetTransform(follow)
    if cpc and cdc then
        ComponentSetValue2(cpc, "velocity_min_x", 0)
        ComponentSetValue2(cpc, "velocity_max_x", 0)
        ComponentSetValue2(cpc, "velocity_min_y", 0)
        ComponentSetValue2(cpc, "velocity_max_y", 0)
        ComponentSetValue2(cdc, "flying_needs_recharge", false)
    end
    GameSetCameraPos(x, y)
    local speed = 1.2
    if InputIsKeyDown(225) or InputIsKeyDown(229) then -- TODO: keybinds in mod settings
        speed = speed * 2
    end
    local vs = EntityGetFirstComponent(follow, "VariableStorageComponent")
    local c = 0
    if vs then
        c = ComponentGetValue2(vs, "value_int")
    end
    if vs and c > 0 then
        -- you can set value_int to snap player to their tile for that many frames
        ComponentSetValue2(vs, "value_int", c - 1)
        x, y = x2, y2
    else
        local xv, yv = 0, 0
        xv = (x > x2 and math.min(speed, x - x2)) or (x < x2 and -math.min(speed, x2 - x)) or 0
        yv = (y > y2 and math.min(speed, y - y2)) or (y < y2 and -math.min(speed, y2 - y)) or 0
        x = x - xv
        y = y - yv
    end
    EntityApplyTransform(me, x, y)
else
    if cpc and cdc then
        -- set player back to normal
        ComponentSetValue2(cpc, "velocity_min_x", -57)
        ComponentSetValue2(cpc, "velocity_max_x", 57)
        ComponentSetValue2(cpc, "velocity_min_y", -200)
        ComponentSetValue2(cpc, "velocity_max_y", 350)
        ComponentSetValue2(cdc, "flying_needs_recharge", true)
    end
end