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

local FONT = Font.new("rbxasset://fonts/families/Ubuntu.json")

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

	local ScreenGui = Create("ScreenGui", {
		Name = "MyLib",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui)

	local Main = Create("Frame", {
		Name = "Main", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(36, 38, 37),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = options.size,
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}, ScreenGui)
	Create("UICorner", { CornerRadius = UDim.new(0, 4) }, Main)

	local TopBar = Create("Frame", {
		Name = "TopBar", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(1, 0, 0, 28)
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 4) }, TopBar)
	Create("Frame", {
		Name = "Extension", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 0, 14)
	}, TopBar)

	local Title = Create("TextLabel", {
		Name = "Title", BorderSizePixel = 0, TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		FontFace = FONT,
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
		Text = "X", Position = UDim2.new(0.944, 0, 0, 0),
		FontFace = FONT
	}, TopBar)

	local ContentContainer = Create("Frame", {
		Name = "ContentContainer", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(36, 38, 37),
		Size = UDim2.new(0.726, 0, 0.86667, 28),
		Position = UDim2.new(0.26, 0, 0.06667, 0),
		BackgroundTransparency = 0.8
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 4) }, ContentContainer)

	local Navigation = Create("Frame", {
		Name = "Navigation", BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(55, 87, 129),
		Size = UDim2.new(0.222, 0, 0.86667, 28),
		Position = UDim2.new(0.022, 0, 0.06667, 0),
		BackgroundTransparency = 0.8
	}, Main)
	Create("UICorner", { CornerRadius = UDim.new(0, 4) }, Navigation)

	local ButtonHolder = Create("Frame", {
		Name = "ButtonHolder", BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, Navigation)
	Create("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }, ButtonHolder)
	Create("UIListLayout", { Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder }, ButtonHolder)

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
			BackgroundColor3 = Color3.fromRGB(25, 25, 30),
			BackgroundTransparency = 0.1, BorderSizePixel = 0,
			LayoutOrder = -notifOrder
		}, NotifHolder)
		Create("UICorner", { CornerRadius = UDim.new(0, 6) }, Frame)
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

	local function makeButton(parent, btnText, callback)
		local ButtonFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		local BtnTitle = Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = btnText
		}, ButtonFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, BtnTitle)
		local ClickBtn = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
		}, ButtonFrame)
		ClickBtn.MouseButton1Click:Connect(function() if callback then callback() end end)
		return ButtonFrame
	end

	local function makeLabel(parent, text, color)
		local LabelFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 26)
		}, parent)
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = color or Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = tostring(text)
		}, LabelFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, LabelFrame)
		return LabelFrame
	end

	local function makeInfo(parent, text) return makeLabel(parent, text, Color3.fromRGB(255, 255, 16)) end
	local function makeWarning(parent, text) return makeLabel(parent, text, Color3.fromRGB(255, 60, 60)) end

	local function makeToggle(parent, toggleText, default, callback)
		local ToggleFrame = Create("Frame", {
			BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(55, 87, 129),
			Size = UDim2.new(1, 0, 0, 32)
		}, parent)
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, -40, 1, 0), Text = toggleText
		}, ToggleFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, ToggleFrame)

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
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, -70, 1, 0), Text = sliderText
		}, SliderFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, SliderFrame)
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
		local DropTitle = Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = dropText
		}, DropdownFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, DropTitle)
		local OptionHolder = Create("Frame", {
			Visible = false, BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 26)
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
		Create("TextLabel", {
			BorderSizePixel = 0, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1, Size = UDim2.new(0.4, 0, 1, 0), Text = inputText
		}, InputFrame)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, InputFrame)
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

	function Window:CreateTab(tabName)
		local Tab = {}

		local TabButton = Create("TextLabel", {
			Name = tabName .. "Button", BorderSizePixel = 0, TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = FONT, TextColor3 = Color3.fromRGB(169, 169, 169),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 30),
			Text = tabName
		}, ButtonHolder)
		Create("UIPadding", { PaddingLeft = UDim.new(0, 26) }, TabButton)

		local TabContent = Create("ScrollingFrame", {
			Name = tabName .. "Tab", BorderSizePixel = 0,
			BackgroundTransparency = 1, Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			ScrollBarThickness = 0, Visible = false,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarImageColor3 = Color3.fromRGB(55, 87, 129)
		}, ContentContainer)
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)
		}, TabContent)

		TabButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				for _, otherTab in pairs(Window.Tabs) do
					otherTab.Button.TextColor3 = Color3.fromRGB(169, 169, 169)
					otherTab.Button.BackgroundTransparency = 1
					otherTab.Content.Visible = false
				end
				TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TabButton.BackgroundTransparency = 0.9
				TabContent.Visible = true
				Window.ActiveTab = Tab
			end
		end)

		if not Window.ActiveTab then
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabButton.BackgroundTransparency = 0.9
			TabContent.Visible = true
			Window.ActiveTab = Tab
		end

		Tab.Button = TabButton
		Tab.Content = TabContent
		Window.Tabs[tabName] = Tab

		function Tab:CreateButton(btnText, callback) return makeButton(TabContent, btnText, callback) end
		function Tab:CreateLabel(text) return makeLabel(TabContent, text) end
		function Tab:CreateInfo(text) return makeInfo(TabContent, text) end
		function Tab:CreateWarning(text) return makeWarning(TabContent, text) end
		function Tab:CreateToggle(text, default, cb) return makeToggle(TabContent, text, default, cb) end
		function Tab:CreateSlider(text, min, max, default, cb) return makeSlider(TabContent, text, min, max, default, cb) end
		function Tab:CreateDropdown(text, values, cb) return makeDropdown(TabContent, text, values, cb) end
		function Tab:CreateInput(text, default, placeholder, cb) return makeInput(TabContent, text, default, placeholder, cb) end

		local ColumnsFrame = Create("Frame", {
			Name = "Columns", BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
			Parent = TabContent
		})
		local LeftColumn = Create("Frame", {
			Name = "Left", BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -3, 0, 0), Position = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, Parent = ColumnsFrame
		})
		Create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, LeftColumn)

		local RightColumn = Create("Frame", {
			Name = "Right", BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -3, 0, 0), Position = UDim2.new(0.5, 3, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, Parent = ColumnsFrame
		})
		Create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, RightColumn)

		local columnOrder = 0
		local function makeGroupbox(name, side)
			columnOrder = columnOrder + 1
			local Column = (side == "left") and LeftColumn or RightColumn

			local GroupFrame = Create("Frame", {
				Name = name .. "Group", BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = columnOrder, Parent = Column
			})
			Create("TextLabel", {
				Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
				Text = "  " .. name, TextColor3 = Color3.fromRGB(150, 180, 220),
				Font = Enum.Font.GothamBold, TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left, Parent = GroupFrame
			})
			local Inner = Create("Frame", {
				Name = "Inner", BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 20),
				AutomaticSize = Enum.AutomaticSize.Y, Parent = GroupFrame
			})
			Create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, Inner)

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

		function Tab:AddLeftGroupbox(name) return makeGroupbox(name, "left") end
		function Tab:AddRightGroupbox(name) return makeGroupbox(name, "right") end

		return Tab
	end

	function Window:AddTab(name) return self:CreateTab(name) end

	return Window
end

return Library
