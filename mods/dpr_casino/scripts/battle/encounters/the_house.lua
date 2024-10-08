local TheHouseEnc, super = Class(Encounter)

function TheHouseEnc:init()
    super.init(self)

    self.text = "* It's you versus The House."
    self.music = ""
    self.background = true
    self.flee = false
    
    self:addEnemy("the_house")
end

function TheHouseEnc:onBattleInit()
    super.onBattleInit(self)
    if self.boss_rush == true then
        Game.battle.dojo_bg = DojoBG({1, 1, 1})
        Game.battle:addChild(Game.battle.dojo_bg)
    else
        Game.battle.house_bg = HouseBG()
        Game.battle:addChild(Game.battle.house_bg)
    end
end

function TheHouseEnc:onTurnStart()
    super.onTurnStart(self)
    local house = Game.battle.enemies[1]
    house.sprite.disable_shadow = false
    Game.battle.house_bg.on = 1
end

function TheHouseEnc:onReturnToWorld(events)
    -- check whether the enemies were killed
    if Game.battle.killed then
        -- run this code for each event in the table
        for _,event in ipairs(events) do
            for _,event in ipairs(event:getGroupedEnemies(true)) do
                -- set a 'dont_load' flag to true for the event,
                -- which is a special flag that will prevent the event from loading
                event:setFlag("dont_load", true)
            end
        end
    end
end

return TheHouseEnc