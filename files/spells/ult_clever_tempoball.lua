local me = GetUpdatedEntityID()
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local player = EntityGetWithTag("player_unit") or {}
if not proj then return end
for i = 1, #player do
    if touchinghitbox(ComponentGetValue2(proj, "blood_count_multiplier"), player[i], true) then
        local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
        local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
        local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
        if v and v.tempolevel then
            v.tempolevel = v.tempolevel + 1
            GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
        end
        EntityKill(me)
        return
    end
end