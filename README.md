![Modern Liquid Glass UI preview](docs/images/liquid-glass-overview.jpg)

# Modern Liquid Glass

A Roblox client UI library based on the original Liquid Glass design. It features dark translucent panels, soft blur, rounded corners, and blue accents. The previews are conceptual; the library builds the functional UI at runtime.

## Features

- Draggable, resizable window with tabs and subtabs.
- Buttons, toggles, sliders, inputs, dropdowns, selectors, lists, and cards.
- Circular color picker with brightness and opacity controls.
- JSON autosave and profiles when the runtime supports `writefile`, `readfile`, and `isfile`; otherwise, it runs in memory.
- Final **Language** tab with Roblox locale detection and 12 languages.
- Icon providers for glyphs, Roblox asset IDs, and custom resolvers.

![Conceptual color picker preview](docs/images/chromatic-picker.jpg)

## Example

Import `src` as a `ModernLiquidGlassLibrary` ModuleScript in `ReplicatedStorage`, then run this from a `LocalScript`:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))

local ui = Library.new({ Title = "Liquid Glass", Language = "en", ConfigName = "Example" })
local tab = ui:CreateTab("Demo")

tab:AddSection("Controls")
tab:AddButton("Run action", function() print("Action triggered") end)
tab:AddToggle("Enabled", true, function(value) print("Enabled:", value) end, "demo.enabled")
tab:AddSlider("Intensity", 70, function(value) print("Intensity:", value) end, "demo.intensity")
tab:AddDropdown("Mode", { "Balanced", "Fast" }, "Balanced", function(value) print("Mode:", value) end)

local appearance = tab:CreateSubTab("Appearance")
appearance:AddColorPicker("Accent", Color3.fromRGB(45, 145, 255))
```
