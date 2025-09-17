local collectorPad = workspace:WaitForChild("BioCoinCollector")
local displayGui = collectorPad:FindFirstChild("BioCoinDisplayGui")
local textLabel = displayGui and displayGui:FindFirstChild("TextLabel")

local function updateDisplay()
    if not textLabel then
        return
    end

    -- Show total BioCoins across all players
    local totalCoins = 0
    local globalStorage = workspace:FindFirstChild("GlobalStorage")
    local playerStorages = globalStorage and globalStorage:FindFirstChild("PlayerStorages")

    if playerStorages then
        for _, playerStorage in pairs(playerStorages:GetChildren()) do
            local coinAccumulator = playerStorage:FindFirstChild("AccumulatedCoins")
            if coinAccumulator then
                totalCoins = totalCoins + coinAccumulator.Value
            end
        end
    end

    textLabel.Text = "BioCoins: " .. totalCoins
end

while true do
    updateDisplay()
    task.wait(1)
end
