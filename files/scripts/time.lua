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

function AddDay(amount)
    local current = GlobalsGetValue("NS_DAY", days[1])
    for i = 1, #days do
        if current == days[i] then
			i = math.max(1, math.min(i + amount, #days))

			-- add to day
			GlobalsSetValue("NS_DAY", days[i])

			if i == rainy_day then
    			GlobalsSetValue("NS_WEATHER", "Cloudy")
			else
				GlobalsSetValue("NS_WEATHER", "Clear")
			end
            break
        end
    end
end

function AddTime(amount)
    local current = GlobalsGetValue("NS_TIME", times_of_day[1])
    local new = current
    for i = 1, #times_of_day do
        if current == times_of_day[i] then
            if i + amount > #times_of_day then
                -- final time
                new = times_of_day[1]
				AddDay(1)
			elseif i + amount < 0 then
    			GlobalsGetValue("NS_DAY", days[1])
				new = times_of_day[#times_of_day]
				AddDay(-1)
            else
                -- add to time
                new = times_of_day[i + amount]
			end
            GlobalsSetValue("NS_TIME", new)
			dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
			RefreshStamina()
            break
        end
    end
    if worldstate then
        local times = {["Morning"] = 0.75, ["Midday"] = 0, ["Evening"] = 0.36, ["Night"] = 0.54, ["Midnight"] = 0.63}
        ComponentSetValue2(worldstate, "time", new and times[new] or 0)
    end
end