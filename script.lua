-- [[ CONFIGURATION ]]
local Config = {
    Active = false,
    Dist = 7,         
    Height = 4,       
    AttackSpeed = 0.3, 
    TargetName = "" 
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local VU = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("Weapon_Event", true) 
              or game:GetService("ReplicatedStorage"):FindFirstChild("Events", true)

local LastAtk = 0
local CurrentTarget = nil
local MySpawnSpot = nil
local SkillIndex = 1
local Keys = {"E", "R", "T", "F"}

-- [[ 1. SMOOTH DRAG ]]
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [[ 2. UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "binhdeptrai_v31"
ScreenGui.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 90, 0, 90); OpenBtn.Position = UDim2.new(0, 25, 0.5, -45)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); OpenBtn.Text = "OPEN"; OpenBtn.TextColor3 = Color3.fromRGB(180, 150, 255)
OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.TextSize = 20; OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 25); Instance.new("UIStroke", OpenBtn).Thickness = 4

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 700, 0, 520); MainFrame.Position = UDim2.new(0.5, -350, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17); Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
MakeDraggable(MainFrame, MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 65); Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30); Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 400, 1, 0); Title.Position = UDim2.new(0, 25, 0, 0)
Title.Text = "BINHDEPTRAI.HUB"; Title.TextSize = 28; Title.TextColor3 = Color3.new(1,1,1) -- Removed version here
Title.Font = Enum.Font.GothamBold; Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

local HideBtn = Instance.new("TextButton", Header)
HideBtn.Size = UDim2.new(0, 150, 0, 45); HideBtn.Position = UDim2.new(1, -165, 0, 10)
HideBtn.Text = "[ MINIMIZE ]"; HideBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
HideBtn.TextColor3 = Color3.new(1,1,1); HideBtn.Font = Enum.Font.GothamBold; HideBtn.TextSize = 18; Instance.new("UICorner", HideBtn)

HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)

local Nav = Instance.new("Frame", MainFrame)
Nav.Size = UDim2.new(0, 180, 1, -85); Nav.Position = UDim2.new(0, 15, 0, 75); Nav.BackgroundTransparency = 1

local Content = Instance.new("Frame", MainFrame)
Content.Position = UDim2.new(0, 210, 0, 75); Content.Size = UDim2.new(1, -225, 1, -100); Content.BackgroundTransparency = 1

local function CreateTab()
    local f = Instance.new("ScrollingFrame", Content)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.ScrollBarThickness = 8
    f.ScrollBarImageColor3 = Color3.fromRGB(120, 100, 255)
    local layout = Instance.new("UIListLayout", f); layout.Padding = UDim.new(0, 12)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    return f
end

local Tabs = { Home = CreateTab(), Map = CreateTab(), Players = CreateTab() }
Tabs.Home.Visible = true

local function AddNav(name, tab)
    local b = Instance.new("TextButton", Nav)
    b.Size = UDim2.new(1, 0, 0, 60); b.Position = UDim2.new(0, 0, 0, (#Nav:GetChildren() - 1) * 75)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 50); b.Text = name; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 22; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, t in pairs(Tabs) do t.Visible = false end; tab.Visible = true end)
end

local function AddBtn(text, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.98, 0, 0, 65); b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 22
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(callback); return b
end

AddNav("FARM", Tabs.Home); AddNav("ISLANDS", Tabs.Map); AddNav("PLAYERS", Tabs.Players)

-- [[ 3. AUTO FARM TOGGLE ]]
local FarmToggle = AddBtn("AUTO FARM: OFF", Tabs.Home, function() 
    Config.Active = not Config.Active 
    if Config.Active then
        local r = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if r then MySpawnSpot = r.Position end
    else
        MySpawnSpot = nil; CurrentTarget = nil
    end
end)

-- Text Update Loop
task.spawn(function()
    while task.wait(0.1) do
        if Config.Active then
            FarmToggle.Text = "AUTO FARM: ON"
            FarmToggle.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
        else
            FarmToggle.Text = "AUTO FARM: OFF"
            FarmToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end
    end
end)

local TargetInput = Instance.new("TextBox", Tabs.Home)
TargetInput.Size = UDim2.new(0.98, 0, 0, 60); TargetInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TargetInput.PlaceholderText = "Type Exact Mob Name..."; TargetInput.TextColor3 = Color3.new(1,1,1)
TargetInput.Font = Enum.Font.GothamBold; TargetInput.TextSize = 20; Instance.new("UICorner", TargetInput)
TargetInput.FocusLost:Connect(function() Config.TargetName = TargetInput.Text end)

AddBtn("EQUIP ALL TOOLS", Tabs.Home, function()
    for _, t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = Player.Character end end
end)

-- [[ 4. ISLANDS & PLAYERS ]]
local ValidIslands = {"Starter Island", "Second Island", "Third Island", "Fourth Island", "Fifth Island", "Six Island", "Seven Island", "Eight Island", "Nine Island", "Cutie Noob Island", "Duck Island", "Judgement Island", "Kyo Island", "Safe Zone Island", "Sand Island", "Sans Island", "Sky Island", "Sword Master Island", "Tiny Statue Island"}
for _, name in pairs(ValidIslands) do
    AddBtn(name, Tabs.Map, function()
        local t = workspace:FindFirstChild(name, true)
        if t then Player.Character:PivotTo(t:GetPivot() * CFrame.new(0, 50, 0)) end
    end)
end

local function RefreshPlayers()
    for _, c in pairs(Tabs.Players:GetChildren()) do if c:IsA("TextButton") and c.Text ~= "REFRESH LIST" then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then AddBtn(p.DisplayName, Tabs.Players, function() if p.Character then Player.Character:PivotTo(p.Character:GetPivot()) end end) end
    end
end
AddBtn("REFRESH LIST", Tabs.Players, RefreshPlayers)

-- [[ 5. ENGINE LOGIC ]]
local function UseSkill(key)
    if not CurrentTarget then return end
    if Remote then
        pcall(function()
            Remote:FireServer("Skill " .. key .. " Release", CurrentTarget.Position)
            Remote:FireServer(key, CurrentTarget.Position)
        end)
    end
    VIM:SendKeyEvent(true, key, false, game)
    task.wait(0.01); VIM:SendKeyEvent(false, key, false, game)
end

task.spawn(function()
    while task.wait(0.5) do
        if Config.Active then
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            local target, d = nil, 250
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Health > 0 and v.Parent ~= Player.Character then
                    if not Players:GetPlayerFromCharacter(v.Parent) then
                        local hrp = v.Parent:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local mag = (Config.TargetName == "" and MySpawnSpot) and (MySpawnSpot - hrp.Position).Magnitude or (root.Position - hrp.Position).Magnitude
                            if Config.TargetName ~= "" and v.Parent.Name == Config.TargetName then
                                target = hrp; break
                            elseif Config.TargetName == "" and mag < d then
                                target = hrp; d = mag
                            end
                        end
                    end
                end
            end
            CurrentTarget = target
        end
    end
end)

RS.Heartbeat:Connect(function()
    if not Config.Active or not CurrentTarget or not Player.Character then return end
    local root = Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)

    local goal = CurrentTarget.Position + (CurrentTarget.CFrame.LookVector * -Config.Dist) + Vector3.new(0, Config.Height, 0)
    root.CFrame = root.CFrame:Lerp(CFrame.new(goal, CurrentTarget.Position), 0.3)
    
    if tick() - LastAtk >= Config.AttackSpeed then
        UseSkill(Keys[SkillIndex])
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
        VU:CaptureController(); VU:Button1Down(Vector2.new(0,0))
        SkillIndex = SkillIndex % #Keys + 1
        LastAtk = tick()
    end
end)
