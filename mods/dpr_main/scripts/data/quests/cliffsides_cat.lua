---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "cliffsides_cat")

function MyQuest:init()
    super.init(self)
    self.name = "Cliffside's Cat"
    self.progress_max = 0
end

return MyQuest
