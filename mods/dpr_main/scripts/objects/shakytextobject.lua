local shakytextobject, super = Class(Object)

function shakytextobject:init(x, y, text)
    super.init(self)

    self.height = 40
    self.width = 40

    self.x = x
    self.y = y
    self.font = Assets.getFont("main")
    self.text = text or "no_text"
   print("haha")
    --self.wrap_texture_x = true
    --self:setScale(1)

    --self.parallax_x = 0
    --self.parallax_y = 0

end

function shakytextobject:draw()
    super.draw(self)

    love.graphics.setFont(self.font)
    Draw.setColor(1, 1, 1, 1)

    love.graphics.print(self.text, math.random(-1, 1), math.random(-1, 1))
end

return shakytextobject
