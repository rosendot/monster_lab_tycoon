local BuyButtons = workspace:WaitForChild("BuyButtons")

for _, button in ipairs(BuyButtons:GetChildren()) do
	print("[BuyButton] Setting up button:", button.Name)

	local config = button:FindFirstChild("Config")
	if not config then
		warn("[BuyButton] " .. button.Name .. " missing Config folder.")
		continue
	end

	local costValue = config:FindFirstChild("Cost")
	local targetValue = config:FindFirstChild("Target")
	local currencyValue = config:FindFirstChild("Currency") -- New

	if not costValue or not targetValue or not currencyValue then
		warn("[BuyButton] " .. button.Name .. " missing Cost, Target, or Currency.")
		continue
	end

	local currencyName = currencyValue.Value
	print(string.format("[BuyButton] Ready: %s | Cost = %d %s", button.Name, costValue.Value, currencyName))

	button.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		local player = game.Players:GetPlayerFromCharacter(character)
		if not player then return end

		local stats = player:FindFirstChild("leaderstats")
		if not stats then return end

		local currencyStat = stats:FindFirstChild(currencyName)
		if not currencyStat then
			warn("[BuyButton] Currency '" .. currencyName .. "' not found in leaderstats for " .. player.Name)
			return
		end

		print(string.format("[BuyButton] %s has %s = %d | Cost = %d", player.Name, currencyName, currencyStat.Value, costValue.Value))

		if currencyStat.Value < costValue.Value then
			print("[BuyButton] Not enough " .. currencyName .. " for " .. player.Name)
			return
		end

		currencyStat.Value -= costValue.Value
		print(string.format("[BuyButton] PURCHASED by %s | New %s: %d", player.Name, currencyName, currencyStat.Value))

		if targetValue.Value then
			targetValue.Value.Parent = workspace
			print("[BuyButton] Revealed:", targetValue.Value.Name)
		end

		button:Destroy()
	end)
end
