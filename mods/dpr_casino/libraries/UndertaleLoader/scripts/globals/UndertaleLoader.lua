local UndertaleLoader = {}
local self = UndertaleLoader

function UndertaleLoader.init()
    self.saves = {}

    self.path = self.getSaveDirectory()

    if not self.path then
        print("[UndertaleLoader] Unsupported OS: "..love.system.getOS())
        return
    end
end

function UndertaleLoader.load(filter)
    if not self.path then
        return false
    end

    filter = filter or {}

    local function loadFile()
        if self.saves[1] then
            return -- Already loaded
        end

        local file         = io.open(self.path.."/file0",                  "r")
        local erased       = io.open(self.path.."/system_information_962", "r")
        local sold_soul    = io.open(self.path.."/system_information_963", "r")

        if file then
            local data_str = file:read("*all")
            file:close()

            local data = Utils.split(data_str, "\n")

            for i = 1, #data do
                data[i] = string.gsub(data[i], "^%s*(.-)%s*$", "%1")
            end

            local save = UndertaleSave()
            save:parseData(data)
            
            if erased then
                save.sys_info_962 = true
            end
            if sold_soul then
                save.sys_info_963 = true
            end

            self.saves[1] = save
        end
    end

    loadFile()
end

function UndertaleLoader.getSave()
    return self.saves[1]
end

function UndertaleLoader.getSaveDirectory()
    local os_name = love.system.getOS()

    if os_name == "Windows" then
        return string.gsub(os.getenv("LOCALAPPDATA"), "\\", "/") .. "/Undertale/"
    elseif os_name == "OS X" then
        return os.getenv("HOME") .. "/Library/Application Support/com.tobyfox.undertale/"
    elseif os_name == "Linux" then
        -- Tested on: Linux mint, should probably work on all Debian based systems
        -- I know this code is bad

        -- love.filesystem won't read stuff outside of the game
        local function file_exists(file)
            local f = io.open(file, "rb")
            if f then f:close() end
            return f ~= nil
        end

        local home = os.getenv("HOME")
        local winePath = home .. "/.wine/drive_c/users/" .. os.getenv("USER") .. "/Local Settings/Application Data/UNDERTALE/"
        -- Source: https://store.steampowered.com/app/391540
        local steamPath = home .. "/.steam/steam/steamapps/compatdata/391540/pfx/drive_c/users/steamuser/AppData/Local/UNDERTALE/"

        if file_exists(winePath) then -- Get the path from WINE
            return winePath
        elseif file_exists(steamPath) then -- Get the path from steam
            return steamPath
        end
    end
end


return UndertaleLoader
