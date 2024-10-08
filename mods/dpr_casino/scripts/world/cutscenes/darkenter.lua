-- World's most scuffed darktransition via cutscenes.

---@param cutscene WorldCutscene
return function(cutscene)
    -- Landing positions based on party size. Hardcoded because screw me ig
    local landing = {
        {
            {460, 680}
        },
        {
            {500, 680},
            {420, 680}
        },
        {
            {460, 680},
            {420, 720},
            {500, 720}
        },
        { -- Juuuust in case we end up using MoreParty.
            {500, 680},
            {420, 680},
            {380, 720},
            {540, 720}
        },
    }



    -- Black background
    local blackbg = Sprite("kristal/doorblack")
    blackbg.x, blackbg.y = Game.world.map:getMarker("spawn")
    blackbg:setOrigin(0.5)
    blackbg:setScale(10)
    blackbg.layer = 0.5
    Game.world:addChild(blackbg)

    cutscene:detachCamera()
    cutscene:detachFollowers()

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