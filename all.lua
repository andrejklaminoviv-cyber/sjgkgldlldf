local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent
local Config = require(ReplicatedStorage.UtilityModules.Config)
local Trails = require(ReplicatedStorage.Tables.Trails)

-- 1. ЗАБИРАЕМ ВСЕ ДОНАТНЫЕ ВЕЛИКИ И ПАКИ С ТРОПАМИ ПО ИХ РЕАЛЬНЫМ PRODUCT ID
local donatProducts = {
    1817123692, -- Infernus Bike!
    1745184410, -- Unicorn Bike + Pink Glow Lord
    1739332581, -- Dirt Bike + Muddy Trail
    1766951979, -- Bee Bike + Honey Trail
    1729093481, -- Biker's Bike + Rainbow Tiger
    1751082451, -- Invisible Bike + Lantern Trail
    1732889795, -- Lawnmower + Grass Trail
    1688962958, -- Banana Bike + Banana Trail
    1685214041, -- Hover Bike + Overclock Trail
    1784318667, -- Pizza Bike + Cheese Trail
    1680902687, -- Rocket Bike + Rocket Boost Trail
    1705733459, -- Rocket Sled + Arctic Boost Trail
    1722820454, -- Shark Bike + Water Splash Trail
    1691575356, -- Star Bike + Starstream Trail
    1665966902, -- Speedy VIP + Speedy Trail
    1830714879, -- Golden Thai Bike
    3294390353, -- Bone Bike
    3324447473, -- JetSki
    3299232879, -- Warp Bike
    2658836453, -- Red Flame Bike
    2658835880, -- Purple Star Bike
    2658835154, -- Blue Yellow Bike
    2672767599, 2672767554, 2672767488, 2672767364, -- Righteous Bikes 1, 2, 3, 4
    2151426379, 2151426678, 2151427006, 2151427328, -- Hacker Bikes (Blue, Red, Purple, Green)
    2691919445, 2691919575, 2691919708,             -- Squid Bikes (001, 218, 456)
    3003387189, 3003352406, 3003305991,             -- Cupid, Golden Crush, Love Cruiser
    2681354424, 2681354695, 2681354918,             -- Christmas Bikes 1, 2, 3
    3267533701, 3267533784, 3267533606,             -- Easter Bikes
    3237873225, 3237873876, 3237873563,             -- Lucky, Fortune, Clover Bikes
    1708245248, -- BattlePass GoldPass
    1708244916  -- BattlePass Сразу 50 уровень!
}

for _, id in ipairs(donatProducts) do
    Remote:FireServer("BuyProductFree", id)
    task.wait(0.06)
end

-- 2. СКУПАЕМ ВСЕ ОСТАЛЬНЫЕ ВЕЛИКИ ЗА МОНЕТЫ ЧЕРЕЗ ОФИЦИАЛЬНЫЙ ЭВЕНТ
for bikeName, _ in pairs(Config.BikeInfo) do
    Remote:FireServer("BuyCoinsBypassed", bikeName, "Coins")
    task.wait(0.04)
end

-- 3. СКУПАЕМ ВСЕ МАГАЗИННЫЕ ТРОПЫ ЗА МОНЕТЫ
for trailName, _ in pairs(Trails) do
    Remote:FireServer("BuyFeatured", trailName, "Coins")
    task.wait(0.04)
end

-- 4. ЗАБИРАЕМ ВСЕ НАГРАДЫ BATTLEPASS (1-50 УРОВНИ)
for i = 1, 50 do
    Remote:FireServer("ClaimReward", i)
    task.wait(0.02)
end
