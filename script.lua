-- [[ BINH DEPTRAI - v1016 - ANTI FALL & FREEZE ]]
local Player = game.Players.LocalPlayer
local RS, VIM, TS, UIS = game:GetService("RunService"), game:GetService("VirtualInputManager"), game:GetService("TweenService"), game:GetService("UserInputService")

local Config = {
    Farm = false,
    Dist = 2.0, 
    Height = 2.5,
    IsHealing = false,
    WhiteScreen = false,
    CurrentTarget = nil
}

local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

-- [[ 🔍 CHECK TARGET ]]
local function GetValidTarget()
    for _, name in ipairs(BossList) do
        local b = workspace:FindFirstChild(name, true)
        if b and b:FindFirstChild("Humanoid") and b:FindFirstChild("HumanoidRootPart") then
            if b.Humanoid.Health > 0 then return b end
        end
    end
    return nil
end

-- [[ ⚔️ SUPREME COMBO LOOP ]]
local function ExecuteCombo()
    if not Config.CurrentTarget then return end
    local char = Player.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    hum:UnequipTools()
    task.wait(0.05)
    for _, k in {"E", "R", "T", "F"} do VIM:SendKeyEvent(true, k, false, game); task.wait(0.01); VIM:SendKeyEvent(false, k, false, game) end
    
    for _, t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = char end end
    task.wait(0.05)
    for _, k in {"E", "R", "T", "F"} do VIM:SendKeyEvent(true, k, false, game); task.wait(0.01); VIM:SendKeyEvent(false, k, false, game) end
    
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.02); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    hum:UnequipTools()
end

-- [[ 💉 EMERGENCY HEAL (FIXED POSITION) ]]
local function HandleHeal()
    local char = Player.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum and (hum.Health / hum.MaxHealth) <= 0.20 and not Config.IsHealing then
        Config.IsHealing = true
        local statue = workspace:FindFirstChild("Tiny Statue Island", true)
        task.spawn(function()
            while Config.IsHealing and hum.Health < hum.MaxHealth do
                if statue then 
                    char:PivotTo(statue:GetPivot() * CFrame.new(0, 15, 0)) 
                end
                hum:UnequipTools()
                task.wait(0.2)
                VIM:SendKeyEvent(true, "T", false, game); task.wait(0.01); VIM:SendKeyEvent(false, "T", false, game)
                task.wait(1.5)
                if not Config.Farm or hum.Health >= hum.MaxHealth then break end
            end
            Config.IsHealing = false
        end)
    end
end

-- [[ 🎨 UI BINH DEPTRAI ]]
local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_V16") then Player.PlayerGui.BinhHub_V16:Destroy() end
    local sg = Instance.new("ScreenGui", (game:GetService("CoreGui") or Player.PlayerGui)); sg.Name = "BinhHub_V16"; sg.ResetOnSpawn = false
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 280, 0, 320); main.Position = UDim2.new(0.5, -140, 0.4, 0); main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BackgroundTransparency = 0.3; main.Active = true
    Instance.new("UICorner", main); local stroke = Instance.new("UIStroke", main, {Color = Color3.new(1,0,0), Thickness = 2.5})

    local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1, 0, 0, 50); title.Text = "BINH DEPTRAI"; title.TextColor3 = Color3.new(1, 0, 0); title.Font = "GothamBold"; title.TextSize = 20; title.BackgroundTransparency = 1

    local container = Instance.new("ScrollingFrame", main); container.Size = UDim2.new(1, -20, 1, -70); container.Position = UDim2.new(0, 10, 0, 60); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

    local function AddBtn(txt, cb)
        local b = Instance.new("TextButton", container); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30,30,35); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
    end

    AddBtn("START ELITE FARM", function(b) Config.Farm = not Config.Farm; b.TextColor3 = Config.Farm and Color3.new(0,1,0) or Color3.new(1,1,1) end)
    AddBtn("ULTRA BOOST (20 FPS)", function() if setfpscap then setfpscap(20) end; for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0.6 end end end)
    AddBtn("WHITE SCREEN (AFK)", function() Config.WhiteScreen = not Config.WhiteScreen; RS:Set3dRenderingEnabled(not Config.WhiteScreen) end)
    
    -- Draggable
    local d, ds, sp; title.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = main.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds; main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
    task.spawn(function() while task.wait() do stroke.Color = Color3.fromHSV(tick()%5/5, 0.8, 1) end end)
    UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end end)
end

-- [[ 🚀 CORE ENGINE - THE FREEZER ]]
RS.Heartbeat:Connect(function()
    local char = Player.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if Config.Farm and not Config.IsHealing then
        root.AssemblyLinearVelocity = Vector3.zero
        
        local target = GetValidTarget()
        Config.CurrentTarget = target
        
        if target then
            -- CÓ BOSS: NHẢ FREEZE VÀ BAY TỚI
            root.Anchored = false
            local targetPos = (target.HumanoidRootPart.CFrame * CFrame.new(0, Config.Height, Config.Dist)).Position
            root.CFrame = root.CFrame:Lerp(CFrame.lookAt(targetPos, target.HumanoidRootPart.Position), 0.25)
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        else
            -- HẾT BOSS: ĐÓNG BĂNG NGAY LẬP TỨC ĐỂ KHÔNG RƠI XUỐNG NƯỚC
            root.Anchored = true
        end
    else
        -- KHI TẮT FARM HOẶC ĐANG HỒI MÁU: NHẢ FREEZE ĐỂ DI CHUYỂN BÌNH THƯỜNG
        if not Config.IsHealing then root.Anchored = false end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        HandleHeal()
        if Config.Farm and not Config.IsHealing and Config.CurrentTarget then ExecuteCombo() end
    end
end)

CreateUI()
