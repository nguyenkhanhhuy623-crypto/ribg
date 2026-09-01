--[[
    Super Ring Parts V6 - Bản tiếng Việt (UI nâng cấp)
    Tác giả gốc: lukas (Robloxlukasgames)
    Bản dịch & nâng cấp giao diện: Mavis
    Chức năng giữ nguyên 100%
]]

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local SoundService       = game:GetService("SoundService")
local StarterGui         = game:GetService("StarterGui")
local HttpService        = game:GetService("HttpService")
local TweenService       = game:GetService("TweenService")
local Workspace          = game:GetService("Workspace")
local LocalPlayer        = Players.LocalPlayer

------------------------------------------------------------
-- ÂM THANH
------------------------------------------------------------
local function playSound(soundId)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. soundId
    s.Volume = 0.5
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end
playSound("2865227271")

------------------------------------------------------------
-- CẤU HÌNH MẶC ĐỊNH
------------------------------------------------------------
local config = {
    radius             = 50,
    height             = 100,
    rotationSpeed      = 10,
    attractionStrength = 1000,
}

local function saveConfig()
    pcall(function()
        writefile("SuperRingPartsConfig_VN.txt", HttpService:JSONEncode(config))
    end)
end
local function loadConfig()
    pcall(function()
        if isfile("SuperRingPartsConfig_VN.txt") then
            config = HttpService:JSONDecode(readfile("SuperRingPartsConfig_VN.txt"))
        end
    end)
end
loadConfig()

------------------------------------------------------------
-- TIỆN ÍCH TẠO UI
------------------------------------------------------------
local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function addPadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 6)
    p.PaddingBottom = UDim.new(0, b or 6)
    p.PaddingLeft   = UDim.new(0, l or 6)
    p.PaddingRight  = UDim.new(0, r or 6)
    p.Parent = parent
    return p
end

------------------------------------------------------------
-- GIAO DIỆN CHÍNH
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperRingPartsGUI_VN"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 360, 0, 560)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 16)
addStroke(MainFrame, Color3.fromRGB(85, 110, 255), 1.5)

-- Thanh tiêu đề
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
addCorner(TitleBar, 16)

-- Che phần góc dưới của thanh tiêu đề để bo tròn đẹp
local TitleCover = Instance.new("Frame")
TitleCover.Size = UDim2.new(1, 0, 0, 16)
TitleCover.Position = UDim2.new(0, 0, 1, -16)
TitleCover.BackgroundColor3 = TitleBar.BackgroundColor3
TitleCover.BorderSizePixel = 0
TitleCover.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Vòng Parts Siêu Cấp V6 • by lukas"
Title.TextColor3 = Color3.fromRGB(235, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Nút thu nhỏ
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -72, 0, 8)
MinimizeButton.Text = "—"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
MinimizeButton.TextColor3 = Color3.fromRGB(20,20,20)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar
addCorner(MinimizeButton, 8)

-- Nút đóng
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 8)
CloseButton.Text = "✕"
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar
addCorner(CloseButton, 8)

-- Vùng nội dung
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -16, 1, -58)
Container.Position = UDim2.new(0, 8, 0, 52)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(85, 110, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

------------------------------------------------------------
-- NÚT BẬT/TẮT TORNADO (lớn, nổi bật)
------------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleTornado"
ToggleButton.Size = UDim2.new(1, 0, 0, 52)
ToggleButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
ToggleButton.Text = "●  TORNADO: TẮT"
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.LayoutOrder = 1
ToggleButton.Parent = Container
addCorner(ToggleButton, 12)

------------------------------------------------------------
-- HÀM TẠO Ô ĐIỀU CHỈNH (Bán kính / Chiều cao / Tốc độ / Lực hút)
------------------------------------------------------------
local function createControl(name, labelText, defaultValue, color, layoutOrder, callback)
    local Group = Instance.new("Frame")
    Group.Name = name
    Group.Size = UDim2.new(1, 0, 0, 86)
    Group.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
    Group.LayoutOrder = layoutOrder
    Group.Parent = Container
    addCorner(Group, 12)
    addStroke(Group, color, 1.2)

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -16, 0, 22)
    Header.Position = UDim2.new(0, 10, 0, 6)
    Header.BackgroundTransparency = 1
    Header.Text = labelText
    Header.TextColor3 = color
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = Group

    local Display = Instance.new("TextLabel")
    Display.Size = UDim2.new(0.36, 0, 0, 36)
    Display.Position = UDim2.new(0.32, 0, 0, 28)
    Display.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    Display.Text = tostring(defaultValue)
    Display.TextColor3 = Color3.fromRGB(255,255,255)
    Display.Font = Enum.Font.GothamBold
    Display.TextSize = 16
    Display.Parent = Group
    addCorner(Display, 8)
    addStroke(Display, Color3.fromRGB(60, 60, 80), 1)

    local DecreaseButton = Instance.new("TextButton")
    DecreaseButton.Size = UDim2.new(0.28, 0, 0, 36)
    DecreaseButton.Position = UDim2.new(0, 0, 0, 28)
    DecreaseButton.Text = "−"
    DecreaseButton.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
    DecreaseButton.TextColor3 = Color3.fromRGB(255,255,255)
    DecreaseButton.Font = Enum.Font.GothamBold
    DecreaseButton.TextSize = 22
    DecreaseButton.Parent = Group
    addCorner(DecreaseButton, 8)

    local IncreaseButton = Instance.new("TextButton")
    IncreaseButton.Size = UDim2.new(0.28, 0, 0, 36)
    IncreaseButton.Position = UDim2.new(0.72, 0, 0, 28)
    IncreaseButton.Text = "+"
    IncreaseButton.BackgroundColor3 = color
    IncreaseButton.TextColor3 = Color3.fromRGB(20,20,20)
    IncreaseButton.Font = Enum.Font.GothamBold
    IncreaseButton.TextSize = 22
    IncreaseButton.Parent = Group
    addCorner(IncreaseButton, 8)

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -20, 0, 18)
    TextBox.Position = UDim2.new(0, 10, 1, -22)
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

    DecreaseButton.MouseButton1Click:Connect(function()
        local cur = tonumber(Display.Text) or 0
        setValue(cur - 10)
    end)
    IncreaseButton.MouseButton1Click:Connect(function()
        local cur = tonumber(Display.Text) or 0
        setValue(cur + 10)
    end)
    TextBox.FocusLost:Connect(function(enter)
        if enter and TextBox.Text ~= "" then
            setValue(TextBox.Text)
            TextBox.Text = ""
        end
    end)
end

createControl("Radius",             "Bán kính vòng",          config.radius,             Color3.fromRGB(120, 220, 120), 2, function(v) config.radius             = v end)
createControl("Height",             "Chiều cao cột",           config.height,             Color3.fromRGB(220, 120, 220), 3, function(v) config.height             = v end)
createControl("RotationSpeed",      "Tốc độ xoay (°/s)",      config.rotationSpeed,      Color3.fromRGB(120, 220, 220), 4, function(v) config.rotationSpeed      = v end)
createControl("AttractionStrength", "Lực hút (mạnh → yếu)",   config.attractionStrength, Color3.fromRGB(255, 140, 90),  5, function(v) config.attractionStrength = v end)

------------------------------------------------------------
-- KHU TIỆN ÍCH (Fly / Noclip / Inf Jump / No Fall / IY / Nameless / FPS)
------------------------------------------------------------
local UtilityHeader = Instance.new("TextLabel")
UtilityHeader.Size = UDim2.new(1, 0, 0, 20)
UtilityHeader.BackgroundTransparency = 1
UtilityHeader.Text = "— Tiện ích bổ sung —"
UtilityHeader.TextColor3 = Color3.fromRGB(160, 165, 200)
UtilityHeader.Font = Enum.Font.GothamBold
UtilityHeader.TextSize = 13
UtilityHeader.LayoutOrder = 6
UtilityHeader.Parent = Container

local UtilGrid = Instance.new("Frame")
UtilGrid.Name = "UtilGrid"
UtilGrid.Size = UDim2.new(1, 0, 0, 120)
UtilGrid.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
UtilGrid.LayoutOrder = 7
UtilGrid.Parent = Container
addCorner(UtilGrid, 12)

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 0, 0, 36)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
GridLayout.FillDirectionMaxCells = 2
GridLayout.Parent = UtilGrid
addPadding(UtilGrid, 10, 10, 10, 10)

local function makeUtil(name, label, color, callback)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = label
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = UtilGrid
    addCorner(b, 8)
    b.MouseButton1Click:Connect(function()
        playSound("12221967")
        callback()
    end)
    return b
end

-- Đợi layout cập nhật để tính toán ô lưới đều
task.defer(function()
    local w = (UtilGrid.AbsoluteSize.X - 28) / 2
    GridLayout.CellSize = UDim2.new(0, math.max(120, w), 0, 36)
end)

makeUtil("Fly",     "✈  Bay (Fly Gui)",   Color3.fromRGB(80, 130, 255), function()
    loadstring(game:HttpGet("https://pastebin.com/raw/YSL3xKYU"))()
end)
makeUtil("NoFall",  "🛡  Không rơi sát thương", Color3.fromRGB(220, 80, 80), function()
    local runsvc = game:GetService("RunService")
    local heartbeat = runsvc.Heartbeat
    local rstepped = runsvc.RenderStepped
    local lp = Players.LocalPlayer
    local zero = Vector3.zero
    local function nofalldamage(chr)
        local root = chr:WaitForChild("HumanoidRootPart")
        if root then
            local con
            con = heartbeat:Connect(function()
                if not root.Parent then con:Disconnect() end
                local oldvel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = zero
                rstepped:Wait()
                root.AssemblyLinearVelocity = oldvel
            end)
        end
    end
    nofalldamage(lp.Character)
    lp.CharacterAdded:Connect(nofalldamage)
end)
makeUtil("Noclip",  "👻  Xuyên tường",     Color3.fromRGB(40, 40, 55), function()
    local Noclip = nil
    local Clip   = nil
    local function nocl()
        if Clip == false and Players.LocalPlayer.Character ~= nil then
            for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        task.wait(0.21)
    end
    Noclip = RunService.Stepped:Connect(nocl)
end)
makeUtil("InfJump", "⬆  Nhảy vô hạn",     Color3.fromRGB(80, 200, 110), function()
    UserInputService.JumpRequest:Connect(function()
        local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end)
end)
makeUtil("IY",      "∞  Infinite Yield", Color3.fromRGB(80, 220, 220), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
makeUtil("Nameless","👑  Nameless Admin", Color3.fromRGB(60, 60, 80), function()
    loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Nameless-Admin-FE-11243"))()
end)
makeUtil("FPS",     "🚀  Mở khoá FPS",     Color3.fromRGB(255, 170, 60), function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ySHJdZpb", true))()
end)

------------------------------------------------------------
-- THANH THÔNG TIN
------------------------------------------------------------
local CreditBar = Instance.new("TextLabel")
CreditBar.Size = UDim2.new(1, 0, 0, 22)
CreditBar.BackgroundTransparency = 1
CreditBar.Text = "🇻🇳 Bản tiếng Việt • UI nâng cấp • Chức năng giữ nguyên 100%"
CreditBar.TextColor3 = Color3.fromRGB(120, 130, 170)
CreditBar.Font = Enum.Font.Gotham
CreditBar.TextSize = 11
CreditBar.LayoutOrder = 8
CreditBar.Parent = Container

------------------------------------------------------------
-- KÉO THẢ GUI
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
-- THU NHỎ / ĐÓNG
------------------------------------------------------------
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local target = minimized and UDim2.new(0, 360, 0, 46) or UDim2.new(0, 360, 0, 560)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target}):Play()
    MinimizeButton.Text = minimized and "+" or "—"
    Container.Visible = not minimized
    playSound("12221967")
end)
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.22)
    ScreenGui:Destroy()
end)

------------------------------------------------------------
-- LOGIC RING PARTS / TORNADO (giữ nguyên 100% bản gốc)
------------------------------------------------------------
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

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
    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
            Part.CanCollide = false
        end
    end
    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end
    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored
        and not v.Parent:FindFirstChild("Humanoid")
        and not v.Parent:FindFirstChild("Head")
        and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce")
                or x:IsA("BodyGyro") or x:IsA("BodyPosition")
                or x:IsA("BodyThrust") or x:IsA("BodyVelocity")
                or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment")     then v:FindFirstChild("Attachment"):Destroy()     end
        if v:FindFirstChild("AlignPosition")  then v:FindFirstChild("AlignPosition"):Destroy()  end
        if v:FindFirstChild("Torque")         then v:FindFirstChild("Torque"):Destroy()         end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000,100000,100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = 9999999999999999999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local ringPartsEnabled = false
local function RetainPart(Part)
    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(workspace) then
        if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
            return false
        end
        Part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
        Part.CanCollide = false
        return true
    end
    return false
end

local parts = {}
local function addPart(part) if RetainPart(part) then if not table.find(parts, part) then table.insert(parts, part) end end end
local function removePart(part) local i = table.find(parts, part); if i then table.remove(parts, i) end end
for _, p in pairs(workspace:GetDescendants()) do addPart(p) end
workspace.DescendantAdded:Connect(addPart)
workspace.DescendantRemoving:Connect(removePart)

RunService.Heartbeat:Connect(function()
    if not ringPartsEnabled then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
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
    end
end)

-- Bật / tắt Tornado
ToggleButton.MouseButton1Click:Connect(function()
    ringPartsEnabled = not ringPartsEnabled
    if ringPartsEnabled then
        ToggleButton.Text = "●  TORNADO: BẬT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        ToggleButton.Text = "●  TORNADO: TẮT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
    end
    playSound("12221967")
end)

------------------------------------------------------------
-- THÔNG BÁO CHÀO
------------------------------------------------------------
pcall(function()
    local userId   = Players:GetUserIdFromNameAsync("Robloxlukasgames")
    local content  = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    StarterGui:SetCore("SendNotification", {Title = "Chào bạn",     Text = "Chúc bạn dùng script vui vẻ!", Icon = content, Duration = 5})
    StarterGui:SetCore("SendNotification", {Title = "MẸO",         Text = "Bấm vào ô nhập số bên dưới để chỉnh nhanh", Icon = content, Duration = 5})
    StarterGui:SetCore("SendNotification", {Title = "Credit",      Text = "Tìm trên ScriptBlox nhé!", Icon = content, Duration = 5})
end)

------------------------------------------------------------
-- HIỆU ỨNG GRADIENT NHẸ CHO KHUNG CHÍNH
------------------------------------------------------------
do
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 25, 55)),
    })
    grad.Rotation = 90
    grad.Parent = MainFrame

    local hue = 0
    RunService.Heartbeat:Connect(function(dt)
        hue = (hue + dt * 0.05) % 1
        Title.TextColor3 = Color3.fromHSV(hue, 0.6, 1)
    end)
end
