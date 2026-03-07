-- [[ BINHDEPTRAI.HUB - AIR FREEZE MODE ]]
local Config = { 
    BossMode = false, 
    Dist = 6, 
    Height = 7, -- Độ cao an toàn
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

-- [[ 1. HÀM TÌM BOSS ]]
local function GetCurrentBoss()
    for _, name in pairs(BossList) do
        local b = workspace:FindFirstChild(name, true)
        if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then return b end
    end
    return nil
end

-- [[ 2. SUPREME COMBO ]]
local function ExecuteSupremeCombo()
    local char = Player.Character
    if not char then return end
    local bp = Player.Backpack
    for _, tool in pairs(char:GetChildren()) do if tool:IsA("Tool") then tool.Parent = bp end end
    for _, key in ipairs({"E", "R", "T", "F"}) do VIM:SendKeyEvent(true, key, false, game); task.wait(); VIM:SendKeyEvent(false, key, false, game) end
    for _, tool in pairs(bp:GetChildren()) do if tool:IsA("Tool") then tool.Parent = char end end
    for _, key in ipairs({"E", "R", "T", "F"}) do VIM:SendKeyEvent(true, key, false, game); task.wait(); VIM:SendKeyEvent(false, key, false, game) end
    for i = 1, 3 do VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1) end
end

-- [[ 3. LOGIC DI CHUYỂN & AIR FREEZE ]]
RS.Stepped:Connect(function()
    if Config.BossMode then
        local boss = GetCurrentBoss()
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        if boss and boss:FindFirstChild("HumanoidRootPart") then
            -- KHI CÓ BOSS: MỞ KHÓA VÀ FARM
            root.Anchored = false 
            local target = boss.HumanoidRootPart
            pcall(function()
                target.Size = Vector3.new(70,70,70)
                target.CanCollide = false
                for _, v in pairs(char:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CanCollide = false; v.CanTouch = false end 
                end
            end)
            root.Velocity = Vector3.zero
            root.CFrame = CFrame.lookAt(target.Position + Vector3.new(0, Config.Height, Config.Dist), target.Position)
        else
            -- KHI IDLE: ĐÓNG BĂNG TRÊN KHÔNG
            root.Velocity = Vector3.zero
            root.Anchored = true -- Khóa chặt vị trí, không sợ rơi
        end
    else
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.Anchored = false -- Mở khóa khi tắt BossMode
        end
    end
end)

-- [[ 4. GIAO DIỆN (ĐÃ XÓA VERSION) ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_Final") then Player.PlayerGui.BinhHub_Final:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_Final"; sg.ResetOnSpawn = false
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 240, 0, 360); main.Position = UDim2.new(0.05, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(1, 0, 0)

    local stext = Instance.new("TextLabel", main); stext.Size = UDim2.new(0.9, 0, 0, 60); stext.Position = UDim2.new(0.05, 0, 0, 15)
    stext.BackgroundColor3 = Color3.fromRGB(20, 20, 20); stext.TextColor3 = Color3.new(1,1,1); stext.Font = "GothamBold"; stext.TextSize = 10; Instance.new("UICorner", stext)
    
    task.spawn(function()
        while task.wait(0.5) do
            local b = GetCurrentBoss()
            local status = (b ~= nil) and "FARMING BOSS 🔥" or "AIR FREEZE (IDLE) ❄️"
            stext.Text = "STATUS: "..status.."\nTARGET: "..(b and b.Name or "Waiting...")
        end
    end)

    local function AddBtn(text, pos, callback)
        local b = Instance.new("TextButton", main); b.Size = UDim2.new(0.9, 0, 0, 45); b.Position = UDim2.new(0.05, 0, 0, pos)
        b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end)
        return b
    end

    local fBtn = AddBtn("START AUTO FARM", 90, function() Config.BossMode = not Config.BossMode end)
    RS.RenderStepped:Connect(function() fBtn.BackgroundColor3 = Config.BossMode and Color3.new(0, 0.6, 0) or Color3.fromRGB(40, 40, 40) end)
    
    AddBtn("TP RANDOM PLAYER", 150, function()
        local plrs = {}; for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player and p.Character then table.insert(plrs, p) end end
        if #plrs > 0 then 
            if Player.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.Anchored = false end
            Player.Character:PivotTo(plrs[math.random(1, #plrs)].Character:GetPivot()) 
        end
    end)

    AddBtn("ULTRA FPS BOOST", 210, function()
        for _, v in pairs(workspace:GetDescendants()) do pcall(function() if v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.Color = Color3.new(0.4, 0.4, 0.4) end end) end
    end)

    AddBtn("BLACK SCREEN (AFK - J)", 270, function()
        if not Player.PlayerGui:FindFirstChild("AFK_Overlay") then
            local ov = Instance.new("ScreenGui", Player.PlayerGui); ov.Name = "AFK_Overlay"
            local f = Instance.new("Frame", ov); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(0,0,0); f.ZIndex = 999
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

task.spawn(function()
    while task.wait(0.2) do
        if Config.BossMode and GetCurrentBoss() then ExecuteSupremeCombo() end 
    end
end)

CreateUI()
