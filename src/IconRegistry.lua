-- Adaptador de fuentes de iconos. No descarga código ni recursos remotos por su cuenta.
local IconRegistry = { Providers = {} }

local function normalize(name)
    return tostring(name or ""):lower():gsub("[%s_%-]", "")
end

local function asAssetId(value)
    local text = tostring(value or "")
    if text:match("^rbxassetid://%d+$") or text:match("^rbxasset://") then return text end
    local digits = text:match("^(%d+)$")
    if digits then return "rbxassetid://" .. digits end
    return nil
end

IconRegistry.Providers.glyph = function(value)
    return { Kind = "Text", Value = tostring(value or "•") }
end
IconRegistry.Providers.robloxasset = function(value)
    local assetId = asAssetId(value)
    if not assetId then return nil, "Expected a Roblox asset id or rbxassetid:// URL" end
    return { Kind = "Image", Value = assetId }
end
IconRegistry.Providers.assetid = IconRegistry.Providers.robloxasset
IconRegistry.Providers.lucide = function(value)
    if type(value) == "table" then value = value.AssetId or value.Id or value.Asset end
    return IconRegistry.Providers.robloxasset(value)
end
IconRegistry.Providers.robloxfont = IconRegistry.Providers.glyph

function IconRegistry.RegisterProvider(name, resolver)
    if type(name) ~= "string" or name == "" or type(resolver) ~= "function" then
        return false, "RegisterProvider expects a name and resolver function"
    end
    IconRegistry.Providers[normalize(name)] = resolver
    return true
end

function IconRegistry.Resolve(source, value)
    local provider = IconRegistry.Providers[normalize(source)]
    if not provider then return nil, "Unknown icon provider: " .. tostring(source) end
    local ok, result, err = pcall(provider, value)
    if not ok then return nil, tostring(result) end
    if not result then return nil, err or "Icon provider returned no icon" end
    if result.Kind ~= "Image" and result.Kind ~= "Text" then
        return nil, "Icon provider must return Kind='Image' or Kind='Text'"
    end
    return result
end

return IconRegistry
