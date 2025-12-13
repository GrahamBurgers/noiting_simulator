local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local lua = EntityGetComponent(me, "LuaComponent") or {}
if not proj then return end
local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
ComponentObjectSetValue2(proj, "damage_by_type", "fire", clever + ((#lua - 3) * 0.2))