--[=[
    ImGui Library (converted from @uniquadev output)
    Visuals: 1-to-1 copy of the converter dump
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local Library = {}

local FONT_ROBOTO = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FONT_SRC    = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FONT_UBUNTU = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

function Library:Init(defaults, options)
	options = options or {}
	for k, v in pairs(defaults) do
		if options[k] == nil then options[k] = v end
	end
	return options
end

local function Create(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do inst[k] = v end
	if parent then inst.Parent = parent end
	return inst
end

function Library:new(options)
	options = self:Init({
		name = "ImGui",
		size = UDim2.new(0, 500, 0, 600),
		keybind = Enum.KeyCode.RightShift
	}, options)

	local Window = {}
	Window.Tabs = {}
	Window.ActiveTab = nil
	Window.Opened = true

	--------------------------------------------------------------
	-- Root ScreenGui
	--------------------------------------------------------------
	local ScreenGui = Create("ScreenGui", {
		Name = "MyLib",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or CoreGui)

	--------------------------------------------------------------
	-- Main
	--------------------------------------------------------------
	local Main = Create("Frame", {
		Name = "Main", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(36, 38, 37),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = options.size,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	}, ScreenGui)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, Main)
	Create("UIStroke", { Color = Color3.fromRGB(55, 87, 129) }, Main)

	--------------------------------------------------------------
	-- TopBar
	--------------------------------------------------------------
	local TopBar = Create("Frame", {
		Name = "TopBar", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(1, 0, 0, 28),
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, TopBar)
	Create("UIStroke", {
		Color = Color3.fromRGB(36, 38, 37),
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	}, TopBar)

	local Extension = Create("Frame", {
		Name = "Extension", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 0, 14),
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	}, TopBar)

	local Title = Create("TextLabel", {
		Name = "Title", BorderSizePixel = 0,
		TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = FONT_ROBOTO,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		Text = options.name
	}, TopBar)
	Create("UIPadding", { PaddingLeft = UDim.new(0, 35) }, Title)

	local ExitButton = Create("TextButton", {
		Name = "ExitButton", BorderSizePixel = 0,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = FONT_SRC,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.056, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "X",
		Position = UDim2.new(0.944, 0, 0, 0)
	}, TopBar)

	local ShownButton = Create("TextButton", {
		Name = "ShownButton", BorderSizePixel = 0,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = FONT_SRC,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.056, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "▼",
		Position = UDim2.new(0.888, 0, 0, 0)
	}, TopBar)

	--------------------------------------------------------------
	-- ContentContainer
	--------------------------------------------------------------
	local ContentContainer = Create("Frame", {
		Name = "ContentContainer", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(36, 38, 37),
		Size = UDim2.new(0.964, 0, 0.83, 28),
		Position = UDim2.new(0.022, 0, 0.10333, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.8
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, ContentContainer)

	--------------------------------------------------------------
	-- Navigation (horizontal tab bar)
	--------------------------------------------------------------
	local Navigation = Create("Frame", {
		Name = "Navigation", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(0.96, 0, 0.005, 28),
		Position = UDim2.new(0.022, 0, 0.05, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, Navigation)

	Create("Frame", {
		Name = "Hide", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1
	}, Navigation)
	Create("Frame", {
		Name = "Hide2", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0, 20, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1
	}, Navigation)

	local ButtonHolder = Create("Frame", {
		Name = "ButtonHolder", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, Navigation)
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8)
	}, ButtonHolder)
	Create("UIListLayout", {
		Padding = UDim.new(0, 1),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal
	}, ButtonHolder)

	--------------------------------------------------------------
	-- ShownButton behavior
	--------------------------------------------------------------
	local uiShown = true
	ShownButton.MouseButton1Click:Connect(function()
		uiShown = not uiShown
		Navigation.Visible = uiShown
		ContentContainer.Visible = uiShown
		ShownButton.Text = uiShown and "▼" or "▲"
		if uiShown then
			Main.Size = options.size
		else
			Main.Size = UDim2.new(0, options.size.X.Offset, 0, 32)
		end
	end)

	--------------------------------------------------------------
	-- Drag
	--------------------------------------------------------------
	local dragging, dragInput, dragStart, startPos
	local function updateDrag(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then updateDrag(input) end
	end)

	--------------------------------------------------------------
	-- Close / keybind
	--------------------------------------------------------------
	ExitButton.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = false
		Window.Opened = false
	end)
	UIS.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == options.keybind then
			Window.Opened = not Window.Opened
			ScreenGui.Enabled = Window.Opened
		end
	end)

	--------------------------------------------------------------
	-- Notifications
	--------------------------------------------------------------
	local NotifHolder = Create("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -12, 1, -12),
		Size = UDim2.new(0, 300, 1, -24),
		BackgroundTransparency = 1
	}, ScreenGui)
	Create("UIListLayout", {
		Padding = UDim.new(0, 6),
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder
	}, NotifHolder)

	local notifOrder = 0
	function Window:Notify(text, duration)
		duration = duration or 3
		notifOrder = notifOrder + 1
		local Frame = Create("Frame", {
			Name = "Notif", Size = UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = Color3.fromRGB(36, 38, 37),
			BackgroundTransparency = 0.1, BorderSizePixel = 0,
			LayoutOrder = -notifOrder
		}, NotifHolder)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, Frame)
		Create("UIStroke", { Color = Color3.fromRGB(55, 87, 129), Thickness = 1 }, Frame)
		Create("TextLabel", {
			Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0),
			BackgroundTransparency = 1, Text = tostring(text),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham, TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true, Parent = Frame
		})
		task.delay(duration, function()
			if Frame and Frame.Parent then Frame:Destroy() end
		end)
	end

	--------------------------------------------------------------
	-- Component factories (visuals 1:1 with converter)
	--------------------------------------------------------------
	local function makeButton(parent, text, cb)
		local row = Create("Frame", {
			Name = "Button", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		}, parent)
		local lbl = Create("TextLabel", {
			Name = "Title", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = text
		}, row)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, lbl)
		local click = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
			Text = "", Parent = row
		}, row)
		click.MouseButton1Click:Connect(function() if cb then cb() end end)
		return row
	end

	local function makeLabel(parent, text, color)
		local row = Create("Frame", {
			Name = "Label", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		}, parent)
		local lbl = Create("TextLabel", {
			Name = "Title", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = color or Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = tostring(text)
		}, row)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, lbl)
		return row
	end

	local function makeInfo(parent, text) return makeLabel(parent, text, Color3.fromRGB(255, 255, 16)) end
	local function makeWarning(parent, text) return makeLabel(parent, text, Color3.fromRGB(255, 0, 0)) end

	local function makeToggle(parent, text, default, cb)
		local row = Create("Frame", {
			Name = default and "ToggleActive" or "ToggleInactive",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		local lbl = Create("TextLabel", {
			Name = "Title", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = text
		}, row)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, lbl)

		local check = Create("Frame", {
			Name = "CheckmarkHolder", BorderSizePixel = 0,
			BackgroundColor3 = default and Color3.fromRGB(74, 139, 226) or Color3.fromRGB(53, 85, 123),
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0.98892, 0, 0.03125, 5)
		}, row)

		local click = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
			Text = "", Parent = row
		}, row)

		local state = default
		click.MouseButton1Click:Connect(function()
			state = not state
			check.BackgroundColor3 = state and Color3.fromRGB(74, 139, 226) or Color3.fromRGB(53, 85, 123)
			if cb then cb(state) end
		end)

		return {
			Frame = row,
			Set = function(_, v)
				state = not not v
				check.BackgroundColor3 = state and Color3.fromRGB(74, 139, 226) or Color3.fromRGB(53, 85, 123)
				if cb then cb(state) end
			end,
			Get = function() return state end
		}
	end

	local function makeSlider(parent, text, min, max, default, cb)
		local row = Create("Frame", {
			Name = "Slider", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)

		local title = Create("TextLabel", {
			Name = "Title", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -24, 1, 0),
			Text = text
		}, row)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, title)

		local valueLbl = Create("TextLabel", {
			Name = "Value", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_UBUNTU,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, 24, 1, -10),
			Text = tostring(default),
			Position = UDim2.new(1, 0, 0, 0)
		}, row)

		local back = Create("Frame", {
			Name = "SliderBack", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(53, 85, 123),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 0, 4),
			Position = UDim2.new(0, 0, 1, 0)
		}, row)

		local drag = Create("Frame", {
			Name = "Draggable", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(74, 139, 226),
			Size = UDim2.new(0, 0, 1, 0)
		}, back)

		local dragging = false
		local function update(input)
			local pct = math.clamp((input.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
			drag.Size = UDim2.new(pct, 0, 1, 0)
			local v = math.floor(min + (max - min) * pct + 0.5)
			valueLbl.Text = tostring(v)
			if cb then cb(v) end
		end
		back.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true; update(input)
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
		end)
		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)

		drag.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

		return {
			Frame = row,
			Set = function(_, v)
				v = math.clamp(v, min, max)
				local pct = (v - min) / (max - min)
				drag.Size = UDim2.new(pct, 0, 1, 0)
				valueLbl.Text = tostring(math.floor(v))
				if cb then cb(v) end
			end
		}
	end

	local function makeDropdown(parent, text, values, cb)
		local drop = Create("Frame", {
			Name = "DropDown", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 32),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		}, parent)

		local title = Create("TextLabel", {
			Name = "Title", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = text
		}, drop)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, title)

		local holder = Create("Frame", {
			Name = "OptionHolder",
			Visible = false, BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 1, -32),
			Position = UDim2.new(0, 0, 0, 26),
			BackgroundTransparency = 1
		}, drop)
		Create("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, holder)

		local click = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32),
			Text = "", Parent = drop
		}, drop)

		local opened = false
		click.MouseButton1Click:Connect(function()
			opened = not opened
			holder.Visible = opened
			if opened then
				holder.Size = UDim2.new(1, 0, 0, #values * 17)
				drop.Size = UDim2.new(1, 0, 0, 32 + #values * 17 + 4)
			else
				drop.Size = UDim2.new(1, 0, 0, 32)
			end
		end)

		for _, opt in ipairs(values) do
			local optLbl = Create("TextLabel", {
				BorderSizePixel = 0, TextSize = 14,
				BackgroundColor3 = Color3.fromRGB(74, 139, 226),
				FontFace = FONT_ROBOTO,
				TextColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				Size = UDim2.new(1, 0, 0, 16),
				Text = opt
			}, holder)
			Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, optLbl)
			local optBtn = Create("TextButton", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
				Text = "", Parent = optLbl
			}, optLbl)
			optBtn.MouseEnter:Connect(function() optLbl.BackgroundTransparency = 0.2 end)
			optBtn.MouseLeave:Connect(function() optLbl.BackgroundTransparency = 0.7 end)
			optBtn.MouseButton1Click:Connect(function()
				title.Text = text .. ": " .. opt
				opened = false
				holder.Visible = false
				drop.Size = UDim2.new(1, 0, 0, 32)
				if cb then cb(opt) end
			end)
		end

		return drop
	end

	local function makeInput(parent, text, default, placeholder, cb)
		local row = Create("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)

		local lbl = Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.4, 0, 1, 0),
			Text = text
		}, row)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, lbl)

		local box = Create("TextBox", {
			BorderSizePixel = 0, TextSize = 14,
			BackgroundColor3 = Color3.fromRGB(45, 70, 105),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham,
			PlaceholderText = placeholder or "",
			Text = default or "",
			Size = UDim2.new(0.55, -10, 0, 22),
			Position = UDim2.new(0.4, 0, 0, 5),
			ClearTextOnFocus = false
		}, row)
		Create("UICorner", { CornerRadius = UDim.new(0, 3) }, box)
		box.FocusLost:Connect(function() if cb then cb(box.Text) end end)
		return row
	end

	--------------------------------------------------------------
-- ColorPicker
--------------------------------------------------------------
local function makeColorPicker(parent, text, default, callback)
	text = text or "Color"
	default = default or Color3.fromRGB(255, 255, 255)
	callback = callback or function() end

	local h, s, v = Color3.toHSV(default)
	local hue, sat, val = h, s, v

	-- Root row (как DropDown: 32px, синий, кликабельный)
	local root = Create("Frame", {
		Name = "ColorPicker", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 32),
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	}, parent)

	local title = Create("TextLabel", {
		Name = "Title", BorderSizePixel = 0, TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = FONT_ROBOTO,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -70, 1, 0),
		Text = text
	}, root)
	Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, title)

	-- Превью-квадратик текущего цвета справа
	local preview = Create("Frame", {
		Name = "Preview", BorderSizePixel = 0,
		BackgroundColor3 = default,
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0.98892, 0, 0.03125, 5)
	}, root)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, preview)

	-- Клик по шапке — открыть/закрыть
	local headerClick = Create("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		Text = "", Parent = root
	}, root)

	-- Тело (появляется при открытии)
	local body = Create("Frame", {
		Name = "Body", BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 32),
		Size = UDim2.new(1, 0, 0, 120)
	}, root)

	-- SV-квадрат (Hue x Sat)
	local svFrame = Create("Frame", {
		Name = "SV", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Position = UDim2.new(0, 10, 0, 6),
		Size = UDim2.new(1, -70, 0, 90)
	}, body)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, svFrame)

	-- Белый градиент (сверху вниз): 1 → 0 по S
	local whiteGrad = Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, svFrame)
	local wGrad = Create("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Rotation = 0
	}, whiteGrad)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, whiteGrad)

	-- Чёрный градиент (сверху-вниз уже применён, теперь чёрный слева-направо —> по H)
	local hueGrad = Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 2
	}, svFrame)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, hueGrad)

	-- Сделаем Hue через UIGradient с HSV-последовательностью (7 ключевых точек)
	local hueSeq = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0.00, 1, 1)),
		ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
		ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
		ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
		ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
		ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
		ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1.00, 1, 1))
	})
	local hGrad = Create("UIGradient", {
		Color = hueSeq,
		Transparency = NumberSequence.new(0),
		Rotation = 90
	}, hueGrad)
	hueGrad.BackgroundTransparency = 0
	hueGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	-- Маркер позиции (кружок)
	local svMarker = Create("Frame", {
		Name = "Marker", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.5,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 10, 0, 10),
		ZIndex = 5
	}, svFrame)
	Create("UICorner", { CornerRadius = UDim.new(1, 0) }, svMarker)
	Create("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1 }, svMarker)

	-- Brightness-полоса (справа)
	local valBar = Create("Frame", {
		Name = "Value", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 6),
		Size = UDim2.new(0, 16, 0, 90)
	}, body)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, valBar)
	local vGrad = Create("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)),
		Rotation = 90
	}, valBar)

	local vMarker = Create("Frame", {
		Name = "Marker", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.5,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 10, 0, 10),
		Position = UDim2.new(0.5, 0, 1, 0),
		ZIndex = 5
	}, valBar)
	Create("UICorner", { CornerRadius = UDim.new(1, 0) }, vMarker)
	Create("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1 }, vMarker)

	-- Поле Hex + кнопка Rainbow
	local hexBox = Create("TextBox", {
		Name = "HexBox", BorderSizePixel = 0, TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(45, 70, 105),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		Text = "#FFFFFF",
		Position = UDim2.new(0, 10, 0, 100),
		Size = UDim2.new(1, -80, 0, 20),
		ClearTextOnFocus = false
	}, body)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, hexBox)

	local rainbowBtn = Create("TextButton", {
		Name = "RainbowBtn", BorderSizePixel = 0, TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(74, 139, 226),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = FONT_ROBOTO,
		Text = "Rainbow",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 100),
		Size = UDim2.new(0, 60, 0, 20)
	}, body)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, rainbowBtn)

	-- Helper: конвертирует HSV в Color3 и обновляет UI
	local function applyColor()
		local c = Color3.fromHSV(hue, sat, val)
		preview.BackgroundColor3 = c
		hexBox.Text = string.format("#%02X%02X%02X",
			math.floor(c.R * 255),
			math.floor(c.G * 255),
			math.floor(c.B * 255))
		callback(c)
	end

	local function updateMarkers()
		svMarker.Position = UDim2.new(sat, 0, 1 - val, 0)
		vMarker.Position = UDim2.new(0.5, 0, val, 0)
		svFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
	end

	updateMarkers()

	-- Взаимодействие с SV
	local svDragging = false
	svFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			svDragging = true
			local mx = input.Position.X - svFrame.AbsolutePosition.X
			local my = input.Position.Y - svFrame.AbsolutePosition.Y
			sat = math.clamp(mx / svFrame.AbsoluteSize.X, 0, 1)
			val = math.clamp(1 - my / svFrame.AbsoluteSize.Y, 0, 1)
			updateMarkers()
			applyColor()
		end
	end)

	-- Взаимодействие с Value-полосой
	local vDragging = false
	valBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			vDragging = true
			local my = input.Position.Y - valBar.AbsolutePosition.Y
			val = math.clamp(1 - my / valBar.AbsoluteSize.Y, 0, 1)
			updateMarkers()
			applyColor()
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		if svDragging then
			local mx = input.Position.X - svFrame.AbsolutePosition.X
			local my = input.Position.Y - svFrame.AbsolutePosition.Y
			sat = math.clamp(mx / svFrame.AbsoluteSize.X, 0, 1)
			val = math.clamp(1 - my / svFrame.AbsoluteSize.Y, 0, 1)
			updateMarkers()
			applyColor()
		end
		if vDragging then
			local my = input.Position.Y - valBar.AbsolutePosition.Y
			val = math.clamp(1 - my / valBar.AbsoluteSize.Y, 0, 1)
			updateMarkers()
			applyColor()
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			svDragging = false
			vDragging = false
		end
	end)

	-- Hue через горизонтальный скролл внутри svFrame по движению мыши с зажатым Shift
	-- Проще: отдельный тонкий ряд HueBar под SV
	local hueBar = Create("Frame", {
		Name = "HueBar", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Position = UDim2.new(0, 10, 0, 100),
		Size = UDim2.new(1, -80, 0, 6)
	}, body)
	hueBar.Position = UDim2.new(0, 10, 0, 100)
	-- сдвинем hexBox ниже
	hexBox.Position = UDim2.new(0, 10, 0, 112)
	rainbowBtn.Position = UDim2.new(1, -10, 0, 112)
	body.Size = UDim2.new(1, 0, 0, 140)

	local hueGrad2 = Create("UIGradient", {
		Color = hueSeq,
		Rotation = 0
	}, hueBar)
	Create("UICorner", { CornerRadius = UDim.new(0, 3) }, hueBar)

	local hueMarker = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.5,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 6, 1, 4),
		Position = UDim2.new(hue, 0, 0.5, 0),
		ZIndex = 5
	}, hueBar)
	Create("UICorner", { CornerRadius = UDim.new(1, 0) }, hueMarker)
	Create("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1 }, hueMarker)

	local hueDragging = false
	hueBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			hueDragging = true
			local mx = input.Position.X - hueBar.AbsolutePosition.X
			hue = math.clamp(mx / hueBar.AbsoluteSize.X, 0, 1)
			hueMarker.Position = UDim2.new(hue, 0, 0.5, 0)
			updateMarkers()
			applyColor()
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mx = input.Position.X - hueBar.AbsolutePosition.X
			hue = math.clamp(mx / hueBar.AbsoluteSize.X, 0, 1)
			hueMarker.Position = UDim2.new(hue, 0, 0.5, 0)
			updateMarkers()
			applyColor()
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			hueDragging = false
		end
	end)

	-- Hex input
	hexBox.FocusLost:Connect(function(enter)
		if not enter then return end
		local hex = hexBox.Text:gsub("#", "")
		if #hex == 6 then
			local r = tonumber(hex:sub(1,2), 16)
			local g = tonumber(hex:sub(3,4), 16)
			local b = tonumber(hex:sub(5,6), 16)
			if r and g and b then
				local c = Color3.fromRGB(r, g, b)
				hue, sat, val = Color3.toHSV(c)
				updateMarkers()
				hueMarker.Position = UDim2.new(hue, 0, 0.5, 0)
				applyColor()
			end
		end
	end)

	-- Rainbow toggle
	local rainbowOn = false
	local rainbowConn
	rainbowBtn.MouseButton1Click:Connect(function()
		rainbowOn = not rainbowOn
		if rainbowOn then
			rainbowBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
			rainbowBtn.Text = "Rainbow ✓"
			rainbowConn = RunService.RenderStepped:Connect(function()
				hue = (tick() * 0.3) % 1
				hueMarker.Position = UDim2.new(hue, 0, 0.5, 0)
				updateMarkers()
				applyColor()
			end)
		else
			rainbowBtn.BackgroundColor3 = Color3.fromRGB(74, 139, 226)
			rainbowBtn.Text = "Rainbow"
			if rainbowConn then rainbowConn:Disconnect() end
		end
	end)

	-- Открытие / закрытие
	local opened = false
	local function setOpen(state)
		opened = state
		body.Visible = opened
		root.Size = opened and UDim2.new(1, 0, 0, 32 + body.Size.Y.Offset) or UDim2.new(1, 0, 0, 32)
	end
	setOpen(false)

	headerClick.MouseButton1Click:Connect(function()
		setOpen(not opened)
	end)

	-- API
	local CP = {}
	function CP:Set(color)
		color = typeof(color) == "Color3" and color or Color3.fromRGB(255, 255, 255)
		hue, sat, val = Color3.toHSV(color)
		updateMarkers()
		hueMarker.Position = UDim2.new(hue, 0, 0.5, 0)
		applyColor()
	end
	function CP:Get()
		return Color3.fromHSV(hue, sat, val)
	end
	function CP:SetOpen(s) setOpen(s) end
	function CP:Destroy() root:Destroy() end

	applyColor()
	return CP
end

	--------------------------------------------------------------
	-- CollapsingHeader factory
	--------------------------------------------------------------
	local function makeCollapsingHeader(parent, headerName)
		headerName = headerName or "Collapsing Header"

		-- Header (blue 32px strip)
		local header = Create("Frame", {
			Name = "CollapsingHeader", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		}, parent)

		local titleLbl = Create("TextLabel", {
			Name = "Title", BorderSizePixel = 0, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = headerName,
			Position = UDim2.new(0, 0, 0, 0)
		}, header)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 30) }, titleLbl)

		local shownBtn = Create("TextLabel", {
			Name = "ShownButton", Active = true,
			BorderSizePixel = 0, TextSize = 14,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = FONT_SRC,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.064, 0, 0.96, 0),
			Text = "▼", Selectable = true
		}, header)

		local click = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
			Text = "", Parent = header
		}, header)

		-- GroupHolder (elements go here)
		local holder = Create("Frame", {
			Name = "GroupHolder", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 32),
			BackgroundTransparency = 1
		}, header)
		Create("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, holder)

		local CH = {}
		function CH:AddToggle(id, o)  return makeToggle(holder, o.Text, o.Default, o.Callback) end
		function CH:AddSlider(id, o)  return makeSlider(holder, o.Text, o.Min, o.Max, o.Default, o.Callback) end
		function CH:AddButton(o)      return makeButton(holder, o.Text, o.Func) end
		function CH:AddLabel(t)       return makeLabel(holder, t) end
		function CH:AddInfo(t)        return makeInfo(holder, t) end
		function CH:AddWarning(t)     return makeWarning(holder, t) end
		function CH:AddDropdown(id,o) return makeDropdown(holder, o.Text, o.Values, o.Callback) end
		function CH:AddInput(id,o)    return makeInput(holder, o.Text, o.Default, o.Placeholder, o.Callback) end

		local open = true
		click.MouseButton1Click:Connect(function()
			open = not open
			holder.Visible = open
			shownBtn.Text = open and "▼" or "▶"
			header.Size = open and UDim2.new(1, 0, 0, 32) or UDim2.new(1, 0, 0, 32)
		end)

		return CH
	end

	--------------------------------------------------------------
	-- Tab
	--------------------------------------------------------------
	function Window:CreateTab(tabName)
		local Tab = {}

		-- Horizontal tab button (Active/Inactive style from converter)
		local tabBtn = Create("TextLabel", {
			Name = tabName .. "Button",
			BorderSizePixel = 0, TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			FontFace = FONT_ROBOTO,
			TextColor3 = Color3.fromRGB(169, 169, 169),
			BackgroundTransparency = 0.8,
			Size = UDim2.new(0, 90, 0, 22),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = tabName
		}, ButtonHolder)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 8) }, tabBtn)

		local tabClick = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
			Text = "", Parent = tabBtn
		}, tabBtn)

		-- ScrollingFrame page
		local page = Create("ScrollingFrame", {
			Name = tabName .. "Page", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			Visible = false,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, ContentContainer)
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 1),
			PaddingRight = UDim.new(0, 1),
			PaddingLeft = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1)
		}, page)
		Create("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, page)

		tabClick.MouseButton1Click:Connect(function()
			for _, other in pairs(Window.Tabs) do
				other.Button.TextColor3 = Color3.fromRGB(169, 169, 169)
				other.Button.BackgroundTransparency = 0.8
				other.Page.Visible = false
			end
			tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabBtn.BackgroundTransparency = 0
			page.Visible = true
			Window.ActiveTab = Tab
		end)

		if not Window.ActiveTab then
			tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabBtn.BackgroundTransparency = 0
			page.Visible = true
			Window.ActiveTab = Tab
		end

		Tab.Button = tabBtn
		Tab.Page = page
		Window.Tabs[tabName] = Tab

		-- Direct methods
		function Tab:CreateButton(t, cb)     return makeButton(page, t, cb) end
		function Tab:CreateLabel(t)          return makeLabel(page, t) end
		function Tab:CreateInfo(t)           return makeInfo(page, t) end
		function Tab:CreateWarning(t)        return makeWarning(page, t) end
		function Tab:CreateToggle(t, d, cb)  return makeToggle(page, t, d, cb) end
		function Tab:CreateSlider(t, mn, mx, d, cb) return makeSlider(page, t, mn, mx, d, cb) end
		function Tab:CreateDropdown(t, v, cb) return makeDropdown(page, t, v, cb) end
		function Tab:CreateInput(t, d, p, cb) return makeInput(page, t, d, p, cb) end
		function Tab:CreateCollapsingHeader(n) return makeCollapsingHeader(page, n) end

		-- Groupbox = просто прозрачный враппер над page (одна колонка, как в конвертере)
		local function makeGroupbox()
			local gbInner = Create("Frame", {
				Name = "GroupInner", BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = page
			})
			Create("UIListLayout", {
				Padding = UDim.new(0, 1),
				SortOrder = Enum.SortOrder.LayoutOrder
			}, gbInner)

			local GB = {}
			function GB:AddToggle(id, o)  return makeToggle(gbInner, o.Text, o.Default, o.Callback) end
			function GB:AddSlider(id, o)  return makeSlider(gbInner, o.Text, o.Min, o.Max, o.Default, o.Callback) end
			function GB:AddButton(o)      return makeButton(gbInner, o.Text, o.Func) end
			function GB:AddLabel(t)       return makeLabel(gbInner, t) end
			function GB:AddInfo(t)        return makeInfo(gbInner, t) end
			function GB:AddWarning(t)     return makeWarning(gbInner, t) end
			function GB:AddDropdown(id,o) return makeDropdown(gbInner, o.Text, o.Values, o.Callback) end
			function GB:AddInput(id,o)    return makeInput(gbInner, o.Text, o.Default, o.Placeholder, o.Callback) end
			return GB
		end

		function Tab:AddLeftGroupbox(_) return makeGroupbox() end
		function Tab:AddRightGroupbox(_) return makeGroupbox() end

		return Tab
	end

	function Window:AddTab(name) return self:CreateTab(name) end

	return Window
end

return Library
