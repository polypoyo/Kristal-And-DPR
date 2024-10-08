local GridSoul, super = Class(Soul)

function GridSoul:init(x, y)
    super:init(self, x, y)

    self.color = COLORS.ltgray
	
	-- Variables that can be changed
    self.column_count = 4
    self.row_count = 4

    self.loop = false               -- Will going below or above the strings put you to the other end? [boolean] (true; false)
	
	self.current_column = 2         -- The current string of the soul [real] (any number)
	self.current_row = 2         -- The current string of the soul [real] (any number)
    self.goal_x = self.y            -- The x or y value the soul is moving towards [real] (any number)
    self.goal_y = self.y            -- The x or y value the soul is moving towards [real] (any number)
end

function GridSoul:doMovement()
    local speed = self.speed

    -- Do speed calculations here if required.

    local move_x, move_y = 0, 0

    if Input.down("cancel") then speed = speed / 2 end -- Focus mode.

    if Input.pressed("up")  then self.current_row = self.current_row - 1 end
    if Input.pressed("down")  then self.current_row = self.current_row + 1 end

    if Input.pressed("left")  then self.current_column = self.current_column - 1 end
    if Input.pressed("right")  then self.current_column = self.current_column + 1 end

    self:stringStuff()

    local arena_left = Game.battle.arena.left
    local arena_top = Game.battle.arena.top
    local arena_width = Game.battle.arena.width
    local arena_height = Game.battle.arena.height

    for x=0, self.column_count-1 do
        local string_x = arena_left + 8+math.ceil(((arena_width-16)/(self.column_count-1))*x)
        if self.current_column == x+1 then self.goal_x = string_x end
    end
    for y=0, self.row_count-1 do
        local string_y = arena_top + 8+math.ceil(((arena_height-16)/(self.row_count-1))*y)
        if self.current_row == y+1 then self.goal_y = string_y end
    end

    if self.x < self.goal_x then
        if math.abs(self.x - self.goal_x) < 10 then
            move_x = 0
            self.x = self.goal_x
        else move_x = -((self.x - self.goal_x)/2.4)+1 end
    end
    if self.x > self.goal_x then
        if math.abs(self.x - self.goal_x) < 10 then
            move_x = 0
            self.x = self.goal_x
        else move_x = (((self.goal_x - self.x)/2.4)+1) end
    end
    if self.y < self.goal_y then
        if math.abs(self.y - self.goal_y) < 10 then
            move_y = 0
            self.y = self.goal_y
        else move_y = -((self.y - self.goal_y)/2.4)+1 end
    end
    if self.y > self.goal_y then
        if math.abs(self.y - self.goal_y) < 10 then
            move_y = 0
            self.y = self.goal_y
        else move_y = (((self.goal_y - self.y)/2.4)+1) end
    end

    self:move(move_x, move_y, DTMULT)
    self.moving_x = move_x
    self.moving_y = move_y
end

function GridSoul:stringStuff()
    if self.loop == 1 then
        if (self.current_column < 1) then self.current_column = self.column_count end
        if (self.current_column > self.column_count) then self.current_column = 1 end
        if (self.current_row < 1) then self.current_row = 1 end
        if (self.current_row > self.row_count - 1) then self.current_row = self.row_count end
    elseif self.loop == 2 then
        if (self.current_column < 1) then self.current_column = 1 end
        if (self.current_column > self.column_count - 1) then self.current_column = self.column_count end
        if (self.current_row < 1) then self.current_row = self.row_count end
        if (self.current_row > self.row_count) then self.current_row = 1 end
    elseif self.loop == 3 then
        if (self.current_column < 1) then self.current_column = self.column_count end
        if (self.current_column > self.column_count) then self.current_column = 1 end
        if (self.current_row < 1) then self.current_row = self.row_count end
        if (self.current_row > self.row_count) then self.current_row = 1 end
    else
        if (self.current_column < 1) then self.current_column = 1 end
        if (self.current_column > self.column_count - 1) then self.current_column = self.column_count end
        if (self.current_row < 1) then self.current_row = 1 end
        if (self.current_row > self.row_count - 1) then self.current_row = self.row_count end
    end
end

function GridSoul:draw()
    local r,g,b,a = self:getDrawColor()
    local heart_texture = Assets.getTexture(self.sprite.texture_path)
    local heart_w, heart_h = heart_texture:getDimensions()

    super:draw(self)
    self.color = {r,g,b}
end

return GridSoul