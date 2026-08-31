local times_of_day = {"Morning", "Midday", "Evening", "Night"}
local days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
local rainy_day = 4

local worldstate = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local init_schedules = {
	healer = {
		Monday     = {Morning = "park",    Midday = "medical", Evening = "medical", Night = "healer_apartment"},
		Tuesday    = {Morning = "park",    Midday = "medical", Evening = "medical", Night = "healer_apartment"},
		Wednesday  = {Morning = "park",    Midday = "medical", Evening = "medical", Night = "healer_apartment"},
		Thursday   = {Morning = "park",    Midday = "medical", Evening = "medical", Night = "healer_apartment"},
		Friday     = {Morning = "park",    Midday = "medical", Evening = "medical", Night = "medical"},
		Saturday   = {Morning = "park",    Midday = "park",    Evening = "arcade",  Night = "healer_apartment"},
		Sunday     = {Morning = "medical", Midday = "medical", Evening = "medical", Night = "healer_apartment"},
	},
}

---@param character string       Character ID. Don't screw this up.
---@param value string           This can be basically whatever you want.
---@param day string|number|nil  If number, sets relative to current day.  (Monday + 1 = Tuesday). If string, sets for that day.  If nil, sets for current day.
---@param time string|number|nil If number, sets relative to current time. (Morning + 1 = Midday). If string, sets for that time. If nil, sets for current time.
function SetCharacterSchedule(character, value, day, time)
	local current_day = GlobalsGetValue("NS_DAY")
	local current_time = GlobalsGetValue("NS_TIME")
	for i = 1, #days do
		if days[i] == current_day and type(day) ~= "string" then
			day = days[i + (day or 0)]
			break
		end
	end
	for i = 1, #times_of_day do
		if times_of_day[i] == current_time and type(time) ~= "string" then
			time = times_of_day[i + (time or 0)]
			break
		end
	end
	if not (day and time and value) then return end
	local schedules = smallfolk.loads(GlobalsGetValue("NS_SCHEDULES", smallfolk.dumps(init_schedules)))
	schedules[character] = schedules[character] or {}
	schedules[character][day] = schedules[character][day] or {}
	schedules[character][day][time] = value
	-- print(table.concat({"SETTING SCHEDULE FOR ", character, " TO ", value, ", DAY: ", day, ", TIME: ", time}))
	if day == current_day and time == current_time then
		GlobalsSetValue("L_" .. string.upper(character), value)
	end
	GlobalsSetValue("NS_SCHEDULES", smallfolk.dumps(schedules))
end

function OnGameStart()
	local day = days[1]
	local time = times_of_day[1]
    GlobalsSetValue("NS_DAY", day)
    GlobalsSetValue("NS_TIME", time)
    GlobalsSetValue("NS_WEATHER", "Clear")
	GlobalsSetValue("NS_SCHEDULES", smallfolk.dumps(init_schedules))
	dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
	RefreshStamina()
	for a, b in pairs(init_schedules) do
		GlobalsSetValue("L_" .. string.upper(a), b[day][time])
	end
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
				new = times_of_day[#times_of_day]
				AddDay(-1)
            else
                -- add to time
                new = times_of_day[i + amount]
			end
            GlobalsSetValue("NS_TIME", new)
			dofile_once("mods/noiting_simulator/files/scripts/stamina.lua")
			RefreshStamina()
			local schedules = smallfolk.loads(GlobalsGetValue("NS_SCHEDULES", smallfolk.dumps(init_schedules)))
			local day = GlobalsGetValue("NS_DAY", days[1])
			for a, b in pairs(schedules) do
				GlobalsSetValue("L_" .. string.upper(a), b[day][new])
			end
            break
        end
    end
    if worldstate then
        local times = {["Morning"] = 0.75, ["Midday"] = 0, ["Evening"] = 0.36, ["Night"] = 0.54, ["Midnight"] = 0.63}
        ComponentSetValue2(worldstate, "time", new and times[new] or 0)
    end
end