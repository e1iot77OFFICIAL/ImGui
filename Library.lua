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
