local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trails = require(ReplicatedStorage.Tables.Trails)
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent

-- Покупка абсолютно всех 155 троп через официальный эвент:
for trailName, _ in pairs(Trails) do
    Remote:FireServer("BuyFeatured", trailName, "Coins")
    task.wait(0.05) -- небольшая пауза между запросами
end
