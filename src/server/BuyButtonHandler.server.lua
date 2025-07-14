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

	if not costValue or not targetValue then
		warn("[BuyButton] " .. button.Name .. " missing Cost or Target.")
		continue
	end

	print("[BuyButton] Button ready:", button.Name, "| Cost =", costValue.Value)

	button.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		if not character then
			print("[BuyButton] Something touched, but no character.")
			return
		end

		local player = game.Players:GetPlayerFromCharacter(character)
		if not player then
			print("[BuyButton] Touched by something that's not a player.")
			return
		end

		print("[BuyButton] Touched by:", player.Name)

		local stats = player:FindFirstChild("leaderstats")
		if not stats then
			warn("[BuyButton] " .. player.Name .. " has no leaderstats.")
			return
		end

		local dna = stats:FindFirstChild("DNA")
		if not dna then
			warn("[BuyButton] " .. player.Name .. " has no DNA stat.")
			return
		end

		print("[BuyButton] " .. player.Name .. " DNA =", dna.Value, "| Cost =", costValue.Value)

		if dna.Value < costValue.Value then
			print("[BuyButton] Not enough DNA for", player.Name)
			return
		end

		dna.Value -= costValue.Value
		print("[BuyButton] PURCHASED by", player.Name, "| New DNA:", dna.Value)

		if targetValue.Value then
			targetValue.Value.Parent = workspace
			print("[BuyButton] Revealed:", targetValue.Value.Name)
		else
			warn("[BuyButton] TargetValue exists but is nil")
		end

		button:Destroy()
		print("[BuyButton] Removed button:", button.Name)
	end)
end
