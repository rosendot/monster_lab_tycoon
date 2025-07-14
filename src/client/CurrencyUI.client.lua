-- CurrencyUI.client.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for leaderstats to be created
local leaderstats = player:WaitForChild("leaderstats")
local bioCoins = leaderstats:WaitForChild("BioCoins")
local dna = leaderstats:WaitForChild("DNA")

-- Create main UI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CurrencyUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame for currency display
local mainFrame = Instance.new("Frame")
mainFrame.Name = "CurrencyFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 120)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Add subtle border glow
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💰 LAB RESOURCES"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- BioCoins display
local bioCoinFrame = Instance.new("Frame")
bioCoinFrame.Name = "BioCoinFrame"
bioCoinFrame.Size = UDim2.new(1, -20, 0, 35)
bioCoinFrame.Position = UDim2.new(0, 10, 0, 40)
bioCoinFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
bioCoinFrame.BorderSizePixel = 0
bioCoinFrame.Parent = mainFrame

local bioCoinCorner = Instance.new("UICorner")
bioCoinCorner.CornerRadius = UDim.new(0, 8)
bioCoinCorner.Parent = bioCoinFrame

local bioCoinLabel = Instance.new("TextLabel")
bioCoinLabel.Name = "BioCoinLabel"
bioCoinLabel.Size = UDim2.new(1, -10, 1, 0)
bioCoinLabel.Position = UDim2.new(0, 10, 0, 0)
bioCoinLabel.BackgroundTransparency = 1
bioCoinLabel.Text = "🪙 BioCoins: 0"
bioCoinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
bioCoinLabel.TextScaled = true
bioCoinLabel.Font = Enum.Font.SourceSansBold
bioCoinLabel.TextXAlignment = Enum.TextXAlignment.Left
bioCoinLabel.Parent = bioCoinFrame

-- DNA display
local dnaFrame = Instance.new("Frame")
dnaFrame.Name = "DNAFrame"
dnaFrame.Size = UDim2.new(1, -20, 0, 35)
dnaFrame.Position = UDim2.new(0, 10, 0, 80)
dnaFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dnaFrame.BorderSizePixel = 0
dnaFrame.Parent = mainFrame

local dnaCorner = Instance.new("UICorner")
dnaCorner.CornerRadius = UDim.new(0, 8)
dnaCorner.Parent = dnaFrame

local dnaLabel = Instance.new("TextLabel")
dnaLabel.Name = "DNALabel"
dnaLabel.Size = UDim2.new(1, -10, 1, 0)
dnaLabel.Position = UDim2.new(0, 10, 0, 0)
dnaLabel.BackgroundTransparency = 1
dnaLabel.Text = "🧬 DNA: 0"
dnaLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
dnaLabel.TextScaled = true
dnaLabel.Font = Enum.Font.SourceSansBold
dnaLabel.TextXAlignment = Enum.TextXAlignment.Left
dnaLabel.Parent = dnaFrame

-- Animation tweens for value changes
local function createPulseAnimation(frame)
    local tween = TweenService:Create(frame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
            Size = frame.Size + UDim2.new(0, 8, 0, 4)
        })
    return tween
end

-- Update functions with animations
local function updateBioCoins()
    local value = bioCoins.Value
    bioCoinLabel.Text = "🪙 BioCoins: " .. tostring(value)

    -- Pulse animation on value change
    local pulse = createPulseAnimation(bioCoinFrame)
    pulse:Play()
end

local function updateDNA()
    local value = dna.Value
    dnaLabel.Text = "🧬 DNA: " .. tostring(value)

    -- Pulse animation on value change
    local pulse = createPulseAnimation(dnaFrame)
    pulse:Play()
end

-- Connect to value changes
bioCoins.Changed:Connect(updateBioCoins)
dna.Changed:Connect(updateDNA)

-- Initialize display
updateBioCoins()
updateDNA()

-- Optional: Add a fade-in animation when the UI loads
local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
})

-- Start with transparent frame
mainFrame.BackgroundTransparency = 1
titleLabel.TextTransparency = 1
bioCoinLabel.TextTransparency = 1
dnaLabel.TextTransparency = 1

-- Fade everything in
fadeIn:Play()
TweenService:Create(titleLabel, TweenInfo.new(0.5), {
    TextTransparency = 0
}):Play()
TweenService:Create(bioCoinLabel, TweenInfo.new(0.5), {
    TextTransparency = 0
}):Play()
TweenService:Create(dnaLabel, TweenInfo.new(0.5), {
    TextTransparency = 0
}):Play()
