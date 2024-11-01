---@class MainMenuWarningHandler : StateClass
---
---@field menu MainMenu
---
---@overload fun(menu:MainMenu) : MainMenuWarningHandler
local MainMenuWarningHandler, super = Class(StateClass)

function MainMenuWarningHandler:init(menu)
    self.menu = menu

    self.list = nil

    self.warnings = Utils.split(love.filesystem.read("assets/warning.txt"), "\n")
    if Kristal.Config["seenLegitWarning"] then
        self.current_warning = Utils.pick(self.warnings)
    else
        self.current_warning = "May contain swears/profanity"
        Kristal.Config["seenLegitWarning"] = true
    end

    self.loading_dlcs = false

    self.animation_clock = -1
    self.active = false
end

function MainMenuWarningHandler:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function MainMenuWarningHandler:update()
    if self.animation_clock > 2 then
        self.menu:setState("TITLE")
        self.menu.title_screen:selectOption("play")
    elseif self.animation_clock >= 0 then
        self.animation_clock = self.animation_clock + DT
    end
end

function MainMenuWarningHandler:onEnter()
    self.menu.music:pause()
	self.active = true

	self.menu.heart_target_x = -640
	self.menu.heart_target_y = 270
end

function MainMenuWarningHandler:onLeave()
    self.menu.music:play()
	self.active = false
end

function MainMenuWarningHandler:onKeyPressed(key, is_repeat)
	if Input.isConfirm(key) and not is_repeat and self.animation_clock < 0 then
		Assets.stopAndPlaySound("ui_select")
		Assets.stopAndPlaySound("ui_spooky_action")
        self.animation_clock = 0

        return true
    end
end

function MainMenuWarningHandler:draw()
    Draw.setColor(COLORS.black)
    Draw.rectangle("fill", 0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.push()
    love.graphics.translate(SCREEN_WIDTH/2,SCREEN_HEIGHT/2)
    love.graphics.scale(Utils.clampMap(
        self.animation_clock, 0, 1.3, 1, 0.2
    ), Utils.clampMap(
        self.animation_clock, 0, 1.3, 1, 0.0
    ))
    love.graphics.translate(-SCREEN_WIDTH/2,-SCREEN_HEIGHT/2)
    Draw.setColor(COLORS.white, Utils.clampMap(
        self.animation_clock, 0, 1.3, 1, 0
    ))
	Draw.printShadow("WARNING", 0, 115 + 30, 2, "center", 640)
	Draw.printShadow(self.current_warning or "afodsjoewjko", 0, 115 + 30*2, 2, "center", 640)

	Draw.printShadow("Press "..Input.getText("confirm").." to accept.", 0, 115 + 30*5, 2, "center", 640)
    love.graphics.pop()
end

return MainMenuWarningHandler