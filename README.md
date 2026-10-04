![Modern Liquid Glass UI preview](docs/images/liquid-glass-overview.jpg)

# Modern Liquid Glass

A Roblox client UI library based on the original Liquid Glass design: dark translucent panels, soft blur, rounded corners, and blue accents. The images are conceptual previews; the UI is built at runtime.

## Features

- Draggable, resizable window with tabs and subtabs.
- Buttons, icon buttons, toggles, sliders, inputs, dropdowns, selectors, lists, cards, and a color picker.
- JSON autosave and profiles when the runtime supports `writefile`, `readfile`, and `isfile`; otherwise, settings stay in memory.
- **Language** tab with Roblox locale detection and 12 languages.
- Icon providers for glyphs, Roblox asset IDs, and custom resolvers.

![Conceptual color picker preview](docs/images/chromatic-picker.jpg)

## Example

Run this in a client runtime that supports `loadstring` and `game:HttpGet`. It downloads and runs the complete standalone UI review, including the original tabs and a demo of every control type.

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/Isqrssss/Glass-UI/main/examples/FullReview.lua'))()
```
