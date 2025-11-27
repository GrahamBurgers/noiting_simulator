local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local arm = EntityGetAllChildren(player, "player_arm_r")
local storage = EntityGetFirstComponent(player, "VariableStorageComponent", "wheel")
local children = EntityGetAllChildren(me, "flamboyance")
if storage and arm and arm[1] and children and #children >= 4 then
    local x, _, _   = EntityGetTransform(player)
    local _, y, _   = EntityGetTransform(arm[1])
    local _, _, rot = EntityGetTransform(me)
    local spin = ComponentGetValue2(storage, "value_float")
    local spin_mult = 0.3
    ComponentSetValue2(storage, "value_float", spin * 0.96)
    EntitySetTransform(me, x, y, rot + (spin * spin_mult))
    EntitySetTransform(children[1], x, y, rot + (spin * spin_mult))
    EntitySetTransform(children[2], x, y, rot + (spin * spin_mult) + math.rad(90))
    EntitySetTransform(children[3], x, y, rot + (spin * spin_mult) + math.rad(180))
    EntitySetTransform(children[4], x, y, rot + (spin * spin_mult) + math.rad(270))
end