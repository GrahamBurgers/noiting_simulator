local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local lua = EntityGetComponent(me, "LuaComponent") or {}
local count = #lua
local old = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", count)

if count == old or (not proj) then return end
local add = (count - old) * 0.2
local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
ComponentObjectSetValue2(proj, "damage_by_type", "fire", clever + add)