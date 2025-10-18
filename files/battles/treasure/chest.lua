function interacting( entity_who_interacted, entity_interacted, interactable_name )
    local me = GetUpdatedEntityID()
    local sprite = EntityGetFirstComponent(me, "SpriteComponent")
    if sprite and ComponentGetValue2(sprite, "rect_animation") == "open" then
        ComponentSetValue2(sprite, "rect_animation", "close")
    elseif sprite then
        ComponentSetValue2(sprite, "rect_animation", "open")
    end
end

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
y = y - 10
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
if sprite and GameGetFrameNum() % 8 == 0 and ComponentGetValue2(sprite, "rect_animation") == "open" then
    SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
    local proj
    if Random(1, 12) == 12 then
        proj = EntityLoad("mods/noiting_simulator/files/battles/treasure/token_riser.xml", x, y)
    else
        proj = EntityLoad("mods/noiting_simulator/files/battles/treasure/gold_riser.xml", x, y)
    end
    GameShootProjectile(me, x, y, x + math.sin(GameGetFrameNum() / 30) * 25, y - 6, proj)
    if GameGetFrameNum() % 200 / 8 == 0 then
        ComponentSetValue2(sprite, "rect_animation", "close")
    end
end