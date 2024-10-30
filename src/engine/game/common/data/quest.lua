---@class Quest : Class
---@overload fun(): Class
local Quest = Class()
function Quest:init()
    self.name = "Untitled Quest " .. (self.id or "???")
    self.description = "No description."
    self.progress = -1
    self.progress_max = 1
    self.flags = {}
end

function Quest:setFlag(flag, value)
    self.flags[flag] = value
end
function Quest:getFlag(flag, default)
    if self.flags[flag] == nil then
        return default
    else
        return self.flags[flag]
    end
end
function Quest:addFlag(flag, value)
    self:setFlag(flag, self:getFlag(flag, 0) + value)
end

function Quest:unlock(...)
    self:setProgress(math.max(self:getProgress(), 0))
    Kristal.callEvent("unlockQuest", self, ...)
end

function Quest:isUnlocked()
    return (self:getProgress() >= 0)
end

function Quest:isVisible()
    return self:isUnlocked()
end

function Quest:setProgress(v) self.progress = v end
function Quest:addProgress(v) self:setProgress(self:getProgress() + v) end

function Quest:getName() return self.name end
function Quest:getDescription() return self.description end
function Quest:getProgress() return self.progress end
function Quest:getProgressMax() return self.progress_max end
function Quest:getProgressPercent() return self:getProgress() / self:getProgressMax() end

function Quest:isCompleted()
    return self:getProgressPercent() >= 1.0
end

function Quest:save()
    local data = {
        id = self.id,
        progress = self:getProgress(),
        flags = self.flags
    }
    self:onSave(data)
    return data
end

function Quest:load(data)
    self.progress = data.progress
    self.flags = data.flags or {}
    self:onLoad(data)
end

function Quest:onSave(data) end
function Quest:onLoad(data) end


return Quest
