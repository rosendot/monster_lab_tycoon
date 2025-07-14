local pad = workspace:WaitForChild("BioCoinCollectorPad")
local displayGui = pad:FindFirstChild("BioCoinDisplayGui")
local display = displayGui and displayGui:FindFirstChild("TextLabel")

-- Update floating BioCoin display
local function updateDisplay()
	if not display then return end
	local totalCoins = 0
	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("IntValue") and item.Name == "BioCoinDrop" then
			totalCoins += item.Value
		end
	end
	display.Text = "BioCoins: " .. totalCoins
end

-- Update constantly
task.spawn(function()
	while true do
		updateDisplay()
		task.wait(1)
	end
end)

-- When player touches the pad
pad.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local player = game.Players:GetPlayerFromCharacter(character)

	if player and player:FindFirstChild("leaderstats") then
		for _, item in pairs(workspace:GetChildren()) do
			if item:IsA("IntValue") and item.Name == "BioCoinDrop" then
				player.leaderstats.BioCoins.Value += item.Value
				item:Destroy()
			end
		end
		updateDisplay()
	end
end)
