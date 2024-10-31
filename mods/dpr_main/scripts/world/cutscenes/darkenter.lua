-- World's most scuffed darktransition via cutscenes.

---@param cutscene WorldCutscene
return function(cutscene)
    -- Landing positions based on party size. Hardcoded because screw me ig
    local landing = {
        {
            {0, 36}
        },
        {
            {40, 36},
            {-40, 36}
        },
        {
            {0, 36},
            {-40, 76},
            {40, 76}
        },
        { -- Juuuust in case we end up using MoreParty.
            {40, 36},
            {-40, 36},
            {-80, 76},
            {80, 76}
        },
    }

    for i = 1, #landing do
        local landing_sub = landing[i]
        for i = 1, #landing_sub do
            local pair = landing_sub[i]
            local x,y = Game.world.map:getMarker("landing")
            pair[1] = pair[1] + x
            pair[2] = pair[2] + y
        end
    end

    -- Black background
    local blackbg = Sprite("kristal/doorblack")
    blackbg.x, blackbg.y = Game.world.map:getMarker("landing")
    blackbg:setOrigin(0.5)
    blackbg:setScale(10)
    blackbg.layer = 0.5
    Game.world:addChild(blackbg)

    cutscene:detachCamera()
    Game.world.camera:setPosition(Game.world.map:getMarker("landing"))
    cutscene:detachFollowers()
    Kristal.hideBorder(1)

    -- Get every party member and move them up offscreen
    local party = {}
    for i, chara in ipairs(Game.party) do
        table.insert(party, cutscene:getCharacter(Game.party[i].id))
        party[i].sprite:set("jump_ball")
        party[i].layer_old = party[i].layer
        party.layer = WORLD_LAYERS["ui"]
        party[i].x = landing[#Game.party][i][1]
        party[i].y = landing[#Game.party][i][2] - SCREEN_HEIGHT/2 - 100 -- Juuuust in case
    end

    -- Drop everybody down
    for i, chara in ipairs(party) do
        chara:slideTo(landing[#party][i][1], landing[#party][i][2], 0.5)
    end

    cutscene:wait(0.5)

    -- We've hit the ground.
    Game.stage:shake(8)
    Assets.playSound("dtrans_flip")
    for i, chara in ipairs(party) do
        chara.sprite:set("landed")
    end
    cutscene:wait(1)
    Kristal.showBorder(0.75)
    Assets.playSound("him_quick")
    blackbg:fadeOutAndRemove(0.75)
    cutscene:wait(0.75)
    for i, chara in ipairs(party) do
        chara.sprite:play(4/30, false)
        chara.layer = chara.layer_old
    end

    cutscene:wait(0.5)
    cutscene:resetSprites()
    cutscene:attachCamera()
    cutscene:interpolateFollowers()
    cutscene:attachFollowers()
    DTRANS = false

end