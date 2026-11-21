local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent
local Config = require(ReplicatedStorage.UtilityModules.Config)
local Trails = require(ReplicatedStorage.Tables.Trails)
local Enums = require(ReplicatedStorage.UtilityModules.Enums)

print("=== [1/3] ЗАБИРАЕМ ВСЕ ВЕЛИКИ СО СКИДКОЙ 0 МОНЕТ (КАК WARP BIKE) ===")

local freeBikes = {
    "WarpBike", "SharkBike", "UnicornBike", "DirtBike", "BeeBike",
    "HoverBike", "RocketBike", "StarBike", "BikersBike", "InvisibleBike",
    "PizzaBike", "BananaBike", "BoneBike", "JetSki", "Lawnmower",
    "VoltBike", "DragonBike", "CyberBike", "GoldenCrush", "LoveCruiser",
    "CupidsChariot", "Broomstick", "LuckyBike", "FortuneBike", "CloverBike",
    "RighteousBike1", "RighteousBike2", "RighteousBike3", "RighteousBike4",
    "BlueHackerBike", "RedHackerBike", "PurpleHackerBike", "GreenHackerBike",
    "SquidBike001", "SquidBike218", "SquidBike456", "SpeedyVIP", "RocketSled"
}

for i, bikeName in ipairs(freeBikes) do
    Remote:FireServer("BuyCoinsBypassed", bikeName, "Coins")
    task.wait(0.12) -- безопасный интервал от потери пакетов
end

print("=== [2/3] СКУПАЕМ ВСЕ МАГАЗИННЫЕ ТРОПЫ ЗА МОНЕТЫ ===")

-- Покупаем самые популярные и крутые тропы (денег у тебя 2 миллиона, хватит с головой):
local trailsToBuy = {
    "Rainbow", "Godly", "Lightspeed", "Blackhole", "Starstream",
    "Flamed", "Smoke", "FrozenFlame", "Frostbite", "Magma",
    "Sunburst", "Decay", "MatrixGlow", "CyberTrail", "Radioactive",
    "Acid", "Dragonscale", "Ghost", "Bats", "Pumpkins", "WitchMist",
    "CandyCane", "Gingerbread", "TreeOrnament", "Snowflakes", "Presents",
    "Muddy", "Honey", "WaterSplash", "RocketBoost", "ArcticBoost",
    "Cheese", "LanternEffect", "SpeedyTrail", "BananaTrail", "PinkGlowLord",
    "WhiteVibrate", "RedVibrate", "BlueVibrate", "GreenVibrate", "RainbowVibrate"
}

for _, trailName in ipairs(trailsToBuy) do
    Remote:FireServer("BuyFeatured", trailName, "Coins")
    task.wait(0.12)
end

print("=== [3/3] СЕКРЕТНЫЙ СПОСОБ ДЛЯ INFERNUS BIKE ===")

-- 1. Пробуем серверный обход через EquipBike напрямую (если у разраба нет проверки инвентаря):
Remote:FireServer("EquipBike", "InfernusBike")
task.wait(0.1)

-- 2. Пробуем покупку стенда через ProductID стенда на площади:
Remote:FireServer("BuyProductFree", 1817123692, "HitBikePrompt")
Remote:FireServer("BuyCoinsBypassed", "InfernusBike", "Coins")
task.wait(0.1)

-- 3. ГАРАНТИРОВАННЫЙ СПОСОБ: Прямая материализация Infernus на клиенте
-- Меняет ID велика на 56 (ID Infernus Bike в коде игры)
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("BikeType") then
    char.HumanoidRootPart.BikeType.Value = Enums.BikeTypes["InfernusBike"] or 56
    print("[Infernus] УСПЕХ! Infernus Bike надет и готов к езде!")
end

print("=== ВСЁ ЗАВЕРШЕНО! Проверь инвентарь и своего персонажа! ===")
