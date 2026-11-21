-- =========================================================
-- [BIKE OF HELL] INSTANT INFERNUS & INVENTORY UNLOCKER (v2)
-- =========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

print("[Bike of Hell] [1/4] Инициализация скрипта...")

local Config = require(ReplicatedStorage.UtilityModules.Config)
local Enums = require(ReplicatedStorage.UtilityModules.Enums)
local Trails = require(ReplicatedStorage.Tables.Trails)
local Remote = ReplicatedStorage.NetworkEvents.RemoteEvent

local currentBikeId = 56 -- Enums.BikeTypes.InfernusBike (ID Инфернуса)
local currentBikeName = "InfernusBike"

-- Функция поиска персонажа (в Bike of Hell персонажи в workspace.Characters):
local function getCharacter()
    return LocalPlayer.Character 
        or (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(LocalPlayer.Name)) 
        or workspace:FindFirstChild(LocalPlayer.Name)
end

-- =========================================================
-- [2/4] МГНОВЕННАЯ СБОРКА И НАДЕВАНИЕ ИНФЕРНУСА НА ПЕРСОНАЖА
-- =========================================================
local function equipBikeModel(bikeId, bikeName)
    currentBikeId = bikeId
    currentBikeName = bikeName or currentBikeName

    local char = getCharacter()
    if not char then 
        warn("[Bike of Hell] Персонаж ещё не заспавнен!")
        return 
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bt = hrp:FindFirstChild("BikeType")
    if not bt then return end

    -- Удаляем старую 3D модель в workspace.Ignore, чтобы игра не конфликтовала:
    local ignoreFolder = workspace:FindFirstChild("Ignore")
    if ignoreFolder then
        local oldBike = ignoreFolder:FindFirstChild(LocalPlayer.Name .. "Bike")
        if oldBike then
            oldBike:Destroy()
        end
    end

    -- Переключаем BikeType для вызова официального rebuildBike в Bike.lua:
    if bt.Value == bikeId then
        bt.Value = 0
        task.wait(0.03)
    end
    bt.Value = bikeId

    -- Перезапускаем официальный модуль привязки велика:
    pcall(function()
        local BikeMod = require(ReplicatedStorage.Modules.Bike)
        BikeMod:Attach(char)
    end)

    print("[Bike of Hell] [OK] Велик переключен на: " .. tostring(bikeName or bikeId) .. " (ID: " .. tostring(bikeId) .. ")")
end

-- Функция экипировки тропы:
local function equipTrailEffect(trailName)
    LocalPlayer:SetAttribute("Trail", trailName)
    local char = getCharacter()
    if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("Trails") then
        char.HumanoidRootPart.Trails.Value = true
    end
    pcall(function()
        local trailsFunc = require(ReplicatedStorage.Modules.Bike.Trails)
        trailsFunc(LocalPlayer, trailName)
    end)
    print("[Bike of Hell] [OK] Тропа переключена на: " .. tostring(trailName))
end

-- Надеваем Infernus прямо сейчас:
equipBikeModel(56, "InfernusBike")
print("[Bike of Hell] [2/4] Инфернус активирован под персонажем!")

-- =========================================================
-- [3/4] АВТОМАТИЧЕСКОЕ СОХРАНЕНИЕ ПРИ СМЕРТИ / РЕСПАВНЕ
-- =========================================================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.4)
    equipBikeModel(currentBikeId, currentBikeName)
    if LocalPlayer:GetAttribute("Trail") then
        equipTrailEffect(LocalPlayer:GetAttribute("Trail"))
    end
end)

-- Фоновый поток, удерживающий велик (если сервер попытается его сбросить):
task.spawn(function()
    while true do
        task.wait(0.3)
        local char = getCharacter()
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bt = hrp:FindFirstChild("BikeType")
                if bt and bt.Value ~= currentBikeId then
                    bt.Value = currentBikeId
                end
            end
        end
    end
end)
print("[Bike of Hell] [3/4] Авто-респавн Инфернуса подключен!")

-- =========================================================
-- [4/4] РАЗБЛОКИРОВКА И ДОБАВЛЕНИЕ ВСЕХ ВЕЛИКОВ И ТРОП В МЕНЮ
-- =========================================================
task.spawn(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not playerGui then return end

    local screenGui = playerGui:WaitForChild("ScreenGui", 10)
    if not screenGui then return end

    local inventory = screenGui:WaitForChild("Inventory", 10)
    if not inventory then return end

    local bikeList = inventory:WaitForChild("BikeList", 5)
    local trailList = inventory:WaitForChild("TrailList", 5)
    local templates = bikeList and bikeList:FindFirstChild("_Templates")

    if not templates then 
        warn("[Bike of Hell] Шаблоны интерфейса не найдены")
        return 
    end

    -- Добавляем абсолютно все 124 велика в меню:
    local rarityMap = {
        [1] = "Basic",
        [2] = "Uncommon",
        [3] = "Epic",
        [4] = "Legendary",
        [5] = "Legendary",
        [6] = "Legendary"
    }

    local bikesAdded = 0
    for bName, bInfo in pairs(Config.BikeInfo) do
        if not bikeList:FindFirstChild(bName) then
            local rName = rarityMap[bInfo.Rarity] or "Legendary"
            local template = templates:FindFirstChild(rName) or templates.Legendary
            local btn = template:Clone()
            btn.Name = bName
            btn.Visible = true

            local icon = btn:FindFirstChild("Icon", true)
            if icon and bInfo.Image then
                icon.Image = bInfo.Image
            end

            -- При клике на велик в инвентаре он моментально надевается:
            btn.MouseButton1Down:Connect(function()
                local bId = Enums.BikeTypes[bName] or 1
                equipBikeModel(bId, bName)

                -- Подсветка кнопки голубым:
                for _, other in ipairs(bikeList:GetChildren()) do
                    if other:IsA("GuiObject") and other:FindFirstChild("ImageLabel") and other.ImageLabel:FindFirstChild("UIGradient") then
                        other.ImageLabel.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                    end
                end
                if btn:FindFirstChild("ImageLabel") and btn.ImageLabel:FindFirstChild("UIGradient") then
                    btn.ImageLabel.UIGradient.Color = ColorSequence.new(Color3.fromRGB(0, 166, 255))
                end
            end)

            btn.Parent = bikeList
            bikesAdded += 1
        end
    end

    -- Добавляем абсолютно все 155 троп в меню:
    local trailsAdded = 0
    for tName, tInfo in pairs(Trails) do
        if not trailList:FindFirstChild(tName) then
            local rName = tInfo.Rarity or "Legendary"
            local template = templates:FindFirstChild(rName) or templates.Legendary
            local btn = template:Clone()
            btn.Name = tName
            btn.Visible = true

            local icon = btn:FindFirstChild("Icon", true)
            if icon and tInfo.Image then
                icon.Image = tInfo.Image
                if tInfo.ImageCol then
                    icon.ImageColor3 = tInfo.ImageCol
                end
            end

            -- При клике на тропу в инвентаре она надевается:
            btn.MouseButton1Down:Connect(function()
                equipTrailEffect(tName)

                for _, other in ipairs(trailList:GetChildren()) do
                    if other:IsA("GuiObject") and other:FindFirstChild("ImageLabel") and other.ImageLabel:FindFirstChild("UIGradient") then
                        other.ImageLabel.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                    end
                end
                if btn:FindFirstChild("ImageLabel") and btn.ImageLabel:FindFirstChild("UIGradient") then
                    btn.ImageLabel.UIGradient.Color = ColorSequence.new(Color3.fromRGB(0, 166, 255))
                end
            end)

            btn.Parent = trailList
            trailsAdded += 1
        end
    end

    print(string.format("[Bike of Hell] [4/4] Готово! В меню инвентаря добавлены все велики (+%d) и тропы (+%d)!", bikesAdded, trailsAdded))
end)

-- =========================================================
-- ФОНОВАЯ ОФИЦИАЛЬНАЯ СКУПКА СЕРВЕРНЫХ ВЕЛИКОВ И ТРОП
-- =========================================================
task.spawn(function()
    task.wait(1)
    print("[Bike of Hell] [Сервер] Запускаем скупку доступных серверных великов и троп...")
    for bName, bInfo in pairs(Config.BikeInfo) do
        if bInfo.ShopPrice ~= nil then
            Remote:FireServer("BuyCoinsBypassed", bName, "Coins")
            task.wait(0.12)
        end
    end
    for tName, tInfo in pairs(Trails) do
        if tInfo.ShopPrice ~= nil then
            Remote:FireServer("BuyFeatured", tName, "Coins")
            task.wait(0.12)
        end
    end
    print("[Bike of Hell] [Сервер] Все официальные покупки завершены!")
end)

print("[Bike of Hell] УСПЕХ! Посмотри на своего персонажа — ты на Infernus Bike! Открой инвентарь — там все велики и тропы кликабельны!")
