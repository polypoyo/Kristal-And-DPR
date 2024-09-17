local WarpBin, super = Class(Event)

function WarpBin:init(data)
    super.init(self, data.x, data.y, data.width, data.height)

    self.solid = true

    local properties = data.properties or {}

    --TO-DO: find a way to make these sprites customizable.
    self.sprite_a = Sprite("world/events/warpbin/warp_bin", 1/5)
    
    --self.sprite_a:setSprite("world/events/warpbin/warp_bin", 1/5)
    self.sprite_a.debug_select = false

    self.sprite_a:setScale(2)

    --self.sprite_a.x = -1
    self.sprite_a.y = -50
    self:addChild(self.sprite_a)

    
end

function WarpBin:onInteract()
    Game.world:startCutscene("warp_bin")
end


function WarpBin:draw()
    --Draw.scissor(self.sprite_frame.x, self.sprite_frame.y, self.sprite_frame.width*2-20, self.sprite_frame.height*2)
    super.draw(self)
    --love.graphics.setScissor()
    --love.graphics.draw(Assets.getTexture("world/events/WarpBin/floor1/frame"), 15, -65, 0, 2, 2)
end

return WarpBin