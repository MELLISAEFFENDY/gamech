--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))

--// Variables
local flags = {}
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
        ["Keeper's Altar"] = CFrame.new(1297.92285, -805.292236, -284.155823, -0.99758029, 5.80044706e-08, -0.0695239156, 6.16549869e-08, 1, -5.03615105e-08, 0.0695239156, -5.45261436e-08, -0.99758029),
        -- New locations from GPS data
        ['Atlantis'] = CFrame.new(-4465, -604, 1874)
    },
    ['Rods'] = {
        ['Heaven Rod'] = CFrame.new(20025.0508, -467.665955, 7114.40234, -0.9998191, -2.41349773e-10, 0.0190212391, -4.76249762e-10, 1, -1.23448247e-08, -0.0190212391, -1.23516495e-08, -0.9998191),
        ['Summit Rod'] = CFrame.new(20213.334, 736.668823, 5707.8208, -0.274440169, 3.53429606e-08, 0.961604178, -1.52819659e-08, 1, -4.11156122e-08, -0.961604178, -2.59789772e-08, -0.274440169),
        ['Kings Rod'] = CFrame.new(1380.83862, -807.198608, -304.22229, -0.692510426, 9.24755454e-08, 0.72140789, 4.86611427e-08, 1, -8.1475676e-08, -0.72140789, -2.13182219e-08, -0.692510426),
        -- New rods from GPS data
        ['Training Rod'] = CFrame.new(465, 150, 235),
        ['Long Rod'] = CFrame.new(480, 180, 150),
        ['Fortune Rod'] = CFrame.new(-1515, 141, 765),
        ['Depthseeker Rod'] = CFrame.new(-4465, -604, 1874),
        ['Champions Rod'] = CFrame.new(-4277, -606, 1838),
        ['Tempest Rod'] = CFrame.new(-4928, -595, 1857),
        ['Abyssal Specter Rod'] = CFrame.new(-3804, -567, 1870),
        ['Poseidon Rod'] = CFrame.new(-4086, -559, 895),
        ['Zeus Rod'] = CFrame.new(-4272, -629, 2665),
        ['Kraken Rod'] = CFrame.new(-4415, -997, 2055),
        -- Desolate Deep Rods
        ['Reinforced Rod'] = CFrame.new(-975, -245, -2700),
        ['Trident Rod'] = CFrame.new(-1485, -225, -2195),
        -- Forsaken Shores Rods
        ['Scurvy Rod'] = CFrame.new(-2830, 215, 1510),
        -- Ancient Isle Rods
        ['Stone Rod'] = CFrame.new(5487, 143, -316),
        -- Terrapin Island Rods
        ['Magnet Rod'] = CFrame.new(-200, 130, 1930)
    },
    ['Items'] = {
        -- Moosewood Items
        ['Fish Radar'] = CFrame.new(365, 135, 275),
        ['Basic Diving Gear'] = CFrame.new(370, 135, 250),
        ['Bait Crate (Moosewood)'] = CFrame.new(315, 135, 335),
        -- Roslit Bay Items
        ['Meteor Totem'] = CFrame.new(-1945, 275, 230),
        ['Glider'] = CFrame.new(-1710, 150, 740),
        ['Bait Crate (Roslit)'] = CFrame.new(-1465, 130, 680),
        ['Crab Cage (Roslit)'] = CFrame.new(-1485, 130, 640),
        -- Atlantis Items
        ['Poseidon Wrath Totem'] = CFrame.new(-3953, -556, 853),
        ['Zeus Storm Totem'] = CFrame.new(-4325, -630, 2687),
        ['Quality Bait Crate (Atlantis)'] = CFrame.new(-177, 144, 1933),
        ['Flippers'] = CFrame.new(-4462, -605, 1875),
        ['Super Flippers'] = CFrame.new(-4463, -603, 1876),
        ['Advanced Diving Gear (Atlantis)'] = CFrame.new(-4452, -603, 1877),
        ['Conception Conch (Atlantis)'] = CFrame.new(-4450, -605, 1874),
        -- Desolate Deep Items
        ['Advanced Diving Gear (Desolate)'] = CFrame.new(-790, 125, -3100),
        ['Basic Diving Gear (Desolate)'] = CFrame.new(-1655, -210, -2825),
        ['Tidebreaker'] = CFrame.new(-1645, -210, -2855),
        ['Conception Conch (Desolate)'] = CFrame.new(-1630, -210, -2860),
        ['Aurora Totem'] = CFrame.new(-1800, -135, -3280),
        -- Forsaken Shores Items
        ['Bait Crate (Forsaken)'] = CFrame.new(-2490, 130, 1535),
        ['Crab Cage (Forsaken)'] = CFrame.new(-2525, 135, -1575),
        -- Ancient Isle Items
        ['Eclipse Totem'] = CFrame.new(5966, 274, 846),
        ['Bait Crate (Ancient)'] = CFrame.new(6075, 195, 260),
        -- Mushgrove Swamp Items
        ['Smokescreen Totem'] = CFrame.new(2790, 140, -625),
        ['Crab Cage (Mushgrove)'] = CFrame.new(2520, 135, -895),
        -- Snowcap Island Items
        ['Windset Totem'] = CFrame.new(2845, 180, 2700),
        -- Sunstone Island Items
        ['Sundial Totem'] = CFrame.new(-1145, 135, -1075),
        ['Bait Crate (Sunstone)'] = CFrame.new(-1045, 200, -1100),
        ['Crab Cage (Sunstone)'] = CFrame.new(-920, 130, -1105),
        -- Terrapin Island Items
        ['Quality Bait Crate (Terrapin)'] = CFrame.new(-175, 145, 1935),
        ['Tempest Totem'] = CFrame.new(35, 130, 1945)
    },
    ['Fishing Spots'] = {
        -- Moosewood Fish
        ['Trout Spot'] = CFrame.new(390, 132, 345),
        ['Anchovy Spot'] = CFrame.new(130, 135, 630),
        ['Yellowfin Tuna Spot'] = CFrame.new(705, 136, 340),
        ['Carp Spot'] = CFrame.new(560, 145, 600),
        ['Goldfish Spot'] = CFrame.new(525, 145, 310),
        ['Flounder Spot'] = CFrame.new(285, 133, 215),
        ['Pike Spot'] = CFrame.new(540, 145, 330),
        -- Roslit Bay Fish
        ['Perch Spot'] = CFrame.new(-1805, 140, 595),
        ['Blue Tang Spot'] = CFrame.new(-1465, 125, 525),
        ['Clownfish Spot'] = CFrame.new(-1520, 125, 520),
        ['Clam Spot'] = CFrame.new(-2028, 130, 541),
        ['Angelfish Spot'] = CFrame.new(-1500, 135, 615),
        ['Arapaima Spot'] = CFrame.new(-1765, 140, 600),
        ['Suckermouth Catfish Spot'] = CFrame.new(-1800, 140, 620),
        -- Desolate Deep Fish
        ['Phantom Ray Spot'] = CFrame.new(-1685, -235, -3090),
        ['Cockatoo Squid Spot'] = CFrame.new(-1645, -205, -2790),
        ['Banditfish Spot'] = CFrame.new(-1500, -235, -2855),
        -- Forsaken Shores Fish
        ['Scurvy Sailfish Spot'] = CFrame.new(-2430, 130, 1450),
        ['Cutlass Fish Spot'] = CFrame.new(-2645, 130, 1410),
        ['Shipwreck Barracuda Spot'] = CFrame.new(-3597, 140, 1604),
        ['Golden Seahorse Spot'] = CFrame.new(-3100, 127, 1450),
        -- Ancient Isle Fish
        ['Anomalocaris Spot'] = CFrame.new(5504, 143, -321),
        ['Cobia Spot'] = CFrame.new(5983, 125, 1007),
        ['Hallucigenia Spot'] = CFrame.new(6015, 190, 339),
        ['Leedsichthys Spot'] = CFrame.new(6052, 394, 648),
        ['Deep Sea Fragment Spot'] = CFrame.new(5841, 81, 388),
        ['Solar Fragment Spot'] = CFrame.new(6073, 443, 684),
        ['Earth Fragment Spot'] = CFrame.new(5972, 274, 845),
        -- Mushgrove Swamp Fish
        ['White Perch Spot'] = CFrame.new(2475, 125, -675),
        ['Grey Carp Spot'] = CFrame.new(2665, 125, -815),
        ['Bowfin Spot'] = CFrame.new(2445, 125, -795),
        ['Marsh Gar Spot'] = CFrame.new(2520, 125, -815),
        ['Alligator Spot'] = CFrame.new(2670, 130, -710),
        -- Snowcap Island Fish
        ['Pollock Spot'] = CFrame.new(2550, 135, 2385),
        ['Bluegill Spot'] = CFrame.new(3070, 130, 2600),
        ['Herring Spot'] = CFrame.new(2595, 140, 2500),
        ['Red Drum Spot'] = CFrame.new(2310, 135, 2545),
        ['Arctic Char Spot'] = CFrame.new(2350, 130, 2230),
        ['Lingcod Spot'] = CFrame.new(2820, 125, 2805),
        ['Glacierfish Spot'] = CFrame.new(2860, 135, 2620),
        -- Sunstone Island Fish
        ['Sweetfish Spot'] = CFrame.new(-940, 130, -1105),
        ['Glassfish Spot'] = CFrame.new(-905, 130, -1000),
        ['Longtail Bass Spot'] = CFrame.new(-860, 135, -1205),
        ['Red Tang Spot'] = CFrame.new(-1195, 123, -1220),
        ['Chinfish Spot'] = CFrame.new(-625, 130, -950),
        ['Trumpetfish Spot'] = CFrame.new(-790, 125, -1340),
        ['Mahi Mahi Spot'] = CFrame.new(-730, 130, -1350),
        ['Sunfish Spot'] = CFrame.new(-975, 125, -1430),
        -- Terrapin Island Fish
        ['Walleye Spot'] = CFrame.new(-225, 125, 2150),
        ['White Bass Spot'] = CFrame.new(-50, 130, 2025),
        ['Redeye Bass Spot'] = CFrame.new(-35, 125, 2285),
        ['Chinook Salmon Spot'] = CFrame.new(-305, 125, 1625),
        ['Golden Smallmouth Bass Spot'] = CFrame.new(65, 135, 2140),
        ['Olm Spot'] = CFrame.new(95, 125, 1980)
    },
    ['NPCs'] = {
        -- Moosewood NPCs
        ['Angler'] = CFrame.new(480, 150, 295),
        ['Appraiser'] = CFrame.new(445, 150, 210),
        ['Arnold'] = CFrame.new(320, 134, 264),
        ['Bob'] = CFrame.new(420, 145, 260),
        ['Brickford Masterson'] = CFrame.new(412, 132, 365),
        ['Captain Ahab'] = CFrame.new(441, 135, 358),
        ['Challenges'] = CFrame.new(337, 138, 312),
        ['Clover McRich'] = CFrame.new(345, 136, 330),
        ['Daisy'] = CFrame.new(580, 165, 220),
        ['Dr. Blackfin'] = CFrame.new(355, 136, 329),
        ['Egg Salesman'] = CFrame.new(404, 135, 312),
        ['Harry Fischer'] = CFrame.new(396, 134, 381),
        ['Henry'] = CFrame.new(484, 152, 236),
        ['Idle Fishing NPC Moosewood'] = CFrame.new(376, 136, 341),
        ['Idle Fishing NPC Moosewood2'] = CFrame.new(365, 132, 182),
        ['Inn Keeper'] = CFrame.new(490, 150, 245),
        ['Lucas'] = CFrame.new(450, 180, 175),
        ['Marlon Friend'] = CFrame.new(405, 135, 248),
        ['Merchant'] = CFrame.new(465, 150, 230),
        ['Moosewood'] = CFrame.new(350, 135, 250),
        ['NPCs'] = CFrame.new(415, 135, 200),
        ['Northern Expedition'] = CFrame.new(400, 135, 265),
        ['Oxygen'] = CFrame.new(370, 135, 250),
        ['Paul'] = CFrame.new(382, 137, 347),
        ['Phineas'] = CFrame.new(470, 150, 275),
        ['Pierre'] = CFrame.new(390, 135, 200),
        ['Pilgrim'] = CFrame.new(402, 134, 257),
        ['Ringo'] = CFrame.new(410, 135, 235),
        ['Shipwright'] = CFrame.new(360, 135, 260),
        ['Skin Merchant'] = CFrame.new(415, 135, 194),
        ['Smurfette'] = CFrame.new(334, 135, 327),
        ['Tom Elf'] = CFrame.new(404, 136, 317),
        ['Valentine\'s Day NPC'] = CFrame.new(347, 136, 330),
        ['Witch'] = CFrame.new(410, 135, 310),
        ['Wren'] = CFrame.new(368, 135, 286),
        -- Roslit Bay / Ocean NPCs
        ['Mike'] = CFrame.new(210, 115, 640),
        ['Ryder Vex'] = CFrame.new(233, 116, 746),
        ['Ocean'] = CFrame.new(1230, 125, 575),
        -- Pine Shoals NPCs
        ['Lars Timberjaw'] = CFrame.new(1217, 87, 574),
        ['Sporey'] = CFrame.new(1245, 86, 425),
        ['Sporey Mom'] = CFrame.new(1262, 129, 663),
        ['Oscar IV'] = CFrame.new(1392, 116, 493),
        ['Angus McBait'] = CFrame.new(236, 222, 461),
        ['Waveborne'] = CFrame.new(360, 90, 780),
        ['Boone Tiller'] = CFrame.new(390, 87, 764),
        ['Clark'] = CFrame.new(443, 84, 703),
        ['Jak'] = CFrame.new(474, 84, 758),
        ['Willow'] = CFrame.new(501, 134, 125),
        ['Marley'] = CFrame.new(505, 134, 120),
        ['Sage'] = CFrame.new(513, 134, 125),
        -- Ancient Isle NPCs
        ['Meteoriticist'] = CFrame.new(5922, 262, 596),
        ['Chiseler'] = CFrame.new(6087, 195, 294),
        -- Terrapin Island NPCs
        ['Sea Traveler'] = CFrame.new(140, 150, 2030),
        ['Idle Fishing NPC 1'] = CFrame.new(72, 133, 2139),
        -- Snowcap Island NPCs
        ['Wilson'] = CFrame.new(2935, 280, 2565),
        -- Mushgrove Swamp NPCs
        ['Agaric'] = CFrame.new(2931, 4268, 3039),
        -- Sunstone Island NPCs
        ['Sunken Chest'] = CFrame.new(798, 130, 1667),
        -- Event/Special NPCs
        ['Daily Shopkeeper'] = CFrame.new(229, 139, 42),
        ['AFK Rewards'] = CFrame.new(233, 139, 38),
        ['Travelling Merchant'] = CFrame.new(2, 500, 0),
        ['Silas'] = CFrame.new(1545, 1690, 6310),
        ['Nick'] = CFrame.new(50, 0, 0),
        ['Hollow'] = CFrame.new(25, 0, 0),
        ['1.23'] = CFrame.new(7, 100, 0),
        -- Fischfest NPCs
        ['Shopper Girl'] = CFrame.new(1000, 140, 9932),
        ['Sandy Finn'] = CFrame.new(1015, 140, 9911),
        ['Red NPC'] = CFrame.new(1020, 173, 9857),
        ['Thomas'] = CFrame.new(1062, 140, 9890),
        ['Shawn'] = CFrame.new(1068, 157, 9918),
        ['Axel'] = CFrame.new(883, 132, 9905),
        ['Joey'] = CFrame.new(906, 132, 9962),
        ['Jett'] = CFrame.new(925, 131, 9883),
        ['Lucas (Fischfest)'] = CFrame.new(946, 132, 9894),
        ['Shell Merchant'] = CFrame.new(972, 132, 9921),
        ['Barnacle Bill'] = CFrame.new(989, 143, 9975)
    }
}
local ZoneNames = {}
local RodNames = {}
local ItemNames = {}
local FishingSpotNames = {}
local NPCNames = {}
local RodColors = {}
local RodMaterials = {}
for i,v in pairs(TeleportLocations['Zones']) do table.insert(ZoneNames, i) end
for i,v in pairs(TeleportLocations['Rods']) do table.insert(RodNames, i) end
for i,v in pairs(TeleportLocations['Items']) do table.insert(ItemNames, i) end
for i,v in pairs(TeleportLocations['Fishing Spots']) do table.insert(FishingSpotNames, i) end
for i,v in pairs(TeleportLocations['NPCs']) do table.insert(NPCNames, i) end

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
    return lp.Character or lp.CharacterAdded:Wait()
end
gethrp = function()
    return getchar():WaitForChild('HumanoidRootPart')
end
gethum = function()
    return getchar():WaitForChild('Humanoid')
end
FindRod = function()
    if FindChildOfClass(getchar(), 'Tool') and FindChild(FindChildOfClass(getchar(), 'Tool'), 'values') then
        return FindChildOfClass(getchar(), 'Tool')
    else
        return nil
    end
end
message = function(text, time)
    if tooltipmessage then tooltipmessage:Remove() end
    tooltipmessage = require(lp.PlayerGui:WaitForChild("GeneralUIModule")):GiveToolTip(lp, text)
    task.spawn(function()
        task.wait(time)
        if tooltipmessage then tooltipmessage:Remove(); tooltipmessage = nil end
    end)
end

--// UI
local ReGui
if CheckFunc(makefolder) and (CheckFunc(isfolder) and not isfolder('fisch')) then
    makefolder('fisch')
end
if CheckFunc(writefile) and (CheckFunc(isfile) and not isfile('fisch/ReGui.lua')) then
    writefile('fisch/ReGui.lua', game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/gamech/refs/heads/main/ReGui.lua'))
end
if CheckFunc(loadfile) then
    ReGui = loadfile('fisch/ReGui.lua')()
else
    ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/gamech/refs/heads/main/ReGui.lua'))()
end

-- Initialize ReGui
ReGui:Init()

-- Create main window
local MainWindow = ReGui:Window({
    Title = 'FISCH Script',
    Size = UDim2.fromOffset(400, 500)
})

-- Create tabs
local AutomationTab = MainWindow:CreateTab({Name = 'Automation'})
local ModificationsTab = MainWindow:CreateTab({Name = 'Modifications'})
local TeleportsTab = MainWindow:CreateTab({Name = 'Teleports'})
local VisualsTab = MainWindow:CreateTab({Name = 'Visuals'})

-- Automation Section
AutomationTab:CollapsingHeader({Title = 'Autofarm'})
AutomationTab:Checkbox({
    Label = 'Freeze Character',
    Value = false,
    Callback = function(self, value)
        flags.freezechar = value
    end
})
AutomationTab:Combo({
    Label = 'Freeze Character Mode',
    Items = {'Rod Equipped', 'Toggled'},
    Selected = 'Rod Equipped',
    Callback = function(self, value)
        flags.freezecharmode = value
    end
})
AutomationTab:Checkbox({
    Label = 'Auto Cast',
    Value = false,
    Callback = function(self, value)
        flags.autocast = value
    end
})
AutomationTab:Checkbox({
    Label = 'Auto Shake',
    Value = false,
    Callback = function(self, value)
        flags.autoshake = value
    end
})
AutomationTab:Checkbox({
    Label = 'Auto Reel',
    Value = false,
    Callback = function(self, value)
        flags.autoreel = value
    end
})

-- Modifications Section
if CheckFunc(hookmetamethod) then
    ModificationsTab:CollapsingHeader({Title = 'Hooks'})
    ModificationsTab:Checkbox({
        Label = 'No AFK Text',
        Value = false,
        Callback = function(self, value)
            flags.noafk = value
        end
    })
    ModificationsTab:Checkbox({
        Label = 'Perfect Cast',
        Value = false,
        Callback = function(self, value)
            flags.perfectcast = value
        end
    })
    ModificationsTab:Checkbox({
        Label = 'Always Catch',
        Value = false,
        Callback = function(self, value)
            flags.alwayscatch = value
        end
    })
end

ModificationsTab:CollapsingHeader({Title = 'Client'})
ModificationsTab:Checkbox({
    Label = 'Infinite Oxygen',
    Value = false,
    Callback = function(self, value)
        flags.infoxygen = value
    end
})
ModificationsTab:Checkbox({
    Label = 'No Temp & Oxygen',
    Value = false,
    Callback = function(self, value)
        flags.nopeakssystems = value
    end
})

-- Teleports Section
TeleportsTab:CollapsingHeader({Title = 'Locations'})
TeleportsTab:Combo({
    Label = 'Zones',
    Items = ZoneNames,
    Selected = ZoneNames[1] or '',
    Callback = function(self, value)
        flags.zones = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Zone',
    Callback = function()
        if flags.zones and TeleportLocations['Zones'][flags.zones] then
            gethrp().CFrame = TeleportLocations['Zones'][flags.zones]
        end
    end
})

TeleportsTab:CollapsingHeader({Title = 'Rods & Equipment'})
TeleportsTab:Combo({
    Label = 'Rod Locations',
    Items = RodNames,
    Selected = RodNames[1] or '',
    Callback = function(self, value)
        flags.rodlocations = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Rod',
    Callback = function()
        if flags.rodlocations and TeleportLocations['Rods'][flags.rodlocations] then
            gethrp().CFrame = TeleportLocations['Rods'][flags.rodlocations]
        end
    end
})

TeleportsTab:CollapsingHeader({Title = 'Items & Equipment'})
TeleportsTab:Combo({
    Label = 'Items',
    Items = ItemNames,
    Selected = ItemNames[1] or '',
    Callback = function(self, value)
        flags.itemlocations = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Item',
    Callback = function()
        if flags.itemlocations and TeleportLocations['Items'][flags.itemlocations] then
            gethrp().CFrame = TeleportLocations['Items'][flags.itemlocations]
        end
    end
})

TeleportsTab:CollapsingHeader({Title = 'Fishing Spots'})
TeleportsTab:Combo({
    Label = 'Fish Locations',
    Items = FishingSpotNames,
    Selected = FishingSpotNames[1] or '',
    Callback = function(self, value)
        flags.fishlocations = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Fishing Spot',
    Callback = function()
        if flags.fishlocations and TeleportLocations['Fishing Spots'][flags.fishlocations] then
            gethrp().CFrame = TeleportLocations['Fishing Spots'][flags.fishlocations]
        end
    end
})

TeleportsTab:CollapsingHeader({Title = 'NPCs'})
TeleportsTab:Combo({
    Label = 'NPC Locations',
    Items = NPCNames,
    Selected = NPCNames[1] or '',
    Callback = function(self, value)
        flags.npclocations = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To NPC',
    Callback = function()
        if flags.npclocations and TeleportLocations['NPCs'][flags.npclocations] then
            gethrp().CFrame = TeleportLocations['NPCs'][flags.npclocations]
        end
    end
})

-- Visuals Section
VisualsTab:CollapsingHeader({Title = 'Rod'})
VisualsTab:Checkbox({
    Label = 'Body Rod Chams',
    Value = false,
    Callback = function(self, value)
        flags.bodyrodchams = value
    end
})
VisualsTab:Checkbox({
    Label = 'Rod Chams',
    Value = false,
    Callback = function(self, value)
        flags.rodchams = value
    end
})
VisualsTab:Combo({
    Label = 'Material',
    Items = {'ForceField', 'Neon'},
    Selected = 'ForceField',
    Callback = function(self, value)
        flags.rodmaterial = value
    end
})

VisualsTab:CollapsingHeader({Title = 'Fish Abundance'})
VisualsTab:Checkbox({
    Label = 'Free Fish Radar',
    Value = false,
    Callback = function(self, value)
        flags.fishabundance = value
    end
})

--// Loops
RunService.Heartbeat:Connect(function()
    -- Autofarm
    if flags['freezechar'] then
        if flags['freezecharmode'] == 'Toggled' then
            if characterposition == nil then
                characterposition = gethrp().CFrame
            else
                gethrp().CFrame = characterposition
            end
        elseif flags['freezecharmode'] == 'Rod Equipped' then
            local rod = FindRod()
            if rod and characterposition == nil then
                characterposition = gethrp().CFrame
            elseif rod and characterposition ~= nil then
                gethrp().CFrame = characterposition
            else
                characterposition = nil
            end
        end
    else
        characterposition = nil
    end
    if flags['autoshake'] then
        if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
            GuiService.SelectedObject = lp.PlayerGui['shakeui']['safezone']['button']
            if GuiService.SelectedObject == lp.PlayerGui['shakeui']['safezone']['button'] then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
    if flags['autocast'] then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value <= .001 and task.wait(.5) then
            rod.events.cast:FireServer(100, 1)
        end
    end
    if flags['autoreel'] then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value == 100 and task.wait(.5) then
            ReplicatedStorage.events.reelfinished:FireServer(100, true)
        end
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
        if not deathcon then
            deathcon = gethum().Died:Connect(function()
                task.delay(9, function()
                    if FindChildOfType(getchar(), 'DivingTank', 'Decal') then
                        FindChildOfType(getchar(), 'DivingTank', 'Decal'):Destroy()
                    end
                    local oxygentank = Instance.new('Decal')
                    oxygentank.Name = 'DivingTank'
                    oxygentank.Parent = workspace
                    oxygentank:SetAttribute('Tier', 1/0)
                    oxygentank.Parent = getchar()
                    deathcon = nil
                end)
            end)
        end
        if deathcon and gethum().Health > 0 then
            if not getchar():FindFirstChild('DivingTank') then
                local oxygentank = Instance.new('Decal')
                oxygentank.Name = 'DivingTank'
                oxygentank.Parent = workspace
                oxygentank:SetAttribute('Tier', 1/0)
                oxygentank.Parent = getchar()
            end
        end
    else
        if FindChildOfType(getchar(), 'DivingTank', 'Decal') then
            FindChildOfType(getchar(), 'DivingTank', 'Decal'):Destroy()
        end
    end
    if flags['nopeakssystems'] then
        getchar():SetAttribute('WinterCloakEquipped', true)
        getchar():SetAttribute('Refill', true)
    else
        getchar():SetAttribute('WinterCloakEquipped', nil)
        getchar():SetAttribute('Refill', false)
    end
end)

--// Hooks
if CheckFunc(hookmetamethod) then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method, args = getnamecallmethod(), {...}
        if method == 'FireServer' and self.Name == 'afk' and flags['noafk'] then
            args[1] = false
            return old(self, unpack(args))
        elseif method == 'FireServer' and self.Name == 'cast' and flags['perfectcast'] then
            args[1] = 100
            return old(self, unpack(args))
        elseif method == 'FireServer' and self.Name == 'reelfinished' and flags['alwayscatch'] then
            args[1] = 100
            args[2] = true
            return old(self, unpack(args))
        end
        return old(self, ...)
    end)
end
