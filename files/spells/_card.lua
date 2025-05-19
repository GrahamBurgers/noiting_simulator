local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local action = EntityGetFirstComponentIncludingDisabled(me, "ItemActionComponent")
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local id = action and ComponentGetValue2(action, "action_id")
if not (item and string.len(id) > 1) then return end

-- animate quote flavor text
local text = "$q_" .. string.lower(id)
local real = GameTextGetTranslatedOrNot(text)
if not (real and real ~= text and string.len(real) > 1) then return end
if ComponentGetValue2(item, "custom_pickup_string") == "" then
    ComponentSetValue2(item, "custom_pickup_string", text)
end