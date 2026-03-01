local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end

local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
local total = tonumber(ComponentGetValue2(GetUpdatedComponentID(), "script_polymorphing_to")) or 0
if current ~= last then
    ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", current)
    ComponentSetValue2(GetUpdatedComponentID(), "script_polymorphing_to", tostring(total + 1))
    if current < last and total > 0 then
		local subtract = math.max(1, ComponentGetValue2(proj, "lifetime") - 15)
        ComponentSetValue2(proj, "lifetime", subtract)
    end
end