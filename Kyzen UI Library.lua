--[[
    LiquidGlass UI Library - Apple iOS 26/27 Theme
    Designed for Roblox Luau & Delta X Executor (Android / PC)
    Developer: kyzen-script
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Global Theme Engine
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        BgTransparency = 0.35,
        Stroke = Color3.fromRGB(255, 255, 255),
        StrokeTransparency = 0.2,
        HeaderBg = Color3.fromRGB(255, 255, 255),
        HeaderTransparency = 0.9,
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(160, 160, 175),
        Accent = Color3.fromRGB(52, 199, 89), -- iOS Green
        ComponentBg = Color3.fromRGB(255, 255, 255),
        CompTransparency = 0.88,
        Gradient1 = Color3.fromRGB(40, 40, 55),
        Gradient2 = Color3.fromRGB(15, 15, 20)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        BgTransparency = 0.25,
        Stroke = Color3.fromRGB(255, 255, 255),
        StrokeTransparency = 0.1,
        HeaderBg = Color3.fromRGB(255, 255, 255),
        HeaderTransparency = 0.7,
        Text = Color3.fromRGB(30, 30, 35),
        SubText = Color3.fromRGB(100, 100, 115),
        Accent = Color3.fromRGB(0, 122, 255), -- iOS Blue
        ComponentBg = Color3.fromRGB(255, 255, 255),
        CompTransparency = 0.5,
        Gradient1 = Color3.fromRGB(255, 255, 255),
        Gradient2 = Color3.fromRGB(210, 220, 240)
    }
}

local Library = {
    Version = "1.0.0",
    ActiveTheme = Themes.Dark,
    Instances = {}
}

-- Utility Functions
local function CreateTween(inst, info, props)
    local tween = TweenService:Create(inst, info, props)
    tween:Play()
    return tween
end

local function MakeDraggable(gui, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or gui
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ScreenGui Parent Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiquidGlass_Framework"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Notification System Container
local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Size = UDim2.new(0, 280, 1, -40)
NotifHolder.Position = UDim2.new(1, -290, 0, 20)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Parent = NotifHolder

function Library:Notify(cfg)
    cfg = cfg or {}
    local TitleText = cfg.Title or "Notification"
    local DescText = cfg.Description or ""
    local Duration = cfg.Duration or 3
    local Type = cfg.Type or "Info" -- Success, Error, Warning, Info

    local TypeColors = {
        Success = Color3.fromRGB(52, 199, 89),
        Error = Color3.fromRGB(255, 59, 48),
        Warning = Color3.fromRGB(255, 149, 0),
        Info = Color3.fromRGB(0, 122, 255)
    }

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.Position = UDim2.new(1, 300, 0, 0)
    NotifFrame.BackgroundColor3 = Library.ActiveTheme.Background
    NotifFrame.BackgroundTransparency = Library.ActiveTheme.BgTransparency
    NotifFrame.ClipsDescendants = true
    NotifFrame.Parent = NotifHolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = NotifFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.2
    Stroke.Color = TypeColors[Type] or Library.ActiveTheme.Stroke
    Stroke.Transparency = 0.3
    Stroke.Parent = NotifFrame

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, -16)
    AccentBar.Position = UDim2.new(0, 8, 0.5, -22)
    AccentBar.BackgroundColor3 = TypeColors[Type] or Library.ActiveTheme.Accent
    AccentBar.Parent = NotifFrame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = AccentBar

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -25, 0, 20)
    TitleLbl.Position = UDim2.new(0, 20, 0, 10)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.Text = TitleText
    TitleLbl.TextColor3 = Library.ActiveTheme.Text
    TitleLbl.TextSize = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Parent = NotifFrame

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size = UDim2.new(1, -25, 0, 22)
    DescLbl.Position = UDim2.new(0, 20, 0, 28)
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.Text = DescText
    DescLbl.TextColor3 = Library.ActiveTheme.SubText
    DescLbl.TextSize = 11
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.BackgroundTransparency = 1
    DescLbl.Parent = NotifFrame

    -- Animation Slide In
    CreateTween(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    
    task.delay(Duration, function()
        local tw = CreateTween(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.2, 0, 0, 0)})
        tw.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
end

-- Main Window Creator
function Library:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "Liquid Glass UI"
    local WindowSize = config.Size or UDim2.fromOffset(500, 340)
    local ThemeMode = config.Theme or "Dark"
    
    Library.ActiveTheme = Themes[ThemeMode] or Themes.Dark

    -- Floating Logo Setup
    local FloatLogo = Instance.new("TextButton")
    FloatLogo.Name = "LiquidGlass_Logo"
    FloatLogo.Size = UDim2.new(0, 45, 0, 45)
    FloatLogo.Position = UDim2.new(0, 20, 0.2, 0)
    FloatLogo.BackgroundColor3 = Library.ActiveTheme.Background
    FloatLogo.BackgroundTransparency = 0.3
    FloatLogo.Text = ""
    FloatLogo.TextColor3 = Library.ActiveTheme.Text
    FloatLogo.TextSize = 22
    FloatLogo.Font = Enum.Font.GothamBold
    FloatLogo.Parent = ScreenGui

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = FloatLogo

    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Thickness = 1.5
    LogoStroke.Color = Library.ActiveTheme.Stroke
    LogoStroke.Transparency = 0.3
    LogoStroke.Parent = FloatLogo

    MakeDraggable(FloatLogo)

    -- Main Container Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = WindowSize
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    MainFrame.BackgroundColor3 = Library.ActiveTheme.Background
    MainFrame.BackgroundTransparency = Library.ActiveTheme.BgTransparency
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 18)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.Color = Library.ActiveTheme.Stroke
    MainStroke.Transparency = Library.ActiveTheme.StrokeTransparency
    MainStroke.Parent = MainFrame

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Library.ActiveTheme.Gradient1),
        ColorSequenceKeypoint.new(1, Library.ActiveTheme.Gradient2)
    }
    MainGradient.Rotation = 45
    MainGradient.Parent = MainFrame

    -- Header Bar
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    MakeDraggable(MainFrame, Header)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = WindowTitle
    TitleLabel.TextColor3 = Library.ActiveTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    -- Control Buttons (Close / Toggle)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 11
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    FloatLogo.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        CreateTween(FloatLogo, TweenInfo.new(0.1), {Size = UDim2.new(0, 38, 0, 38)})
        task.wait(0.1)
        CreateTween(FloatLogo, TweenInfo.new(0.1), {Size = UDim2.new(0, 45, 0, 45)})
    end)

    -- Tab Bar Container (Left Side Layout)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, -42)
    Sidebar.Position = UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 6)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideLayout.Parent = Sidebar

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -138, 1, -50)
    ContainerHolder.Position = UDim2.new(0, 132, 0, 44)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = MainFrame

    local WindowObj = {
        CurrentTab = nil,
        Tabs = {}
    }

    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 32)
        TabBtn.BackgroundColor3 = Library.ActiveTheme.ComponentBg
        TabBtn.BackgroundTransparency = 0.9
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Library.ActiveTheme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabBtn

        local ContentContainer = Instance.new("ScrollingFrame")
        ContentContainer.Size = UDim2.new(1, 0, 1, 0)
        ContentContainer.BackgroundTransparency = 1
        ContentContainer.ScrollBarThickness = 2
        ContentContainer.ScrollBarImageColor3 = Library.ActiveTheme.Stroke
        ContentContainer.Visible = false
        ContentContainer.Parent = ContainerHolder

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = ContentContainer

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        local TabObj = {}

        function TabObj:Select()
            for _, t in pairs(WindowObj.Tabs) do
                CreateTween(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = Library.ActiveTheme.SubText})
                t.Content.Visible = false
            end
            CreateTween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4, TextColor3 = Library.ActiveTheme.Text})
            ContentContainer.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(function()
            TabObj:Select()
        end)

        if #WindowObj.Tabs == 0 then
            TabObj:Select()
        end

        -- Component Generators
        function TabObj:CreateButton(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Button"
            local callback = cfg.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -6, 0, 36)
            Btn.BackgroundColor3 = Library.ActiveTheme.ComponentBg
            Btn.BackgroundTransparency = Library.ActiveTheme.CompTransparency
            Btn.Text = name
            Btn.TextColor3 = Library.ActiveTheme.Text
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 12
            Btn.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 10)
            Corner.Parent = Btn

            local Stroke = Instance.new("UIStroke")
            Stroke.Thickness = 1
            Stroke.Color = Library.ActiveTheme.Stroke
            Stroke.Transparency = 0.5
            Stroke.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                CreateTween(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 34)})
                task.wait(0.1)
                CreateTween(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -6, 0, 36)})
                pcall(callback)
            end)
        end

        function TabObj:CreateToggle(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Toggle"
            local default = cfg.Default or false
            local callback = cfg.Callback or function() end

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, -6, 0, 38)
            ToggleBtn.BackgroundColor3 = Library.ActiveTheme.ComponentBg
            ToggleBtn.BackgroundTransparency = Library.ActiveTheme.CompTransparency
            ToggleBtn.Text = ""
            ToggleBtn.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 10)
            Corner.Parent = ToggleBtn

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.7, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextColor3 = Library.ActiveTheme.Text
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.BackgroundTransparency = 1
            Lbl.Parent = ToggleBtn

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 40, 0, 22)
            Indicator.Position = UDim2.new(1, -48, 0.5, -11)
            Indicator.BackgroundColor3 = default and Library.ActiveTheme.Accent or Color3.fromRGB(150, 150, 160)
            Indicator.Parent = ToggleBtn

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 18, 0, 18)
            Dot.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Indicator

            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = Dot

            local toggled = default
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                local targetPos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                local targetColor = toggled and Library.ActiveTheme.Accent or Color3.fromRGB(150, 150, 160)
                
                CreateTween(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos})
                CreateTween(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
                pcall(callback, toggled)
            end)
        end

        function TabObj:CreateSlider(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Slider"
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local default = cfg.Default or min
            local callback = cfg.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -6, 0, 46)
            SliderFrame.BackgroundColor3 = Library.ActiveTheme.ComponentBg
            SliderFrame.BackgroundTransparency = Library.ActiveTheme.CompTransparency
            SliderFrame.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 10)
            Corner.Parent = SliderFrame

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.6, 0, 0, 20)
            Lbl.Position = UDim2.new(0, 12, 0, 4)
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextColor3 = Library.ActiveTheme.Text
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.BackgroundTransparency = 1
            Lbl.Parent = SliderFrame

            local ValLbl = Instance.new("TextLabel")
            ValLbl.Size = UDim2.new(0.3, 0, 0, 20)
            ValLbl.Position = UDim2.new(0.7, -12, 0, 4)
            ValLbl.Text = tostring(default)
            ValLbl.Font = Enum.Font.GothamBold
            ValLbl.TextColor3 = Library.ActiveTheme.SubText
            ValLbl.TextSize = 12
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            ValLbl.BackgroundTransparency = 1
            ValLbl.Parent = SliderFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -24, 0, 6)
            Bar.Position = UDim2.new(0, 12, 0, 30)
            Bar.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
            Bar.Parent = SliderFrame

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Library.ActiveTheme.Accent
            Fill.Parent = Bar

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local draggingSlider = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                ValLbl.Text = tostring(val)
                pcall(callback, val)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
        end

        table.insert(WindowObj.Tabs, {Button = TabBtn, Content = ContentContainer})
        return TabObj
    end

    return WindowObj
end

return Library
