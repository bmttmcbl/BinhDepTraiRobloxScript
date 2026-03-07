-- [[ BINHDEPTRAI.HUB - v116 ]]
local Config = { 
    BossMode = false, 
    Dist = 8, 
    Height = 6,
    RangeSize = Vector3.new(45, 45, 45), -- SIÊU HITBOX
    ShowHitbox = true -- Hiển thị vùng cheat để ông kiểm tra
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

-- [[ 1. HÀM CHEAT HITBOX & STUN BOSS ]]
local function ApplyCheats(target)
    pcall(function()
        if target then
            -- PHÓNG TO HITBOX (CHEAT RANGE)
            target.Size = Config.RangeSize
            target.CanCollide = false
            
            -- HIỆN THỊ HITBOX (Để ông biết cheat đang chạy)
            if Config.ShowHitbox then
                target.Transparency = 0.7
                target.Color = Color3.fromRGB(255, 0, 0) -- Màu đỏ đại diện cho vùng cheat
                target.Material = Enum.Material.ForceField
            end
        end
    end)
end

-- [[ 2. GOD COMBO (FRUIT -> SWORD) ]]
local function ExecuteGodCombo()
    local char = Player.Character
    local bp = Player.Backpack
    if not char then return end

    -- BƯỚC 1: UNEQUIP (DÙNG SKILL TRÁI ÁC QUỶ)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = bp end
    end
    task.wait(0.05)

    for _, key in ipairs({"E", "R", "T", "F"}) do
        VIM:SendKeyEvent(true, key, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, key, false, game)
    end

    -- BƯỚC 2: EQUIP ALL (DÙNG SKILL KIẾM/VŨ KHÍ)
    for _, tool in pairs(bp:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = char end
    end
    task.wait(0.05)

    for _, key in ipairs({"E", "R", "T", "F"}) do
        VIM:SendKeyEvent(true, key, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, key, false, game)
    end
    
    -- CLICK CHUỘT LIÊN TỤC
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- [[ 3. AUTO FARM & DI CHUYỂN ]]
local function GetTarget()
    for _, name in pairs(BossList) do
        local b = workspace:FindFirstChild(name, true)
        if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
            return b:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil
end

RS.Stepped:Connect(function()
    if Config.BossMode then
        local target = GetTarget()
        if target and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local root = Player.Character.HumanoidRootPart
            root.Velocity = Vector3.zero -- ANTI-STUN
            
            -- Áp dụng Hitbox Cheat
            ApplyCheats(target)
            
            -- Noclip nhân vật
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            
            -- Bay trên đầu Boss
            local goal = target.CFrame * CFrame.new(0, Config.Height, Config.Dist)
            root.CFrame = CFrame.lookAt(goal.Position, target.Position)
        end
    end
end)

task.spawn(function()
    while task.wait(0.4) do
        if Config.BossMode and GetTarget() then
            ExecuteGodCombo()
        end
    end
end)

-- [[ 4. UI V116 ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_v116") then Player.PlayerGui.BinhHub_v116:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_v116"; sg.ResetOnSpawn = false
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 220, 0, 200); main.Position = UDim2.new(0.05, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 0, 0); main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main); local s = Instance.new("UIStroke", main); s.Color = Color3.new(1,0,0)

    local function AddBtn(text, pos, callback)
        local b = Instance.new("TextButton", main); b.Size = UDim2.new(0.9, 0, 0, 45); b.Position = UDim2.new(0.05, 0, 0, pos)
        b.Text = text; b.BackgroundColor3 = Color3.fromRGB(50, 0, 0); b.TextColor3 = Color3.new(1,1,1)
        b.Font = "GothamBold"; b.TextSize = 12; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end)
    end

    AddBtn("START CHEAT FARM: OFF", 20, function(b)
        Config.BossMode = not Config.BossMode
        b.Text = Config.BossMode and "CHEATING..." or "START CHEAT FARM: OFF"
        b.BackgroundColor3 = Config.BossMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 0, 0)
    end)

    AddBtn("GRAY WORLD (FPS+)", 80, function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.Color = Color3.new(0.5, 0.5, 0.5) end
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
    end)

    AddBtn("TP PLAYER LIST", 140, function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then Player.Character:PivotTo(p.Character:GetPivot()); break end
        end
    end)

    UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end end)
end

CreateUI()
