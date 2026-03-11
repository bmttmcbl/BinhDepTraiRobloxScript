-- [[ BINHDEPTRAI.HUB - ULTRA PERFECTION EDITION ]]
repeat task.wait() until game:IsLoaded()

local Config = { 
    BossMode = false, 
    Dist = 2.8,       -- Khoảng cách tối ưu để chém trúng bụng
    Height = -2.5,    -- ĐỨNG NGANG BỤNG BOSS: Nhân vật lún nhẹ xuống đất
    IsAtSafe = false, 
    SelectedBosses = {},
    PvPMode = false,
    PvPTarget = nil,
    PvPAttack = false,
    PvPEquipAll = false,
    FlySpeed = 250,
    FlyEnabled = false,
    WalkSpeedEnabled = false,
    WalkSpeed = 16,
    JumpHeightEnabled = false,
    JumpHeight = 50,
    OriginalWalkSpeed = 16,
    OriginalJumpPower = 50,
    RainbowEnabled = false,
    FullBrightEnabled = false,
    ESPEnabled = false,
    SceneryEnabled = false,
    RainbowHue = 0,
    ScenerySky = nil,
    SelectedScenery = "AURORA",
    OriginalColors = {}
} 

local Player = game.Players.LocalPlayer
local RS, VIM, UIS, TS = game:GetService("RunService"), game:GetService("VirtualInputManager"), game:GetService("UserInputService"), game:GetService("TweenService")
local Players = game:GetService("Players")

local Keys = {"E", "R", "T", "F"}
local BossPriority = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Sans", "Sword Master", "Cutie Boss", "King Noob", "Nooby", "Unknown Boss"}
local CurrentTarget = nil
local LastSafeCFrame = nil 

-- [[ 1. INTRO LOADING ]]
local IntroGui = Instance.new("ScreenGui")
IntroGui.Parent = (game:GetService("CoreGui") or Player.PlayerGui)
IntroGui.Name = "BinhIntro"
IntroGui.ResetOnSpawn = false

local IntroFrame = Instance.new("Frame", IntroGui)
IntroFrame.Size = UDim2.new(0, 150, 0, 150)
IntroFrame.Position = UDim2.new(0.5, -75, 0.5, -75)
IntroFrame.BackgroundTransparency = 1
IntroFrame.BackgroundColor3 = Color3.new(0,0,0)

local IntroBar = Instance.new("Frame", IntroFrame)
IntroBar.Size = UDim2.new(0, 0, 0, 3)
IntroBar.Position = UDim2.new(0, 0, 0.8, 0)
IntroBar.BackgroundColor3 = Color3.new(0, 1, 0.5)

task.spawn(function() 
    TS:Create(IntroBar, TweenInfo.new(5.5), {Size = UDim2.new(1, 0, 0, 3)}):Play() 
    task.wait(6) 
    IntroGui:Destroy() 
end)

-- [[ 2. UI DESIGN ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = (game:GetService("CoreGui") or Player.PlayerGui)
ScreenGui.Name = "BinhDepTrai_ZeroSpace"
ScreenGui.ResetOnSpawn = false

-- MAIN MENU
local MainGroup = Instance.new("Frame", ScreenGui)
MainGroup.Size = UDim2.new(0, 550, 0, 450)
MainGroup.Position = UDim2.new(0.5, -275, 0.5, -225)
MainGroup.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainGroup.Visible = false
MainGroup.BackgroundTransparency = 1
MainGroup.Active = true
Instance.new("UICorner", MainGroup).CornerRadius = UDim.new(0, 10)
local RGBStroke = Instance.new("UIStroke", MainGroup)
RGBStroke.Thickness = 2
RGBStroke.Color = Color3.new(0,1,0.5)

-- MINI LOGO
local MiniLogo = Instance.new("Frame", ScreenGui)
MiniLogo.Size = UDim2.new(0, 45, 0, 45)
MiniLogo.Position = UDim2.new(0, 20, 0, 20)
MiniLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MiniLogo.Visible = false
MiniLogo.Active = true
Instance.new("UICorner", MiniLogo).CornerRadius = UDim.new(1, 0)
local MiniStroke = Instance.new("UIStroke", MiniLogo)
MiniStroke.Thickness = 2
MiniStroke.Color = Color3.new(0,1,0.5)
local MiniText = Instance.new("TextLabel", MiniLogo)
MiniText.Size = UDim2.new(1, 0, 1, 0)
MiniText.Text = "B"
MiniText.TextColor3 = Color3.new(1,1,1)
MiniText.Font = Enum.Font.GothamBold
MiniText.TextSize = 24
MiniText.BackgroundTransparency = 1

-- BOSS RADAR
local StatusPanel = Instance.new("Frame", ScreenGui)
StatusPanel.Size = UDim2.new(0, 200, 0, 260)
StatusPanel.Position = UDim2.new(1, -220, 0.5, -130)
StatusPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatusPanel.Visible = false
StatusPanel.BackgroundTransparency = 1
Instance.new("UICorner", StatusPanel).CornerRadius = UDim.new(0, 10)
local StatusStroke = Instance.new("UIStroke", StatusPanel)
StatusStroke.Thickness = 2
StatusStroke.Color = Color3.new(0,1,0.5)

local StatusHeader = Instance.new("Frame", StatusPanel)
StatusHeader.Size = UDim2.new(1, 0, 0, 30)
StatusHeader.BackgroundTransparency = 1

local StatusTitle = Instance.new("TextLabel", StatusHeader)
StatusTitle.Size = UDim2.new(1, -30, 1, 0)
StatusTitle.Position = UDim2.new(0, 10, 0, 0)
StatusTitle.Text = "BOSS RADAR"
StatusTitle.TextColor3 = Color3.new(1,1,1)
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextSize = 12
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.BackgroundTransparency = 1

-- MINI RADAR
local MiniRadar = Instance.new("Frame", ScreenGui)
MiniRadar.Size = UDim2.new(0, 45, 0, 45)
MiniRadar.Position = UDim2.new(1, -60, 0.5, -22)
MiniRadar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MiniRadar.Visible = false
MiniRadar.Active = true
Instance.new("UICorner", MiniRadar).CornerRadius = UDim.new(1, 0)
local RadarStroke = Instance.new("UIStroke", MiniRadar)
RadarStroke.Thickness = 2
RadarStroke.Color = Color3.new(0,1,0.5)
local RadarText = Instance.new("TextLabel", MiniRadar)
RadarText.Size = UDim2.new(1, 0, 1, 0)
RadarText.Text = "🛰️"
RadarText.TextSize = 20
RadarText.BackgroundTransparency = 1
RadarText.TextColor3 = Color3.new(1,1,1)

local StatusScroll = Instance.new("ScrollingFrame", StatusPanel)
StatusScroll.Size = UDim2.new(1, -10, 1, -40)
StatusScroll.Position = UDim2.new(0, 5, 0, 35)
StatusScroll.BackgroundTransparency = 1
StatusScroll.ScrollBarThickness = 0
StatusScroll.CanvasSize = UDim2.new(0,0,0,0)
StatusScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local StatusListLayout = Instance.new("UIListLayout", StatusScroll)
StatusListLayout.Padding = UDim.new(0, 4)

local BossLabels = {}
for _, bName in ipairs(BossPriority) do
    local f = Instance.new("Frame", StatusScroll)
    f.Size = UDim2.new(1, -5, 0, 22)
    f.BackgroundTransparency = 1
    
    local n = Instance.new("TextLabel", f)
    n.Size = UDim2.new(0.7, 0, 1, 0)
    n.Text = " " .. bName
    n.TextColor3 = Color3.fromRGB(150, 150, 150)
    n.Font = Enum.Font.GothamMedium
    n.TextSize = 11
    n.BackgroundTransparency = 1
    n.TextXAlignment = Enum.TextXAlignment.Left
    
    local s = Instance.new("TextLabel", f)
    s.Size = UDim2.new(0.3, 0, 1, 0)
    s.Position = UDim2.new(0.7, 0, 0, 0)
    s.Text = "Wait..."
    s.TextColor3 = Color3.fromRGB(80, 80, 80)
    s.Font = Enum.Font.GothamBold
    s.TextSize = 10
    s.BackgroundTransparency = 1
    
    BossLabels[bName] = {Name = n, Stat = s}
end

-- [[ 3. ANIMATION LOGIC ]]
local function ToggleStatus(s)
    if s == "Min" then 
        TS:Create(StatusPanel, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function() StatusPanel.Visible = false; MiniRadar.Visible = true end)
    else 
        MiniRadar.Visible = false; StatusPanel.Visible = true
        TS:Create(StatusPanel, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
    end
end

local function ToggleUI(s)
    if s == "Min" then 
        TS:Create(MainGroup, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function() MainGroup.Visible = false; MiniLogo.Visible = true end)
    else 
        MiniLogo.Visible = false; MainGroup.Visible = true
        TS:Create(MainGroup, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end
end

local StatusMinBtn = Instance.new("TextButton", StatusHeader)
StatusMinBtn.Size = UDim2.new(0, 20, 0, 20)
StatusMinBtn.Position = UDim2.new(1, -25, 0.5, -10)
StatusMinBtn.Text = "-"
StatusMinBtn.TextColor3 = Color3.new(1,1,1)
StatusMinBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
StatusMinBtn.Font = Enum.Font.GothamBold
StatusMinBtn.TextSize = 14
StatusMinBtn.BorderSizePixel = 0
Instance.new("UICorner", StatusMinBtn).CornerRadius = UDim.new(1, 0)
StatusMinBtn.MouseButton1Click:Connect(function() ToggleStatus("Min") end)

local lastRadarClick, draggingRadar = 0, false
MiniRadar.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        lastRadarClick = tick() 
        draggingRadar = false 
    end 
end)

MiniRadar.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 and tick() - lastRadarClick < 0.2 and not draggingRadar then 
        ToggleStatus("Max") 
    end 
end)

local lastClickTime, draggingLogo = 0, false
MiniLogo.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        lastClickTime = tick() 
        draggingLogo = false 
    end 
end)

MiniLogo.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 and tick() - lastClickTime < 0.2 and not draggingLogo then 
        ToggleUI("Max") 
    end 
end)

-- CLICK CHO MINI RADAR
local lastRadarClick, draggingRadar = 0, false
MiniRadar.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        lastRadarClick = tick() 
        draggingRadar = false 
    end 
end)

MiniRadar.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 and tick() - lastRadarClick < 0.2 and not draggingRadar then 
        ToggleStatus("Max") 
    end 
end)

-- CLICK CHO MINI LOGO
local lastClickTime, draggingLogo = 0, false
MiniLogo.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        lastClickTime = tick() 
        draggingLogo = false 
    end 
end)

MiniLogo.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 and tick() - lastClickTime < 0.2 and not draggingLogo then 
        ToggleUI("Max") 
    end 
end)

local Header = Instance.new("Frame", MainGroup)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local RGBCircle = Instance.new("Frame", Header)
RGBCircle.Size = UDim2.new(0, 30, 0, 30)
RGBCircle.Position = UDim2.new(0, 12, 0.5, -15)
RGBCircle.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", RGBCircle).CornerRadius = UDim.new(1, 0)

local CircleStroke = Instance.new("UIStroke", RGBCircle)
CircleStroke.Thickness = 2
CircleStroke.Color = Color3.new(0,1,0.5)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 50, 0, 0)
Title.Text = "BinhDepTrai.Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0.5, -12)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)
MinBtn.MouseButton1Click:Connect(function() ToggleUI("Min") end)

local ContentHolder = Instance.new("Frame", MainGroup)
ContentHolder.Position = UDim2.new(0, 140, 0, 55)
ContentHolder.Size = UDim2.new(1, -150, 1, -60)
ContentHolder.BackgroundTransparency = 1
ContentHolder.ClipsDescendants = true

local function CreateTab()
    local f = Instance.new("ScrollingFrame", ContentHolder)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ScrollBarThickness = 0
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 5)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return f
end

local Tabs = { Farm = CreateTab(), Map = CreateTab(), Plyr = CreateTab(), Misc = CreateTab(), Visual = CreateTab() }
local CurrentTab = Tabs.Farm
CurrentTab.Visible = true

local SideBar = Instance.new("Frame", MainGroup)
SideBar.Size = UDim2.new(0, 125, 1, -60)
SideBar.Position = UDim2.new(0, 8, 0, 55)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 6)

local SL = Instance.new("UIListLayout", SideBar)
SL.Padding = UDim.new(0, 4)
SL.SortOrder = Enum.SortOrder.LayoutOrder

local SideBarPadding = Instance.new("UIPadding", SideBar)
SideBarPadding.PaddingTop = UDim.new(0, 6)

local function AddNav(name, tab)
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(0.9, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    b.Text = name
    b.TextColor3 = Color3.new(0.8,0.8,0.8)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function() 
        if CurrentTab == tab then return end 
        TS:Create(CurrentTab, TweenInfo.new(0.2), {Position = UDim2.new(0, 20, 0, 0)}):Play()
        task.wait(0.1)
        CurrentTab.Visible = false
        tab.Visible = true
        tab.Position = UDim2.new(0, -20, 0, 0)
        TS:Create(tab, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        CurrentTab = tab 
    end)
end

AddNav("FARM", Tabs.Farm)
AddNav("WORLD", Tabs.Map)
AddNav("PLAYERS", Tabs.Plyr)
AddNav("MISC", Tabs.Misc)
AddNav("VISUAL", Tabs.Visual)

task.delay(6, function() 
    MainGroup.Visible = true 
    TS:Create(MainGroup, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
    StatusPanel.Visible = true 
    TS:Create(StatusPanel, TweenInfo.new(1), {BackgroundTransparency = 0.2}):Play()
end)

-- [[ 4. DRAG LOGIC ]]
local function MakeDrag(obj)
    local dragging, dragInput, dragStart, startPos
    local titleBar = obj == MainGroup and Header or obj
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                end 
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end 
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDrag(MainGroup)
MakeDrag(MiniLogo)
MakeDrag(StatusPanel)
MakeDrag(MiniRadar)

-- [[ 5. FARM BOSS LOGIC ]]
task.spawn(function()
    while task.wait(0.5) do
        for bName, lbls in pairs(BossLabels) do
            local found = workspace:FindFirstChild(bName, true)
            if found and found:FindFirstChild("Humanoid") and found.Humanoid.Health > 0 then
                lbls.Name.TextColor3 = Color3.new(1, 1, 1)
                lbls.Stat.Text = "ALIVE"
                lbls.Stat.TextColor3 = Color3.new(0, 1, 0.5)
            else
                lbls.Name.TextColor3 = Color3.fromRGB(150, 150, 150)
                lbls.Stat.Text = "..."
                lbls.Stat.TextColor3 = Color3.fromRGB(80, 80, 80)
            end
        end
        
        local t = nil
        if Config.BossMode then
            for _, b in ipairs(BossPriority) do 
                if Config.SelectedBosses[b] then 
                    local v = workspace:FindFirstChild(b, true)
                    if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then 
                        t = v:FindFirstChild("HumanoidRootPart")
                        break 
                    end 
                end 
            end
        end
        CurrentTarget = t
    end
end)

RS.Heartbeat:Connect(function() 
    if Config.BossMode and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Player.Character.HumanoidRootPart
        if CurrentTarget then
            HRP.AssemblyLinearVelocity = Vector3.zero
            CurrentTarget.AssemblyLinearVelocity = Vector3.zero
            
            local targetPos = CurrentTarget.Position
            local backPos = targetPos - (CurrentTarget.CFrame.LookVector * Config.Dist) + Vector3.new(0, Config.Height, 0)
            local lookTarget = Vector3.new(targetPos.X, backPos.Y, targetPos.Z)
            
            HRP.CFrame = CFrame.lookAt(backPos, lookTarget)
            LastSafeCFrame = HRP.CFrame 
            
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPos)
            if onScreen then VIM:SendMouseMoveEvent(pos.X, pos.Y, game) end
        else
            HRP.AssemblyLinearVelocity = Vector3.zero
            if LastSafeCFrame then HRP.CFrame = LastSafeCFrame end
        end
    end
end)

task.spawn(function()
    while true do
        if Config.BossMode and CurrentTarget then
            for _, t in pairs(Player.Character:GetChildren()) do 
                if t:IsA("Tool") then 
                    t.Parent = Player.Backpack 
                end 
            end
            task.wait(0.2)
            
            for _, k in ipairs(Keys) do 
                VIM:SendKeyEvent(true, k, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, k, false, game)
                task.wait(0.2)
            end
            
            for _, t in pairs(Player.Backpack:GetChildren()) do 
                if t:IsA("Tool") then 
                    t.Parent = Player.Character 
                end 
            end
            task.wait(0.2)
            
            for _, k in ipairs(Keys) do 
                VIM:SendKeyEvent(true, k, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, k, false, game)
                task.wait(0.2)
            end
            
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
        task.wait(0.1)
    end
end)

-- [[ 6. UI COMPONENTS ]]
local function CreateBossDropdown(parent)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(0.98, 0, 0, 40)
    c.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)
    
    local t = Instance.new("TextLabel", c)
    t.Size = UDim2.new(1, -30, 1, 0)
    t.Position = UDim2.new(0, 10, 0, 0)
    t.Text = "BOSS LIST"
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    
    local l = Instance.new("Frame", parent)
    l.Size = UDim2.new(0.98, 0, 0, 0)
    l.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    l.ClipsDescendants = true
    l.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout", l)
    listLayout.Padding = UDim.new(0, 1)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local open = false
    c.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then 
            open = not open
            TS:Create(l, TweenInfo.new(0.3), {Size = open and UDim2.new(0.98, 0, 0, #BossPriority * 30) or UDim2.new(0.98, 0, 0, 0)}):Play()
        end 
    end)
    
    for _, boss in ipairs(BossPriority) do
        local b = Instance.new("TextButton", l)
        b.Size = UDim2.new(1, 0, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        b.Text = "  [+] " .. boss
        b.TextColor3 = Color3.fromRGB(150, 150, 150)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.BorderSizePixel = 0
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        
        b.MouseButton1Click:Connect(function() 
            Config.SelectedBosses[boss] = not Config.SelectedBosses[boss]
            b.TextColor3 = Config.SelectedBosses[boss] and Color3.new(0, 1, 0.5) or Color3.fromRGB(150, 150, 150)
            b.Text = Config.SelectedBosses[boss] and "  [✔] " .. boss or "  [+] " .. boss
        end)
    end
end

local function CreateSwitch(parent, text, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(0.98, 0, 0, 35)
    c.BackgroundTransparency = 1
    
    local b = Instance.new("TextButton", c)
    b.Size = UDim2.new(0, 45, 0, 22)
    b.Position = UDim2.new(1, -50, 0.5, -11)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    
    local l = Instance.new("TextLabel", c)
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local k = Instance.new("Frame", b)
    k.Size = UDim2.new(0, 18, 0, 18)
    k.Position = UDim2.new(0, 2, 0.5, -9)
    k.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)
    
    local s = false
    b.MouseButton1Click:Connect(function() 
        s = not s
        TS:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Back), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)}):Play()
        TS:Create(k, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = s and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        callback(s) 
    end)
end

CreateSwitch(Tabs.Farm, "AUTO FARM", function(v) Config.BossMode = v end)
CreateBossDropdown(Tabs.Farm)

-- [[ 7. WORLD TELEPORT ]]
for _, n in pairs({"Cutie", "Duck", "Judge", "Kyo", "Safe", "Sand", "Sans", "Sky", "Sword", "Tiny"}) do 
    local b = Instance.new("TextButton", Tabs.Map)
    b.Size = UDim2.new(0.98, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    b.Text = n .. " Island"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function() 
        local fullName = n == "Cutie" and "Cutie Noob Island" or
                        n == "Duck" and "Duck Island" or
                        n == "Judge" and "Judgement Island" or
                        n == "Kyo" and "Kyo Island" or
                        n == "Safe" and "Safe Zone Island" or
                        n == "Sand" and "Sand Island" or
                        n == "Sans" and "Sans Island" or
                        n == "Sky" and "Sky Island" or
                        n == "Sword" and "Sword Master Island" or
                        n == "Tiny" and "Tiny Statue Island"
        local t = workspace:FindFirstChild(fullName, true)
        if t and Player.Character then 
            Player.Character:PivotTo(t:GetPivot() * CFrame.new(0, 30, 0)) 
        end 
    end) 
end

-- [[ 8. PVP MODE UI ]]
local PvPTitle = Instance.new("TextLabel", Tabs.Plyr)
PvPTitle.Size = UDim2.new(0.98, 0, 0, 25)
PvPTitle.BackgroundTransparency = 1
PvPTitle.Text = "⚔️ PVP"
PvPTitle.TextColor3 = Color3.new(1, 1, 1)
PvPTitle.Font = Enum.Font.GothamBold
PvPTitle.TextSize = 14
PvPTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Player Dropdown với REFRESH bên trong
local PvPDropdown = Instance.new("Frame", Tabs.Plyr)
PvPDropdown.Size = UDim2.new(0.98, 0, 0, 35)
PvPDropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", PvPDropdown).CornerRadius = UDim.new(0, 6)

local PvPDropdownText = Instance.new("TextLabel", PvPDropdown)
PvPDropdownText.Size = UDim2.new(1, -50, 1, 0)
PvPDropdownText.Position = UDim2.new(0, 10, 0, 0)
PvPDropdownText.Text = "SELECT TARGET"
PvPDropdownText.TextColor3 = Color3.new(1, 1, 1)
PvPDropdownText.Font = Enum.Font.GothamBold
PvPDropdownText.TextSize = 12
PvPDropdownText.BackgroundTransparency = 1
PvPDropdownText.TextXAlignment = Enum.TextXAlignment.Left

local PvPArrow = Instance.new("TextLabel", PvPDropdown)
PvPArrow.Size = UDim2.new(0, 20, 1, 0)
PvPArrow.Position = UDim2.new(1, -25, 0, 0)
PvPArrow.Text = "▼"
PvPArrow.TextColor3 = Color3.new(1, 1, 1)
PvPArrow.Font = Enum.Font.GothamBold
PvPArrow.TextSize = 12
PvPArrow.BackgroundTransparency = 1

-- Refresh button trong dropdown
local PvPRefreshBtn = Instance.new("TextButton", PvPDropdown)
PvPRefreshBtn.Size = UDim2.new(0, 30, 0, 30)
PvPRefreshBtn.Position = UDim2.new(1, -60, 0.5, -15)
PvPRefreshBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PvPRefreshBtn.Text = "↻"
PvPRefreshBtn.TextColor3 = Color3.new(1, 1, 1)
PvPRefreshBtn.Font = Enum.Font.GothamBold
PvPRefreshBtn.TextSize = 16
PvPRefreshBtn.BorderSizePixel = 0
Instance.new("UICorner", PvPRefreshBtn).CornerRadius = UDim.new(1, 0)

-- Player List
local PvPList = Instance.new("ScrollingFrame", Tabs.Plyr)
PvPList.Size = UDim2.new(0.98, 0, 0, 0)
PvPList.Position = UDim2.new(0, 0, 0, 70)
PvPList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
PvPList.ClipsDescendants = true
PvPList.ScrollBarThickness = 3
PvPList.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
PvPList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PvPList.Visible = false
Instance.new("UICorner", PvPList).CornerRadius = UDim.new(0, 6)

local PvPListLayout = Instance.new("UIListLayout", PvPList)
PvPListLayout.Padding = UDim.new(0, 2)
PvPListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- STICK TO TARGET SWITCH
local StickFrame = Instance.new("Frame", Tabs.Plyr)
StickFrame.Size = UDim2.new(0.98, 0, 0, 35)
StickFrame.Position = UDim2.new(0, 0, 0, 110)
StickFrame.BackgroundTransparency = 1

local StickLabel = Instance.new("TextLabel", StickFrame)
StickLabel.Size = UDim2.new(0.7, 0, 1, 0)
StickLabel.Position = UDim2.new(0, 8, 0, 0)
StickLabel.Text = "🎯 STICK TO TARGET"
StickLabel.TextColor3 = Color3.new(1, 1, 1)
StickLabel.Font = Enum.Font.GothamBold
StickLabel.TextSize = 13
StickLabel.BackgroundTransparency = 1
StickLabel.TextXAlignment = Enum.TextXAlignment.Left

local StickSwitch = Instance.new("TextButton", StickFrame)
StickSwitch.Size = UDim2.new(0, 45, 0, 22)
StickSwitch.Position = UDim2.new(1, -50, 0.5, -11)
StickSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
StickSwitch.Text = ""
Instance.new("UICorner", StickSwitch).CornerRadius = UDim.new(1, 0)

local StickKnob = Instance.new("Frame", StickSwitch)
StickKnob.Size = UDim2.new(0, 18, 0, 18)
StickKnob.Position = UDim2.new(0, 2, 0.5, -9)
StickKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", StickKnob).CornerRadius = UDim.new(1, 0)

-- ATTACK PLAYER SWITCH
local AttackFrame = Instance.new("Frame", Tabs.Plyr)
AttackFrame.Size = UDim2.new(0.98, 0, 0, 35)
AttackFrame.Position = UDim2.new(0, 0, 0, 150)
AttackFrame.BackgroundTransparency = 1

local AttackLabel = Instance.new("TextLabel", AttackFrame)
AttackLabel.Size = UDim2.new(0.7, 0, 1, 0)
AttackLabel.Position = UDim2.new(0, 8, 0, 0)
AttackLabel.Text = "⚔️ ATTACK PLAYER"
AttackLabel.TextColor3 = Color3.new(1, 1, 1)
AttackLabel.Font = Enum.Font.GothamBold
AttackLabel.TextSize = 13
AttackLabel.BackgroundTransparency = 1
AttackLabel.TextXAlignment = Enum.TextXAlignment.Left

local AttackSwitch = Instance.new("TextButton", AttackFrame)
AttackSwitch.Size = UDim2.new(0, 45, 0, 22)
AttackSwitch.Position = UDim2.new(1, -50, 0.5, -11)
AttackSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AttackSwitch.Text = ""
Instance.new("UICorner", AttackSwitch).CornerRadius = UDim.new(1, 0)

local AttackKnob = Instance.new("Frame", AttackSwitch)
AttackKnob.Size = UDim2.new(0, 18, 0, 18)
AttackKnob.Position = UDim2.new(0, 2, 0.5, -9)
AttackKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AttackKnob).CornerRadius = UDim.new(1, 0)

-- EQUIP ALL SWITCH
local EquipFrame = Instance.new("Frame", Tabs.Plyr)
EquipFrame.Size = UDim2.new(0.98, 0, 0, 35)
EquipFrame.Position = UDim2.new(0, 0, 0, 190)
EquipFrame.BackgroundTransparency = 1

local EquipLabel = Instance.new("TextLabel", EquipFrame)
EquipLabel.Size = UDim2.new(0.7, 0, 1, 0)
EquipLabel.Position = UDim2.new(0, 8, 0, 0)
EquipLabel.Text = "🔧 EQUIP ALL"
EquipLabel.TextColor3 = Color3.new(1, 1, 1)
EquipLabel.Font = Enum.Font.GothamBold
EquipLabel.TextSize = 13
EquipLabel.BackgroundTransparency = 1
EquipLabel.TextXAlignment = Enum.TextXAlignment.Left

local EquipSwitch = Instance.new("TextButton", EquipFrame)
EquipSwitch.Size = UDim2.new(0, 45, 0, 22)
EquipSwitch.Position = UDim2.new(1, -50, 0.5, -11)
EquipSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
EquipSwitch.Text = ""
Instance.new("UICorner", EquipSwitch).CornerRadius = UDim.new(1, 0)

local EquipKnob = Instance.new("Frame", EquipSwitch)
EquipKnob.Size = UDim2.new(0, 18, 0, 18)
EquipKnob.Position = UDim2.new(0, 2, 0.5, -9)
EquipKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", EquipKnob).CornerRadius = UDim.new(1, 0)

-- Notification Function
local function showNotification(msg)
    local notif = Instance.new("Frame", ScreenGui)
    notif.Size = UDim2.new(0, 200, 0, 30)
    notif.Position = UDim2.new(0.5, -100, 0, 30)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notif.BackgroundTransparency = 1
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Thickness = 1
    stroke.Color = Color3.new(1, 0, 0)
    stroke.Transparency = 1
    
    local text = Instance.new("TextLabel", notif)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Text = msg
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.BackgroundTransparency = 1
    
    TS:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
    TS:Create(stroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    
    task.wait(1.5)
    
    TS:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    task.delay(0.5, function() notif:Destroy() end)
end

-- Refresh Player List Function
local function refreshPlayerList()
    for _, v in pairs(PvPList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local btn = Instance.new("TextButton", PvPList)
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.Text = ""
            btn.BorderSizePixel = 0
            
            local nameLabel = Instance.new("TextLabel", btn)
            nameLabel.Size = UDim2.new(1, -10, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.Text = p.DisplayName
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 11
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Hover effect
            btn.MouseEnter:Connect(function()
                TS:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                }):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                TS:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                }):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                Config.PvPTarget = p
                PvPDropdownText.Text = p.DisplayName
                
                -- Đóng dropdown
                TS:Create(PvPList, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0.98, 0, 0, 0)
                }):Play()
                TS:Create(PvPArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.delay(0.3, function() 
                    PvPList.Visible = false 
                    pvpOpen = false
                end)
                
                showNotification("✅ Selected: " .. p.DisplayName)
            end)
        end
    end
end

-- Refresh button click
PvPRefreshBtn.MouseButton1Click:Connect(function()
    refreshPlayerList()
    showNotification("🔄 Player list refreshed")
end)

-- Dropdown Logic
local pvpOpen = false
PvPDropdown.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        pvpOpen = not pvpOpen
        if pvpOpen then
            -- Refresh list before opening
            refreshPlayerList()
            
            PvPList.Visible = true
            PvPList.Size = UDim2.new(0.98, 0, 0, 0)
            TS:Create(PvPList, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0.98, 0, 0, 150)
            }):Play()
            TS:Create(PvPArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TS:Create(PvPList, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0.98, 0, 0, 0)
            }):Play()
            TS:Create(PvPArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            task.delay(0.3, function() PvPList.Visible = false end)
        end
    end
end)

-- STICK TO TARGET SWITCH LOGIC
StickSwitch.MouseButton1Click:Connect(function()
    if not Config.PvPTarget then
        showNotification("❌ Select a player first!")
        return
    end
    
    Config.PvPMode = not Config.PvPMode
    TS:Create(StickSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.PvPMode and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(StickKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.PvPMode and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Config.PvPMode then
        showNotification("✅ Sticking to: " .. Config.PvPTarget.DisplayName)
    end
end)

-- ATTACK PLAYER SWITCH LOGIC
AttackSwitch.MouseButton1Click:Connect(function()
    if not Config.PvPTarget then
        showNotification("❌ Select a player first!")
        return
    end
    
    if not Config.PvPMode then
        showNotification("❌ Enable STICK TO TARGET first!")
        return
    end
    
    Config.PvPAttack = not Config.PvPAttack
    TS:Create(AttackSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.PvPAttack and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(AttackKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.PvPAttack and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Config.PvPAttack then
        showNotification("⚔️ Attacking: " .. Config.PvPTarget.DisplayName)
    end
end)

-- EQUIP ALL SWITCH LOGIC
EquipSwitch.MouseButton1Click:Connect(function()
    Config.PvPEquipAll = not Config.PvPEquipAll
    TS:Create(EquipSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.PvPEquipAll and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(EquipKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.PvPEquipAll and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Config.PvPEquipAll and Player.Character then
        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Player.Character
            end
        end
        showNotification("🔧 All weapons equipped")
    end
end)

-- [[ 9. PVP COMBAT LOGIC ]]
task.spawn(function()
    while true do
        -- STICK TO TARGET - GIỐNG FARM BOSS NHƯNG CHỈ STICK
        if Config.PvPMode and Config.PvPTarget and Config.PvPTarget.Character and Config.PvPTarget.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = Config.PvPTarget.Character.HumanoidRootPart
            
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = Player.Character.HumanoidRootPart
                
                -- Giống y chang farm boss
                HRP.AssemblyLinearVelocity = Vector3.zero
                targetHRP.AssemblyLinearVelocity = Vector3.zero
                
                local targetPos = targetHRP.Position
                local backPos = targetPos - (targetHRP.CFrame.LookVector * Config.Dist) + Vector3.new(0, Config.Height, 0)
                local lookTarget = Vector3.new(targetPos.X, backPos.Y, targetPos.Z)
                
                HRP.CFrame = CFrame.lookAt(backPos, lookTarget)
                
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPos)
                if onScreen then VIM:SendMouseMoveEvent(pos.X, pos.Y, game) end
            end
        end
        
        -- ATTACK PLAYER - COMBO ĐẦY ĐỦ NHƯ FARM BOSS
        if Config.PvPAttack and Config.PvPTarget and Config.PvPTarget.Character and Config.PvPTarget.Character:FindFirstChild("HumanoidRootPart") then
            -- UNEQUIP ALL
            for _, t in pairs(Player.Character:GetChildren()) do 
                if t:IsA("Tool") then 
                    t.Parent = Player.Backpack 
                end 
            end
            task.wait(0.1)
            
            -- FIRST COMBO E,R,T,F
            for _, k in ipairs(Keys) do
                VIM:SendKeyEvent(true, k, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, k, false, game)
                task.wait(0.15)
            end
            
            -- EQUIP ALL (nếu bật)
            if Config.PvPEquipAll then
                for _, t in pairs(Player.Backpack:GetChildren()) do 
                    if t:IsA("Tool") then 
                        t.Parent = Player.Character 
                    end 
                end
            end
            task.wait(0.1)
            
            -- SECOND COMBO E,R,T,F
            for _, k in ipairs(Keys) do
                VIM:SendKeyEvent(true, k, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, k, false, game)
                task.wait(0.15)
            end
            
            -- CLICK ATTACK
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            
            task.wait(0.1)
        end
        task.wait(0.1)
    end
end)

-- [[ 10. DRAG SLIDER FUNCTION ]]
local function MakeSliderDraggable(sliderBtn, sliderBg, callback)
    local dragging = false
    local guiMain = MainGroup
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            guiMain.Active = false
            return true
        end
    end)
    
    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            guiMain.Active = true
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local sliderSize = sliderBg.AbsoluteSize.X
            local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize)
            local percent = relativeX / sliderSize
            callback(percent)
            sliderBtn.Position = UDim2.new(percent, -8, 0.5, -8)
        end
    end)
end

-- [[ 11. MISC TAB ]]
local FlySection = Instance.new("Frame", Tabs.Misc)
FlySection.Size = UDim2.new(0.98, 0, 0, 100)
FlySection.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", FlySection).CornerRadius = UDim.new(0, 6)

local FlyTitle = Instance.new("TextLabel", FlySection)
FlyTitle.Size = UDim2.new(1, -10, 0, 25)
FlyTitle.Position = UDim2.new(0, 8, 0, 5)
FlyTitle.Text = "🕊️ FLY"
FlyTitle.TextColor3 = Color3.new(1, 1, 1)
FlyTitle.Font = Enum.Font.GothamBold
FlyTitle.TextSize = 14
FlyTitle.BackgroundTransparency = 1
FlyTitle.TextXAlignment = Enum.TextXAlignment.Left

local FlySwitchBtn = Instance.new("TextButton", FlySection)
FlySwitchBtn.Size = UDim2.new(0, 45, 0, 22)
FlySwitchBtn.Position = UDim2.new(1, -50, 0, 7)
FlySwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
FlySwitchBtn.Text = ""
Instance.new("UICorner", FlySwitchBtn).CornerRadius = UDim.new(1, 0)

local FlySwitchKnob = Instance.new("Frame", FlySwitchBtn)
FlySwitchKnob.Size = UDim2.new(0, 18, 0, 18)
FlySwitchKnob.Position = UDim2.new(0, 2, 0.5, -9)
FlySwitchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", FlySwitchKnob).CornerRadius = UDim.new(1, 0)

local FlySpeedLabel = Instance.new("TextLabel", FlySection)
FlySpeedLabel.Size = UDim2.new(1, -10, 0, 20)
FlySpeedLabel.Position = UDim2.new(0, 8, 0, 35)
FlySpeedLabel.Text = "SPEED: 250"
FlySpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FlySpeedLabel.Font = Enum.Font.GothamMedium
FlySpeedLabel.TextSize = 11
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local FlySpeedSliderBg = Instance.new("Frame", FlySection)
FlySpeedSliderBg.Size = UDim2.new(0.9, 0, 0, 6)
FlySpeedSliderBg.Position = UDim2.new(0.05, 0, 0, 60)
FlySpeedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", FlySpeedSliderBg).CornerRadius = UDim.new(1, 0)

local FlySpeedSliderBtn = Instance.new("Frame", FlySpeedSliderBg)
FlySpeedSliderBtn.Size = UDim2.new(0, 16, 0, 16)
FlySpeedSliderBtn.Position = UDim2.new((Config.FlySpeed-100)/900, -8, 0.5, -8)
FlySpeedSliderBtn.BackgroundColor3 = Color3.new(0, 1, 0.5)
Instance.new("UICorner", FlySpeedSliderBtn).CornerRadius = UDim.new(1, 0)

-- Walk Speed Section
local WalkSection = Instance.new("Frame", Tabs.Misc)
WalkSection.Size = UDim2.new(0.98, 0, 0, 100)
WalkSection.Position = UDim2.new(0, 0, 0, 105)
WalkSection.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", WalkSection).CornerRadius = UDim.new(0, 6)

local WalkTitle = Instance.new("TextLabel", WalkSection)
WalkTitle.Size = UDim2.new(1, -10, 0, 25)
WalkTitle.Position = UDim2.new(0, 8, 0, 5)
WalkTitle.Text = "👟 WALK"
WalkTitle.TextColor3 = Color3.new(1, 1, 1)
WalkTitle.Font = Enum.Font.GothamBold
WalkTitle.TextSize = 14
WalkTitle.BackgroundTransparency = 1
WalkTitle.TextXAlignment = Enum.TextXAlignment.Left

local WalkSwitchBtn = Instance.new("TextButton", WalkSection)
WalkSwitchBtn.Size = UDim2.new(0, 45, 0, 22)
WalkSwitchBtn.Position = UDim2.new(1, -50, 0, 7)
WalkSwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
WalkSwitchBtn.Text = ""
Instance.new("UICorner", WalkSwitchBtn).CornerRadius = UDim.new(1, 0)

local WalkSwitchKnob = Instance.new("Frame", WalkSwitchBtn)
WalkSwitchKnob.Size = UDim2.new(0, 18, 0, 18)
WalkSwitchKnob.Position = UDim2.new(0, 2, 0.5, -9)
WalkSwitchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", WalkSwitchKnob).CornerRadius = UDim.new(1, 0)

local WalkSpeedLabel = Instance.new("TextLabel", WalkSection)
WalkSpeedLabel.Size = UDim2.new(1, -10, 0, 20)
WalkSpeedLabel.Position = UDim2.new(0, 8, 0, 35)
WalkSpeedLabel.Text = "SPEED: 16"
WalkSpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
WalkSpeedLabel.Font = Enum.Font.GothamMedium
WalkSpeedLabel.TextSize = 11
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local WalkSpeedSliderBg = Instance.new("Frame", WalkSection)
WalkSpeedSliderBg.Size = UDim2.new(0.9, 0, 0, 6)
WalkSpeedSliderBg.Position = UDim2.new(0.05, 0, 0, 60)
WalkSpeedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", WalkSpeedSliderBg).CornerRadius = UDim.new(1, 0)

local WalkSpeedSliderBtn = Instance.new("Frame", WalkSpeedSliderBg)
WalkSpeedSliderBtn.Size = UDim2.new(0, 16, 0, 16)
WalkSpeedSliderBtn.Position = UDim2.new((Config.WalkSpeed-16)/100, -8, 0.5, -8)
WalkSpeedSliderBtn.BackgroundColor3 = Color3.new(0, 1, 0.5)
Instance.new("UICorner", WalkSpeedSliderBtn).CornerRadius = UDim.new(1, 0)

-- Jump Section
local JumpSection = Instance.new("Frame", Tabs.Misc)
JumpSection.Size = UDim2.new(0.98, 0, 0, 100)
JumpSection.Position = UDim2.new(0, 0, 0, 210)
JumpSection.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", JumpSection).CornerRadius = UDim.new(0, 6)

local JumpTitle = Instance.new("TextLabel", JumpSection)
JumpTitle.Size = UDim2.new(1, -10, 0, 25)
JumpTitle.Position = UDim2.new(0, 8, 0, 5)
JumpTitle.Text = "🦘 JUMP"
JumpTitle.TextColor3 = Color3.new(1, 1, 1)
JumpTitle.Font = Enum.Font.GothamBold
JumpTitle.TextSize = 14
JumpTitle.BackgroundTransparency = 1
JumpTitle.TextXAlignment = Enum.TextXAlignment.Left

local JumpSwitchBtn = Instance.new("TextButton", JumpSection)
JumpSwitchBtn.Size = UDim2.new(0, 45, 0, 22)
JumpSwitchBtn.Position = UDim2.new(1, -50, 0, 7)
JumpSwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
JumpSwitchBtn.Text = ""
Instance.new("UICorner", JumpSwitchBtn).CornerRadius = UDim.new(1, 0)

local JumpSwitchKnob = Instance.new("Frame", JumpSwitchBtn)
JumpSwitchKnob.Size = UDim2.new(0, 18, 0, 18)
JumpSwitchKnob.Position = UDim2.new(0, 2, 0.5, -9)
JumpSwitchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", JumpSwitchKnob).CornerRadius = UDim.new(1, 0)

local JumpHeightLabel = Instance.new("TextLabel", JumpSection)
JumpHeightLabel.Size = UDim2.new(1, -10, 0, 20)
JumpHeightLabel.Position = UDim2.new(0, 8, 0, 35)
JumpHeightLabel.Text = "HEIGHT: 50"
JumpHeightLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
JumpHeightLabel.Font = Enum.Font.GothamMedium
JumpHeightLabel.TextSize = 11
JumpHeightLabel.BackgroundTransparency = 1
JumpHeightLabel.TextXAlignment = Enum.TextXAlignment.Left

local JumpHeightSliderBg = Instance.new("Frame", JumpSection)
JumpHeightSliderBg.Size = UDim2.new(0.9, 0, 0, 6)
JumpHeightSliderBg.Position = UDim2.new(0.05, 0, 0, 60)
JumpHeightSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", JumpHeightSliderBg).CornerRadius = UDim.new(1, 0)

local JumpHeightSliderBtn = Instance.new("Frame", JumpHeightSliderBg)
JumpHeightSliderBtn.Size = UDim2.new(0, 16, 0, 16)
JumpHeightSliderBtn.Position = UDim2.new((Config.JumpHeight-50)/200, -8, 0.5, -8)
JumpHeightSliderBtn.BackgroundColor3 = Color3.new(0, 1, 0.5)
Instance.new("UICorner", JumpHeightSliderBtn).CornerRadius = UDim.new(1, 0)

-- Slider Drag
MakeSliderDraggable(FlySpeedSliderBtn, FlySpeedSliderBg, function(p)
    Config.FlySpeed = math.floor(100 + p * 900)
    FlySpeedLabel.Text = "SPEED: " .. Config.FlySpeed
end)

MakeSliderDraggable(WalkSpeedSliderBtn, WalkSpeedSliderBg, function(p)
    Config.WalkSpeed = math.floor(16 + p * 100)
    WalkSpeedLabel.Text = "SPEED: " .. Config.WalkSpeed
    if Config.WalkSpeedEnabled and Player.Character then
        Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

MakeSliderDraggable(JumpHeightSliderBtn, JumpHeightSliderBg, function(p)
    Config.JumpHeight = 50 + p * 200
    JumpHeightLabel.Text = "HEIGHT: " .. math.floor(Config.JumpHeight)
    if Config.JumpHeightEnabled and Player.Character then
        Player.Character.Humanoid.JumpPower = Config.JumpHeight
    end
end)

-- Fly Logic
FlySwitchBtn.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    TS:Create(FlySwitchBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.FlyEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(FlySwitchKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.FlyEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Config.FlyEnabled then
        local flyLoop
        flyLoop = RS.Heartbeat:Connect(function()
            if not Config.FlyEnabled or not Player.Character then return end
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local bv = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
            bv.Name = "BodyVelocity"
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.Parent = hrp
            
            local moveDir = Vector3.new()
            local cam = workspace.CurrentCamera
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
            
            bv.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * Config.FlySpeed or Vector3.new(0,0,0)
        end)
    else
        if Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
end)

-- Walk Speed Logic
WalkSwitchBtn.MouseButton1Click:Connect(function()
    Config.WalkSpeedEnabled = not Config.WalkSpeedEnabled
    TS:Create(WalkSwitchBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.WalkSpeedEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(WalkSwitchKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.WalkSpeedEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Player.Character then
        if Config.WalkSpeedEnabled then
            Config.OriginalWalkSpeed = Player.Character.Humanoid.WalkSpeed
            Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        else
            Player.Character.Humanoid.WalkSpeed = Config.OriginalWalkSpeed
        end
    end
end)

-- Jump Logic
JumpSwitchBtn.MouseButton1Click:Connect(function()
    Config.JumpHeightEnabled = not Config.JumpHeightEnabled
    TS:Create(JumpSwitchBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.JumpHeightEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(JumpSwitchKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.JumpHeightEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Player.Character then
        if Config.JumpHeightEnabled then
            Config.OriginalJumpPower = Player.Character.Humanoid.JumpPower
            Player.Character.Humanoid.JumpPower = Config.JumpHeight
        else
            Player.Character.Humanoid.JumpPower = Config.OriginalJumpPower or 50
        end
    end
end)

-- [[ VISUAL TAB - COMPLETE WITH 10 SCENERY ]]

-- Function to save original colors
local function saveOriginalColors()
    Config.OriginalColors = {}
    if not Player.Character then return end
    
    for _, part in pairs(Player.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            Config.OriginalColors[part] = {
                BrickColor = part.BrickColor,
                Material = part.Material,
                Color = part.Color
            }
        end
    end
    
    for _, tool in pairs(Player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, part in pairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    Config.OriginalColors[part] = {
                        BrickColor = part.BrickColor,
                        Material = part.Material,
                        Color = part.Color
                    }
                end
            end
        end
    end
end

-- Function to restore original colors
local function restoreOriginalColors()
    if not Player.Character then return end
    
    for part, original in pairs(Config.OriginalColors) do
        if part and part.Parent then
            part.BrickColor = original.BrickColor
            part.Material = original.Material
            part.Color = original.Color
        end
    end
end

-- Save colors on load
task.wait(1)
saveOriginalColors()

-- Save colors when character respawns
Player.CharacterAdded:Connect(function()
    task.wait(1)
    saveOriginalColors()
end)

-- RAINBOW SECTION
local RainbowFrame = Instance.new("Frame", Tabs.Visual)
RainbowFrame.Size = UDim2.new(0.98, 0, 0, 40)
RainbowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", RainbowFrame).CornerRadius = UDim.new(0, 6)

local RainbowTitle = Instance.new("TextLabel", RainbowFrame)
RainbowTitle.Size = UDim2.new(0.6, 0, 1, 0)
RainbowTitle.Position = UDim2.new(0, 10, 0, 0)
RainbowTitle.Text = "🌈 RAINBOW"
RainbowTitle.TextColor3 = Color3.new(1, 1, 1)
RainbowTitle.Font = Enum.Font.GothamBold
RainbowTitle.TextSize = 14
RainbowTitle.BackgroundTransparency = 1
RainbowTitle.TextXAlignment = Enum.TextXAlignment.Left

local RainbowSwitch = Instance.new("TextButton", RainbowFrame)
RainbowSwitch.Size = UDim2.new(0, 45, 0, 22)
RainbowSwitch.Position = UDim2.new(1, -50, 0.5, -11)
RainbowSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
RainbowSwitch.Text = ""
Instance.new("UICorner", RainbowSwitch).CornerRadius = UDim.new(1, 0)

local RainbowKnob = Instance.new("Frame", RainbowSwitch)
RainbowKnob.Size = UDim2.new(0, 18, 0, 18)
RainbowKnob.Position = UDim2.new(0, 2, 0.5, -9)
RainbowKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", RainbowKnob).CornerRadius = UDim.new(1, 0)

-- FULLBRIGHT SECTION
local FullbrightFrame = Instance.new("Frame", Tabs.Visual)
FullbrightFrame.Size = UDim2.new(0.98, 0, 0, 40)
FullbrightFrame.Position = UDim2.new(0, 0, 0, 45)
FullbrightFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", FullbrightFrame).CornerRadius = UDim.new(0, 6)

local FullbrightTitle = Instance.new("TextLabel", FullbrightFrame)
FullbrightTitle.Size = UDim2.new(0.6, 0, 1, 0)
FullbrightTitle.Position = UDim2.new(0, 10, 0, 0)
FullbrightTitle.Text = "☀️ FULLBRIGHT"
FullbrightTitle.TextColor3 = Color3.new(1, 1, 1)
FullbrightTitle.Font = Enum.Font.GothamBold
FullbrightTitle.TextSize = 14
FullbrightTitle.BackgroundTransparency = 1
FullbrightTitle.TextXAlignment = Enum.TextXAlignment.Left

local FullbrightSwitch = Instance.new("TextButton", FullbrightFrame)
FullbrightSwitch.Size = UDim2.new(0, 45, 0, 22)
FullbrightSwitch.Position = UDim2.new(1, -50, 0.5, -11)
FullbrightSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
FullbrightSwitch.Text = ""
Instance.new("UICorner", FullbrightSwitch).CornerRadius = UDim.new(1, 0)

local FullbrightKnob = Instance.new("Frame", FullbrightSwitch)
FullbrightKnob.Size = UDim2.new(0, 18, 0, 18)
FullbrightKnob.Position = UDim2.new(0, 2, 0.5, -9)
FullbrightKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", FullbrightKnob).CornerRadius = UDim.new(1, 0)

-- ESP SECTION
local ESPFrame = Instance.new("Frame", Tabs.Visual)
ESPFrame.Size = UDim2.new(0.98, 0, 0, 40)
ESPFrame.Position = UDim2.new(0, 0, 0, 90)
ESPFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", ESPFrame).CornerRadius = UDim.new(0, 6)

local ESPTitle = Instance.new("TextLabel", ESPFrame)
ESPTitle.Size = UDim2.new(0.6, 0, 1, 0)
ESPTitle.Position = UDim2.new(0, 10, 0, 0)
ESPTitle.Text = "👁️ ESP"
ESPTitle.TextColor3 = Color3.new(1, 1, 1)
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.TextSize = 14
ESPTitle.BackgroundTransparency = 1
ESPTitle.TextXAlignment = Enum.TextXAlignment.Left

local ESPSwitch = Instance.new("TextButton", ESPFrame)
ESPSwitch.Size = UDim2.new(0, 45, 0, 22)
ESPSwitch.Position = UDim2.new(1, -50, 0.5, -11)
ESPSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ESPSwitch.Text = ""
Instance.new("UICorner", ESPSwitch).CornerRadius = UDim.new(1, 0)

local ESPKnob = Instance.new("Frame", ESPSwitch)
ESPKnob.Size = UDim2.new(0, 18, 0, 18)
ESPKnob.Position = UDim2.new(0, 2, 0.5, -9)
ESPKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ESPKnob).CornerRadius = UDim.new(1, 0)



-- SCENERY SECTION
local SceneryFrame = Instance.new("Frame", Tabs.Visual)
SceneryFrame.Size = UDim2.new(0.98, 0, 0, 180)
SceneryFrame.Position = UDim2.new(0, 0, 0, 135)
SceneryFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", SceneryFrame).CornerRadius = UDim.new(0, 6)

local SceneryTitle = Instance.new("TextLabel", SceneryFrame)
SceneryTitle.Size = UDim2.new(0.6, 0, 0, 30)
SceneryTitle.Position = UDim2.new(0, 10, 0, 5)
SceneryTitle.Text = "🎨 SCENERY"
SceneryTitle.TextColor3 = Color3.new(1, 1, 1)
SceneryTitle.Font = Enum.Font.GothamBold
SceneryTitle.TextSize = 16
SceneryTitle.BackgroundTransparency = 1
SceneryTitle.TextXAlignment = Enum.TextXAlignment.Left

-- SCENERY SWITCH
local ScenerySwitch = Instance.new("TextButton", SceneryFrame)
ScenerySwitch.Size = UDim2.new(0, 45, 0, 22)
ScenerySwitch.Position = UDim2.new(1, -50, 0, 9)
ScenerySwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ScenerySwitch.Text = ""
Instance.new("UICorner", ScenerySwitch).CornerRadius = UDim.new(1, 0)

local SceneryKnob = Instance.new("Frame", ScenerySwitch)
SceneryKnob.Size = UDim2.new(0, 18, 0, 18)
SceneryKnob.Position = UDim2.new(0, 2, 0.5, -9)
SceneryKnob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SceneryKnob).CornerRadius = UDim.new(1, 0)

-- SCENERY DROPDOWN
local SceneryDropdown = Instance.new("Frame", SceneryFrame)
SceneryDropdown.Size = UDim2.new(0.9, 0, 0, 35)
SceneryDropdown.Position = UDim2.new(0.05, 0, 0, 40)
SceneryDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", SceneryDropdown).CornerRadius = UDim.new(0, 6)
SceneryDropdown.ClipsDescendants = true

local ScenerySelected = Instance.new("TextLabel", SceneryDropdown)
ScenerySelected.Size = UDim2.new(1, -30, 1, 0)
ScenerySelected.Position = UDim2.new(0, 10, 0, 0)
ScenerySelected.Text = Config.SelectedScenery or "AURORA"
ScenerySelected.TextColor3 = Color3.new(1, 1, 1)
ScenerySelected.Font = Enum.Font.GothamBold
ScenerySelected.TextSize = 13
ScenerySelected.BackgroundTransparency = 1
ScenerySelected.TextXAlignment = Enum.TextXAlignment.Left

local SceneryArrow = Instance.new("TextLabel", SceneryDropdown)
SceneryArrow.Size = UDim2.new(0, 20, 1, 0)
SceneryArrow.Position = UDim2.new(1, -25, 0, 0)
SceneryArrow.Text = "▼"
SceneryArrow.TextColor3 = Color3.new(1, 1, 1)
SceneryArrow.Font = Enum.Font.GothamBold
SceneryArrow.TextSize = 14
SceneryArrow.BackgroundTransparency = 1

-- SCENERY OPTIONS (SCROLLING)
local SceneryOptions = Instance.new("Frame", SceneryFrame)
SceneryOptions.Size = UDim2.new(0.9, 0, 0, 0)
SceneryOptions.Position = UDim2.new(0.05, 0, 0, 75)
SceneryOptions.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SceneryOptions.ClipsDescendants = true
SceneryOptions.Visible = false
SceneryOptions.ZIndex = 10
Instance.new("UICorner", SceneryOptions).CornerRadius = UDim.new(0, 6)

local SceneryScroller = Instance.new("ScrollingFrame", SceneryOptions)
SceneryScroller.Size = UDim2.new(1, -8, 1, -8)
SceneryScroller.Position = UDim2.new(0, 4, 0, 4)
SceneryScroller.BackgroundTransparency = 1
SceneryScroller.ScrollBarThickness = 4
SceneryScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
SceneryScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
SceneryScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
SceneryScroller.BorderSizePixel = 0
SceneryScroller.ZIndex = 11

local SceneryListLayout = Instance.new("UIListLayout", SceneryScroller)
SceneryListLayout.Padding = UDim.new(0, 2)
SceneryListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 10 SCENERY OPTIONS
local SceneryList = {
    {name = "SUNSET", icon = "🌅"},
    {name = "NIGHT", icon = "🌙"},
    {name = "DAWN", icon = "🌄"},
    {name = "MIDNIGHT", icon = "⭐"},
    {name = "AURORA", icon = "✨"},
    {name = "STORM", icon = "⛈️"},
    {name = "CHERRY", icon = "🌸"},
    {name = "GALAXY", icon = "🌌"},
    {name = "SUNRISE", icon = "☀️"},
    {name = "TWILIGHT", icon = "🌆"}
}

for _, opt in ipairs(SceneryList) do
    local btn = Instance.new("TextButton", SceneryScroller)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 12
    
    local icon = Instance.new("TextLabel", btn)
    icon.Size = UDim2.new(0, 25, 1, 0)
    icon.Position = UDim2.new(0, 5, 0, 0)
    icon.Text = opt.icon
    icon.TextColor3 = Color3.new(1, 1, 1)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 16
    icon.BackgroundTransparency = 1
    icon.ZIndex = 13
    
    local nameLabel = Instance.new("TextLabel", btn)
    nameLabel.Size = UDim2.new(1, -35, 1, 0)
    nameLabel.Position = UDim2.new(0, 35, 0, 0)
    nameLabel.Text = opt.name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 13
    
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        ScenerySelected.Text = opt.name
        Config.SelectedScenery = opt.name
        
        -- Apply ngay lập tức
        if Config.SceneryEnabled then
            applyScenery(opt.name)
        end
        
        -- Đóng dropdown
        TS:Create(SceneryOptions, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0.9, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        TS:Create(SceneryArrow, TweenInfo.new(0.2), {
            Rotation = 0
        }):Play()
        task.delay(0.3, function()
            SceneryOptions.Visible = false
        end)
    end)
end

-- DROPDOWN CLICK
SceneryDropdown.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if SceneryOptions.Visible then
            TS:Create(SceneryOptions, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0.9, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            TS:Create(SceneryArrow, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            task.delay(0.3, function()
                SceneryOptions.Visible = false
            end)
        else
            SceneryOptions.Visible = true
            SceneryOptions.BackgroundTransparency = 1
            SceneryOptions.Size = UDim2.new(0.9, 0, 0, 0)
            
            TS:Create(SceneryOptions, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
                Size = UDim2.new(0.9, 0, 0, 150),
                BackgroundTransparency = 0
            }):Play()
            TS:Create(SceneryArrow, TweenInfo.new(0.3), {
                Rotation = 180
            }):Play()
        end
    end
end)

-- RAINBOW SWITCH
RainbowSwitch.MouseButton1Click:Connect(function()
    Config.RainbowEnabled = not Config.RainbowEnabled
    TS:Create(RainbowSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.RainbowEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(RainbowKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.RainbowEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if not Config.RainbowEnabled then
        restoreOriginalColors()
    end
end)

-- FULLBRIGHT SWITCH
FullbrightSwitch.MouseButton1Click:Connect(function()
    Config.FullBrightEnabled = not Config.FullBrightEnabled
    TS:Create(FullbrightSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.FullBrightEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(FullbrightKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.FullBrightEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    local lighting = game:GetService("Lighting")
    if Config.FullBrightEnabled then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        lighting.ColorShift_Top = Color3.new(1, 1, 1)
        lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        lighting.FogColor = Color3.new(1, 1, 1)
    else
        lighting.Brightness = 1
        lighting.ClockTime = 14
        lighting.GlobalShadows = true
        lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        lighting.ColorShift_Top = Color3.new(1, 1, 1)
        lighting.ColorShift_Bottom = Color3.new(0.5, 0.5, 0.5)
        lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
    end
end)

-- ESP SWITCH
local ESPConnection = nil
ESPSwitch.MouseButton1Click:Connect(function()
    Config.ESPEnabled = not Config.ESPEnabled
    TS:Create(ESPSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.ESPEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(ESPKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.ESPEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Config.ESPEnabled then
        local function createESP(player)
            if player == Player then return end
            if not player.Character then return end
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            if not hrp or not head then return end
            
            -- Remove old
            local oldBox = player.Character:FindFirstChild("ESP_Box")
            local oldName = player.Character:FindFirstChild("ESP_Name")
            if oldBox then oldBox:Destroy() end
            if oldName then oldName:Destroy() end
            
            -- Box
            local espBox = Instance.new("BoxHandleAdornment")
            espBox.Name = "ESP_Box"
            espBox.Size = Vector3.new(4, 6, 4)
            espBox.Color3 = Color3.new(0, 1, 0.5)
            espBox.Transparency = 0.5
            espBox.AlwaysOnTop = true
            espBox.Adornee = hrp
            espBox.Parent = player.Character
            
            -- Name
            local espName = Instance.new("BillboardGui")
            espName.Name = "ESP_Name"
            espName.Size = UDim2.new(0, 80, 0, 20)
            espName.StudsOffset = Vector3.new(0, 3, 0)
            espName.AlwaysOnTop = true
            espName.Adornee = head
            
            local nameLabel = Instance.new("TextLabel", espName)
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.new(0, 1, 0.5)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.TextStrokeTransparency = 0
            
            espName.Parent = player.Character
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        ESPConnection = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                task.wait(0.5)
                createESP(player)
            end)
        end)
        
        for _, player in pairs(Players:GetPlayers()) do
            player.CharacterAdded:Connect(function()
                task.wait(0.5)
                createESP(player)
            end)
        end
    else
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local box = player.Character:FindFirstChild("ESP_Box")
                local name = player.Character:FindFirstChild("ESP_Name")
                if box then box:Destroy() end
                if name then name:Destroy() end
            end
        end
    end
end)

-- SCENERY SWITCH
ScenerySwitch.MouseButton1Click:Connect(function()
    Config.SceneryEnabled = not Config.SceneryEnabled
    TS:Create(ScenerySwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Config.SceneryEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)
    }):Play()
    TS:Create(SceneryKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = Config.SceneryEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    }):Play()
    
    if Config.SceneryEnabled then
        applyScenery(Config.SelectedScenery)
    else
        -- Reset lighting
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 1
        lighting.ClockTime = 14
        lighting.GlobalShadows = true
        lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        lighting.ColorShift_Top = Color3.new(1, 1, 1)
        lighting.ColorShift_Bottom = Color3.new(0.5, 0.5, 0.5)
        lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
        
        if Config.ScenerySky then
            Config.ScenerySky:Destroy()
            Config.ScenerySky = nil
        end
    end
end)



-- RAINBOW LOOP
task.spawn(function()
    while true do
        if Config.RainbowEnabled and Player.Character then
            Config.RainbowHue = (Config.RainbowHue + 0.01) % 1
            local color = Color3.fromHSV(Config.RainbowHue, 1, 1)
            
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.BrickColor = BrickColor.new(color)
                    part.Material = Enum.Material.Neon
                    part.Color = color
                end
            end
            
            for _, tool in pairs(Player.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, part in pairs(tool:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.BrickColor = BrickColor.new(color)
                            part.Material = Enum.Material.Neon
                            part.Color = color
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

-- SCENERY FUNCTION
function applyScenery(sceneryType)
    local lighting = game:GetService("Lighting")
    
    if Config.ScenerySky then
        Config.ScenerySky:Destroy()
        Config.ScenerySky = nil
    end
    
    local sky = Instance.new("Sky")
    sky.Name = "ScenerySky"
    sky.StarCount = 5000
    
    -- Skybox cho từng cảnh
    if sceneryType == "SUNSET" or sceneryType == "DAWN" or sceneryType == "SUNRISE" or sceneryType == "CHERRY" then
        sky.SkyboxBk = "rbxassetid://1415760678"
        sky.SkyboxDn = "rbxassetid://1415760678"
        sky.SkyboxFt = "rbxassetid://1415760678"
        sky.SkyboxLf = "rbxassetid://1415760678"
        sky.SkyboxRt = "rbxassetid://1415760678"
        sky.SkyboxUp = "rbxassetid://1415760678"
    else
        sky.SkyboxBk = "rbxassetid://160333334"
        sky.SkyboxDn = "rbxassetid://160333334"
        sky.SkyboxFt = "rbxassetid://160333334"
        sky.SkyboxLf = "rbxassetid://160333334"
        sky.SkyboxRt = "rbxassetid://160333334"
        sky.SkyboxUp = "rbxassetid://160333334"
    end
    
    -- Cấu hình cho 10 cảnh
    if sceneryType == "SUNSET" then
        lighting.ClockTime = 18
        lighting.Brightness = 0.8
        lighting.OutdoorAmbient = Color3.new(0.5, 0.3, 0.2)
        lighting.ColorShift_Top = Color3.new(1, 0.7, 0.4)
        lighting.ColorShift_Bottom = Color3.new(0.4, 0.2, 0.1)
        lighting.FogColor = Color3.new(0.8, 0.4, 0.2)
        sky.MoonAngularSize = 10
        
    elseif sceneryType == "NIGHT" then
        lighting.ClockTime = 0
        lighting.Brightness = 0.3
        lighting.OutdoorAmbient = Color3.new(0.1, 0.1, 0.2)
        lighting.ColorShift_Top = Color3.new(0.2, 0.2, 0.4)
        lighting.ColorShift_Bottom = Color3.new(0.05, 0.05, 0.1)
        lighting.FogColor = Color3.new(0.1, 0.1, 0.15)
        sky.MoonAngularSize = 20
        sky.StarCount = 8000
        
    elseif sceneryType == "DAWN" then
        lighting.ClockTime = 6
        lighting.Brightness = 0.7
        lighting.OutdoorAmbient = Color3.new(0.5, 0.4, 0.4)
        lighting.ColorShift_Top = Color3.new(0.9, 0.6, 0.5)
        lighting.ColorShift_Bottom = Color3.new(0.4, 0.3, 0.3)
        lighting.FogColor = Color3.new(0.7, 0.5, 0.4)
        sky.MoonAngularSize = 5
        
    elseif sceneryType == "MIDNIGHT" then
        lighting.ClockTime = 1
        lighting.Brightness = 0.15
        lighting.OutdoorAmbient = Color3.new(0.05, 0.05, 0.1)
        lighting.ColorShift_Top = Color3.new(0.1, 0.1, 0.2)
        lighting.ColorShift_Bottom = Color3.new(0.02, 0.02, 0.05)
        lighting.FogColor = Color3.new(0.03, 0.03, 0.06)
        sky.MoonAngularSize = 25
        sky.StarCount = 10000
        
    elseif sceneryType == "AURORA" then
        lighting.ClockTime = 22
        lighting.Brightness = 0.4
        lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.3)
        lighting.ColorShift_Top = Color3.new(0.3, 0.5, 0.7)
        lighting.ColorShift_Bottom = Color3.new(0.1, 0.2, 0.3)
        lighting.FogColor = Color3.new(0.2, 0.3, 0.4)
        sky.MoonAngularSize = 15
        sky.StarCount = 6000
        
    elseif sceneryType == "STORM" then
        lighting.ClockTime = 15
        lighting.Brightness = 0.2
        lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
        lighting.ColorShift_Top = Color3.new(0.3, 0.3, 0.3)
        lighting.ColorShift_Bottom = Color3.new(0.1, 0.1, 0.1)
        lighting.FogColor = Color3.new(0.2, 0.2, 0.2)
        sky.MoonAngularSize = 0
        
    elseif sceneryType == "CHERRY" then
        lighting.ClockTime = 17
        lighting.Brightness = 0.8
        lighting.OutdoorAmbient = Color3.new(0.5, 0.3, 0.3)
        lighting.ColorShift_Top = Color3.new(1, 0.6, 0.6)
        lighting.ColorShift_Bottom = Color3.new(0.4, 0.2, 0.2)
        lighting.FogColor = Color3.new(0.9, 0.5, 0.5)
        sky.MoonAngularSize = 8
        
    elseif sceneryType == "GALAXY" then
        lighting.ClockTime = 0
        lighting.Brightness = 0.25
        lighting.OutdoorAmbient = Color3.new(0.15, 0.1, 0.2)
        lighting.ColorShift_Top = Color3.new(0.4, 0.2, 0.5)
        lighting.ColorShift_Bottom = Color3.new(0.1, 0.05, 0.15)
        lighting.FogColor = Color3.new(0.2, 0.1, 0.2)
        sky.MoonAngularSize = 12
        sky.StarCount = 8000
        
    elseif sceneryType == "SUNRISE" then
        lighting.ClockTime = 5
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.new(0.6, 0.4, 0.3)
        lighting.ColorShift_Top = Color3.new(1, 0.8, 0.4)
        lighting.ColorShift_Bottom = Color3.new(0.5, 0.3, 0.2)
        lighting.FogColor = Color3.new(1, 0.7, 0.3)
        sky.MoonAngularSize = 3
        
    elseif sceneryType == "TWILIGHT" then
        lighting.ClockTime = 19
        lighting.Brightness = 0.5
        lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.4)
        lighting.ColorShift_Top = Color3.new(0.3, 0.4, 0.7)
        lighting.ColorShift_Bottom = Color3.new(0.1, 0.15, 0.3)
        lighting.FogColor = Color3.new(0.3, 0.3, 0.5)
        sky.MoonAngularSize = 18
        sky.StarCount = 4000
    end
    
    sky.Parent = lighting
    Config.ScenerySky = sky
    lighting.GlobalShadows = true
    lighting.FogEnd = 100000
end

-- Apply default scenery
applyScenery(Config.SelectedScenery)


-- [[ 14. RGB EFFECT ]]
task.spawn(function() 
    while true do 
        local c = Color3.fromHSV(tick()%5/5, 0.7, 1)
        RGBStroke.Color = c
        RGBCircle.BackgroundColor3 = c
        CircleStroke.Color = c
        MiniStroke.Color = c
        MiniText.TextColor3 = c
        StatusStroke.Color = c
        RadarStroke.Color = c
        task.wait() 
    end 
end)
