local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 0 then
	ComponentSetValue2(proj, "bounce_energy", math.max(1.75, ComponentGetValue2(proj, "bounce_energy")))
end

local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
local total = tonumber(ComponentGetValue2(GetUpdatedComponentID(), "script_polymorphing_to")) or 0
if current ~= last then
    ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", current)
    ComponentSetValue2(GetUpdatedComponentID(), "script_polymorphing_to", tostring(total + 1))
    if current < last then
		local subtract = math.max(1, ComponentGetValue2(proj, "lifetime") - 5)
        ComponentSetValue2(proj, "lifetime", subtract)
    end
end