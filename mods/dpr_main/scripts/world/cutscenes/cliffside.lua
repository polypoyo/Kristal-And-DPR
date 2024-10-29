return {
    ---@param cutscene WorldCutscene
    intro = function(cutscene, event)
        
        cutscene:wait(function()
            if Game.world.map.id == [[grey_cliffside/cliffside_start]] then
                return true
            else
                return false
            end
        end)
        Game.world.music:stop()
        local darknessoverlay = DarknessOverlay()
        darknessoverlay.layer = 1
        Game.world:addChild(darknessoverlay)
        local lightsource = LightSource(15, 28, 60)
        lightsource.alpha = 0.25
        Game.world.player:addChild(lightsource)

        local textobj = shakytextobject(115, 810, "Press C to open your menu.")
        textobj.layer = 2
        Game.world:addChild(textobj)
        

        local hero = cutscene:getCharacter("hero")
        hero:setSprite("fell")

local function openMenulol(menu, layer)
    local self = Game.world
    if self.menu then
        self.menu:remove()
        self.menu = nil
    end

    if not menu then
        menu = self:createMenu()
    end

    self.menu = menu
    if self.menu then
        self.menu.layer = layer and self:parseLayer(layer) or WORLD_LAYERS["ui"]

        if self.menu:includes(AbstractMenuComponent) then
            self.menu.close_callback = function()
                self:afterMenuClosed()
            end
        elseif self.menu:includes(Component) then
            -- Sigh... traverse the children to find the menu component
            for _,child in ipairs(self.menu:getComponents()) do
                if child:includes(AbstractMenuComponent) then
                    child.close_callback = function()
                        self:afterMenuClosed()
                    end
                    break
                end
            end
        end

        self:addChild(self.menu)
        self:setState("MENU")
    end
    return self.menu
end
        Game.tutorial = true


        --cutscene:text("* press c")

        cutscene:wait(function()
            return Input.pressed("menu")
        end)
        openMenulol()
        --Game.world.menu:addChild()

        textobj.text = "Press Z to select the TALK option."
        textobj.x, textobj.y = 10, 560


        cutscene:wait(function()
            return Input.pressed("confirm")
        end)
        Assets.playSound("ui_select")
        textobj.text = ""
       
        Game.world:closeMenu()

       local choicer = cutscene:choicer({"* Hero..."})
       if choicer == 1 then
          cutscene:wait(0.5)
          Game.stage.timer:tween(1, lightsource, {alpha = 0.50})
          local wing = Assets.playSound("wing")
          Game.world.player:shake()
          cutscene:wait(1.5)
          wing:play()
          Game.world.player:shake()
          cutscene:wait(0.5)
          wing:stop()
          wing:play()
          Game.world.player:shake()
          lightsource.y = 25
          hero:setSprite("walk/right")
          cutscene:wait(2)
          cutscene:showNametag("Hero")
          cutscene:text("* Hello?", nil, "hero")
          cutscene:hideNametag()
          local stime = 0.30
          cutscene:wait(stime)
          hero:setSprite("walk/up")
          cutscene:wait(stime)
          hero:setSprite("walk/left")
          cutscene:wait(stime)
          hero:setSprite("walk/down")
          cutscene:wait(stime)
          hero:setSprite("walk/right")
          cutscene:wait(0.75)

          cutscene:showNametag("Hero")
          cutscene:text("* Is someone there?", nil, "hero")
          cutscene:hideNametag()

          textobj.text = "What will you do?"
          textobj.x, textobj.y = 200, 560

          local choicer = cutscene:choicer({"Speak", "Do not"})
          textobj.text = ""
          if choicer == 1 then
          elseif choicer == 2 then
              cutscene:wait(2)
              cutscene:showNametag("Hero")
              cutscene:text("* Hello?", nil, "hero")
              cutscene:hideNametag()

              cutscene:wait(4)

              cutscene:showNametag("Hero")
              cutscene:text("* Wow...[wait:30]\n* It's sad how I'm waiting a reply...", nil, "hero")

              hero:setSprite("walk/down")

              cutscene:text("* But,[wait:5] I know you're there though.[wait:10]\n* I overheard you talking to [color:yellow]him[color:white].", nil, "hero")
              cutscene:hideNametag()

              cutscene:wait(0.5)
              hero:setSprite("walk/left")
              cutscene:wait(0.5)

              cutscene:showNametag("Hero")
              cutscene:text("* Unless he was talking to himself again...", nil, "hero")
              cutscene:text("* Wouldn't be the first time.[wait:10]\n* I guess...", nil, "hero")
              cutscene:hideNametag()

              cutscene:wait(0.5)
              hero:setSprite("walk/right")
              cutscene:wait(0.5)

              cutscene:showNametag("Hero")
              cutscene:text("* But I could've sworn I heard someone call out to me.", nil, "hero")
              cutscene:hideNametag()

              cutscene:wait(0.5)
              hero:setFacing("up")
              hero:resetSprite()
              cutscene:wait(0.5)

              cutscene:showNametag("Hero")
              cutscene:text("* Actually,[wait:5] where even IS[wait:5] me?", nil, "hero") --haha grammer
              cutscene:hideNametag()
          end
          hero:resetSprite()
          Game.stage.timer:tween(1, lightsource, {radius = 900})
          Game.stage.timer:tween(1, lightsource, {alpha = 1})
          cutscene:wait(0.75)
          Game.world.music:play()

       elseif choicer == 2 then

       end





        cutscene:wait(function()
            if lightsource.alpha >= 1 or lightsource.radius >= 900 then
            return true
            else
            return false
            end
        end)
        Game.tutorial = nil
        darknessoverlay:remove()
    end,
    welcome = function(cutscene, event)
        cutscene:text("* Welcome to Cliffside![wait:10]\n* Watch your step!")
    end,
    first_reverse_cliff = function(cutscene, event)

       local text

        local function gonerTextFade(wait)
            local this_text = text
            Game.world.timer:tween(1, this_text, {alpha = 0}, "linear", function()
                this_text:remove()
            end)
            if wait ~= false then
                cutscene:wait(1)
            end
        end
 
        local function createsprite(kris)
            kris.parallax_x = 0
            kris.parallax_y = 0
            kris:setScale(2)
            kris.layer = WORLD_LAYERS["top"] + 100
            Game.world:addChild(kris)
        end

        local function gonerText(str, advance, option)
            text = DialogueText("[speed:0.5][spacing:6][style:GONER]" .. str, 160, 100, 640, 480, {auto_size = true})
            text.layer = WORLD_LAYERS["top"] + 100
            text.skip_speed = true
            text.parallax_x = 0
            text.parallax_y = 0

            Game.world:addChild(text)
            if option then
                if option == "shake" then
                    cutscene:shake(10, 10)
                end
            end

            if advance == "auto" then
                cutscene:wait(function() return not text:isTyping() end)
                text:remove()
            elseif advance ~= false then
                cutscene:wait(function() return not text:isTyping() end)
                gonerTextFade(true)
            end
        end
        Assets.playSound("noise")

        Game.world.player:setState("SLIDE")
        
        --cutscene:text("* Oh okay.")
        local cat = cutscene:getCharacter("cat")
        if not cat then
            Game.world:spawnNPC("cat", 460, 160)
        end

        local player = Game.world.player
        cutscene:slideTo(player, 459, 1300, 4, "out-cubic")
        cutscene:wait(3)
        Game.world.player.slide_in_place = true
        local plx = player.x
        local num = 1
        local mum = 2
        local sam = "sdtart"
        cutscene:during(function()
            if sam == "start" then
                local oh = plx + love.math.random(-num * mum, num * mum)
                player.x = oh
            end
        end)
        cutscene:wait(1)
        sam = "start"
        cutscene:slideTo(player, 459, 1100, 9, "out-cubic")
        cutscene:wait(1)

        local time = 0.25
        local plir = 0.01
        for _ = 1, 25 do
             Game.world.player.y = Game.world.player.y -10
             Assets.playSound("wing")
             Game.world.player:shake(0, 5)
             cutscene:wait(time)
             time = time - plir
        end
        Game.world.player.slide_sound:stop()

        Game.world.player:setState("WALK")
        Assets.playSound("jump", 1, 0.5)
        cutscene:slideTo(player, 459, 260, 0.2)
        cutscene:wait(0.2)
        Game.world:shake(1, 50)
        sam = "stop"
        Assets.playSound("dtrans_flip", 1, 0.5)
        Assets.playSound("impact")
        Game.world.player:setAnimation("wall_slam")
        cutscene:wait(1)
        Game.world.player:setState("SLIDE")
        cutscene:slideTo(player, 459, 320, 0.2)
        cutscene:wait(0.2)
        Game.world.player:setState("WALK")
        Game.world.player:shake(5)
        Assets.playSound("bump")
        cutscene:wait(2)
        --gonerText("\nCareful.[wait:10]\nYou can't go down\nthose cliffs.", false)

        cutscene:showNametag("???")
        cutscene:text("* Careful.[wait:10]\nYou can't go down those cliffs.", nil, "cat")
        cutscene:hideNametag()

        local wat = 0.5
        Game.world.player:setFacing("left")
        cutscene:wait(wat)
        Game.world.player:setFacing("right")
        cutscene:wait(wat)
        Game.world.player:setFacing("left")
        cutscene:wait(wat)
        Game.world.player:setFacing("right")
        cutscene:wait(wat)

       --[[local choicer = cutscene:choicer({"Hello?", "Who's there?", "Thanks for the heads up.",  "No shit."})
       if choicer == 1 then
           cutscene:showNametag("???")
           cutscene:text("* Hello there.[wait:5]\n* Up here.", nil, "cat")
       elseif choicer == 2 then
           cutscene:showNametag("???")
           cutscene:text("* Up here.", nil, "cat")
           Game.world.player:setFacing("up")
           cutscene:wait(1)
           cutscene:showNametag("Cat?")
           cutscene:text("* Hello there.", nil, "cat")
       elseif choicer == 3 then
       elseif choicer == 4 then
       end]]

       cutscene:showNametag("Hero")
       cutscene:text("* Who's there?", nil, "hero")

       cutscene:showNametag("???")
       cutscene:text("* Me.[wait:10]\nI'm there.\n[wait:10]Up here.", nil, "cat")
        cutscene:hideNametag()
       Game.world.player:setFacing("up")
       cutscene:wait(1)
       cutscene:showNametag("Cat?")
       cutscene:text("* Hello there.", "neutral", "cat")
        cutscene:hideNametag()
       cutscene:showNametag("Cat?")
       local choicer = cutscene:choicer({"Hello?", "Is that a\ntalking cat?!"})
       if choicer == 1 then
          cutscene:text("* Yes,[wait:10] hello.", "neutral", "cat")
          cutscene:text("* Hm...[wait:10]\n* You seem to be confused...", "neutral", "cat")
       elseif choicer == 2 then
           cutscene:text("* Yes,[wait:5] I am a cat[wait:5] and I can talk.", "neutral", "cat")
           cutscene:text("* How very observant you are for someone with [color:red]their[color:white] eyes closed.", "neutral", "cat")

           --cutscene:text("* You seem to already know me.", "neutral", "cat")
       end

       Game:getQuest("cliffsides_cat"):unlock()
       cutscene:text("* quest created", "neutral", "cat")


       --cutscene:showNametag("Cat")
       --cutscene:text("* My name is cat.", "neutral", "cat")
      -- cutscene:text("* Say... You don't look like you're from around here.", "neutral", "cat")
       --cutscene:text("* The both of you...", "neutral", "cat")
       --cutscene:text("* Has fate brought you here?\n[wait:10]* Perchance Lady Luck?", "neutral", "cat")

       --cat walking

       --cutscene:text("* Follow me...", "neutral", "cat")

       --cat keep walking

        cutscene:hideNametag()
    end,
    reverse_cliff_2 = function(cutscene, event)

        local end_y = 80
        local p_y = Game.world.player.y
        local tiles = 12
        local length = tiles*40
        local reverse_spot = p_y + length/2

        Assets.playSound("noise")

        Game.world.player:setState("SLIDE")

        cutscene:wait(function()
            if Game.world.player.walk_speed < -8 then
                Assets.playSound("jump", 1, 0.5)
                Game.world.player.physics.speed_y = -10
                Game.world.player.physics.friction = -1.5
                Game.world.player.walk_speed = -8

                return true
            else
                Game.world.player.walk_speed = Game.world.player.walk_speed - DT*8
                return false
            end
        end)

        cutscene:wait(function()
            if Game.world.player.y < p_y then
                Game.world.player:setState("WALK")
                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                return true
            else
                return false
            end
        end)

        cutscene:wait(function()
            if Game.world.player.y < -20 then

                local x = Game.world.player.x - 240 + 400
                phys_speed = Game.world.player.physics.speed_y
                Game.world:mapTransition("grey_cliffside/cliffside_start", x, 1040)

                return true
            else
                return false
            end
        end)

        cutscene:wait(function()
            if Game.world.map.id == "grey_cliffside/cliffside_start" then

                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                Game.world.player.physics.speed_y = phys_speed 
                Game.world.player.physics.friction = -1.5

                return true
            else
                return false
            end
        end)

        cutscene:wait(function()
            if Game.world.player.y < 520 then
                Game.world.player.physics.friction = 4

                return true
            else
                return false
            end
        end)

        cutscene:wait(function()
            if Game.world.player.physics.speed_y == 0 then
                Game.world.player.physics.friction = -1

                Game.world.player.physics.speed_y = 1

                return true
            else
                return false
            end
        end)

        cutscene:wait(function()
            if Game.world.player.y > 420 then

                return true
            else
                return false
            end
        end)

        Game.world.player.noclip = false
        Game.world.player.physics.friction = 0
        Game.world.player.physics.speed_y = 0
        Game.world.player:setFacing("down")
        Game.world.player:resetSprite()
        Game.world.player:shake(5)
        Assets.playSound("dtrans_flip")
        Game.world.player.walk_speed = 4
    end,
    warp_bin = function(cutscene, event)
        Game.world:mapTransition("main_hub")
    end,
    video = function(cutscene, event)

local cool = [[
extern vec4 keyColor;    // The color to be made transparent (greenscreen color)
extern float threshold;  // The tolerance for matching the key color

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(texture, texture_coords);  // Get the pixel color
    float diff = distance(pixel.rgb, keyColor.rgb);  // Measure color difference

    // If the difference between the pixel color and the key color is less than the threshold, make it transparent
    if (diff < threshold) {
        return vec4(0.0, 0.0, 0.0, 0.0);  // Transparent pixel
    } else {
        return pixel * color;  // Return the original color
    }
}
]]





    local cooler = love.graphics.newShader(cool)

        local video = Video("spongebob", true, 0, 0, 640, 480) -- assets/videos/video_here.ogv
        video.parallax_x, video.parallax_y = 0, 0
        video:play()
            video:addFX(ShaderFX(cooler, {
                ["keyColor"] = {0.0, 1.0, 0.0, 1.0},  -- Pure green (R=0, G=1, B=0)
                ["threshold"] = 0.4,  -- Adjust the threshold for green color tolerance
            }), 66)
        Game.stage:addChild(video)
        
        cutscene:wait(function()
            local check = video:isPlaying()

            if video.was_playing and not video.video:isPlaying() then
                return true
            else
                return false
            end

            
        end)
        video:remove()
    end,
}
