local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local wrappers = EntityGetComponent(me, "LuaComponent", "wrapper") or {}
if (not vel) or (wrappers[1] ~= this) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
if v then
    local x, y = EntityGetTransform(me)
    local x2, y2 = nil, nil
    local bx = (vx / 40) + 2
    local by = (vy / 40) + 2
    local bf = 2
    if (x + bx + bf) > v.arena_x + v.arena_w / 2 then x2, y2 = (x + bx + bf * 1.5) - v.arena_w, y end
    if (x + bx - bf) < v.arena_x - v.arena_w / 2 then x2, y2 = (x + bx - bf * 1.5) + v.arena_w, y end
    if (y + by + bf) > v.arena_y + v.arena_h / 2 then x2, y2 = x, (y + by + bf * 1.5) - v.arena_h end
    if (y + by - bf) < v.arena_y - v.arena_h / 2 then x2, y2 = x, (y + by - bf * 1.5) + v.arena_h end
    if x2 and y2 then
        EntityLoad("data/entities/particles/teleportation_source.xml", x, y)
        EntityLoad("data/entities/particles/teleportation_target.xml", x2, y2)
        EntitySetTransform(me, x2, y2)
        EntityRemoveComponent(me, this)
        -- do the bounce
        local bouncy = EntityGetComponent(me, "LuaComponent", "bounce_effect") or {}
        for i = 1, #bouncy do
            ComponentSetValue2(bouncy[i], "limit_how_many_times_per_frame", ComponentGetValue2(bouncy[i], "limit_how_many_times_per_frame") + 1)
        end
        local particle = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
        for i = 1, #particle do
            ComponentSetValue2(particle[i], "mExPosition", x2, y2)
            ComponentSetValue2(particle[i], "m_last_emit_position", x2, y2)
        end
    end
end