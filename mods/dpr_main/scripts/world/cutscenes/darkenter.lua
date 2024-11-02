-- World's most scuffed darktransition via cutscenes.

---@param cutscene WorldCutscene
return function(cutscene)
    local markx,marky = Game.world.map:getMarker("landing")
    cutscene:after(function()
        DTRANS = nil
    end)
    
    cutscene:detachCamera()
    Game.world.camera:setPosition(markx, marky)
    cutscene:detachFollowers()
    Kristal.hideBorder(1)
    local transition = LoadingDarkTransition(300, {
        resuming = true,
        character_data = DTRANS
    })
    transition.layer = WORLD_LAYERS["top"]
    local waiting = true
    local endData
    transition.end_callback = function(trans, data)
        waiting = false
        endData = data
    end
    Game.world:addChild(transition)
    cutscene:wait(function() return not waiting end)
    for _, character in ipairs(endData) do
        local char = Game.world:getPartyCharacterInParty(character.party)
        local kx, ky = character.sprite_1:localToScreenPos(character.sprite_1.width / 2, 0)
        char:setScreenPos(kx + 8, transition.final_y)
        char.visible = true
        char:setFacing("down")
    end
    cutscene:wait(0.2)
    cutscene:attachCamera()
    cutscene:interpolateFollowers()
    cutscene:attachFollowers()
end