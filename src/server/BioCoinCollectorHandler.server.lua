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

    -- Get player's personal storage
    local globalStorage = workspace:FindFirstChild("GlobalStorage")
    local playerStorages = globalStorage and globalStorage:FindFirstChild("PlayerStorages")
    local playerStorage = playerStorages and playerStorages:FindFirstChild(player.Name)
    local coinAccumulator = playerStorage and playerStorage:FindFirstChild("AccumulatedCoins")

    if not coinAccumulator or coinAccumulator.Value <= 0 then
        print(player.Name .. " tried to collect but no BioCoins available")
        return
    end

    -- Transfer player's accumulated coins
    local collected = coinAccumulator.Value
    coinStat.Value = coinStat.Value + collected
    coinAccumulator.Value = 0

    print(player.Name .. " collected " .. collected .. " BioCoins!")
end)
