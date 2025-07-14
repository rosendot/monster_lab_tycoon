local coinAmount = 10
local cooldown = 3

while true do
    wait(cooldown)
    local coinDrop = Instance.new("IntValue")
    coinDrop.Name = "BioCoinDrop"
    coinDrop.Value = coinAmount
    coinDrop.Parent = workspace
end
