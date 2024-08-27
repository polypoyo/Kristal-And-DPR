local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)
    Game.world:spawnObject(white_glows(), "objects_bg")

end

return map