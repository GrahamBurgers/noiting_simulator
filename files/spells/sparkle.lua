local me = GetUpdatedEntityID()
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local audio = EntityGetComponentIncludingDisabled(me, "AudioComponent") or {}
if me and sprite and proj and vel and (#audio > 0) then
    SetRandomSeed(me + proj + GetUpdatedComponentID(), sprite + GameGetFrameNum() + GetUpdatedComponentID())
    local dmg = 4
	local types = {"CUTE", "CHARMING", "CLEVER", "COMEDIC"}
	local commander_type = GlobalsGetValue("SPELL_COMMANDER_TYPE", "NONE")
	local commander_count = tonumber(GlobalsGetValue("SPELL_COMMANDER_COUNT", "0"))

    local type = types[Random(1, 4)]
	if commander_count > 0 then
		if commander_type ~= "NONE" then type = commander_type end
		EntityAddComponent2(me, "LuaComponent", {
			script_source_file="mods/noiting_simulator/files/spells/commander_move.lua",
			limit_how_many_times_per_frame=commander_count,
		})
	end
    if type == "CUTE" then
        ComponentSetValue2(sprite, "rect_animation", "cute")
        ComponentObjectSetValue2(proj, "damage_by_type", "melee", ComponentObjectGetValue2(proj, "damage_by_type", "melee") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "data/particles/explosion_008_pink.xml")
    elseif type == "CHARMING" then
        ComponentSetValue2(sprite, "rect_animation", "charming")
        ComponentObjectSetValue2(proj, "damage_by_type", "slice", ComponentObjectGetValue2(proj, "damage_by_type", "slice") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "data/particles/explosion_008.xml")
    elseif type == "CLEVER" then
        ComponentSetValue2(sprite, "rect_animation", "clever")
        ComponentObjectSetValue2(proj, "damage_by_type", "fire", ComponentObjectGetValue2(proj, "damage_by_type", "fire") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "mods/noiting_simulator/files/spells/explosions/008_blue.xml")
    elseif type == "COMEDIC" then
        ComponentSetValue2(sprite, "rect_animation", "comedic")
        ComponentObjectSetValue2(proj, "damage_by_type", "ice", ComponentObjectGetValue2(proj, "damage_by_type", "ice") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "data/particles/explosion_008_plasma_green.xml")
        EntityAddTag(me, "comedic_noheal")
        EntityAddTag(me, "comedic_nohurt")
    end
    ComponentSetValue2(sprite, "visible", true)
    EntityRefreshSprite(me, sprite)

	for i = 1, #audio do
		EntityRemoveComponent(me, audio[i])
	end
end