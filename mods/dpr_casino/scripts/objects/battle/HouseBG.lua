local HouseCarousel, C_super = Class(Object)

HouseCarousel.COLORS = {
    {200/255, 0/255, 100/255},
    {255/255, 100/255, 50/255},
}

function HouseCarousel:init()
    C_super:init(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    self.layer = BATTLE_LAYERS["bottom"] + 10

    self.points = {}
    for i=1,8 do
        table.insert(self.points, {
            angle = i*math.pi/4,
            color = self.COLORS[i%2+1],
            fg = false,
        })
    end
	
    self.bgx = 0
    self.on = false
    self.bgalpha = 0
    self.rotfps = 1
    self.rotspeed = 0
    self.rot = 0
    self.rotcounter = 0

    self.dkblue3 = Utils.mergeColor(COLORS.navy, COLORS.dkgray, 0.5)
    self.dkblue3 = Utils.mergeColor(self.dkblue3, COLORS.black, 0.2)
end

function HouseCarousel:update()
    C_super:update(self)


    if self.on then
        self.rotcounter = self.rotcounter + DTMULT
    end
    if self.rotcounter >= self.rotfps and self.on then
        if (self.on and self.rotspeed < 1) then
            self.rotspeed = self.rotspeed + 0.1*DTMULT
        end
        self.bgx = self.bgx + DTMULT*self.rotfps
        self.rot = self.rot + ((2.5 * self.rotfps) * self.rotspeed * DTMULT)
        self.rotcounter = 0
    end
    for _,point in ipairs(self.points) do
        point.angle = (point.angle-((self.rotspeed*0.05)*DTMULT))%(2*math.pi)
    end
end

function HouseCarousel:draw()
    C_super:draw(self)
	
    local curx = 0
    local curl = (0 + self.bgx)

    if (self.bgx >= 640) then
        self.bgx = self.bgx - 640
    end

    local curscale = 1
    local tempscale = 0
    local curw = 5
	
    if (self.on == 1) then
        if (self.bgalpha < 1) then
            self.bgalpha = self.bgalpha + 0.02
        end
    end
    if (self.on == 0) then
        if (self.bgalpha > 0) then
            self.bgalpha = self.bgalpha - 0.02
        end
    end
    self.dkblue3[4] = self.bgalpha
	
    --[[for i=0,15 do
	    love.graphics.setColor(self.dkblue3)
        Draw.drawPart(Assets.getTexture("battle/bg/carouselbg"), curx - 320, - 240, curl, 0, curw, 300, 0, curscale, 1)
		
        tempscale = (1 + (0.5 * i))
        curscale = math.floor(tempscale)
        curl = curl + 5
        if curl >= 640 then
            curl = curl - 640
        end
        curw = 5
        curx = curx + ((5 * curscale) - 5)
    end
	
    for i=16,1, -1 do
	    love.graphics.setColor(self.dkblue3)
        Draw.drawPart(Assets.getTexture("battle/bg/carouselbg"), curx - 320, - 240, curl, 0, curw, 300, 0, curscale, 1)
		
        tempscale = (1 + (0.5 * i))
        if tempscale < 1 then
            tempscale = 1
        end
        curscale = math.ceil(tempscale)
        curl = curl + 5
        if curl >= 640 then
            curl = curl - 640
        end
        curw = 5
        curx = curx + ((5 * curscale) - 5)
    end]]

    for i,point in ipairs(self.points) do
        local x, y = math.cos(point.angle)*360, math.sin(point.angle)*120
        local np = self.points[i%8+1]
        local nx, ny = math.cos(np.angle)*360, math.sin(np.angle)*120

        love.graphics.setColor(point.color)
        love.graphics.polygon("fill", 
            0, 0,
            x, y,
            nx, ny
        )
        point.fg = nx < x
    end
    
    for i,point in ipairs(self.points) do
        if not point.fg then
            local x, y = math.cos(point.angle)*60, math.sin(point.angle)*20
            local np = self.points[i%8+1]
            local nx, ny = math.cos(np.angle)*60, math.sin(np.angle)*20

            if Utils.sign(y) ~= Utils.sign(ny) then
                love.graphics.setColor(point.color)
                love.graphics.polygon("fill", 
                    0, -80,
                    x, y,
                    nx, ny
                )
            end
        end
    end
    for i,point in ipairs(self.points) do
        if point.fg then
            local x, y = math.cos(point.angle)*60, math.sin(point.angle)*20
            local np = self.points[i%8+1]
            local nx, ny = math.cos(np.angle)*60, math.sin(np.angle)*20

            love.graphics.setColor(point.color)
            love.graphics.polygon("fill", 
                0, -80,
                x, y,
                nx, ny
            )
        end
    end
	
    love.graphics.setColor(0,0,0, Game.battle.background_fade_alpha)
    love.graphics.rectangle("fill", -320, -240, SCREEN_WIDTH, SCREEN_HEIGHT)
end

return HouseCarousel