-- [[ BINHDEPTRAI.HUB - ZERO SPACE EDITION ]]
repeat task.wait() until game:IsLoaded()

local Config = { BossMode = false, Dist = 2.5, Height = 3, IsAtSafe = false, SelectedBosses = {} }
local Player = game.Players.LocalPlayer
local RS, VIM, UIS, TS = game:GetService("RunService"), game:GetService("VirtualInputManager"), game:GetService("UserInputService"), game:GetService("TweenService")
local Players = game:GetService("Players")

local Keys = {"E", "R", "T", "F"}
local BossPriority = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Sans", "Sword Master", "Cutie Boss", "King Noob", "Nooby", "Unknown Boss"}
local CurrentTarget = nil

-- [[ 1. INTRO (CLEAN) ]]
local IntroGui = Instance.new("ScreenGui", (game:GetService("CoreGui") or Player.PlayerGui))
local IntroFrame = Instance.new("Frame", IntroGui); IntroFrame.Size = UDim2.new(0, 200, 0, 200); IntroFrame.Position = UDim2.new(0.5, -100, 0.5, -100); IntroFrame.BackgroundTransparency = 1
local IntroBar = Instance.new("Frame", IntroFrame); IntroBar.Size = UDim2.new(0, 0, 0, 4); IntroBar.Position = UDim2.new(0, 0, 0.8, 0); IntroBar.BackgroundColor3 = Color3.new(0, 1, 0.5)
task.spawn(function() TS:Create(IntroBar, TweenInfo.new(5.5), {Size = UDim2.new(1, 0, 0, 4)}):Play(); task.wait(6); IntroGui:Destroy() end)

-- [[ 2. MAIN UI ]]
local ScreenGui = Instance.new("ScreenGui", (game:GetService("CoreGui") or Player.PlayerGui)); ScreenGui.Name = "BinhDepTrai_ZeroSpace"
local MainGroup = Instance.new("CanvasGroup", ScreenGui); MainGroup.Size = UDim2.new(0, 650, 0, 450); MainGroup.Position = UDim2.new(0.5, -325, 0.5, -225); MainGroup.BackgroundColor3 = Color3.fromRGB(10, 10, 12); MainGroup.GroupTransparency = 1; MainGroup.Visible = false
Instance.new("UICorner", MainGroup).CornerRadius = UDim.new(0, 12)
local RGBStroke = Instance.new("UIStroke", MainGroup); RGBStroke.Thickness = 3

-- Minimize & Logo Fix
local MiniLogo = Instance.new("Frame", ScreenGui); MiniLogo.Size = UDim2.new(0, 55, 0, 55); MiniLogo.Position = UDim2.new(0, 30, 0, 30); MiniLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MiniLogo.Visible = false; Instance.new("UICorner", MiniLogo).CornerRadius = UDim.new(1, 0)
local MiniStroke = Instance.new("UIStroke", MiniLogo); MiniStroke.Thickness = 3
local MiniText = Instance.new("TextLabel", MiniLogo); MiniText.Size = UDim2.new(1, 0, 1, 0); MiniText.Text = "B"; MiniText.TextColor3 = Color3.new(1,1,1); MiniText.Font = "GothamBold"; MiniText.TextSize = 28; MiniText.BackgroundTransparency = 1

local function ToggleUI(s)
    if s == "Min" then TS:Create(MainGroup, TweenInfo.new(0.3), {GroupTransparency = 1}):Play(); task.delay(0.3, function() MainGroup.Visible = false; MiniLogo.Visible = true end)
    else MiniLogo.Visible = false; MainGroup.Visible = true; TS:Create(MainGroup, TweenInfo.new(0.3), {GroupTransparency = 0}):Play() end
end
MiniLogo.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then ToggleUI("Max") end end)

local Header = Instance.new("Frame", MainGroup); Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundTransparency = 1
local RGBCircle = Instance.new("Frame", Header); RGBCircle.Size = UDim2.new(0, 30, 0, 30); RGBCircle.Position = UDim2.new(0, 15, 0.5, -15); RGBCircle.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", RGBCircle).CornerRadius = UDim.new(1, 0)
local CircleStroke = Instance.new("UIStroke", RGBCircle); CircleStroke.Thickness = 2
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 55, 0, 0); Title.Text = "BinhDepTrai.Hub"; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 20; Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextXAlignment = "Left"
local MinBtn = Instance.new("TextButton", Header); MinBtn.Size = UDim2.new(0, 25, 0, 25); MinBtn.Position = UDim2.new(1, -35, 0.5, -12); MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); MinBtn.Font = "GothamBold"; Instance.new("UICorner", MinBtn); MinBtn.MouseButton1Click:Connect(function() ToggleUI("Min") end)

local ContentHolder = Instance.new("Frame", MainGroup); ContentHolder.Position = UDim2.new(0, 175, 0, 60); ContentHolder.Size = UDim2.new(1, -187, 1, -70); ContentHolder.BackgroundTransparency = 1; ContentHolder.ClipsDescendants = true

local function CreateTab()
    local f = Instance.new("ScrollingFrame", ContentHolder); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.ScrollBarThickness = 0
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.CanvasSize = UDim2.new(0, 0, 0, 0) -- FIX SPACE
    local l = Instance.new("UIListLayout", f); l.Padding = UDim.new(0, 5); return f
end
local Tabs = { Farm = CreateTab(), Map = CreateTab(), Plyr = CreateTab() }
local CurrentTab = Tabs.Farm; CurrentTab.Visible = true

local SideBar = Instance.new("Frame", MainGroup); SideBar.Size = UDim2.new(0, 150, 1, -70); SideBar.Position = UDim2.new(0, 12, 0, 60); SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22); Instance.new("UICorner", SideBar)
local SL = Instance.new("UIListLayout", SideBar); SL.Padding = UDim.new(0, 5); Instance.new("UIPadding", SideBar).PaddingTop = UDim.new(0, 8)

local function AddNav(name, tab)
    local b = Instance.new("TextButton", SideBar); b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(28, 28, 38); b.Text = name; b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "GothamBold"; b.TextSize = 12; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() if CurrentTab == tab then return end TS:Create(CurrentTab, TweenInfo.new(0.2), {Position = UDim2.new(0, 30, 0, 0)}):Play(); task.wait(0.1); CurrentTab.Visible = false; tab.Visible = true; tab.Position = UDim2.new(0, -30, 0, 0); TS:Create(tab, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play(); CurrentTab = tab end)
end
AddNav("FARMING", Tabs.Farm); AddNav("WORLD", Tabs.Map); AddNav("PLAYERS", Tabs.Plyr)
task.delay(6, function() MainGroup.Visible = true; TS:Create(MainGroup, TweenInfo.new(1), {GroupTransparency = 0}):Play() end)

-- [[ 3. LOGIC & COMBO (0.5S) ]]
task.spawn(function()
    while task.wait(0.5) do
        local t = nil
        if Config.BossMode then
            for _, b in ipairs(BossPriority) do if Config.SelectedBosses[b] then local v = workspace:FindFirstChild(b, true); if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then t = v:FindFirstChild("HumanoidRootPart"); break end end end
            if not t and not Config.IsAtSafe then local s = workspace:FindFirstChild("Safe Zone Island", true); if s and Player.Character then Player.Character:PivotTo(s:GetPivot() * CFrame.new(0, 20, 0)); Config.IsAtSafe = true end
            elseif t then Config.IsAtSafe = false end
        end
        CurrentTarget = t
    end
end)

RS.Heartbeat:Connect(function() if Config.BossMode and CurrentTarget and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero; Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame:Lerp(CFrame.lookAt((CurrentTarget.CFrame * CFrame.new(0, Config.Height, Config.Dist)).Position, CurrentTarget.Position), 0.25) end end)

task.spawn(function()
    while true do
        if Config.BossMode and CurrentTarget then
            for _, t in pairs(Player.Character:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Backpack end end; task.wait(0.5)
            for _, k in ipairs(Keys) do VIM:SendKeyEvent(true, k, false, game); task.wait(0.05); VIM:SendKeyEvent(false, k, false, game); task.wait(0.5) end
            for _, t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Character end end; task.wait(0.5)
            for _, k in ipairs(Keys) do VIM:SendKeyEvent(true, k, false, game); task.wait(0.05); VIM:SendKeyEvent(false, k, false, game); task.wait(0.5) end
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.05); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
        task.wait(0.1)
    end
end)

-- [[ 4. COMPONENTS (CLEAN) ]]
local function CreateBossDropdown(parent)
    local c = Instance.new("Frame", parent); c.Size = UDim2.new(0.98, 0, 0, 45); c.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", c)
    local t = Instance.new("TextLabel", c); t.Size = UDim2.new(1, -40, 1, 0); t.Position = UDim2.new(0, 12, 0, 0); t.Text = "TARGET BOSS LIST"; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 14; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"
    local l = Instance.new("Frame", parent); l.Size = UDim2.new(0.98, 0, 0, 0); l.BackgroundColor3 = Color3.fromRGB(25, 25, 30); l.ClipsDescendants = true; Instance.new("UICorner", l); Instance.new("UIListLayout", l)
    local open = false
    c.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then open = not open; TS:Create(l, TweenInfo.new(0.3), {Size = open and UDim2.new(0.98, 0, 0, #BossPriority * 32) or UDim2.new(0.98, 0, 0, 0)}):Play() end end)
    for _, boss in ipairs(BossPriority) do
        local b = Instance.new("TextButton", l); b.Size = UDim2.new(1, 0, 0, 32); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.Text = "  [+] " .. boss; b.TextColor3 = Color3.fromRGB(150, 150, 150); b.Font = "GothamBold"; b.TextSize = 13; b.BorderSizePixel = 0; b.TextXAlignment = "Left"
        b.MouseButton1Click:Connect(function() Config.SelectedBosses[boss] = not Config.SelectedBosses[boss]; b.TextColor3 = Config.SelectedBosses[boss] and Color3.new(0, 1, 0.5) or Color3.fromRGB(150, 150, 150); b.Text = Config.SelectedBosses[boss] and "  [✔] " .. boss or "  [+] " .. boss end)
    end
end

local function CreateSwitch(parent, text, callback)
    local c = Instance.new("Frame", parent); c.Size = UDim2.new(0.98, 0, 0, 45); c.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", c); l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.Text = text; l.TextColor3 = Color3.new(1,1,1); l.Font = "GothamBold"; l.TextSize = 14; l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
    local b = Instance.new("TextButton", c); b.Size = UDim2.new(0, 50, 0, 25); b.Position = UDim2.new(1, -60, 0.5, -12); b.BackgroundColor3 = Color3.fromRGB(50, 50, 60); b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local k = Instance.new("Frame", b); k.Size = UDim2.new(0, 21, 0, 21); k.Position = UDim2.new(0, 2, 0, 2); k.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)
    local s = false
    b.MouseButton1Click:Connect(function() s = not s; TS:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 60)}):Play(); TS:Create(k, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play(); callback(s) end)
end

CreateSwitch(Tabs.Farm, "Auto Farm Boss", function(v) Config.BossMode = v end)
CreateBossDropdown(Tabs.Farm)

local rb = Instance.new("TextButton", Tabs.Plyr); rb.Size = UDim2.new(0.98, 0, 0, 35); rb.BackgroundColor3 = Color3.fromRGB(35, 35, 45); rb.Text = "REFRESH LIST"; rb.TextColor3 = Color3.new(1,1,1); rb.Font = "GothamBold"; rb.TextSize = 12; Instance.new("UICorner", rb)
rb.MouseButton1Click:Connect(function()
    for _, c in pairs(Tabs.Plyr:GetChildren()) do if c:IsA("TextButton") and c ~= rb then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do if p ~= Player then 
        local b = Instance.new("TextButton", Tabs.Plyr); b.Size = UDim2.new(0.98, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.Text = p.DisplayName; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 12; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() if p.Character then Player.Character:PivotTo(p.Character:GetPivot()) end end)
    end end
end)

for _, n in pairs({"Cutie Noob Island", "Duck Island", "Judgement Island", "Kyo Island", "Safe Zone Island", "Sand Island", "Sans Island", "Sky Island", "Sword Master Island", "Tiny Statue Island"}) do 
    local b = Instance.new("TextButton", Tabs.Map); b.Size = UDim2.new(0.98, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 12; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() local t = workspace:FindFirstChild(n, true); if t then Player.Character:PivotTo(t:GetPivot() * CFrame.new(0, 50, 0)) end end) 
end

local function MakeDrag(obj)
    local dragS, dragSt, stP
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true; dragSt = i.Position; stP = obj.Position end end)
    UIS.InputChanged:Connect(function(i) if dragS and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragSt; obj.Position = UDim2.new(stP.X.Scale, stP.X.Offset + d.X, stP.Y.Scale, stP.Y.Offset + d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)
end
MakeDrag(MainGroup); MakeDrag(MiniLogo)
task.spawn(function() while true do local c = Color3.fromHSV(tick()%5/5, 0.7, 1); RGBStroke.Color = c; RGBCircle.BackgroundColor3 = c; CircleStroke.Color = c; MiniStroke.Color = c; MiniText.TextColor3 = c; task.wait() end end)
