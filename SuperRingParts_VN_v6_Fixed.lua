--[[
    Super Ring Parts V6 - Compact Scrollable + Anti-Ring/Fling
    Tác giả gốc: lukas (Robloxlukasgames)
    Nâng cấp: [ZERO2]
    • Compact menu (scrollable)
    • Anti-Ring + Anti-Fling protection
    • Fixed close button
    • Keyboard toggle (RightShift)
]]

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local StarterGui         = game:GetService("StarterGui")
local HttpService        = game:GetService("HttpService")
local TweenService       = game:GetService("TweenService")
local Workspace          = game:GetService("Workspace")
local LocalPlayer        = Players.LocalPlayer

------------------------------------------------------------
-- ⚙️ CONFIG & STATE
------------------------------------------------------------
local Config = {
    radius = 50,
    height = 100,
    rotationSpeed = 10,
    attractionStrength = 1000,
    toggleKey = Enum.KeyCode.RightShift,
}

local UIState = {
    menuOpen = true,
    minimized = false,
    tornadoActive = false,
    antiRingActive = false,
    antiFlingActive = false,
}

------------------------------------------------------------
-- 💾 SAVE/LOAD
------------------------------------------------------------
local function saveConfig()
    pcall(function()
        writefile("SuperRingPartsConfig_VN.txt", HttpService:JSONEncode(Config))
    end)
end

local function loadConfig()
    pcall(function()
        if isfile("SuperRingPartsConfig_VN.txt") then
            Config = HttpService:JSONDecode(readfile("SuperRingPartsConfig_VN.txt"))
        end
    end)
end

loadConfig()

------------------------------------------------------------
-- 🔊 SOUND
------------------------------------------------------------
local function playSound(soundId)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. soundId
    s.Volume = 0.5
    s.Parent = game:GetService("SoundService")
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

playSound("2865227271")

------------------------------------------------------------
-- 🎨 UI HELPERS
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
    p.PaddingTop = UDim.new(0, t or 6)
    p.PaddingBottom = UDim.new(0, b or 6)
    p.PaddingLeft = UDim.new(0, l or 6)
    p.PaddingRight = UDim.new(0, r or 6)
    p.Parent = parent
    return p
end

------------------------------------------------------------
-- 🖼️ MAIN GUI (COMPACT)
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperRingPartsGUI_VN"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 12)
addStroke(MainFrame, Color3.fromRGB(85, 110, 255), 1.5)

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
addCorner(TitleBar, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Ring Parts v6"
Title.TextColor3 = Color3.fromRGB(235, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -58, 0, 6)
MinimizeButton.Text = "−"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
MinimizeButton.TextColor3 = Color3.fromRGB(20,20,20)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar
addCorner(MinimizeButton, 6)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -28, 0, 6)
CloseButton.Text = "✕"
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CloseButton.Parent = TitleBar
addCorner(CloseButton, 6)

-- SCROLLABLE CONTAINER
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -12, 1, -50)
Container.Position = UDim2.new(0, 6, 0, 44)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(85, 110, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

------------------------------------------------------------
-- 🎮 TORNADO TOGGLE
------------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleTornado"
ToggleButton.Size = UDim2.new(1, 0, 0, 38)
ToggleButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
ToggleButton.Text = "● TORNADO: TẮT"
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 13
ToggleButton.LayoutOrder = 1
ToggleButton.Parent = Container
addCorner(ToggleButton, 8)

------------------------------------------------------------
-- 🛡️ ANTI-RING TOGGLE
------------------------------------------------------------
local AntiRingButton = Instance.new("TextButton")
AntiRingButton.Name = "AntiRing"
AntiRingButton.Size = UDim2.new(1, 0, 0, 38)
AntiRingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
AntiRingButton.Text = "🛡 ANTI-RING: TẮT"
AntiRingButton.TextColor3 = Color3.fromRGB(255,255,255)
AntiRingButton.Font = Enum.Font.GothamBold
AntiRingButton.TextSize = 13
AntiRingButton.LayoutOrder = 2
AntiRingButton.Parent = Container
addCorner(AntiRingButton, 8)

------------------------------------------------------------
-- 🔄 ANTI-FLING TOGGLE
------------------------------------------------------------
local AntiFlingButton = Instance.new("TextButton")
AntiFlingButton.Name = "AntiFling"
AntiFlingButton.Size = UDim2.new(1, 0, 0, 38)
AntiFlingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
AntiFlingButton.Text = "🔄 ANTI-FLING: TẮT"
AntiFlingButton.TextColor3 = Color3.fromRGB(255,255,255)
AntiFlingButton.Font = Enum.Font.GothamBold
AntiFlingButton.TextSize = 13
AntiFlingButton.LayoutOrder = 3
AntiFlingButton.Parent = Container
addCorner(AntiFlingButton, 8)

------------------------------------------------------------
-- 🎚️ CONTROLS (compact)
------------------------------------------------------------
local function createSmallControl(name, labelText, defaultValue, color, layoutOrder, callback)
    local Group = Instance.new("Frame")
    Group.Name = name
    Group.Size = UDim2.new(1, 0, 0, 60)
    Group.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
    Group.LayoutOrder = layoutOrder
    Group.Parent = Container
    addCorner(Group, 8)
    addStroke(Group, color, 1)

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -12, 0, 18)
    Header.Position = UDim2.new(0, 6, 0, 4)
    Header.BackgroundTransparency = 1
    Header.Text = labelText
    Header.TextColor3 = color
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 12
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = Group

    local Display = Instance.new("TextLabel")
    Display.Size = UDim2.new(0.3, 0, 0, 28)
    Display.Position = UDim2.new(0.35, 0, 0, 26)
    Display.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    Display.Text = tostring(defaultValue)
    Display.TextColor3 = Color3.fromRGB(255,255,255)
    Display.Font = Enum.Font.GothamBold
    Display.TextSize = 12
    Display.Parent = Group
    addCorner(Display, 6)
    addStroke(Display, Color3.fromRGB(60, 60, 80), 1)

    local DecreaseButton = Instance.new("TextButton")
    DecreaseButton.Size = UDim2.new(0.3, 0, 0, 28)
    DecreaseButton.Position = UDim2.new(0, 6, 0, 26)
    DecreaseButton.Text = "−"
    DecreaseButton.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
    DecreaseButton.TextColor3 = Color3.fromRGB(255,255,255)
    DecreaseButton.Font = Enum.Font.GothamBold
    DecreaseButton.TextSize = 16
    DecreaseButton.Parent = Group
    addCorner(DecreaseButton, 6)

    local IncreaseButton = Instance.new("TextButton")
    IncreaseButton.Size = UDim2.new(0.3, 0, 0, 28)
    IncreaseButton.Position = UDim2.new(0.64, 0, 0, 26)
    IncreaseButton.Text = "+"
    IncreaseButton.BackgroundColor3 = color
    IncreaseButton.TextColor3 = Color3.fromRGB(20,20,20)
    IncreaseButton.Font = Enum.Font.GothamBold
    IncreaseButton.TextSize = 16
    IncreaseButton.Parent = Group
    addCorner(IncreaseButton, 6)

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
end

createSmallControl("Radius", "Bán kính", Config.radius, Color3.fromRGB(120, 220, 120), 4, function(v) Config.radius = v end)
createSmallControl("Height", "Chiều cao", Config.height, Color3.fromRGB(220, 120, 220), 5, function(v) Config.height = v end)
createSmallControl("Speed", "Tốc độ xoay", Config.rotationSpeed, Color3.fromRGB(120, 220, 220), 6, function(v) Config.rotationSpeed = v end)
createSmallControl("Force", "Lực hút", Config.attractionStrength, Color3.fromRGB(255, 140, 90), 7, function(v) Config.attractionStrength = v end)

------------------------------------------------------------
-- 🛠️ QUICK UTILS (compact grid)
------------------------------------------------------------
local UtilHeader = Instance.new("TextLabel")
UtilHeader.Size = UDim2.new(1, 0, 0, 16)
UtilHeader.BackgroundTransparency = 1
UtilHeader.Text = "— Tiện ích —"
UtilHeader.TextColor3 = Color3.fromRGB(160, 165, 200)
UtilHeader.Font = Enum.Font.GothamBold
UtilHeader.TextSize = 11
UtilHeader.LayoutOrder = 8
UtilHeader.Parent = Container

local UtilGrid = Instance.new("Frame")
UtilGrid.Name = "UtilGrid"
UtilGrid.Size = UDim2.new(1, 0, 0, 80)
UtilGrid.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
UtilGrid.LayoutOrder = 9
UtilGrid.Parent = Container
addCorner(UtilGrid, 8)

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 0, 0, 32)
GridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
GridLayout.FillDirectionMaxCells = 2
GridLayout.Parent = UtilGrid
addPadding(UtilGrid, 6, 6, 6, 6)

local function makeUtil(name, label, color, callback)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = label
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Parent = UtilGrid
    addCorner(b, 6)
    b.MouseButton1Click:Connect(function()
        playSound("12221967")
        callback()
    end)
    return b
end

task.defer(function()
    local w = (UtilGrid.AbsoluteSize.X - 18) / 2
    GridLayout.CellSize = UDim2.new(0, math.max(100, w), 0, 32)
end)

makeUtil("Fly", "✈ Fly", Color3.fromRGB(80, 130, 255), function()
    loadstring(game:HttpGet("https://pastebin.com/raw/YSL3xKYU"))()
end)

makeUtil("NoFall", "🛡 No Fall", Color3.fromRGB(220, 80, 80), function()
    local runsvc = game:GetService("RunService")
    local lp = Players.LocalPlayer
    local zero = Vector3.zero
    local function nofall(chr)
        local root = chr:WaitForChild("HumanoidRootPart")
        if root then
            local con
            con = runsvc.Heartbeat:Connect(function()
                if not root.Parent then con:Disconnect() end
                local oldvel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = zero
                runsvc.RenderStepped:Wait()
                root.AssemblyLinearVelocity = oldvel
            end)
        end
    end
    nofall(lp.Character)
    lp.CharacterAdded:Connect(nofall)
end)

makeUtil("NoClip", "👻 NoClip", Color3.fromRGB(40, 40, 55), function()
    local function nocl()
        if Players.LocalPlayer.Character then
            for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        task.wait(0.2)
    end
    RunService.Stepped:Connect(nocl)
end)

makeUtil("IY", "∞ IY", Color3.fromRGB(80, 220, 220), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

------------------------------------------------------------
-- 🖱️ DRAG & DROP
------------------------------------------------------------
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local d = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end
end)

------------------------------------------------------------
-- 📌 MINIMIZE / CLOSE
------------------------------------------------------------
MinimizeButton.MouseButton1Click:Connect(function()
    UIState.minimized = not UIState.minimized
    local target = UIState.minimized and UDim2.new(0, 320, 0, 40) or UDim2.new(0, 320, 0, 420)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target}):Play()
    MinimizeButton.Text = UIState.minimized and "+" or "−"
    Container.Visible = not UIState.minimized
    playSound("12221967")
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.15), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.15)
    ScreenGui:Destroy()
    print("✓ Menu closed")
end)

------------------------------------------------------------
-- ⌨️ KEYBOARD TOGGLE
------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.toggleKey then
        UIState.menuOpen = not UIState.menuOpen
        MainFrame.Visible = UIState.menuOpen
        playSound("12221967")
    end
end)

------------------------------------------------------------
-- 🌪️ TORNADO LOGIC
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
local function addPart(part)
    if RetainPart(part) then
        if not table.find(parts, part) then
            table.insert(parts, part)
        end
    end
end

local function removePart(part)
    local i = table.find(parts, part)
    if i then table.remove(parts, i) end
end

for _, p in pairs(workspace:GetDescendants()) do addPart(p) end
workspace.DescendantAdded:Connect(addPart)
workspace.DescendantRemoving:Connect(removePart)

RunService.Heartbeat:Connect(function()
    if not UIState.tornadoActive then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tornadoCenter = hrp.Position
        for _, part in pairs(parts) do
            if part.Parent and not part.Anchored then
                local pos = part.Position
                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                local newAngle = angle + math.rad(Config.rotationSpeed)
                local targetPos = Vector3.new(
                    tornadoCenter.X + math.cos(newAngle) * math.min(Config.radius, distance),
                    tornadoCenter.Y + (Config.height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / Config.height)))),
                    tornadoCenter.Z + math.sin(newAngle) * math.min(Config.radius, distance)
                )
                local dir = (targetPos - part.Position).unit
                part.Velocity = dir * Config.attractionStrength
            end
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    UIState.tornadoActive = not UIState.tornadoActive
    if UIState.tornadoActive then
        ToggleButton.Text = "● TORNADO: BẬT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        ToggleButton.Text = "● TORNADO: TẮT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
    end
    playSound("12221967")
end)

------------------------------------------------------------
-- 🛡️ ANTI-RING (protects player from tornado)
------------------------------------------------------------
AntiRingButton.MouseButton1Click:Connect(function()
    UIState.antiRingActive = not UIState.antiRingActive
    if UIState.antiRingActive then
        AntiRingButton.Text = "🛡 ANTI-RING: BẬT"
        AntiRingButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        AntiRingButton.Text = "🛡 ANTI-RING: TẮT"
        AntiRingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    end
    playSound("12221967")
end)

RunService.Heartbeat:Connect(function()
    if not UIState.antiRingActive then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end)

------------------------------------------------------------
-- 🔄 ANTI-FLING (protects from velocity-based attacks)
------------------------------------------------------------
AntiFlingButton.MouseButton1Click:Connect(function()
    UIState.antiFlingActive = not UIState.antiFlingActive
    if UIState.antiFlingActive then
        AntiFlingButton.Text = "🔄 ANTI-FLING: BẬT"
        AntiFlingButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        AntiFlingButton.Text = "🔄 ANTI-FLING: TẮT"
        AntiFlingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    end
    playSound("12221967")
end)

RunService.Heartbeat:Connect(function()
    if not UIState.antiFlingActive then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local vel = hrp.AssemblyLinearVelocity
        local magnitude = vel.Magnitude
        if magnitude > 100 then
            hrp.AssemblyLinearVelocity = vel.Unit * 50
        end
    end
end)

------------------------------------------------------------
-- 📢 INIT NOTIFY
------------------------------------------------------------
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✓ Ring Parts V6",
        Text = "Menu ready! Press RightShift to toggle",
        Duration = 3
    })
end)

print("✓ SuperRingParts V6 loaded - Anti-Ring & Anti-Fling ready!")
