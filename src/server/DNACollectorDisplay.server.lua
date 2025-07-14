local collectorPad = workspace:WaitForChild("DNACollector")
local displayGui = collectorPad:FindFirstChild("DNADisplayGui")
local textLabel = displayGui and displayGui:FindFirstChild("TextLabel")

local function updateDisplay()
	if not textLabel then return end

	local totalDNA = 0
	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("IntValue") and item.Name == "DNADrop" then
			totalDNA += item.Value
		end
	end

	textLabel.Text = "DNA: " .. totalDNA
end

while true do
	updateDisplay()
	task.wait(1)
end