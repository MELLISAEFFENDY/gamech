--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))

--// Anti-Detection Variables
local antiDetection = {
    randomSeed = tick(),
    lastAction = 0,
    actionCount = 0,
    humanBehavior = true,
    detectionFlags = {}
}

--// Anti-Detection Functions
local function randomDelay(min, max)
    min = min or 0.1
    max = max or 0.5
    return min + (math.random() * (max - min))
end

local function isDetectionRisky()
    local currentTime = tick()
    antiDetection.actionCount = antiDetection.actionCount + 1
    
    -- Reset counter every minute
    if currentTime - antiDetection.lastAction > 60 then
        antiDetection.actionCount = 0
    end
    
    -- Too many actions in short time = risky
    if antiDetection.actionCount > 20 then
        return true
    end
    
    antiDetection.lastAction = currentTime
    return false
end

local function humanizeAction(callback)
    if isDetectionRisky() then
        task.wait(randomDelay(1, 3)) -- Longer delay if risky
    else
        task.wait(randomDelay(0.05, 0.2)) -- Normal human delay
    end
    
    if callback then
        callback()
    end
end

--// Variables
local flags = {}
local characterposition
local lp = Players.LocalPlayer
local fishabundancevisible = false
local deathcon
local tooltipmessage

-- Cast Statistics
local castStats = {
    totalCasts = 0,
    totalReels = 0,
    totalShakes = 0,
    avgCastPower = 0,
    avgReelPower = 0,
    avgShakeDelay = 0,
    successfulReels = 0,
    lastStatsUpdate = tick()
}
local TeleportLocations = {
    ['Zones'] = {
        ['Moosewood'] = CFrame.new(379.875458, 134.500519, 233.5495, -0.033920113, 8.13274355e-08, 0.999424577, 8.98441925e-08, 1, -7.83249803e-08, -0.999424577, 8.7135696e-08, -0.033920113),
        ['Roslit Bay'] = CFrame.new(-1472.9812, 132.525513, 707.644531, -0.00177415239, 1.15743369e-07, -0.99999845, -9.25943056e-09, 1, 1.15759981e-07, 0.99999845, 9.46479251e-09, -0.00177415239),
        ['Forsaken Shores'] = CFrame.new(-2491.104, 133.250015, 1561.2926, 0.355353981, -1.68352852e-08, -0.934731781, 4.69647858e-08, 1, -1.56367586e-10, 0.934731781, -4.38439116e-08, 0.355353981),
        ['Sunstone Island'] = CFrame.new(-913.809143, 138.160782, -1133.25879, -0.746701241, 4.50330218e-09, 0.665159583, 2.84934609e-09, 1, -3.5716119e-09, -0.665159583, -7.71657294e-10, -0.746701241),
        ['Statue of Sovereignty'] = CFrame.new(21.4017925, 159.014709, -1039.14233, -0.865476549, -4.38348664e-08, -0.500949502, -9.38435818e-08, 1, 7.46273798e-08, 0.500949502, 1.11599142e-07, -0.865476549),
        ['Terrapin Island'] = CFrame.new(-193.434143, 135.121979, 1951.46936, 0.512723684, -6.94711346e-08, 0.858553708, 5.44089183e-08, 1, 4.84237539e-08, -0.858553708, 2.18849721e-08, 0.512723684),
        ['Snowcap Island'] = CFrame.new(2607.93018, 135.284332, 2436.13208, 0.909039497, -7.49003748e-10, 0.4167099, 3.38659367e-09, 1, -5.59032465e-09, -0.4167099, 6.49305321e-09, 0.909039497),
        ['Mushgrove Swamp'] = CFrame.new(2434.29785, 131.983276, -691.930542, -0.123090521, -7.92820209e-09, -0.992395461, -9.05862692e-08, 1, 3.2467995e-09, 0.992395461, 9.02970569e-08, -0.123090521),
        ['Ancient Isle'] = CFrame.new(6056.02783, 195.280167, 276.270325, -0.655055285, 1.96010075e-09, 0.755580962, -1.63855578e-08, 1, -1.67997189e-08, -0.755580962, -2.33853594e-08, -0.655055285),
        ['Northern Expedition'] = CFrame.new(-1701.02979, 187.638779, 3944.81494, 0.918493569, -8.5804345e-08, 0.395435959, 8.59132356e-08, 1, 1.74328942e-08, -0.395435959, 1.7961181e-08, 0.918493569),
        ['Northern Summit'] = CFrame.new(19608.791, 131.420105, 5222.15283, 0.462794542, -2.64426987e-08, 0.886465549, -4.47066562e-08, 1, 5.31692343e-08, -0.886465549, -6.42373408e-08, 0.462794542),
        ['Vertigo'] = CFrame.new(-102.40567, -513.299377, 1052.07104, -0.999989033, 5.36423439e-09, 0.00468267547, 5.85247495e-09, 1, 1.04251647e-07, -0.00468267547, 1.04277916e-07, -0.999989033),
        ['Depths Entrance'] = CFrame.new(-15.4965982, -706.123718, 1231.43494, 0.0681341439, 1.15903154e-08, -0.997676194, 7.1017638e-08, 1, 1.64673093e-08, 0.997676194, -7.19745898e-08, 0.0681341439),
        ['Depths'] = CFrame.new(491.758118, -706.123718, 1230.6377, 0.00879980437, 1.29271776e-08, -0.999961257, 1.95575205e-13, 1, 1.29276803e-08, 0.999961257, -1.13956629e-10, 0.00879980437),
        ['Overgrowth Caves'] = CFrame.new(19746.2676, 416.00293, 5403.5752, 0.488031536, -3.30940715e-08, -0.87282598, -3.24267696e-11, 1, -3.79341323e-08, 0.87282598, 1.85413569e-08, 0.488031536),
        ['Frigid Cavern'] = CFrame.new(20253.6094, 756.525818, 5772.68555, -0.781508088, 1.85673343e-08, 0.623895109, 5.92671467e-09, 1, -2.23363816e-08, -0.623895109, -1.3758414e-08, -0.781508088),
        ['Cryogenic Canal'] = CFrame.new(19958.5176, 917.195923, 5332.59375, 0.758922458, -7.29783434e-09, 0.651180983, -4.58880756e-09, 1, 1.65551253e-08, -0.651180983, -1.55522013e-08, 0.758922458),
        ['Glacial Grotto'] = CFrame.new(20003.0273, 1136.42798, 5555.95996, 0.983130038, -3.94455064e-08, 0.182907909, 3.45229765e-08, 1, 3.0096718e-08, -0.182907909, -2.32744615e-08, 0.983130038),
        ["Keeper's Altar"] = CFrame.new(1297.92285, -805.292236, -284.155823, -0.99758029, 5.80044706e-08, -0.0695239156, 6.16549869e-08, 1, -5.03615105e-08, 0.0695239156, -5.45261436e-08, -0.99758029)
    },
    ['Rods'] = {
        ['Heaven Rod'] = CFrame.new(20025.0508, -467.665955, 7114.40234, -0.9998191, -2.41349773e-10, 0.0190212391, -4.76249762e-10, 1, -1.23448247e-08, -0.0190212391, -1.23516495e-08, -0.9998191),
        ['Summit Rod'] = CFrame.new(20213.334, 736.668823, 5707.8208, -0.274440169, 3.53429606e-08, 0.961604178, -1.52819659e-08, 1, -4.11156122e-08, -0.961604178, -2.59789772e-08, -0.274440169),
        ['Kings Rod'] = CFrame.new(1380.83862, -807.198608, -304.22229, -0.692510426, 9.24755454e-08, 0.72140789, 4.86611427e-08, 1, -8.1475676e-08, -0.72140789, -2.13182219e-08, -0.692510426)
    }
}
local ZoneNames = {}
local RodNames = {}
local RodColors = {}
local RodMaterials = {}
for i,v in pairs(TeleportLocations['Zones']) do table.insert(ZoneNames, i) end
for i,v in pairs(TeleportLocations['Rods']) do table.insert(RodNames, i) end

-- Debug: Print zona dan rod yang tersedia
print("[DEBUG] Available Zones:", #ZoneNames)
for i, zone in ipairs(ZoneNames) do
    print(" -", i, zone)
end
print("[DEBUG] Available Rods:", #RodNames)
for i, rod in ipairs(RodNames) do
    print(" -", i, rod)
end

--// Functions
FindChildOfClass = function(parent, classname)
    return parent:FindFirstChildOfClass(classname)
end
FindChild = function(parent, child)
    return parent:FindFirstChild(child)
end
FindChildOfType = function(parent, childname, classname)
    child = parent:FindFirstChild(childname)
    if child and child.ClassName == classname then
        return child
    end
end
CheckFunc = function(func)
    return typeof(func) == 'function'
end

--// Custom Functions
getchar = function()
    local success, char = pcall(function()
        return lp.Character or lp.CharacterAdded:Wait()
    end)
    return success and char or nil
end
gethrp = function()
    local char = getchar()
    if char then
        local success, hrp = pcall(function()
            return char:WaitForChild('HumanoidRootPart', 5)
        end)
        return success and hrp or nil
    end
    return nil
end
gethum = function()
    local char = getchar()
    if char then
        local success, hum = pcall(function()
            return char:WaitForChild('Humanoid', 5)
        end)
        return success and hum or nil
    end
    return nil
end
FindRod = function()
    local success, result = pcall(function()
        local char = getchar()
        if char then
            local tool = FindChildOfClass(char, 'Tool')
            if tool and FindChild(tool, 'values') then
                return tool
            end
        end
        return nil
    end)
    return success and result or nil
end
message = function(text, time)
    if tooltipmessage then tooltipmessage:Remove() end
    pcall(function()
        tooltipmessage = require(lp.PlayerGui:WaitForChild("GeneralUIModule")):GiveToolTip(lp, text)
        task.spawn(function()
            task.wait(time)
            if tooltipmessage then tooltipmessage:Remove(); tooltipmessage = nil end
        end)
    end)
end

-- Error logging function
local function logError(err, context)
    print("[FISHCH ERROR] " .. context .. ": " .. tostring(err))
    message("Script Error: " .. context, 3)
end

-- Validate CFrame function
local function isValidCFrame(cf)
    if not cf then return false end
    
    -- Check if position contains valid numbers
    local pos = cf.Position
    if pos.X ~= pos.X or pos.Y ~= pos.Y or pos.Z ~= pos.Z then -- NaN check
        return false
    end
    
    -- Check for reasonable position values (not infinity)
    if math.abs(pos.X) > 1000000 or math.abs(pos.Y) > 1000000 or math.abs(pos.Z) > 1000000 then
        return false
    end
    
    return true
end

-- Safe teleportation function
local function safeTeleport(targetCFrame, locationName)
    if not targetCFrame or not isValidCFrame(targetCFrame) then
        message("Invalid teleport location: " .. tostring(locationName), 3)
        return false
    end
    
    -- Add delay if specified
    if flags['teleportdelay'] and flags['teleportdelay'] > 0 then
        task.wait(flags['teleportdelay'] / 1000)
    end
    
    local hrp = gethrp()
    if not hrp then
        message("Character not ready for teleport", 3)
        return false
    end
    
    -- Check if target position is valid
    local success, result = pcall(function()
        -- Store original position for fallback
        local originalCFrame = hrp.CFrame
        local safePosition = targetCFrame
        
        -- Safe teleport mode with ground detection
        if flags['safeteleport'] then
            local raycast = workspace:Raycast(targetCFrame.Position + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0))
            
            -- If there's ground below, adjust Y position
            if raycast and raycast.Position then
                safePosition = CFrame.new(targetCFrame.Position.X, raycast.Position.Y + 5, targetCFrame.Position.Z) * (targetCFrame - targetCFrame.Position)
            end
        end
        
        -- Multiple teleport methods for better success rate
        local methods = {
            -- Method 1: Direct CFrame
            function()
                hrp.CFrame = safePosition
                return true
            end,
            
            -- Method 2: Through character reparenting
            function()
                local char = hrp.Parent
                char.Parent = workspace
                hrp.CFrame = safePosition
                return true
            end,
            
            -- Method 3: PivotTo method (newer)
            function()
                if hrp.Parent.PivotTo then
                    hrp.Parent:PivotTo(safePosition)
                    return true
                end
                return false
            end
        }
        
        local teleported = false
        for i, method in ipairs(methods) do
            local methodSuccess, methodResult = pcall(method)
            if methodSuccess and methodResult then
                task.wait(0.1)
                
                -- Verify teleport success
                local distance = (hrp.Position - safePosition.Position).Magnitude
                if distance < 50 then
                    teleported = true
                    break
                end
            end
        end
        
        if not teleported then
            hrp.CFrame = originalCFrame
            return false
        end
        
        return true
    end)
    
    if success and result then
        message("✓ Teleported to: " .. locationName, 2)
        return true
    else
        message("✗ Teleport failed: " .. locationName .. " (Try Safe Mode)", 3)
        return false
    end
end

--// UI
local library
if CheckFunc(makefolder) and (CheckFunc(isfolder) and not isfolder('fisch')) then
    makefolder('fisch')
end
if CheckFunc(writefile) and (CheckFunc(isfile) and not isfile('fisch/library.lua')) then
    writefile('fisch/library.lua', game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/gamech/refs/heads/main/library.lua'))
end

-- Try to load local library first, then fallback to remote
if CheckFunc(loadfile) and CheckFunc(isfile) and isfile('library.lua') then
    library = loadfile('library.lua')()
elseif CheckFunc(loadfile) and CheckFunc(isfile) and isfile('fisch/library.lua') then
    library = loadfile('fisch/library.lua')()
else
    library = loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/gamech/refs/heads/main/library.lua'))()
end
local Automation = library:CreateWindow('Automation')
local Modifications = library:CreateWindow('Modifications')
local Teleports = library:CreateWindow('Teleports')
local Visuals = library:CreateWindow('Visuals')

-- Debug: Konfirmasi window creation
print("[DEBUG] UI Windows created:")
print("- Automation:", Automation and "✓" or "✗")
print("- Modifications:", Modifications and "✓" or "✗") 
print("- Teleports:", Teleports and "✓" or "✗")
print("- Visuals:", Visuals and "✓" or "✗")
Automation:Section('Basic Settings')
Automation:Toggle('Stealth Mode', {location = flags, flag = 'stealthmode', default = true})
Automation:Slider('Human %', {location = flags, flag = 'humanbehavior', min = 0, max = 100, default = 50})
Automation:Section('Cast Settings')
Automation:Toggle('Auto Cast', {location = flags, flag = 'autocast'})
Automation:Slider('Cast Delay (s)', {location = flags, flag = 'autocastdelay', min = 0.1, max = 10, default = 2})
Automation:Toggle('Random Cast Power', {location = flags, flag = 'randomcast', default = false})
Automation:Slider('Min Cast %', {location = flags, flag = 'mincastpower', min = 50, max = 100, default = 85})
Automation:Slider('Max Cast %', {location = flags, flag = 'maxcastpower', min = 50, max = 100, default = 100})
Automation:Section('Shake Settings')
Automation:Toggle('Auto Shake', {location = flags, flag = 'autoshake'})
Automation:Toggle('Random Shake Timing', {location = flags, flag = 'randomshake', default = false})

-- Fixed Shake Range Slider with stable behavior
local shakeSlider = Automation:Slider('Shake Range (ms)', {
    location = flags, 
    flag = 'shakedelayrange', 
    min = 0, 
    max = 500, 
    default = 150,
    step = 10  -- Add step for more stable sliding
})

-- Alternative: Button-based shake delay control
Automation:Button('Shake: 50ms (Fast)', function()
    flags['shakedelayrange'] = 50
    message("Shake delay set to 50ms", 1)
end)

Automation:Button('Shake: 150ms (Normal)', function()
    flags['shakedelayrange'] = 150
    message("Shake delay set to 150ms", 1)
end)

Automation:Button('Shake: 300ms (Safe)', function()
    flags['shakedelayrange'] = 300
    message("Shake delay set to 300ms", 1)
end)

Automation:Button('Reset All Shake Settings', function()
    flags['autoshake'] = false
    flags['randomshake'] = false
    flags['shakedelayrange'] = 150
    message("All shake settings reset!", 2)
end)

-- Display current shake setting
Automation:Button('Show Current Settings', function()
    local currentDelay = flags['shakedelayrange'] or 150
    local isRandom = flags['randomshake'] and "ON" or "OFF"
    local isAutoShake = flags['autoshake'] and "ON" or "OFF"
    
    message("Shake: " .. currentDelay .. "ms | Random: " .. isRandom .. " | Auto: " .. isAutoShake, 3)
end)

-- Emergency slider release function
Automation:Button('🚨 Fix Stuck Slider', function()
    pcall(function()
        -- Force release any mouse input
        game:GetService('UserInputService').InputEnded:Fire()
        flags['shakedelayrange'] = 150  -- Reset to safe value
        message("Slider fixed! Reset to 150ms", 2)
    end)
end)
Automation:Button('Test Shake Function', function()
    pcall(function()
        if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
            message("Shake UI detected - Test successful", 2)
        else
            message("No shake UI found", 2)
        end
    end)
end)
Automation:Section('Reel Settings')
Automation:Toggle('Auto Reel', {location = flags, flag = 'autoreel'})
Automation:Slider('Reel Delay (s)', {location = flags, flag = 'autoreeldelay', min = 0.1, max = 5, default = 0.5})
Automation:Toggle('Random Reel Power', {location = flags, flag = 'randomreel', default = false})
Automation:Slider('Min Reel %', {location = flags, flag = 'minreelpower', min = 70, max = 100, default = 90})
Automation:Slider('Max Reel %', {location = flags, flag = 'maxreelpower', min = 70, max = 100, default = 100})
Automation:Section('Character Settings')
Automation:Toggle('Show Cast Stats', {location = flags, flag = 'showcaststats', default = false})
Automation:Toggle('Freeze Character', {location = flags, flag = 'freezechar'})
Automation:Dropdown('Freeze Mode', {location = flags, flag = 'freezecharmode', list = {'Rod Equipped', 'Toggled'}})
-----
if CheckFunc(hookmetamethod) then
    Modifications:Section('Hooks')
    Modifications:Toggle('Anti-Cheat Monitor', {location = flags, flag = 'anticheatmonitor', default = true})
    Modifications:Toggle('No AFK Text', {location = flags, flag = 'noafk'})
    Modifications:Toggle('Perfect Cast', {location = flags, flag = 'perfectcast'})
    Modifications:Toggle('Always Catch', {location = flags, flag = 'alwayscatch'})
end
Modifications:Section('Client')
Modifications:Toggle('Infinite Oxygen', {location = flags, flag = 'infoxygen'})
Modifications:Toggle('No Temp & Oxygen', {location = flags, flag = 'nopeakssystems'})
-----
Teleports:Section('Locations')
Teleports:Toggle('Safe Teleport Mode', {location = flags, flag = 'safeteleport', default = true})
Teleports:Slider('TP Delay (ms)', {location = flags, flag = 'teleportdelay', min = 0, max = 2000, default = 100})
Teleports:Dropdown('Zones', {location = flags, flag = 'zones', list = ZoneNames})
-- Debug: Print untuk memastikan button dibuat
pcall(function()
    print("[DEBUG] Creating Teleport To Zone button...")
    Teleports:Button('Teleport To Zone', function() 
        print("[DEBUG] Teleport To Zone button clicked")
        if flags['zones'] and TeleportLocations['Zones'][flags['zones']] then
            print("[DEBUG] Teleporting to:", flags['zones'])
            safeTeleport(TeleportLocations['Zones'][flags['zones']], flags['zones'])
        else
            print("[DEBUG] No zone selected")
            message("Please select a zone first", 3)
        end
    end)
    print("[DEBUG] Teleport To Zone button created successfully")
end)
Teleports:Dropdown('Rod Locations', {location = flags, flag = 'rodlocations', list = RodNames})
pcall(function()
    print("[DEBUG] Creating Teleport To Rod button...")
    Teleports:Button('Teleport To Rod', function() 
        print("[DEBUG] Teleport To Rod button clicked")
        if flags['rodlocations'] and TeleportLocations['Rods'][flags['rodlocations']] then
            print("[DEBUG] Teleporting to rod:", flags['rodlocations'])
            safeTeleport(TeleportLocations['Rods'][flags['rodlocations']], flags['rodlocations'])
        else
            print("[DEBUG] No rod location selected")
            message("Please select a rod location first", 3)
        end
    end)
    print("[DEBUG] Teleport To Rod button created successfully")
end)
-----
Teleports:Section('Utilities')
Teleports:Button('Get Current Position', function()
    local hrp = gethrp()
    if hrp then
        local pos = hrp.CFrame
        local posString = string.format("CFrame.new(%.2f, %.2f, %.2f, %.8f, %.8f, %.8f, %.8f, %.8f, %.8f, %.8f, %.8f, %.8f)", 
            pos.X, pos.Y, pos.Z, pos.LookVector.X, pos.LookVector.Y, pos.LookVector.Z, 
            pos.UpVector.X, pos.UpVector.Y, pos.UpVector.Z, pos.RightVector.X, pos.RightVector.Y, pos.RightVector.Z)
        
        if CheckFunc(setclipboard) then
            setclipboard(posString)
            message("Position copied to clipboard!", 3)
        else
            print("Current Position: " .. posString)
            message("Position printed to console", 3)
        end
    end
end)
Teleports:Button('Teleport to Spawn', function()
    safeTeleport(CFrame.new(0, 10, 0), "Spawn")
end)
-----
Visuals:Section('Rod')
Visuals:Toggle('Body Rod Chams', {location = flags, flag = 'bodyrodchams'})
Visuals:Toggle('Rod Chams', {location = flags, flag = 'rodchams'})
Visuals:Dropdown('Material', {location = flags, flag = 'rodmaterial', list = {'ForceField', 'Neon'}})
Visuals:Section('Fish Abundance')
Visuals:Toggle('Free Fish Radar', {location = flags, flag = 'fishabundance'})

--// Loops
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- Autofarm
        if flags['freezechar'] then
            local hrp = gethrp()
            if hrp then
                if flags['freezecharmode'] == 'Toggled' then
                    if characterposition == nil then
                        characterposition = hrp.CFrame
                    else
                        hrp.CFrame = characterposition
                    end
                elseif flags['freezecharmode'] == 'Rod Equipped' then
                    local rod = FindRod()
                    if rod and characterposition == nil then
                        characterposition = hrp.CFrame
                    elseif rod and characterposition ~= nil then
                        hrp.CFrame = characterposition
                    else
                        characterposition = nil
                    end
                end
            end
        else
            characterposition = nil
        end
        if flags['autoshake'] then
            pcall(function()
                if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
                    local randomDelayMs = 0 -- Initialize delay variable
                    
                    -- Random shake timing if enabled with safety validation
                    if flags['randomshake'] and flags['shakedelayrange'] then
                        local maxDelayMs = tonumber(flags['shakedelayrange']) or 150
                        
                        -- Safety check: prevent extreme values
                        if maxDelayMs > 2000 then 
                            maxDelayMs = 500 
                            flags['shakedelayrange'] = 500
                            print("[WARNING] Shake delay too high, reset to 500ms")
                        elseif maxDelayMs < 0 then
                            maxDelayMs = 0
                            flags['shakedelayrange'] = 0
                        end
                        
                        randomDelayMs = math.random(0, maxDelayMs)
                        local randomDelaySec = randomDelayMs / 1000
                        task.wait(randomDelaySec)
                        
                        if flags['showcaststats'] then
                            print("[DEBUG] Auto Shake: " .. randomDelayMs .. "ms delay (max: " .. maxDelayMs .. "ms)")
                        end
                    elseif flags['stealthmode'] then
                        -- Human-like delay before shaking
                        task.wait(randomDelay(0.1, 0.3))
                        
                        -- Sometimes miss the perfect timing (human behavior)
                        if flags['humanbehavior'] and flags['humanbehavior'] > 0 and math.random(1, 100) <= flags['humanbehavior'] then
                            task.wait(randomDelay(0.05, 0.15))
                        end
                    end
                    
                    -- Safe shake execution with fallback
                    local shakeSuccess = pcall(function()
                        GuiService.SelectedObject = lp.PlayerGui['shakeui']['safezone']['button']
                        if GuiService.SelectedObject == lp.PlayerGui['shakeui']['safezone']['button'] then
                            game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        end
                    end)
                    
                    -- Update shake statistics only if shake was successful
                    if shakeSuccess and flags['showcaststats'] then
                        castStats.totalShakes = castStats.totalShakes + 1
                        if flags['randomshake'] then
                            castStats.avgShakeDelay = ((castStats.avgShakeDelay * (castStats.totalShakes - 1)) + randomDelayMs) / castStats.totalShakes
                            print("[STATS] Shake #" .. castStats.totalShakes .. " | Delay: " .. randomDelayMs .. "ms | Avg: " .. math.floor(castStats.avgShakeDelay) .. "ms")
                        else
                            print("[STATS] Shake #" .. castStats.totalShakes .. " | Instant shake")
                        end
                    elseif not shakeSuccess then
                        print("[ERROR] Auto Shake failed - retrying next cycle")
                    end
                end
            end)
        end
        if flags['autocast'] then
            pcall(function()
                local rod = FindRod()
                if rod ~= nil and rod['values']['lure'].Value <= .001 then
                    -- Use custom delay or default
                    local castDelay = flags['autocastdelay'] or 2
                    
                    -- Determine cast power
                    local castPower = 100
                    
                    if flags['randomcast'] then
                        -- Use random cast power within specified range
                        local minPower = flags['mincastpower'] or 85
                        local maxPower = flags['maxcastpower'] or 100
                        castPower = math.random(minPower, maxPower)
                    elseif flags['perfectcast'] then
                        -- Perfect Cast is handled by hook, use 100% here
                        -- Hook will modify if stealth mode is active
                        castPower = 100
                    elseif flags['stealthmode'] and flags['humanbehavior'] > 0 then
                        -- Stealth mode: sometimes use imperfect cast power
                        if math.random(1, 100) <= flags['humanbehavior'] then
                            castPower = math.random(85, 99)
                        end
                    end
                    
                    if flags['stealthmode'] then
                        -- Stealth mode: add randomization to the base delay
                        local minDelay = math.max(castDelay - 1, 0.5)
                        local maxDelay = castDelay + 1
                        task.wait(randomDelay(minDelay, maxDelay))
                    else
                        -- Normal mode: use exact delay
                        task.wait(castDelay)
                    end
                    
                    -- Fire the cast with determined power
                    rod.events.cast:FireServer(castPower, 1)
                    
                    -- Update statistics
                    if flags['showcaststats'] then
                        castStats.totalCasts = castStats.totalCasts + 1
                        castStats.avgCastPower = ((castStats.avgCastPower * (castStats.totalCasts - 1)) + castPower) / castStats.totalCasts
                        
                        print("[STATS] Cast #" .. castStats.totalCasts .. " | Power: " .. castPower .. "% | Avg: " .. math.floor(castStats.avgCastPower) .. "%")
                    elseif flags['randomcast'] then
                        print("[DEBUG] Auto Cast: " .. castPower .. "% power")
                    end
                end
            end)
        end
        if flags['autoreel'] then
            pcall(function()
                local rod = FindRod()
                if rod ~= nil and rod['values']['lure'].Value == 100 then
                    -- Use custom delay or default
                    local reelDelay = flags['autoreeldelay'] or 0.5
                    
                    -- Determine reel power and success
                    local reelPower = 100
                    local reelSuccess = true
                    
                    if flags['randomreel'] then
                        -- Use random reel power within specified range
                        local minPower = flags['minreelpower'] or 90
                        local maxPower = flags['maxreelpower'] or 100
                        reelPower = math.random(minPower, maxPower)
                        
                        -- Sometimes fail if power is too low
                        if reelPower < 85 then
                            reelSuccess = math.random(1, 100) <= 85 -- 85% success rate for low power
                        end
                    elseif flags['stealthmode'] and flags['humanbehavior'] > 0 then
                        -- Stealth mode: sometimes fail the reel (human behavior)
                        if math.random(1, 100) <= (flags['humanbehavior'] / 3) then
                            reelSuccess = false
                            reelPower = math.random(60, 85)
                        end
                    end
                    
                    if flags['stealthmode'] then
                        -- Stealth mode: Human reaction time with randomization
                        local minDelay = math.max(reelDelay, 0.3)
                        local maxDelay = reelDelay + 0.5
                        task.wait(randomDelay(minDelay, maxDelay))
                    else
                        -- Normal mode: use exact delay
                        task.wait(reelDelay)
                    end
                    
                    -- Fire the reel with determined power and success
                    ReplicatedStorage.events.reelfinished:FireServer(reelPower, reelSuccess)
                    
                    -- Update statistics
                    if flags['showcaststats'] then
                        castStats.totalReels = castStats.totalReels + 1
                        castStats.avgReelPower = ((castStats.avgReelPower * (castStats.totalReels - 1)) + reelPower) / castStats.totalReels
                        if reelSuccess then
                            castStats.successfulReels = castStats.successfulReels + 1
                        end
                        
                        local successRate = math.floor((castStats.successfulReels / castStats.totalReels) * 100)
                        print("[STATS] Reel #" .. castStats.totalReels .. " | Power: " .. reelPower .. "% | Success: " .. tostring(reelSuccess) .. " | Rate: " .. successRate .. "%")
                    elseif flags['randomreel'] then
                        print("[DEBUG] Auto Reel: " .. reelPower .. "% power, Success: " .. tostring(reelSuccess))
                    end
                end
            end)
        end

    -- Visuals
    if flags['rodchams'] then
        local rod = FindRod()
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodName = tostring(rod)
            if not RodColors[rodName] then
                RodColors[rodName] = {}
                RodMaterials[rodName] = {}
            end
            for i,v in rod['Details']:GetDescendants() do
                if v:IsA('BasePart') or v:IsA('MeshPart') then
                    if v.Color ~= Color3.fromRGB(100, 100, 255) then
                        RodColors[rodName][v.Name..i] = v.Color
                    end
                    if RodMaterials[rodName][v.Name..i] == nil then
                        if v.Material == Enum.Material.Neon then
                            RodMaterials[rodName][v.Name..i] = Enum.Material.Neon
                        elseif v.Material ~= Enum.Material.ForceField and v.Material ~= Enum.Material[flags['rodmaterial']] then
                            RodMaterials[rodName][v.Name..i] = v.Material
                        end
                    end
                    v.Material = Enum.Material[flags['rodmaterial']]
                    v.Color = Color3.fromRGB(100, 100, 255)
                end
            end
            if rod['handle'].Color ~= Color3.fromRGB(100, 100, 255) then
                RodColors[rodName]['handle'] = rod['handle'].Color
            end
            if rod['handle'].Material ~= Enum.Material.ForceField and rod['handle'].Material ~= Enum.Material.Neon and rod['handle'].Material ~= Enum.Material[flags['rodmaterial']] then
                RodMaterials[rodName]['handle'] = rod['handle'].Material
            end
            rod['handle'].Material = Enum.Material[flags['rodmaterial']]
            rod['handle'].Color = Color3.fromRGB(100, 100, 255)
        end
    elseif not flags['rodchams'] then
        local rod = FindRod()
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodName = tostring(rod)
            if RodColors[rodName] and RodMaterials[rodName] then
                for i,v in rod['Details']:GetDescendants() do
                    if v:IsA('BasePart') or v:IsA('MeshPart') then
                        if RodMaterials[rodName][v.Name..i] and RodColors[rodName][v.Name..i] then
                            v.Material = RodMaterials[rodName][v.Name..i]
                            v.Color = RodColors[rodName][v.Name..i]
                        end
                    end
                end
                if RodMaterials[rodName]['handle'] and RodColors[rodName]['handle'] then
                    rod['handle'].Material = RodMaterials[rodName]['handle']
                    rod['handle'].Color = RodColors[rodName]['handle']
                end
            end
        end
    end
    if flags['bodyrodchams'] then
        local rod = getchar():FindFirstChild('RodBodyModel')
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodName = tostring(rod)
            if not RodColors[rodName] then
                RodColors[rodName] = {}
                RodMaterials[rodName] = {}
            end
            for i,v in rod['Details']:GetDescendants() do
                if v:IsA('BasePart') or v:IsA('MeshPart') then
                    if v.Color ~= Color3.fromRGB(100, 100, 255) then
                        RodColors[rodName][v.Name..i] = v.Color
                    end
                    if RodMaterials[rodName][v.Name..i] == nil then
                        if v.Material == Enum.Material.Neon then
                            RodMaterials[rodName][v.Name..i] = Enum.Material.Neon
                        elseif v.Material ~= Enum.Material.ForceField and v.Material ~= Enum.Material[flags['rodmaterial']] then
                            RodMaterials[rodName][v.Name..i] = v.Material
                        end
                    end
                    v.Material = Enum.Material[flags['rodmaterial']]
                    v.Color = Color3.fromRGB(100, 100, 255)
                end
            end
            if rod['handle'].Color ~= Color3.fromRGB(100, 100, 255) then
                RodColors[rodName]['handle'] = rod['handle'].Color
            end
            if rod['handle'].Material ~= Enum.Material.ForceField and rod['handle'].Material ~= Enum.Material.Neon and rod['handle'].Material ~= Enum.Material[flags['rodmaterial']] then
                RodMaterials[rodName]['handle'] = rod['handle'].Material
            end
            rod['handle'].Material = Enum.Material[flags['rodmaterial']]
            rod['handle'].Color = Color3.fromRGB(100, 100, 255)
        end
    elseif not flags['bodyrodchams'] then
        local rod = getchar():FindFirstChild('RodBodyModel')
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodName = tostring(rod)
            if RodColors[rodName] and RodMaterials[rodName] then
                for i,v in rod['Details']:GetDescendants() do
                    if v:IsA('BasePart') or v:IsA('MeshPart') then
                        if RodMaterials[rodName][v.Name..i] and RodColors[rodName][v.Name..i] then
                            v.Material = RodMaterials[rodName][v.Name..i]
                            v.Color = RodColors[rodName][v.Name..i]
                        end
                    end
                end
                if RodMaterials[rodName]['handle'] and RodColors[rodName]['handle'] then
                    rod['handle'].Material = RodMaterials[rodName]['handle']
                    rod['handle'].Color = RodColors[rodName]['handle']
                end
            end
        end
    end
    if flags['fishabundance'] then
        if not fishabundancevisible then
            message('\<b><font color = \"#9eff80\">Fish Abundance Zones</font></b>\ are now visible', 5)
        end
        for i,v in workspace.zones.fishing:GetChildren() do
            if FindChildOfType(v, 'Abundance', 'StringValue') and FindChildOfType(v, 'radar1', 'BillboardGui') then
                v['radar1'].Enabled = true
                v['radar2'].Enabled = true
            end
        end
        fishabundancevisible = flags['fishabundance']
    else
        if fishabundancevisible then
            message('\<b><font color = \"#9eff80\">Fish Abundance Zones</font></b>\ are no longer visible', 5)
        end
        for i,v in workspace.zones.fishing:GetChildren() do
            if FindChildOfType(v, 'Abundance', 'StringValue') and FindChildOfType(v, 'radar1', 'BillboardGui') then
                v['radar1'].Enabled = false
                v['radar2'].Enabled = false
            end
        end
        fishabundancevisible = flags['fishabundance']
    end

    -- Modifications
    if flags['infoxygen'] then
        pcall(function()
            local hum = gethum()
            if hum then
                if not deathcon then
                    deathcon = hum.Died:Connect(function()
                        task.delay(9, function()
                            pcall(function()
                                local char = getchar()
                                if char then
                                    if FindChildOfType(char, 'DivingTank', 'Decal') then
                                        FindChildOfType(char, 'DivingTank', 'Decal'):Destroy()
                                    end
                                    local oxygentank = Instance.new('Decal')
                                    oxygentank.Name = 'DivingTank'
                                    oxygentank.Parent = workspace
                                    oxygentank:SetAttribute('Tier', 1/0)
                                    oxygentank.Parent = char
                                end
                                deathcon = nil
                            end)
                        end)
                    end)
                end
                if deathcon and hum.Health > 0 then
                    local char = getchar()
                    if char and not char:FindFirstChild('DivingTank') then
                        local oxygentank = Instance.new('Decal')
                        oxygentank.Name = 'DivingTank'
                        oxygentank.Parent = workspace
                        oxygentank:SetAttribute('Tier', 1/0)
                        oxygentank.Parent = char
                    end
                end
            end
        end)
    else
        pcall(function()
            local char = getchar()
            if char and FindChildOfType(char, 'DivingTank', 'Decal') then
                FindChildOfType(char, 'DivingTank', 'Decal'):Destroy()
            end
        end)
    end
    if flags['nopeakssystems'] then
        pcall(function()
            local char = getchar()
            if char then
                char:SetAttribute('WinterCloakEquipped', true)
                char:SetAttribute('Refill', true)
            end
        end)
    else
        pcall(function()
            local char = getchar()
            if char then
                char:SetAttribute('WinterCloakEquipped', nil)
                char:SetAttribute('Refill', false)
            end
        end)
    end
    -- Anti-Cheat Monitoring
    if flags['anticheatmonitor'] then
        pcall(function()
            -- Monitor for suspicious activity
            local currentTime = tick()
            
            -- Check for rapid actions
            if antiDetection.actionCount > 15 then
                message("⚠️ High activity detected - Slowing down", 2)
                task.wait(randomDelay(2, 5))
                antiDetection.actionCount = 0
            end
            
            -- Monitor network events
            local httpSuccess, httpResult = pcall(function()
                return game:GetService("HttpService"):GetAsync("https://httpbin.org/get", false)
            end)
            
            if not httpSuccess then
                -- HTTP blocked might indicate detection
                message("⚠️ Network restrictions detected", 2)
            end
        end)
    end
    
    end) -- Close main pcall
end)

--// Hooks
if CheckFunc(hookmetamethod) then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method, args = getnamecallmethod(), {...}
        
        -- Add randomization to avoid detection patterns
        if flags['stealthmode'] then
            -- Random small delay
            if math.random(1, 10) == 1 then
                task.wait(0.001)
            end
        end
        
        if method == 'FireServer' and self.Name == 'afk' and flags['noafk'] then
            args[1] = false
            return old(self, unpack(args))
        elseif method == 'FireServer' and self.Name == 'cast' and flags['perfectcast'] then
            -- Perfect Cast Hook - Always ensures perfect cast
            if flags['stealthmode'] and flags['humanbehavior'] > 0 then
                if math.random(1, 100) <= flags['humanbehavior'] then
                    args[1] = math.random(85, 99) -- Imperfect cast sometimes for stealth
                    if flags['showcaststats'] then
                        print("[PERFECT CAST] Stealth imperfect: " .. args[1] .. "%")
                    end
                else
                    args[1] = 100
                    if flags['showcaststats'] then
                        print("[PERFECT CAST] Perfect: 100%")
                    end
                end
            else
                args[1] = 100
                if flags['showcaststats'] then
                    print("[PERFECT CAST] Perfect: 100%")
                end
            end
            return old(self, unpack(args))
        elseif method == 'FireServer' and self.Name == 'reelfinished' and flags['alwayscatch'] then
            -- Randomize always catch to avoid detection
            if flags['stealthmode'] and flags['humanbehavior'] > 0 then
                if math.random(1, 100) <= (flags['humanbehavior'] / 4) then
                    args[1] = math.random(70, 90) -- Sometimes fail
                    args[2] = false
                else
                    args[1] = 100
                    args[2] = true
                end
            else
                args[1] = 100
                args[2] = true
            end
            return old(self, unpack(args))
        end
        return old(self, ...)
    end)
end
