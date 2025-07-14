local pad = workspace:WaitForChild("DNACollector")
local displayGui = pad:FindFirstChild("DNADisplayGui")
local display = displayGui and displayGui:FindFirstChild("TextLabel")

-- Update DNA display every second
local function updateDisplay()
	if not display then return end
	local totalDNA = 0
	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("IntValue") and item.Name == "DNADrop" then
			totalDNA += item.Value
		end
	end
	display.Text = "DNA: " .. totalDNA
end

-- Refresh display constantly
task.spawn(function()
	while true do
		updateDisplay()
		task.wait(1)
	end
end)

-- Handle player touching the pad
pad.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local player = game.Players:GetPlayerFromCharacter(character)

	if player and player:FindFirstChild("leaderstats") then
		for _, item in pairs(workspace:GetChildren()) do
			if item:IsA("IntValue") and item.Name == "DNADrop" then
				player.leaderstats.DNA.Value += item.Value
				item:Destroy()
			end
		end
		updateDisplay()
	end
end)