local CharaTest, super = Class(Wave)

function CharaTest:init()
    super:init(self)
    self.string = {-9999, -9999, -9999}
    self.column_count = 4
    self.row_count = 5
    self.loop = 0
	self.current_column = 2
	self.current_row = 2
    self.started = false
    self:setLayer(BATTLE_LAYERS["below_soul"])
    self.posmarker = Assets.getTexture("ui/battle/heart_posmarker")
    self.loopmarker = Assets.getTexture("ui/battle/heart_loopmarker")
    self.loopmarkerdiag = Assets.getTexture("ui/battle/heart_loopmarkerdiag")
    self.pegalpha = {}
    for x=1, self.column_count+1 do
      self.pegalpha[x] = {}
      for y=1, self.row_count+1 do
        self.pegalpha[x][y] = 1
      end
    end
end

function CharaTest:onStart()
    Game.battle:swapSoul(GridSoul())

    Game.battle.soul.column_count = self.column_count
    Game.battle.soul.row_count = self.row_count
    Game.battle.soul.loop = self.loop
    Game.battle.soul.current_column = self.current_column
    Game.battle.soul.current_row = self.current_row
    Game.battle.soul.layer = BATTLE_LAYERS["soul"]
    self.started = true
    self.timer:every(1/2, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
            local bullet = self:spawnBullet("smallbullet", x, y, angle, 8)
            bullet.damage = 99
            bullet.mhp_damage = 99
        end
    end)
    -- Game.battle.soul:setParent(Game.battle.arena.mask)
    super:onStart()
end

function CharaTest:update()
    super.update(self)
end

function CharaTest:draw()
    super.draw(self)
    if self.started then
        local arena_left = Game.battle.arena.left
        local arena_top = Game.battle.arena.top
        local arena_width = Game.battle.arena.width
        local arena_height = Game.battle.arena.height
        love.graphics.setColor(COLORS.dkgray)
        love.graphics.setLineWidth(1)
        for x=0, self.column_count-1 do
            local string_x = math.ceil(((arena_height-16)/(self.column_count-1))*x)
            if (self.loop == 3 or self.loop == 2) then
                love.graphics.rectangle("fill", arena_left + 8 + string_x, arena_top, 1, arena_height)
            else
                love.graphics.rectangle("fill", arena_left + 8 + string_x, arena_top + 8, 1, arena_height - 16)
            end
        end
        for y=0, self.row_count-1 do
            local string_y = math.ceil(((arena_width-16)/(self.row_count-1))*y)
            if (self.loop == 3 or self.loop == 1)  then
                love.graphics.rectangle("fill", arena_left, arena_top + 8 + string_y, arena_width, 1)
            else
                love.graphics.rectangle("fill", arena_left + 8, arena_top + 8 + string_y, arena_width - 16, 1)
            end
        end
        love.graphics.setColor(COLORS.white)
        for x=0, self.column_count-1 do
            for y=0, self.row_count-1 do
                local string_x = math.ceil(((arena_height-16)/(self.column_count-1))*x)
                local string_y = math.ceil(((arena_width-16)/(self.row_count-1))*y)
                if Game.battle.soul then
                    if Game.battle.soul.current_column == x+1
                    and Game.battle.soul.current_row == y+1 then
                        if self.pegalpha[x+1][y+1] > 0 then
                            self.pegalpha[x+1][y+1] = self.pegalpha[x+1][y+1] - 0.25 * DTMULT
                        end
                    else
                        if self.pegalpha[x+1][y+1] < 1 then
                            self.pegalpha[x+1][y+1] = self.pegalpha[x+1][y+1] + 0.25 * DTMULT
                        end
                    end
                end
                love.graphics.setColor(1,1,1,self.pegalpha[x+1][y+1])
                if self.loop then
                    if x == 0 and y == 0 and self.loop == 3 then
                        Draw.draw(self.loopmarkerdiag, arena_left + 5 + string_x, arena_top + 5 + string_y)
                    elseif x == self.column_count-1 and y == 0 and self.loop == 3 then
                        Draw.draw(self.loopmarkerdiag, arena_left + 12 + string_x, arena_top + 5 + string_y,0,-1,1)
                    elseif x == 0 and y == self.row_count-1 and self.loop == 3 then
                        Draw.draw(self.loopmarkerdiag, arena_left + 5 + string_x, arena_top + 12 + string_y,0,1,-1)
                    elseif x == self.column_count-1 and y == self.row_count-1 and self.loop == 3 then
                        Draw.draw(self.loopmarkerdiag, arena_left + 12 + string_x, arena_top + 12 + string_y,0,-1,-1)
                    else
                        if x == 0 and (self.loop == 3 or self.loop == 1) then
                            Draw.draw(self.loopmarker, arena_left + 5 + string_x, arena_top + 12 + string_y,math.rad(-90))
                        elseif x == self.column_count-1 and (self.loop == 3 or self.loop == 1) then
                            Draw.draw(self.loopmarker, arena_left + 12 + string_x, arena_top + 5 + string_y,math.rad(90))
                        elseif y == 0 and (self.loop == 3 or self.loop == 2) then
                            Draw.draw(self.loopmarker, arena_left + 5 + string_x, arena_top + 5 + string_y,math.rad(0))
                        elseif y == self.row_count-1 and (self.loop == 3 or self.loop == 2) then
                            Draw.draw(self.loopmarker, arena_left + 12 + string_x, arena_top + 12 + string_y,math.rad(180))
                        else
                            Draw.draw(self.posmarker, arena_left + 5 + string_x, arena_top + 5 + string_y)
                        end
                    end
                else
                    Draw.draw(self.posmarker, arena_left + 5 + string_x, arena_top + 5 + string_y)
                end
            end
        end
    end
end

return CharaTest