local BG, super = Class(Object)

function BG:init()
    super.init(self)
    self.timer = 0
    self.started = 0
    self.vidsource = nil
    self.layer = BATTLE_LAYERS["bottom"]+1
    self.plain_font = Assets.getFont("plain")
    self.name = "utchara.mid"
end

function BG:start(name)
    Game.battle.utchara_vid = Video("utcharabg", true, 0, 0, 640, 480)
    Game.battle.utchara_vid.parallax_x, Game.battle.utchara_bg.parallax_y = 0, 0
    Game.battle.utchara_vid:setLooping(true)
    Game.battle.utchara_vid.layer = BATTLE_LAYERS["bottom"]
    Game.battle:addChild(Game.battle.utchara_vid)
    Game.battle.utchara_vid:play()
    self.vidsource = Game.battle.utchara_vid.video:getSource()
    self.name = name
    self.started = 1
end


function BG:stop()
    Game.battle.utchara_vid:stop()
    self.started = 2
end

function BG:update()
    super.update(self)
    if self.started == 1 then
        self.fade = self.fade - 0.05 * DTMULT
        if self.fade <= 0 then
            self.fade = 0
        end
    elseif self.started == 2 then
        self.fade = self.fade + 0.05 * DTMULT
        if self.fade >= 1 then
            self.fade = 1
        end
    else
        self.fade = Game.battle.transition_timer / 10
    end
end

function BG:draw()
    super.draw(self)

    if self.started == 1 and self.vidsource then
        love.graphics.setColor(COLORS.white)
        love.graphics.setFont(self.plain_font)
        love.graphics.print(self.name.."  fps:"..FPS..".00", 50, 5)
        love.graphics.rectangle("fill", 28, 23, SCREEN_WIDTH - 56, 14)
        love.graphics.setColor(COLORS.black)
        love.graphics.rectangle("fill", 30, 25, SCREEN_WIDTH - 60, 10)
        local percentage = self.vidsource:tell() / self.vidsource:getDuration()
        love.graphics.setColor(COLORS.red)
        love.graphics.rectangle("fill", 30, 25, math.ceil(percentage * (SCREEN_WIDTH - 60)), 10)
    end
    love.graphics.setColor(0,0,0,self.fade)
    love.graphics.rectangle("fill", -10, -10, SCREEN_WIDTH+10, SCREEN_HEIGHT+10)
end

return BG