-- [[ BINHDEPTRAI.HUB - ULTIMATE EDITION v17 ]]
-- Hướng dẫn: Nhấn [ K ] để ẩn/hiện Menu
-- Tính năng: Auto Farm (Sau lưng), Auto Boss, Smart Combo (Fruit & Sword), Player TP

local Config = {
    Active = false, 
    BossMode = false, 
    Dist = 7, 
    Height = 4, 
    TargetName = "" 
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Keys = {"E", "R", "T", "F"}
local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}
local ValidIslands = {"Cutie Noob Island", "Duck Island", "Judgement Island", "Kyo Island", "Safe Zone Island", "Sand Island", "Sans Island", "Sky Island", "Sword Master Island", "Tiny Statue Island"}
local CurrentTarget = nil

-- [[ 1. UI ENGINE & DRAGGABLE ]]
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "BinhDepTrai_V17_Final"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("CanvasGroup", ScreenGui)
MainFrame.Size = UDim2.new(0, 700, 0, 520); MainFrame.Position = UDim2.new(0.5, -350, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12); MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local RGBStroke = Instance.new("UIStroke", MainFrame); RGBStroke.Thickness = 3; RGBStroke.ApplyStrokeMode = "Border"

-- Kéo thả Menu
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 70); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 30, 0, 0)
Title.Text = "BinhDepTrai.Hub"; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 26; Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextXAlignment = "Left"

local MiniBtn = Instance.new("TextButton", Header)
MiniBtn.Size = UDim2.new(0, 40, 0, 40); MiniBtn.Position = UDim2.new(1, -55, 0, 15)
MiniBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); MiniBtn.Text = "—"; MiniBtn.TextColor3 = Color3.new(1,1,1); MiniBtn.Font = "GothamBold"; MiniBtn.TextSize = 20; Instance.new("UICorner", MiniBtn)

-- Sidebar & Content
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 180, 1, -90); SideBar.Position = UDim2.new(0, 20, 0, 80)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22); Instance.new("UICorner", SideBar)
Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 10); Instance.new("UIPadding", SideBar).PaddingTop = UDim.new(0, 10)

local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Position = UDim2.new(0, 215, 0, 80); ContentHolder.Size = UDim2.new(1, -235, 1, -90); ContentHolder.BackgroundTransparency = 1

local function CreateTab()
    local f = Instance.new("CanvasGroup", ContentHolder)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.GroupTransparency = 1
    local scroll = Instance.new("ScrollingFrame", f)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 0
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)
    return f
end

local Tabs = { Farm = CreateTab(), Map = CreateTab(), Plyr = CreateTab() }
local CurrentTab = Tabs.Farm; CurrentTab.Visible = true; CurrentTab.GroupTransparency = 0

-- Chuyển Tab (Scale Effect)
local function SwitchTab(newTab)
    if newTab == CurrentTab then return end
    TS:Create(CurrentTab, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0.8, 0, 0.8, 0), GroupTransparency = 1}):Play()
    task.wait(0.2); CurrentTab.Visible = false
    newTab.Visible = true; newTab.Size = UDim2.new(0.8, 0, 0.8, 0); newTab.GroupTransparency = 1
    TS:Create(newTab, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0), GroupTransparency = 0}):Play()
    CurrentTab = newTab
end

local function AddNav(name, tab)
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(0.9, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    b.Text = name; b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "GothamBold"; b.TextSize = 14; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() SwitchTab(tab) end)
end
AddNav("FARMING", Tabs.Farm); AddNav("WORLD", Tabs.Map); AddNav("PLAYERS", Tabs.Plyr)

-- [[ 2. UI COMPONENTS (TOGGLES & BUTTONS) ]]
local function CreateToggleSwitch(parent, text, defaultValue, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.98, 0, 0, 60); container.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.Text = text; label.TextColor3 = Color3.new(1,1,1); label.Font = "GothamBold"; label.TextSize = 16; label.BackgroundTransparency = 1; label.TextXAlignment = "Left"
    local switchBg = Instance.new("TextButton", container)
    switchBg.Size = UDim2.new(0, 60, 0, 30); switchBg.Position = UDim2.new(1, -70, 0.5, -15); switchBg.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60); switchBg.Text = ""; Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", switchBg)
    knob.Size = UDim2.new(0, 26, 0, 26); knob.Position = defaultValue and UDim2.new(1, -28, 0, 2) or UDim2.new(0, 2, 0, 2); knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local isActive = defaultValue
    switchBg.MouseButton1Click:Connect(function()
        isActive = not isActive
        TS:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = isActive and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)}):Play()
        TS:Create(knob, TweenInfo.new(0.2), {Position = isActive and UDim2.new(1, -28, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
        callback(isActive)
    end)
end

local function AddBtn(text, parentTab, callback)
    local b = Instance.new("TextButton", parentTab:FindFirstChildOfClass("ScrollingFrame"))
    b.Size = UDim2.new(0.98, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 15; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback); return b
end

-- Farm Tab Setup
local farmScroll = Tabs.Farm:FindFirstChildOfClass("ScrollingFrame")
local TargetInput = Instance.new("TextBox", farmScroll)
TargetInput.Size = UDim2.new(0.98, 0, 0, 55); TargetInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20); TargetInput.PlaceholderText = "Mob Name..."; TargetInput.TextColor3 = Color3.new(1,1,1); TargetInput.Font = "GothamBold"; TargetInput.TextSize = 15; Instance.new("UICorner", TargetInput)
TargetInput.FocusLost:Connect(function() Config.TargetName = TargetInput.Text end)

CreateToggleSwitch(farmScroll, "Auto Farm Mob", Config.Active, function(v) Config.Active = v end)
CreateToggleSwitch(farmScroll, "Auto Farm Boss", Config.BossMode, function(v) Config.BossMode = v end)

-- World & Player Tab Setup
for _, name in pairs(ValidIslands) do AddBtn(name, Tabs.Map, function() local t = workspace:FindFirstChild(name, true); if t then Player.Character:PivotTo(t:GetPivot() * CFrame.new(0, 55, 0)) end end) end
local function RefreshPlayers()
    local scroll = Tabs.Plyr:FindFirstChildOfClass("ScrollingFrame")
    for _, child in pairs(scroll:GetChildren()) do if child:IsA("TextButton") and child.Text ~= "REFRESH LIST" then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do if p ~= Player then AddBtn(p.DisplayName, Tabs.Plyr, function() if p.Character then Player.Character:PivotTo(p.Character:GetPivot()) end end) end end
end
AddBtn("REFRESH LIST", Tabs.Plyr, RefreshPlayers); RefreshPlayers()

-- [[ 3. COMBAT ENGINE (SMART FLOW) ]]
task.spawn(function()
    while true do
        if (Config.Active or Config.BossMode) and CurrentTarget then
            -- GIAI ĐOẠN 1: DÙNG CHIÊU FRUIT (KHÔNG CẦM ĐỒ)
            for _, t in pairs(Player.Character:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Backpack end end
            task.wait(0.1)
            for i=1,2 do -- Combo E,R,T,F 2 lần
                for _, key in pairs(Keys) do
                    VIM:SendKeyEvent(true, key, false, game); task.wait(0.05); VIM:SendKeyEvent(false, key, false, game); task.wait(0.1)
                end
            end

            -- GIAI ĐOẠN 2: EQUIP ALL (CẦM KIẾM/SÚNG)
            for _, t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Character end end
            task.wait(0.1)
            for i=1,2 do -- Combo E,R,T,F 2 lần khi cầm đồ
                for _, key in pairs(Keys) do
                    VIM:SendKeyEvent(true, key, false, game); task.wait(0.05); VIM:SendKeyEvent(false, key, false, game); task.wait(0.1)
                end
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.1); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1) -- Click
            end

            -- GIAI ĐOẠN 3: UNEQUIP ĐỂ LẶP LẠI
            for _, t in pairs(Player.Character:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Backpack end end
            task.wait(0.3)
        end
        task.wait(0.1)
    end
end)

-- Tìm Mục Tiêu & Di Chuyển Sau Lưng
task.spawn(function()
    while task.wait(0.5) do
        if Config.Active or Config.BossMode then
            local target = nil
            if Config.BossMode then
                for _, b in pairs(BossList) do for _, v in pairs(workspace:GetDescendants()) do if v.Name == b and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then target = v:FindFirstChild("HumanoidRootPart") break end end if target then break end end
            else
                local dist = 1000
                for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Humanoid") and v.Health > 0 and v.Parent ~= Player.Character and not Players:GetPlayerFromCharacter(v.Parent) then local hrp = v.Parent:FindFirstChild("HumanoidRootPart"); if hrp and (Config.TargetName == "" or v.Parent.Name:find(Config.TargetName)) then target = hrp break end end end
            end
            CurrentTarget = target
        end
    end
end)

RS.Heartbeat:Connect(function()
    if (Config.Active or Config.BossMode) and CurrentTarget and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        root.AssemblyLinearVelocity = Vector3.zero
        -- Luôn bám sát sau lưng (CFrame.new(0, Cao, KhoảngCách))
        root.CFrame = root.CFrame:Lerp(CurrentTarget.CFrame * CFrame.new(0, Config.Height, Config.Dist), 0.25)
    end
end)

-- RGB & Toggle
task.spawn(function() while true do RGBStroke.Color = Color3.fromHSV(tick()%5/5, 0.7, 1); task.wait() end end)
local function ToggleHub()
    if MainFrame.Visible then TS:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0), GroupTransparency = 1}):Play(); task.delay(0.3, function() MainFrame.Visible = false end)
    else MainFrame.Visible = true; MainFrame.Size = UDim2.new(0,0,0,0); TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0,700,0,520), GroupTransparency = 0}):Play() end
end
MiniBtn.MouseButton1Click:Connect(ToggleHub); UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.K then ToggleHub() end end)

đây là cái hoạn thiện nè, từ lúc ông thêm aim bot vs chuối xuống nó bị lỗi, h ông thêm vô đây đi
