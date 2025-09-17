local collectorPad = workspace:WaitForChild("DNACollector")
local displayGui = collectorPad:FindFirstChild("DNADisplayGui")
local textLabel = displayGui and displayGui:FindFirstChild("TextLabel")
local globalStorage = workspace:WaitForChild("GlobalStorage")
local playerStorages = globalStorage:WaitForChild("PlayerStorages")

local function updateDisplay()
    if not textLabel then
        return
    end

    -- Show total DNA across all players
    local totalDNA = 0
    for _, playerStorage in pairs(playerStorages:GetChildren()) do
        local dnaAccumulator = playerStorage:FindFirstChild("AccumulatedDNA")
        if dnaAccumulator then
            totalDNA = totalDNA + dnaAccumulator.Value
        end
    end

    textLabel.Text = "DNA: " .. totalDNA
end

while true do
    updateDisplay()
    task.wait(1)
end
