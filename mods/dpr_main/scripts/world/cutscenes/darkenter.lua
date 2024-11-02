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
    transition.end_callback = function(trans, data)
        waiting = false
    end
    Game.world:addChild(transition)
    cutscene:wait(function() return not waiting end)
    cutscene:attachCamera()
    cutscene:interpolateFollowers()
    cutscene:attachFollowers()
end