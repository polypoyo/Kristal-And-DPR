local PartySelectMenu, super = Class(Object)

function PartySelectMenu:init(selected)
    super.init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")

    self.heart_sprite = Sprite("player/heart")
	self.heart_sprite:setOrigin(0.5, 0.5)

    self.up = Assets.getTexture("ui/page_arrow_up")
    self.down = Assets.getTexture("ui/page_arrow_down")

    self.bg = UIBox(100, 100, 440, 300)
    self.bg.layer = -1

    self:addChild(self.bg)

	self.slot_selected = selected or 1

	self.char = Game.party[selected]

	self.unlocked = Game:getFlag("_unlockedPartyMembers")

	self.unlocked = {"hero", "susie", "dess", "noelle"}

	self.deltarune = {"kris", "susie", "ralsei", "noelle", "berdly"}

	self.dark_place = {"hero", "dess"}

	self.character_menus = {
		["DELTARUNE"] = self.deltarune,
		["[color:#7F00FF]Dark Place"] = self.dark_place
	}

	for i, menu in pairs(self.character_menus) do
		local has_unlocked = false
		for _, character in ipairs(menu) do
			if table.concat(self.unlocked, " "):find(character) then
				has_unlocked = true
				break
			end
		end
		if not has_unlocked then
			self.character_menus[i] = nil
		end
	end

	self.text = Text("")
	self:addChild(self.text)
	self.text.x = 240
	self.text.y = 80

	self.selected_menu = 1

	self.state = "menu_select"
	self.character_index = {}

	self:selection(0)

end

function PartySelectMenu:selection(num)
	if self.state == "menu_select" then

		for i, sprite in ipairs(self.character_index) do
			self.character_index[sprite] = nil
			sprite:remove()
		end
	
		self.character_index = {}
		
		self.selected_menu = self.selected_menu + num
	
		local menus = {}

		for k in pairs(self.character_menus) do
			table.insert(menus, k)
		end
	
		local max = #menus
	
		if self.selected_menu > max then
			self.selected_menu = 1
		elseif self.selected_menu <= 0 then
			self.selected_menu = max
		end
	
		self.text:setText(menus[self.selected_menu])

		local menu_name = menus[self.selected_menu] 
		local table = self.character_menus[menu_name] 
		
		for i, party in ipairs(table) do

			local unlocked = false
	
			for _, key in ipairs(self.unlocked) do
				if key == party then
					unlocked = true
					break
				end
			end
			local path = "ui/menu/party/"
			local sprite = Sprite(path.."unknown")
	
			if unlocked then
				sprite:setSprite(path..party)
				sprite.icon_path = path..party
			else
				sprite:setSprite(path.."unknown")
			end
			local offset = 40
			local x = 270 - offset + (i * offset)
	
			sprite.x = x
	
			sprite.y = 130
	
			sprite:setOrigin(0.5, 0.5)
	
			self:addChild(sprite)
			self.character_index[i] = sprite
		end
	end
	
end

function PartySelectMenu:update()
	super.update(self)

	if Input.pressed("left", true) then
		self:selection(-1)

	elseif Input.pressed("right", true) then
		self:selection(1)

	elseif Input.pressed("cancel") then

		Game.world:openMenu(CharacterMenu(self.slot_selected))

	elseif Input.pressed("confirm") then
		if self.ready then
			self.ui_select:play()
		else
			self.ready = true
		end

	elseif Input.pressed("menu") then
	end
end

function PartySelectMenu:draw()
    super.draw(self)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(6)
	--local y = 300
	--love.graphics.line(80, y, 560, y)
    local x = 220
	love.graphics.line(x, 80, x, 420)

end

return PartySelectMenu