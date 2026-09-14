local players = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")

local Library = {}

local Defaults = {
    SchemeColor  = Color3.fromRGB(55, 87, 129),   -- синий топбар/акценты
    Background   = Color3.fromRGB(36, 38, 37),    -- фон окна
    Panel        = Color3.fromRGB(45, 47, 52),    -- панель навигации / контент
    TextColor    = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(50, 52, 57),    -- фон элементов
    ElementHover = Color3.fromRGB(60, 62, 68)
}

local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

function Library:CreateLib(libName, customTheme)
    libName = libName or "ImGui"

    -- ==== Тема ====
    local Theme = {}
    for k, v in pairs(Defaults) do Theme[k] = v end
    if type(customTheme) == "table" then
        for k, v in pairs(customTheme) do Theme[k] = v end
    end

    local Registry = {}
    local function Reg(obj, prop, key)
        Registry[obj] = { prop = prop, key = key }
    end
    local function ApplyTheme()
        for obj, data in pairs(Registry) do
            if obj.Parent then
                obj[data.prop] = Theme[data.key]
            else
                Registry[obj] = nil
            end
        end
    end

    local Window = {}

    -- ==== ScreenGui ====
    local ScreenGui = Create("ScreenGui", {
        Name = "ImGui_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui)

    -- ==== Main (окно) ====
    local Main = Create("Frame", {
        Name = "Main",
        BorderSizePixel = 0,
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 560, 0, 340),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, ScreenGui)
    Reg(Main, "BackgroundColor3", "Background")
    Create("UICorner", { CornerRadius = UDim.new(0, 4) }, Main)

    -- ==== TopBar (синий, как в ImGui) ====
    local TopBar = Create("Frame", {
        Name = "TopBar", BorderSizePixel = 0,
        BackgroundColor3 = Theme.SchemeColor,
        Size = UDim2.new(1, 0, 0, 28)
    }, Main)
    Reg(TopBar, "BackgroundColor3", "SchemeColor")
    Create("UICorner", { CornerRadius = UDim.new(0, 4) }, TopBar)
    Create("Frame", {
        BackgroundColor3 = Theme.SchemeColor, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -6), Size = UDim2.new(1, 0, 0, 6)
    }, TopBar)

    local Title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(0.8, 0, 1, 0),
        Font = Enum.Font.Gotham, Text = libName,
        TextColor3 = Theme.TextColor, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)
    Reg(Title, "TextColor3", "TextColor")

    local CloseBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.Gotham, Text = "X",
        TextColor3 = Theme.TextColor, TextSize = 13
    }, TopBar)
    Reg(CloseBtn, "TextColor3", "TextColor")
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

    -- ==== Navigation (левая колонка) ====
    local Navigation = Create("Frame", {
        Name = "Navigation", BorderSizePixel = 0,
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, 12, 0, 40),
        Size = UDim2.new(0, 140, 1, -52)
    }, Main)
    Reg(Navigation, "BackgroundColor3", "Background")
    Create("UICorner", { CornerRadius = UDim.new(0, 4) }, Navigation)

    local TabHolder = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 6),
        Size = UDim2.new(1, 0, 1, -12)
    }, Navigation)
    Create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, TabHolder)

    -- ==== Content (правая колонка) ====
    local Content = Create("Frame", {
        Name = "Content", BackgroundTransparency = 1,
        Position = UDim2.new(0, 164, 0, 40),
        Size = UDim2.new(1, -176, 1, -52)
    }, Main)

    -- ==== Notify ====
    local NotifHolder = Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -12, 1, -12),
        Size = UDim2.new(0, 280, 1, -24),
        BackgroundTransparency = 1
    }, ScreenGui)
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, NotifHolder)
    local notifCounter = 0

    function Window:Notify(text, duration)
        duration = duration or 3
        notifCounter = notifCounter + 1
        local f = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 44),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            LayoutOrder = -notifCounter
        }, NotifHolder)
        Reg(f, "BackgroundColor3", "Background")
        Create("UICorner", { CornerRadius = UDim.new(0, 4) }, f)
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
        if Theme[prop] ~= nil then
            Theme[prop] = color
            ApplyTheme()
        end
    end

    function Window:Toggle()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    -- ==== Drag ====
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

    -- RightShift toggle
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
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 28),
            AutoButtonColor = false,
            Font = Enum.Font.Gotham, Text = tabName,
            TextColor3 = Theme.TextColor, TextSize = 13
        }, TabHolder)
        Reg(TabButton, "TextColor3", "TextColor")
        Create("UICorner", { CornerRadius = UDim.new(0, 3) }, TabButton)

        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.SchemeColor,
            Visible = false
        }, Content)
        Create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, TabPage)

        TabButton.MouseButton1Click:Connect(function()
            for _, other in pairs(Tabs) do
                other.Button.BackgroundTransparency = 1
                other.Page.Visible = false
            end
            TabButton.BackgroundTransparency = 0.2
            TabPage.Visible = true
            ActiveTab = Tab
        end)

        if not ActiveTab then
            ActiveTab = Tab
            TabButton.BackgroundTransparency = 0.2
            TabPage.Visible = true
        end

        Tab.Button = TabButton
        Tab.Page = TabPage
        Tabs[tabName] = Tab

        -- ==== Sections ====
        function Tab:NewSection(sectionName)
            sectionName = sectionName or "Section"
            local Section = {}

            -- Просто подпись секции (тонкая строка, как в ImGui)
            local SectionLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Font = Enum.Font.Gotham, Text = sectionName,
                TextColor3 = Theme.SchemeColor, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            }, TabPage)

            local Inner = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, TabPage)
            Create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, Inner)

            -- Универсальный фон элемента (прямоугольник, без углов — как ImGui)
            local function baseRow(height)
                local row = Create("Frame", {
                    BackgroundColor3 = Theme.ElementColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, height or 30)
                }, Inner)
                Reg(row, "BackgroundColor3", "ElementColor")
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }, row)
                return row
            end

            local function baseLabel(parent, text)
                local lbl = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.Gotham, Text = text,
                    TextColor3 = Theme.TextColor, TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, parent)
                Reg(lbl, "TextColor3", "TextColor")
                return lbl
            end

            function Section:NewLabel(text)
                text = text or "Label"
                local row = baseRow(26)
                baseLabel(row, "  " .. text)
            end

            function Section:NewButton(text, callback)
                text = text or "Button"
                callback = callback or function() end
                local row = baseRow(30)
                local lbl = baseLabel(row, text)

                local click = Create("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
                }, row)
                click.MouseEnter:Connect(function()
                    row.BackgroundColor3 = Theme.ElementHover
                end)
                click.MouseLeave:Connect(function()
                    row.BackgroundColor3 = Theme.ElementColor
                end)
                click.MouseButton1Click:Connect(function() callback() end)
            end

            function Section:NewToggle(text, default, callback)
                text = text or "Toggle"
                default = default or false
                callback = callback or function() end

                local row = baseRow(30)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(1, -50, 1, 0)

                -- Квадратик-чекбокс справа
                local Check = Create("Frame", {
                    BackgroundColor3 = default and Theme.SchemeColor or Color3.fromRGB(35, 37, 40),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }, row)
                Create("UICorner", { CornerRadius = UDim.new(0, 2) }, Check)

                local click = Create("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
                }, row)
                local state = default
                local function update()
                    Check.BackgroundColor3 = state and Theme.SchemeColor or Color3.fromRGB(35, 37, 40)
                end
                click.MouseEnter:Connect(function() row.BackgroundColor3 = Theme.ElementHover end)
                click.MouseLeave:Connect(function() row.BackgroundColor3 = Theme.ElementColor end)
                click.MouseButton1Click:Connect(function()
                    state = not state
                    update()
                    callback(state)
                end)

                return {
                    Set = function(_, v) state = not not v; update(); callback(state) end,
                    Get = function() return state end
                }
            end

            function Section:NewSlider(text, min, max, default, callback)
                text = text or "Slider"
                min, max = min or 0, max or 100
                default = default or min
                callback = callback or function() end

                local row = baseRow(30)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(0.6, 0, 1, 0)

                local val = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 50, 1, 0),
                    Font = Enum.Font.Gotham, Text = tostring(default),
                    TextColor3 = Theme.TextColor, TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                }, row)
                Reg(val, "TextColor3", "TextColor")

                local Back = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(25, 27, 30),
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -4),
                    Size = UDim2.new(1, -20, 0, 3),
                    BorderSizePixel = 0
                }, row)
                local Fill = Create("Frame", {
                    BackgroundColor3 = Theme.SchemeColor,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BorderSizePixel = 0
                }, Back)

                local dragging = false
                local function update(input)
                    local mx = input.Position.X
                    local sx = Back.AbsolutePosition.X
                    local sw = Back.AbsoluteSize.X
                    local pct = math.clamp((mx - sx) / sw, 0, 1)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    local v = math.floor(min + (max - min) * pct + 0.5)
                    val.Text = tostring(v)
                    callback(v)
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
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)

                return {
                    Set = function(_, v)
                        v = math.clamp(v, min, max)
                        Fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                        val.Text = tostring(math.floor(v))
                        callback(v)
                    end
                }
            end

            function Section:NewDropdown(text, list, callback)
                text = text or "Dropdown"
                list = list or {}
                callback = callback or function() end

                local DropFrame = Create("Frame", {
                    BackgroundColor3 = Theme.ElementColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 30),
                    ClipsDescendants = true
                }, Inner)
                Reg(DropFrame, "BackgroundColor3", "ElementColor")
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }, DropFrame)

                local lbl = baseLabel(DropFrame, text)
                lbl.Size = UDim2.new(1, -20, 0, 30)

                local ListHolder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, DropFrame)
                Create("UIListLayout", { Padding = UDim.new(0, 1) }, ListHolder)

                local open = false
                local click = Create("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Text = ""
                }, DropFrame)
                click.MouseButton1Click:Connect(function()
                    open = not open
                    DropFrame.Size = open
                        and UDim2.new(1, 0, 0, 30 + #list * 18 + 4)
                        or UDim2.new(1, 0, 0, 30)
                end)

                for _, opt in ipairs(list) do
                    local optBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.SchemeColor,
                        BackgroundTransparency = 0.6,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 17),
                        Text = "  " .. tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, ListHolder)
                    optBtn.MouseEnter:Connect(function() optBtn.BackgroundTransparency = 0.2 end)
                    optBtn.MouseLeave:Connect(function() optBtn.BackgroundTransparency = 0.6 end)
                    optBtn.MouseButton1Click:Connect(function()
                        lbl.Text = text .. ": " .. tostring(opt)
                        open = false
                        DropFrame.Size = UDim2.new(1, 0, 0, 30)
                        callback(opt)
                    end)
                end
            end

            function Section:NewInput(text, default, placeholder, callback)
                text = text or "Input"
                default = default or ""
                placeholder = placeholder or "Type here..."
                callback = callback or function() end

                local row = baseRow(30)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(0.4, 0, 1, 0)

                local box = Create("TextBox", {
                    BackgroundColor3 = Color3.fromRGB(25, 27, 30),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.4, 0, 0, 5),
                    Size = UDim2.new(0.58, -10, 0, 20),
                    Font = Enum.Font.Gotham, TextSize = 13,
                    TextColor3 = Theme.TextColor,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                    Text = default,
                    ClearTextOnFocus = false
                }, row)
                Reg(box, "TextColor3", "TextColor")
                Create("UICorner", { CornerRadius = UDim.new(0, 2) }, box)
                box.FocusLost:Connect(function() callback(box.Text) end)
            end

            function Section:NewKeybind(text, default, callback)
                text = text or "Keybind"
                default = default or Enum.KeyCode.E
                callback = callback or function() end

                local row = baseRow(30)
                local lbl = baseLabel(row, text)
                lbl.Size = UDim2.new(0.6, 0, 1, 0)

                local keyLbl = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 80, 1, 0),
                    Font = Enum.Font.Gotham, Text = default.Name,
                    TextColor3 = Theme.SchemeColor, TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                }, row)

                local click = Create("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
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
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
