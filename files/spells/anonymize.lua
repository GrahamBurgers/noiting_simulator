local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local genome = EntityGetFirstComponentIncludingDisabled(me, "GenomeDataComponent")
if not (proj and genome) then return end
ComponentSetValue2(proj, "mWhoShot", 0)
ComponentSetValue2(genome, "herd_id", StringToHerdId("mage_swapper"))