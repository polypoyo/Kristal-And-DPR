---@class TutorialMasterSprite: Object
local TutorialMasterSprite, super = Class(Object)

function TutorialMasterSprite:init(actor, chara, x, y)
    local prefix = actor.path.."/"..chara.."_master/"
    super.init(self, x, y)
    self.body = Sprite(prefix.."body", x, (y or 0)+40, 40, 40)
    self.body:setOrigin(0,1)
    self:addChild(self.body)
    self.hat = Sprite(prefix.."hat", x,y, 40, 40)
    self.body:addChild(self.hat)
    self.face_shocked = Sprite(prefix.."face_shocked")
    self.face_shocked.visible = false
    self:addChild(self.face_shocked)
    self.face = Sprite(prefix.."face")
    self:addChild(self.face)
end

function TutorialMasterSprite:update()
    super.update(self)
    if self.face_shocked.visible then
        self.face_shocked.x = math.sin(math.pi * Kristal.getTime() * 8) * 3
    elseif self.bop then
        self.face.x = math.sin(math.pi * Kristal.getTime() * 1) * 5
        self.face.y = math.sin(math.pi * Kristal.getTime() * 3) * 3
        self.body.scale_y = Utils.clampMap(
            math.sin(math.pi * Kristal.getTime() * 3),
            -1,1, 0.8, 1.1
        )
    end
end

function TutorialMasterSprite:setAnimation(animation)
    self.face:setPosition(0,0)
    self.body:setScale(1)
    local anim = type(animation) == "string" and animation or animation[1]
    if anim == "shocked" then
        self.face_shocked.visible = true
        self.face.visible = false
        self.bop = false
    elseif anim == "idle" then
        self.face_shocked.visible = false
        self.face.visible = true
        self.bop = false
    elseif anim == "bop" then
        self.face_shocked.visible = false
        self.face.visible = true
        self.bop = true
    end
end

return TutorialMasterSprite