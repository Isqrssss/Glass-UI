-- Ejemplo de funciones core añadidas a ModernLiquidGlassLibrary.
-- Ejecutar como LocalScript después de importar el ModuleScript en ReplicatedStorage.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))
local ui = Library.new()

local tools = ui:CreateTab("Core Features")
local general = tools:CreateSubTab("General")
local appearance = tools:CreateSubTab("Appearance")

-- Este toggle y slider se restauran automáticamente al volver a ejecutar.
general:AddSection("Autosave", "El estado del usuario se guarda en segundo plano")
general:AddToggle("Demo enabled", true, function(enabled)
    print("Demo enabled:", enabled)
end, "core.demo-enabled")
general:AddSlider("Intensity", 65, function(value)
    print("Intensity:", value)
end, "core.intensity")
general:AddDropdown("Quality", { "High", "Medium", "Low" }, "High", function(value)
    print("Quality:", value)
end, "core.quality")
general:AddSelector("Layout", { "Compact", "Comfort", "Airy" }, "Comfort", nil, "core.layout")
general:AddIconButton("Glyph icon", "◆", function()
    print("Icon button activated")
end, "Glyph")

appearance:AddSection("Appearance", "Accent and glass effects")
appearance:AddColorPicker("Accent color", Color3.fromRGB(45, 145, 255), function(color)
    print("Accent changed:", color)
end)
appearance:AddCard("Profiles", "Use the profile methods shown in docs/API.md to create and load presets.")

-- El paquete también incluye la pestaña Language como última pestaña.
-- Localización manual y diccionario personalizado:
ui:SetLanguage("en")
ui:RegisterTranslations("es", {
    ["Demo enabled"] = "Demo activada",
    ["Intensity"] = "Intensidad",
})

-- Ejemplo de perfiles (descomentar si quieres crear y activar este perfil):
-- ui:CreateProfile("PvP", true)
-- ui:LoadProfile("Default")

_G.ModernLiquidGlassCoreExample = ui
