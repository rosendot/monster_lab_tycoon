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

    -- Get player's personal storage
    local globalStorage = workspace:FindFirstChild("GlobalStorage")
    local playerStorages = globalStorage and globalStorage:FindFirstChild("PlayerStorages")
    local playerStorage = playerStorages and playerStorages:FindFirstChild(player.Name)
    local dnaAccumulator = playerStorage and playerStorage:FindFirstChild("AccumulatedDNA")

    if not dnaAccumulator or dnaAccumulator.Value <= 0 then
        print(player.Name .. " tried to collect but no DNA available")
        return
    end

    -- Transfer player's accumulated DNA
    local collected = dnaAccumulator.Value
    dnaStat.Value = dnaStat.Value + collected
    dnaAccumulator.Value = 0

    print(player.Name .. " collected " .. collected .. " DNA!")
end)
