---@class Quest : Class
local Quest = Class()
function Quest:init()
    self.name = "Known Objective " .. self.id
    self.description = "It is known."
    self.progress = 0
    self.progress_max = 1
end

function Quest:setProgress(v) self.progress = v end

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
    }
    self:onSave(data)
    return data
end

function Quest:load(data)
    assert(self.id == data.id, "Loading the wrong quest! "..self.id.." ~= "..data.id)
    self.progress = data.progress
end

function Quest:onSave(data) end
function Quest:onLoad(data) end


return Quest
