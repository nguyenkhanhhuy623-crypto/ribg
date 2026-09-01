--[[
    Super Ring Parts V7 - Troll Suite + Tab UI
    All troll features: Tornado, Lag, Fling, Gravity, Teleport, Freeze, Speed
    Compact + Smooth + Token-efficient
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- STATE
------------------------------------------------------------
local State = {
    menuOpen = true,
    currentTab = "tornado",
    tornadoActive = false,
    lagActive = false,
    flingActive = false,
    gravityActive = false,
    freezeActive = false,
    speedActive = false,
    antiRingActive = false,
    antiFlingActive = false,
}

local Config = {radius = 50, height = 100, rotationSpeed = 10, attractionStrength = 1000}

------------------------------------------------------------
-- SOUND
------------------------------------------------------------
local function playSound(id)
    local s = Instance.new("Sound", game:GetService("SoundService"))
    s.SoundId = "rbxassetid://" .. id
    s.Volume = 0.3
    s:Play()
    game:GetService("Debris"):AddItem(s, 0.5)
end

------------------------------------------------------------
-- UI HELPERS
------------------------------------------------------------
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
end

------------------------------------------------------------
-- MAIN GUI
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollSuite"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
corner(MainFrame, 12)
stroke(MainFrame, Color3.fromRGB(100, 120, 255), 1.5)

-- TITLE
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
corner(TitleBar, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎪 TROLL SUITE"
Title.TextColor3 = Color3.fromRGB(255, 100, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = TitleBar
corner(CloseBtn, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- TAB BUTTONS
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 36)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local tabs = {
    {name = "tornado", icon = "🌪", label = "Tornado"},
    {name = "chaos", icon = "💥", label = "Chaos"},
    {name = "protect", icon = "🛡", label = "Protect"},
}

local TabButtons = {}

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.name
    btn.Size = UDim2.new(0.33, 0, 1, 0)
    btn.BackgroundColor3 = State.currentTab == tab.name and Color3.fromRGB(100, 120, 255) or Color3.fromRGB(40, 45, 60)
    btn.Text = tab.icon .. " " .. tab.label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    btn.Parent = TabBar
    corner(btn, 6)
    
    TabButtons[tab.name] = btn
    
    btn.MouseButton1Click:Connect(function()
        State.currentTab = tab.name
        for name, button in pairs(TabButtons) do
            button.BackgroundColor3 = name == tab.name and Color3.fromRGB(100, 120, 255) or Color3.fromRGB(40, 45, 60)
        end
        ContentContainer:ClearAllChildren()
        LoadTabContent(tab.name)
        playSound("12221967")
    end)
end

-- CONTENT CONTAINER
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -12, 1, -88)
ContentContainer.Position = UDim2.new(0, 6, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 255)
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentContainer

------------------------------------------------------------
-- TAB CONTENT LOADER
------------------------------------------------------------
function LoadTabContent(tab)
    if tab == "tornado" then
        CreateToggleButton("TORNADO", "tornadoActive", Color3.fromRGB(100, 180, 255), 1)
        CreateToggleButton("LAG ALL", "lagActive", Color3.fromRGB(200, 80, 80), 2)
        CreateToggleButton("FLING", "flingActive", Color3.fromRGB(255, 150, 50), 3)
        CreateToggleButton("GRAVITY PULL", "gravityActive", Color3.fromRGB(150, 100, 255), 4)
        CreateSlider("Radius", "radius", 10, 200, 5)
        CreateSlider("Speed", "rotationSpeed", 5, 100, 6)
        
    elseif tab == "chaos" then
        CreateToggleButton("SPEED BOOST", "speedActive", Color3.fromRGB(100, 255, 100), 1)
        CreateToggleButton("FREEZE PLAYERS", "freezeActive", Color3.fromRGB(100, 200, 255), 2)
        CreateButton("TELEPORT RANDOM", Color3.fromRGB(255, 100, 200), 3, function()
            TeleportRandom()
        end)
        CreateButton("SPAWN PARTS", Color3.fromRGB(255, 150, 50), 4, function()
            SpawnParts()
        end)
        CreateButton("INVISIBLE MODE", Color3.fromRGB(150, 150, 255), 5, function()
            ToggleInvisible()
        end)
        
    elseif tab == "protect" then
        CreateToggleButton("ANTI-RING", "antiRingActive", Color3.fromRGB(80, 200, 120), 1)
        CreateToggleButton("ANTI-FLING", "antiFlingActive", Color3.fromRGB(100, 200, 200), 2)
        CreateButton("GOD MODE", Color3.fromRGB(255, 200, 100), 3, function()
            ToggleGodMode()
        end)
        CreateButton("NO CLIP", Color3.fromRGB(150, 150, 200), 4, function()
            ToggleNoClip()
        end)
    end
end

function CreateToggleButton(label, key, color, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = State[key] and Color3.fromRGB(80, 200, 120) or color
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = ContentContainer
    corner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        State[key] = not State[key]
        btn.BackgroundColor3 = State[key] and Color3.fromRGB(80, 200, 120) or color
        playSound("12221967")
    end)
end

function CreateButton(label, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = ContentContainer
    corner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        playSound("12221967")
        callback()
    end)
end

function CreateSlider(label, key, min, max, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = ContentContainer
    corner(container, 8)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 18)
    lbl.Position = UDim2.new(0, 6, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. Config[key]
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -12, 0, 18)
    slider.Position = UDim2.new(0, 6, 0, 26)
    slider.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
    slider.Text = ""
    slider.BorderSizePixel = 0
    slider.Parent = container
    corner(slider, 4)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Config[key] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    corner(fill, 4)
    
    slider.MouseButton1Click:Connect(function(x, y)
        local relX = x - slider.AbsolutePosition.X
        local ratio = math.clamp(relX / slider.AbsoluteSize.X, 0, 1)
        Config[key] = math.floor(min + (max - min) * ratio)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        lbl.Text = label .. ": " .. Config[key]
    end)
end

------------------------------------------------------------
-- TORNADO SYSTEM
------------------------------------------------------------
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

local parts = {}
local function addPart(p)
    if p:IsA("BasePart") and not p.Anchored and not p:IsDescendantOf(LocalPlayer.Character) then
        if not table.find(parts, p) then table.insert(parts, p) end
    end
end

for _, p in pairs(Workspace:GetDescendants()) do addPart(p) end
Workspace.DescendantAdded:Connect(addPart)
Workspace.DescendantRemoving:Connect(function(p)
    local i = table.find(parts, p)
    if i then table.remove(parts, i) end
end)

RunService.Heartbeat:Connect(function()
    if State.tornadoActive then
        local hc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hc then
            for _, p in pairs(parts) do
                if p.Parent and not p.Anchored then
                    local d = (p.Position - hc.Position).Magnitude
                    if d < Config.radius then
                        local ang = math.atan2(p.Z - hc.Position.Z, p.X - hc.Position.X) + math.rad(Config.rotationSpeed)
                        local tp = hc.Position + Vector3.new(math.cos(ang) * Config.radius, Config.height / 2, math.sin(ang) * Config.radius)
                        p.Velocity = (tp - p.Position).Unit * Config.attractionStrength
                    end
                end
            end
        end
    end
    
    if State.antiRingActive then
        local hc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hc then
            hc.Velocity = Vector3.zero
            hc.AssemblyLinearVelocity = Vector3.zero
        end
    end
    
    if State.antiFlingActive then
        local hc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hc and hc.AssemblyLinearVelocity.Magnitude > 100 then
            hc.AssemblyLinearVelocity = hc.AssemblyLinearVelocity.Unit * 50
        end
    end
    
    if State.speedActive then
        local hc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hc then
            hc.Velocity = hc.Velocity * 1.5
        end
    end
end)

------------------------------------------------------------
-- LAG EVERYONE
------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not State.lagActive then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hc = p.Character:FindFirstChild("HumanoidRootPart")
            if hc then
                hc.Velocity = Vector3.new(math.random(-5000, 5000), math.random(-5000, 5000), math.random(-5000, 5000))
            end
        end
    end
end)

------------------------------------------------------------
-- FLING
------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not State.flingActive then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hc = p.Character:FindFirstChild("HumanoidRootPart")
            if hc then
                hc.AssemblyLinearVelocity = Vector3.new(math.random(-10000, 10000), math.random(5000, 20000), math.random(-10000, 10000))
            end
        end
    end
end)

------------------------------------------------------------
-- GRAVITY PULL
------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not State.gravityActive then return end
    local hc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hc then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local pc = p.Character:FindFirstChild("HumanoidRootPart")
                if pc then
                    local dir = (hc.Position - pc.Position).Unit
                    pc.AssemblyLinearVelocity = dir * 100
                end
            end
        end
    end
end)

------------------------------------------------------------
-- FREEZE
------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not State.freezeActive then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hc = p.Character:FindFirstChild("HumanoidRootPart")
            if hc then
                hc.Velocity = Vector3.zero
                hc.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
end)

------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------
function TeleportRandom()
    local hc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hc then
        hc.CFrame = CFrame.new(math.random(-500, 500), math.random(50, 200), math.random(-500, 500))
    end
end

function SpawnParts()
    for i = 1, 5 do
        local p = Instance.new("Part", Workspace)
        p.Shape = Enum.PartType.Block
        p.Size = Vector3.new(2, 2, 2)
        p.BrickColor = BrickColor.new("Bright red")
        p.CanCollide = true
        p.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
        task.delay(5, function() p:Destroy() end)
    end
end

local invisible = false
function ToggleInvisible()
    invisible = not invisible
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = invisible and 1 or 0
        end
    end
end

local godMode = false
function ToggleGodMode()
    godMode = not godMode
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = godMode and math.huge or 100
    end
end

local noClipActive = false
function ToggleNoClip()
    noClipActive = not noClipActive
    if noClipActive then
        RunService.Stepped:Connect(function()
            if noClipActive and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end

------------------------------------------------------------
-- KEYBOARD TOGGLE
------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        State.menuOpen = not State.menuOpen
        MainFrame.Visible = State.menuOpen
    end
end)

-- DRAG
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- INIT
LoadTabContent("tornado")
print("✓ Troll Suite V7 loaded! Press RightShift to toggle")
