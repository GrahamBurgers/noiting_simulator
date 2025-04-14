local m = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local grow_time = math.floor(5 * 0.3 * 60) -- (frame_count - 1) * frame_wait * 60
if (m >= grow_time) or (not proj) then return end
ComponentSetValue2(proj, "damage_scale_max_speed", ComponentGetValue2(proj, "damage_scale_max_speed") + 1 / grow_time)