local test, super = Class(LightEnemyBattler)

function test:init()
    super.init(self)

    self.name = "test"
    self:setActor("dummy_ut")

    self:registerAct("Talk")
    self:registerAct("Red Buster", nil, {"susie"}, 60, nil, false)
    self:registerAct("Dual Heal", nil, {"noelle"}, 50, nil, false)

    self.max_health = 100
    self.health = 100
    self.attack = 1
    self.defense = 0
    self.exp = 10

    self.count_as_kill = false
    
    self.check = "ATK 0 DEF 0\n* A cotton heart and a button eye\n*You are the apple of my eye"

    self.text = {
        "* Dummy stands around absentmindedly.",
        "* The power of fluffy boys is\nNOT in the air.",
        "* Smells like...[wait:1s]\n* A Dummy."
    }

    self.dialogue = {
        "[wave:1][speed:0.5]...."
    }
    self.flip_dialogue = true

    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }
end

function test:onAct(battler, name)
    if name == "Talk" then
        self:addMercy(100)
        return {
            "* You talk to the DUMMY.\n[wait:0.5s]* ...",
            "* It's still not much for\nconversation, [wait:10]\nbut it seems happy with you."
        }
    elseif name == "Red Buster" then
        Game.battle:powerAct("red_buster", "kris", "susie", self)
    elseif name == "Dual Heal" then
        Game.battle:powerAct("dual_heal", "kris", "noelle")
    elseif name == "Standard" then
        self:addMercy(100)
        return "* " .. battler.chara:getName() .. " talks to the DUMMY.\n* Still doesn't seem much for\nconversation."
    end

    return super.onAct(self, battler, name)
end

return test