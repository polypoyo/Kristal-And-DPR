---@class MainMenuWarningHandler : StateClass
---
---@field menu MainMenu
---@field container Object
---
---@overload fun(menu:MainMenu) : MainMenuWarningHandler
local MainMenuWarningHandler, super = Class(StateClass)

function MainMenuWarningHandler:init(menu)
    self.menu = menu

    self.list = nil

    self.warnings = Utils.split(love.filesystem.read("assets/warning.txt"), "\n")
    -- Removes the last item and errors if that wasn't a blank line
    assert(table.remove(self.warnings, #self.warnings) == "", "No final newline on warnings.txt!")
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
        return
    elseif self.animation_clock >= 0 then
        self.animation_clock = self.animation_clock + DT
        self.container:setScale(Utils.clampMap(
            self.animation_clock, 0, 1.3, 1, 0.2
        ), Utils.clampMap(
            self.animation_clock, 0, 1.3, 1, 0.0
        ))
        local luma = Utils.clampMap(
            self.animation_clock, 0, 1.3, 1, 0
        )
        self.container:setColor(luma,luma,luma)
    end
end

function MainMenuWarningHandler:onEnter()
    self.menu.music:pause()
	self.active = true
    local options = {align = "center"}
    self.container = self.menu.stage:addChild(Object(0,0,SCREEN_WIDTH, SCREEN_HEIGHT))
    self.container:setScaleOrigin(0.5, 0.5)
    self.text_warn = self.container:addChild(Text("asdf", 0, 115 + 30, options))
    self.text_warn.inherit_color = true
    self.text_contents = self.container:addChild(Text("", 0, 115 + 30*2, options))
    self.text_contents.inherit_color = true
    self.text_accept = self.container:addChild(Text("", 0, 115 + 30*5, options))
    self.text_accept.inherit_color = true
    self:updateTexts()
	self.menu.heart_target_x = -640
	self.menu.heart_target_y = 270
end

function MainMenuWarningHandler:onLeave()
    self.menu.music:play()
	self.active = false
    self.container:remove()
    self.container = nil
end

function MainMenuWarningHandler:updateTexts()
    self.text_warn:setText("WARNING")
    self.text_contents:setText(self.current_warning)
    self.text_accept:setText("Press "..Input.getText("confirm").. (Input.usingGamepad() and "" or " ").. "to accept.")
end

function MainMenuWarningHandler:onKeyPressed(key, is_repeat)
    self:updateTexts()
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
end

return MainMenuWarningHandler