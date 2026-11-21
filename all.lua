local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent
local Config = require(ReplicatedStorage.UtilityModules.Config)
local Trails = require(ReplicatedStorage.Tables.Trails)
local Enums = require(ReplicatedStorage.UtilityModules.Enums)

print("[Bike of Hell] Запуск полной разблокировки через официальный эвент...")

-- 1. Забираем ВСЕ официальные паки (включая все секретные паковые велики и тропы)
local packs = {
    "Unicorn", "InvisiblePack", "DirtPack", "BikersBike", "BeePack",
    "GrassPack", "FruitPack", "FireIce", "BananaPack", "PizzaPack",
    "RocketPack", "RocketSledPack", "SharkPack", "StarPack",
    "StarterPack", "BroomPack", "ThaiPack", "BoneBike", "JetSki"
}

for _, pack in ipairs(packs) do
    Remote:FireServer("BuyProductFree", pack)
    task.wait(0.04)
end

-- 2. Забираем ВСЕ 124 велосипеда (включая InfernusBike, BatStorm, RighteousBike 1-4, NeonRider и т.д.)
for bikeName, _ in pairs(Config.BikeInfo) do
    Remote:FireServer("BuyProductFree", bikeName)
    task.wait(0.04)
end

-- На случай скрытых великов из Enum
for bikeName, _ in pairs(Enums.BikeTypes) do
    Remote:FireServer("BuyProductFree", bikeName)
    task.wait(0.04)
end

-- 3. Забираем ВСЕ 155 троп (включая все редкие, ивентовые и из рулетки)
for trailName, _ in pairs(Trails) do
    Remote:FireServer("BuyProductFree", trailName)
    task.wait(0.04)
end

print("[Bike of Hell] ГОТОВО! Все 124 велика (включая Infernus) и 155 троп у тебя в инвентаре!")
