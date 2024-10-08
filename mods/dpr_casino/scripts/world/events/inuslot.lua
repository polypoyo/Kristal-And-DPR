local InuSlot, super = Class(Event)

function InuSlot:init(data)
    super.init(self, data)

    local pr        = data.properties

    --self.direction  = pr.direction or "right"
    --self.type       = pr.type or 1

    self.count      = 4
    self.timer      = 0
    self.btimer     = 0
    self.movemode   = 0
    self.dontdraw   = false

    self.path       = "world/events/inuslot/"
    self:setSprite(self.path.."inuslot_1")
    self:setOrigin(0.5, 1)
    self:setHitbox(0, 94, 78, 40)
    self.solid = true
    
    -- Options
    self.correct_a = pr["correctA"] or 1
    self.correct_b = pr["correctB"] or 1
    self.correct_c = pr["correctC"] or 1

    self.group = pr["group"]

    self.flag = pr["flag"]
    self.once = pr["once"]

    self.cutscene = pr["cutscene"]
    self.script = pr["script"]

    self.slot_type = pr["slottype"] or 0
    
    self.speed_factor = pr["speed"] or 0.42
    
    self.slot = {0,0,0}
    for i=1,3 do
        self.slot[i] = {1,2,3,1}
    end
    self.slot_max = {3,3,3}
    self.slot_no = {1,1,1}
    self.slot_y = {0,0,0}
    self.slot_spd = {0,0,0}
    -- State variables
    self.gambling = false
    self.confirmed = 0
    self.won = false
    self.flashtimer = -1
    self.won_flashing = 1
    self.raxd_secret = 0 
end

function InuSlot:onLoad()
    if self.slot_type == 0 then
        self.slot_max = {9,9,9}
        self.slot[1] = {4,1,1,2,2,3,3,4,4,1}
        self.slot[2] = {4,1,1,2,2,3,3,4,4,1}
        self.slot[3] = {4,1,1,2,2,3,3,4,4,1}
    elseif self.slot_type == 1 then
        self.slot_max = {5,5,5}
        self.slot[1] = {4,1,2,3,4,1}
        self.slot[2] = {4,1,2,3,4,1}
        self.slot[3] = {4,1,2,3,4,1}
    end
end

function InuSlot:onInteract(player, dir)
    self:startSlots()
    
    return true
end

function InuSlot:startSlots()
    if self.won then
        return
    end
    self.gambling = true
    self.confirmed = 0
    Game.lock_movement = true
    self.raxd_secret = Utils.random()
    if self.raxd_secret <= 0.03 then 
        Assets.stopSound("slot_win_raxd")
        Assets.stopSound("slot_lose_raxd")
        Assets.playSound("slot_start_raxd")
    else
        Assets.playSound("slot_start")
    end
end

function InuSlot:endSlots()
    self.gambling = false
    if self.slot[1][self.slot_no[1]+2] == self.correct_a
    and self.slot[2][self.slot_no[2]+2] == self.correct_b
    and self.slot[3][self.slot_no[3]+2] == self.correct_c then
        if self.raxd_secret <= 0.03 then 
            Assets.stopSound("slot_start_raxd")
            Assets.playSound("slot_win_raxd")
        Game.stage.timer:after(2, function()
            self:setSprite(self.path.."inuslot_2")
            self.flashtimer = -1
            self.won_flashing = 2
            self:checkCompletion()
            Game.lock_movement = false
        end)
        else
            Assets.playSound("slot_win")
            Game.stage.timer:after(40/30, function()
                self:setSprite(self.path.."inuslot_2")
                self.flashtimer = -1
                self.won_flashing = 2
                self:checkCompletion()
                Game.lock_movement = false
            end)
        end
        self:setSprite(self.path.."inuslot",1/4)
        self.flashtimer = 0
        self.won = true
    else
        if self.raxd_secret <= 0.03 then 
            Assets.stopSound("slot_start_raxd")
            Assets.playSound("slot_lose_raxd")
        end
        Game.lock_movement = false
    end
end

function InuSlot:update()
    if self.gambling then
        for i=1,3 do
            if self.confirmed < i then
                if self.slot_spd[i] < ((4 + (i-1)*2) * self.speed_factor) then
                    self.slot_spd[i] = self.slot_spd[i] + 0.8 * DTMULT
                end
            end
        end
        if Input.pressed("confirm") then
            if self.raxd_secret <= 0.03 then 
                Assets.playSound("slot_set_raxd")
            else
                Assets.playSound("slot_set")
            end
            self.confirmed = self.confirmed + 1
            if self.confirmed >= 3 then
                self:endSlots()
            end
        end
    end
    for i=1,3 do
        self.slot_y[i] = self.slot_y[i] + self.slot_spd[i] * DTMULT
        if self.slot_y[i] >= 30 then
            if self.confirmed < i then
                self.slot_y[i] = self.slot_y[i] - 30
                self.slot_no[i] = self.slot_no[i] + 1
                if self.slot_no[i] >= self.slot_max[i] then
                    self.slot_no[i] = 1
                end
            else
                self.slot_y[i] = 30
                self.slot_spd[i] = 0
            end
        end
    end
    if self.flashtimer ~= -1 then
        self.flashtimer = self.flashtimer + DTMULT
        if self.flashtimer >= 8 then
            if self.won_flashing == 1 then
                self.won_flashing = 2
            else
                self.won_flashing = 1
            end
            self.flashtimer = 0
        end
    end
    super.update(self)
end

--- Called to run everything that happens when the tile button puzzle is completed
function InuSlot:onCompleted()
    self:setFlag("solved", true)

    if self.flag then
        Game:setFlag(self.flag, true)
    end

    if self.script then
        Registry.getEventScript(self.script)(self)
    end
    if self.cutscene then
        self.world:startCutscene(self.cutscene, self)
    end
end

--- Called to set the tile button puzzle as incomplete
function InuSlot:onIncompleted()
    self:setFlag("solved", false)

    if self.flag then
        Game:setFlag(self.flag, false)
    end
end

--- Checks whether the tile button puzzle is completed and then calls [`onCompleted()`](lua://InuSlot.onCompleted) or [`onIncompleted()`](lua://InuSlot.onIncompleted) appropriately.
function InuSlot:checkCompletion()
    self:onCompleted()
end

function InuSlot:draw()
    Draw.setColor(1, 1, 1)
    for i=1,3 do
        --Draw.draw(Assets.getTexture("world/events/inuslot/sloticon_"..self.won_flashing.."_"..self.slot[i][self.slot_no[i]]), -10+i*20, 8-self.slot_y[i], 0, 2, 2)
        --Draw.draw(Assets.getTexture("world/events/inuslot/sloticon_"..self.won_flashing.."_"..self.slot[i][self.slot_no[i]+1]), -10+i*20, 38-self.slot_y[i], 0, 2, 2)
        --Draw.draw(Assets.getTexture("world/events/inuslot/sloticon_"..self.won_flashing.."_"..self.slot[i][self.slot_no[i]+2]), -10+i*20, 68-self.slot_y[i], 0, 2, 2)
        if self.slot_y[i] < 4 then
            Draw.draw(Assets.getTexture("world/events/inuslot/sloticon_"..self.won_flashing.."_"..self.slot[i][self.slot_no[i]]), -10+i*20, 8-self.slot_y[i], 0, 2, 2)
        end
        Draw.draw(Assets.getTexture("world/events/inuslot/sloticon_"..self.won_flashing.."_"..self.slot[i][self.slot_no[i]+1]), -10+i*20, 38-self.slot_y[i], 0, 2, 2)
        Draw.draw(Assets.getTexture("world/events/inuslot/sloticon_"..self.won_flashing.."_"..self.slot[i][self.slot_no[i]+2]), -10+i*20, 68-self.slot_y[i], 0, 2, 2)
    end
    Draw.draw(self.sprite.texture, 0, 0, 0, 2, 2)

    if self.dontdraw then
        return
    end
end

return InuSlot