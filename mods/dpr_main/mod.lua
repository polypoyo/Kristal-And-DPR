modRequire("scripts/main/warp_bin")
modRequire("scripts/main/utils_general")

function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.border_shaders = {}
end

function Mod:postInit(new_file)
    local items_list = {
        {
            result = "soulmantle",
            item1 = "flarewings",
            item2 = "discarded_robe"
        },
    }
    Kristal.callEvent("setItemsList", items_list)
    if new_file then
        Game:setFlag("library_love", 1)
        Game:setFlag("library_experience", 0)
        Game:setFlag("library_kills", 0)
		
        if Game.save_name == "SUPER" then
            Game.inventory:addItem("chaos_emeralds")
        end

        local baseParty = {}
        table.insert(baseParty, "hero") -- should be just Hero for now
        Game:setFlag("_unlockedPartyMembers", baseParty)

        Game.world:startCutscene("_main.introcutscene")
    end
end

function Mod:addGlobalEXP(exp)
    Game:setFlag("library_experience", Utils.clamp(Game:getFlag("library_experience", 0) + exp, 0, 99999))

    local max_love = #Kristal.getLibConfig("library_main", "global_xp_requirements")
    local leveled_up = false
    while
        Game:getFlag("library_experience") >= Kristal.callEvent("getGlobalNextLvRequiredEXP")
        and Game:getFlag("library_love", 1) < max_love
    do
        leveled_up = true
        Game:addFlag("library_love", 1)
        for _,party in ipairs(Game.party) do
            party:onLevelUpLVLib(Game:getFlag("library_love"))
        end
    end

    return leveled_up
end

function Mod:getGlobalNextLvRequiredEXP()
    return Kristal.getLibConfig("library_main", "global_xp_requirements")[Game:getFlag("library_love") + 1] or 0
end

function Mod:getGlobalNextLv()
    return Utils.clamp(Kristal.callEvent("getGlobalNextLvRequiredEXP") - Game:getFlag("library_experience"), 0, 99999)
end

function Mod:unlockQuest(quest, silent)
    if not silent and Game.stage then
        Game.stage:addChild(QuestCreatedPopup(quest))
    end
end

function Mod:onBorderDraw(border_sprite)
    if not self.border_shaders then return end
    if not self.border_shaders[border_sprite] and Assets.data.shaders["borders/"..border_sprite] then
        self.border_shaders[border_sprite] = love.graphics.newShader(Assets.data.shaders["borders/"..border_sprite])
    end
    local shader = self.border_shaders[border_sprite]
    if shader then
        shader:send("iTime", Kristal.getTime())
        shader:send("iResolution", {love.graphics.getWidth(), love.graphics.getHeight()})
        love.graphics.setShader(shader)
        love.graphics.draw(Assets.getTexture("borders/"..border_sprite), 0, 0, 0, BORDER_SCALE)
        love.graphics.setShader()
    end
end