local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if proj and not EntityHasTag(me, "pierces") then
    local stacks = EntityGetComponent(me, "LuaComponent", "piercing") or {}
    local factor = math.max(7 - #stacks, 1) -- between 6 and 1
    local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
    q.add_mult(me, "piercing", ((factor - 1) / -factor), "dmg_mult_collision")
    -- ComponentSetValue2(proj, "knockback_force", ComponentGetValue2(proj, "knockback_force") / factor)
    EntityAddTag(me, "pierces")
    for i = 1, #stacks do
        EntityRemoveComponent(me, stacks[i])
    end
end