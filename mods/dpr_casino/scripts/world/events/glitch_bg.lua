local Glitch_Bg, super = Class(Event)
function Glitch_Bg:init(data)
    local map = Game.world.map
    function map:onEnter()
        --super.onEnter(map)
        Game.world:spawnObject(white_glows(), "objects_bg")

    end
    super.init(self, data)
end
return Glitch_Bg