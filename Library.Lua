local players = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")

local Library = {}
Library.Tree = {}

local DefaultTheme = {
    SchemeColor  = Color3.fromRGB(55, 87, 129),
    Background   = Color3.fromRGB(36, 38, 37),
    Header       = Color3.fromRGB(28, 29, 34),
    TextColor    = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(45, 47, 52)
}

local ThemePresets = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background  = Color3.fromRGB(20, 20, 20),
        Header      = Color3.fromRGB(12, 12, 12),
        TextColor   = Color3.fromRGB(255, 255, 255),
        ElementColor= Color3.fromRGB(32, 32, 32)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background  = Color3.fromRGB(245, 245, 245),
        Header      = Color3.fromRGB(220, 220, 220),
        TextColor   = Color3.fromRGB(15, 15, 15),
        ElementColor= Color3.fromRGB(228, 228, 228)
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background  = Color3.fromRGB(10, 10, 10),
        Header      = Color3.fromRGB(5, 5, 5),
        TextColor   = Color3.fromRGB(255, 255, 255),
        ElementColor= Color3.fromRGB(22, 22, 22)
    },
    GrapeTheme = {
        SchemeColor = Color3.fromRGB(166, 71, 214),
        Background  = Color3.fromRGB(64, 50, 71),
        Header      = Color3.fromRGB(36, 28, 41),
        TextColor   = Color3.fromRGB(255, 255, 255),
        ElementColor= Color3.fromRGB(74, 58, 84)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background  = Color3.fromRGB(26, 32, 58),
        Header      = Color3.fromRGB(38, 45, 71),
        TextColor   = Color3.fromRGB(220, 220, 220),
        ElementColor= Color3.fromRGB(38, 45, 71)
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(26, 189, 158),
        Background  = Color3.fromRGB(44, 62, 82),
        Header      = Color3.fromRGB(57, 81, 105),
        TextColor   = Color3.fromRGB(255, 255, 255),
        ElementColor= Color3.fromRGB(52, 74, 95)
    }
}

local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

function Library:CreateLib(libName, themeInput)
    libName = libName or "MyLib"

    -- ==== Theme ====
    local Theme = {}
    for k, v in pairs(DefaultTheme) do Theme[k] = v end
    if type(themeInput) == "string" and ThemePresets[themeInput] then
        for k, v in pairs(ThemePresets[themeInput]) do Theme[k] = v end
    elseif type(themeInput) == "table" then
        for k, v in pairs(themeInput) do Theme[k] = v end
    end

    local ThemeRegistry = {}
    local function Reg(obj, prop, key)
        ThemeRegistry[obj] = { prop = prop, key = key }
    end
    local function ApplyTheme()
        for obj, data in pairs(ThemeRegistry) do
            if obj.Parent then
                obj[data.prop] = Theme[data.key]
            else
                ThemeRegistry[obj] = nil
            end
        end
    end

    -- ==== Window shell ====
    local Window = {}

    local ScreenGui = Create("ScreenGui", {
        Name = libName,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui)

    local Main = Create("Frame", {
        Name = "Main",
        BorderSizePixel = 0,
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 525, 0, 340),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, ScreenGui)
    Reg(Main, "BackgroundColor3", "Background")
    Create("UICorner", { CornerRadius = UDim.new(0, 4) }, Main)

    local TopBar = Create("Frame", {
        Name = "TopBar", BorderSizePixel = 0,
        BackgroundColor3 = Theme.Header,
        Size = UDim2.new(1, 0, 0, 30)
    }, Main)
    Reg(TopBar, "BackgroundColor3", "Header")
    Create("UICorner", { CornerRadius = UDim.new(0, 4) }, TopBar)
    Create("Frame", {
        BackgroundColor3 = Theme.Header, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -6), Size = UDim2.new(1, 0, 0, 6)
    }, TopBar)

    local Title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.02, 0, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.Gotham, Text = libName,
        TextColor3 = Theme.TextColor, TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)
    Reg(Title, "TextColor3", "TextColor")

    local CloseBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 22, 0, 22),
        Text = "✕", Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextColor, TextSize = 14
    }, TopBar)
    Reg(CloseBtn, "TextColor3", "TextColor")
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

    local Navigation = Create("Frame", {
        Name = "Navigation", BorderSizePixel = 0,
        BackgroundColor3 = Theme.Header,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 149, 1, -30)
    }, Main)
    Reg(Navigation, "BackgroundColor3", "Header")

    local TabHolder = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 6, 0, 6),
        Size = UDim2.new(1, -12, 1, -12)
    }, Navigation)
    Create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, TabHolder)

    local Content = Create("Frame", {
        Name = "Content", BackgroundTransparency = 1,
        Position = UDim2.new(0, 149, 0, 30),
        Size = UDim2.new(1, -149, 1, -30)
    }, Main)

    -- Notifications
    local NotifHolder = Create("Frame", {
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
        local f = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            LayoutOrder = -notifOrder
        }, NotifHolder)
        Create("UICorner", { CornerRadius = UDim.new(0, 6) }, f)
        Create("UIStroke", { Color = Theme.SchemeColor, Thickness = 1 }, f)
        local lbl = Create("TextLabel", {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(text),
            TextColor3 = Theme.TextColor,
            Font = Enum.Font.Gotham, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        }, f)
        Reg(lbl, "TextColor3", "TextColor")
        task.delay(duration, function() if f.Parent then f:Destroy() end end)
    end

    function Window:ChangeColor(prop, color)
        Theme[prop] = color
        ApplyTheme()
    end

    function Window:Toggle()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    -- Dragging
    local dragging, dragInput, dragStart, startPos
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
    userInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle keybind for the window
    userInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then Window:Toggle() end
    end)

    -- ==== Tabs ====
    local Tabs = {}
    local ActiveTab = nil

    function Window:NewTab(tabName)
        tabName = tabName or "Tab"
        local Tab = {}

        local TabButton = Create("TextButton", {
            Name = tabName .. "Button",
            BackgroundColor3 = Theme.SchemeColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 28),
            AutoButtonColor = false,
            Font = Enum.Font.Gotham, Text = tabName,
            TextColor3 = Theme.TextColor, TextSize = 14
        }, TabHolder)
        Reg(TabButton, "TextColor3", "TextColor")
        Create("UICorner", { CornerRadius = UDim.new(0, 5) }, TabButton)

        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.SchemeColor,
            Visible = false
        }, Content)
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)
        }, TabPage)
        Create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, TabPage)

        TabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(Tabs) do
                otherTab.Button.BackgroundTransparency = 1
                otherTab.Page.Visible = false
            end
            TabButton.BackgroundTransparency = 0
            TabPage.Visible = true
            ActiveTab = Tab
        end)

        if not ActiveTab then
            ActiveTab = Tab
            TabButton.BackgroundTransparency = 0
            TabPage.Visible = true
        end

        Tab.Button = TabButton
        Tab.Page = TabPage
        Tabs[tabName] = Tab

        -- ==== Sections ====
        function Tab:NewSection(sectionName)
            sectionName = sectionName or "Section"
            local Section = {}

            local SectionFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, TabPage)

            local SectionHead = Create("Frame", {
                BackgroundColor3 = Theme.SchemeColor,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30)
            }, SectionFrame)
            Reg(SectionHead, "BackgroundColor3", "SchemeColor")
            Create("UICorner", { CornerRadius = UDim.new(0, 4) }, SectionHead)

            local SectionTitle = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.02, 0, 0, 0),
                Size = UDim2.new(0.96, 0, 1, 0),
                Font = Enum.Font.Gotham, Text = sectionName,
                TextColor3 = Theme.TextColor, TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, SectionHead)
            Reg(SectionTitle, "TextColor3", "TextColor")

            local Inner = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 34),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, SectionFrame)
            Create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, Inner)

            local function baseRow(height)
                local row = Create("Frame", {
                    BackgroundColor3 = Theme.ElementColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, height or 32)
                }, Inner)
                Reg(row, "BackgroundColor3", "ElementColor")
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }, row)
                return row
            end

            local function baseLabel(parent, text)
                local lbl = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.03, 0, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = text,
                    TextColor3 = Theme.TextColor, TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, parent)
                Reg(lbl, "TextColor3", "TextColor")
                return lbl
            end

            function Section:NewButton(text, callback)
                text = text or "Button"
                callback = callback or function() end
                local row = baseRow(32)
                local lbl = baseLabel(row, text)

                local click = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                }, row)
                click.MouseButton1Click:Connect(function() callback() end)

                local obj = {}
                function obj:SetText(t) lbl.Text = t end
                return obj
            end

            function Section:NewLabel(text)
                text = text or "Label"
                local row = baseRow(28)
                local lbl = baseLabel(row, "  " .. text)
                local obj = {}
                function obj:SetText(t) lbl.Text = "  " .. t end
                return obj
            end

            function Section:NewToggle(text, default, callback)
                text = text or "Toggle"
                default = default or false
                callback = callback or function() end

                local row = baseRow(32)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(1, -50, 1, 0)

                local Check = Create("Frame", {
                    BackgroundColor3 = default and Theme.SchemeColor or Color3.fromRGB(80, 80, 80),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20)
                }, row)
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }, Check)

                local click = Create("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
                }, row)
                local state = default
                click.MouseButton1Click:Connect(function()
                    state = not state
                    Check.BackgroundColor3 = state and Theme.SchemeColor or Color3.fromRGB(80, 80, 80)
                    callback(state)
                end)

                local obj = {}
                function obj:Set(v)
                    state = not not v
                    Check.BackgroundColor3 = state and Theme.SchemeColor or Color3.fromRGB(80, 80, 80)
                    callback(state)
                end
                function obj:Get() return state end
                return obj
            end

            function Section:NewSlider(text, min, max, default, callback)
                text = text or "Slider"
                min, max = min or 0, max or 100
                default = default or min
                callback = callback or function() end

                local row = baseRow(32)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(0.55, 0, 1, 0)

                local val = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 50, 1, 0),
                    Font = Enum.Font.GothamSemibold, Text = tostring(default),
                    TextColor3 = Theme.TextColor, TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                }, row)
                Reg(val, "TextColor3", "TextColor")

                local Back = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -4),
                    Size = UDim2.new(1, -20, 0, 4)
                }, row)
                local Fill = Create("Frame", {
                    BackgroundColor3 = Theme.SchemeColor,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                }, Back)

                local dragging = false
                local function update(input)
                    local mx = input.Position.X
                    local sx = Back.AbsolutePosition.X
                    local sw = Back.AbsoluteSize.X
                    local pct = math.clamp((mx - sx) / sw, 0, 1)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    local value = math.floor(min + (max - min) * pct + 0.5)
                    val.Text = tostring(value)
                    callback(value)
                end
                Back.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true; update(input)
                    end
                end)
                userInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
                userInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                local obj = {}
                function obj:Set(v)
                    v = math.clamp(v, min, max)
                    local pct = (v - min) / (max - min)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    val.Text = tostring(math.floor(v))
                    callback(v)
                end
                return obj
            end

            function Section:NewDropdown(text, list, callback)
                text = text or "Dropdown"
                list = list or {}
                callback = callback or function() end

                local DropFrame = Create("Frame", {
                    BackgroundColor3 = Theme.ElementColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    ClipsDescendants = true
                }, Inner)
                Reg(DropFrame, "BackgroundColor3", "ElementColor")
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }, DropFrame)

                local lbl = baseLabel(DropFrame, text)
                lbl.Size = UDim2.new(1, -20, 0, 32)

                local ListHolder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 32),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, DropFrame)
                Create("UIListLayout", { Padding = UDim.new(0, 1) }, ListHolder)

                local open = false
                local click = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = ""
                }, DropFrame)
                click.MouseButton1Click:Connect(function()
                    open = not open
                    DropFrame.Size = open
                        and UDim2.new(1, 0, 0, 32 + #list * 20 + 4)
                        or UDim2.new(1, 0, 0, 32)
                end)

                for _, opt in ipairs(list) do
                    local optBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.SchemeColor,
                        BackgroundTransparency = 0.7,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 18),
                        Text = "  " .. tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, ListHolder)
                    optBtn.MouseEnter:Connect(function() optBtn.BackgroundTransparency = 0.2 end)
                    optBtn.MouseLeave:Connect(function() optBtn.BackgroundTransparency = 0.7 end)
                    optBtn.MouseButton1Click:Connect(function()
                        lbl.Text = text .. ": " .. tostring(opt)
                        open = false
                        DropFrame.Size = UDim2.new(1, 0, 0, 32)
                        callback(opt)
                    end)
                end
            end

            function Section:NewInput(text, default, placeholder, callback)
                text = text or "Input"
                default = default or ""
                placeholder = placeholder or "Type here..."
                callback = callback or function() end

                local row = baseRow(32)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(0.4, 0, 1, 0)

                local box = Create("TextBox", {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.4, 0, 0, 5),
                    Size = UDim2.new(0.55, -10, 0, 22),
                    Font = Enum.Font.Gotham, TextSize = 13,
                    TextColor3 = Theme.TextColor,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Color3.fromRGB(140, 140, 140),
                    Text = default,
                    ClearTextOnFocus = false
                }, row)
                Reg(box, "TextColor3", "TextColor")
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }, box)
                box.FocusLost:Connect(function() callback(box.Text) end)
            end

            function Section:NewKeybind(text, default, callback)
                text = text or "Keybind"
                default = default or Enum.KeyCode.E
                callback = callback or function() end

                local row = baseRow(32)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(0.55, 0, 1, 0)

                local keyLbl = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 90, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = default.Name,
                    TextColor3 = Theme.SchemeColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                }, row)

                local click = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                }, row)

                local current = default
                click.MouseButton1Click:Connect(function()
                    keyLbl.Text = ". . ."
                    local input = userInputService.InputBegan:Wait()
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        current = input.KeyCode
                        keyLbl.Text = current.Name
                    end
                end)

                userInputService.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if input.KeyCode == current then callback() end
                end)

                local obj = {}
                function obj:Set(k)
                    current = k
                    keyLbl.Text = k.Name
                end
                return obj
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
