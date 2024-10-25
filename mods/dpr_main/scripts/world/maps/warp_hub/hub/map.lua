local hub, super = Class(Map)

function hub:onEnter()
    super.onEnter(self)
end

function hub:onFootstep(char, num)
    local brenda = Game.world:getCharacter("brenda")
    if (brenda and Game:getPartyMember("brenda").love >= 5)
        and (love.math.random(1, 1000) == 55 and not Game:getFlag("thoughts"))
    then
        Game.world:startCutscene("thoughts", "b")
    end
end

return hub