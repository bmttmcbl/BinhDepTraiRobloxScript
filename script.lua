-- [[ BINH DEPTRAI - v1024 - ANTI-AFK 2 LAYERS - NO FPS LIMIT ]]
local Player = game.Players.LocalPlayer
local RS, VIM, TS, UIS = game:GetService("RunService"), game:GetService("VirtualInputManager"), game:GetService("TweenService"), game:GetService("UserInputService")

-- [[ 🛡️ LỚP 1: CHẶN TÍN HIỆU IDLED (ANTI-AFK) ]]
if getconnections then
    for _, v in pairs(getconnections(Player.Idled)) do
        v:Disable()
    end
end

-- [[ 🛡️ LỚP 2: GIẢ LẬP PHÍM VIRTUAL (ANTI-AFK) ]]
Player.Idled:Connect(function()
    VIM:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    task.wait(0.5)
    VIM:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

_G.AutoFarm_BinhDepTrai = _G.AutoFarm_BinhDepTrai or false

local Config = {
    Dist = 2.8, 
    Height = 3.0,
    WhiteScreen = false,
    CurrentTarget = nil
}

local BossList = {"Kyo", "Shinoa", "Duck Boss", "Chara", "Cutie Boss", "Sword Master", "Sans", "King Noob"}

local function GetValidTarget()
    for _, name in ipairs(BossList) do
        local b = workspace:FindFirstChild(name, true)
        if b and b:FindFirstChild("Humanoid") and b:FindFirstChild("HumanoidRootPart") then
            if b.Humanoid.Health > 0 then return b end
        end
    end
    return nil
end

local function ExecuteCombo()
    if not Config.CurrentTarget or not _G.AutoFarm_BinhDepTrai then return end
    local char = Player.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    hum:UnequipTools()
    task.wait(0.05)
    for _, k in {"E", "R", "T", "F"} do VIM:SendKeyEvent(true, k, false, game); task.wait(0.01); VIM:SendKeyEvent(false, k, false, game) end
    
    for _, t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = char end end
    task.wait(0.05)
    for _, k in {"E", "R", "T", "F"} do VIM:SendKeyEvent(true, k, false, game); task.wait(0.01); VIM:SendKeyEvent(false, k, false, game) end
    
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.02); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    hum:UnequipTools()
end

local function CreateUI()
    if Player.PlayerGui:FindFirstChild("BinhHub_V24") then Player.PlayerGui.BinhHub_V24:Destroy() end
    local sg = Instance.new("ScreenGui", (game:GetService("CoreGui") or Player.PlayerGui)); sg.Name = "BinhHub_V24"; sg.ResetOnSpawn = false
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 260, 0, 300); main.Position = UDim2.new(0.5, -130, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BackgroundTransparency = 0.2; main.Active = true; main.Draggable = true 
    Instance.new("UICorner", main); local stroke = Instance.new("UIStroke", main, {Color = Color3.new(1,0,0), Thickness = 2})

    local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1, 0, 0, 50); title.Text = "BINH DEPTRAI V24"; title.TextColor3 = Color3.new(1, 0, 0); title.Font = "GothamBold"; title.TextSize = 18; title.BackgroundTransparency = 1

    local container = Instance.new("ScrollingFrame", main); container.Size = UDim2.new(1, -20, 1, -70); container.Position = UDim2.new(0, 10, 0, 60); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

    local function AddBtn(txt, cb)
        local b = Instance.new("TextButton", container); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30,30,35); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() cb(b) end)
    end

    AddBtn(_G.AutoFarm_BinhDepTrai and "FARMING: ON" or "START ELITE FARM", function(b) 
        _G.AutoFarm_BinhDepTrai = not _G.AutoFarm_BinhDepTrai
        b.Text = _G.AutoFarm_BinhDepTrai and "FARMING: ON" or "FARMING: OFF"
        b.TextColor3 = _G.AutoFarm_BinhDepTrai and Color3.new(0,1,0) or Color3.new(1,1,1)
    end)
    
    AddBtn("ULTRA BOOST (CLEAN)", function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0.6 end end end)
    AddBtn("WHITE SCREEN (AFK)", function() Config.WhiteScreen = not Config.WhiteScreen; RS:Set3dRenderingEnabled(not Config.WhiteScreen) end)
    
    task.spawn(function() while task.wait() do stroke.Color = Color3.fromHSV(tick()%5/5, 0.8, 1) end end)
    UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end end)
end

RS.Heartbeat:Connect(function()
    local char = Player.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if _G.AutoFarm_BinhDepTrai then
        root.AssemblyLinearVelocity = Vector3.zero
        local target = GetValidTarget()
        Config.CurrentTarget = target
        
        if target then
            root.Anchored = false
            local targetPos = (target.HumanoidRootPart.CFrame * CFrame.new(0, Config.Height, Config.Dist)).Position
            root.CFrame = root.CFrame:Lerp(CFrame.lookAt(targetPos, target.HumanoidRootPart.Position), 0.25)
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        else
            root.Anchored = true
        end
    else
        root.Anchored = false
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarm_BinhDepTrai and Config.CurrentTarget then
            ExecuteCombo()
        end
    end
end)

CreateUI()
