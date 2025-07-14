local DNACollector = workspace:WaitForChild("DNACollector")

DNACollector.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then
		warn("[DNACollector] No player from touch")
		return
	end

	local stats = player:FindFirstChild("leaderstats")
	local dnaStat = stats and stats:FindFirstChild("DNA")
	if not dnaStat then
		warn("[DNACollector] Missing leaderstats or DNA stat for", player.Name)
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

	if collected > 0 then
		print("[DNACollector] " .. player.Name .. " collected DNA:", collected, "| New Total:", dnaStat.Value)
	else
		print("[DNACollector] " .. player.Name .. " touched pad, but no DNA drops present")
	end
end)
