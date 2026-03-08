-- [[ BINHDEPTRAI.HUB - v221 - PERFORMANCE EDITION ]]
local Config = { FarmEnabled = false, Targets = {}, Dist = 5.5, Height = 6.5 }
local Player = game.Players.LocalPlayer
local RS, VIM, UIS, TS = game:GetService("RunService"), game:GetService("VirtualInputManager"), game:GetService("UserInputService"), game:GetService("TweenService")

local OriginalMaterials = {}
local BossData = {
    {n = "Kyo", w = "Amethyst Scythe"}, {n = "Shinoa", w = "Cursed Scythe"},
    {n = "Duck Boss", w = "Awakening Book"}, {n = "Chara", w = "Real Knife"},
    {n = "Sword Master", w = "True Yoru"}, {n = "Sans", w = "Bone Fruit"},
    {n = "King Noob", w = "Bisento"}, {n = "Cutie Boss", w = "Hao Haki"},
    {n = "Nooby", w = "Dual Elucidator"}, {n = "Unknown Boss", w = "Fake Yoru"}
}

-- [[ 🛡️ ANTI-AFK ]]
Player.Idled:Connect(function()
    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.2)
    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)

-- [[ ENGINE - AUTO SCAN ALL BOSSES ]]
local function GetCurrentTarget()
    if not Config.FarmEnabled then return nil end
    for _, data in pairs(BossData) do
        local b = workspace:FindFirstChild(data.n, true)
        if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
            if not game.Players:GetPlayerFromCharacter(b) then
                pcall(function() 
                    if b:FindFirstChild("HumanoidRootPart") and b.HumanoidRootPart.Size.X < 10 then 
                        b.HumanoidRootPart.Size = Vector3.new(85,85,85)
                        b.HumanoidRootPart.CanCollide = false 
                    end 
                end)
                return b
            end
        end
    end
    return nil
end

-- [[ 🔥 COMBO CHUẨN V179 ]]
local function ExecuteSupremeCombo()
    local char = Player.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    task.spawn(function() VIM:SendKeyEvent(true, "V", false, game); task.wait(0.01); VIM:SendKeyEvent(false, "V", false, game) end)
    hum:UnequipTools(); task.wait(0.06)
    for _, key in ipairs({"E", "R", "T", "F"}) do 
        VIM:SendKeyEvent(true, key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, key, false, game) 
    end
    for _, tool in pairs(Player.Backpack:GetChildren()) do 
        if tool:IsA("Tool") then tool.Parent = char end 
    end; task.wait(0.06)
    for _, key in ipairs({"E", "R", "T", "F"}) do 
        VIM:SendKeyEvent(true, key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, key, false, game) 
    end
    for i = 1, 4 do 
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.01); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1) 
    end
end

-- [[ UI SYSTEM ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_v212") then Player.PlayerGui.BinhHub_v212:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_v212"; sg.ResetOnSpawn = false
    
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 850, 0, 480); main.Position = UDim2.new(0.5, -425, 0.3, 0); main.BackgroundColor3 = Color3.fromRGB(8, 8, 8); main.Active = true; main.Draggable = true; main.ClipsDescendants = true
    Instance.new("UICorner", main, {CornerRadius = UDim.new(0, 15)}); Instance.new("UIStroke", main, {Color = Color3.new(1,0,0), Thickness = 3})

    local content = Instance.new("Frame", main); content.Size = UDim2.new(1, 0, 1, 0); content.BackgroundTransparency = 1
    local top = Instance.new("Frame", content); top.Size = UDim2.new(1, 0, 0, 60); top.BackgroundTransparency = 1
    local logo = Instance.new("TextLabel", top); logo.Size = UDim2.new(0, 80, 1, 0); logo.Text = "B"; logo.TextColor3 = Color3.new(1,0,0); logo.Font = "GothamBold"; logo.TextSize = 45; logo.BackgroundTransparency = 1
    
    local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -40, 0, 15); closeBtn.Text = "-"; closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = "GothamBold"; closeBtn.TextSize = 25; closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); closeBtn.ZIndex = 100; Instance.new("UICorner", closeBtn)

    local function CreateSection(name, x, color)
        local s = Instance.new("Frame", content); s.Size = UDim2.new(0, 260, 0, 340); s.Position = UDim2.new(0, x, 0, 90); s.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Instance.new("UICorner", s)
        local l = Instance.new("TextLabel", s); l.Size = UDim2.new(1, 0, 0, 40); l.Text = name:upper(); l.TextColor3 = color; l.Font = "GothamBold"; l.TextSize = 18; l.BackgroundTransparency = 1
        local c = Instance.new("ScrollingFrame", s); c.Size = UDim2.new(1, -10, 1, -50); c.Position = UDim2.new(0, 5, 0, 45); c.BackgroundTransparency = 1; c.ScrollBarThickness = 2; c.CanvasSize = UDim2.new(0,0,0,0); c.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", c).Padding = UDim.new(0, 8); return c
    end

    local function AddSwitch(parent, text, cb)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundTransparency = 1
        local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.9, 0, 1, 0); t.Text = text; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 13; t.TextXAlignment = "Left"; t.BackgroundTransparency = 1
        local sBG = Instance.new("TextButton", f); sBG.Size = UDim2.new(0, 40, 0, 20); sBG.Position = UDim2.new(1, -45, 0.25, 0); sBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40); sBG.Text = ""; Instance.new("UICorner", sBG).CornerRadius = UDim.new(1,0)
        local sC = Instance.new("Frame", sBG); sC.Size = UDim2.new(0, 16, 0, 16); sC.Position = UDim2.new(0.1, 0, 0.1, 0); sC.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", sC).CornerRadius = UDim.new(1,0)
        local active = false
        sBG.MouseButton1Click:Connect(function() 
            active = not active
            TS:Create(sC, TweenInfo.new(0.2), {Position = active and UDim2.new(0.5, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0)}):Play()
            TS:Create(sBG, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.new(0,1,0) or Color3.fromRGB(40,40,40)}):Play()
            cb(active)
        end)
    end

    -- SECTION 1: FARMING
    local fSec = CreateSection("Farming", 20, Color3.new(1,0,0))
    AddSwitch(fSec, "AUTO FARM (ALL)", function(v) Config.FarmEnabled = v end)

    -- SECTION 2: PERFORMANCE
    local pSec = CreateSection("Performance", 295, Color3.new(1,1,1))
    
    -- ADD SWITCH 20 FPS
    AddSwitch(pSec, "ULTRA BOOST (20 FPS)", function(v) 
        if setfpscap then setfpscap(v and 20 or 999) end 
    end)
    
    -- GREY ALL
    AddSwitch(pSec, "GREY ALL (FPS BOOST)", function(v) 
        if v then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not game.Players:GetPlayerFromCharacter(obj.Parent) then
                    OriginalMaterials[obj] = {obj.Material, obj.Color}
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Color = Color3.fromRGB(120, 120, 120)
                end
            end
        else
            for obj, data in pairs(OriginalMaterials) do
                if obj and obj.Parent then obj.Material = data[1]; obj.Color = data[2] end
            end
            OriginalMaterials = {}
        end
    end)
    AddSwitch(pSec, "WHITE SCREEN (J)", function(v) RS:Set3dRenderingEnabled(not v) end)

    -- SECTION 3: UTILITIES
    local uSec = CreateSection("Utilities", 570, Color3.new(0, 0.6, 1))
    local tpSw = Instance.new("TextButton", uSec); tpSw.Size = UDim2.new(1, 0, 0, 40); tpSw.Text = "GET LIGHTNING SWORD"; tpSw.BackgroundColor3 = Color3.fromRGB(0, 60, 150); tpSw.TextColor3 = Color3.new(1,1,1); tpSw.Font = "GothamBold"; Instance.new("UICorner", tpSw)
    tpSw.MouseButton1Click:Connect(function() local i = workspace:FindFirstChild("Tiny Statue Island", true); if i then Player.Character:PivotTo(i:GetPivot()) end end)

    -- TP RANDOM PLAYER
    local tpRand = Instance.new("TextButton", uSec); tpRand.Size = UDim2.new(1, 0, 0, 40); tpRand.Text = "TP TO RANDOM PLAYER"; tpRand.BackgroundColor3 = Color3.fromRGB(150, 0, 0); tpRand.TextColor3 = Color3.new(1,1,1); tpRand.Font = "GothamBold"; Instance.new("UICorner", tpRand)
    tpRand.MouseButton1Click:Connect(function()
        local others = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(others, p) end
        end
        if #others > 0 then Player.Character:PivotTo(others[math.random(1, #others)].Character:GetPivot()) end
    end)

    local isMin = false
    closeBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = isMin and UDim2.new(0, 80, 0, 80) or UDim2.new(0, 850, 0, 480)}):Play()
        content.Visible = not isMin
    end)
end

-- [[ ENGINE START ]]
RS.Stepped:Connect(function()
    local boss = GetCurrentTarget()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if boss and root and boss:FindFirstChild("HumanoidRootPart") then 
        root.Velocity = Vector3.zero
        root.CFrame = CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, Config.Height, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
    elseif Config.FarmEnabled and root then 
        root.Velocity = Vector3.zero; root.Anchored = true 
    elseif not Config.FarmEnabled and root then 
        root.Anchored = false 
    end
end)

task.spawn(function() while task.wait(0.3) do if GetCurrentTarget() then ExecuteSupremeCombo() end end end)

CreateUI()
