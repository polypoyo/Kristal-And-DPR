local Warstalker, super = Class(Encounter)

function Warstalker:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "[instant]Error: src/engine/registry.lua:273: Attempt to create non existent enemy \"starwalker\"\nstack traceback:\n[C]: in function 'pcall'\nmain.lua:438: in function <main.lua:436>\n[C]: in function 'error'"

    -- Battle music ("battle" is rude buster)
    self.music = "battle"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("warstalker")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")


end

function Warstalker:onReturnToWorld(events)
    -- check whether the enemies were killed
    if Game.battle.killed then
        -- run this code for each event in the table
        for _,event in ipairs(events) do
            for _,event in ipairs(event:getGroupedEnemies(true)) do
                -- set a 'dont_load' flag to true for the event,
                -- which is a special flag that will prevent the event from loading
                event:setFlag("dont_load", true)
            end
        end
    end
end

return Warstalker