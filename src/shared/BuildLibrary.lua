-- src/shared/BuildLibrary.lua
local BuildLibrary = {}

-- Colors
local DARK = Color3.fromRGB(45, 45, 45)
local LIGHT = Color3.fromRGB(200, 200, 200)
local CREAM = Color3.fromRGB(245, 240, 225)

local function part(parent, name, size, pos, color, rot)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = pos
    p.Anchored = true
    p.Color = color
    p.Material = Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    if rot then
        p.Orientation = rot
    end
    p.Parent = parent
    return p
end

function BuildLibrary.CreateDropperTall(origin)
    origin = origin or Vector3.new()
    local model = Instance.new("Model")
    model.Name = "Dropper_Tall"
    model.Parent = workspace

    -- Base
    part(model, "Base", Vector3.new(3, 0.5, 3), origin + Vector3.new(0, 0.25, 0), DARK)
    -- Pillar
    part(model, "Pillar", Vector3.new(1, 7, 1), origin + Vector3.new(1, 3.75, -1), LIGHT)
    -- Arm
    part(model, "Arm", Vector3.new(4, 1, 1), origin + Vector3.new(-1, 7.5, -1), LIGHT)
    -- Neck
    part(model, "Neck", Vector3.new(1, 1.5, 1), origin + Vector3.new(-3, 7.5, -1), LIGHT)
    -- Head
    part(model, "Head", Vector3.new(2, 2, 2), origin + Vector3.new(-4.5, 7.5, -1), CREAM, Vector3.new(-30, 0, 0))
    -- Tube
    part(model, "Tube", Vector3.new(1, 1.5, 1), origin + Vector3.new(-4.5, 6.25, -1), DARK, Vector3.new(-30, 0, 0))
    -- Steps
    part(model, "Step1", Vector3.new(1.5, 0.5, 1.5), origin + Vector3.new(-4.5, 5.5, -1), DARK)
    part(model, "Step2", Vector3.new(1.1, 0.5, 1.1), origin + Vector3.new(-4.5, 5, -1), DARK)
    part(model, "NozzleTip", Vector3.new(0.8, 0.5, 0.8), origin + Vector3.new(-4.5, 4.5, -1), DARK)

    return model
end

return BuildLibrary
