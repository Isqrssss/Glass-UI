-- Smoke test manual; ejecutar en una experiencia privada/de prueba como LocalScript.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))
local ui = Library.new({ Name = "ModernLiquidGlassSmokeTest" })

local originalTabs = {
    "Dashboard", "Buttons", "Toggles", "Sliders", "Inputs", "Dropdowns",
    "Selectors", "Lists", "Cards", "Visuals", "Animations", "Settings",
}
for _, name in ipairs(originalTabs) do
    assert(ui:GetTab(name), "Falta la pestaña original: " .. name)
end
assert(ui.Screen and ui.Window and ui.Blur, "No se crearon los elementos raíz")
local extra = ui:CreateTab("SmokeTest")
assert(extra and extra.Page, "No se creó la pestaña extendida")
extra:AddButton("Smoke test button")
extra:AddToggle("Smoke test toggle", true)
extra:AddSlider("Smoke test slider", 50)
extra:AddInput("Smoke test input", "test")
extra:AddCard("Smoke test card", "El componente reutiliza el estilo original")
extra:AddDropdown("Smoke test dropdown", { "A", "B" }, "A")
extra:AddSelector("Smoke test selector", { "A", "B" }, "A")
extra:AddList({ { title = "Fila", meta = "OK" } })
print("ModernLiquidGlassLibrary smoke test: OK")
ui:Unload()
