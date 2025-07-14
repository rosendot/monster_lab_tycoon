local BuyButtons = workspace:WaitForChild("BuyButtons")

for _, button in ipairs(BuyButtons:GetChildren()) do
	local config = button:FindFirstChild("Config")
	if not config then
		continue
	end

	local costValue = config:FindFirstChild("Cost")
	local targetValue = config:FindFirstChild("Target")
	local currencyValue = config:FindFirstChild("Currency")

	if not costValue or not targetValue or not currencyValue then
		continue
	end

	local currencyName = currencyValue.Value

	button.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		local player = game.Players:GetPlayerFromCharacter(character)
		if not player then return end

		local stats = player:FindFirstChild("leaderstats")
		if not stats then return end

		local currencyStat = stats:FindFirstChild(currencyName)
		if not currencyStat then
			return
		end

		if currencyStat.Value < costValue.Value then
			return
		end

		currencyStat.Value -= costValue.Value

		if targetValue.Value then
			targetValue.Value.Parent = workspace
		end

		button:Destroy()
	end)
end