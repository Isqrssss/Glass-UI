# ModernLiquidGlassLibrary — API

Biblioteca cliente construida a partir de la UI Liquid Glass original. Mantiene su ventana, paleta y controles existentes; las funciones ampliadas reutilizan el mismo estilo.

## Instalación

Importa `src/` como `ModuleScript` (el `default.project.json` de Rojo lo coloca en `ReplicatedStorage.ModernLiquidGlassLibrary`) y úsalo desde un `LocalScript`:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))
local ui = Library.new()
-- Alias: local ui = Library:CreateWindow()
```

`new(options)` admite `Name`, `Size`, `Position`, `LogoText`, `Title`, `Subtitle`, `ToggleKey`, `Language`, `AccentColor`, `GlassAlpha`, `ConfigName`, `ConfigFile` y `SaveDebounce`. Sin opciones visuales conserva los valores originales. La biblioteca conserva las doce pestañas originales y agrega **Language** como última pestaña.

## Ventana

La instancia expone `Screen`, `Window`, `Blur`, `OpenButton`, `Pages`, `Tabs`, `ConfigManager`, `StorageAvailable` y `Localization`.

Métodos: `GetTab(name)`, `GetPage(name)`, `CreateTab(name)`, `SelectTab(name)`, `SetVisible(boolean)`, `Toggle()`, `Open()`, `Close()`, `SetSnowing(boolean)`, `Unload()` y `Destroy()`.

## Controles

Los métodos de tab reciben un identificador opcional al final. Si no se proporciona, se usa el nombre de la página, tipo de control y etiqueta para formar una clave estable de autosave; usa un ID explícito cuando haya etiquetas repetidas.

- `tab:AddSection(título, subtítuloOpcional)`
- `tab:AddButton(texto, callbackOpcional)`
- `tab:AddToggle(texto, valorInicial, callbackOpcional, idOpcional)`
- `tab:AddSlider(texto, valorInicialPorcentaje, callbackOpcional, idOpcional)` — callback recibe un entero de 0 a 100 mientras se arrastra.
- `tab:AddInput(título, placeholder, callbackOpcional, idOpcional)` — callback al perder foco; el texto también se autosalva.
- `tab:AddCard(título, descripción)`
- `tab:AddDropdown(título, opciones, valorInicial, callbackOpcional, idOpcional)`
- `tab:AddSelector(título, opciones, valorInicial, callbackOpcional, idOpcional)`
- `tab:AddList(items, callbackOpcional, idOpcional)` — cada elemento lleva `title` y `meta`; la última fila activada también se autosalva.
- `tab:AddColorPicker(título, colorInicial, callbackOpcional)` — selector cromático circular; el callback recibe `Color3`.
- `tab:AddIconButton(texto, nombreOId, callbackOpcional, proveedorOpcional)`
- `tab:CreateSubTab(nombre)` — devuelve otro objeto tab con los mismos métodos y controles.

Ejemplo de subpestañas:

```lua
local tools = ui:CreateTab("Tools")
local general = tools:CreateSubTab("General")
local appearance = tools:CreateSubTab("Appearance")
general:AddToggle("Enabled", true, function(value) print(value) end, "tools.enabled")
appearance:AddColorPicker("Accent", Color3.fromRGB(45, 145, 255))
```

## Autosave y perfiles

Cada toggle, slider, input, dropdown, selector y selección de lista persiste automáticamente; también se guardan idioma, color de acento, opacidad del vidrio, posición y tamaño al cambiarse. La configuración se escribe como JSON local en `ConfigFile` (por defecto `<Name>.json`) con debounce.

La escritura persistente requiere que el runtime cliente proporcione `writefile`, `readfile` e `isfile`. En Roblox Studio estándar, donde esas funciones no existen, `StorageAvailable` será `false` y la biblioteca sigue funcionando en memoria. El módulo **no** envía la configuración a servidores ni guarda código/callbacks; solo conserva valores serializables de controles y ajustes.

El archivo contiene un perfil `Default`, se carga automáticamente al iniciar, y la API permite gestionar más perfiles:

```lua
ui:CreateProfile("PvP", true) -- clona el perfil activo y lo activa
ui:SaveProfile("PvP")        -- copia el estado actual al perfil indicado y lo activa
ui:LoadProfile("Default")    -- aplica controles y tema; devuelve true o false, error
ui:GetProfiles()               -- nombres ordenados
ui:GetActiveProfile()          -- nombre activo
ui:DeleteProfile("PvP")       -- no permite borrar Default
```

`CreateProfile(name, false)` crea un perfil vacío y aplica los valores predeterminados de los controles y del tema. Al borrar el perfil activo, la interfaz vuelve a `Default`.

## Idiomas

La última pestaña, **Language**, ofrece: English, Español, Português, Français, Deutsch, Italiano, Русский, 中文（简体）, 日本語, 한국어, العربية y Türkçe. El idioma inicial se detecta con el locale de Roblox (`LocalizationService.RobloxLocaleId`); un idioma seleccionado se recuerda y reemplaza la detección en los siguientes inicios.

```lua
ui:SetLanguage("es")
ui:SetLanguage("Português") -- también acepta los nombres visibles
ui:RegisterTranslations("es", {
    ["My custom label"] = "Mi etiqueta",
})
```

Las traducciones usan la cadena original exacta como clave. Las claves que no estén en un diccionario conservan el texto de origen.

## Proveedores de iconos

Proveedores integrados: `Glyph` (un carácter), `RobloxAsset`/`AssetId` (ID o URL `rbxassetid://`), `Lucide` (IDs de assets subidos; acepta una tabla con `AssetId`, `Id` o `Asset`) y `RobloxFont` (glifo de texto). No se descarga ni ejecuta código remoto.

```lua
local ok, err = ui:RegisterIconProvider("MyLucide", function(name)
    local ids = { check = "rbxassetid://1234567890" } -- reemplazar por un asset propio
    local id = ids[name]
    if not id then return nil, "Icon not found" end
    return { Kind = "Image", Value = id }
end)
local tab = ui:CreateTab("Icons")
tab:AddIconButton("Check", "check", function() end, "MyLucide")
```

El resolver debe devolver `{ Kind = "Image", Value = assetId }` o `{ Kind = "Text", Value = glyph }`.

## Limpieza

Llama `ui:Unload()` o `ui:Destroy()` al terminar. Se guardan los últimos ajustes y se eliminan GUI, blur y conexiones creadas por la biblioteca.
