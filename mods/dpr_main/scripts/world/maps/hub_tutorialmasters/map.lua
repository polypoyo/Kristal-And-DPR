---@class Map.hub_tutorialmasters : Map
local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)
    for i, partymember in ipairs(Game.party) do
        local id = partymember.id
        local ok, actor = pcall(Registry.createActor, "tutorialmaster/"..id)
        if not ok then actor = Registry.createActor("tutorialmaster/bepis"); id = "bepis" end
        self.world:spawnObject(NPC(actor, 90 + (i * 80), 390, {
            cutscene = "tutorialmaster."..id
        }))
    end
end

return map
