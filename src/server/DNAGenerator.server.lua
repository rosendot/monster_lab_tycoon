local dnaAmount = 10
local cooldown = 3

-- Get or create global storage container
local globalStorage = workspace:FindFirstChild("GlobalStorage")
if not globalStorage then
    globalStorage = Instance.new("Folder")
    globalStorage.Name = "GlobalStorage"
    globalStorage.Parent = workspace
end

local playerStorages = globalStorage:FindFirstChild("PlayerStorages")
if not playerStorages then
    playerStorages = Instance.new("Folder")
    playerStorages.Name = "PlayerStorages"
    playerStorages.Parent = globalStorage
end

-- Function to get or create player's storage
local function getPlayerStorage(player)
    local playerStorage = playerStorages:FindFirstChild(player.Name)
    if not playerStorage then
        playerStorage = Instance.new("Folder")
        playerStorage.Name = player.Name
        playerStorage.Parent = playerStorages

        local dnaAccumulator = Instance.new("IntValue")
        dnaAccumulator.Name = "AccumulatedDNA"
        dnaAccumulator.Value = 0
        dnaAccumulator.Parent = playerStorage

        local coinAccumulator = Instance.new("IntValue")
        coinAccumulator.Name = "AccumulatedCoins"
        coinAccumulator.Value = 0
        coinAccumulator.Parent = playerStorage
    end
    return playerStorage
end

-- Create storage for players when they join
game.Players.PlayerAdded:Connect(function(player)
    getPlayerStorage(player)
end)

-- Clean up when players leave
game.Players.PlayerRemoving:Connect(function(player)
    local playerStorage = playerStorages:FindFirstChild(player.Name)
    if playerStorage then
        playerStorage:Destroy()
    end
end)

-- Generate DNA for all online players
while true do
    wait(cooldown)
    for _, player in pairs(game.Players:GetPlayers()) do
        local playerStorage = getPlayerStorage(player)
        local dnaAccumulator = playerStorage:FindFirstChild("AccumulatedDNA")
        if dnaAccumulator then
            dnaAccumulator.Value = dnaAccumulator.Value + dnaAmount
        end
    end
    print("Generated DNA for all " .. #game.Players:GetPlayers() .. " players")
end
