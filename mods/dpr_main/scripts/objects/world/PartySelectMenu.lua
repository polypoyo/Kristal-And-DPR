local PartySelectMenu, super = Class(Object)

function PartySelectMenu:init(selected)
    super.init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
	self.ui_cancel = Assets.newSound("ui_cancel")
	self.ui_cancel_small = Assets.newSound("ui_cancel_small")

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

	self.deltarune = {"kris", "susie", "ralsei", "noelle"}

	self.dark_place = {"hero", "dess", "brenda", "jamm", "noel"}

	self.fangames = {"ceroba", "pauling"}

	self.misc = {"mario"}

	self.character_menus = {
		["DELTARUNE"] = self.deltarune,
		["[color:#7F00FF]Dark Place"] = self.dark_place,
		["Fangames"] = self.fangames,
		["Miscelanious"] = self.misc
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

	self.party_selected = 1
	local party = Game.party[self.slot_selected]

	if party then
		local sprite = Sprite(party.actor.path .. "/" .. party.actor.default .. "/down")
	
		local x = self.bg.x + 55
		sprite:setOrigin(0.5, 0.5)
		local y = self.bg.y + 50
		
		sprite:setScale(2)
		sprite.x = x
		sprite.y = y
	
		sprite.party = party
		
		self:addChild(sprite)
	
		if party.actor.menu_anim then
			sprite:setSprite(party.actor.path .. "/" .. party.actor.menu_anim)
		end
	end
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

	if self.state == "menu_select" then
		if Input.pressed("left", true) then
			self:selection(-1)
			self.ui_move:stop()
			self.ui_move:play()
		elseif Input.pressed("right", true) then
			self:selection(1)
			self.ui_move:stop()
			self.ui_move:play()
		elseif Input.pressed("cancel") then
			Game.world:openMenu(CharacterMenu(self.slot_selected))
			self.ui_cancel_small:stop()
			self.ui_cancel_small:play()
		elseif Input.pressed("confirm") then
			if self.ready then
				self.ui_select:stop()
				self.ui_select:play()
				Input.clear()
				self.party_selected = 1
				self.state = "party_select"
			else
				self.ready = true
			end
		elseif Input.pressed("menu") then
		end
	end
	if self.state == "party_select" then
		for i, v in ipairs(self.character_index) do
			local menus = {}

			for k in pairs(self.character_menus) do
				table.insert(menus, k)
			end

			local menu_name = menus[self.selected_menu]
			local menu = self.character_menus[menu_name]

			local party = menu[i]

			local unlocked = false
	
			for _, key in ipairs(self.unlocked) do
				if key == party then
					unlocked = true
					break
				end
			end
			local path = "ui/menu/party/"
			local sprite = v

			if i == self.party_selected then
				if unlocked then
					sprite:setSprite(path..party.."_h")
					sprite.icon_path = path..party.."_h"
				else
					sprite:setSprite(path.."unknown_h")
				end
			else
				if unlocked then
					sprite:setSprite(path..party)
					sprite.icon_path = path..party
				else
					sprite:setSprite(path.."unknown")
				end
			end
		end
		if Input.pressed("left", true) then
			if self.party_selected > 1 then
				self.ui_move:stop()
				self.ui_move:play()
				self.party_selected = self.party_selected - 1
			end
		end
		if Input.pressed("right", true) then
			local menus = {}
	
			for k in pairs(self.character_menus) do
				table.insert(menus, k)
			end

			local menu_name = menus[self.selected_menu]
			local menu = self.character_menus[menu_name]
			if self.party_selected < #menu then
				self.ui_move:stop()
				self.ui_move:play()
				self.party_selected = self.party_selected + 1
			end
		end
		if Input.pressed("confirm") then
			local can_select = true

			local menus = {}

			for k in pairs(self.character_menus) do
				table.insert(menus, k)
			end

			local menu_name = menus[self.selected_menu]
			local menu = self.character_menus[menu_name]

			local party = menu[self.party_selected]

			local unlocked = false
	
			for _, key in ipairs(self.unlocked) do
				if key == party then
					unlocked = true
					break
				end
			end

			for i, v in ipairs(Game.party) do
				if v.id == party then
					can_select = false
				end
			end

			if can_select and unlocked then
				self.ui_select:stop()
				self.ui_select:play()
				local party_member = Game:getPartyMember(party)
				if Game.party[self.slot_selected] then
					Game.party[self.slot_selected] = party_member
					if self.slot_selected > 1 then
						Game.world.followers[self.slot_selected - 1]:setActor(Game.party[self.slot_selected]:getActor())
					else
						Game.world.player:setActor(Game.party[1]:getActor())
					end
				else
					Game:addPartyMember(party)
					if self.slot_selected > 1 then
						if Game.world.followers[self.slot_selected - 1] then
							Game.world.followers[self.slot_selected - 1]:setActor(Game.party[self.slot_selected]:getActor())
						else
							local follower = Game.world:spawnFollower(party)
							follower:setActor(Game.party[self.slot_selected]:getActor())
							follower:setFacing("down")
						end
					end
				end
			else
				self.ui_cant_select:stop()
				self.ui_cant_select:play()
			end
		end
		if Input.pressed("cancel") then
			for i, v in ipairs(self.character_index) do
				local menus = {}
	
				for k in pairs(self.character_menus) do
					table.insert(menus, k)
				end
	
				local menu_name = menus[self.selected_menu]
				local menu = self.character_menus[menu_name]
	
				local party = menu[i]
	
				local unlocked = false
		
				for _, key in ipairs(self.unlocked) do
					if key == party then
						unlocked = true
						break
					end
				end
				local path = "ui/menu/party/"
				local sprite = v
	
				if i == self.party_selected then
					if unlocked then
						sprite:setSprite(path..party)
						sprite.icon_path = path..party
					else
						sprite:setSprite(path.."unknown")
					end
				end
			end
			self.ui_cancel_small:stop()
			self.ui_cancel_small:play()
			self.state = "menu_select"
		end
	end
end

function PartySelectMenu:draw()
    super.draw(self)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(6)
	--local y = 300
	--love.graphics.line(80, y, 560, y)
    local x = 230
	love.graphics.line(x, 80, x, 420)
	love.graphics.line(self.bg.x - 20, 220, self.bg.x + (230 - self.bg.x), 220)

	local party = Game.party[self.slot_selected]
	if party then
		x = self.bg.x - 10
		love.graphics.print(party.name, x, 220)
		love.graphics.print("HP "..party.health.."/"..party.stats["health"], x, 245)
		love.graphics.print("ATK "..party.stats["attack"], x, 270)
		love.graphics.print("DEF "..party.stats["defense"], x, 295)
		love.graphics.print("MAG "..party.stats["magic"], x, 320)
		love.graphics.print("LOVE "..party.love, x, 345)
		love.graphics.print("KILLS "..party.kills, x, 370)
	end
end

return PartySelectMenu