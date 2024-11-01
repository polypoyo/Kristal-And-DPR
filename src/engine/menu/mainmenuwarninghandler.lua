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

    self.active = false
end

function MainMenuWarningHandler:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    --self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
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
	if Input.isConfirm(key) and not is_repeat then
		Assets.stopAndPlaySound("ui_select")
		Assets.stopAndPlaySound("ui_spooky_action")

        self.menu:setState("TITLE")
        self.menu.title_screen:selectOption("dlc")
        return true
    end
end

function MainMenuWarningHandler:draw()
    Draw.setColor(COLORS.black)
    Draw.rectangle("fill", 0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
    Draw.setColor(COLORS.white)
	Draw.printShadow("WARNING", 0, 115 + 30, 2, "center", 640)
	Draw.printShadow(self.current_warning or "afodsjoewjko", 0, 115 + 30*2, 2, "center", 640)

	Draw.printShadow("Press "..Input.getText("confirm").." to accept.", 0, 115 + 30*5, 2, "center", 640)
end

return MainMenuWarningHandler