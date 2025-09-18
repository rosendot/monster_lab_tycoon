-- src/shared/BuildLibrary.lua
local BuildLibrary = {}

-- Colors
local DARK = Color3.fromRGB(45, 45, 45)
local LIGHT = Color3.fromRGB(200, 200, 200)
local CREAM = Color3.fromRGB(245, 240, 225)

-- Helper to create parts
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

-- Main Dropper
function BuildLibrary.CreateDropperTall(origin)
    origin = origin or Vector3.new()
    local model = Instance.new("Model")
    model.Name = "Dropper_Tall"
    model.Parent = workspace

    -- Base (centered at origin)
    part(model, "Base", Vector3.new(3, 0.5, 3), origin + Vector3.new(0, 0.25, 0), DARK)

    -- Pillar (centered on base)
    part(model, "Pillar", Vector3.new(1, 7, 1), origin + Vector3.new(0, 3.75, 0), LIGHT)

    -- Arm
    part(model, "Arm", Vector3.new(4, 1, 1), origin + Vector3.new(-2, 7.5, 0), LIGHT)

    -- Neck
    part(model, "Neck", Vector3.new(1, 1.5, 1), origin + Vector3.new(-4, 7.5, 0), LIGHT)

    -- Head (tilted)
    local headPos = origin + Vector3.new(-5.5, 7.5, 0)
    local headRot = Vector3.new(-30, 0, 0)
    part(model, "Head", Vector3.new(2, 2, 2), headPos, CREAM, headRot)

    -- Chimney Cap (Mario tube style), aligned to head tilt
    local headTiltDeg = 30 -- magnitude of tilt (head is -30° about X)
    local ang = math.rad(headTiltDeg)
    local up = Vector3.new(0, math.cos(ang), -math.sin(ang)) -- head's local up direction

    local headHalfY = 1
    local stemSizeY = 1.2
    local lidSizeY = 0.5

    local stemCenter = headPos + up * (headHalfY + stemSizeY / 2)
    part(model, "CapStem", Vector3.new(1, 1.2, 1), stemCenter, DARK, headRot)

    local lidCenter = headPos + up * (headHalfY + stemSizeY + lidSizeY / 2)
    part(model, "CapLid", Vector3.new(2.6, 0.5, 2.6), lidCenter, DARK, headRot)

    -- Tube + nozzle (below head, tilted same as head)
    part(model, "Tube", Vector3.new(1, 1.5, 1), origin + Vector3.new(-5.5, 6.25, 0), DARK, headRot)
    part(model, "Step1", Vector3.new(1.5, 0.5, 1.5), origin + Vector3.new(-5.5, 5.5, 0), DARK)
    part(model, "Step2", Vector3.new(1.1, 0.5, 1.1), origin + Vector3.new(-5.5, 5.0, 0), DARK)
    part(model, "NozzleTip", Vector3.new(0.8, 0.5, 0.8), origin + Vector3.new(-5.5, 4.5, 0), DARK)

    return model
end

return BuildLibrary
