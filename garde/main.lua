-- GRADE A GROW - MEGA AUTO SCRIPT
-- Berdasarkan analisis dump.txt - Semua fitur yang tersedia

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Load ReGui Library
local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()

-- Global Variables
local GameEvents = ReplicatedStorage.GameEvents
local DebugMode = true

-- Toggle Variables untuk semua fitur
local AutoFarmingEnabled = {
    AutoPlant = false,
    AutoHarvest = false,
    AutoWater = false,
    AutoBuySeeds = false,
    AutoSellInventory = false,
}

local AutoPetEnabled = {
    AutoSellPets = false,
    AutoSellAllPets = false,
    AutoHatchEggs = false,
    AutoClaimPetRewards = false,
    AutoFeedNPC = false,
}

local AutoQuestEnabled = {
    AutoClaimDailyQuest = false,
    AutoClaimAchievements = false,
    AutoClaimFairyRewards = false,
    AutoClaimDinoQuest = false,
    AutoClaimNightQuest = false,
}

local AutoCookingEnabled = {
    AutoCooking = false,
    AutoSellFood = false,
    AutoSubmitFood = false,
    AutoCookingPot = false,
}

local AutoMiscEnabled = {
    AutoClaimCodes = false,
    AutoBuyDailyEgg = false,
    AutoClaimInfinitePack = false,
    AutoUseFertilizer = false,
    AutoUseSpray = false,
}

-- Debug Function
local function DebugPrint(message)
    if DebugMode then
        print("[MEGA AUTO] " .. tostring(message))
    end
end

-- Safe Remote Call Function
local function SafeRemoteCall(remote, ...)
    local success, result = pcall(function(...)
        if remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        elseif remote:IsA("RemoteFunction") then
            return remote:InvokeServer(...)
        end
    end, ...)
    
    if not success then
        DebugPrint("ERROR calling " .. remote.Name .. ": " .. tostring(result))
        return false, result
    end
    return true, result
end

-- ============================================
-- FARMING FUNCTIONS
-- ============================================

-- Auto Plant Function
local function AutoPlant()
    while AutoFarmingEnabled.AutoPlant do
        local success = SafeRemoteCall(GameEvents.Plant_RE, "Carrot") -- Ganti seed sesuai kebutuhan
        if success then
            DebugPrint("Auto Plant executed")
        end
        wait(1)
    end
end

-- Auto Harvest Function
local function AutoHarvest()
    while AutoFarmingEnabled.AutoHarvest do
        local success = SafeRemoteCall(GameEvents.HarvestRemote)
        if success then
            DebugPrint("Auto Harvest executed")
        end
        wait(1)
    end
end

-- Auto Water Function
local function AutoWater()
    while AutoFarmingEnabled.AutoWater do
        SafeRemoteCall(GameEvents.Water_RE)
        SafeRemoteCall(GameEvents.WaterYourGardens) -- Function
        SafeRemoteCall(GameEvents.Sprinkler_RE)
        DebugPrint("Auto Water executed")
        wait(2)
    end
end

-- Auto Buy Seeds Function
local function AutoBuySeeds()
    while AutoFarmingEnabled.AutoBuySeeds do
        SafeRemoteCall(GameEvents.BuySeedStock, "Carrot", 10)
        DebugPrint("Auto Buy Seeds executed")
        wait(30)
    end
end

-- Auto Sell Inventory Function
local function AutoSellInventory()
    while AutoFarmingEnabled.AutoSellInventory do
        SafeRemoteCall(GameEvents.Sell_Inventory)
        DebugPrint("Auto Sell Inventory executed")
        wait(60)
    end
end

-- ============================================
-- PET FUNCTIONS
-- ============================================

-- Auto Sell Pets Function
local function AutoSellPets()
    while AutoPetEnabled.AutoSellPets do
        SafeRemoteCall(GameEvents.SellPet_RE)
        DebugPrint("Auto Sell Pet executed")
        wait(5)
    end
end

-- Auto Sell All Pets Function
local function AutoSellAllPets()
    while AutoPetEnabled.AutoSellAllPets do
        SafeRemoteCall(GameEvents.SellAllPets_RE)
        DebugPrint("Auto Sell All Pets executed")
        wait(10)
    end
end

-- Auto Hatch Eggs Function
local function AutoHatchEggs()
    while AutoPetEnabled.AutoHatchEggs do
        SafeRemoteCall(GameEvents.EggReadyToHatch_RE)
        SafeRemoteCall(GameEvents.BuyDailyEgg)
        DebugPrint("Auto Hatch Eggs executed")
        wait(5)
    end
end

-- Auto Feed NPC Function
local function AutoFeedNPC()
    while AutoPetEnabled.AutoFeedNPC do
        SafeRemoteCall(GameEvents.FeedNPC_RE)
        DebugPrint("Auto Feed NPC executed")
        wait(10)
    end
end

-- ============================================
-- QUEST FUNCTIONS
-- ============================================

-- Auto Claim Daily Quest Function
local function AutoClaimDailyQuest()
    while AutoQuestEnabled.AutoClaimDailyQuest do
        SafeRemoteCall(GameEvents.DailyQuests.Claim)
        DebugPrint("Auto Claim Daily Quest executed")
        wait(60)
    end
end

-- Auto Claim Achievements Function
local function AutoClaimAchievements()
    while AutoQuestEnabled.AutoClaimAchievements do
        SafeRemoteCall(GameEvents.AchievementService.Claim)
        DebugPrint("Auto Claim Achievements executed")
        wait(30)
    end
end

-- Auto Claim Fairy Rewards Function
local function AutoClaimFairyRewards()
    while AutoQuestEnabled.AutoClaimFairyRewards do
        SafeRemoteCall(GameEvents.FairyService.ClaimFairyReward)
        DebugPrint("Auto Claim Fairy Rewards executed")
        wait(30)
    end
end

-- Auto Claim Dino Quest Function
local function AutoClaimDinoQuest()
    while AutoQuestEnabled.AutoClaimDinoQuest do
        SafeRemoteCall(GameEvents.ClaimDinoQuest)
        DebugPrint("Auto Claim Dino Quest executed")
        wait(60)
    end
end

-- Auto Claim Night Quest Function
local function AutoClaimNightQuest()
    while AutoQuestEnabled.AutoClaimNightQuest do
        SafeRemoteCall(GameEvents.NightQuestRemoteEvent)
        DebugPrint("Auto Claim Night Quest executed")
        wait(60)
    end
end

-- ============================================
-- COOKING FUNCTIONS
-- ============================================

-- Auto Cooking Function
local function AutoCooking()
    while AutoCookingEnabled.AutoCooking do
        SafeRemoteCall(GameEvents.CookingPotService_RE)
        DebugPrint("Auto Cooking executed")
        wait(5)
    end
end

-- Auto Sell Food Function
local function AutoSellFood()
    while AutoCookingEnabled.AutoSellFood do
        SafeRemoteCall(GameEvents.SellFood_RE)
        DebugPrint("Auto Sell Food executed")
        wait(30)
    end
end

-- Auto Submit Food Function
local function AutoSubmitFood()
    while AutoCookingEnabled.AutoSubmitFood do
        SafeRemoteCall(GameEvents.SubmitFoodService_RE)
        SafeRemoteCall(GameEvents.FoodCriticService_RE)
        DebugPrint("Auto Submit Food executed")
        wait(10)
    end
end

-- ============================================
-- MISC FUNCTIONS
-- ============================================

-- Auto Claim Codes Function
local function AutoClaimCodes()
    while AutoMiscEnabled.AutoClaimCodes do
        SafeRemoteCall(GameEvents.ClaimableCodeService)
        DebugPrint("Auto Claim Codes executed")
        wait(300) -- 5 menit
    end
end

-- Auto Buy Daily Egg Function
local function AutoBuyDailyEgg()
    while AutoMiscEnabled.AutoBuyDailyEgg do
        SafeRemoteCall(GameEvents.BuyDailyEgg)
        DebugPrint("Auto Buy Daily Egg executed")
        wait(3600) -- 1 jam
    end
end

-- Auto Claim Infinite Pack Function
local function AutoClaimInfinitePack()
    while AutoMiscEnabled.AutoClaimInfinitePack do
        SafeRemoteCall(GameEvents.InfinitePack.Claim)
        DebugPrint("Auto Claim Infinite Pack executed")
        wait(60)
    end
end

-- Auto Use Fertilizer Function
local function AutoUseFertilizer()
    while AutoMiscEnabled.AutoUseFertilizer do
        SafeRemoteCall(GameEvents.FertilizerService_RE)
        DebugPrint("Auto Use Fertilizer executed")
        wait(30)
    end
end

-- Auto Use Spray Function
local function AutoUseSpray()
    while AutoMiscEnabled.AutoUseSpray do
        SafeRemoteCall(GameEvents.SprayService_RE)
        DebugPrint("Auto Use Spray executed")
        wait(30)
    end
end

-- ============================================
-- GUI SETUP
-- ============================================

-- Initialize GUI
ReGui:Init()

local Window = ReGui:Window{
    Title = "GRADE A GROW - MEGA AUTO SCRIPT",
    Size = UDim2.fromOffset(500, 700)
}:Center()

-- Debug Section
local DebugSection = Window:CollapsingHeader{Title = "🔧 Debug & Controls"}
DebugSection:Checkbox{
    Text = "Debug Mode",
    Value = DebugMode,
    Callback = function(_, value)
        DebugMode = value
        DebugPrint("Debug mode " .. (value and "enabled" or "disabled"))
    end
}

DebugSection:Button{
    Text = "Stop All Features",
    Callback = function()
        for category, features in pairs({AutoFarmingEnabled, AutoPetEnabled, AutoQuestEnabled, AutoCookingEnabled, AutoMiscEnabled}) do
            for feature, _ in pairs(features) do
                features[feature] = false
            end
        end
        DebugPrint("All auto features stopped!")
    end
}

-- ============================================
-- FARMING SECTION
-- ============================================
local FarmingSection = Window:CollapsingHeader{Title = "🌱 Auto Farming"}

FarmingSection:Checkbox{
    Text = "Auto Plant",
    Value = AutoFarmingEnabled.AutoPlant,
    Callback = function(_, value)
        AutoFarmingEnabled.AutoPlant = value
        if value then spawn(AutoPlant) end
    end
}

FarmingSection:Checkbox{
    Text = "Auto Harvest",
    Value = AutoFarmingEnabled.AutoHarvest,
    Callback = function(_, value)
        AutoFarmingEnabled.AutoHarvest = value
        if value then spawn(AutoHarvest) end
    end
}

FarmingSection:Checkbox{
    Text = "Auto Water Plants",
    Value = AutoFarmingEnabled.AutoWater,
    Callback = function(_, value)
        AutoFarmingEnabled.AutoWater = value
        if value then spawn(AutoWater) end
    end
}

FarmingSection:Checkbox{
    Text = "Auto Buy Seeds",
    Value = AutoFarmingEnabled.AutoBuySeeds,
    Callback = function(_, value)
        AutoFarmingEnabled.AutoBuySeeds = value
        if value then spawn(AutoBuySeeds) end
    end
}

FarmingSection:Checkbox{
    Text = "Auto Sell Inventory",
    Value = AutoFarmingEnabled.AutoSellInventory,
    Callback = function(_, value)
        AutoFarmingEnabled.AutoSellInventory = value
        if value then spawn(AutoSellInventory) end
    end
}

FarmingSection:Button{
    Text = "🚀 Start All Farming",
    Callback = function()
        for feature, _ in pairs(AutoFarmingEnabled) do
            AutoFarmingEnabled[feature] = true
        end
        spawn(AutoPlant)
        spawn(AutoHarvest)
        spawn(AutoWater)
        spawn(AutoBuySeeds)
        spawn(AutoSellInventory)
        DebugPrint("All farming features started!")
    end
}

-- ============================================
-- PET SECTION
-- ============================================
local PetSection = Window:CollapsingHeader{Title = "🐾 Auto Pet Management"}

PetSection:Checkbox{
    Text = "Auto Sell Pets",
    Value = AutoPetEnabled.AutoSellPets,
    Callback = function(_, value)
        AutoPetEnabled.AutoSellPets = value
        if value then spawn(AutoSellPets) end
    end
}

PetSection:Checkbox{
    Text = "Auto Sell All Pets",
    Value = AutoPetEnabled.AutoSellAllPets,
    Callback = function(_, value)
        AutoPetEnabled.AutoSellAllPets = value
        if value then spawn(AutoSellAllPets) end
    end
}

PetSection:Checkbox{
    Text = "Auto Hatch Eggs",
    Value = AutoPetEnabled.AutoHatchEggs,
    Callback = function(_, value)
        AutoPetEnabled.AutoHatchEggs = value
        if value then spawn(AutoHatchEggs) end
    end
}

PetSection:Checkbox{
    Text = "Auto Feed NPC",
    Value = AutoPetEnabled.AutoFeedNPC,
    Callback = function(_, value)
        AutoPetEnabled.AutoFeedNPC = value
        if value then spawn(AutoFeedNPC) end
    end
}

-- ============================================
-- QUEST SECTION
-- ============================================
local QuestSection = Window:CollapsingHeader{Title = "⭐ Auto Quests & Rewards"}

QuestSection:Checkbox{
    Text = "Auto Claim Daily Quests",
    Value = AutoQuestEnabled.AutoClaimDailyQuest,
    Callback = function(_, value)
        AutoQuestEnabled.AutoClaimDailyQuest = value
        if value then spawn(AutoClaimDailyQuest) end
    end
}

QuestSection:Checkbox{
    Text = "Auto Claim Achievements",
    Value = AutoQuestEnabled.AutoClaimAchievements,
    Callback = function(_, value)
        AutoQuestEnabled.AutoClaimAchievements = value
        if value then spawn(AutoClaimAchievements) end
    end
}

QuestSection:Checkbox{
    Text = "Auto Claim Fairy Rewards",
    Value = AutoQuestEnabled.AutoClaimFairyRewards,
    Callback = function(_, value)
        AutoQuestEnabled.AutoClaimFairyRewards = value
        if value then spawn(AutoClaimFairyRewards) end
    end
}

QuestSection:Checkbox{
    Text = "Auto Claim Dino Quest",
    Value = AutoQuestEnabled.AutoClaimDinoQuest,
    Callback = function(_, value)
        AutoQuestEnabled.AutoClaimDinoQuest = value
        if value then spawn(AutoClaimDinoQuest) end
    end
}

QuestSection:Checkbox{
    Text = "Auto Claim Night Quest",
    Value = AutoQuestEnabled.AutoClaimNightQuest,
    Callback = function(_, value)
        AutoQuestEnabled.AutoClaimNightQuest = value
        if value then spawn(AutoClaimNightQuest) end
    end
}

-- ============================================
-- COOKING SECTION
-- ============================================
local CookingSection = Window:CollapsingHeader{Title = "🍳 Auto Cooking"}

CookingSection:Checkbox{
    Text = "Auto Cooking",
    Value = AutoCookingEnabled.AutoCooking,
    Callback = function(_, value)
        AutoCookingEnabled.AutoCooking = value
        if value then spawn(AutoCooking) end
    end
}

CookingSection:Checkbox{
    Text = "Auto Sell Food",
    Value = AutoCookingEnabled.AutoSellFood,
    Callback = function(_, value)
        AutoCookingEnabled.AutoSellFood = value
        if value then spawn(AutoSellFood) end
    end
}

CookingSection:Checkbox{
    Text = "Auto Submit Food",
    Value = AutoCookingEnabled.AutoSubmitFood,
    Callback = function(_, value)
        AutoCookingEnabled.AutoSubmitFood = value
        if value then spawn(AutoSubmitFood) end
    end
}

-- ============================================
-- MISC SECTION
-- ============================================
local MiscSection = Window:CollapsingHeader{Title = "🎁 Auto Miscellaneous"}

MiscSection:Checkbox{
    Text = "Auto Claim Codes",
    Value = AutoMiscEnabled.AutoClaimCodes,
    Callback = function(_, value)
        AutoMiscEnabled.AutoClaimCodes = value
        if value then spawn(AutoClaimCodes) end
    end
}

MiscSection:Checkbox{
    Text = "Auto Buy Daily Egg",
    Value = AutoMiscEnabled.AutoBuyDailyEgg,
    Callback = function(_, value)
        AutoMiscEnabled.AutoBuyDailyEgg = value
        if value then spawn(AutoBuyDailyEgg) end
    end
}

MiscSection:Checkbox{
    Text = "Auto Claim Infinite Pack",
    Value = AutoMiscEnabled.AutoClaimInfinitePack,
    Callback = function(_, value)
        AutoMiscEnabled.AutoClaimInfinitePack = value
        if value then spawn(AutoClaimInfinitePack) end
    end
}

MiscSection:Checkbox{
    Text = "Auto Use Fertilizer",
    Value = AutoMiscEnabled.AutoUseFertilizer,
    Callback = function(_, value)
        AutoMiscEnabled.AutoUseFertilizer = value
        if value then spawn(AutoUseFertilizer) end
    end
}

MiscSection:Checkbox{
    Text = "Auto Use Spray",
    Value = AutoMiscEnabled.AutoUseSpray,
    Callback = function(_, value)
        AutoMiscEnabled.AutoUseSpray = value
        if value then spawn(AutoUseSpray) end
    end
}

-- ============================================
-- ALL-IN-ONE SECTION
-- ============================================
local AllInOneSection = Window:CollapsingHeader{Title = "🚀 ALL-IN-ONE CONTROLS"}

AllInOneSection:Button{
    Text = "🔥 START EVERYTHING",
    Callback = function()
        -- Enable all features
        for category, features in pairs({AutoFarmingEnabled, AutoPetEnabled, AutoQuestEnabled, AutoCookingEnabled, AutoMiscEnabled}) do
            for feature, _ in pairs(features) do
                features[feature] = true
            end
        end
        
        -- Start all functions
        spawn(AutoPlant)
        spawn(AutoHarvest)
        spawn(AutoWater)
        spawn(AutoBuySeeds)
        spawn(AutoSellInventory)
        spawn(AutoSellPets)
        spawn(AutoSellAllPets)
        spawn(AutoHatchEggs)
        spawn(AutoFeedNPC)
        spawn(AutoClaimDailyQuest)
        spawn(AutoClaimAchievements)
        spawn(AutoClaimFairyRewards)
        spawn(AutoClaimDinoQuest)
        spawn(AutoClaimNightQuest)
        spawn(AutoCooking)
        spawn(AutoSellFood)
        spawn(AutoSubmitFood)
        spawn(AutoClaimCodes)
        spawn(AutoBuyDailyEgg)
        spawn(AutoClaimInfinitePack)
        spawn(AutoUseFertilizer)
        spawn(AutoUseSpray)
        
        DebugPrint("🔥 ALL FEATURES STARTED! MAXIMUM AUTOMATION ACTIVATED!")
    end
}

AllInOneSection:Button{
    Text = "⛔ STOP EVERYTHING",
    Callback = function()
        for category, features in pairs({AutoFarmingEnabled, AutoPetEnabled, AutoQuestEnabled, AutoCookingEnabled, AutoMiscEnabled}) do
            for feature, _ in pairs(features) do
                features[feature] = false
            end
        end
        DebugPrint("⛔ All auto features stopped!")
    end
}

-- Manual Actions Section
local ManualSection = Window:CollapsingHeader{Title = "🖱️ Manual Actions"}

ManualSection:Button{
    Text = "Manual Harvest All",
    Callback = function()
        SafeRemoteCall(GameEvents.HarvestRemote)
        DebugPrint("Manual harvest executed")
    end
}

ManualSection:Button{
    Text = "Manual Sell Inventory",
    Callback = function()
        SafeRemoteCall(GameEvents.Sell_Inventory)
        DebugPrint("Manual sell inventory executed")
    end
}

ManualSection:Button{
    Text = "Manual Water All",
    Callback = function()
        SafeRemoteCall(GameEvents.WaterYourGardens)
        DebugPrint("Manual water all executed")
    end
}

ManualSection:Button{
    Text = "Manual Claim All Rewards",
    Callback = function()
        SafeRemoteCall(GameEvents.DailyQuests.Claim)
        SafeRemoteCall(GameEvents.AchievementService.Claim)
        SafeRemoteCall(GameEvents.FairyService.ClaimFairyReward)
        SafeRemoteCall(GameEvents.InfinitePack.Claim)
        DebugPrint("Manual claim all rewards executed")
    end
}

DebugPrint("🚀 MEGA AUTO SCRIPT LOADED!")
DebugPrint("📋 Available features: Farming, Pets, Quests, Cooking, Miscellaneous")
DebugPrint("🔥 Use 'START EVERYTHING' for maximum automation!")
