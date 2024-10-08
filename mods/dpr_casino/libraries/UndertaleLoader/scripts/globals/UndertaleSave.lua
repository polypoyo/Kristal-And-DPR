local UndertaleSave = Class()

function UndertaleSave:init()
    self.data = {}

    self.completion = false

    self.name = ""
    self.gold = 0
    self.fun  = 0

    self.sys_info_962 = false -- Set to 'true' if you erased the world.
    self.sys_info_963 = false -- Set to 'true' if you sold your soul to Chara.

    self.plot = 0
    self.room_id = 0
    self.room_name = ""
    self.playtime = 0

    self.inventory = {
        ["items"]   = {},
        ["box_a"]   = {},
        ["box_b"]   = {}
    }

    self.boss_states = {
        ["dummy"]           = "INITIAL", -- "KILLED",       "TALKED",       "BORED",       "FLED"
        ["toriel"]          = "INITIAL", -- "IN_BASEMENT",  "KILLED",       "SPARED"
        ["comedian"]        = "INITIAL", -- "LAUGHED_AT",   "KILLED"
        ["papyrus"]         = "INITIAL", -- "LOST_ONCE",    "LOST_TWICE",   "LOST_THRICE", "KILLED", "SPARED"
        ["shyren"]          = "INITIAL", -- "KILLED",       "ENCOURAGED"
      --["mad_dummy"]       = "INITIAL", -- "KILLED"                        -- (I couldn't find Mad Dummy's status flag in file0)
        ["undyne"]          = "INITIAL", -- "KILLED",       "SPARED"
        ["undying"]         = "INITIAL", -- "KILLED"
        ["sosorry"]         = "INITIAL", -- "KILLED",       "SPARED"
        ["muffet"]          = "INITIAL", -- "KILLED",       "FOUGHT"
        ["mettaton"]        = "INITIAL", -- "KILLED"
        ["asgore"]          = "INITIAL", -- "KILLED"
    }

    self.hp = 20
    self.maxhp = 20

    self.lv = 1
    self.exp = 0
    self.kills = 0

    self.atk = 0
    self.def = 0

    self.weapon = nil
    self.armor = nil
    self.name_color = "yellow"
end

function UndertaleSave:getData(index, as)
    local value = self.data[index]

    if value == nil then
        return nil
    end

    if as == "number" then
        return tonumber(value) or 0
    elseif as == "boolean" then
        return value ~= "0" and value ~= ""
    elseif as == "string" then
        return value
    else
        return tonumber(value) or value
    end
end

function UndertaleSave:checkData(...)
    local index, compare = ...
    if arg.n == 1 then
        compare = true
    end
    return self:getData(index, type(compare)) == compare
end

function UndertaleSave:getRoomName()
    return UndertaleConsts.ROOM_IDS[self.room_id] or "--"
end

function UndertaleSave:parseData(data)
    self.data = data

    self.name = data[1]
    self.money = tonumber(data[11])
    self.fun = tonumber(data[36])

    self.plot         = tonumber(data[543])
    self.room_id      = tonumber(data[548])
    self.playtime     = tonumber(data[549])

    self.room_name = UndertaleConsts.ROOM_IDS[self.room_id] or "--"
    self.playtime = self.playtime / 30

    self.weapon = UndertaleConsts.ITEM_IDS[tonumber(data[29])]
    self.armor  = UndertaleConsts.ITEM_IDS[tonumber(data[30])]

    if tonumber(data[53]) == 0 then
        self.name_color = "yellow"
    elseif tonumber(data[53]) == 1 then
        self.name_color = "white"
    elseif tonumber(data[53]) == 2 then
        self.name_color = "pink"
    end

    local function parseItems(start, num, inc, tbl, lookup)
        for i = 1, num do
            local item_id = data[start + (i - 1) * inc]

            tbl[i] = lookup[tonumber(item_id)]
        end
    end

    parseItems(13,  8,  2, self.inventory.items, UndertaleConsts.ITEM_IDS)
    parseItems(331, 12, 1, self.inventory.box_a, UndertaleConsts.ITEM_IDS)
    parseItems(343, 12, 1, self.inventory.box_b, UndertaleConsts.ITEM_IDS)

    self.hp     = tonumber(data[3])
    self.maxhp  = tonumber(data[3])

    self.lv     = tonumber(data[2] )
    self.exp    = tonumber(data[10])
    self.kills  = tonumber(data[12])

    self.atk    = tonumber(data[5])
    self.def    = tonumber(data[7])

    ---------------------- BOSS STATES ----------------------

    -- DUMMY
    if     tonumber(data[45]) == 0 then
        self.boss_states["dummy"] = "FLED"
    elseif tonumber(data[45]) == 1 then
        self.boss_states["dummy"] = "KILLED"
    elseif tonumber(data[45]) == 2 then
        self.boss_states["dummy"] = "TALKED"
    elseif tonumber(data[45]) == 3 then
        self.boss_states["dummy"] = "BORED"
    end

    -- TORIEL
    if     tonumber(data[76]) == 1 then
        self.boss_states["toriel"] = "IN_BASEMENT"
    elseif tonumber(data[76]) == 4 then
        self.boss_states["toriel"] = "KILLED"
    elseif tonumber(data[76]) == 5 then
        self.boss_states["toriel"] = "SPARED"
    end

    -- COMEDIAN / SNOWDRAKE
    if     tonumber(data[76]) == 1 then
        self.boss_states["comedian"] = "LAUGHED_AT"
    elseif tonumber(data[76]) == 2 then
        self.boss_states["comedian"] = "KILLED"
    end

    -- PAPYRUS
    if     tonumber(data[98]) == -1 then
        self.boss_states["papyrus"] = "LOST_ONCE"
    elseif tonumber(data[98]) == -2 then
        self.boss_states["papyrus"] = "LOST_TWICE"
    elseif tonumber(data[98]) == -3 then
        self.boss_states["papyrus"] = "LOST_THRICE"
    elseif tonumber(data[98]) == 0 then
        self.boss_states["papyrus"] = "SPARED"
    elseif tonumber(data[98]) == 1 then
        self.boss_states["papyrus"] = "KILLED"
    end

    -- SHYREN
    if     tonumber(data[112]) == 1 then
        self.boss_states["shyren"] = "KILLED"
    elseif tonumber(data[112]) == 2 then
        self.boss_states["shyren"] = "ENCOURAGED"
    end

    -- UNDYNE
    if     tonumber(data[381]) == 1 then
        self.boss_states["undyne"] = "KILLED"
    elseif tonumber(data[381]) == 2 then
        self.boss_states["undyne"] = "SPARED"
    end

    -- UNDYING
    if tonumber(data[282]) == 1 then
        self.boss_states["undying"] = "KILLED"
    end

    -- SO SORRY
    if     tonumber(data[312]) == 1 then
        self.boss_states["sosorry"] = "KILLED"
    elseif tonumber(data[312]) == 2 then
        self.boss_states["sosorry"] = "SPARED"
    end

    -- MUFFET
    if     tonumber(data[428]) == 1 then
        self.boss_states["muffet"] = "KILLED"
    elseif tonumber(data[427]) == 1 then
        self.boss_states["muffet"] = "FOUGHT"
    end

    -- METTATON
    if tonumber(data[456]) == 1 then
        self.boss_states["mettaton"] = "KILLED"
    end

    -- ASGORE
    if tonumber(data[507]) == 1 then
        self.boss_states["asgore"] = "KILLED"
    end

    ---------------------------------------------------------

    if (self.plot == 999) or (self.sys_info_962) then
        self.completion = true
    end
end

function UndertaleSave:load()
    Game.save_name = self.name
    Game.lw_money = self.money
    Game.playtime = self.playtime
    if Mod.libs["magical-glass"] then
        MagicalGlassLib.kills = self.kills
        MagicalGlassLib:changeSpareColor(self.name_color)
    end
    for _,party in ipairs(Kristal.getLibConfig("undertale-loader", "partymemberimport")) do
        if Game:hasPartyMember(party) then
            local member = Game:getPartyMember(party)
            member.lw_health = self.hp
            member.lw_stats.health = self.maxhp
            member.lw_stats.attack = self.atk
            member.lw_stats.defense = self.def
            member.lw_lv = self.lv
            member.lw_exp = self.exp
        end
    end

    local function safeGetItem(id)
        if not id then
            return nil
        end

        if not Registry.getItem(id) then
            print("[UndertaleLoader] Loaded invalid item: "..id)
            return nil
        end

        return id
    end

    local function clearStorages(inventory, storages)
        for _,storage_id in ipairs(storages) do
            local storage = inventory:getStorage(storage_id)
            for i = 1, storage.max do
                if inventory.stored_items[storage[i]] then
                    inventory.stored_items[storage[i]] = nil
                end
                storage[i] = nil
            end
        end
    end

    local function loadStorage(inventory, storage_id, data)
        local storage = inventory:getStorage(storage_id)
        for i = 1, storage.max do
            local item = safeGetItem(data[i])
            if storage.sorted then
                if item then
                    inventory:addItemTo(storage, item)
                end
            else
                inventory:setItem(storage, i, item)
            end
        end
    end

    local inventory = Game.inventory
    if Game:isLight() then
        if not Mod.libs["magical-glass"] then
            Kristal.Console:warn("[color:yellow]\"magical-glass\" library is missing. Cannot load UNDERTALE items.")
        else
            clearStorages(inventory, {"items"})
            clearStorages(inventory, {"box_a"})
            clearStorages(inventory, {"box_b"})
            loadStorage(inventory, "items", self.inventory.items)
            loadStorage(inventory, "box_a", self.inventory.box_a)
            loadStorage(inventory, "box_b", self.inventory.box_b)

            for _,party in ipairs(Kristal.getLibConfig("undertale-loader", "partymemberimport")) do
                if Game:hasPartyMember(party) then
                    local member = Game:getPartyMember(party)
                    member:setWeapon(safeGetItem(self.weapon))
                    member:setArmor(1, safeGetItem(self.armor))
                end
            end
        end
    end
end

return UndertaleSave