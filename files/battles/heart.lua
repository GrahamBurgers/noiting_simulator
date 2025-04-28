local me = GetUpdatedEntityID()
local hitbox = EntityGetFirstComponentIncludingDisabled(me, "HitboxComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (hitbox and vel) then return end

-- AI LOGIC --