---@class FallbackQuest : Quest
local FallbackQuest, super = Class(Quest)
function FallbackQuest:init(data)
    super.init(self)
    self.name = "Missing " .. (data.id or "???")
    self.description = "It is known."
    self.progress = 0
    self.progress_max = 1000
    self.hidden = true
    self.id = data.id
    self:load(data)
end

return FallbackQuest
