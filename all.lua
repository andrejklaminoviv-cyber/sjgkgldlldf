-- =========================================================
-- [BIKE OF HELL] ULTIMATE UNLOCKER & INFERNUS FORCER
-- =========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerData = require(ReplicatedStorage.Modules.PlayerData)
local Config = require(ReplicatedStorage.UtilityModules.Config)
local Enums = require(ReplicatedStorage.UtilityModules.Enums)
local Trails = require(ReplicatedStorage.Tables.Trails)
local Network = require(ReplicatedStorage.Modules.Network)
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent

print("[Bike of Hell] Запуск полного анлокера...")

-- 1. НАПОЛНЯЕМ ИНВЕНТАРЬ (ВСЕ 124 ВЕЛИКА И 155 ТРОП В UI):
local data = PlayerData.GetWhole()

local allBikes = {}
for bikeName, _ in pairs(Config.BikeInfo) do
    table.insert(allBikes, bikeName)
end
data.BikesInventory = allBikes

local allTrails = {}
for trailName, _ in pairs(Trails) do
    table.insert(allTrails, trailName)
end
data.TrailInventory = allTrails

-- Принудительно ставим Infernus как экипированный:
data.EquippedBike = "InfernusBike"

-- Оповещаем интерфейс инвентаря обновить иконки:
pcall(function()
    PlayerData.GetKeyUpdatedSignal("BikesInventory"):Fire(data.BikesInventory)
    PlayerData.GetKeyUpdatedSignal("TrailInventory"):Fire(data.TrailInventory)
    PlayerData.GetKeyUpdatedSignal("EquippedBike"):Fire("InfernusBike")
end)

print("[Bike of Hell] Все 124 велика и 155 троп добавлены в меню инвентаря!")

-- 2. ФОРСИНГ МОДЕЛИ ИНФЕРНУСА НА ПЕРСОНАЖА (ID: 56):
local targetBikeId = 56 -- Enums.BikeTypes.InfernusBike
local targetBikeName = "InfernusBike"

local function getHrp()
    local char = LocalPlayer.Character or (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(LocalPlayer.Name))
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function applyBike(bikeId)
    local hrp = getHrp()
    if hrp then
        local bt = hrp:FindFirstChild("BikeType")
        if bt then
            if bt.Value == bikeId then
                bt.Value = 0
                task.wait()
            end
            bt.Value = bikeId
        end
    end
end

-- Моментально спавним Инфернус:
applyBike(targetBikeId)

-- 3. ХУК ПЕРЕКЛЮЧЕНИЯ ВЕЛИКОВ И ТРОП В МЕНЮ ИНВЕНТАРЯ:
-- Когда ты кликаешь на любой велик или тропу в UI, они моментально надеваются:
local oldFireServer = Network.FireServer
Network.FireServer = function(eventName, ...)
    local args = {...}
    
    if eventName == "EquipBike" then
        local bikeName = args[1]
        local bId = Enums.BikeTypes[bikeName]
        if bId then
            targetBikeId = bId
            targetBikeName = bikeName
            data.EquippedBike = bikeName
            PlayerData.GetKeyUpdatedSignal("EquippedBike"):Fire(bikeName)
            applyBike(bId)
            print("[Bike of Hell] Экипирован велик:", bikeName, "(ID: " .. tostring(bId) .. ")")
        end
    elseif eventName == "EQUIP_TRAIL" then
        local trailName = args[1]
        LocalPlayer:SetAttribute("Trail", trailName)
        data.Trail = trailName
        PlayerData.GetKeyUpdatedSignal("Trail"):Fire(trailName)
        pcall(function()
            require(ReplicatedStorage.Modules.Bike.Trails)(LocalPlayer, trailName)
        end)
        print("[Bike of Hell] Экипирована тропа:", trailName)
    end
    
    return oldFireServer(eventName, ...)
end

-- 4. СОХРАНЕНИЕ ПРИ РЕСПАВНЕ / ПАДЕНИИ:
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    applyBike(targetBikeId)
    if data.Trail then
        LocalPlayer:SetAttribute("Trail", data.Trail)
    end
end)

-- Подстраховка циклом (если сервер попытается сбросить велик):
task.spawn(function()
    while task.wait(0.5) do
        local hrp = getHrp()
        if hrp then
            local bt = hrp:FindFirstChild("BikeType")
            if bt and bt.Value ~= targetBikeId then
                bt.Value = targetBikeId
            end
        end
    end
end)

-- 5. ФОНОВАЯ СКУПКА ВСЕХ ОСТАЛЬНЫХ СЕРВЕРНЫХ ВЕЛИКОВ И ТРОП:
task.spawn(function()
    print("[Bike of Hell] Скупаем все серверные велики с ценой...")
    for bName, bInfo in pairs(Config.BikeInfo) do
        if bInfo.ShopPrice ~= nil then
            Remote:FireServer("BuyCoinsBypassed", bName, "Coins")
            task.wait(0.1)
        end
    end
    
    print("[Bike of Hell] Скупаем все серверные тропы с ценой...")
    for tName, tInfo in pairs(Trails) do
        if tInfo.ShopPrice ~= nil then
            Remote:FireServer("BuyFeatured", tName, "Coins")
            task.wait(0.1)
        end
    end
    print("[Bike of Hell] Серверная скупка завершена!")
end)

print("[Bike of Hell] ГОТОВО! Инфернус надет прямо сейчас! Открой инвентарь — там доступны абсолютно все велики и тропы!")
