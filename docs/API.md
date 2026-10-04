# API

## Biblioteca y ventana

```lua
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))
local ui = Library.new(options)
-- Alias: local ui = Library:CreateWindow(options)
```

Opciones implementadas: `Name`, `Size`, `Position`, `LogoText`, `Title`, `Subtitle` y `ToggleKey` (`Enum.KeyCode`). Si no se pasan, se usan los valores del script original: `ModernLiquidGlass`, 650×430, título “Liquid Glass”, marca “X” y tecla G. Se conservan el blur y la nevada iniciales, así como las doce pestañas predeterminadas.

La instancia expone `Screen`, `Window`, `Blur`, `OpenButton`, `Pages` y `Tabs`. Métodos: `GetTab(name)`, `GetPage(name)`, `CreateTab(name)`, `SelectTab(name)`, `SetVisible(boolean)`, `Toggle()`, `Open()`, `Close()`, `SetSnowing(boolean)`, `Unload()` y `Destroy()`.

## Componentes de pestaña

Obtén un objeto tab con `ui:GetTab("Dashboard")` o `ui:CreateTab("Mi pestaña")`:

- `tab:AddSection(título, subtítuloOpcional)`
- `tab:AddButton(texto, callbackOpcional)`
- `tab:AddToggle(texto, valorInicial, callbackOpcional)`
- `tab:AddSlider(texto, valorInicialPorcentaje, callbackOpcional)` — callback recibe el porcentaje entero mientras se arrastra.
- `tab:AddInput(título, placeholder, callbackOpcional)` — callback recibe el texto al perder foco.
- `tab:AddCard(título, descripción)`
- `tab:AddDropdown(título, opciones, valorInicial, callbackOpcional)`
- `tab:AddSelector(título, opciones, valorInicial, callbackOpcional)`
- `tab:AddList(items, callbackOpcional)` — cada elemento lleva `title` y `meta`; callback recibe el elemento elegido.

La interfaz utiliza el mismo estilo y los mismos factories del script adjunto. La API los expone para reutilizarlos; no añade un tema visual alternativo.
