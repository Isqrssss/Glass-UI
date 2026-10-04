-- Persistencia opcional para runtimes cliente con writefile/readfile/isfile.
-- En Roblox Studio sin esas funciones, conserva el estado en memoria y no rompe la UI.
local HttpService = game:GetService("HttpService")
local ConfigManager = {}
ConfigManager.__index = ConfigManager

local function clone(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local result = {}
    seen[value] = result
    for key, item in pairs(value) do
        result[clone(key, seen)] = clone(item, seen)
    end
    return result
end

local function resolveGlobal(name)
    local environments = {}
    pcall(function()
        if type(getgenv) == "function" then
            local env = getgenv()
            if type(env) == "table" then table.insert(environments, env) end
        end
    end)
    pcall(function()
        if type(_G) == "table" then table.insert(environments, _G) end
    end)
    pcall(function()
        if type(getfenv) == "function" then
            local env = getfenv(0)
            if type(env) == "table" then table.insert(environments, env) end
        end
    end)
    for _, env in ipairs(environments) do
        local value = rawget(env, name)
        if type(value) == "function" then return value end
    end
    return nil
end

local function emptyProfile()
    return { Controls = {}, Settings = {} }
end

function ConfigManager.new(filePath, debounceSeconds)
    local self = setmetatable({}, ConfigManager)
    self.Path = filePath or "ModernLiquidGlass.json"
    self.DebounceSeconds = debounceSeconds or 0.45
    self._readfile = resolveGlobal("readfile")
    self._writefile = resolveGlobal("writefile")
    self._isfile = resolveGlobal("isfile")
    self._revision = 0
    self._suspended = false
    self.StorageAvailable = type(self._readfile) == "function"
        and type(self._writefile) == "function"
        and type(self._isfile) == "function"

    self.Data = {
        Version = 1,
        ActiveProfile = "Default",
        Profiles = { Default = emptyProfile() },
    }

    if self.StorageAvailable then
        local ok, exists = pcall(self._isfile, self.Path)
        if ok and exists then
            local readOk, encoded = pcall(self._readfile, self.Path)
            if readOk and type(encoded) == "string" then
                local decodeOk, decoded = pcall(function()
                    return HttpService:JSONDecode(encoded)
                end)
                if decodeOk and type(decoded) == "table" then
                    if type(decoded.Profiles) == "table" then
                        self.Data = decoded
                    end
                end
            end
        end
    end

    if type(self.Data.Profiles) ~= "table" then self.Data.Profiles = {} end
    if type(self.Data.Profiles.Default) ~= "table" then
        self.Data.Profiles.Default = emptyProfile()
    end
    if type(self.Data.ActiveProfile) ~= "string"
        or type(self.Data.Profiles[self.Data.ActiveProfile]) ~= "table" then
        self.Data.ActiveProfile = "Default"
    end
    for profileName, profile in pairs(self.Data.Profiles) do
        if type(profile) ~= "table" then
            self.Data.Profiles[profileName] = emptyProfile()
        else
            if type(profile.Controls) ~= "table" then profile.Controls = {} end
            if type(profile.Settings) ~= "table" then profile.Settings = {} end
        end
    end
    return self
end

function ConfigManager:_active()
    local profile = self.Data.Profiles[self.Data.ActiveProfile]
    if type(profile) ~= "table" then
        profile = emptyProfile()
        self.Data.Profiles[self.Data.ActiveProfile] = profile
    end
    profile.Controls = type(profile.Controls) == "table" and profile.Controls or {}
    profile.Settings = type(profile.Settings) == "table" and profile.Settings or {}
    return profile
end

function ConfigManager:GetControl(key, defaultValue)
    local value = self:_active().Controls[key]
    if value == nil then return defaultValue end
    return clone(value)
end

function ConfigManager:SetControl(key, value)
    if self._suspended then return end
    self:_active().Controls[key] = clone(value)
    self:ScheduleSave()
end

function ConfigManager:GetSetting(key, defaultValue)
    local value = self:_active().Settings[key]
    if value == nil then return defaultValue end
    return clone(value)
end

function ConfigManager:SetSetting(key, value)
    if self._suspended then return end
    self:_active().Settings[key] = clone(value)
    self:ScheduleSave()
end

function ConfigManager:SetSuspended(value)
    self._suspended = value == true
end

function ConfigManager:ScheduleSave()
    if self._suspended then return end
    self._revision = self._revision + 1
    local revision = self._revision
    task.delay(self.DebounceSeconds, function()
        if revision == self._revision then self:SaveNow() end
    end)
end

function ConfigManager:SaveNow()
    self._revision = self._revision + 1
    if not self.StorageAvailable then
        return false, "writefile/readfile/isfile are unavailable; keeping settings in memory"
    end
    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(self.Data)
    end)
    if not encodeOk then return false, tostring(encoded) end
    local writeOk, writeError = pcall(self._writefile, self.Path, encoded)
    if not writeOk then return false, tostring(writeError) end
    return true
end

function ConfigManager:GetProfileNames()
    local names = {}
    for name in pairs(self.Data.Profiles) do table.insert(names, name) end
    table.sort(names)
    return names
end

function ConfigManager:GetActiveProfile()
    return self.Data.ActiveProfile
end

function ConfigManager:CreateProfile(name, copyActive)
    if type(name) ~= "string" or name:match("^%s*$") then
        return false, "Profile name must not be empty"
    end
    name = name:sub(1, 48)
    if self.Data.Profiles[name] then return false, "Profile already exists" end
    self.Data.Profiles[name] = copyActive and clone(self:_active()) or emptyProfile()
    self.Data.ActiveProfile = name
    self:ScheduleSave()
    return true
end

function ConfigManager:SaveProfile(name)
    if type(name) ~= "string" or name:match("^%s*$") then
        return false, "Profile name must not be empty"
    end
    name = name:sub(1, 48)
    self.Data.Profiles[name] = clone(self:_active())
    self.Data.ActiveProfile = name
    self:ScheduleSave()
    return true
end

function ConfigManager:LoadProfile(name)
    if type(name) ~= "string" or type(self.Data.Profiles[name]) ~= "table" then
        return nil, "Profile not found"
    end
    self.Data.ActiveProfile = name
    self:ScheduleSave()
    return clone(self.Data.Profiles[name])
end

function ConfigManager:DeleteProfile(name)
    if name == "Default" then return false, "The Default profile cannot be deleted" end
    if type(self.Data.Profiles[name]) ~= "table" then return false, "Profile not found" end
    self.Data.Profiles[name] = nil
    if self.Data.ActiveProfile == name then self.Data.ActiveProfile = "Default" end
    self:ScheduleSave()
    return true
end

return ConfigManager
