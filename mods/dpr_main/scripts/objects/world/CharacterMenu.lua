local CharacterMenu, super = Class(Object)

function CharacterMenu:init()
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
	
	self.party = Game.party

	self.sprites = {}

	self.index = 3

	self.selected = 1

	for i, party in ipairs(Game.party) do

		local sprite = Sprite(party.actor.path .. "/" .. party.actor.default .. "/down")

		local x = self.bg.x + 100 + (i - 1) * 100 
		--x = x - sprite.width/2
		sprite:setOrigin(0.5, 0.5)
		local y = self.bg.y + 100
	
		sprite:setScale(2)
		sprite.x = x
		sprite.y = y

		sprite.party = party

		self.sprites[i] = sprite
	
		self:addChild(sprite)

        if party.actor.menu_anim then
			sprite:setSprite(party.actor.path .. "/" .. party.actor.menu_anim)
		end
	end

	self.text = Text("")
	self:addChild(self.text)
	self.text.x = 90
	self.text.y = 310
	

	self.characters = {
		"Hero", "Susie", "Dess" 
	}
	self:addChild(self.heart_sprite)
	self.heart_sprite.y = self.bg.y + 170
	self.heart_sprite.x = self.bg.x + (self.selected) * 100
	self.target_x = self.bg.x + (self.selected) * 100
	self:selection(0)
end

function CharacterMenu:selection(num)
	local chr = self.sprites[self.selected]

	if chr then
	    chr:removeFX(OutlineFX)
	end

	self.selected = self.selected + num

	self.ui_move:play()

	if self.selected > self.index then
		self.selected = 1
	end

	if self.selected <= 0 then
		self.selected = self.index
	end

	local chr = self.sprites[self.selected]

	if chr then 
		chr:addFX(OutlineFX())

		local color = chr.party.color or {1, 1, 1}
		chr:getFX(OutlineFX):setColor(unpack(color))

		local soul_color = chr.party.soul_color or {1, 0, 0}
		self.heart_sprite:setColor(soul_color)

		local text = chr.party.title_extended or chr.party.title or "* Placeholder~"
		self.text:setText(text)
	else
		self.text:setText("Empty")
		self.heart_sprite:setColor({1, 0, 0})
	end

	self.target_x = self.bg.x + (self.selected) * 100
end

function CharacterMenu:update()
	super.update(self)

    self.heart_sprite.x = self.heart_sprite.x + (self.target_x - self.heart_sprite.x) * 20 * DT

	
	if Input.pressed("left", true) then
		self:selection(-1)

	elseif Input.pressed("right", true) then
		self:selection(1)

	elseif Input.pressed("cancel") then
		Game.world:closeMenu()
		self:remove()
		
	end
end

function CharacterMenu:draw()
    super.draw(self)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(6)
	local y = 300
	love.graphics.line(80, y, 560, y)
    local x = 380
	love.graphics.line(x, 300, x, 420)
end

return CharacterMenu