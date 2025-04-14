local c = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local proj = EntityGetFirstComponent(GetUpdatedEntityID(), "ProjectileComponent")
if not proj then return end
if c == 3 then
    ComponentSetValue2(proj, "penetrate_world", false)
end