local KyzenLib = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = game:GetService("Players").LocalPlayer

-- UI Base
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KyzenLibUI"
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("ImageLabel", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 340)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 1
MainFrame.Image = "rbxassetid://105468345186897"
MainFrame.ScaleType = Enum.ScaleType.Crop
MainFrame.ImageTransparency = 0.35
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 105, 180)
Instance.new("UIStroke", MainFrame).Thickness = 2

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -70)
Sidebar.Position = UDim2.new(0, 20, 0, 60)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -180, 1, -70)
PageContainer.Position = UDim2.new(0, 175, 0, 60)
PageContainer.BackgroundTransparency = 1

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 30, 0.5, -25)
ToggleBtn.Image = "rbxassetid://105468345186897"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255, 105, 180)

-- API của Library
function KyzenLib:CreateTab(name)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(200, 200, 200) end end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return Page
end

function KyzenLib:CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- Mở đóng UI
local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)

getgenv().KyzenLib = KyzenLib
