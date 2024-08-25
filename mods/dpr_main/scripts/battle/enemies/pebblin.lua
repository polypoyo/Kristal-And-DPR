local Pebblin, super = Class(EnemyBattler)

function Pebblin:init()
    super.init(self)

    self.name = "Pebblin"
    self:setActor("dummy") -- Placeholder

    self.max_health = 150
    self.health = 150
    self.attack = 3
    self.defense = 5
    self.money = 15
    self.experience = 3

    self.killable = true

    self.spare_points = 20

    self.waves = { -- Placeholder
        "basic",
        "aiming",
        "movingarena"
    }

    self.dialogue = { -- Placeholder
        "..."
    }

    self.check = "AT 3 DF 5\n* Proud warrior of Cliffside.\n* Has a cobbled together club."

    self.text = {
        "* Pebblin readies their club.",
        "* Pebblin might be taking this fight for granite.",
        "* Smells like andesite."
    }
    self.low_health_text = "* Pebblin is starting to errode."

    self:registerAct("Smile") -- Placeholder
    self:registerAct("Tell Story", "", {"susie"}) -- Placeholder
end

function Pebblin:onAct(battler, name)
    if name == "Smile" then
        self:addMercy(100)
        self.dialogue_override = "... ^^"
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        for _, enemy in ipairs(Game.battle.enemies) do
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "Standard" then --X-Action
        self:addMercy(50)
        if battler.chara.id == "susie" then
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Pebblin