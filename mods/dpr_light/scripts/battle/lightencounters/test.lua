local test, super = Class(LightEncounter)

function test:init()
    super.init(self)

    self.text = "* The tutorial begins...?\n* Again...?"

    self.flee_threshold = 0

    self:addEnemy("test")
end

return test