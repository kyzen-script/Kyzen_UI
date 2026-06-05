-- ╔══════════════════════════════╗
-- ║     Kyzen Hub v4  - KyzenUI  ║
-- ║      đã xong ║
-- ╚══════════════════════════════╝

local TweenService  = game:GetService("TweenService")
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local HttpService   = game:GetService("HttpService")
local player        = Players.LocalPlayer

-- ══════════════════════════════
--  THEME SYSTEM
-- ══════════════════════════════
local KyzenUI = {}
KyzenUI.Theme = {
	Primary     = Color3.fromRGB(255, 40, 60),
	Background  = Color3.fromRGB(10, 10, 10),
	Surface     = Color3.fromRGB(15, 15, 15),
	Surface2    = Color3.fromRGB(20, 20, 20),
	Text        = Color3.new(1, 1, 1),
	SubText     = Color3.fromRGB(160, 160, 160),
	Island      = Color3.fromRGB(12, 12, 12),
	Success     = Color3.fromRGB(40, 200, 100),
	Warning     = Color3.fromRGB(255, 180, 0),
	Error       = Color3.fromRGB(255, 60, 60),
}

function KyzenUI:SetTheme(customTheme)
	for k, v in pairs(customTheme) do
		self.Theme[k] = v
	end
end

-- ══════════════════════════════
--  SAVE CONFIG SYSTEM
-- ══════════════════════════════
local ConfigData = {}

local function saveConfig()
	local ok, encoded = pcall(HttpService.JSONEncode, HttpService, ConfigData)
	if ok then
		if writefile then
			pcall(writefile, "KyzenHub_Config.json", encoded)
		end
	end
end

local function loadConfig()
	if readfile then
		local ok, raw = pcall(readfile, "KyzenHub_Config.json")
		if ok and raw and raw ~= "" then
			local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
			if ok2 then
				ConfigData = decoded
			end
		end
	end
end

loadConfig()

-- ══════════════════════════════
--  SCREEN GUI
-- ══════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name        = "KyzenHubV2"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = game.CoreGui end)
if not gui.Parent then gui.Parent = player.PlayerGui end

-- ══════════════════════════════
--  DYNAMIC ISLAND  (kept intact)
-- ══════════════════════════════
local island = Instance.new("TextButton")
island.Parent           = gui
island.AnchorPoint      = Vector2.new(.5, 0)
island.Position         = UDim2.new(.5, 0, 0, -50)
island.Size             = UDim2.new(0, 180, 0, 38)
island.Text             = "⚡ Kyzen Hub"
island.TextColor3       = KyzenUI.Theme.Text
island.BackgroundColor3 = KyzenUI.Theme.Island
island.AutoButtonColor  = false
island.Font             = Enum.Font.GothamBold
island.TextSize         = 14
island.ZIndex           = 10

Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)

local islandStroke = Instance.new("UIStroke", island)
islandStroke.Color     = KyzenUI.Theme.Primary
islandStroke.Thickness = 1.5

-- Island pulse animation
local function pulseIsland()
	local ti = TweenInfo.new(.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	TweenService:Create(islandStroke, ti, { Transparency = 0.6 }):Play()
end
pulseIsland()

-- ══════════════════════════════
--  NOTIFY SYSTEM
-- ══════════════════════════════
local notifHolder = Instance.new("Frame", gui)
notifHolder.Size                = UDim2.new(0, 260, 1, 0)
notifHolder.Position            = UDim2.new(1, -270, 0, 60)
notifHolder.BackgroundTransparency = 1
notifHolder.ZIndex              = 20

local notifLayout = Instance.new("UIListLayout", notifHolder)
notifLayout.SortOrder           = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
notifLayout.Padding             = UDim.new(0, 8)

local notifCount = 0

function KyzenUI:Notify(opts)
	opts = opts or {}
	local title    = opts.Title   or "Kyzen Hub"
	local message  = opts.Message or ""
	local duration = opts.Duration or 3
	local ntype    = opts.Type    or "Info" -- Info | Success | Warning | Error
	notifCount += 1

	local typeColor = {
		Info    = KyzenUI.Theme.Primary,
		Success = KyzenUI.Theme.Success,
		Warning = KyzenUI.Theme.Warning,
		Error   = KyzenUI.Theme.Error,
	}
	local typeIcon = { Info="ℹ️", Success="✅", Warning="⚠️", Error="❌" }

	local nf = Instance.new("Frame", notifHolder)
	nf.Size             = UDim2.new(1, 0, 0, 72)
	nf.BackgroundColor3 = KyzenUI.Theme.Surface
	nf.LayoutOrder      = notifCount
	nf.ClipsDescendants = true

	Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 12)

	local bar = Instance.new("Frame", nf)
	bar.Size             = UDim2.new(0, 4, 1, 0)
	bar.BackgroundColor3 = typeColor[ntype] or KyzenUI.Theme.Primary
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)

	local icon = Instance.new("TextLabel", nf)
	icon.Size               = UDim2.new(0, 30, 0, 30)
	icon.Position           = UDim2.new(0, 14, 0, 10)
	icon.Text               = typeIcon[ntype] or "ℹ️"
	icon.TextSize           = 18
	icon.BackgroundTransparency = 1

	local tl = Instance.new("TextLabel", nf)
	tl.Size                 = UDim2.new(1, -55, 0, 22)
	tl.Position             = UDim2.new(0, 48, 0, 8)
	tl.Text                 = title
	tl.TextColor3           = KyzenUI.Theme.Text
	tl.Font                 = Enum.Font.GothamBold
	tl.TextSize             = 13
	tl.TextXAlignment       = Enum.TextXAlignment.Left
	tl.BackgroundTransparency = 1

	local ml = Instance.new("TextLabel", nf)
	ml.Size                 = UDim2.new(1, -55, 0, 30)
	ml.Position             = UDim2.new(0, 48, 0, 30)
	ml.Text                 = message
	ml.TextColor3           = KyzenUI.Theme.SubText
	ml.Font                 = Enum.Font.Gotham
	ml.TextSize             = 11
	ml.TextXAlignment       = Enum.TextXAlignment.Left
	ml.TextWrapped          = true
	ml.BackgroundTransparency = 1

	-- Slide in
	nf.Position = UDim2.new(1, 10, 0, 0)
	TweenService:Create(nf, TweenInfo.new(.3, Enum.EasingStyle.Back), { Position = UDim2.new(0, 0, 0, 0) }):Play()

	-- Progress bar
	local prog = Instance.new("Frame", nf)
	prog.Size             = UDim2.new(1, 0, 0, 2)
	prog.Position         = UDim2.new(0, 0, 1, -2)
	prog.BackgroundColor3 = typeColor[ntype] or KyzenUI.Theme.Primary
	TweenService:Create(prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) }):Play()

	task.delay(duration, function()
		TweenService:Create(nf, TweenInfo.new(.25, Enum.EasingStyle.Quad), { Position = UDim2.new(1, 20, 0, 0) }):Play()
		task.wait(.3)
		nf:Destroy()
	end)
end

-- ══════════════════════════════
--  CREATE WINDOW
-- ══════════════════════════════
function KyzenUI:CreateWindow(opts)
	opts = opts or {}
	local title = opts.Title or "Kyzen Hub"

	local win = {}
	local tabList  = {}
	local pageList = {}
	local open     = false

	-- Main Frame
	local main = Instance.new("Frame", gui)
	main.AnchorPoint      = Vector2.new(.5, .5)
	main.Position         = UDim2.new(.5, 0, .55, 0)
	main.Size             = UDim2.new(.92, 0, .74, 0)
	main.BackgroundColor3 = KyzenUI.Theme.Background
	main.Visible          = false
	main.ClipsDescendants = true

	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

	local mainStroke = Instance.new("UIStroke", main)
	mainStroke.Color     = KyzenUI.Theme.Primary
	mainStroke.Thickness = 2

	-- Top bar
	local top = Instance.new("Frame", main)
	top.Size                = UDim2.new(1, 0, 0, 52)
	top.BackgroundColor3    = KyzenUI.Theme.Surface
	Instance.new("UICorner", top).CornerRadius = UDim.new(0, 20)

	local topFix = Instance.new("Frame", top)
	topFix.Size             = UDim2.new(1, 0, 0.5, 0)
	topFix.Position         = UDim2.new(0, 0, 0.5, 0)
	topFix.BackgroundColor3 = KyzenUI.Theme.Surface
	topFix.BorderSizePixel  = 0

	local logo = Instance.new("ImageLabel", top)
	logo.BackgroundTransparency = 1
	logo.Size     = UDim2.new(0, 110, 0, 38)
	logo.Position = UDim2.new(0, 10, 0, 7)
	logo.Image    = "rbxassetid://91493125301731"

	local closeBtn = Instance.new("TextButton", top)
	closeBtn.Size             = UDim2.new(0, 34, 0, 34)
	closeBtn.Position         = UDim2.new(1, -42, 0, 9)
	closeBtn.Text             = "✕"
	closeBtn.TextColor3       = KyzenUI.Theme.Text
	closeBtn.TextSize         = 16
	closeBtn.BackgroundColor3 = Color3.fromRGB(40, 14, 18)
	closeBtn.AutoButtonColor  = false
	closeBtn.Font             = Enum.Font.GothamBold
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	closeBtn.MouseButton1Click:Connect(function()
		open = false
		main.Visible = false
		island.Text  = "⚡ Kyzen Hub"
	end)

	-- SEARCH BAR
	local searchBar = Instance.new("TextBox", main)
	searchBar.Size             = UDim2.new(1, -20, 0, 34)
	searchBar.Position         = UDim2.new(0, 10, 0, 56)
	searchBar.PlaceholderText  = "🔍  SEARCH..."
	searchBar.Text             = ""
	searchBar.TextColor3       = KyzenUI.Theme.Text
	searchBar.PlaceholderColor3 = KyzenUI.Theme.SubText
	searchBar.BackgroundColor3 = KyzenUI.Theme.Surface2
	searchBar.Font             = Enum.Font.Gotham
	searchBar.TextSize         = 13
	searchBar.ClearTextOnFocus = false
	Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 10)
	Instance.new("UIStroke", searchBar).Color         = KyzenUI.Theme.Primary

	-- TAB BAR
	local tabBar = Instance.new("Frame", main)
	tabBar.Size                 = UDim2.new(1, 0, 0, 36)
	tabBar.Position             = UDim2.new(0, 0, 0, 94)
	tabBar.BackgroundTransparency = 1

	local tabLayout = Instance.new("UIListLayout", tabBar)
	tabLayout.FillDirection     = Enum.FillDirection.Horizontal
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	tabLayout.Padding           = UDim.new(0, 4)
	tabLayout.SortOrder         = Enum.SortOrder.LayoutOrder

	local tabPad = Instance.new("UIPadding", tabBar)
	tabPad.PaddingLeft = UDim.new(0, 8)

	-- PAGE CONTAINER
	local pageContainer = Instance.new("Frame", main)
	pageContainer.Position         = UDim2.new(0, 0, 0, 130)
	pageContainer.Size             = UDim2.new(1, 0, 1, -130)
	pageContainer.BackgroundTransparency = 1
	pageContainer.ClipsDescendants = true

	-- Search filtering
	local allElements = {}

	searchBar:GetPropertyChangedSignal("Text"):Connect(function()
		local query = searchBar.Text:lower()
		if query == "" then
			for _, el in pairs(allElements) do
				el.frame.Visible = true
			end
		else
			for _, el in pairs(allElements) do
				el.frame.Visible = el.label:lower():find(query) ~= nil
			end
		end
	end)

	-- Island toggle
	main.Visible = false
	open = false

	island.MouseButton1Click:Connect(function()
		open = not open
		main.Visible = open
		island.Text = open and "✕ Close" or "⚡ Kyzen Hub"
		if open then
			-- Tween mở
			main.Size = UDim2.new(.92,0,.01,0)
			TweenService:Create(main, TweenInfo.new(.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(.92,0,.74,0)
			}):Play()
		end
	end)

	-- ── AddTab ─────────────────────
	function win:AddTab(name)
		local t = {}
		local elemY = 0
		local elements = {}

		-- Page
		local page = Instance.new("ScrollingFrame", pageContainer)
		page.Size               = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible            = #pageList == 0
		page.ScrollBarThickness = 3
		page.CanvasSize         = UDim2.new(0, 0, 0, 0)
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.Name               = name

		local pagePad = Instance.new("UIPadding", page)
		pagePad.PaddingLeft   = UDim.new(0, 8)
		pagePad.PaddingRight  = UDim.new(0, 8)
		pagePad.PaddingTop    = UDim.new(0, 6)
		pagePad.PaddingBottom = UDim.new(0, 10)

		local pageLayout = Instance.new("UIListLayout", page)
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Padding   = UDim.new(0, 6)

		table.insert(pageList, page)

		-- Tab Button
		local tabBtn = Instance.new("TextButton", tabBar)
		tabBtn.Size             = UDim2.new(0, 80, 0, 28)
		tabBtn.Text             = name
		tabBtn.Font             = Enum.Font.GothamSemibold
		tabBtn.TextSize         = 12
		tabBtn.TextColor3       = KyzenUI.Theme.SubText
		tabBtn.BackgroundColor3 = KyzenUI.Theme.Surface2
		tabBtn.AutoButtonColor  = false
		tabBtn.LayoutOrder      = #tabList + 1
		Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

		local function setActive(active)
			if active then
				tabBtn.TextColor3       = KyzenUI.Theme.Text
				tabBtn.BackgroundColor3 = KyzenUI.Theme.Primary
			else
				tabBtn.TextColor3       = KyzenUI.Theme.SubText
				tabBtn.BackgroundColor3 = KyzenUI.Theme.Surface2
			end
		end

		if #pageList == 1 then setActive(true) end

		tabBtn.MouseButton1Click:Connect(function()
			for _, p in pairs(pageList) do p.Visible = false end
			page.Visible = true
			for _, btn in pairs(tabList) do
				btn.TextColor3       = KyzenUI.Theme.SubText
				btn.BackgroundColor3 = KyzenUI.Theme.Surface2
			end
			setActive(true)
		end)

		table.insert(tabList, tabBtn)

		-- ── Shared card factory ──────
		local function newCard(labelText, h)
			h = h or 54
			local f = Instance.new("Frame", page)
			f.Size             = UDim2.new(1, 0, 0, h)
			f.BackgroundColor3 = KyzenUI.Theme.Surface
			f.LayoutOrder      = elemY
			elemY += 1
			Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
			local s = Instance.new("UIStroke", f)
			s.Color = KyzenUI.Theme.Primary
			s.Transparency = 0.7

			local lbl = Instance.new("TextLabel", f)
			lbl.Size               = UDim2.new(0.6, 0, 0, 20)
			lbl.Position           = UDim2.new(0, 12, 0, 8)
			lbl.Text               = labelText
			lbl.TextColor3         = KyzenUI.Theme.Text
			lbl.Font               = Enum.Font.GothamSemibold
			lbl.TextSize           = 13
			lbl.TextXAlignment     = Enum.TextXAlignment.Left
			lbl.BackgroundTransparency = 1

			table.insert(allElements, { frame = f, label = labelText })
			return f, lbl
		end

		-- ── AddButton ───────────────
		function t:AddButton(opts)
			opts = opts or {}
			local f, lbl = newCard(opts.Name or "Button")
			lbl.Position = UDim2.new(0, 12, 0.5, -10)

			local desc = Instance.new("TextLabel", f)
			desc.Size               = UDim2.new(0.58, 0, 0, 16)
			desc.Position           = UDim2.new(0, 12, 0.5, 4)
			desc.Text               = opts.Description or ""
			desc.TextColor3         = KyzenUI.Theme.SubText
			desc.Font               = Enum.Font.Gotham
			desc.TextSize           = 10
			desc.TextXAlignment     = Enum.TextXAlignment.Left
			desc.BackgroundTransparency = 1

			local btn = Instance.new("TextButton", f)
			btn.Size             = UDim2.new(0, 72, 0, 30)
			btn.Position         = UDim2.new(1, -82, 0.5, -15)
			btn.Text             = opts.ButtonText or "Execute"
			btn.Font             = Enum.Font.GothamBold
			btn.TextSize         = 12
			btn.TextColor3       = KyzenUI.Theme.Text
			btn.BackgroundColor3 = KyzenUI.Theme.Primary
			btn.AutoButtonColor  = false
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn, TweenInfo.new(.1), { BackgroundTransparency = .4 }):Play()
				task.wait(.12)
				TweenService:Create(btn, TweenInfo.new(.1), { BackgroundTransparency = 0 }):Play()
				if opts.Callback then opts.Callback() end
			end)
		end

		-- ── AddToggle ───────────────
		function t:AddToggle(opts)
			opts = opts or {}
			local key   = opts.ConfigKey or opts.Name
			local state = ConfigData[key] ~= nil and ConfigData[key] or (opts.Default or false)

			local f, lbl = newCard(opts.Name or "Toggle")
			lbl.Position = UDim2.new(0, 12, 0.5, -10)

			local desc = Instance.new("TextLabel", f)
			desc.Size               = UDim2.new(0.65, 0, 0, 16)
			desc.Position           = UDim2.new(0, 12, 0.5, 4)
			desc.Text               = opts.Description or ""
			desc.TextColor3         = KyzenUI.Theme.SubText
			desc.Font               = Enum.Font.Gotham
			desc.TextSize           = 10
			desc.TextXAlignment     = Enum.TextXAlignment.Left
			desc.BackgroundTransparency = 1

			local track = Instance.new("TextButton", f)
			track.Size             = UDim2.new(0, 46, 0, 24)
			track.Position         = UDim2.new(1, -58, 0.5, -12)
			track.BackgroundColor3 = state and KyzenUI.Theme.Primary or Color3.fromRGB(50,50,50)
			track.AutoButtonColor  = false
			track.Text             = ""
			Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

			local knob = Instance.new("Frame", track)
			knob.Size             = UDim2.new(0, 18, 0, 18)
			knob.Position         = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			knob.BackgroundColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

			local function setToggle(v)
				state = v
				TweenService:Create(track, TweenInfo.new(.2), { BackgroundColor3 = v and KyzenUI.Theme.Primary or Color3.fromRGB(50,50,50) }):Play()
				TweenService:Create(knob, TweenInfo.new(.2), { Position = v and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) }):Play()
				if key then ConfigData[key] = v; saveConfig() end
				if opts.Callback then opts.Callback(v) end
			end

			setToggle(state)

			track.MouseButton1Click:Connect(function()
				setToggle(not state)
			end)

			return { Set = setToggle, Get = function() return state end }
		end

		-- ── AddSlider ───────────────
		function t:AddSlider(opts)
			opts = opts or {}
			local key = opts.ConfigKey or opts.Name
			local min = opts.Min or 0
			local max = opts.Max or 100
			local val = ConfigData[key] ~= nil and ConfigData[key] or (opts.Default or min)

			local f, lbl = newCard(opts.Name or "Slider", 64)

			local valLabel = Instance.new("TextLabel", f)
			valLabel.Size               = UDim2.new(0, 40, 0, 18)
			valLabel.Position           = UDim2.new(1, -48, 0, 8)
			valLabel.Text               = tostring(val)
			valLabel.TextColor3         = KyzenUI.Theme.Primary
			valLabel.Font               = Enum.Font.GothamBold
			valLabel.TextSize           = 13
			valLabel.BackgroundTransparency = 1

			local track = Instance.new("Frame", f)
			track.Size             = UDim2.new(1, -24, 0, 6)
			track.Position         = UDim2.new(0, 12, 0, 38)
			track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

			local fill = Instance.new("Frame", track)
			fill.Size             = UDim2.new((val - min)/(max - min), 0, 1, 0)
			fill.BackgroundColor3 = KyzenUI.Theme.Primary
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			local knob = Instance.new("TextButton", track)
			knob.Size             = UDim2.new(0, 16, 0, 16)
			knob.AnchorPoint      = Vector2.new(.5, .5)
			knob.Position         = UDim2.new((val - min)/(max - min), 0, .5, 0)
			knob.BackgroundColor3 = Color3.new(1,1,1)
			knob.Text             = ""
			knob.AutoButtonColor  = false
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

			local dragging = false
			knob.MouseButton1Down:Connect(function() dragging = true end)
			game:GetService("UserInputService").InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			game:GetService("UserInputService").InputChanged:Connect(function(i)
				if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
					local absPos  = track.AbsolutePosition.X
					local absSize = track.AbsoluteSize.X
					local rel     = math.clamp((i.Position.X - absPos) / absSize, 0, 1)
					val = math.floor(min + rel*(max - min))
					fill.Size     = UDim2.new(rel, 0, 1, 0)
					knob.Position = UDim2.new(rel, 0, .5, 0)
					valLabel.Text = tostring(val)
					if key then ConfigData[key] = val; saveConfig() end
					if opts.Callback then opts.Callback(val) end
				end
			end)

			return { Set = function(v)
				val = math.clamp(v, min, max)
				local rel = (val - min)/(max - min)
				fill.Size     = UDim2.new(rel, 0, 1, 0)
				knob.Position = UDim2.new(rel, 0, .5, 0)
				valLabel.Text = tostring(val)
			end, Get = function() return val end }
		end
		-- ── AddDropdown ─────────────
		function t:AddDropdown(opts)
			opts = opts or {}
			local key     = opts.ConfigKey or opts.Name
			local options = opts.Options or {}
			local chosen  = ConfigData[key] or opts.Default or (options[1] or "Select")

			local f, lbl = newCard(opts.Name or "Dropdown", 54)

			local dropBtn = Instance.new("TextButton", f)
			dropBtn.Size             = UDim2.new(0, 130, 0, 28)
			dropBtn.Position         = UDim2.new(1, -140, 0.5, -14)
			dropBtn.Text             = chosen .. "  ▾"
			dropBtn.Font             = Enum.Font.Gotham
			dropBtn.TextSize         = 12
			dropBtn.TextColor3       = KyzenUI.Theme.Text
			dropBtn.BackgroundColor3 = KyzenUI.Theme.Surface2
			dropBtn.AutoButtonColor  = false
			Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", dropBtn).Color        = KyzenUI.Theme.Primary

			local menu = Instance.new("Frame", gui)
			menu.Size             = UDim2.new(0, 130, 0, #options * 32 + 8)
			menu.BackgroundColor3 = KyzenUI.Theme.Surface
			menu.Visible          = false
			menu.ZIndex           = 15
			Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
			local ml = Instance.new("UIListLayout", menu)
			ml.SortOrder = Enum.SortOrder.LayoutOrder
			ml.Padding   = UDim.new(0, 2)
			local mp = Instance.new("UIPadding", menu)
			mp.PaddingLeft = UDim.new(0,4); mp.PaddingRight = UDim.new(0,4)
			mp.PaddingTop  = UDim.new(0,4)
			Instance.new("UIStroke", menu).Color = KyzenUI.Theme.Primary

			local function setChosen(v)
				chosen = v
				dropBtn.Text = v .. "  ▾"
				menu.Visible = false
				if key then ConfigData[key] = v; saveConfig() end
				if opts.Callback then opts.Callback(v) end
			end

			for i, opt in ipairs(options) do
				local ob = Instance.new("TextButton", menu)
				ob.Size             = UDim2.new(1, 0, 0, 28)
				ob.Text             = opt
				ob.Font             = Enum.Font.Gotham
				ob.TextSize         = 12
				ob.TextColor3       = KyzenUI.Theme.Text
				ob.BackgroundColor3 = KyzenUI.Theme.Surface2
				ob.AutoButtonColor  = false
				ob.LayoutOrder      = i
				Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)
				ob.MouseButton1Click:Connect(function() setChosen(opt) end)
			end

			dropBtn.MouseButton1Click:Connect(function()
				menu.Visible = not menu.Visible
				if menu.Visible then
					local abs = dropBtn.AbsolutePosition
					menu.Position = UDim2.new(0, abs.X, 0, abs.Y + 32)
				end
			end)

			return { Set = setChosen, Get = function() return chosen end }
		end

		-- ── AddLabel ────────────────
		function t:AddLabel(text)
			local f = newCard(text, 36)
			return f
		end

		return t
	end

	return win
end

-- ══════════════════════════════
--  EXPORTS
-- ══════════════════════════════
return KyzenUI
