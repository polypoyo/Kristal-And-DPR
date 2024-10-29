---@class FallbackQuest : Quest
local FallbackQuest = Class(Quest)
function FallbackQuest:init(data)
    self.name = "Missing " .. (data.id or "???")
    self.description = "It is known."
    self.progress = 0
    self.progress_max = 1000
    self:load(data)
end

return FallbackQuest
