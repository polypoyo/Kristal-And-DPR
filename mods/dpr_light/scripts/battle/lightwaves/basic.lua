local Basic, super = Class(LightWave)

function Basic:onStart()
    -- Every 0.33 seconds...
    self.timer:every(1/3, function()
        -- Our X position is offscreen, to the right
        local x = Game.battle.arena.right + 15
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnRelativeMaskedBullet("smallbullet", x, y, math.rad(180), 4)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic