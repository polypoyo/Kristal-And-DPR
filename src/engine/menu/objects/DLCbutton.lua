local DLCButton, super = Class(ModButton, nil, "DLCButton")

function DLCButton:init(name, width, height, mod)
	super:init(self, name, width, height, mod)

end

function DLCButton:update()
	super:update(self)

	if not self.selected then
		self.x = Utils.approach(self.x, 25, 4*DTMULT)
	else
		self.x = Utils.approach(self.x, 0, 4*DTMULT)
	end
end

function DLCButton:draw()
    -- Get the position for the mod icon
    local ix, iy = self:getIconPos()

    -- Draw the transparent backgrounds
    Draw.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    -- Draw the icon background
    love.graphics.rectangle("fill", ix, iy, self.height, self.height)

    -- Draw the rectangle outlines
    self:drawCoolRectangle(0, 0, self.width, self.height)
    self:drawCoolRectangle(ix, iy, self.height, self.height)

    -- Draw text inside the button rectangle
    Draw.pushScissor()
    Draw.scissor(0, 0, self.width, self.height)
    -- Make name position higher if we have a subtitle
    local name_y = math.floor((self.height/2 - self.font:getHeight()/2) / 2) * 2
    love.graphics.setFont(self.font)
    -- Draw the name shadow
    Draw.setColor(0, 0, 0)
    love.graphics.print(self.name, 10 + 2, name_y + 2)
    -- Draw the name
    Draw.setColor(self:getDrawColor())
    love.graphics.print(self.name, 10, name_y)

    -- Set the font to the small font
    love.graphics.setFont(self.subfont)

    Draw.popScissor()

    -- Draw icon
    local icon = self.icon[math.floor(self.icon_frame)]
    if icon then
        local x, y = ix + self.height/2 - icon:getWidth(), iy + self.height/2 - icon:getHeight()
        -- Draw the icon shadow
        Draw.setColor(0, 0, 0)
        Draw.draw(icon, x + 2, y + 2, 0, 2, 2)
        -- Draw the icon
        Draw.setColor(self:getDrawColor())
        Draw.draw(icon, x, y, 0, 2, 2)
    end
end

return DLCButton