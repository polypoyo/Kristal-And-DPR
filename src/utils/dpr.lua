---@class DPR : Class
local DPR = {}

function DPR.calendar()
    return os.date("*t")
end

function DPR.checkCalendar(cal)
    local now = DPR.calendar()
    for key, value in pairs(cal) do
        if value ~= now[key]
        then return false end
    end
    return true
end

function DPR.isNight()
    local hour = DPR.calendar().hour
    return hour < 8 or hour >= 21
end

return DPR