-- Smoke test manual; ejecutar como LocalScript en una experiencia privada/de prueba.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))
local ui = Library.new({ Name = "ModernLiquidGlassSmokeTest" })

local originalTabs = {
    "Dashboard", "Buttons", "Toggles", "Sliders", "Inputs", "Dropdowns",
    "Selectors", "Lists", "Cards", "Visuals", "Animations", "Settings", "Language",
}
for _, name in ipairs(originalTabs) do
    assert(ui:GetTab(name), "Falta la pestaña original o integrada: " .. name)
end
assert(ui.Screen and ui.Window and ui.Blur, "No se crearon los elementos raíz")
assert(type(ui.StorageAvailable) == "boolean", "Falta el estado del storage")
assert(#ui:GetProfiles() >= 1, "No existe el perfil Default")
assert(ui:GetActiveProfile() ~= nil, "No se informa el perfil activo")

local extra = ui:CreateTab("SmokeTest")
assert(extra and extra.Page, "No se creó la pestaña extendida")
extra:AddButton("Smoke test button")
extra:AddToggle("Smoke test toggle", true, nil, "smoke.toggle")
extra:AddSlider("Smoke test slider", 50, nil, "smoke.slider")
extra:AddInput("Smoke test input", "test", nil, "smoke.input")
extra:AddCard("Smoke test card", "El componente reutiliza el estilo original")
extra:AddDropdown("Smoke test dropdown", { "A", "B" }, "A", nil, "smoke.dropdown")
extra:AddSelector("Smoke test selector", { "A", "B" }, "A", nil, "smoke.selector")
extra:AddList({ { title = "Fila", meta = "OK" } })
extra:AddIconButton("Glyph", "◆", nil, "Glyph")

local sub = extra:CreateSubTab("Subcategory")
assert(sub and sub.Page, "No se creó la subpestaña")
sub:AddButton("Subtab control")
sub:AddColorPicker("Accent test", Color3.fromRGB(45, 145, 255))

assert(ui:RegisterIconProvider("SmokeProvider", function(value)
    return { Kind = "Text", Value = tostring(value) }
end), "No se registró el provider de iconos")
local originalLanguage = ui:SetLanguage("en", false)
assert(originalLanguage == "en", "No se aplicó el idioma inglés")
ui:SetLanguage("es", false)
assert(ui:RegisterTranslations("es", { ["Smoke custom label"] = "Etiqueta de prueba" }), "No se registró el diccionario")

print("ModernLiquidGlassLibrary smoke test: OK")
ui:Unload()
