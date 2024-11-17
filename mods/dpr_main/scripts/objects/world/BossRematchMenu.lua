---@class BossRematchMenu : Object
local BossRematchMenu, super = Class(Object)

function BossRematchMenu:init(options)
    super.init(self, SCREEN_WIDTH / 2 - 480 / 2, SCREEN_HEIGHT / 2 - 320 / 2, 480, 320)

    self.options = options or {}
    self.parallax_x = 0
    self.parallax_y = 0

    self.draw_children_below = 0

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)

    self.font = Assets.getFont("main")
    self.font_2 = Assets.getFont("plain")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.up_sprite = Assets.getTexture("ui/page_arrow_up")
    self.down_sprite = Assets.getTexture("ui/page_arrow_down")
    self.soul = Assets.getTexture("player/heart")
    self.gradient = Assets.getTexture("ui/char_gradient") or self.soul

    self.currently_selected = 1
    self.page = 1
    self.line_height = 30
    self.item_color_unk = {0.5, 0.5, 0.5}
    self.item_color = {1, 1, 1}

    local encs = {}
    for mod_id, mod in pairs(Kristal.Mods.data) do
        if mod.dlc and mod.dlc.bosses then
            for boss_id, boss in pairs(mod.dlc.bosses) do
                local t = Utils.copy(boss)
                t.mod = t.mod or mod_id
                table.insert(encs, t)
            end
        end
    end
    -- preview is a table. First index is a sprite path, second is the X offset, third is the Y offset.
    -- Each page has room for 8 entries. Any more than that, and you'll either have text overlapping or text going off the UI box.
    self.encounters = {}
    for i, value in ipairs(encs) do
        local page = math.floor(i/8) + 1
        if self.encounters[page] == nil then self.encounters[page] = {} end
        table.insert(self.encounters[page], value)
        value.flag = value.flag or ("encounter#"..value.mod.."/"..value.encounter..":done")
        if value.preview then
            local path = value.preview
            if type(path) == "table" then path = path[1] end
            local image = love.graphics.newImage(Kristal.Mods.data[value.mod].path.."/"..path)
            value.preview = {image, value.preview[2] or 0, value.preview[3] or 0}
        end
    end

	self.bosses = {}
    
    for i, _ in ipairs(self.encounters) do
	    for n, v in ipairs(self.encounters[i]) do
		    if self:isUnlocked(v) then
			    table.insert(self.bosses, v.encounter)
		    end
	    end
    end

end

---@return boolean
function BossRematchMenu:isUnlocked(boss)
    if self.options.all_unlocked then return true end
    return Game:getFlag(boss.flag)
end

function BossRematchMenu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.printf("Bosses", 0, 0, self.width, "center")
    love.graphics.setFont(self.font_2)
    love.graphics.printf("Press [R] to fight all bosses in a boss rush.", 0, 300, self.width, "center")

    local entry = self.encounters[self.page][self.currently_selected]
	
    if self:isUnlocked(entry) and entry.grad_color then
	    love.graphics.setColor(entry.grad_color)
    end

    love.graphics.draw(self.gradient, 260, 50)

    if self:isUnlocked(entry) then
	    love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0, 0, 0)
    end
	
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 260, 50, 200, 140)

    if self:isUnlocked(entry) and entry.preview then
        local preview = entry.preview
        local canvas = Draw.pushCanvas(200, 140)
        love.graphics.draw(preview[1], preview[2], preview[3], 0, (entry.name == "Omega Spamton" and 1 or 2))
        Draw.popCanvas()
        Draw.draw(canvas, 260, 50)
    end

    local y_off = 16

    love.graphics.setFont(self.font_2)
    love.graphics.setColor(1, 0, 0)
    love.graphics.draw(self.soul, 0, y_off + self.line_height * self.currently_selected)
    love.graphics.setColor(1, 1, 1)

    local line_x = 24
    local line_y = y_off + self.line_height * 1
    for _, encounter in ipairs(self.encounters[self.page]) do
        if self:isUnlocked(encounter) then
            love.graphics.setColor(unpack(self.item_color))
            love.graphics.print(encounter.name, line_x, line_y)
        else
            love.graphics.setColor(unpack(self.item_color_unk))
            love.graphics.print(string.rep("?", utf8.len(encounter.name)), line_x, line_y)
        end
        love.graphics.setColor(1, 1, 1)
        line_y = line_y + self.line_height
    end

    love.graphics.setColor(1, 1, 1)
    if self.page > 1 then
        love.graphics.draw(self.up_sprite, 230, -10, 0, 1, 1)
    end
    if self.page < #self.encounters then
        love.graphics.draw(self.down_sprite, 230, 262, 0, 1, 1)
    end

    super.draw(self)
end

function BossRematchMenu:onKeyPressed(key, is_repeat)
    if Input.isMenu(key) or Input.isCancel(key) then
        self.ui_cancel_small:stop()
        self.ui_cancel_small:play()
        Game.world:closeMenu()
        return
    end

    if Input.is("up", key) then
        if self.currently_selected > 1 then
            self.currently_selected = self.currently_selected - 1
            self.ui_move:stop()
            self.ui_move:play()
        elseif self.page > 1 then
        self.page = self.page - 1
        self.currently_selected = #self.encounters[self.page]
        self.ui_move:stop()
        self.ui_move:play()
        elseif not is_repeat then
            self.currently_selected = #self.encounters[self.page]
            self.ui_move:stop()
            self.ui_move:play()
        end
    end
    if Input.is("down", key) then
        if self.currently_selected < #self.encounters[self.page] then
            self.currently_selected = self.currently_selected + 1
            self.ui_move:stop()
            self.ui_move:play()
        elseif self.page < #self.encounters then
            self.currently_selected = 1
            self.page = self.page + 1
            self.ui_move:stop()
            self.ui_move:play()
        elseif not is_repeat then
            self.currently_selected = 1
            self.ui_move:stop()
            self.ui_move:play()
        end
    end
    if Input.pressed("confirm") then
        local entry = self.encounters[self.page][self.currently_selected]
        if self:isUnlocked(entry) then
            self.ui_select:stop()
            self.ui_select:play()
            Game.world:closeMenu()
            Game.bossrush_encounters = {entry.encounter}
            Game:swapIntoMod(Game:getBossRef(Game.bossrush_encounters[1]).mod)
        else
            self.ui_cant_select:stop()
            self.ui_cant_select:play()
        end
    end
    if Input.pressed("r") then
        self.ui_select:stop()
        self.ui_select:play()
        Game.world:closeMenu()
        Game.bossrush_encounters = Utils.copy(self.bosses)
        Game:swapIntoMod(Game:getBossRef(Game.bossrush_encounters[1]).mod)
    end
end

function BossRematchMenu:close()
    Game.world.menu = nil
    self:remove()
end

return BossRematchMenu
