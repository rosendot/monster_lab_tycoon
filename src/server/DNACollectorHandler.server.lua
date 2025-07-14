local DNACollector = workspace:WaitForChild("DNACollector")

DNACollector.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then
		return
	end

	local stats = player:FindFirstChild("leaderstats")
	local dnaStat = stats and stats:FindFirstChild("DNA")
	if not dnaStat then
		return
	end

	local collected = 0

	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("IntValue") and item.Name == "DNADrop" then
			collected += item.Value
			dnaStat.Value += item.Value
			item:Destroy()
		end
	end
end)