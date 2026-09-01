--[[
    Super Ring Parts V6 - Bản tiếng Việt v3 (đã sửa lỗi)
    Tác giả gốc: lukas (Robloxlukasgames)
    Bản dịch & nâng cấp giao diện: Mavis
    Chức năng giữ nguyên 100%
]]

-- Bỏ qua mọi lỗi để script không bao giờ chết giữa chừng
local function safe(fn, ...) local ok, err = pcall(fn, ...); if not ok then warn("[RingParts]", err) end end
safe(function()
    -- Mã chính
end)

------------------------------------------------------------
-- DỊCH VỤ
------------------------------------------------------------
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService     = game:GetService("SoundService")
local StarterGui       = game:GetService("StarterGui")
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")
local LocalPlayer      = Players.LocalPlayer

------------------------------------------------------------
-- TIỆN ÍCH UI
------------------------------------------------------------
local function addCorner(parent, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = parent; return c
end
local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Transparency = 0.2
    s.Parent = parent
    return s
end
local function addPadding(p, t, b, l, r)
    local x = Instance.new("UIPadding")
    x.PaddingTop = UDim.new(0,t or 6); x.PaddingBottom = UDim.new(0,b or 6)
    x.PaddingLeft = UDim.new(0,l or 6); x.PaddingRight = UDim.new(0,r or 6)
    x.Parent = p; return x
end

------------------------------------------------------------
-- ÂM THANH
------------------------------------------------------------
local function playSound(id)
    safe(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(id)
        s.Volume = 0.45
        s.Parent = SoundService
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
    end)
end
playSound("2865227271")

------------------------------------------------------------
-- CẤU HÌNH
------------------------------------------------------------
local config = { radius = 50, height = 100, rotationSpeed = 10, attractionStrength = 1000 }

local function saveConfig()
    safe(function() writefile("SuperRingPartsConfig_VN_v3.txt", HttpService:JSONEncode(config)) end)
end
local function loadConfig()
    safe(function()
        if isfile and isfile("SuperRingPartsConfig_VN_v3.txt") then
            config = HttpService:JSONDecode(readfile("SuperRingPartsConfig_VN_v3.txt"))
        end
    end)
end
loadConfig()

------------------------------------------------------------
-- TÊN NGƯỜI DÙNG + THÔNG BÁO CHÀO
------------------------------------------------------------
local displayName = LocalPlayer.DisplayName or LocalPlayer.Name
local userId      = LocalPlayer.UserId
local avatarImg   = ""
safe(function()
    avatarImg = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
end)

safe(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Xin chào, " .. displayName .. "!",
        Text  = "Chúc bạn dùng script vui vẻ 🎉",
        Icon  = avatarImg, Duration = 5,
    })
    task.wait(0.2)
    StarterGui:SetCore("SendNotification", {
        Title = "MẸO",
        Text  = "Bấm vào ô nhập số bên dưới mỗi mục để chỉnh nhanh",
        Icon  = avatarImg, Duration = 5,
    })
    task.wait(0.2)
    StarterGui:SetCore("SendNotification", {
        Title = "Credit",
        Text  = "Tìm trên ScriptBlox nhé!",
        Icon  = avatarImg, Duration = 5,
    })
end)

------------------------------------------------------------
-- SCREENGUI
------------------------------------------------------------
-- Nếu GUI cũ còn tồn tại thì xoá đi để tránh trùng
safe(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("SuperRingPartsGUI_VN_v3")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperRingPartsGUI_VN_v3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------
-- KHUNG CHÍNH
------------------------------------------------------------
local FULL_SIZE   = UDim2.new(0, 400, 0, 580)
local FULL_OFFSET = UDim2.new(0.5, -200, 0.5, -290)
local MINI_SIZE   = UDim2.new(0, 260, 0, 48)
local MINI_OFFSET = UDim2.new(0.5, -130, 0.5, -24)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = FULL_SIZE
MainFrame.Position = FULL_OFFSET
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 18)
addStroke(MainFrame, Color3.fromRGB(110, 130, 255), 1.5)

-- Gradient nền
do
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 24, 36)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(28, 22, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 22, 60)),
    })
    g.Rotation = 145
    g.Parent = MainFrame
end

-- Drop shadow
do
    local sh = Instance.new("ImageLabel")
    sh.Name = "Shadow"
    sh.BackgroundTransparency = 1
    sh.Image = "rbxassetid://6014261993"
    sh.ImageColor3 = Color3.fromRGB(0,0,0)
    sh.ImageTransparency = 0.4
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(49,49,450,450)
    sh.Size = UDim2.new(1, 30, 1, 30)
    sh.Position = UDim2.new(0, -15, 0, -15)
    sh.ZIndex = -1
    sh.Parent = ScreenGui
end

------------------------------------------------------------
-- THANH TIÊU ĐỀ
------------------------------------------------------------
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 56)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 30, 44)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
addCorner(TitleBar, 18)

-- Che phần dưới TitleBar để chỉ bo 2 góc trên
local TitleCover = Instance.new("Frame")
TitleCover.Size = UDim2.new(1, 0, 0, 24)
TitleCover.Position = UDim2.new(0, 0, 1, -24)
TitleCover.BackgroundColor3 = TitleBar.BackgroundColor3
TitleCover.BorderSizePixel = 0
TitleCover.Parent = TitleBar

do
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 38, 58)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 45, 95)),
    })
    g.Rotation = 90
    g.Parent = TitleBar
end

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.Size = UDim2.new(0, 36, 0, 36)
Avatar.Position = UDim2.new(0, 10, 0, 10)
Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Avatar.Image = avatarImg
Avatar.Parent = TitleBar
addCorner(Avatar, 18)
addStroke(Avatar, Color3.fromRGB(110, 130, 255), 1.5)

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -160, 1, 0)
Title.Position = UDim2.new(0, 56, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎 " .. displayName .. "  •  Ring Parts V6"
Title.TextColor3 = Color3.fromRGB(235, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTruncate = Enum.TextTruncate.AtEnd
Title.Parent = TitleBar

-- Nút thu nhỏ
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
MinimizeButton.Position = UDim2.new(1, -80, 0, 12)
MinimizeButton.Text = "—"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 195, 60)
MinimizeButton.TextColor3 = Color3.fromRGB(20, 20, 20)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.AutoButtonColor = true
MinimizeButton.Parent = TitleBar
addCorner(MinimizeButton, 10)

-- Nút đóng
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -42, 0, 12)
CloseButton.Text = "✕"
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = true
CloseButton.Parent = TitleBar
addCorner(CloseButton, 10)

-- Nút mở lại (khi thu nhỏ)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.AnchorPoint = Vector2.new(0.5, 0)
OpenButton.Size = UDim2.new(0, 140, 0, 36)
OpenButton.Position = UDim2.new(0.5, 0, 0, 6)
OpenButton.BackgroundColor3 = Color3.fromRGB(110, 130, 255)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 13
OpenButton.Text = "☰  Mở Menu"
OpenButton.AutoButtonColor = true
OpenButton.Visible = false
OpenButton.Parent = TitleBar
addCorner(OpenButton, 10)
addStroke(OpenButton, Color3.fromRGB(255,255,255), 1)

------------------------------------------------------------
-- VÙNG NỘI DUNG (ScrollingFrame)
------------------------------------------------------------
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -16, 1, -68)
Container.Position = UDim2.new(0, 8, 0, 62)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 5
Container.ScrollBarImageColor3 = Color3.fromRGB(110, 130, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ElasticBehavior = Enum.ElasticBehavior.Always
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

------------------------------------------------------------
-- NÚT BẬT/TẮT TORNADO
------------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleTornado"
ToggleButton.Size = UDim2.new(1, 0, 0, 56)
ToggleButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
ToggleButton.Text = "●  TORNADO : TẮT"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.LayoutOrder = 1
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = Container
addCorner(ToggleButton, 14)
addStroke(ToggleButton, Color3.fromRGB(255,255,255), 1.5)
do
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 50, 80)),
    })
    g.Rotation = 90
    g.Parent = ToggleButton
end

------------------------------------------------------------
-- Ô ĐIỀU CHỈNH
------------------------------------------------------------
local function createControl(name, labelText, defaultValue, color, layoutOrder, callback)
    local Group = Instance.new("Frame")
    Group.Name = name
    Group.Size = UDim2.new(1, 0, 0, 90)
    Group.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
    Group.LayoutOrder = layoutOrder
    Group.Parent = Container
    addCorner(Group, 12)
    addStroke(Group, color, 1.2)

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -16, 0, 22)
    Header.Position = UDim2.new(0, 12, 0, 8)
    Header.BackgroundTransparency = 1
    Header.Text = labelText
    Header.TextColor3 = color
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = Group

    local Display = Instance.new("TextLabel")
    Display.Name = "Display"
    Display.Size = UDim2.new(0.36, 0, 0, 36)
    Display.Position = UDim2.new(0.32, 0, 0, 30)
    Display.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    Display.Text = tostring(defaultValue)
    Display.TextColor3 = Color3.fromRGB(255, 255, 255)
    Display.Font = Enum.Font.GothamBold
    Display.TextSize = 16
    Display.Parent = Group
    addCorner(Display, 8)
    addStroke(Display, Color3.fromRGB(60, 60, 80), 1)

    local DecreaseButton = Instance.new("TextButton")
    DecreaseButton.Name = "Minus"
    DecreaseButton.Size = UDim2.new(0.28, 0, 0, 36)
    DecreaseButton.Position = UDim2.new(0, 0, 0, 30)
    DecreaseButton.Text = "−"
    DecreaseButton.BackgroundColor3 = Color3.fromRGB(45, 48, 65)
    DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecreaseButton.Font = Enum.Font.GothamBold
    DecreaseButton.TextSize = 22
    DecreaseButton.AutoButtonColor = true
    DecreaseButton.Parent = Group
    addCorner(DecreaseButton, 8)

    local IncreaseButton = Instance.new("TextButton")
    IncreaseButton.Name = "Plus"
    IncreaseButton.Size = UDim2.new(0.28, 0, 0, 36)
    IncreaseButton.Position = UDim2.new(0.72, 0, 0, 30)
    IncreaseButton.Text = "+"
    IncreaseButton.BackgroundColor3 = color
    IncreaseButton.TextColor3 = Color3.fromRGB(20, 20, 20)
    IncreaseButton.Font = Enum.Font.GothamBold
    IncreaseButton.TextSize = 22
    IncreaseButton.AutoButtonColor = true
    IncreaseButton.Parent = Group
    addCorner(IncreaseButton, 8)

    local TextBox = Instance.new("TextBox")
    TextBox.Name = "Input"
    TextBox.Size = UDim2.new(1, -24, 0, 18)
    TextBox.Position = UDim2.new(0, 12, 1, -22)
    TextBox.BackgroundTransparency = 1
    TextBox.PlaceholderText = "✎  Nhập số rồi Enter để đặt nhanh…"
    TextBox.Text = ""
    TextBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 160)
    TextBox.TextColor3 = Color3.fromRGB(220, 220, 230)
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 11
    TextBox.ClearTextOnFocus = true
    TextBox.Parent = Group

    local function setValue(v)
        v = math.clamp(tonumber(v) or defaultValue, 0, 10000)
        Display.Text = tostring(math.floor(v))
        callback(v)
        playSound("12221967")
        saveConfig()
    end

    DecreaseButton.MouseButton1Click:Connect(function() setValue((tonumber(Display.Text) or 0) - 10) end)
    IncreaseButton.MouseButton1Click:Connect(function() setValue((tonumber(Display.Text) or 0) + 10) end)
    TextBox.FocusLost:Connect(function(enter)
        if enter and TextBox.Text ~= "" then
            setValue(TextBox.Text)
            TextBox.Text = ""
        end
    end)
end

createControl("Radius",             "🔵 Bán kính vòng",         config.radius,             Color3.fromRGB(120, 220, 140), 2, function(v) config.radius             = v end)
createControl("Height",             "🟣 Chiều cao cột",         config.height,             Color3.fromRGB(220, 130, 230), 3, function(v) config.height             = v end)
createControl("RotationSpeed",      "🟢 Tốc độ xoay (°/s)",    config.rotationSpeed,      Color3.fromRGB(130, 230, 230), 4, function(v) config.rotationSpeed      = v end)
createControl("AttractionStrength", "🟠 Lực hút (mạnh → yếu)", config.attractionStrength, Color3.fromRGB(255, 150, 90),  5, function(v) config.attractionStrength = v end)

------------------------------------------------------------
-- TIỆN ÍCH BỔ SUNG
------------------------------------------------------------
local UtilHeader = Instance.new("TextLabel")
UtilHeader.Name = "UtilHeader"
UtilHeader.Size = UDim2.new(1, 0, 0, 22)
UtilHeader.BackgroundTransparency = 1
UtilHeader.Text = "— ⚙ Tiện ích bổ sung —"
UtilHeader.TextColor3 = Color3.fromRGB(160, 165, 200)
UtilHeader.Font = Enum.Font.GothamBold
UtilHeader.TextSize = 13
UtilHeader.LayoutOrder = 6
UtilHeader.Parent = Container

local UtilGrid = Instance.new("Frame")
UtilGrid.Name = "UtilGrid"
UtilGrid.Size = UDim2.new(1, 0, 0, 140)
UtilGrid.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
UtilGrid.LayoutOrder = 7
UtilGrid.Parent = Container
addCorner(UtilGrid, 12)
addStroke(UtilGrid, Color3.fromRGB(80, 90, 130), 1)
addPadding(UtilGrid, 10, 10, 10, 10)

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 150, 0, 38)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
GridLayout.FillDirectionMaxCells = 2
GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
GridLayout.Parent = UtilGrid

task.defer(function()
    local w = (UtilGrid.AbsoluteSize.X - 28) / 2
    if w > 0 then
        GridLayout.CellSize = UDim2.new(0, math.max(120, w), 0, 38)
    end
end)

local function makeUtil(name, label, color, callback)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = label
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = true
    b.Parent = UtilGrid
    addCorner(b, 10)
    b.MouseButton1Click:Connect(function()
        playSound("12221967")
        safe(callback)
    end)
    return b
end

-- Bay
makeUtil("Fly", "✈  Bay (Fly Gui)", Color3.fromRGB(80, 130, 255), function()
    safe(function() loadstring(game:HttpGet("https://pastebin.com/raw/YSL3xKYU"))() end)
end)

-- Không sát thương rơi
makeUtil("NoFall", "🛡  Không sát thương rơi", Color3.fromRGB(220, 80, 80), function()
    local heartbeat = RunService.Heartbeat
    local rstepped  = RunService.RenderStepped
    local zero      = Vector3.zero
    local function nofall(chr)
        local root = chr and chr:FindFirstChild("HumanoidRootPart")
        if not root then root = chr and chr:WaitForChild("HumanoidRootPart", 5) end
        if root then
            local con
            con = heartbeat:Connect(function()
                if not root.Parent then return con and con:Disconnect() end
                local old = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = zero
                rstepped:Wait()
                root.AssemblyLinearVelocity = old
            end)
        end
    end
    if LocalPlayer.Character then nofall(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(nofall)
end)

-- Xuyên tường
makeUtil("Noclip", "👻  Xuyên tường", Color3.fromRGB(50, 50, 70), function()
    local Clip = false
    local noclipConn
    noclipConn = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if Clip == false and char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
    -- Không tự tắt
end)

-- Nhảy vô hạn
makeUtil("InfJump", "⬆  Nhảy vô hạn", Color3.fromRGB(80, 200, 110), function()
    UserInputService.JumpRequest:Connect(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end)
end)

-- Infinite Yield
makeUtil("IY", "∞  Infinite Yield", Color3.fromRGB(80, 220, 220), function()
    safe(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
end)

-- Nameless Admin
makeUtil("Nameless", "👑  Nameless Admin", Color3.fromRGB(70, 60, 100), function()
    safe(function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Nameless-Admin-FE-11243"))() end)
end)

-- FPS Unlocker
makeUtil("FPS", "🚀  Mở khoá FPS", Color3.fromRGB(255, 170, 60), function()
    safe(function() loadstring(game:HttpGet("https://pastebin.com/raw/ySHJdZpb", true))() end)
end)

------------------------------------------------------------
-- CREDIT
------------------------------------------------------------
local CreditBar = Instance.new("TextLabel")
CreditBar.Size = UDim2.new(1, 0, 0, 24)
CreditBar.BackgroundTransparency = 1
CreditBar.Text = "🇻🇳 Bản tiếng Việt v3 • UI nâng cấp • Chức năng giữ nguyên"
CreditBar.TextColor3 = Color3.fromRGB(120, 130, 170)
CreditBar.Font = Enum.Font.Gotham
CreditBar.TextSize = 11
CreditBar.LayoutOrder = 8
CreditBar.Parent = Container

------------------------------------------------------------
-- KÉO THẢ MENU
------------------------------------------------------------
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

------------------------------------------------------------
-- THU NHỎ / MỞ RỘNG (mượt)
------------------------------------------------------------
local minimized = false
local function setMinimized(state)
    if state == minimized then return end
    minimized = state
    if minimized then
        Container.Visible = false
        MinimizeButton.Visible = false
        CloseButton.Visible = false
        Title.Visible = false
        Avatar.Visible = false
        OpenButton.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = MINI_SIZE,
            Position = MINI_OFFSET,
        }):Play()
    else
        OpenButton.Visible = false
        Container.Visible = true
        Title.Visible = true
        Avatar.Visible = true
        MinimizeButton.Visible = true
        CloseButton.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = FULL_SIZE,
            Position = FULL_OFFSET,
        }):Play()
    end
    playSound("12221967")
end

MinimizeButton.MouseButton1Click:Connect(function() setMinimized(true) end)
OpenButton.MouseButton1Click:Connect(function() setMinimized(false) end)

------------------------------------------------------------
-- ĐÓNG
------------------------------------------------------------
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
    }):Play()
    task.wait(0.27)
    safe(function() ScreenGui:Destroy() end)
end)

------------------------------------------------------------
-- LOGIC TORNADO (giữ nguyên 100% bản gốc)
------------------------------------------------------------
safe(function()
    local Folder = Instance.new("Folder", Workspace)
    local Part = Instance.new("Part", Folder)
    local Attachment1 = Instance.new("Attachment", Part)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1

    if not getgenv().Network then
        getgenv().Network = {
            BaseParts = {},
            Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424),
        }
        Network.RetainPart = function(p)
            if typeof(p) == "Instance" and p:IsA("BasePart") and p:IsDescendantOf(Workspace) then
                table.insert(Network.BaseParts, p)
                p.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
                p.CanCollide = false
            end
        end
        local function EnablePartControl()
            LocalPlayer.ReplicationFocus = Workspace
            RunService.Heartbeat:Connect(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                for _, p in pairs(Network.BaseParts) do
                    if p:IsDescendantOf(Workspace) then
                        p.Velocity = Network.Velocity
                    end
                end
            end)
        end
        EnablePartControl()
    end
end)

local ringPartsEnabled = false

safe(function()
    local parts = {}
    local function RetainPart(p)
        if p:IsA("BasePart") and not p.Anchored and p:IsDescendantOf(workspace) then
            if p.Parent == LocalPlayer.Character or p:IsDescendantOf(LocalPlayer.Character) then
                return false
            end
            p.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
            p.CanCollide = false
            return true
        end
        return false
    end
    local function addPart(p) if RetainPart(p) then if not table.find(parts, p) then table.insert(parts, p) end end end
    local function removePart(p) local i = table.find(parts, p); if i then table.remove(parts, i) end end
    for _, p in pairs(workspace:GetDescendants()) do addPart(p) end
    workspace.DescendantAdded:Connect(addPart)
    workspace.DescendantRemoving:Connect(removePart)

    RunService.Heartbeat:Connect(function()
        if not ringPartsEnabled then return end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tornadoCenter = hrp.Position
        for _, part in pairs(parts) do
            if part.Parent and not part.Anchored then
                local pos = part.Position
                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                local newAngle = angle + math.rad(config.rotationSpeed)
                local targetPos = Vector3.new(
                    tornadoCenter.X + math.cos(newAngle) * math.min(config.radius, distance),
                    tornadoCenter.Y + (config.height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / config.height)))),
                    tornadoCenter.Z + math.sin(newAngle) * math.min(config.radius, distance)
                )
                local dir = (targetPos - part.Position).unit
                part.Velocity = dir * config.attractionStrength
            end
        end
    end)
end)

ToggleButton.MouseButton1Click:Connect(function()
    ringPartsEnabled = not ringPartsEnabled
    if ringPartsEnabled then
        ToggleButton.Text = "●  TORNADO : BẬT"
        TweenService:Create(ToggleButton, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
    else
        ToggleButton.Text = "●  TORNADO : TẮT"
        TweenService:Create(ToggleButton, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(235, 70, 90)}):Play()
    end
    playSound("12221967")
end)

------------------------------------------------------------
-- HIỆU ỨNG MỞ (fade + scale)
------------------------------------------------------------
safe(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Container.Visible = false
    task.wait(0.15)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = FULL_SIZE,
        BackgroundTransparency = 0,
    }):Play()
    task.wait(0.3)
    Container.Visible = true
end)

------------------------------------------------------------
-- HIỆU ỨNG NHẸ (tiêu đề đổi màu HSV chậm)
------------------------------------------------------------
safe(function()
    local hue = 0
    RunService.Heartbeat:Connect(function(dt)
        hue = (hue + (dt or 0) * 0.05) % 1
        Title.TextColor3 = Color3.fromHSV(hue, 0.5, 1)
    end)
end)
