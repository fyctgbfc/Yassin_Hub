-- Yassin Hub (Clean Dashboard Edition - Auto Return Fling + Spectate + Respawn)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local TargetParent = LocalPlayer:FindFirstChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then 
        TargetParent = game:GetService("CoreGui") 
    end
end)

if TargetParent:FindFirstChild("YASSIN_HUB_V2") then
    TargetParent.YASSIN_HUB_V2:Destroy()
end

local FeatureStates = { 
    Speed = false, InfJump = false, Fly = false, ESP = false,
    NoClip = false, FlingMurderer = false, FlingSheriff = false,
    FlingSelected = false, Invisible = false
}
local Settings = { WalkSpeed = 50, FlySpeed = 60, NormalSpeed = 16 }
local Connections, Highlights = {}, {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YASSIN_HUB_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Theme Palette
local OrangeMain = Color3.fromRGB(255, 110, 0)
local OrangeGlow = Color3.fromRGB(255, 140, 20)
local AccentPurple = Color3.fromRGB(90, 25, 130)
local DarkBg = Color3.fromRGB(18, 12, 22)
local SidebarBg = Color3.fromRGB(24, 16, 32)
local FrameBg = Color3.fromRGB(32, 20, 42)
local TextColor = Color3.fromRGB(245, 235, 255)

-- Floating & DRAGGABLE Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 130, 0, 34)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = DarkBg
ToggleBtn.Text = "✨ Yassin Hub"
ToggleBtn.TextColor3 = OrangeGlow
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Active = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 17)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = OrangeMain
ToggleStroke.Thickness = 1.5

-- Dragging for Toggle Button
local draggingToggle, dragStartToggle, startPosToggle
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true; dragStartToggle = input.Position; startPosToggle = ToggleBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingToggle = false end end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartToggle
        ToggleBtn.Position = UDim2.new(startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X, startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y)
    end
end)

-- Main Dashboard Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = DarkBg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = OrangeMain
MainStroke.Thickness = 1.5

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Dragging for Main Frame
local draggingMain, dragStartMain, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true; dragStartMain = input.Position; startPosMain = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingMain = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = SidebarBg
Sidebar.BorderSizePixel = 0

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 6)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Title = Instance.new("TextLabel")
Title.Parent = Sidebar
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "Yassin Hub"
Title.TextColor3 = OrangeGlow
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -150, 1, -20)
ContentFrame.Position = UDim2.new(0, 145, 0, 10)
ContentFrame.BackgroundTransparency = 1

local Pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentFrame
    page.Size = UDim2.new(1, -10, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = OrangeMain
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    Pages[name] = page
    return page
end

local function createTab(name, pageName)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.BackgroundColor3 = FrameBg
    btn.Text = name
    btn.TextColor3 = TextColor
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = OrangeMain
    btnStroke.Thickness = 0.5
    
    btn.MouseButton1Click:Connect(function()
        for pName, page in pairs(Pages) do
            page.Visible = (pName == pageName)
        end
    end)
end

-- Create Pages
local PlayerPage = createPage("Player")
local TeleportPage = createPage("Teleport")
local VisualsPage = createPage("Visuals")

createTab("🏃 Player", "Player")
createTab("⚡ Teleport & Fling", "Teleport")
createTab("👁️ Visuals & Spectate", "Visuals")

Pages["Player"].Visible = true

-- UI Builders
local function addToggle(parent, text, name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = FrameBg
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TextColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 55, 0, 24)
    btn.Position = UDim2.new(1, -63, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    btn.Text = "OFF"
    btn.TextColor3 = TextColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        FeatureStates[name] = toggled
        btn.BackgroundColor3 = toggled and OrangeMain or Color3.fromRGB(180, 40, 40)
        btn.Text = toggled and "ON" or "OFF"
        pcall(callback, toggled)
    end)
end

local function addButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = AccentPurple
    btn.Text = text
    btn.TextColor3 = TextColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = OrangeMain
    btnStroke.Thickness = 1

    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- Role Helper Function
local function getRolePlayer(itemName)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if plr.Character:FindFirstChild(itemName) or (plr:FindFirstChild("Backpack") and plr.Backpack:FindFirstChild(itemName)) then
                return plr
            end
        end
    end
    return nil
end

-- SPECTATE LOGIC
local function spectatePlayer(targetPlayer)
    local camera = workspace.CurrentCamera
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
        camera.CameraSubject = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end

-- WORKING FLING WITH AUTO RETURN
local function flingTarget(targetPlayer, stateKey)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not root or not targetPlayer or not targetPlayer.Character then return end

    -- SAVE ORIGINAL POSITION BEFORE FLING
    local originalCFrame = root.CFrame
    
    local bAV = Instance.new("BodyAngularVelocity")
    bAV.Name = "YassinFlingVelocity"
    bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bAV.AngularVelocity = Vector3.new(0, 99999, 0)
    bAV.Parent = root

    local conn
    conn = RunService.Heartbeat:Connect(function()
        -- Stop condition: toggle disabled, or target lost/dead
        if not FeatureStates[stateKey] or not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            
            -- CLEANUP AND TELEPORT BACK TO ORIGINAL POSITION
            if bAV then bAV:Destroy() end
            if conn then conn:Disconnect() end
            
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = originalCFrame -- Teleports you back safely
            end
            return
        end

        pcall(function()
            local targetRoot = targetPlayer.Character.HumanoidRootPart
            
            -- Disable collisions on self during fling
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end

            -- Micro-jitter teleport to force target velocity physics
            local offset = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))
            root.CFrame = targetRoot.CFrame * CFrame.new(offset)
            root.AssemblyLinearVelocity = Vector3.new(10000, 10000, 10000)
        end)
    end)
end

-- 1. Player Features
addToggle(PlayerPage, "WalkSpeed Boost", "Speed", function(enabled)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = enabled and Settings.WalkSpeed or Settings.NormalSpeed
    end
end)

addToggle(PlayerPage, "3D Fly", "Fly", function(enabled)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if enabled and root and hum then
        hum.PlatformStand = true
        Connections.Fly = RunService.RenderStepped:Connect(function()
            if not FeatureStates.Fly or not root or not hum then
                if Connections.Fly then Connections.Fly:Disconnect() end
                if hum then hum.PlatformStand = false end
                return
            end
            
            local cam = workspace.CurrentCamera
            local vel = Vector3.zero
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, 1, 0) end
            
            if vel.Magnitude > 0 then
                root.AssemblyLinearVelocity = vel.Unit * Settings.FlySpeed
            else
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    else
        if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
        if hum then hum.PlatformStand = false end
        if root then root.AssemblyLinearVelocity = Vector3.zero end
    end
end)

addToggle(PlayerPage, "NoClip", "NoClip", function(enabled)
    if enabled then
        Connections.NoClip = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if Connections.NoClip then Connections.NoClip:Disconnect(); Connections.NoClip = nil end
    end
end)

addToggle(PlayerPage, "Infinite Jump", "InfJump", function(enabled)
    if enabled and not Connections.InfJump then
        Connections.InfJump = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    elseif not enabled and Connections.InfJump then
        Connections.InfJump:Disconnect(); Connections.InfJump = nil
    end
end)

addButton(PlayerPage, "Respawn Character 🔄", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

-- 2. Teleport & Fling Features
addButton(TeleportPage, "Teleport to Murderer 🔪", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local murderer = getRolePlayer("Knife")
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") and root then
        root.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

addButton(TeleportPage, "Teleport to Sheriff 🔫", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local sheriff = getRolePlayer("Gun")
    if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") and root then
        root.CFrame = sheriff.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

addToggle(TeleportPage, "Fling Murderer ☠️", "FlingMurderer", function(enabled)
    if enabled then
        local murderer = getRolePlayer("Knife")
        if murderer then 
            flingTarget(murderer, "FlingMurderer") 
        end
    end
end)

addToggle(TeleportPage, "Fling Sheriff 💥", "FlingSheriff", function(enabled)
    if enabled then
        local sheriff = getRolePlayer("Gun")
        if sheriff then 
            flingTarget(sheriff, "FlingSheriff") 
        end
    end
end)

-- 3. Visuals & Spectate
addToggle(VisualsPage, "Role ESP (Murderer/Sheriff)", "ESP", function(enabled)
    if enabled then
        Connections.RoleESP = RunService.RenderStepped:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local char = plr.Character
                    local hl = char:FindFirstChild("YassinRoleESP")
                    local roleColor = Color3.fromRGB(0, 255, 100)
                    local hasKnife = char:FindFirstChild("Knife") or (plr:FindFirstChild("Backpack") and plr.Backpack:FindFirstChild("Knife"))
                    local hasGun = char:FindFirstChild("Gun") or (plr:FindFirstChild("Backpack") and plr.Backpack:FindFirstChild("Gun"))
                    
                    if hasKnife then roleColor = Color3.fromRGB(255, 30, 0)
                    elseif hasGun then roleColor = Color3.fromRGB(255, 170, 0) end
                    
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "YassinRoleESP"
                        hl.Adornee = char
                        hl.FillTransparency = 0.5
                        hl.Parent = char
                    end
                    hl.FillColor = roleColor
                    hl.OutlineColor = roleColor
                end
            end
        end)
    else
        if Connections.RoleESP then Connections.RoleESP:Disconnect(); Connections.RoleESP = nil end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("YassinRoleESP") then
                plr.Character.YassinRoleESP:Destroy()
            end
        end
    end
end)

addButton(VisualsPage, "Spectate Murderer 🔪", function()
    local murderer = getRolePlayer("Knife")
    if murderer then
        spectatePlayer(murderer)
    end
end)

addButton(VisualsPage, "Spectate Sheriff 🔫", function()
    local sheriff = getRolePlayer("Gun")
    if sheriff then
        spectatePlayer(sheriff)
    end
end)

addButton(VisualsPage, "Stop Spectating 👁️", function()
    spectatePlayer(LocalPlayer)
end)

print("[YASSIN HUB] Loaded successfully with Auto-Return Fling, Spectate, and Respawn!")
