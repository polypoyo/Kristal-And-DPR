local MainHub, super = Class(Map)

function MainHub:onEnter()
    if DTRANS then
        Game.world:startCutscene("darkenter")
    end
end

return MainHub