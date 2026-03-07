-- [[ BINHDEPTRAI.HUB - v37 THE MASTERPIECE ]]
local Config = { BossMode = false, GodMode = false, Dist = 7, Height = 4 }
local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")

local Keys = {"E", "R", "T", "F"}
local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}
local ValidIslands = {"Cutie Noob Island", "Duck Island", "Judgement Island", "Kyo Island", "Safe Zone Island", "Sand Island", "Sans Island", "Sky Island", "Sword Master Island", "Tiny Statue Island"}
local CurrentTarget = nil

-- [[ 1. NOTIFICATION SYSTEM (FIXED) ]]
local function SendNotify(title, text, color)
    local n = Instance.new("ScreenGui", Player.PlayerGui)
    local f = Instance.new("Frame", n)
    f.Size = UDim2.new(0, 220, 0, 70); f.Position = UDim2.new(1, 10, 1, -80); f.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color or Color3.new(0, 1, 0.5); s.Thickness = 2
    local t1 = Instance.new("TextLabel", f); t1.Size = UDim2.new(1, 0, 0, 30); t1.Text = title; t1.TextColor3 = s.Color; t1.Font = "GothamBold"; t1.TextSize = 14; t1.BackgroundTransparency = 1
    local t2 = Instance.new("TextLabel", f); t2.Size = UDim2.new(1, 0, 0, 30); t2.Position = UDim2.new(0, 0, 0, 30); t2.Text = text; t2.TextColor3 = Color3.new(1, 1, 1); t2.Font = "Gotham"; t2.TextSize = 13; t2.BackgroundTransparency = 1
    TS:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -230, 1, -80)}):Play()
    task.delay(2, function() 
        TS:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 1, -80)}):Play()
        task.wait(0.5); n:Destroy()
    end)
end

-- [[ 2. UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "BinhDepTrai_V37"; ScreenGui.ResetOnSpawn = false

local MainGroup = Instance.new("CanvasGroup", ScreenGui)
MainGroup.Size = UDim2.new(0, 700, 0, 520); MainGroup.Position = UDim2.new(0.5, -350, 0.5, -260)
MainGroup.BackgroundColor3 = Color3.fromRGB(10, 10, 12); MainGroup.BorderSizePixel = 0; MainGroup.GroupTransparency = 1
Instance.new("UICorner", MainGroup).CornerRadius = UDim.new(0, 15)
local RGBStroke = Instance.new("UIStroke", MainGroup); RGBStroke.Thickness = 3; RGBStroke.ApplyStrokeMode = "Border"

-- Header & Intro Text
local Header = Instance.new("Frame", MainGroup); Header.Size = UDim2.new(1, 0, 0, 70); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(0, 400, 1, 0); Title.Position = UDim2.new(0, -300, 0, 0)
Title.Text = "BinhDepTrai.Hub"; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 24; Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextXAlignment = "Left"; Title.TextTransparency = 1
local RGBCircle = Instance.new("Frame", Header); RGBCircle.Size = UDim2.new(0, 35, 0, 35); RGBCircle.Position = UDim2.new(0, 25, 0.5, -17.5); RGBCircle.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", RGBCircle).CornerRadius = UDim.new(1, 0); RGBCircle.BackgroundTransparency = 1
local CircleStroke = Instance.new("UIStroke", RGBCircle); CircleStroke.Thickness = 2; CircleStroke.Transparency = 1

-- Sidebar & Content
local SideBar = Instance.new("Frame", MainGroup); SideBar.Size = UDim2.new(0, 180, 1, -90); SideBar.Position = UDim2.new(0, 20, 0, 80); SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22); Instance.new("UICorner", SideBar)
Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 10); Instance.new("UIPadding", SideBar).PaddingTop = UDim.new(0, 10)
local ContentHolder = Instance.new("Frame", MainGroup); ContentHolder.Position = UDim2.new(0, 215, 0, 80); ContentHolder.Size = UDim2.new(1, -235, 1, -90); ContentHolder.BackgroundTransparency = 1; ContentHolder.ClipsDescendants = true

local function CreateTab()
    local f = Instance.new("ScrollingFrame", ContentHolder); f.Size = UDim2.new(1, 0, 1, 0); f.Position = UDim2.new(0, 0, 0, 0); f.BackgroundTransparency = 1; f.Visible = false; f.ScrollBarThickness = 0
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 10); return f
end
local Tabs = { Farm = CreateTab(), Map = CreateTab(), Plyr = CreateTab() }
local CurrentTab = Tabs.Farm; CurrentTab.Visible = true

-- [[ 3. ANIMATION LOGIC ]]

-- CINEMATIC INTRO (6 GIÂY)
task.spawn(function()
    MainGroup.Visible = true
    TS:Create(Title, TweenInfo.new(6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 75, 0, 0), TextTransparency = 0}):Play()
    task.wait(4.5)
    TS:Create(RGBCircle, TweenInfo.new(1.5), {BackgroundTransparency = 0}):Play()
    TS:Create(CircleStroke, TweenInfo.new(1.5), {Transparency = 0}):Play()
    TS:Create(MainGroup, TweenInfo.new(2), {GroupTransparency = 0}):Play()
    SendNotify("BinhDepTrai.Hub", "Executed Successfully!", Color3.new(0, 1, 0.5))
end)

-- TOGGLE K WITH SCALE & FADE & NOTIFY
local IsOpen = true
local function ToggleUI()
    IsOpen = not IsOpen
    if IsOpen then
        MainGroup.Visible = true
        TS:Create(MainGroup, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {GroupTransparency = 0, Size = UDim2.new(0, 700, 0, 520)}):Play()
        SendNotify("BinhDepTrai.Hub", "Menu: ON", Color3.new(0, 0.8, 1))
    else
        TS:Create(MainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1, Size = UDim2.new(0, 650, 0, 480)}):Play()
        task.delay(0.3, function() if not IsOpen then MainGroup.Visible = false end end)
        SendNotify("BinhDepTrai.Hub", "Menu: OFF", Color3.fromRGB(255, 50, 50))
    end
end
UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.K then ToggleUI() end end)

-- TAB SWITCH (SMOOTH SLIDE)
local function SwitchTab(newTab)
    if newTab == CurrentTab then return end
    CurrentTab.Visible = false
    newTab.Visible = true
    newTab.Position = UDim2.new(0, 0, 0.1, 0)
    TS:Create(newTab, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    CurrentTab = newTab
end

local function AddNav(name, tab)
    local b = Instance.new("TextButton", SideBar); b.Size = UDim2.new(0.9, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(28, 28, 38); b.Text = name; b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "GothamBold"; b.TextSize = 14; Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() SwitchTab(tab) end)
end
AddNav("FARMING", Tabs.Farm); AddNav("WORLD", Tabs.Map); AddNav("PLAYERS", Tabs.Plyr)

-- [[ 4. COMPONENTS & LOGIC (BOSS ONLY) ]]
local function CreateToggle(parent, text, defaultValue, callback)
    local container = Instance.new("Frame", parent); container.Size = UDim2.new(0.98, 0, 0, 60); container.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", container); label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.Text = text; label.TextColor3 = Color3.new(1,1,1); label.Font = "GothamBold"; label.TextSize = 16; label.BackgroundTransparency = 1; label.TextXAlignment = "Left"
    local switchBg = Instance.new("TextButton", container); switchBg.Size = UDim2.new(0, 60, 0, 30); switchBg.Position = UDim2.new(1, -70, 0.5, -15); switchBg.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60); switchBg.Text = ""; Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", switchBg); knob.Size = UDim2.new(0, 26, 0, 26); knob.Position = defaultValue and UDim2.new(1, -28, 0, 2) or UDim2.new(0, 2, 0, 2); knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local active = defaultValue
    switchBg.MouseButton1Click:Connect(function() active = not active; TS:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)}):Play(); TS:Create(knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -28, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play(); callback(active) end)
end
local function AddBtn(text, parentTab, callback)
    local b = Instance.new("TextButton", parentTab); b.Size = UDim2.new(0.98, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 15; Instance.new("UICorner", b); b.MouseButton1Click:Connect(callback)
end

CreateToggle(Tabs.Farm, "Auto Farm Boss", Config.BossMode, function(v) Config.BossMode = v end)
CreateToggle(Tabs.Farm, "GOD MODE (Distance)", Config.GodMode, function(v) Config.GodMode = v end)
for _, name in pairs(ValidIslands) do AddBtn(name, Tabs.Map, function() local t = workspace:FindFirstChild(name, true); if t then Player.Character:PivotTo(t:GetPivot() * CFrame.new(0, 55, 0)) end end) end
local function RefreshPlayers()
    for _, c in pairs(Tabs.Plyr:GetChildren()) do if c:IsA("TextButton") and c.Text ~= "REFRESH LIST" then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do if p ~= Player then AddBtn(p.DisplayName, Tabs.Plyr, function() if p.Character then Player.Character:PivotTo(p.Character:GetPivot()) end end) end end
end
AddBtn("REFRESH LIST", Tabs.Plyr, RefreshPlayers); RefreshPlayers()

-- BOSS HUNTER LOGIC
task.spawn(function()
    while task.wait(0.3) do
        local target = nil
        if Config.BossMode then
            for _, b in pairs(BossList) do for _, v in pairs(workspace:GetDescendants()) do if v.Name == b and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then target = v:FindFirstChild("HumanoidRootPart") break end end if target then break end end
        end
        CurrentTarget = target
    end
end)
RS.Heartbeat:Connect(function()
    if Config.BossMode and CurrentTarget and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart; root.AssemblyLinearVelocity = Vector3.zero
        for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        local h, d = (Config.GodMode and 20 or Config.Height), (Config.GodMode and 10 or Config.Dist)
        root.CFrame = root.CFrame:Lerp(CFrame.lookAt((CurrentTarget.CFrame * CFrame.new(0, h, d)).Position, CurrentTarget.Position), 0.25)
    end
end)
task.spawn(function()
    while true do
        if Config.BossMode and CurrentTarget then
            for _, t in pairs(Player.Character:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Backpack end end
            task.wait(0.1); for i=1,2 do for _, k in pairs(Keys) do VIM:SendKeyEvent(true, k, false, game); task.wait(0.05); VIM:SendKeyEvent(false, k, false, game); task.wait(0.1) end end
            for _, t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Character end end
            task.wait(0.1); for i=1,2 do for _, k in pairs(Keys) do VIM:SendKeyEvent(true, k, false, game); task.wait(0.05); VIM:SendKeyEvent(false, k, false, game); task.wait(0.1) end; VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.1); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1) end
            task.wait(0.2)
        end
        task.wait(0.1)
    end
end)

-- RGB & Drag
local dragS, dragSt, stP
MainGroup.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true; dragSt = i.Position; stP = MainGroup.Position end end)
UIS.InputChanged:Connect(function(i) if dragS and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragSt; MainGroup.Position = UDim2.new(stP.X.Scale, stP.X.Offset + d.X, stP.Y.Scale, stP.Y.Offset + d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)
task.spawn(function() while true do local c = Color3.fromHSV(tick()%5/5, 0.7, 1); RGBStroke.Color = c; RGBCircle.BackgroundColor3 = c; CircleStroke.Color = c; task.wait() end end)
