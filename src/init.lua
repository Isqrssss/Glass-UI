-- Liquid Glass UI de la usuaria, convertido a biblioteca reutilizable.
-- Conserva el diseño original: glass azul, logo X, nieve, blur, resize y 12 pestañas.
-- Uso: local UI = require(path.LiquidGlassUI); local window = UI.new({})
-- También expone UI:CreateWindow({}). El estilo y las demos originales se mantienen.

-- Liquid Glass UI
-- LocalScript / executor-compatible client UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")


local LiquidGlassUI = {}
LiquidGlassUI.__index = LiquidGlassUI
LiquidGlassUI.Version = "1.0.0-original"

function LiquidGlassUI.new(options)
    options = options or {}

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURATION
--==================================================
local GUI_NAME = options.Name or "ModernLiquidGlass"
local TOGGLE_ACTION = "ToggleLiquidGlassUI_" .. GUI_NAME

local BLUE = Color3.fromRGB(45, 145, 255)
local BLUE_LIGHT = Color3.fromRGB(95, 185, 255)
local WHITE = Color3.fromRGB(245, 249, 255)
local TEXT_SECONDARY = Color3.fromRGB(165, 177, 195)
local GLASS = Color3.fromRGB(15, 22, 34)
local GLASS_LIGHT = Color3.fromRGB(35, 48, 68)
local MATTE_BLACK = Color3.fromRGB(20, 20, 25)

local MIN_WIDTH, MIN_HEIGHT = 310, 320
local MAX_WIDTH, MAX_HEIGHT = 850, 620

--==================================================
-- INSTANCE CLEANUP & ANTI-LEAK
--==================================================
local old = PlayerGui:FindFirstChild(GUI_NAME)
if old then
    old:Destroy()
end

local oldBlur = Lighting:FindFirstChild("ModernLiquidGlassBlur")
if oldBlur then
    oldBlur:Destroy()
end

local Janitor = { Connections = {} }
local CloseUI, OpenUI, Unload



function Janitor:Add(conn)
    table.insert(self.Connections, conn)
end

function Janitor:Clean()
    for _, conn in ipairs(self.Connections) do
        if conn then
            conn:Disconnect()
        end
    end
    self.Connections = {}
end

--==================================================
-- INTERPOLATION & SPRING PHYSICS HELPERS
--==================================================
local function Create(className, properties, parent)
    local object = Instance.new(className)
    for prop, val in pairs(properties or {}) do
        object[prop] = val
    end
    object.Parent = parent
    return object
end

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function Stroke(object, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(210, 235, 255)
    stroke.Transparency = transparency or 0.8
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = object
    return stroke
end

local function FrameSafeLerp(start, target, alpha, dt)
    local compl = 1 - math.exp(-alpha * (dt * 60))
    if type(start) == "number" then
        return start + (target - start) * compl
    elseif typeof(start) == "UDim2" then
        return UDim2.new(
            start.X.Scale + (target.X.Scale - start.X.Scale) * compl,
            start.X.Offset + (target.X.Offset - start.X.Offset) * compl,
            start.Y.Scale + (target.Y.Scale - start.Y.Scale) * compl,
            start.Y.Offset + (target.Y.Offset - start.Y.Offset) * compl
        )
    end
    return target
end

local function Animate(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            style or Enum.EasingStyle.Quart,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

--==================================================
-- RECT CORE STRUCTS
--==================================================
local Blur = Create("BlurEffect", {
    Name = "ModernLiquidGlassBlur",
    Size = 14,
    Enabled = true,
}, Lighting)

local Screen = Create("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, PlayerGui)

local WindowScale = Create("UIScale", { Scale = 1 })

local Window = Create("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = options.Position or UDim2.fromScale(0.5, 0.5),
    Size = options.Size or UDim2.fromOffset(650, 430),
    BackgroundColor3 = GLASS,
    BackgroundTransparency = 0.18,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 10,
    Visible = true,
}, Screen)
WindowScale.Parent = Window
Corner(Window, 24)
Stroke(Window, 0.72, 1)

Create("UISizeConstraint", {
    MinSize = Vector2.new(MIN_WIDTH, MIN_HEIGHT),
    MaxSize = Vector2.new(MAX_WIDTH, MAX_HEIGHT),
}, Window)

local SnowCanvas = Create("Frame", {
    Name = "SnowCanvas",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ClipsDescendants = false,
    ZIndex = 1,
}, Screen)

local GlassHighlight = Create("Frame", {
    Name = "GlassHighlight",
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundColor3 = Color3.fromRGB(120, 190, 255),
    BackgroundTransparency = 0.96,
    BorderSizePixel = 0,
    ZIndex = 11,
}, Window)
Corner(GlassHighlight, 24)

local TopLight = Create("Frame", {
    Size = UDim2.new(0.65, 0, 0, 2),
    Position = UDim2.new(0.175, 0, 0, 0),
    BackgroundColor3 = BLUE_LIGHT,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ZIndex = 100,
}, Window)
Corner(TopLight, 10)

local Header = Create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 72),
    BackgroundColor3 = GLASS_LIGHT,
    BackgroundTransparency = 0.58,
    BorderSizePixel = 0,
    ZIndex = 30,
}, Window)
Corner(Header, 23)

local DragArea = Create("TextButton", {
    Name = "DragArea",
    Size = UDim2.new(1, -70, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    AutoButtonColor = false,
    Active = true,
    ZIndex = 200,
}, Header)

--==================================================
-- LOGO REDESIGN & MODERN BRANDING
--==================================================
local LogoHolder = Create("Frame", {
    Name = "LogoHolder",
    Size = UDim2.fromOffset(44, 44),
    Position = UDim2.fromOffset(14, 14),
    BackgroundColor3 = MATTE_BLACK,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    ZIndex = 50,
}, Header)
Corner(LogoHolder, 12)
Stroke(LogoHolder, 0.85, 1)

local LogoGlow = Create("Frame", {
    Size = UDim2.new(1, 10, 1, 10),
    Position = UDim2.fromOffset(-5, -5),
    BackgroundColor3 = BLUE,
    BackgroundTransparency = 0.95,
    BorderSizePixel = 0,
    ZIndex = 49,
}, LogoHolder)
Corner(LogoGlow, 15)

local LogoText = Create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = options.LogoText or "X",
    TextColor3 = WHITE,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    ZIndex = 52,
}, LogoHolder)

Create("TextLabel", {
    Size = UDim2.new(1, -190, 0, 26),
    Position = UDim2.fromOffset(72, 12),
    BackgroundTransparency = 1,
    Text = options.Title or "Liquid Glass",
    TextColor3 = WHITE,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 50,
}, Header)

Create("TextLabel", {
    Size = UDim2.new(1, -190, 0, 18),
    Position = UDim2.fromOffset(73, 39),
    BackgroundTransparency = 1,
    Text = options.Subtitle or "Modern interface",
    TextColor3 = TEXT_SECONDARY,
    TextSize = 9,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 50,
}, Header)

local Status = Create("Frame", {
    Size = UDim2.fromOffset(7, 7),
    Position = UDim2.new(1, -93, 0, 22),
    BackgroundColor3 = BLUE_LIGHT,
    BorderSizePixel = 0,
    ZIndex = 60,
}, Header)
Corner(Status, 10)

local Close = Create("TextButton", {
    Name = "Close",
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.new(1, -55, 0, 15),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = 0.91,
    BorderSizePixel = 0,
    Text = "x",
    TextColor3 = WHITE,
    TextSize = 19,
    Font = Enum.Font.Gotham,
    AutoButtonColor = false,
    ZIndex = 250,
}, Header)
Corner(Close, 14)
Stroke(Close, 0.86)

Janitor:Add(Close.MouseEnter:Connect(function()
    Animate(Close, { BackgroundColor3 = BLUE, BackgroundTransparency = 0.15 }, 0.15)
end))
Janitor:Add(Close.MouseLeave:Connect(function()
    Animate(Close, { BackgroundColor3 = WHITE, BackgroundTransparency = 0.91 }, 0.15)
end))

local Body = Create("Frame", {
    Name = "Body",
    Size = UDim2.new(1, 0, 1, -72),
    Position = UDim2.fromOffset(0, 72),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 20,
}, Window)

local Sidebar = Create("ScrollingFrame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 155, 1, -18),
    Position = UDim2.fromOffset(10, 9),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
    ZIndex = 30,
}, Body)
Create("UIPadding", {
    PaddingTop = UDim.new(0, 3),
    PaddingBottom = UDim.new(0, 8),
}, Sidebar)
Create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Sidebar)

local Content = Create("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -176, 1, -18),
    Position = UDim2.fromOffset(169, 9),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 30,
}, Body)

--==================================================
-- CANVAS SNOWFALL PARTICLE SYSTEM (Matcha Parallax — 3 capas de profundidad)
--==================================================
local MAX_COPOS       = 150
local FRECUENCIA_COPO = 0.35   -- prob. por frame de generar un copo

local coposActivos = {}
local IsSnowing    = false

-- Template base para clonar copos (sin Parent para que no se muestre)
local copoTemplate = Instance.new("Frame")
copoTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
copoTemplate.BorderSizePixel  = 0
local _tc = Instance.new("UICorner")
_tc.CornerRadius = UDim.new(1, 0)
_tc.Parent = copoTemplate

local function SpawnSnowflake()
    if not IsSnowing or #coposActivos >= MAX_COPOS then return end

    local copo  = copoTemplate:Clone()
    local capa  = math.random(1, 3)
    local tamano, transparencia, velBase, zIdx

    if capa == 1 then           -- Fondo lejano: pequeño, lento, tenue
        tamano       = math.random(2, 3)
        transparencia = math.random(6, 8) / 10
        velBase      = math.random(40, 80)   / 10000
        zIdx         = 2
    elseif capa == 2 then       -- Capa media: estándar
        tamano       = math.random(4, 5)
        transparencia = math.random(3, 5) / 10
        velBase      = math.random(90, 140)  / 10000
        zIdx         = 3
    else                        -- Primer plano: grande, rápido, nítido
        tamano       = math.random(6, 8)
        transparencia = math.random(1, 2) / 10
        velBase      = math.random(160, 240) / 10000
        zIdx         = 4
    end

    copo.Size                 = UDim2.new(0, tamano, 0, tamano)
    copo.BackgroundTransparency = transparencia
    copo.ZIndex               = zIdx
    copo.Position             = UDim2.new(math.random(), 0, -0.05, 0)
    copo.Parent               = SnowCanvas

    table.insert(coposActivos, {
        Instancia       = copo,
        Y               = -0.05,
        X               = copo.Position.X.Scale,
        VelY            = velBase,
        FrecuenciaViento = math.random(1, 4),
        AmplitudViento  = math.random(5, 15) / 10000,
        TiempoInterno   = math.random(0, 100),
    })
end

local function UpdateSnowfall(dt)
    if not IsSnowing and #coposActivos == 0 then return end

    if IsSnowing and math.random() < FRECUENCIA_COPO then
        SpawnSnowflake()
    end

    local velFrame = dt * 60
    for i = #coposActivos, 1, -1 do
        local d = coposActivos[i]
        if d.Instancia and d.Instancia.Parent then
            d.TiempoInterno = d.TiempoInterno + (dt * d.FrecuenciaViento)
            d.Y = d.Y + (d.VelY * velFrame)
            local seno = math.sin(d.TiempoInterno) * d.AmplitudViento
            d.X = d.X + (seno * velFrame)
            d.Instancia.Position = UDim2.new(d.X, 0, d.Y, 0)
            if d.Y > 1.05 then
                d.Instancia:Destroy()
                table.remove(coposActivos, i)
            end
        else
            table.remove(coposActivos, i)
        end
    end
end

local function ClearAllSnow()
    IsSnowing = false
    for _, d in ipairs(coposActivos) do
        if d.Instancia then d.Instancia:Destroy() end
    end
    table.clear(coposActivos)
end

--==================================================
-- HIGH-REFRESH RATE INPUT HANDLING
--==================================================
local State = {
    Dragging = false,
    DragStart = nil,
    StartWindowPos = nil,
    Resizing = false,
    ResizeStart = nil,
    StartWindowSize = nil,
    Sliding = false,
    CurrentSliderFill = nil,
    CurrentSliderKnob = nil,
    CurrentSliderLabel = nil,
    CurrentSliderBar = nil,
    CurrentSliderCallback = nil,
    CurrentSliderValue = nil,
}

Janitor:Add(RunService.RenderStepped:Connect(function(dt)
    UpdateSnowfall(dt)

    local mousePos = UserInputService:GetMouseLocation()

    if State.Dragging and State.DragStart and State.StartWindowPos then
        local delta = mousePos - State.DragStart
        local targetPos = UDim2.new(
            State.StartWindowPos.X.Scale,
            State.StartWindowPos.X.Offset + delta.X,
            State.StartWindowPos.Y.Scale,
            State.StartWindowPos.Y.Offset + delta.Y
        )
        Window.Position = FrameSafeLerp(Window.Position, targetPos, 0.35, dt)
    end

    if State.Resizing and State.ResizeStart and State.StartWindowSize then
        local delta = mousePos - State.ResizeStart
        local w = math.clamp(State.StartWindowSize.X + delta.X, MIN_WIDTH, MAX_WIDTH)
        local h = math.clamp(State.StartWindowSize.Y + delta.Y, MIN_HEIGHT, MAX_HEIGHT)
        Window.Size = UDim2.fromOffset(w, h)
    end

    if State.Sliding and State.CurrentSliderBar then
        local bar = State.CurrentSliderBar
        local width = bar.AbsoluteSize.X
        if width > 0 then
            local percent = math.clamp((mousePos.X - bar.AbsolutePosition.X) / width, 0, 1)
            local value = math.round(percent * 100)
            State.CurrentSliderFill.Size = FrameSafeLerp(State.CurrentSliderFill.Size, UDim2.new(percent, 0, 1, 0), 0.45, dt)
            State.CurrentSliderKnob.Position = FrameSafeLerp(State.CurrentSliderKnob.Position, UDim2.new(percent, -8, 0.5, -8), 0.45, dt)
            State.CurrentSliderLabel.Text = tostring(value) .. "%"
            if State.CurrentSliderValue ~= value then
                State.CurrentSliderValue = value
                if State.CurrentSliderCallback then
                    local ok, err = pcall(State.CurrentSliderCallback, value)
                    if not ok then warn("[ModernLiquidGlass] Slider callback error: " .. tostring(err)) end
                end
            end
        end
    end
end))

Janitor:Add(DragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        State.Dragging = true
        State.DragStart = UserInputService:GetMouseLocation()
        State.StartWindowPos = Window.Position
    end
end))

Janitor:Add(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        State.Dragging = false
        State.Resizing = false
        State.Sliding = false
    end
end))

--==================================================
-- TABS & COMPONENT FACTORIES
--==================================================
local TabNames = {
    "Dashboard",
    "Buttons",
    "Toggles",
    "Sliders",
    "Inputs",
    "Dropdowns",
    "Selectors",
    "Lists",
    "Cards",
    "Visuals",
    "Animations",
    "Settings",
}

local Pages, TabButtons = {}, {}

local function CreatePage(name)
    local page = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = BLUE,
        ScrollBarImageTransparency = 0.35,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Visible = false,
        ZIndex = 40,
    }, Content)
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 20),
    }, page)
    Create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    Pages[name] = page
    return page
end

for _, name in ipairs(TabNames) do
    local button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -4, 0, 30),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.97,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = Color3.fromRGB(205, 216, 232),
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        ZIndex = 50,
    }, Sidebar)
    Corner(button, 10)
    Stroke(button, 0.95)
    Create("UIPadding", { PaddingLeft = UDim.new(0, 12) }, button)
    TabButtons[name] = button
    CreatePage(name)
end

local function SectionTitle(page, title, subtitle)
    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
    }, page)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.fromOffset(0, 27),
        BackgroundTransparency = 1,
        Text = subtitle or "",
        TextColor3 = TEXT_SECONDARY,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)
    return holder
end

local function AddButton(page, text, callback)
    local button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
    }, page)
    Corner(button, 10)
    Stroke(button, 0.92)

    local scale = Create("UIScale", { Scale = 1 }, button)

    Janitor:Add(button.MouseEnter:Connect(function()
        Animate(button, { BackgroundColor3 = BLUE, BackgroundTransparency = 0.45 }, 0.16)
    end))
    Janitor:Add(button.MouseLeave:Connect(function()
        Animate(button, { BackgroundColor3 = WHITE, BackgroundTransparency = 0.96 }, 0.18)
    end))
    Janitor:Add(button.Activated:Connect(function()
        Animate(scale, { Scale = 0.96 }, 0.07)
        task.delay(0.07, function()
            if button.Parent then
                Animate(scale, { Scale = 1 }, 0.13)
            end
        end)
        if callback then
            callback()
        end
    end))

    return button
end

local function AddToggle(page, text, default, callback)
    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
    }, page)
    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)

    local switch = Create("TextButton", {
        Size = UDim2.fromOffset(45, 25),
        Position = UDim2.new(1, -45, 0.5, -12),
        BackgroundColor3 = default and BLUE or Color3.fromRGB(58, 67, 82),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, holder)
    Corner(switch, 20)

    local dot = Create("Frame", {
        Size = UDim2.fromOffset(19, 19),
        Position = default and UDim2.new(1, -22, 0.5, -9) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
    }, switch)
    Corner(dot, 20)

    local state = default
    Janitor:Add(switch.Activated:Connect(function()
        state = not state
        Animate(switch, {
            BackgroundColor3 = state and BLUE or Color3.fromRGB(58, 67, 82),
        }, 0.18)
        Animate(dot, {
            Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.fromOffset(3, 3),
        }, 0.18)
        if callback then
            callback(state)
        end
    end))

    return holder
end

local function AddSlider(page, text, startingValue, callback)
    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 59),
        BackgroundTransparency = 1,
    }, page)
    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)

    local valueLabel = Create("TextLabel", {
        Size = UDim2.fromOffset(55, 20),
        Position = UDim2.new(1, -55, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(startingValue) .. "%",
        TextColor3 = BLUE_LIGHT,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, holder)

    local bar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.fromOffset(0, 35),
        BackgroundColor3 = Color3.fromRGB(57, 65, 79),
        BorderSizePixel = 0,
    }, holder)
    Corner(bar, 10)

    local fill = Create("Frame", {
        Size = UDim2.new(startingValue / 100, 0, 1, 0),
        BackgroundColor3 = BLUE,
        BorderSizePixel = 0,
    }, bar)
    Corner(fill, 10)

    local knob = Create("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(startingValue / 100, -8, 0.5, -8),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, bar)
    Corner(knob, 20)

    local hitbox = Create("TextButton", {
        Size = UDim2.new(1, 24, 0, 34),
        Position = UDim2.new(0, -12, 0.5, -17),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10,
    }, bar)

    Janitor:Add(hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            State.Sliding = true
            State.CurrentSliderBar = bar
            State.CurrentSliderFill = fill
            State.CurrentSliderKnob = knob
            State.CurrentSliderLabel = valueLabel
            State.CurrentSliderCallback = callback
            State.CurrentSliderValue = nil
        end
    end))
    return holder
end

local function AddInput(page, title, placeholder, callback)
    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 67),
        BackgroundTransparency = 1,
    }, page)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)

    local box = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 39),
        Position = UDim2.fromOffset(0, 26),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.93,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = TEXT_SECONDARY,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)
    Corner(box, 11)
    Stroke(box, 0.88)
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, box)

    Janitor:Add(box.Focused:Connect(function()
        Animate(box, { BackgroundColor3 = BLUE, BackgroundTransparency = 0.88 }, 0.15)
    end))
    Janitor:Add(box.FocusLost:Connect(function()
        Animate(box, { BackgroundColor3 = WHITE, BackgroundTransparency = 0.93 }, 0.15)
        if callback then
            local ok, err = pcall(callback, box.Text)
            if not ok then warn("[ModernLiquidGlass] Input callback error: " .. tostring(err)) end
        end
    end))

    return box
end

local function AddCard(page, title, description)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
    }, page)
    Corner(card, 14)
    Stroke(card, 0.9)

    local accent = Create("Frame", {
        Size = UDim2.fromOffset(3, 38),
        Position = UDim2.fromOffset(9, 15),
        BackgroundColor3 = BLUE,
        BorderSizePixel = 0,
    }, card)
    Corner(accent, 5)

    Create("TextLabel", {
        Size = UDim2.new(1, -35, 0, 21),
        Position = UDim2.fromOffset(22, 11),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -35, 0, 25),
        Position = UDim2.fromOffset(22, 33),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = TEXT_SECONDARY,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    return card
end

local function AddDropdown(page, title, options, default, callback)
    local selected = default or options[1]
    local open = false

    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
    }, page)

    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)

    local button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 39),
        Position = UDim2.fromOffset(0, 26),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.93,
        BorderSizePixel = 0,
        Text = selected,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        ZIndex = 60,
    }, holder)
    Corner(button, 11)
    Stroke(button, 0.88)
    Create("UIPadding", { PaddingLeft = UDim.new(0, 12) }, button)

    local menu = Create("Frame", {
        Size = UDim2.new(1, 0, 0, #options * 34 + 8),
        Position = UDim2.fromOffset(0, 70),
        BackgroundColor3 = GLASS_LIGHT,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 80,
    }, holder)
    Corner(menu, 12)
    Stroke(menu, 0.85)
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, menu)
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
    }, menu)

    local function setOpen(nextOpen)
        open = nextOpen
        menu.Visible = open
        holder.Size = open and UDim2.new(1, 0, 0, 78 + #options * 34) or UDim2.new(1, 0, 0, 70)
    end

    for _, option in ipairs(options) do
        local item = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = WHITE,
            BackgroundTransparency = option == selected and 0.82 or 1,
            BorderSizePixel = 0,
            Text = option,
            TextColor3 = WHITE,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            ZIndex = 81,
        }, menu)
        Corner(item, 8)
        Janitor:Add(item.Activated:Connect(function()
            selected = option
            button.Text = selected
            if callback then
                local ok, err = pcall(callback, selected)
                if not ok then warn("[ModernLiquidGlass] Dropdown callback error: " .. tostring(err)) end
            end
            for _, child in ipairs(menu:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundTransparency = child.Text == selected and 0.82 or 1
                end
            end
            setOpen(false)
        end))
    end

    Janitor:Add(button.Activated:Connect(function()
        setOpen(not open)
    end))
    return holder
end

local function AddSelector(page, title, options, default, callback)
    local selected = default or options[1]
    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1,
    }, page)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)

    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 39),
        Position = UDim2.fromOffset(0, 26),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
    }, holder)
    Corner(row, 12)
    Stroke(row, 0.9)
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, row)
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
    }, row)

    local chips = {}
    local function paint()
        for name, chip in pairs(chips) do
            if name == selected then
                chip.BackgroundColor3 = BLUE
                chip.BackgroundTransparency = 0.15
                chip.TextColor3 = WHITE
            else
                chip.BackgroundColor3 = WHITE
                chip.BackgroundTransparency = 1
                chip.TextColor3 = TEXT_SECONDARY
            end
        end
    end

    for _, option in ipairs(options) do
        local chip = Create("TextButton", {
            Size = UDim2.new(1 / math.max(#options, 1), -4, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = option,
            TextColor3 = TEXT_SECONDARY,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
        }, row)
        Corner(chip, 8)
        chips[option] = chip
        Janitor:Add(chip.Activated:Connect(function()
            selected = option
            paint()
            if callback then
                local ok, err = pcall(callback, selected)
                if not ok then warn("[ModernLiquidGlass] Selector callback error: " .. tostring(err)) end
            end
        end))
    end
    paint()
    return holder
end

local function AddList(page, items, callback)
    local rows = {}
    for _, item in ipairs(items) do
        local row = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = WHITE,
            BackgroundTransparency = 0.94,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        }, page)
        Corner(row, 12)
        Stroke(row, 0.9)
        table.insert(rows, row)
        if callback then
            Janitor:Add(row.Activated:Connect(function()
                local ok, err = pcall(callback, item)
                if not ok then warn("[ModernLiquidGlass] List callback error: " .. tostring(err)) end
            end))
        end
        Create("TextLabel", {
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1,
            Text = item.title,
            TextColor3 = WHITE,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
        Create("TextLabel", {
            Size = UDim2.fromOffset(70, 42),
            Position = UDim2.new(1, -78, 0, 0),
            BackgroundTransparency = 1,
            Text = item.meta,
            TextColor3 = TEXT_SECONDARY,
            TextSize = 9,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, row)
    end
    return rows
end

--==================================================
-- POPULATING WORKSPACE PAGES
--==================================================
SectionTitle(Pages.Dashboard, "Dashboard", "Modern Premium Engine")
AddCard(Pages.Dashboard, "Engine Status Active", "Systems operating at peak fluid framework.")
AddButton(Pages.Dashboard, "Primary System Action")
AddToggle(Pages.Dashboard, "Enable Canvas Overlays", true, function(on)
    IsSnowing = on
    if not on then
        ClearAllSnow()
        IsSnowing = false
    end
end)
AddSlider(Pages.Dashboard, "System Responsiveness", 95)

SectionTitle(Pages.Buttons, "Buttons", "Primary and secondary actions")
AddButton(Pages.Buttons, "Ghost Action")
AddButton(Pages.Buttons, "Confirm Change")
AddButton(Pages.Buttons, "Secondary Confirm")

SectionTitle(Pages.Toggles, "Toggles", "Boolean switches")
AddToggle(Pages.Toggles, "Canvas Overlays", true)
AddToggle(Pages.Toggles, "Motion Blur Trail", false)
AddToggle(Pages.Toggles, "Live Telemetry", true)

SectionTitle(Pages.Sliders, "Sliders", "Pointer captured fill")
AddSlider(Pages.Sliders, "Master Volume", 40)
AddSlider(Pages.Sliders, "Backdrop Blur", 22)
AddSlider(Pages.Sliders, "Bloom Amount", 32)

SectionTitle(Pages.Inputs, "Inputs", "Focus uses ice accent")
AddInput(Pages.Inputs, "Display Name", "Operator")
AddInput(Pages.Inputs, "Toggle Key", "G")
AddInput(Pages.Inputs, "Session Note", "Write a short note")

SectionTitle(Pages.Dropdowns, "Dropdowns", "Expand in-flow so they survive clipping")
AddDropdown(Pages.Dropdowns, "Quality Preset", { "High", "Medium", "Low" }, "High")
AddDropdown(Pages.Dropdowns, "Particle Renderer", { "Canvas", "DOM", "Off" }, "Canvas")
AddDropdown(Pages.Dropdowns, "Window Anchor", { "Center", "Top Left", "Remember Last" }, "Center")

SectionTitle(Pages.Selectors, "Selectors", "Segmented chips")
AddSelector(Pages.Selectors, "Accent", { "Blue", "Ice", "Steel" }, "Blue")
AddSelector(Pages.Selectors, "Density", { "Compact", "Comfort", "Airy" }, "Comfort")

SectionTitle(Pages.Lists, "Lists", "Selectable module rows")
AddList(Pages.Lists, {
    { title = "Snowfall system", meta = "Fixed" },
    { title = "Empty tab factory", meta = "Filled" },
    { title = "Font.Builder crash", meta = "Patched" },
    { title = "Yielding close tween", meta = "Async" },
    { title = "Dead unload button", meta = "Wired" },
})

SectionTitle(Pages.Cards, "Cards", "Accent bar, frost fill, hairline edge")
AddCard(Pages.Cards, "Liquid interpolation", "Drag uses frame-safe lerp so 144hz and 30hz feel the same.")
AddCard(Pages.Cards, "Constraint-safe close", "UIScale closes the window instead of fighting MinSize.")
AddCard(Pages.Cards, "Janitor actually runs", "Connections, blur, and the ScreenGui die together on unload.")

SectionTitle(Pages.Visuals, "Visuals", "Atmosphere controls")
AddToggle(Pages.Visuals, "Snowfall", true, function(on)
    IsSnowing = on
    if not on then
        ClearAllSnow()
    else
        IsSnowing = true
    end
end)
AddSlider(Pages.Visuals, "Snowflake Density", 55)
AddSlider(Pages.Visuals, "Glass Tint", 82)

SectionTitle(Pages.Animations, "Animations", "Interruptible tweens")
AddButton(Pages.Animations, "Trigger Pulse")
AddCard(Pages.Animations, "Press scale", "Buttons use UIScale 0.96 so the list layout does not jump.")

SectionTitle(Pages.Settings, "Settings", "Interface Configuration")
AddToggle(Pages.Settings, "Dynamic Keybind Active (G)", true, function(on)
    if on then
        ContextActionService:BindAction(TOGGLE_ACTION, function(_, inputState)
            if inputState ~= Enum.UserInputState.Begin then
                return
            end
            if UserInputService:GetFocusedTextBox() then
                return
            end
            if Window.Visible then
                CloseUI()
            else
                OpenUI()
            end
        end, false, (options.ToggleKey or Enum.KeyCode.G))
    else
        ContextActionService:UnbindAction(TOGGLE_ACTION)
    end
end)
AddButton(Pages.Settings, "Safe-Unload Framework", function()
    Unload()
end)

--==================================================
-- RESIZE IMPLEMENTATION
--==================================================
local Resize = Create("TextButton", {
    Name = "Resize",
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -34, 1, -34),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.fromRGB(140, 170, 200),
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 300,
}, Window)

Janitor:Add(Resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        State.Resizing = true
        State.ResizeStart = UserInputService:GetMouseLocation()
        State.StartWindowSize = Window.AbsoluteSize
    end
end))

--==================================================
-- TAB SELECTION NAVIGATION
--==================================================
local CurrentTab = nil

local function SelectTab(name)
    if CurrentTab == name then
        return
    end
    CurrentTab = name

    for tabName, button in pairs(TabButtons) do
        if tabName == name then
            Animate(button, { BackgroundColor3 = BLUE, BackgroundTransparency = 0.40 }, 0.18)
            button.TextColor3 = WHITE
        else
            Animate(button, { BackgroundColor3 = WHITE, BackgroundTransparency = 0.97 }, 0.18)
            button.TextColor3 = Color3.fromRGB(205, 216, 232)
        end
    end

    for pageName, page in pairs(Pages) do
        if pageName == name then
            page.Visible = true
            page.Position = UDim2.new(0, 12, 0, 0)
            Animate(page, { Position = UDim2.new(0, 0, 0, 0) }, 0.22)
        else
            page.Visible = false
        end
    end
end

for name, button in pairs(TabButtons) do
    Janitor:Add(button.Activated:Connect(function()
        SelectTab(name)
    end))
    Janitor:Add(button.MouseEnter:Connect(function()
        if CurrentTab ~= name then
            Animate(button, { BackgroundTransparency = 0.92 }, 0.12)
        end
    end))
    Janitor:Add(button.MouseLeave:Connect(function()
        if CurrentTab ~= name then
            Animate(button, { BackgroundTransparency = 0.97 }, 0.12)
        end
    end))
end

SelectTab("Dashboard")

--==================================================
-- MOBILE / PC RESPONSIVE LOGIC
--==================================================
local function Responsive()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local viewport = camera.ViewportSize
    if viewport.X <= 700 then
        Sidebar.Visible = false
        Content.Position = UDim2.fromOffset(9, 8)
        Content.Size = UDim2.new(1, -18, 1, -16)
        if not State.Dragging and not State.Resizing then
            Window.Size = UDim2.fromOffset(
                math.clamp(viewport.X - 18, MIN_WIDTH, 500),
                math.clamp(viewport.Y - 25, MIN_HEIGHT, 650)
            )
        end
    else
        Sidebar.Visible = true
        Content.Position = UDim2.fromOffset(169, 9)
        Content.Size = UDim2.new(1, -176, 1, -18)
    end
end

if workspace.CurrentCamera then
    Janitor:Add(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Responsive))
end
Responsive()

--==================================================
-- OPEN BUTTON INTERFACE
--==================================================
local OpenButton = Create("TextButton", {
    Name = "OpenButton",
    Size = UDim2.fromOffset(54, 54),
    Position = UDim2.new(0, 15, 0.5, -27),
    BackgroundColor3 = GLASS,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Text = "LG",
    TextColor3 = WHITE,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    Visible = false,
    AutoButtonColor = false,
    ZIndex = 500,
}, Screen)
Corner(OpenButton, 17)
Stroke(OpenButton, 0.72)

Janitor:Add(OpenButton.MouseEnter:Connect(function()
    Animate(OpenButton, { BackgroundColor3 = BLUE, BackgroundTransparency = 0.15 }, 0.15)
end))
Janitor:Add(OpenButton.MouseLeave:Connect(function()
    Animate(OpenButton, { BackgroundColor3 = GLASS, BackgroundTransparency = 0.15 }, 0.15)
end))

--==================================================
-- OPEN / CLOSE TRANSITIONS & KEYBIND
-- Close uses UIScale so UISizeConstraint does not fight a Size(0,0) tween.
--==================================================
local Transitioning = false

function CloseUI()
    if Transitioning or not Window.Visible then
        return
    end
    Transitioning = true
    State.Dragging = false
    State.Resizing = false
    State.Sliding = false

    Animate(Blur, { Size = 0 }, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    Animate(Window, { BackgroundTransparency = 1 }, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local tween = Animate(WindowScale, { Scale = 0.92 }, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    Janitor:Add(tween.Completed:Connect(function(playback)
        if playback ~= Enum.PlaybackState.Completed then
            return
        end
        Window.Visible = false
        WindowScale.Scale = 1
        Window.BackgroundTransparency = 0.18
        Blur.Enabled = false
        ClearAllSnow()
        OpenButton.Visible = true
        OpenButton.Size = UDim2.fromOffset(0, 0)
        Animate(OpenButton, { Size = UDim2.fromOffset(54, 54) }, 0.25, Enum.EasingStyle.Back)
        Transitioning = false
    end))
end

function OpenUI()
    if Transitioning or Window.Visible then
        return
    end
    Transitioning = true
    OpenButton.Visible = false
    Window.Visible = true
    WindowScale.Scale = 0.92
    Window.BackgroundTransparency = 1
    Blur.Enabled = true
    Blur.Size = 0
    IsSnowing = true

    Animate(Blur, { Size = 14 }, 0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    Animate(Window, { BackgroundTransparency = 0.18 }, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = Animate(WindowScale, { Scale = 1 }, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    Janitor:Add(tween.Completed:Connect(function(playback)
        if playback ~= Enum.PlaybackState.Completed then
            return
        end
        Responsive()
        Transitioning = false
    end))
end

function Unload()
    ContextActionService:UnbindAction(TOGGLE_ACTION)
    Janitor:Clean()
    ClearAllSnow()
    if Screen then
        Screen:Destroy()
    end
    if Blur then
        Blur:Destroy()
    end
end

Janitor:Add(Close.Activated:Connect(CloseUI))
Janitor:Add(OpenButton.Activated:Connect(OpenUI))

local function OnToggle(_, inputState)
    if inputState ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end
    if UserInputService:GetFocusedTextBox() then
        return Enum.ContextActionResult.Pass
    end
    if Window.Visible then
        CloseUI()
    else
        OpenUI()
    end
    return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction(TOGGLE_ACTION, OnToggle, false, (options.ToggleKey or Enum.KeyCode.G))
Janitor:Add({
    Disconnect = function()
        ContextActionService:UnbindAction(TOGGLE_ACTION)
    end,
})

-- Execution Startup Init
Window.Visible = true
OpenButton.Visible = false
Blur.Enabled = true
Blur.Size = 14
IsSnowing = true

--==================================================
-- PUBLIC LIBRARY API (uses the original Liquid Glass design)
--==================================================
local controller = {
    Name = GUI_NAME,
    Screen = Screen,
    Window = Window,
    Blur = Blur,
    OpenButton = OpenButton,
    Pages = Pages,
    Tabs = {},
}

local function makeTabApi(name, page)
    local tab = { Name = name, Page = page, Window = controller }
    function tab:AddSection(title, subtitle) return SectionTitle(self.Page, title, subtitle) end
    function tab:AddButton(text, callback) return AddButton(self.Page, text, callback) end
    function tab:AddToggle(text, default, callback) return AddToggle(self.Page, text, default, callback) end
    function tab:AddSlider(text, default, callback) return AddSlider(self.Page, text, default, callback) end
    function tab:AddInput(title, placeholder, callback) return AddInput(self.Page, title, placeholder, callback) end
    function tab:AddCard(title, description) return AddCard(self.Page, title, description) end
    function tab:AddDropdown(title, options, default, callback) return AddDropdown(self.Page, title, options, default, callback) end
    function tab:AddSelector(title, options, default, callback) return AddSelector(self.Page, title, options, default, callback) end
    function tab:AddList(items, callback) return AddList(self.Page, items, callback) end
    return tab
end

for name, page in pairs(Pages) do
    controller.Tabs[name] = makeTabApi(name, page)
end

function controller:GetTab(name)
    return self.Tabs[name]
end

function controller:GetPage(name)
    return Pages[name]
end

function controller:CreateTab(name)
    name = tostring(name)
    if Pages[name] then return self.Tabs[name] end
    local page = CreatePage(name)
    local order = #TabNames + 1
    for _ in pairs(self._extraTabs or {}) do order += 1 end
    self._extraTabs = self._extraTabs or {}
    self._extraTabs[name] = true
    local button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -4, 0, 30),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.97,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = Color3.fromRGB(205, 216, 232),
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        ZIndex = 50,
        LayoutOrder = order,
    }, Sidebar)
    Corner(button, 10)
    Stroke(button, 0.95)
    Create("UIPadding", { PaddingLeft = UDim.new(0, 12) }, button)
    TabButtons[name] = button
    Janitor:Add(button.Activated:Connect(function() SelectTab(name) end))
    Janitor:Add(button.MouseEnter:Connect(function()
        if CurrentTab ~= name then Animate(button, { BackgroundTransparency = 0.92 }, 0.12) end
    end))
    Janitor:Add(button.MouseLeave:Connect(function()
        if CurrentTab ~= name then Animate(button, { BackgroundTransparency = 0.97 }, 0.12) end
    end))
    local tab = makeTabApi(name, page)
    self.Tabs[name] = tab
    SelectTab(name)
    return tab
end

function controller:SelectTab(name)
    if not Pages[name] then return false end
    SelectTab(name)
    return true
end

function controller:SetVisible(visible)
    if visible then OpenUI() else CloseUI() end
end

function controller:Toggle()
    if Window.Visible then CloseUI() else OpenUI() end
end

function controller:Open() OpenUI() end
function controller:Close() CloseUI() end
function controller:Unload() Unload() end
function controller:Destroy() Unload() end

function controller:SetSnowing(enabled)
    IsSnowing = enabled == true
    if not IsSnowing then ClearAllSnow() end
end

return controller

end

function LiquidGlassUI:CreateWindow(options)
    return LiquidGlassUI.new(options)
end

return LiquidGlassUI
