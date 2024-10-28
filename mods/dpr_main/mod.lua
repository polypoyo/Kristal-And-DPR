modRequire("scripts/main/warp_bin")
modRequire("scripts/main/utils_general")

function Mod:init()
    print("Loaded "..self.info.name.."!")
    self:registerShaders()
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

function Mod:createQuest(name, id, desc, progress_max, silent)
    if not silent and Game.stage then
        Game.stage:addChild(QuestCreatedPopup(name))
    end
end

function Mod:onTextSound(sound, node)
    if sound == "noel" then
        Assets.playSound("voice/noel/"..string.lower(node.character), 1, 1)
        return true
    elseif sound == "hero" then
            Assets.playSound("voice/default", 1, 1)
            Assets.playSound("voice/battle", 1, 1)
        return true
    end
end

function Mod:registerShaders()
    self.shaders = {}
    for _,path,shader in Registry.iterScripts("shaders/") do
        assert(shader ~= nil, '"shaders/'..path..'.lua" does not return value')
        self.shaders[path] = shader
    end
end