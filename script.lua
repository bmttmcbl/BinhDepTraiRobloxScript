-- [[ BINHDEPTRAI.HUB - v179 - ULTIMATE OPTIMIZED ]]
local Config = { 
    FarmMode = "None", 
    Dist = 5.5, 
    Height = 6.5,
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

-- [[ 1. LOGIC TÌM BOSS (TỐI ƯU CPU) ]]
local function GetCurrentBoss()
    local targetName = nil
    if Config.FarmMode == "Dual Swords" then targetName = "Nooby"
    elseif Config.FarmMode == "Fake Yoru" then targetName = "Unknown Boss"
    elseif Config.FarmMode == "Main" then
        for _, name in pairs(BossList) do
            local b = workspace:FindFirstChild(name, true)
            if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then targetName = name; break end
        end
    end
    
    if targetName then
        local b = workspace:FindFirstChild(targetName, true)
        if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
            pcall(function() 
                if b.HumanoidRootPart.Size.X < 10 then
                    b.HumanoidRootPart.Size = Vector3.new(80,80,80)
                    b.HumanoidRootPart.CanCollide = false 
                end
            end)
            return b
        end
    end
    return nil
end

-- [[ 2. SUPREME COMBO (GIỮ NGUYÊN) ]]
local function ExecuteSupremeCombo()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local bp = Player.Backpack
    
    -- Auto Ken Haki (Nhấn V) khi đang Farm
    task.spawn(function() VIM:SendKeyEvent(true, "V", false, game); task.wait(0.01); VIM:SendKeyEvent(false, "V", false, game) end)

    if hum then hum:UnequipTools() end
    task.wait(0.06)
    for _, key in ipairs({"E", "R", "T", "F"}) do 
        VIM:SendKeyEvent(true, key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, key, false, game) 
    end
    for _, tool in pairs(bp:GetChildren()) do if tool:IsA("Tool") then tool.Parent = char end end
    task.wait(0.06)
    for _, key in ipairs({"E", "R", "T", "F"}) do 
        VIM:SendKeyEvent(true, key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, key, false, game) 
    end
    for i = 1, 3 do VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1) end
end

-- [[ 3. DI CHUYỂN TỐI ƯU ]]
RS.Stepped:Connect(function()
    if Config.FarmMode == "None" then 
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.Anchored = false end
        return 
    end
    local boss = GetCurrentBoss()
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if boss then
        root.Anchored = false 
        local target = boss.HumanoidRootPart
        pcall(function() for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end)
        root.Velocity = Vector3.zero
        local circle = Vector3.new(math.sin(tick()*3)*3, Config.Height, math.cos(tick()*3)*Config.Dist)
        root.CFrame = CFrame.lookAt(target.Position + circle, target.Position)
    else
        root.Velocity = Vector3.zero; root.Anchored = true 
    end
end)

-- [[ 4. GIAO DIỆN v179 + STATUS PANEL ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_v179") then Player.PlayerGui.BinhHub_v179:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_v179"; sg.ResetOnSpawn = false
    
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 720, 0, 380); main.Position = UDim2.new(0.5, -360, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", main).Color = Color3.new(1, 0, 0)

    -- Tiêu đề
    local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1, 0, 0, 50); title.Text = "BINHDEPTRAI.HUB - v179 (PRO)"; title.TextColor3 = Color3.new(1,1,1); title.Font = "GothamBold"; title.TextSize = 22; title.BackgroundTransparency = 1

    -- STATUS PANEL (PHẦN THÊM MỚI CHO THẨM MỸ)
    local statusFrame = Instance.new("Frame", main); statusFrame.Size = UDim2.new(0.96, 0, 0, 30); statusFrame.Position = UDim2.new(0.02, 0, 0, 45); statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", statusFrame)
    local statusLab = Instance.new("TextLabel", statusFrame); statusLab.Size = UDim2.new(1, 0, 1, 0); statusLab.Text = "STATUS: IDLE | TARGET: NONE"; statusLab.TextColor3 = Color3.new(1, 1, 0); statusLab.Font = "GothamBold"; statusLab.TextSize = 11; statusLab.BackgroundTransparency = 1

    task.spawn(function()
        while task.wait(0.5) do
            local b = GetCurrentBoss()
            statusLab.Text = "STATUS: " .. (Config.FarmMode:upper()) .. " | TARGET: " .. (b and b.Name:upper() or "WAITING...")
        end
    end)

    local function CreateSection(name, xPos)
        local s = Instance.new("Frame", main); s.Size = UDim2.new(0, 220, 0, 270); s.Position = UDim2.new(0, xPos, 0, 90); s.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", s)
        local l = Instance.new("TextLabel", s); l.Size = UDim2.new(1, 0, 0, 40); l.Text = name; l.TextColor3 = Color3.new(1, 0, 0); l.Font = "GothamBold"; l.TextSize = 14; l.BackgroundTransparency = 1
        return s
    end

    local function AddBtn(text, parent, yPos, callback)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.9, 0, 0, 38); b.Position = UDim2.new(0.05, 0, 0, yPos)
        b.Text = text; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end); return b
    end

    -- SECTION 1: FARMING
    local secFarm = CreateSection("FARMING CONTROL", 15)
    local btnMain = AddBtn("Main Boss: OFF", secFarm, 40, function() end)
    local lbWeapon = Instance.new("TextLabel", secFarm); lbWeapon.Size = UDim2.new(1,0,0,20); lbWeapon.Position = UDim2.new(0,0,0,85); lbWeapon.Text = "-- SWORD FARM --"; lbWeapon.TextColor3 = Color3.new(0.6,0.6,0.6); lbWeapon.Font = "GothamBold"; lbWeapon.TextSize = 10; lbWeapon.BackgroundTransparency = 1
    
    local btnDual = AddBtn("Dual Swords: OFF", secFarm, 110, function() end)
    local btnYoru = AddBtn("Fake Yoru: OFF", secFarm, 155, function() end)
    local btnLight = AddBtn("Lightning Sword", secFarm, 200, function()
        local island = workspace:FindFirstChild("Tiny Statue Island", true)
        if island then Player.Character:PivotTo(island:GetPivot()) end
    end)
    btnLight.BackgroundColor3 = Color3.fromRGB(0, 80, 200)

    -- SECTION 2: PERFORMANCE
    local secPerf = CreateSection("PERFORMANCE", 250)
    AddBtn("Set 20 FPS Cap", secPerf, 40, function(b) setfpscap(20); b.Text = "FPS: 20 ✅" end)
    AddBtn("Ultra Boost (No Lag)", secPerf, 85, function() 
        for _, v in pairs(workspace:GetDescendants()) do pcall(function() if v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.Color = Color3.new(0.4, 0.4, 0.4) end end) end 
    end)
    AddBtn("White Screen (J)", secPerf, 130, function() 
        if not Player.PlayerGui:FindFirstChild("AFK") then 
            local ov = Instance.new("ScreenGui", Player.PlayerGui); ov.Name = "AFK"
            local f = Instance.new("Frame", ov); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(1,1,1)
            RS:Set3dRenderingEnabled(false) 
        else Player.PlayerGui.AFK:Destroy(); RS:Set3dRenderingEnabled(true) end 
    end)

    -- SECTION 3: UTILITIES
    local secUtils = CreateSection("EXTRA UTILS", 485)
    AddBtn("TP Random Player", secUtils, 40, function() 
        local p = {}; for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player and v.Character then table.insert(p, v) end end
        if #p > 0 then Player.Character:PivotTo(p[math.random(1, #p)].Character:GetPivot()) end 
    end)
    AddBtn("Hide Menu (K)", secUtils, 85, function() main.Visible = false end)

    -- Logic Cập Nhật
    local function UpdateButtons()
        btnMain.Text = (Config.FarmMode == "Main") and "Main Boss: ON ✅" or "Main Boss: OFF"
        btnMain.BackgroundColor3 = (Config.FarmMode == "Main") and Color3.new(0, 0.5, 0) or Color3.fromRGB(35, 35, 35)
        btnDual.Text = (Config.FarmMode == "Dual Swords") and "Dual Swords: ON 🔥" or "Dual Swords: OFF"
        btnDual.BackgroundColor3 = (Config.FarmMode == "Dual Swords") and Color3.new(0.5, 0.4, 0) or Color3.fromRGB(35, 35, 35)
        btnYoru.Text = (Config.FarmMode == "Fake Yoru") and "Fake Yoru: ON 💀" or "Fake Yoru: OFF"
        btnYoru.BackgroundColor3 = (Config.FarmMode == "Fake Yoru") and Color3.new(0.4, 0, 0.4) or Color3.fromRGB(35, 35, 35)
    end

    btnMain.MouseButton1Click:Connect(function() Config.FarmMode = (Config.FarmMode == "Main") and "None" or "Main"; UpdateButtons() end)
    btnDual.MouseButton1Click:Connect(function() Config.FarmMode = (Config.FarmMode == "Dual Swords") and "None" or "Dual Swords"; UpdateButtons() end)
    btnYoru.MouseButton1Click:Connect(function() Config.FarmMode = (Config.FarmMode == "Fake Yoru") and "None" or "Fake Yoru"; UpdateButtons() end)

    UIS.InputBegan:Connect(function(i, p) 
        if not p and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end 
        if i.KeyCode == Enum.KeyCode.J and Player.PlayerGui:FindFirstChild("AFK") then Player.PlayerGui.AFK:Destroy(); RS:Set3dRenderingEnabled(true) end 
    end)
end

-- Vòng lặp chính xả Combo
task.spawn(function() 
    while task.wait(0.35) do 
        if Config.FarmMode ~= "None" and GetCurrentBoss() then ExecuteSupremeCombo() end 
    end 
end)

CreateUI()
