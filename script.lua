-- [[ BINHDEPTRAI.HUB - v118 ]]
local Config = { 
    BossMode = false, 
    Dist = 7, 
    Height = 5,
    RangeSize = Vector3.new(55, 55, 55),
    FastAttack = true -- Bypass thời gian hồi chém
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

-- [[ 1. SIÊU CHEAT: BYPASS COOLDOWN & ANIMATION ]]
task.spawn(function()
    while task.wait() do
        if Config.BossMode and Config.FastAttack then
            pcall(function()
                local char = Player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- Hủy bỏ các Animation đang chạy để chém tiếp (Animation Cancel)
                    for _, v in pairs(hum:GetPlayingAnimationTracks()) do
                        v:Stop()
                    end
                end
            end)
        end
    end
end)

-- [[ 2. GOD COMBO (FRUIT -> SWORD) ]]
local function ExecuteGodCombo()
    local char = Player.Character
    local bp = Player.Backpack
    if not char then return end

    -- BƯỚC 1: DÙNG SKILL FRUIT (UNEQUIP)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = bp end
    end
    
    for _, key in ipairs({"E", "R", "T", "F"}) do
        VIM:SendKeyEvent(true, key, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, key, false, game)
    end

    -- BƯỚC 2: DÙNG SKILL SWORD (EQUIP ALL)
    for _, tool in pairs(bp:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = char end
    end
    
    for _, key in ipairs({"E", "R", "T", "F"}) do
        VIM:SendKeyEvent(true, key, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, key, false, game)
    end
    
    -- CLICK CHÉM (BYPASS GIÂY HỒI)
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- [[ 3. LOGIC FARM & HITBOX ]]
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
            root.Velocity = Vector3.new(0,0,0)
            
            -- HITBOX CHEAT & STUN BOSS
            pcall(function()
                target.Size = Config.RangeSize
                target.Transparency = 0.8
                target.Color = Color3.new(1, 0, 0)
                target.CanCollide = false
                
                -- Noclip
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
            
            -- Căn vị trí
            local goal = target.CFrame * CFrame.new(0, Config.Height, Config.Dist)
            root.CFrame = CFrame.lookAt(goal.Position, target.Position)
        end
    end
end)

-- Vòng lặp combo
task.spawn(function()
    while task.wait(0.3) do
        if Config.BossMode and GetTarget() then
            ExecuteGodCombo()
        end
    end
end)

-- [[ 4. UI V118 (KÉO - PHÍM K) ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_v118") then Player.PlayerGui.BinhHub_v118:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_v118"; sg.ResetOnSpawn = false
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 220, 0, 200); main.Position = UDim2.new(0.05, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(15, 0, 0); main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main); local s = Instance.new("UIStroke", main); s.Color = Color3.new(1,0,0)

    local function AddBtn(text, pos, callback)
        local b = Instance.new("TextButton", main); b.Size = UDim2.new(0.9, 0, 0, 40); b.Position = UDim2.new(0.05, 0, 0, pos)
        b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40, 0, 0); b.TextColor3 = Color3.new(1,1,1)
        b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end)
    end

    AddBtn("BYPASS FAST FARM: OFF", 20, function(b)
        Config.BossMode = not Config.BossMode
        b.Text = Config.BossMode and "BYPASSING..." or "BYPASS FAST FARM: OFF"
        b.BackgroundColor3 = Config.BossMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 0, 0)
    end)

    AddBtn("GRAY WORLD (FPS BOOST)", 75, function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.Color = Color3.new(0.4, 0.4, 0.4) end
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
    end)

    AddBtn("TP LIST PLAYER", 130, function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then Player.Character:PivotTo(p.Character:GetPivot()); break end
        end
    end)

    UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end end)
end

CreateUI()
