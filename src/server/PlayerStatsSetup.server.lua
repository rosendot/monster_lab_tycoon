game.Players.PlayerAdded:Connect(function(player)
    local stats = Instance.new("Folder")
    stats.Name = "leaderstats"
    stats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "BioCoins"
    coins.Value = 0
    coins.Parent = stats

    local dna = Instance.new("IntValue")
    dna.Name = "DNA"
    dna.Value = 0
    dna.Parent = stats
end)
