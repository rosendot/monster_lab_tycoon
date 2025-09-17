local collectorPad = workspace:WaitForChild("DNACollector")
local displayGui = collectorPad:FindFirstChild("DNADisplayGui")
local textLabel = displayGui and displayGui:FindFirstChild("TextLabel")

local function updateDisplay()
    if not textLabel then
        return
    end

    -- Show total DNA across all players (or just show "Available")
    local totalDNA = 0
    local globalStorage = workspace:FindFirstChild("GlobalStorage")
    local playerStorages = globalStorage and globalStorage:FindFirstChild("PlayerStorages")

    if playerStorages then
        for _, playerStorage in pairs(playerStorages:GetChildren()) do
            local dnaAccumulator = playerStorage:FindFirstChild("AccumulatedDNA")
            if dnaAccumulator then
                totalDNA = totalDNA + dnaAccumulator.Value
            end
        end
    end

    textLabel.Text = "Total DNA: " .. totalDNA
end

while true do
    updateDisplay()
    task.wait(1)
end
