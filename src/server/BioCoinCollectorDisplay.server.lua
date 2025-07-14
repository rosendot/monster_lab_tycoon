local collectorPad = workspace:WaitForChild("BioCoinCollector")
local displayGui = collectorPad:FindFirstChild("BioCoinDisplayGui")
local textLabel = displayGui and displayGui:FindFirstChild("TextLabel")

local function updateDisplay()
	if not textLabel then return end

	local totalCoins = 0
	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("IntValue") and item.Name == "BioCoinDrop" then
			totalCoins += item.Value
		end
	end

	textLabel.Text = "BioCoins: " .. totalCoins
end

-- Update display every second
while true do
	updateDisplay()
	task.wait(1)
end
