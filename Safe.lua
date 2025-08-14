--[[
    🎣 FischCH AutoFarm - Safe & Anti-Detection Version
    ════════════════════════════════════════════════════
    
    Features:
    ✅ Human-like behavior patterns
    ✅ Smart break system 
    ✅ Advanced randomization
    ✅ Multiple anti-detection layers
    ✅ Session camouflage
    ✅ Fail-safe mechanisms
    ✅ Beautiful modern UI
    
    Author: MELLISAEFFENDY
    Version: 3.0 Safe Edition
--]]

--// Services
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local GuiService = game:GetService('GuiService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local Debris = game:GetService('Debris')

--// Variables
local lp = Players.LocalPlayer
local flags = {}
local characterposition

print("🎣 [SAFE-FARM] Initializing secure autofarm system...")

--// Advanced Anti-Detection System
local antiDetection = {
    -- Human behavior simulation
    human = {
        enabled = true,
        reactionTimeVariance = 0.8, -- How much reaction time varies
        focusLevel = 0.85, -- Attention level (affects miss chance)
        fatigueRate = 0.002, -- How quickly fatigue builds up
        currentFatigue = 0,
        lastFocusChange = tick(),
        patterns = {
            "morning_fresh", "focused", "relaxed", "tired", "distracted"
        },
        currentPattern = "focused"
    },
    
    -- Session management
    session = {
        startTime = tick(),
        totalActions = 0,
        fishCaught = 0,
        missedActions = 0,
        lastBreak = tick(),
        isOnBreak = false,
        breakReason = "",
        sessionId = HttpService:GenerateGUID(),
        playTime = 0
    },
    
    -- Smart timing system
    timing = {
        baseDelays = {
            cast = {min = 1.8, max = 4.2},
            reel = {min = 0.6, max = 2.1},
            shake = {min = 0.08, max = 0.6}
        },
        currentMultiplier = 1.0,
        lastActionTime = {},
        actionVariance = {}
    },
    
    -- Break system
    breaks = {
        enabled = true,
        frequency = {min = 8, max = 25}, -- fish count before break
        duration = {min = 12, max = 45}, -- break duration in seconds
        reasons = {
            "bathroom", "drink", "stretch", "phone", "distraction", 
            "fatigue", "boredom", "checking_stats"
        },
        progressToBreak = 0
    },
    
    -- Error simulation
    errors = {
        enabled = true,
        baseChance = 3.5, -- base miss chance percentage
        fatigueFactor = 2.0, -- how fatigue affects errors
        streakFactor = 0.8, -- reduced errors during good streaks
        lastError = 0,
        errorTypes = {"timing", "distraction", "coordination", "fatigue"}
    },
    
    -- Detection avoidance
    detection = {
        actionCooldowns = true,
        randomPauses = true,
        behaviorMixing = true,
        sessionLimits = true,
        maxSessionTime = 7200, -- 2 hours max
        suspicionLevel = 0
    }
}

--// Anti-Detection Helper Functions
local function updateHumanState()
    local currentTime = tick()
    local sessionDuration = currentTime - antiDetection.session.startTime
    
    -- Update fatigue
    antiDetection.human.currentFatigue = math.min(1, antiDetection.human.currentFatigue + antiDetection.human.fatigueRate)
    
    -- Change focus patterns every 5-15 minutes
    if currentTime - antiDetection.human.lastFocusChange > math.random(300, 900) then
        local patterns = antiDetection.human.patterns
        antiDetection.human.currentPattern = patterns[math.random(1, #patterns)]
        antiDetection.human.lastFocusChange = currentTime
        
        -- Adjust focus level based on pattern
        local focusAdjustments = {
            morning_fresh = 0.95,
            focused = 0.9,
            relaxed = 0.75,
            tired = 0.6,
            distracted = 0.45
        }
        antiDetection.human.focusLevel = focusAdjustments[antiDetection.human.currentPattern] or 0.8
    end
    
    -- Session limits
    if sessionDuration > antiDetection.detection.maxSessionTime then
        antiDetection.session.isOnBreak = true
        antiDetection.session.breakReason = "session_limit"
    end
end

local function calculateActionDelay(actionType)
    local baseDelay = antiDetection.timing.baseDelays[actionType]
    if not baseDelay then return 1.0 end
    
    -- Base random delay
    local delay = math.random(baseDelay.min * 100, baseDelay.max * 100) / 100
    
    -- Apply human factors
    local focusMultiplier = 2.0 - antiDetection.human.focusLevel
    local fatigueMultiplier = 1.0 + (antiDetection.human.currentFatigue * 0.8)
    
    -- Pattern-based adjustments
    local patternMultipliers = {
        morning_fresh = 0.85,
        focused = 0.9,
        relaxed = 1.1,
        tired = 1.4,
        distracted = 1.6
    }
    local patternMultiplier = patternMultipliers[antiDetection.human.currentPattern] or 1.0
    
    -- Final calculation
    delay = delay * focusMultiplier * fatigueMultiplier * patternMultiplier
    
    -- Add extra variance for realism
    local variance = math.random(80, 120) / 100
    delay = delay * variance
    
    return math.max(0.1, delay)
end

local function shouldSimulateError(actionType)
    if not antiDetection.errors.enabled then return false end
    
    local baseChance = antiDetection.errors.baseChance
    local fatigueBonus = antiDetection.human.currentFatigue * antiDetection.errors.fatigueFactor
    local focusPenalty = (1.0 - antiDetection.human.focusLevel) * 2.0
    
    local totalChance = baseChance + fatigueBonus + focusPenalty
    
    -- Reduce errors if player has been doing well
    if antiDetection.session.fishCaught > antiDetection.session.missedActions * 3 then
        totalChance = totalChance * antiDetection.errors.streakFactor
    end
    
    -- Cooldown between errors
    if tick() - antiDetection.errors.lastError < 15 then
        totalChance = totalChance * 0.3
    end
    
    return math.random(1, 1000) <= (totalChance * 10)
end

local function checkBreakCondition()
    if not antiDetection.breaks.enabled then return false end
    
    if antiDetection.session.isOnBreak then
        return true
    end
    
    local fishSinceBreak = antiDetection.session.fishCaught
    local breakThreshold = math.random(antiDetection.breaks.frequency.min, antiDetection.breaks.frequency.max)
    
    -- Fatigue makes breaks more likely
    if antiDetection.human.currentFatigue > 0.7 then
        breakThreshold = breakThreshold * 0.7
    end
    
    if fishSinceBreak >= breakThreshold then
        -- Start break
        antiDetection.session.isOnBreak = true
        antiDetection.session.lastBreak = tick()
        
        local duration = math.random(antiDetection.breaks.duration.min, antiDetection.breaks.duration.max)
        local reasons = antiDetection.breaks.reasons
        antiDetection.session.breakReason = reasons[math.random(1, #reasons)]
        
        -- Schedule break end
        spawn(function()
            wait(duration)
            antiDetection.session.isOnBreak = false
            antiDetection.session.fishCaught = 0 -- Reset counter
            antiDetection.human.currentFatigue = antiDetection.human.currentFatigue * 0.5 -- Reduce fatigue
        end)
        
        return true
    end
    
    return false
end

--// Game Helper Functions
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

local function safeWait(duration)
    local startTime = tick()
    while tick() - startTime < duration do
        if not flags.enabled then break end
        RunService.Heartbeat:Wait()
    end
end

--// Modern UI Creation
local function createSafeUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SafeFarm_UI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try multiple parent options
    local success = false
    for _, parent in pairs({game:GetService("CoreGui"), lp:WaitForChild("PlayerGui")}) do
        pcall(function()
            screenGui.Parent = parent
            success = true
        end)
        if success then break end
    end
    
    if not success then
        warn("🎣 [SAFE-FARM] Could not create UI!")
        return
    end
    
    -- Main Frame with gradient
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 450)
    mainFrame.Position = UDim2.new(0, 30, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Add gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Drop shadow
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadow
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 200))
    })
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "🛡️ SafeFarm AutoFish"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Text = "🔒 Anti-Detection • Human-Like • Safe"
    subtitle.Size = UDim2.new(1, -20, 0, 20)
    subtitle.Position = UDim2.new(0, 10, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(200, 220, 255)
    subtitle.Font = Enum.Font.SourceSans
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -80)
    content.Position = UDim2.new(0, 10, 0, 70)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = mainFrame
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Main toggle creation function
    local function createToggle(name, description, flag, defaultValue, icon, order)
        flags[flag] = defaultValue or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = name
        toggleFrame.Size = UDim2.new(1, 0, 0, 60)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.LayoutOrder = order
        toggleFrame.Parent = content
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggleFrame
        
        -- Hover effect
        local hoverTween
        toggleFrame.MouseEnter:Connect(function()
            if hoverTween then hoverTween:Cancel() end
            hoverTween = TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            })
            hoverTween:Play()
        end)
        
        toggleFrame.MouseLeave:Connect(function()
            if hoverTween then hoverTween:Cancel() end
            hoverTween = TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            })
            hoverTween:Play()
        end)
        
        -- Icon
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.Text = icon
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Position = UDim2.new(0, 10, 0, 5)
        iconLabel.BackgroundTransparency = 1
        iconLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
        iconLabel.Font = Enum.Font.SourceSansBold
        iconLabel.TextSize = 18
        iconLabel.Parent = toggleFrame
        
        -- Main label
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = name
        label.Size = UDim2.new(1, -120, 0, 20)
        label.Position = UDim2.new(0, 45, 0, 5)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        -- Description
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.Text = description
        desc.Size = UDim2.new(1, -120, 0, 30)
        desc.Position = UDim2.new(0, 45, 0, 25)
        desc.BackgroundTransparency = 1
        desc.TextColor3 = Color3.fromRGB(180, 180, 190)
        desc.Font = Enum.Font.SourceSans
        desc.TextSize = 11
        desc.TextWrapped = true
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.Parent = toggleFrame
        
        -- Toggle switch
        local switchFrame = Instance.new("Frame")
        switchFrame.Name = "SwitchFrame"
        switchFrame.Size = UDim2.new(0, 50, 0, 26)
        switchFrame.Position = UDim2.new(1, -60, 0.5, -13)
        switchFrame.BackgroundColor3 = flags[flag] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 110)
        switchFrame.BorderSizePixel = 0
        switchFrame.Parent = toggleFrame
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(0, 13)
        switchCorner.Parent = switchFrame
        
        local switchButton = Instance.new("Frame")
        switchButton.Name = "Button"
        switchButton.Size = UDim2.new(0, 22, 0, 22)
        switchButton.Position = flags[flag] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchButton.BorderSizePixel = 0
        switchButton.Parent = switchFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 11)
        buttonCorner.Parent = switchButton
        
        -- Click detection
        local clickDetector = Instance.new("TextButton")
        clickDetector.Size = UDim2.new(1, 0, 1, 0)
        clickDetector.BackgroundTransparency = 1
        clickDetector.Text = ""
        clickDetector.Parent = toggleFrame
        
        clickDetector.MouseButton1Click:Connect(function()
            flags[flag] = not flags[flag]
            
            -- Animate switch
            local switchTween = TweenService:Create(switchFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = flags[flag] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 110)
            })
            switchTween:Play()
            
            local buttonTween = TweenService:Create(switchButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Position = flags[flag] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            })
            buttonTween:Play()
            
            -- Visual feedback
            local feedbackTween = TweenService:Create(toggleFrame, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            })
            feedbackTween:Play()
            feedbackTween.Completed:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                }):Play()
            end)
        end)
        
        return toggleFrame
    end
    
    -- Create toggles
    createToggle("Auto Cast", "Automatically cast fishing line with human timing", "autocast", false, "🎯", 1)
    createToggle("Auto Shake", "Smart shake detection with reaction variance", "autoshake", false, "🎣", 2)
    createToggle("Auto Reel", "Intelligent reel timing with success patterns", "autoreel", false, "🐟", 3)
    createToggle("Human Behavior", "Advanced anti-detection behavior simulation", "humanbehavior", true, "🤖", 4)
    createToggle("Smart Breaks", "Realistic break patterns based on fatigue", "smartbreaks", true, "☕", 5)
    createToggle("Freeze Position", "Lock character position while fishing", "freeze", false, "❄️", 6)
    
    -- Stats panel
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(1, 0, 0, 120)
    statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    statsFrame.BorderSizePixel = 0
    statsFrame.LayoutOrder = 7
    statsFrame.Parent = content
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsFrame
    
    local statsTitle = Instance.new("TextLabel")
    statsTitle.Text = "📊 Session Statistics"
    statsTitle.Size = UDim2.new(1, -20, 0, 25)
    statsTitle.Position = UDim2.new(0, 10, 0, 5)
    statsTitle.BackgroundTransparency = 1
    statsTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    statsTitle.Font = Enum.Font.SourceSansBold
    statsTitle.TextSize = 14
    statsTitle.TextXAlignment = Enum.TextXAlignment.Left
    statsTitle.Parent = statsFrame
    
    local statsContent = Instance.new("TextLabel")
    statsContent.Name = "StatsContent"
    statsContent.Text = "🐟 Fish: 0 | ⏱️ Time: 0m | 📈 Rate: 0/h\n🎯 Accuracy: 100% | 😴 Fatigue: 0%\n🔄 Status: Ready"
    statsContent.Size = UDim2.new(1, -20, 0, 85)
    statsContent.Position = UDim2.new(0, 10, 0, 30)
    statsContent.BackgroundTransparency = 1
    statsContent.TextColor3 = Color3.fromRGB(200, 200, 210)
    statsContent.Font = Enum.Font.SourceSans
    statsContent.TextSize = 12
    statsContent.TextWrapped = true
    statsContent.TextXAlignment = Enum.TextXAlignment.Left
    statsContent.TextYAlignment = Enum.TextYAlignment.Top
    statsContent.Parent = statsFrame
    
    -- Control buttons
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.LayoutOrder = 8
    buttonFrame.Parent = content
    
    local startButton = Instance.new("TextButton")
    startButton.Name = "StartButton"
    startButton.Text = "▶️ Start SafeFarm"
    startButton.Size = UDim2.new(0.48, 0, 1, 0)
    startButton.Position = UDim2.new(0, 0, 0, 0)
    startButton.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    startButton.Font = Enum.Font.SourceSansBold
    startButton.TextSize = 14
    startButton.BorderSizePixel = 0
    startButton.Parent = buttonFrame
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 6)
    startCorner.Parent = startButton
    
    local resetButton = Instance.new("TextButton")
    resetButton.Name = "ResetButton"
    resetButton.Text = "🔄 Reset Stats"
    resetButton.Size = UDim2.new(0.48, 0, 1, 0)
    resetButton.Position = UDim2.new(0.52, 0, 0, 0)
    resetButton.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.Font = Enum.Font.SourceSansBold
    resetButton.TextSize = 14
    resetButton.BorderSizePixel = 0
    resetButton.Parent = buttonFrame
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 6)
    resetCorner.Parent = resetButton
    
    -- Button functionality
    flags.enabled = false
    
    startButton.MouseButton1Click:Connect(function()
        flags.enabled = not flags.enabled
        startButton.Text = flags.enabled and "⏸️ Stop SafeFarm" or "▶️ Start SafeFarm"
        startButton.BackgroundColor3 = flags.enabled and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(0, 180, 100)
        
        if flags.enabled then
            antiDetection.session.startTime = tick()
            print("🎣 [SAFE-FARM] SafeFarm started with anti-detection enabled!")
        else
            print("🎣 [SAFE-FARM] SafeFarm stopped.")
        end
    end)
    
    resetButton.MouseButton1Click:Connect(function()
        antiDetection.session = {
            startTime = tick(),
            totalActions = 0,
            fishCaught = 0,
            missedActions = 0,
            lastBreak = tick(),
            isOnBreak = false,
            breakReason = "",
            sessionId = HttpService:GenerateGUID(),
            playTime = 0
        }
        antiDetection.human.currentFatigue = 0
        print("🎣 [SAFE-FARM] Session statistics reset!")
    end)
    
    -- Stats updater
    spawn(function()
        while screenGui.Parent do
            if statsContent then
                local session = antiDetection.session
                local sessionTime = tick() - session.startTime
                local fishPerHour = session.fishCaught > 0 and math.floor((session.fishCaught / sessionTime) * 3600) or 0
                local accuracy = session.totalActions > 0 and math.floor(((session.totalActions - session.missedActions) / session.totalActions) * 100) or 100
                local fatiguePercent = math.floor(antiDetection.human.currentFatigue * 100)
                
                local status = "Ready"
                if flags.enabled then
                    if session.isOnBreak then
                        status = "On Break (" .. session.breakReason .. ")"
                    else
                        status = "Farming (" .. antiDetection.human.currentPattern .. ")"
                    end
                end
                
                statsContent.Text = string.format(
                    "🐟 Fish: %d | ⏱️ Time: %dm | 📈 Rate: %d/h\n🎯 Accuracy: %d%% | 😴 Fatigue: %d%%\n🔄 Status: %s",
                    session.fishCaught,
                    math.floor(sessionTime / 60),
                    fishPerHour,
                    accuracy,
                    fatiguePercent,
                    status
                )
            end
            wait(1)
        end
    end)
    
    print("🎣 [SAFE-FARM] Advanced UI created successfully!")
    
    -- Success notification
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 350, 0, 70)
    notification.Position = UDim2.new(0.5, -175, 0, -80)
    notification.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifGradient = Instance.new("UIGradient")
    notifGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 100))
    })
    notifGradient.Rotation = 90
    notifGradient.Parent = notification
    
    local notifLabel = Instance.new("TextLabel")
    notifLabel.Text = "✅ SafeFarm Loaded!\nAnti-detection systems active"
    notifLabel.Size = UDim2.new(1, 0, 1, 0)
    notifLabel.BackgroundTransparency = 1
    notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifLabel.Font = Enum.Font.SourceSansBold
    notifLabel.TextSize = 16
    notifLabel.Parent = notification
    
    -- Animate notification
    TweenService:Create(notification, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -175, 0, 20)
    }):Play()
    
    Debris:AddItem(notification, 4)
end

--// Safe Autofarm Logic
local function performAction(actionType, actionFunction)
    if not flags.enabled then return false end
    if checkBreakCondition() then return false end
    
    updateHumanState()
    
    -- Check if we should simulate an error
    if shouldSimulateError(actionType) then
        antiDetection.session.missedActions = antiDetection.session.missedActions + 1
        antiDetection.errors.lastError = tick()
        
        local errorType = antiDetection.errors.errorTypes[math.random(1, #antiDetection.errors.errorTypes)]
        print("🎣 [SAFE-FARM] Simulated " .. errorType .. " error for realism")
        return false
    end
    
    -- Calculate and apply delay
    local delay = calculateActionDelay(actionType)
    safeWait(delay)
    
    if not flags.enabled then return false end
    
    -- Perform the action
    local success = actionFunction()
    
    -- Update statistics
    antiDetection.session.totalActions = antiDetection.session.totalActions + 1
    antiDetection.timing.lastActionTime[actionType] = tick()
    
    return success
end

local function safeCast()
    return performAction("cast", function()
        local rod = findRod()
        if rod and rod.values and rod.values:FindFirstChild('lure') then
            if rod.values.lure.Value <= 0.001 then
                pcall(function()
                    rod.events.cast:FireServer(100, 1)
                end)
                return true
            end
        end
        return false
    end)
end

local function safeShake()
    return performAction("shake", function()
        local shakeUI = lp.PlayerGui:FindFirstChild('shakeui')
        if shakeUI and shakeUI:FindFirstChild('safezone') and shakeUI.safezone:FindFirstChild('button') then
            pcall(function()
                GuiService.SelectedObject = shakeUI.safezone.button
                UserInputService:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                UserInputService:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end)
            return true
        end
        return false
    end)
end

local function safeReel()
    return performAction("reel", function()
        local rod = findRod()
        if rod and rod.values and rod.values:FindFirstChild('lure') then
            if rod.values.lure.Value >= 99.9 then
                pcall(function()
                    ReplicatedStorage.events.reelfinished:FireServer(100, true)
                    antiDetection.session.fishCaught = antiDetection.session.fishCaught + 1
                end)
                return true
            end
        end
        return false
    end)
end

--// Main Loop
local function mainLoop()
    if not flags.enabled then return end
    
    pcall(function()
        -- Auto Cast
        if flags.autocast then
            safeCast()
        end
        
        -- Auto Shake  
        if flags.autoshake then
            safeShake()
        end
        
        -- Auto Reel
        if flags.autoreel then
            safeReel()
        end
        
        -- Freeze Character
        if flags.freeze then
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
    end)
end

--// Initialize
wait(3) -- Wait for game to fully load
createSafeUI()

-- Start main loop
RunService.Heartbeat:Connect(mainLoop)

print("🎣 [SAFE-FARM] SafeFarm fully initialized with advanced anti-detection!")
print("🛡️ [SAFE-FARM] Human behavior simulation active")
print("📊 [SAFE-FARM] Session monitoring enabled")
print("🔒 [SAFE-FARM] Ready for safe autofishing!")
