--// FischCH - Simple Version (No External Library)
--// Services
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local GuiService = game:GetService('GuiService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')

--// Variables
local lp = Players.LocalPlayer
local flags = {}
local characterposition

print("[FISHCH] Starting Simple FischCH...")

--// Human Behavior System
local humanBehavior = {
    delays = {
        cast = {min = 1.2, max = 3.5},
        reel = {min = 0.4, max = 1.8},
        shake = {min = 0.05, max = 0.4}
    },
    session = {
        startTime = tick(),
        fishCaught = 0,
        isOnBreak = false
    },
    lastActions = {
        cast = 0,
        reel = 0,
        shake = 0
    }
}

--// Helper Functions
local function getChar()
    return lp.Character
end

local function getHRP()
    local char = getChar()
    return char and char:FindFirstChild('HumanoidRootPart')
end

local function findRod()
    local char = getChar()
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA('Tool') and tool:FindFirstChild('values') then
                return tool
            end
        end
    end
    return nil
end

local function getRandomDelay(actionType)
    local delays = humanBehavior.delays[actionType]
    if not delays then return 0.5 end
    return math.random(delays.min * 100, delays.max * 100) / 100
end

local function canPerformAction(actionType)
    local now = tick()
    local minInterval = getRandomDelay(actionType)
    return now - humanBehavior.lastActions[actionType] >= minInterval
end

--// Simple UI Creation
local function createSimpleUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FischCH_UI"
    screenGui.ResetOnSpawn = false
    
    -- Try multiple parents
    local success = false
    for _, parent in pairs({game:GetService("CoreGui"), lp:WaitForChild("PlayerGui")}) do
        pcall(function()
            screenGui.Parent = parent
            success = true
        end)
        if success then break end
    end
    
    if not success then
        warn("[FISHCH] Could not create UI!")
        return
    end
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 350)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "🎣 FischCH v2.0"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.BorderSizePixel = 0
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = contentFrame
    
    -- Toggle creation function
    local function createToggle(name, flag, defaultValue, order)
        flags[flag] = defaultValue or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = name
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.LayoutOrder = order
        toggleFrame.Parent = contentFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = name
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(0, 40, 0, 20)
        button.Position = UDim2.new(1, -45, 0.5, -10)
        button.BackgroundColor3 = flags[flag] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        button.Text = flags[flag] and "ON" or "OFF"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 12
        button.BorderSizePixel = 0
        button.Parent = toggleFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            flags[flag] = not flags[flag]
            button.Text = flags[flag] and "ON" or "OFF"
            button.BackgroundColor3 = flags[flag] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
            
            -- Animate button
            local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 45, 0, 22)
            })
            tween:Play()
            tween.Completed:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 40, 0, 20)
                }):Play()
            end)
        end)
        
        return toggleFrame
    end
    
    -- Create toggles
    createToggle("🎯 Auto Cast", "autocast", false, 1)
    createToggle("🎣 Auto Shake", "autoshake", false, 2)
    createToggle("🐟 Auto Reel", "autoreel", false, 3)
    createToggle("❄️ Freeze Character", "freezechar", false, 4)
    createToggle("🤖 Human Behavior", "humanbehavior", true, 5)
    createToggle("💎 Infinite Oxygen", "infoxygen", false, 6)
    createToggle("🌊 No Temp & Oxygen", "nopeakssystems", false, 7)
    
    -- Stats label
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "Stats"
    statsLabel.Text = "📊 Session: Starting..."
    statsLabel.Size = UDim2.new(1, 0, 0, 40)
    statsLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statsLabel.Font = Enum.Font.SourceSans
    statsLabel.TextSize = 12
    statsLabel.TextWrapped = true
    statsLabel.BorderSizePixel = 0
    statsLabel.LayoutOrder = 8
    statsLabel.Parent = contentFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 6)
    statsCorner.Parent = statsLabel
    
    -- Update stats
    spawn(function()
        while screenGui.Parent do
            local sessionTime = tick() - humanBehavior.session.startTime
            local fishPerHour = humanBehavior.session.fishCaught > 0 and 
                math.floor((humanBehavior.session.fishCaught / sessionTime) * 3600) or 0
                
            statsLabel.Text = string.format("📊 Fish: %d | Time: %dm | Rate: %d/h%s", 
                humanBehavior.session.fishCaught,
                math.floor(sessionTime / 60),
                fishPerHour,
                humanBehavior.session.isOnBreak and "\n🛑 ON BREAK" or ""
            )
            wait(1)
        end
    end)
    
    print("[FISHCH] UI Created Successfully!")
    
    -- Notification
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(0.5, -150, 0, -70)
    notification.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifLabel = Instance.new("TextLabel")
    notifLabel.Text = "✅ FischCH Loaded Successfully!"
    notifLabel.Size = UDim2.new(1, 0, 1, 0)
    notifLabel.BackgroundTransparency = 1
    notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifLabel.Font = Enum.Font.SourceSansBold
    notifLabel.TextSize = 16
    notifLabel.Parent = notification
    
    -- Animate notification
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()
    
    -- Remove notification after 3 seconds
    game:GetService("Debris"):AddItem(notification, 3)
end

--// Main Logic
local function mainLoop()
    pcall(function()
        -- Auto Cast
        if flags.autocast then
            local rod = findRod()
            if rod and rod.values and rod.values:FindFirstChild('lure') then
                if rod.values.lure.Value <= 0.001 and canPerformAction('cast') then
                    if flags.humanbehavior then
                        wait(getRandomDelay('cast'))
                    else
                        wait(0.5)
                    end
                    rod.events.cast:FireServer(100, 1)
                    humanBehavior.lastActions.cast = tick()
                end
            end
        end
        
        -- Auto Shake
        if flags.autoshake then
            local shakeUI = lp.PlayerGui:FindFirstChild('shakeui')
            if shakeUI and shakeUI:FindFirstChild('safezone') and shakeUI.safezone:FindFirstChild('button') then
                if canPerformAction('shake') then
                    if flags.humanbehavior then
                        wait(getRandomDelay('shake'))
                    end
                    GuiService.SelectedObject = shakeUI.safezone.button
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    humanBehavior.lastActions.shake = tick()
                end
            end
        end
        
        -- Auto Reel
        if flags.autoreel then
            local rod = findRod()
            if rod and rod.values and rod.values:FindFirstChild('lure') then
                if rod.values.lure.Value >= 99.9 and canPerformAction('reel') then
                    if flags.humanbehavior then
                        wait(getRandomDelay('reel'))
                    else
                        wait(0.5)
                    end
                    ReplicatedStorage.events.reelfinished:FireServer(100, true)
                    humanBehavior.lastActions.reel = tick()
                    humanBehavior.session.fishCaught = humanBehavior.session.fishCaught + 1
                end
            end
        end
        
        -- Freeze Character
        if flags.freezechar then
            local hrp = getHRP()
            if hrp then
                if not characterposition then
                    characterposition = hrp.CFrame
                else
                    hrp.CFrame = characterposition
                end
            end
        else
            characterposition = nil
        end
        
        -- Infinite Oxygen
        if flags.infoxygen then
            local char = getChar()
            if char and not char:FindFirstChild('DivingTank') then
                local tank = Instance.new('Decal')
                tank.Name = 'DivingTank'
                tank:SetAttribute('Tier', math.huge)
                tank.Parent = char
            end
        end
        
        -- No Temperature & Oxygen
        if flags.nopeakssystems then
            local char = getChar()
            if char then
                char:SetAttribute('WinterCloakEquipped', true)
                char:SetAttribute('Refill', true)
            end
        end
    end)
end

--// Initialize
wait(2) -- Wait for game to load
createSimpleUI()

-- Main loop
RunService.Heartbeat:Connect(mainLoop)

print("[FISHCH] Script fully initialized!")
