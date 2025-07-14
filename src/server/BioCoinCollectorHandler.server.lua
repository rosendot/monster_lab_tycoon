local coinCollector = workspace:WaitForChild("BioCoinCollector")

coinCollector.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then
		return
	end

	local stats = player:FindFirstChild("leaderstats")
	local coinStat = stats and stats:FindFirstChild("BioCoins")
	if not coinStat then
		return
	end

	local collected = 0

	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("IntValue") and item.Name == "BioCoinDrop" then
			collected += item.Value
			coinStat.Value += item.Value
			item:Destroy()
		end
	end
end)