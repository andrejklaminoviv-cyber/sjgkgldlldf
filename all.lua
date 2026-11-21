local Remote = game:GetService("ReplicatedStorage").NetworkEvents.RemoteEvent

-- Точные официальные пары (ProductID, PackName) из PackStorage:
local officialPacks = {
    { 1665966902, "StarterPack" },     -- Speedy VIP + Speedy Trail
    { 1722820454, "UpdatePack" },      -- Shark Bike + Water Splash
    { 1722820454, "SharkPack" },       -- Shark Bundle
    { 1745184410, "UnicornBike" },     -- Unicorn Bike + Pink Glow Lord
    { 1739332581, "DirtPack" },        -- Dirt Bike + Muddy Trail
    { 1766951979, "BeePack" },         -- Bee Bike + Honey Trail
    { 1729093481, "BikersBike" },      -- Biker's Bike + Rainbow Tiger
    { 1751082451, "InvisiblePack" },   -- Invisible Bike + Lantern Trail
    { 1732889795, "GrassPack" },       -- Lawnmower + Grass Trail
    { 1688962958, "BananaPack" },      -- Banana Bike + Banana Trail
    { 1685214041, "HoverPack" },       -- Hover Bike + Overclock
    { 1784318667, "PizzaPack" },       -- Pizza Bike + Cheese
    { 1680902687, "RocketPack" },      -- Rocket Bike + Rocket Boost
    { 1705733459, "RocketSledPack" },  -- Rocket Sled + Arctic Boost
    { 1691575356, "StarPack" },        -- Star Bike + Starstream
    { 1830714879, "ThaiPack" },        -- Golden Thai Bike
    { 3294390353, "BoneBikeEvent" },   -- Bone Bike
    { 3324447473, "JetSkiEvent" },     -- JetSki
    
    -- Все возможные официальные варианты для Infernus Bike:
    { 1817123692, "InfernusBike" },
    { 1817123692, "Gamepass" },
    { 1817123692, "HitBikePrompt" },
}

for _, packData in ipairs(officialPacks) do
    Remote:FireServer("BuyProductFree", packData[1], packData[2])
    task.wait(0.08)
end
