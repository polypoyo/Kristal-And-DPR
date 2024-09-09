Put lib config in main, include:

    Config:
        extra.json:
            "save_after_modification": false,   //Save keybinds when modifying them.
            "cancel_to_exit": false,            //Allow you to press the cancel key to get out of the binding menu.
            "hide_if_no_extra": true,           //Hide the page counter and the arrows when there is no extra keybind.
            "show_arrow": true,                 //Show arrows next to the page counter if conditions are met.
            "banned_key": {                     //List of key to hide in the binding menu. (Contains an example)
                //"Name_of_key": "id_of_key"
                "Console": "console",
                "Debug Menu": "debug_menu",
                "Object Selector": "object_selector",
                "Fast Forward": "fast_forward",
            }

        MainMenuModConfig:registerOptions()
            orig(self)

            self.registerOption("save_after_modification",      "Save keybind after modification",                                          "selection", {nil, true, false})
            self.registerOption("cancel_to_exit",               "Allow you to press the cancel key to get out of the binding menu.",        "selection", {nil, true, false})
            self.registerOption("hide_if_no_extra",             "Hide the page counter and the arrows when there is no extra keybind.",     "selection", {nil, true, false})
            self.registerOption("show_arrow",                   "Show arrows next to the page counter if conditions are met.",              "selection", {nil, true, false})
            self.registerOption("banned_key",                   "Require manual config. Default to Debug Keys",                             "selection", {nil})

        end

        Game:getConfig(key, merge, deep_merge)
            local default_config = Kristal.ChapterConfigs[Utils.clamp(self.chapter, 1, #Kristal.ChapterConfigs)]
            local extra_config = Kristal.ExtraConfigs

            if not Mod then return default_config[key], extra_config end

            local mod_result = Kristal.callEvent(KRISTAL_EVENT.getConfig, key)
            if mod_result ~= nil then return mod_result end

            local mod_config = Mod.info and Mod.info.config and Utils.getAnyCase(Mod.info.config, "kristal") or {}

            local default_value = Utils.getAnyCase(default_config, key)
            local extra_value = Utils.getAnyCase(extra_config, key)
            local mod_value = Utils.getAnyCase(mod_config, key)

            if mod_value ~= nil and default_value == nil then
                return mod_value
            elseif default_value ~= nil and mod_value == nil then
                return default_value
            elseif type(default_value) == "table" and merge then
                return Utils.merge(Utils.copy(default_value, true), mod_value, deep_merge)
            else
                return mod_value
            end

        end

        (Kistal)love.load(args)
            orig(self)

            Kristal.ExtraConfigs = JSON.decode(love.filesystem.read("configs/extra.json"))

        end

    For rebinds:
        