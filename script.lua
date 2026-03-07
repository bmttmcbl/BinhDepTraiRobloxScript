-- [[ BINHDEPTRAI.HUB - v155 - BACK TO TP BOSS & PLAYER ]]
local Config = { 
    BossMode = false, 
    Dist = 7, 
    Height = 6, -- Đứng cao hơn một chút để né đòn
    RangeSize = Vector3.new(70, 70, 70),
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

-- [[ 2. GOD COMBO V118 ]]
local function ExecuteGodCombo()
    local char = Player.Character
    if not char then return end
    local bp = Player.Backpack
    -- Fruit Skill
    for _, tool in pairs(char:GetChildren()) do if tool:IsA("Tool") then tool.Parent = bp end end
    for _, key in ipairs({"E", "R", "T", "F"}) do VIM:SendKeyEvent(true, key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, key, false, game) end
    -- Sword Skill
    for _, tool in pairs(bp:GetChildren()) do if tool:IsA("Tool") then tool.Parent = char end end
    for _, key in ipairs({"E", "R", "T", "F"}) do VIM:SendKeyEvent(true, key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, key, false, game) end
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- [[ 3. LOGIC TP BOSS (ỔN ĐỊNH NHẤT) ]]
RS.Stepped:Connect(function()
    if Config.BossMode then
        local boss = GetCurrentBoss()
        if boss and boss:FindFirstChild("HumanoidRootPart") and Player.Character then
            local target = boss.HumanoidRootPart
            local root = Player.Character.HumanoidRootPart
            
            pcall(function()
                target.Size = Config.RangeSize -- Phóng to để chém cho dễ
                target.CanCollide = false
                target.Velocity = Vector3.zero -- Khóa Boss đứng im tại chỗ
                
                -- Noclip nhân vật
                for _, v in pairs(Player.Character:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CanCollide = false; v.CanTouch = false end 
                end
            end)
            
            -- TP mình đến phía trên Boss một chút để chém xuống
            root.Velocity = Vector3.zero
            root.CFrame = CFrame.lookAt(target.Position + Vector3.new(0, Config.Height, Config.Dist), target.Position)
        end
    end
end)

-- [[ 4. GIAO DIỆN V155 ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_v155") then Player.PlayerGui.BinhHub_v155:Destroy() end
    local sg = Instance.new("ScreenGui", Player.PlayerGui); sg.Name = "BinhHub_v155"; sg.ResetOnSpawn = false
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 240, 0, 380); main.Position = UDim2.new(0.05, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(1, 0, 0)

    local stext = Instance.new("TextLabel", main); stext.Size = UDim2.new(0.9, 0, 0, 60); stext.Position = UDim2.new(0.05, 0, 0, 10)
    stext.BackgroundColor3 = Color3.fromRGB(25, 25, 25); stext.TextColor3 = Color3.new(1,1,1); stext.Font = "GothamBold"; stext.TextSize = 10; Instance.new("UICorner", stext)
    
    task.spawn(function()
        while task.wait(0.8) do
            local b = GetCurrentBoss()
            stext.Text = "STATIONARY FARM 🔱\nBOSS: "..(b and b.Name or "None").."\nSTATUS: "..(Config.BossMode and "ON" or "OFF")
        end
    end)

    local function AddBtn(text, pos, callback)
        local b = Instance.new("TextButton", main); b.Size = UDim2.new(0.9, 0, 0, 40); b.Position = UDim2.new(0.05, 0, 0, pos)
        b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end)
        return b
    end

    local fBtn = AddBtn("START FARM", 80, function() Config.BossMode = not Config.BossMode end)
    RS.RenderStepped:Connect(function() fBtn.BackgroundColor3 = Config.BossMode and Color3.new(0, 0.6, 0) or Color3.fromRGB(40, 40, 40) end)
    
    -- TRẢ LẠI TP PLAYER ĐÂY ÔNG ƠI
    AddBtn("TP RANDOM PLAYER", 130, function()
        local plrs = {}; for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player and p.Character then table.insert(plrs, p) end end
        if #plrs > 0 then Player.Character:PivotTo(plrs[math.random(1, #plrs)].Character:GetPivot()) end
    end)

    AddBtn("FPS BOOST (GREY)", 180, function()
        for _, v in pairs(workspace:GetDescendants()) do pcall(function() if v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.Color = Color3.new(0.4, 0.4, 0.4) end end) end
    end)

    AddBtn("BLACK SCREEN (AFK - J)", 230, function()
        if not Player.PlayerGui:FindFirstChild("AFK_Overlay") then
            local ov = Instance.new("ScreenGui", Player.PlayerGui); ov.Name = "AFK_Overlay"
            local f = Instance.new("Frame", ov); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(0,0,0); f.ZIndex = 999
            RS:Set3dRenderingEnabled(false)
        else Player.PlayerGui.AFK_Overlay:Destroy(); RS:Set3dRenderingEnabled(true) end
    end)

    AddBtn("HIDE MENU (K)", 280, function() main.Visible = false end)
    
    UIS.InputBegan:Connect(function(i, p) 
        if not p and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
        if i.KeyCode == Enum.KeyCode.J and Player.PlayerGui:FindFirstChild("AFK_Overlay") then 
            Player.PlayerGui.AFK_Overlay:Destroy(); RS:Set3dRenderingEnabled(true)
        end
    end)
end

-- [[ 5. COMBO LOOP ]]
task.spawn(function()
    while task.wait(0.3) do
        if Config.BossMode and GetCurrentBoss() then ExecuteGodCombo() end 
    end
end)

CreateUI()
