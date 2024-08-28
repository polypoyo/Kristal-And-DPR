return {
    ---@param cutscene WorldCutscene
    welcome = function(cutscene, event)
        cutscene:text("* Oh okay.")
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
        --cutscene:text("* Oh okay.")
        local cat = cutscene:getCharacter("cat")
        if not cat then
            Game.world:spawnNPC("cat", 460, 160)
        end

        local player = Game.world.player
        cutscene:slideTo(player, 459, 1190, 2.5, "out-cubic")
        cutscene:wait(3)

        local plx = player.x
        local num = 1
        local mum = 2
        local sam = "start"
        cutscene:during(function()
            if sam == "start" then
                local oh = plx + love.math.random(-num * mum, num * mum)
                player.x = oh
            end
        end)


        local time = 1
        local plir = 0.051
        for _ = 1, 21 do
             Assets.playSound("wing")
             Game.world.player:shake(0, 5)
             cutscene:wait(time)
             time = time - plir
        end

        Assets.playSound("jump", 1, 0.5)
        cutscene:slideTo(player, 459, 260, 0.2)
        cutscene:wait(0.2)
        Game.world:shake(1, 50)
        sam = "stop"
        Assets.playSound("dtrans_flip", 1, 0.5)
        Assets.playSound("impact")
        cutscene:wait(5)
        cutscene:slideTo(player, 459, 320, 0.2)
        cutscene:wait(0.2)
        Game.world.player:shake(5)
        Assets.playSound("bump")
        cutscene:wait(2)
        gonerText("\nCareful.[wait:10]\nYou can't go down\nthose cliffs.", false)
        cutscene:wait(5)
        gonerTextFade()
    end,
}
