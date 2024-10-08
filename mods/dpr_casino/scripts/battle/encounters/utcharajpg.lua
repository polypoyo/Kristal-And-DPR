local UTCharaJpeg, super = Class(Encounter)

function UTCharaJpeg:init()
    super.init(self)

    self.text = "* genocides >=]"
    self.music = ""
    self.background = false
    self.flee = false
    self.turn = 0

    self:addEnemy("utcharajpg")
end

function UTCharaJpeg:onBattleInit()
    super.onBattleInit(self)
    
    if self.boss_rush == true then
        self.music = "utcharajpg"
        Game.battle.dojo_bg = DojoBG({1, 1, 1})
        Game.battle:addChild(Game.battle.dojo_bg)
    else
        Game.battle.utchara_bg = UTCharaJPGBG()
        Game.battle:addChild(Game.battle.utchara_bg)
    end
    local save = UndertaleLoader.getSave()
    if save then
        Kristal.Console:log("Undertale save name is "..UndertaleLoader.getSave().name)
        self.ut_name = save.name
        local chara = Game.battle.enemies[1]
        chara.name = "ut"..string.lower(UndertaleLoader.getSave().name)..".jpg"
    else
        Kristal.Console:log("Unable to get Undertale save name >=［")
    end
end

function UTCharaJpeg:onTurnStart()
    super.onTurnStart(self)
    if self.turn == 0 then
        local midiname = "utchara.mid"
        local save = UndertaleLoader.getSave()
        if save then
            midiname = "ut"..string.lower(UndertaleLoader.getSave().name)..".mid"
        end
        if not self.boss_rush then
            Game.battle.utchara_bg:start(midiname)
        end
        local chara = Game.battle.enemies[1]
    end
    self.turn = self.turn + 1
end

function UTCharaJpeg:onReturnToWorld(events)
    -- check whether the enemies were killed
    if not self.boss_rush then
        Game.battle.utchara_bg:stop()
    end
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

return UTCharaJpeg