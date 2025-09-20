local me = GetUpdatedEntityID()
local action = EntityGetFirstComponentIncludingDisabled(me, "ItemActionComponent")
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "charges")
local id = action and ComponentGetValue2(action, "action_id")
local spells = dofile_once("mods/noiting_simulator/files/spells/__gun_list.lua")
if not (var and item and string.len(id) > 1 and #spells > 0) then return end
local data = {}
for i = 1, #spells do
    if spells[i].id == id then
        data = spells[i]
        break
    end
end

-- quote flavor text
local text = "$q_" .. string.lower(id)
local real = GameTextGetTranslatedOrNot(text)
if not (real and real ~= text and string.len(real) > 1) then return end
if ComponentGetValue2(item, "custom_pickup_string") == "" then
    ComponentSetValue2(item, "custom_pickup_string", text)
end

if data.charge_time and data.max_uses then
    local current = ComponentGetValue2(item, "uses_remaining")
    local charges = ComponentGetValue2(var, "value_float")
    local charge_time = 1 / (data.charge_time * 25 * 60)
    local max_charges = data.max_uses or -1
    charges = charges + charge_time
    if charges >= 1 then
        ComponentSetValue2(item, "uses_remaining", current + 1)
        charges = charges - 1
    end
    if current >= max_charges or charge_time == -1 then charges = 0 end
    ComponentSetValue2(var, "value_float", charges)
end