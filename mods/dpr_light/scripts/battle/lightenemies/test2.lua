local test, super = Class(LightEnemyBattler)

function test:init()
    super.init(self)

    self.name = "test 2"
    self:setActor("dummy_ut")

    self:registerAct("hi", nil, {"susie"})

    self.text = {
        "* h"
    }

    self.waves = {
        "basic"
    }

    self.dialogue = {
        "Board the platforms"
    }

    self.flip_dialogue = true
end

function test:onAct(battler, name)
    if name == "hi" then
        self:addMercy(100)
        return "* hi"
    elseif name == "Standard" then
        self:addMercy(50)
        return "* Standard"
    end

    return super.onAct(self, battler, name)
end

return test