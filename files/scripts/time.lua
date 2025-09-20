local times_of_day = {"Morning", "Evening", "Night"}
local days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
local default_stamina_max = "4"
local worldstate = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")

function OnGameStart()
    GlobalsSetValue("NS_STAMINA_MAX", default_stamina_max)
    GlobalsSetValue("NS_STAMINA_VALUE", default_stamina_max)
    GlobalsSetValue("NS_TIME", times_of_day[#times_of_day])
    GlobalsSetValue("NS_DAY", days[1])
end

function OnFinalDay()
    GlobalsSetValue("NS_DAY", "Sunday")
end

function OnNewDay()
    local current = GlobalsGetValue("NS_DAY", days[1])
    for i = 1, #days do
        if current == days[i] then
            if i == #days then
                -- final day
                OnFinalDay()
            else
                -- add to day
                GlobalsSetValue("NS_DAY", days[i + 1])
            end
            break
        end
    end
end

function OnTimePassed()
    GlobalsSetValue("NS_STAMINA_VALUE", GlobalsGetValue("NS_STAMINA_MAX", default_stamina_max) or tostring(default_stamina_max))
    local current = GlobalsGetValue("NS_TIME", times_of_day[1])
    local new = current
    for i = 1, #times_of_day do
        if current == times_of_day[i] then
            if i == #times_of_day then
                -- final time
                new = times_of_day[1]
                OnNewDay()
            else
                -- add to time
                new = times_of_day[i + 1]
            end
            GlobalsSetValue("NS_TIME", new)
            break
        end
    end
    if worldstate then
        local times = {["Morning"] = 0.92, ["Evening"] = 0.44, ["Night"] = 0.53}
        ComponentSetValue2(worldstate, "time", new and times[new] or 0)
    end
end