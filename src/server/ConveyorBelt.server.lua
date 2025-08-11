-- ConveyorBelt.server.lua
local RunService = game:GetService("RunService")

-- Configuration
local CONVEYOR_SPEED = 16 -- studs per second

-- Get the conveyor belt part (you create this in Studio)
local conveyorBelt = workspace:WaitForChild("ConveyorBelt")

local function isOnBelt(part)
    if not part or not part.Parent or not part:IsA("BasePart") then
        return false
    end

    local beltTop = conveyorBelt.Position.Y + conveyorBelt.Size.Y / 2
    local partBottom = part.Position.Y - part.Size.Y / 2

    -- Check if part is touching the belt surface
    return
        math.abs(partBottom - beltTop) <= 1 and part.Position.X >= conveyorBelt.Position.X - conveyorBelt.Size.X / 2 and
            part.Position.X <= conveyorBelt.Position.X + conveyorBelt.Size.X / 2 and part.Position.Z >=
            conveyorBelt.Position.Z - conveyorBelt.Size.Z / 2 and part.Position.Z <= conveyorBelt.Position.Z +
            conveyorBelt.Size.Z / 2
end

-- Main conveyor loop
RunService.Heartbeat:Connect(function()
    -- Check all parts in workspace
    for _, part in pairs(workspace:GetChildren()) do
        if isOnBelt(part) and part ~= conveyorBelt and part.CanCollide then
            -- Add or update BodyVelocity
            local bodyVelocity = part:FindFirstChild("ConveyorVelocity")
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Name = "ConveyorVelocity"
                bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
                bodyVelocity.Parent = part
            end
            bodyVelocity.Velocity = Vector3.new(CONVEYOR_SPEED, 0, 0)
        else
            -- Remove BodyVelocity if part is no longer on belt
            local bodyVelocity = part:FindFirstChild("ConveyorVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end)
