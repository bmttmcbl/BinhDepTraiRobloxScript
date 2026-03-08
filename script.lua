-- [[ BINHDEPTRAI.HUB - v170 - BOSS ANNIHILATOR ]]
local Config = { 
    BossMode = false, 
    Dist = 5.5, -- Áp sát hơn một chút để Multi-Hitbox hiệu quả
    Height = 6.5,
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

-- [[ 1. HÀM TÌM BOSS & TỐI ƯU HITBOX ]]
local function GetCurrentBoss()
    for _, name in pairs(BossList) do
        local b = workspace:FindFirstChild(name, true)
        if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then 
            -- MULTI-HITBOX OVERLAP: Phóng to tối đa để ăn sát thương lan
            pcall(function()
                local root = b:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Size = Vector3.new(80, 80, 80)
                    root.CanCollide = false
                    root.Transparency = 0.8 -- Cho ông dễ nhìn
                end
            end)
            return b 
        end
    end
    return nil
end

-- [[ 2. SUPREME COMBO (TRUE LOGIC - STUN OPTIMIZED) ]]
local function ExecuteSupremeCombo()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local bp = Player.Backpack
    
    -- BƯỚC 1: UNEQUIP (FRUIT/MELEE SKILLS)
    if hum then hum:UnequipTools() end
    task.wait(0.06) -- Nhịp nghỉ nhẹ để Server nhận diện Unequip
    for _, key in ipairs({"E", "R", "T", "F"}) do 
        VIM:SendKeyEvent(true, key, false, game); task.wait(0.02); VIM:SendKeyEvent(false, key, false, game) 
    end
    
    -- BƯỚC 2: EQUIP ALL (SWORD SKILLS)
    for _, tool in pairs(bp:GetChildren()) do 
        if tool:IsA("Tool") then tool.Parent = char end 
    end
    task.wait(0.06)
    for _, key in ipairs({"E", "R", "T", "F"}) do 
        VIM:SendKeyEvent(true, key, false, game); task.wait(0.02); VIM:SendKeyEvent(false, key, false, game) 
    end
    
    -- BƯỚC 3: TRIPLE CLICK (DỒN SÁT THƯƠNG)
    for i = 1, 3 do 
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1) 
        task.wait(0.01)
    end
end

-- [[ 3. LOGIC DI CHUYỂN ]]
RS.Stepped:Connect(function()
    if Config.BossMode then
        local boss = GetCurrentBoss()
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        if boss and boss:FindFirstChild("HumanoidRootPart") then
            root.Anchored = false 
            local target = boss.HumanoidRootPart
            pcall(function()
                for _, v in pairs(char:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CanCollide = false; v.CanTouch = false end 
                end
            end)
            root.Velocity = Vector3.zero
            -- Vờn quanh Boss để kích hoạt Multi-Hitbox từ nhiều góc
            local circle = Vector3.new(math.sin(tick()*3)*3, Config.Height, math.cos(tick()*3)*Config.Dist)
            root.CFrame = CFrame.lookAt(target.Position + circle, target.Position)
        else
            root.Velocity = Vector3.zero; root.Anchored = true 
        end
    else
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

-- [[ 4. UI ĐÀNG HOÀNG ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_V170") then Player.PlayerGui.BinhHub_V170:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_V170"; sg.ResetOnSpawn = false
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 240, 0, 380); main.Position = UDim2.new(0.05, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(5, 5, 5); main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(1, 0, 0)

    local stext = Instance.new("TextLabel", main); stext.Size = UDim2.new(0.9, 0, 0, 60); stext.Position = UDim2.new(0.05, 0, 0, 15)
    stext.BackgroundColor3 = Color3.fromRGB(15, 15, 15); stext.TextColor3 = Color3.new(1,1,1); stext.Font = "GothamBold"; stext.TextSize = 10; Instance.new("UICorner", stext)
    
    task.spawn(function()
        while task.wait(0.5) do
            local b = GetCurrentBoss()
            stext.Text = "BOSS HUNTER v170 🔱\nTARGET: "..(b and b.Name or "None").."\nSTUN LOGIC: ACTIVE"
        end
    end)

    local function AddBtn(text, pos, callback)
        local b = Instance.new("TextButton", main); b.Size = UDim2.new(0.9, 0, 0, 45); b.Position = UDim2.new(0.05, 0, 0, pos)
        b.Text = text; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end)
        return b
    end

    AddBtn("START BOSS FARM", 90, function(b) 
        Config.BossMode = not Config.BossMode 
        b.BackgroundColor3 = Config.BossMode and Color3.new(0, 0.6, 0) or Color3.fromRGB(30, 30, 30)
    end)
    
    AddBtn("TP RANDOM PLAYER", 150, function()
        local plrs = {}; for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player and p.Character then table.insert(plrs, p) end end
        if #plrs > 0 then Player.Character.HumanoidRootPart.Anchored = false; Player.Character:PivotTo(plrs[math.random(1, #plrs)].Character:GetPivot()) end
    end)

    AddBtn("ULTRA FPS BOOST (20 FPS)", 210, function()
        setfpscap(20)
        for _, v in pairs(workspace:GetDescendants()) do 
            pcall(function() if v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.Color = Color3.new(0.4, 0.4, 0.4) end end) 
        end
    end)

    AddBtn("WHITE SCREEN (AFK - J)", 270, function()
        if not Player.PlayerGui:FindFirstChild("AFK_Overlay") then
            local ov = Instance.new("ScreenGui", Player.PlayerGui); ov.Name = "AFK_Overlay"; ov.ResetOnSpawn = false
            local f = Instance.new("Frame", ov); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(1,1,1); f.ZIndex = 9999
            local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,1,0); t.Text = "STAY CONNECTED\nBOSS HUNTER ACTIVE\nJ TO EXIT"; t.TextColor3 = Color3.new(0,0,0); t.TextSize = 25; t.BackgroundTransparency = 1; t.Font = "GothamBold"
            RS:Set3dRenderingEnabled(false)
        else Player.PlayerGui.AFK_Overlay:Destroy(); RS:Set3dRenderingEnabled(true) end
    end)

    UIS.InputBegan:Connect(function(i, p) 
        if not p and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
        if i.KeyCode == Enum.KeyCode.J and Player.PlayerGui:FindFirstChild("AFK_Overlay") then 
            Player.PlayerGui.AFK_Overlay:Destroy(); RS:Set3dRenderingEnabled(true)
        end
    end)
end

Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = false end
end)

task.spawn(function()
    while task.wait(0.3) do -- Nhịp combo chuẩn để Stun Boss mà không bị lag
        if Config.BossMode and GetCurrentBoss() then ExecuteSupremeCombo() end 
    end
end)

CreateUI()
