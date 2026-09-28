local me = GetUpdatedEntityID()
local starshield = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "starshield")
local opacity = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") / 180
if starshield then
	ComponentSetValue2(starshield, "image_animation_emission_probability", 1 - opacity)
end