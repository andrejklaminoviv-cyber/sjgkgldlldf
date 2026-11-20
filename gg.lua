local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.UtilityModules.Config)
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent

-- Реальный способ: цикл покупки всех существующих великов за монеты
for bikeName, bikeData in pairs(Config.BikeInfo) do
    Remote:FireServer("BuyCoinsBypassed", bikeName, "Coins")
    task.wait(0.05) -- небольшая задержка, чтобы сервер не заблокировал спам
end
