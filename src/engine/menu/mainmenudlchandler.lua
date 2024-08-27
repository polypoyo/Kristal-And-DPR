---@class MainMenuDLCHandler : StateClass
---
---@field menu MainMenu
---
---@overload fun(menu:MainMenu) : MainMenuDLCHandler
local MainMenuDLCHandler, super = Class(StateClass)

function MainMenuDLCHandler:init(menu)
    self.menu = menu

    self.list = nil

    self.dlcs = {}

    self.loading_dlcs = false

    self.active = false
end

function MainMenuDLCHandler:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    --self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function MainMenuDLCHandler:onEnter()
	self.active = true

	self.menu.heart_target_x = -16
	self.menu.heart_target_y = -16
end

function MainMenuDLCHandler:onLeave()
	self.active = false
end

function MainMenuDLCHandler:onKeyPressed(key, is_repeat)
	if Input.isConfirm(key) and not is_repeat then
		Assets.stopAndPlaySound("ui_select")
		love.system.openURL("file://"..love.filesystem.getSource().."/mods")
	elseif Input.isCancel(key) then
		Assets.stopAndPlaySound("ui_move")

        self.menu:setState("TITLE")
        self.menu.title_screen:selectOption("dlc")
        return true
    end
end

function MainMenuDLCHandler:draw()
	Draw.printShadow("Work In Progress!", 0, 115 + 30, 2, "center", 640)
	Draw.printShadow("Come back later!", 0, 115 + 30*2, 2, "center", 640)

	Draw.printShadow("Press "..Input.getText("confirm").." to open the DLC folder.", 0, 115 + 30*4, 2, "center", 640)
	Draw.printShadow("Press "..Input.getText("cancel").." to return", 0, 115 + 30*5, 2, "center", 640)
end

return MainMenuDLCHandler