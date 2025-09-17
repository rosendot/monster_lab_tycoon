local BuyButtons = workspace:WaitForChild("BuyButtons")

for _, button in ipairs(BuyButtons:GetChildren()) do
    local config = button:FindFirstChild("Config")
    if not config then
        warn("Button " .. button.Name .. " missing Config folder")
        continue
    end

    local costValue = config:FindFirstChild("Cost")
    local targetValue = config:FindFirstChild("Target")
    local currencyValue = config:FindFirstChild("Currency")

    if not costValue or not targetValue or not currencyValue then
        warn("Button " .. button.Name .. " missing required config values")
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
            warn("Player " .. player.Name .. " missing currency: " .. currencyName)
            return
        end

        if currencyStat.Value < costValue.Value then
            print(player.Name .. " cannot afford " .. button.Name .. " (needs " .. costValue.Value .. " " .. currencyName .. ")")
            return
        end

        currencyStat.Value -= costValue.Value

        if targetValue.Value then
            targetValue.Value.Parent = workspace
            print(player.Name .. " purchased " .. button.Name)
        end

        button:Destroy()
    end)
end