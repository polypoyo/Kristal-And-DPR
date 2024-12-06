local PluginLoader = {
    plugin_scripts = {},
    script_chunks = {}
}

---@return fun(): table?, boolean?, table?
function PluginLoader.iterPlugins(active_only)
    local index = 0
    local all_mods = Kristal.Mods.getMods()
    return function()
        repeat
            index = index + 1
            if index > #all_mods then return nil end
            if all_mods[index].plugin then
                if Kristal.Config["plugins/enabled_plugins"][all_mods[index].id] or (active_only ~= true) then
                    return all_mods[index],
                        Kristal.Config["plugins/enabled_plugins"][all_mods[index].id],
                        Kristal.PluginLoader.plugin_scripts[all_mods[index].id] or {}
                end
            end
        until index > #all_mods
    end
end

return PluginLoader