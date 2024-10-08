local actor, super = Class(Actor, "the_house")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "The House"

    -- Width and height for this actor, used to determine its center
    self.width = 27
    self.height = 45

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 25, 19, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "battle/enemies/the_house"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        -- Looping animation with 0.25 seconds between each frame
        -- (even though there's only 1 idle frame)
        ["idle"] = {"idle", 0.25, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = {0, 0},
    }
end

function actor:onSpriteInit(sprite)
    sprite.shadow_timer = 0
    sprite.shadow_alpha = 0
    sprite.disable_shadow = true
end

function actor:onSpriteUpdate(sprite)
    sprite.shadow_timer = sprite.shadow_timer + (1 * DTMULT)
    if sprite.disable_shadow then
        sprite.shadow_alpha = sprite.shadow_alpha - (0.08 * DTMULT)
        if sprite.shadow_alpha <= 0 then
            sprite.shadow_alpha = 0
        end
    else
        sprite.shadow_alpha = sprite.shadow_alpha + (0.08 * DTMULT)
        if sprite.shadow_alpha >= 1 then
            sprite.shadow_alpha = 1
        end
    end
end

function actor:onSpriteDraw(sprite)
    local offset = sprite:getOffset()
    local fly = math.sin(sprite.shadow_timer / 8) * 3
    love.graphics.setColor(0,0,0,sprite.shadow_alpha)
    love.graphics.rectangle("fill", offset[1]-fly/2, offset[2]+60-fly+(fly/2), 40+fly, 5+(fly/2))
end

return actor