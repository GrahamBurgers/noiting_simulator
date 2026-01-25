local times_of_day = {"Morning", "Midday", "Evening", "Night"}
local days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
local rainy_day = 4

local worldstate = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")

function OnGameStart()
    GlobalsSetValue("NS_TIME", times_of_day[1])
    GlobalsSetValue("NS_DAY", days[1])
    GlobalsSetValue("NS_WEATHER", "Clear")
	dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
	RefreshStamina()
end

function OnFinalDay()

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
			if i == rainy_day then
    			GlobalsSetValue("NS_WEATHER", "Cloudy")
			end
            break
        end
    end
end

function OnTimePassed()
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
			if GlobalsGetValue("NS_WEATHER") == "Cloudy" then GlobalsSetValue("NS_WEATHER", "Rain") end
			dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
			RefreshStamina()
            break
        end
    end
    if worldstate then
        local times = {["Morning"] = 0.75, ["Midday"] = 0, ["Evening"] = 0.45, ["Night"] = 0.54, ["Midnight"] = 0.63}
        ComponentSetValue2(worldstate, "time", new and times[new] or 0)
    end
end