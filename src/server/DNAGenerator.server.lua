-- DNAGeneratorScript
local dnaAmount = 10
local cooldown = 3

while true do
    wait(cooldown)
    local dnaDrop = Instance.new("IntValue")
    dnaDrop.Name = "DNADrop"
    dnaDrop.Value = dnaAmount
    dnaDrop.Parent = workspace

    print("[DNAGenerator] Created DNADrop with value:", dnaDrop.Value)
end
