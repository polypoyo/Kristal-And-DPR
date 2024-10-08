local casino, super = Class(Map)

function casino:onEnter()
    super.onEnter(self)

    Game:swapIntoMod("dpr_casino")
end

return casino