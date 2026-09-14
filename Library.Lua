local players = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")

local Library = {}

function Library:Init(defaults, options)
	options = options or {}
	for key, value in pairs(defaults) do
		if options[key] == nil then options[key] = value end
	end
	return options
end

local function Create(className, properties, parent)
	local instance = Instance.new(className)
	for prop, value in pairs(properties) do
		instance[prop] = value
	end
	if parent then instance.Parent = parent end
	return instance
end

local FONT       = Font.new("rbxasset://fonts/families/RobotoMono.json")
local FONT_LABEL = Font.new("rbxasset://fonts/families/RobotoMono.json")

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

	-- === ScreenGui ===
	local ScreenGui = Create("ScreenGui", {
		Name = "MyLib",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui)

	-- === Main ===
	local Main = Create("Frame", {
		Name = "Main", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(36, 38, 37),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = options.size,
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}, ScreenGui)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, Main)
	Create("UIStroke", { Color = Color3.fromRGB(55, 87, 129), ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Main)

	-- === TopBar ===
	local TopBar = Create("Frame", {
		Name = "TopBar", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(1, 0, 0, 28)
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, TopBar)
	Create("UIStroke", { Color = Color3.fromRGB(36, 38, 37), ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, TopBar)
	Create("Frame", {
		Name = "Extension", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 0, 14)
	}, TopBar)

	local Title = Create("TextLabel", {
		Name = "Title", BorderSizePixel = 0, TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1, FontFace = FONT,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0.5, 0, 1, 0),
		Text = options.name
	}, TopBar)
	Create("UIPadding", { PaddingLeft = UDim.new(0, 35) }, Title)

	local ExitButton = Create("TextButton", {
		Name = "ExitButton", BorderSizePixel = 0, TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.056, 0, 1, 0),
		Position = UDim2.new(0.944, 0, 0, 0),
		Text = "X", FontFace = FONT
	}, TopBar)

	local ShownButton = Create("TextButton", {
		Name = "ShownButton", BorderSizePixel = 0, TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.056, 0, 1, 0),
		Position = UDim2.new(0.888, 0, 0, 0),
		Text = "▼", FontFace = FONT
	}, TopBar)

	-- === Navigation (верхний горизонтальный таб-бар) ===
	local Navigation = Create("Frame", {
		Name = "Navigation", BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.96, 0, 0, 28),
		Position = UDim2.new(0.022, 0, 0, 32)
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, Navigation)

	local ButtonHolder = Create("Frame", {
		Name = "ButtonHolder", BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, Navigation)
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4)
	}, ButtonHolder)
	Create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}, ButtonHolder)

	-- === ContentContainer (контентная область) ===
	local ContentContainer = Create("Frame", {
		Name = "ContentContainer", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(36, 38, 37),
		Size = UDim2.new(0.964, 0, 1, -66),
		Position = UDim2.new(0.018, 0, 0, 62),
		BackgroundTransparency = 0.8
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, ContentContainer)

	-- === ShownButton logic (hide nav + content) ===
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

	-- === Drag ===
	local dragging, dragInput, dragStart, startPos
	local function updateDrag(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	userInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then updateDrag(input) end
	end)

	ExitButton.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = false
		Window.Opened = false
	end)
	userInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == options.keybind then
			Window.Opened = not Window.Opened
			ScreenGui.Enabled = Window.Opened
		end
	end)

	-- === Notifications ===
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

	-- === Component factories ===
	local function makeButton(parent, btnText, callback)
		local ButtonFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, ButtonFrame)
		local BtnTitle = Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = btnText
		}, ButtonFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, BtnTitle)
		local ClickBtn = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
		}, ButtonFrame)
		ClickBtn.MouseButton1Click:Connect(function() if callback then callback() end end)
		return ButtonFrame
	end

	local function makeLabel(parent, text, color)
		local LabelFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, LabelFrame)
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = color or Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = tostring(text)
		}, LabelFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, LabelFrame)
		return LabelFrame
	end

	local function makeInfo(parent, text) return makeLabel(parent, text, Color3.fromRGB(255, 255, 16)) end
	local function makeWarning(parent, text) return makeLabel(parent, text, Color3.fromRGB(255, 0, 0)) end

	local function makeToggle(parent, toggleText, default, callback)
		local ToggleFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, ToggleFrame)
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, -40, 1, 0), Text = toggleText
		}, ToggleFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, ToggleFrame)
		local CheckmarkHolder = Create("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = default and Color3.fromRGB(74, 139, 226) or Color3.fromRGB(53, 85, 123),
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(1, -10, 0.5, 0)
		}, ToggleFrame)
		Create("UICorner", { CornerRadius = UDim.new(0, 3) }, CheckmarkHolder)
		local ClickBtn = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
		}, ToggleFrame)
		local toggled = default
		ClickBtn.MouseButton1Click:Connect(function()
			toggled = not toggled
			CheckmarkHolder.BackgroundColor3 = toggled and Color3.fromRGB(74, 139, 226) or Color3.fromRGB(53, 85, 123)
			if callback then callback(toggled) end
		end)
		return ToggleFrame
	end

	local function makeSlider(parent, sliderText, min, max, default, callback)
		local SliderFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, SliderFrame)
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, -70, 1, 0), Text = sliderText
		}, SliderFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, SliderFrame)
		local ValueLabel = Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 50, 1, 0),
			Text = tostring(default), Position = UDim2.new(1, -10, 0.5, 0)
		}, SliderFrame)
		local SliderBack = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(53, 85, 123),
			AnchorPoint = Vector2.new(0, 1), Size = UDim2.new(1, -20, 0, 4),
			Position = UDim2.new(0, 10, 1, -4)
		}, SliderFrame)
		local Draggable = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(74, 139, 226),
			Size = UDim2.new(0, 0, 1, 0)
		}, SliderBack)
		local draggingSlider = false
		local function updateSlider(input)
			local mousePos = input.Position.X
			local sliderPos = SliderBack.AbsolutePosition.X
			local sliderSize = SliderBack.AbsoluteSize.X
			local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
			Draggable.Size = UDim2.new(percent, 0, 1, 0)
			local value = math.floor(min + ((max - min) * percent) + 0.5)
			ValueLabel.Text = tostring(value)
			if callback then callback(value) end
		end
		SliderBack.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				draggingSlider = true
				updateSlider(input)
			end
		end)
		userInputService.InputChanged:Connect(function(input)
			if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end
		end)
		userInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
		end)
		local defaultPercent = (default - min) / (max - min)
		Draggable.Size = UDim2.new(defaultPercent, 0, 1, 0)
		return SliderFrame
	end

	local function makeDropdown(parent, dropText, optionsList, callback)
		local DropdownFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, DropdownFrame)
		local DropTitle = Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = dropText
		}, DropdownFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, DropTitle)
		local OptionHolder = Create("Frame", {
			Visible = false, BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 32)
		}, DropdownFrame)
		Create("UIListLayout", { Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder }, OptionHolder)
		local ClickBtn = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Text = ""
		}, DropdownFrame)
		local isOpen = false
		ClickBtn.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			OptionHolder.Visible = isOpen
			if isOpen then
				OptionHolder.Size = UDim2.new(1, 0, 0, #optionsList * 17)
				DropdownFrame.Size = UDim2.new(1, 0, 0, 32 + (#optionsList * 17) + 4)
			else
				DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
			end
		end)
		for _, optName in ipairs(optionsList) do
			local OptionLabel = Create("TextLabel", {
				BorderSizePixel = 0, TextSize = 14,
				BackgroundColor3 = Color3.fromRGB(74, 139, 226),
				FontFace = FONT,
				TextColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.7,
				Size = UDim2.new(1, 0, 0, 16), Text = optName
			}, OptionHolder)
			local OptBtn = Create("TextButton", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
			}, OptionLabel)
			OptBtn.MouseEnter:Connect(function() OptionLabel.BackgroundTransparency = 0.2 end)
			OptBtn.MouseLeave:Connect(function() OptionLabel.BackgroundTransparency = 0.7 end)
			OptBtn.MouseButton1Click:Connect(function()
				DropTitle.Text = dropText .. ": " .. optName
				isOpen = false
				OptionHolder.Visible = false
				DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
				if callback then callback(optName) end
			end)
		end
		return DropdownFrame
	end

	local function makeInput(parent, inputText, default, placeholder, callback)
		local InputFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, InputFrame)
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(0.4, 0, 1, 0), Text = inputText
		}, InputFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }, InputFrame)
		local TextBox = Create("TextBox", {
			BorderSizePixel = 0, TextSize = 14,
			BackgroundColor3 = Color3.fromRGB(45, 70, 105),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham, PlaceholderText = placeholder or "",
			Text = default or "",
			Size = UDim2.new(0.55, -10, 0, 22),
			Position = UDim2.new(0.4, 0, 0, 5),
			ClearTextOnFocus = false
		}, InputFrame)
		Create("UICorner", { CornerRadius = UDim.new(0, 3) }, TextBox)
		TextBox.FocusLost:Connect(function()
			if callback then callback(TextBox.Text) end
		end)
		return InputFrame
	end

	-- === CollapsingHeader factory (returns a "container" with same API) ===
	local function makeCollapsingHeader(parent, headerName)
		headerName = headerName or "Section"

		-- Контейнер-обёртка, растёт по высоте
		local HeaderRoot = Create("Frame", {
			Name = headerName .. "CollapsingHeader",
			BackgroundTransparency = 1, BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, parent)
		Create("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}, HeaderRoot)

		-- Шапка (синяя полоса, как в конвертере)
		local HeaderRow = Create("Frame", {
			Name = "HeaderRow", BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, HeaderRoot)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, HeaderRow)

		local ShownLbl = Create("TextLabel", {
			Name = "ShownButton", BackgroundTransparency = 1,
			Size = UDim2.new(0.064, 0, 0.96, 0),
			Position = UDim2.new(0, 6, 0, 0),
			FontFace = FONT, Text = "▼",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			Parent = HeaderRow
		})

		local TitleLbl = Create("TextLabel", {
			Name = "Title", BackgroundTransparency = 1,
			Size = UDim2.new(1, -30, 1, 0),
			Position = UDim2.new(0, 30, 0, 0),
			FontFace = FONT, Text = headerName,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			Parent = HeaderRow
		})

		local ClickArea = Create("TextButton", {
			Name = "ClickArea", BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0), Text = "",
			Parent = HeaderRow
		})

		-- Контейнер для элементов
		local GroupHolder = Create("Frame", {
			Name = "GroupHolder", BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ClipsDescendants = false
		}, HeaderRoot)
		Create("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, GroupHolder)

		local isOpen = true
		ClickArea.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			GroupHolder.Visible = isOpen
			ShownLbl.Text = isOpen and "▼" or "▶"
		end)

		local CH = {}
		function CH:AddToggle(id, opts) return makeToggle(GroupHolder, opts.Text, opts.Default, opts.Callback) end
		function CH:AddSlider(id, opts) return makeSlider(GroupHolder, opts.Text, opts.Min, opts.Max, opts.Default, opts.Callback) end
		function CH:AddButton(opts) return makeButton(GroupHolder, opts.Text, opts.Func) end
		function CH:AddLabel(text) return makeLabel(GroupHolder, text) end
		function CH:AddInfo(text) return makeInfo(GroupHolder, text) end
		function CH:AddWarning(text) return makeWarning(GroupHolder, text) end
		function CH:AddDropdown(id, opts) return makeDropdown(GroupHolder, opts.Text, opts.Values, opts.Callback) end
		function CH:AddInput(id, opts) return makeInput(GroupHolder, opts.Text, opts.Default, opts.Placeholder, opts.Callback) end
		function CH:SetOpen(state)
			isOpen = not not state
			GroupHolder.Visible = isOpen
			ShownLbl.Text = isOpen and "▼" or "▶"
		end
		function CH:SetTitle(newTitle) TitleLbl.Text = newTitle end
		return CH
	end

	-- === Tab ===
	function Window:CreateTab(tabName)
		local Tab = {}

		-- Кнопка-таб в горизонтальной навигации
		local TabButton = Create("TextButton", {
			Name = tabName .. "Button",
			BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 90, 1, 0),
			AutoButtonColor = false,
			FontFace = FONT,
			Text = tabName,
			TextColor3 = Color3.fromRGB(169, 169, 169),
			TextSize = 14
		}, ButtonHolder)
		Create("UICorner", { CornerRadius = UDim.new(0, 2) }, TabButton)

		-- Контент-страница
		local TabContent = Create("ScrollingFrame", {
			Name = tabName .. "Tab",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Color3.fromRGB(55, 87, 129),
			Visible = false,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = ContentContainer
		}, ContentContainer)
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4)
		}, TabContent)
		Create("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, TabContent)

		TabButton.MouseButton1Click:Connect(function()
			for _, otherTab in pairs(Window.Tabs) do
				otherTab.Button.TextColor3 = Color3.fromRGB(169, 169, 169)
				otherTab.Button.BackgroundTransparency = 1
				otherTab.Content.Visible = false
			end
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabButton.BackgroundTransparency = 0.8
			TabContent.Visible = true
			Window.ActiveTab = Tab
		end)

		if not Window.ActiveTab then
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabButton.BackgroundTransparency = 0.8
			TabContent.Visible = true
			Window.ActiveTab = Tab
		end

		Tab.Button = TabButton
		Tab.Content = TabContent
		Window.Tabs[tabName] = Tab

		-- Прямые методы (одна колонка)
		function Tab:CreateButton(btnText, callback) return makeButton(TabContent, btnText, callback) end
		function Tab:CreateLabel(text) return makeLabel(TabContent, text) end
		function Tab:CreateInfo(text) return makeInfo(TabContent, text) end
		function Tab:CreateWarning(text) return makeWarning(TabContent, text) end
		function Tab:CreateToggle(text, default, cb) return makeToggle(TabContent, text, default, cb) end
		function Tab:CreateSlider(text, min, max, default, cb) return makeSlider(TabContent, text, min, max, default, cb) end
		function Tab:CreateDropdown(text, values, cb) return makeDropdown(TabContent, text, values, cb) end
		function Tab:CreateInput(text, default, placeholder, cb) return makeInput(TabContent, text, default, placeholder, cb) end
		function Tab:CreateCollapsingHeader(name) return makeCollapsingHeader(TabContent, name) end

		-- === Groupbox-совместимость (одна колонка, как в конвертере) ===
		local groupOrder = 0
		local function makeGroupbox(name)
			groupOrder = groupOrder + 1
			local GroupFrame = Create("Frame", {
				Name = name .. "Group", BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = groupOrder
			}, TabContent)
			Create("UIListLayout", {
				Padding = UDim.new(0, 1),
				SortOrder = Enum.SortOrder.LayoutOrder
			}, GroupFrame)

			if name and name ~= "" then
				Create("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
					Text = "  " .. name, TextColor3 = Color3.fromRGB(150, 180, 220),
					Font = Enum.Font.GothamBold, TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = GroupFrame
				})
			end

			local Inner = Create("Frame", {
				Name = "Inner", BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = GroupFrame
			})
			Create("UIListLayout", { Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder }, Inner)

			local GB = {}
			function GB:AddToggle(id, opts) return makeToggle(Inner, opts.Text, opts.Default, opts.Callback) end
			function GB:AddSlider(id, opts) return makeSlider(Inner, opts.Text, opts.Min, opts.Max, opts.Default, opts.Callback) end
			function GB:AddButton(opts) return makeButton(Inner, opts.Text, opts.Func) end
			function GB:AddLabel(text) return makeLabel(Inner, text) end
			function GB:AddInfo(text) return makeInfo(Inner, text) end
			function GB:AddWarning(text) return makeWarning(Inner, text) end
			function GB:AddDropdown(id, opts) return makeDropdown(Inner, opts.Text, opts.Values, opts.Callback) end
			function GB:AddInput(id, opts) return makeInput(Inner, opts.Text, opts.Default, opts.Placeholder, opts.Callback) end
			return GB
		end

		-- AddLeft/AddRight в новой раскладке = один и тот же столбец
		function Tab:AddLeftGroupbox(name) return makeGroupbox(name) end
		function Tab:AddRightGroupbox(name) return makeGroupbox(name) end

		return Tab
	end

	function Window:AddTab(name) return self:CreateTab(name) end

	return Window
end

return Library
