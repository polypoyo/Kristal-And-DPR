
-- WIP cutscene, polish later
---@param cutscene WorldCutscene
return function(cutscene)
    local fountain = Game.world:getEvent("darkfountain")
    Kristal.hideBorder(1)
    
    local dialog = DialogueText({"bepis"}, 100, 80, (SCREEN_WIDTH - 100 * 2) + 14)
    dialog:setLayer(WORLD_LAYERS["textbox"])
    dialog:addFunction("look", function(self, chara, dir)
        cutscene:look(chara, dir)
    end)
    local function showDialog(text)
        local style = "[noskip][speed:0.3][voice:nil]"
        local _text
        if type(text) == "string" then
            _text = style .. text
        else
            _text = Utils.copy(text)
            for i, v in ipairs(_text) do
                _text[i] = style .. v
            end
        end
        
        dialog.visible = true
        dialog:setText(_text)
        cutscene:wait(function() return dialog:isDone() end)
        dialog.visible = false
    end
    Game.world:addChild(dialog)
    
    cutscene:detachFollowers()
    
    cutscene:walkToSpeed(Game.world.player, "sealready", 1, "up", true)
    
    showDialog("[speed:0.8](Do you want to return to the Light World?)")

    local seal = cutscene:choicer({"Yes", "No"})

    if seal == 1 then 
        Game.world.music:stop()

        local leader = Game.world.player
        local soul = Game.world:spawnObject(UsefountainSoul(leader.x, leader.y - leader.height + 10), "ui")
        cutscene:playSound("great_shine")
        cutscene:wait(1)

        Game.world.music:play("usefountain", 1)
        Game.world.music.source:setLooping(false)

        cutscene:wait(50/30)
        fountain.adjust = 1 -- fade out color
        Game.world.timer:tween(170/30, soul, {y = 160})
        --
            -- fade out the depth texture
            Game.world.timer:during(170/30, function()
                fountain.eyebody = fountain.eyebody - (fountain.eyebody * (1 - 0.98) * DTMULT)
            end)
        --]]
        cutscene:wait(170/30)
        fountain.adjust = 2 -- freeze in place and fade to white
        cutscene:wait(3)
        

        cutscene:playSound("revival")
        soul:shine()


        local flash_parts = {}
        local flash_part_total = 12
        local flash_part_grow_factor = 0.5
        for i = 1, flash_part_total - 1 do
            -- width is 1px for better scaling
            local part = Rectangle(SCREEN_WIDTH / 2, 0, 1, SCREEN_HEIGHT)
            part:setOrigin(0.5, 0)
            part.layer = soul.layer - i
            part:setColor(1, 1, 1, -(i / flash_part_total))
            part.graphics.fade = flash_part_grow_factor / 16
            part.graphics.fade_to = math.huge
            part.scale_x = i*i * 2
            part.graphics.grow_x = flash_part_grow_factor*i * 2
            table.insert(flash_parts, part)
            Game.world:addChild(part)
        end

        local function fade(step, color)
            local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
            rect:setParallax(0, 0)
            rect:setColor(color)
            rect.layer = soul.layer + 1
            rect.alpha = 0
            rect.graphics.fade = step
            rect.graphics.fade_to = 1
            Game.world:addChild(rect)
            cutscene:wait(1 / step / 30)
        end

        cutscene:wait(50/30)
        fade(0.02, {1, 1, 1})
        cutscene:wait(20/30)
        cutscene:wait(cutscene:fadeOut(used_fountain_once and 2 or 100/30, {color = {0, 0, 0}}))
        cutscene:wait(1)

        cutscene:fadeIn(1, {color = {1, 1, 1}})
        cutscene:after(Game:swapIntoMod("dpr_light"))
    else
        Kristal.showBorder(1)
    end

end