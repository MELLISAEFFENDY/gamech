--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))

--// Variables
local flags = {}
-- Provide safe defaults for flags that are used immediately (avoid nil indexing)
flags['rodmaterial'] = flags['rodmaterial'] or 'Neon'
local characterposition
local lp = Players.LocalPlayer
local fishabundancevisible = false
local deathcon
local tooltipmessage
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

--// Functions (localized to avoid polluting global env)
local function FindChildOfClass(parent, classname)
    if not parent then return nil end
    return parent:FindFirstChildOfClass(classname)
end
local function FindChild(parent, child)
    if not parent then return nil end
    return parent:FindFirstChild(child)
end
local function FindChildOfType(parent, childname, classname)
    if not parent then return nil end
    local child = parent:FindFirstChild(childname)
    if child and child.ClassName == classname then
        return child
    end
end
local function CheckFunc(func)
    return typeof(func) == 'function'
end

--// Custom Functions
local getchar = function()
    local success, char = pcall(function()
        return lp.Character or lp.CharacterAdded:Wait()
    end)
    return success and char or nil
end
local gethrp = function()
    local char = getchar()
    if char then
        local success, hrp = pcall(function()
            return char:WaitForChild('HumanoidRootPart', 5)
        end)
        return success and hrp or nil
    end
    return nil
end
local gethum = function()
    local char = getchar()
    if char then
        local success, hum = pcall(function()
            return char:WaitForChild('Humanoid', 5)
        end)
        return success and hum or nil
    end
    return nil
end
local FindRod = function()
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
local lastMessageTime = 0
local MIN_MESSAGE_INTERVAL = 0.35
local function message(text, time)
    if os.clock() - lastMessageTime < MIN_MESSAGE_INTERVAL then return end
    lastMessageTime = os.clock()
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
    warn("[FISHCH ERROR] " .. context .. ": " .. tostring(err))
end

local function safe(fn, context)
    local ok, err = xpcall(fn, debug.traceback)
    if not ok then
        logError(err, context or 'unknown')
    end
end

-- Remote safety helpers / rate limiting
local state = {
    lastCastTime = 0,
    lastReelTime = 0,
    connections = {},
    unloaded = false,
}

local PERFECT_VALUE = 100
local CAST_COOLDOWN = 0.6
local REEL_COOLDOWN = 0.6
local OXYGEN_TIER_VALUE = 1e9 -- finite large number instead of infinity

local function safeFire(remote, ...)
    if remote and typeof(remote) == 'Instance' and remote:IsA('RemoteEvent') then
        local args = table.pack(...)
        local ok, err = pcall(function()
            remote:FireServer(table.unpack(args, 1, args.n))
        end)
        if not ok then logError(err, 'safeFire') end
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
if CheckFunc(loadfile) then
    library = loadfile('fisch/library.lua')()
else
    library = loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/gamech/refs/heads/main/library.lua'))()
end
local Automation = library:CreateWindow('Automation')
local Modifications = library:CreateWindow('Modifications')
local Teleports = library:CreateWindow('Teleports')
local Visuals = library:CreateWindow('Visuals')
Automation:Section('Autofarm')
Automation:Toggle('Freeze Character', {location = flags, flag = 'freezechar'})
Automation:Dropdown('Freeze Character Mode', {location = flags, flag = 'freezecharmode', list = {'Rod Equipped', 'Toggled'}})
Automation:Toggle('Auto Cast', {location = flags, flag = 'autocast'})
Automation:Toggle('Auto Shake', {location = flags, flag = 'autoshake'})
Automation:Toggle('Auto Reel', {location = flags, flag = 'autoreel'})
-----
if CheckFunc(hookmetamethod) then
    Modifications:Section('Hooks')
    Modifications:Toggle('No AFK Text', {location = flags, flag = 'noafk'})
    Modifications:Toggle('Perfect Cast', {location = flags, flag = 'perfectcast'})
    Modifications:Toggle('Always Catch', {location = flags, flag = 'alwayscatch'})
end
Modifications:Section('Client')
Modifications:Toggle('Infinite Oxygen', {location = flags, flag = 'infoxygen'})
Modifications:Toggle('No Temp & Oxygen', {location = flags, flag = 'nopeakssystems'})
-----
Teleports:Section('Locations')
Teleports:Dropdown('Zones', {location = flags, flag = 'zones', list = ZoneNames})
Teleports:Button('Teleport To Zone', function() 
    local hrp = gethrp()
    if hrp and flags['zones'] and TeleportLocations['Zones'][flags['zones']] then
        pcall(function()
            hrp.CFrame = TeleportLocations['Zones'][flags['zones']]
        end)
    end
end)
Teleports:Dropdown('Rod Locations', {location = flags, flag = 'rodlocations', list = RodNames})
Teleports:Button('Teleport To Rod', function() 
    local hrp = gethrp()
    if hrp and flags['rodlocations'] and TeleportLocations['Rods'][flags['rodlocations']] then
        pcall(function()
            hrp.CFrame = TeleportLocations['Rods'][flags['rodlocations']]
        end)
    end
end)
-----
Visuals:Section('Rod')
Visuals:Toggle('Body Rod Chams', {location = flags, flag = 'bodyrodchams'})
Visuals:Toggle('Rod Chams', {location = flags, flag = 'rodchams'})
Visuals:Dropdown('Material', {location = flags, flag = 'rodmaterial', list = {'ForceField', 'Neon'}})
Visuals:Section('Fish Abundance')
Visuals:Toggle('Free Fish Radar', {location = flags, flag = 'fishabundance'})

--// Loops
state.connections['heartbeat'] = RunService.Heartbeat:Connect(function()
    if state.unloaded then return end
    safe(function()
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
            safe(function()
                local pg = lp.PlayerGui
                local shake = FindChild(pg, 'shakeui')
                if shake then
                    local sz = FindChild(shake, 'safezone')
                    if sz then
                        local btn = FindChild(sz, 'button')
                        if btn then
                            GuiService.SelectedObject = btn
                            if GuiService.SelectedObject == btn then
                                local vim = game:GetService('VirtualInputManager')
                                vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end
                    end
                end
            end, 'autoshake')
        end
        if flags['autocast'] then
            safe(function()
                local now = os.clock()
                local rod = FindRod()
                if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
                    if rod.values.lure.Value <= .001 and (now - state.lastCastTime) >= CAST_COOLDOWN then
                        state.lastCastTime = now
                        safeFire(rod.events and rod.events:FindFirstChild('cast'), PERFECT_VALUE, 1)
                    end
                end
            end, 'autocast')
        end
        if flags['autoreel'] then
            safe(function()
                local now = os.clock()
                local rod = FindRod()
                if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
                    if rod.values.lure.Value == PERFECT_VALUE and (now - state.lastReelTime) >= REEL_COOLDOWN then
                        state.lastReelTime = now
                        safeFire(ReplicatedStorage:FindFirstChild('events') and ReplicatedStorage.events:FindFirstChild('reelfinished'), PERFECT_VALUE, true)
                    end
                end
            end, 'autoreel')
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
                    local key = v:GetDebugId(0)
                    if v.Color ~= Color3.fromRGB(100, 100, 255) then RodColors[rodName][key] = v.Color end
                    if RodMaterials[rodName][v.Name..i] == nil then
                        if v.Material == Enum.Material.Neon then
                            RodMaterials[rodName][key] = Enum.Material.Neon
                        elseif v.Material ~= Enum.Material.ForceField and v.Material ~= Enum.Material[flags['rodmaterial']] then
                            RodMaterials[rodName][key] = v.Material
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
                for _,v in rod['Details']:GetDescendants() do
                    if v:IsA('BasePart') or v:IsA('MeshPart') then
                        local key = v:GetDebugId(0)
                        if RodMaterials[rodName][key] and RodColors[rodName][key] then
                            v.Material = RodMaterials[rodName][key]
                            v.Color = RodColors[rodName][key]
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
        local char = getchar()
        local rod = char and char:FindFirstChild('RodBodyModel')
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodName = tostring(rod)
            if not RodColors[rodName] then
                RodColors[rodName] = {}
                RodMaterials[rodName] = {}
            end
            for i,v in rod['Details']:GetDescendants() do
                if v:IsA('BasePart') or v:IsA('MeshPart') then
                    local key = v:GetDebugId(0)
                    if v.Color ~= Color3.fromRGB(100, 100, 255) then RodColors[rodName][key] = v.Color end
                    if RodMaterials[rodName][v.Name..i] == nil then
                        if v.Material == Enum.Material.Neon then
                            RodMaterials[rodName][key] = Enum.Material.Neon
                        elseif v.Material ~= Enum.Material.ForceField and v.Material ~= Enum.Material[flags['rodmaterial']] then
                            RodMaterials[rodName][key] = v.Material
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
        local char = getchar()
        local rod = char and char:FindFirstChild('RodBodyModel')
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodName = tostring(rod)
            if RodColors[rodName] and RodMaterials[rodName] then
                for _,v in rod['Details']:GetDescendants() do
                    if v:IsA('BasePart') or v:IsA('MeshPart') then
                        local key = v:GetDebugId(0)
                        if RodMaterials[rodName][key] and RodColors[rodName][key] then
                            v.Material = RodMaterials[rodName][key]
                            v.Color = RodColors[rodName][key]
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
        safe(function()
            local hum = gethum()
            if hum and not deathcon then
                deathcon = hum.Died:Connect(function()
                    task.delay(9, function()
                        safe(function()
                            local char = getchar()
                            if char then
                                local existing = FindChildOfType(char, 'DivingTank', 'Decal')
                                if existing then existing:Destroy() end
                                local oxygentank = Instance.new('Decal')
                                oxygentank.Name = 'DivingTank'
                                oxygentank.Parent = workspace
                                oxygentank:SetAttribute('Tier', OXYGEN_TIER_VALUE)
                                oxygentank.Parent = char
                            end
                            deathcon = nil
                        end, 'respawn-oxygen')
                    end)
                end)
            end
            if hum and hum.Health > 0 then
                local char = getchar()
                if char and not char:FindFirstChild('DivingTank') then
                    local oxygentank = Instance.new('Decal')
                    oxygentank.Name = 'DivingTank'
                    oxygentank.Parent = workspace
                    oxygentank:SetAttribute('Tier', OXYGEN_TIER_VALUE)
                    oxygentank.Parent = char
                end
            end
        end, 'infoxygen')
    else
        safe(function()
            local char = getchar()
            if char then
                local existing = FindChildOfType(char, 'DivingTank', 'Decal')
                if existing then existing:Destroy() end
            end
        end, 'remove-oxygen')
    end
    if flags['nopeakssystems'] then
        safe(function()
            local char = getchar()
            if char then
                char:SetAttribute('WinterCloakEquipped', true)
                char:SetAttribute('Refill', true)
            end
        end, 'peaks-on')
    else
        safe(function()
            local char = getchar()
            if char then
                char:SetAttribute('WinterCloakEquipped', nil)
                char:SetAttribute('Refill', false)
            end
        end, 'peaks-off')
    end
    end, 'heartbeat-main') -- Close main safe wrapper
end)

--// Hooks
-- Hook metamethod with guard & ability to early-exit if unloaded
if CheckFunc(hookmetamethod) then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if state.unloaded then
            return old(self, ...)
        end
        local method = getnamecallmethod()
        local args = {...}
        local name = self and self.Name
        local success, result = pcall(function()
            if method == 'FireServer' then
                if name == 'afk' and flags['noafk'] then
                    args[1] = false
                    return old(self, table.unpack(args))
                elseif name == 'cast' and flags['perfectcast'] then
                    args[1] = PERFECT_VALUE
                    return old(self, table.unpack(args))
                elseif name == 'reelfinished' and flags['alwayscatch'] then
                    args[1] = PERFECT_VALUE
                    args[2] = true
                    return old(self, table.unpack(args))
                end
            end
            return old(self, ...)
        end)
        if not success then
            logError(result, '__namecall hook')
        end
        return result
    end)
    state.oldNamecall = true -- marker
end

-- Unload / cleanup function to restore stability
local function restoreChams()
    for rodName, colors in pairs(RodColors) do
        local materials = RodMaterials[rodName]
        for _, model in ipairs({FindRod(), (getchar() and getchar():FindFirstChild('RodBodyModel'))}) do
            if model and tostring(model) == rodName and FindChild(model, 'Details') then
                for _, part in ipairs(model.Details:GetDescendants()) do
                    if part:IsA('BasePart') or part:IsA('MeshPart') then
                        local key = part:GetDebugId(0)
                        if materials and materials[key] and colors[key] then
                            part.Material = materials[key]
                            part.Color = colors[key]
                        end
                    end
                end
                if materials and materials['handle'] and colors['handle'] and FindChild(model, 'handle') then
                    model.handle.Material = materials['handle']
                    model.handle.Color = colors['handle']
                end
            end
        end
    end
end

local function unload()
    if state.unloaded then return end
    state.unloaded = true
    -- disable all flags
    for k,_ in pairs(flags) do flags[k] = false end
    restoreChams()
    if deathcon then pcall(function() deathcon:Disconnect() end) deathcon = nil end
    for _,con in pairs(state.connections) do pcall(function() con:Disconnect() end) end
    state.connections = {}
    message('Script unloaded & cleaned up', 3)
end

-- Add unload button (placed under Modifications -> Client section)
Modifications:Button('Unload Script', unload)
