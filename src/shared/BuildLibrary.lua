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

    -- Pillar: move to the base center
    part(model, "Pillar", Vector3.new(1, 7, 1), origin + Vector3.new(0, 3.75, 0), LIGHT)

    -- Apply Δ = (-1, 0, +1) to everything above so it looks the same
    part(model, "Arm", Vector3.new(4, 1, 1), origin + Vector3.new(-2, 7.5, 0), LIGHT)
    part(model, "Neck", Vector3.new(1, 1.5, 1), origin + Vector3.new(-4, 7.5, 0), LIGHT)
    part(model, "Head", Vector3.new(2, 2, 2), origin + Vector3.new(-5.5, 7.5, 0), CREAM, Vector3.new(-30, 0, 0))
    part(model, "Tube", Vector3.new(1, 1.5, 1), origin + Vector3.new(-5.5, 6.25, 0), DARK, Vector3.new(-30, 0, 0))
    part(model, "Step1", Vector3.new(1.5, 0.5, 1.5), origin + Vector3.new(-5.5, 5.5, 0), DARK)
    part(model, "Step2", Vector3.new(1.1, 0.5, 1.1), origin + Vector3.new(-5.5, 5.0, 0), DARK)
    part(model, "NozzleTip", Vector3.new(0.8, 0.5, 0.8), origin + Vector3.new(-5.5, 4.5, 0), DARK)

    return model
end

return BuildLibrary
