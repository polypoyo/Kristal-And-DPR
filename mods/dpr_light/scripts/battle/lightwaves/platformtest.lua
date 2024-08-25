local platformtest, super = Class(LightWave)

function platformtest:onStart()
    local x, y = Game.battle.arena:getCenter()
    self.platform = self:spawnObject(BlueSoulPlatform(50), x, y + 15)
end

function platformtest:update()
    self.platform.x = self.platform.x + 0.5 * DTMULT
    super.update(self)
end

function platformtest:canEnd()
    return false
end

return platformtest