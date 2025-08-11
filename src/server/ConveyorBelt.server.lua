-- ConveyorBelt.server.lua (optimized)
-- Tracks *only* things touching belts, then forces their along-belt velocity.
-- Supports multiple belts via CollectionService tag: "ConveyorBelt"

local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- Tuning
local PROCESS_HZ = 20           -- how often to update velocities (Hz)
local TOUCH_HEIGHT = 0.2        -- thickness of the invisible touch sensor
local MIN_MASS = 0              -- optional: ignore tiny debris if you want
local MAX_MASS = math.huge      -- optional: cap if needed

-- Per-belt state
type BeltState = {
	belt: BasePart,
	speed: number,
	dir: Vector3,
	sensor: BasePart,
	touching: {[BasePart]: boolean},
}

local belts: {BeltState} = {}

-- Build a thin, invisible sensor that slightly hovers over the belt top face.
local function makeSensorFor(belt: BasePart): BasePart
	local sensor = Instance.new("Part")
	sensor.Name = "ConveyorSensor"
	sensor.Anchored = true
	sensor.CanCollide = false
	sensor.CanQuery = true
	sensor.CanTouch = true
	sensor.Transparency = 1
	sensor.Size = Vector3.new(belt.Size.X, TOUCH_HEIGHT, belt.Size.Z)
	-- place it flush with the belt top
	local topOffset = CFrame.new(0, (belt.Size.Y/2) + (TOUCH_HEIGHT/2) + 0.01, 0)
	sensor.CFrame = belt.CFrame * topOffset
	sensor.Parent = belt
	return sensor
end

local function readBeltSpeed(belt: BasePart): number
	-- Prefer attribute "ConveyorSpeed" if set; else fallback to 16 studs/s
	local s = belt:GetAttribute("ConveyorSpeed")
	if typeof(s) == "number" then return s end
	return 16
end

local function initBelt(belt: BasePart)
	-- Avoid duplicates
	for _, bs in ipairs(belts) do
		if bs.belt == belt then return end
	end

	local sensor = makeSensorFor(belt)
	local speed = readBeltSpeed(belt)
	local dir = belt.CFrame.RightVector -- move along local +X; flip by setting negative speed

	local state: BeltState = {
		belt = belt,
		speed = speed,
		dir = dir,
		sensor = sensor,
		touching = {},
	}
	table.insert(belts, state)

	-- Keep sensor aligned if the belt moves/rotates
	belt:GetPropertyChangedSignal("CFrame"):Connect(function()
		if sensor and sensor.Parent then
			local topOffset = CFrame.new(0, (belt.Size.Y/2) + (TOUCH_HEIGHT/2) + 0.01, 0)
			sensor.CFrame = belt.CFrame * topOffset
		end
	end)

	-- If speed attribute changes live
	belt.AttributeChanged:Connect(function(attr)
		if attr == "ConveyorSpeed" then
			state.speed = readBeltSpeed(belt)
		end
	end)

	-- Track actual touching parts (no global workspace scans)
	sensor.Touched:Connect(function(hit)
		local p = hit:IsA("BasePart") and hit or nil
		if not p then return end
		if p == belt or p == sensor then return end
		if p.Anchored then return end
		local mass = p:GetMass()
		if mass < MIN_MASS or mass > MAX_MASS then return end
		state.touching[p] = true
	end)

	sensor.TouchEnded:Connect(function(hit)
		local p = hit:IsA("BasePart") and hit or nil
		if p then state.touching[p] = nil end
	end)
end

-- Set just the along-belt component of the assembly velocity.
local function pushAlongBelt(part: BasePart, dir: Vector3, speed: number)
	-- If the part is blocked or anchored, skip
	if part.Anchored or not part.Parent then return end

	-- Project current velocity onto belt direction, then correct to target speed
	local v = part.AssemblyLinearVelocity
	local along = dir:Dot(v)
	local delta = speed - along
	if math.abs(delta) < 0.01 then return end -- already close enough

	-- Adjust only the component along the belt direction; preserve other motion
	local newV = v + dir * delta
	part.AssemblyLinearVelocity = newV
end

-- Discover belts now and in the future
for _, inst in ipairs(CollectionService:GetTagged("ConveyorBelt")) do
	if inst:IsA("BasePart") then initBelt(inst) end
end
CollectionService:GetInstanceAddedSignal("ConveyorBelt"):Connect(function(inst)
	if inst:IsA("BasePart") then initBelt(inst) end
end)

-- Periodic processing (no per-frame heavy work)
do
	local acc = 0
	RunService.Heartbeat:Connect(function(dt)
		acc += dt
		local step = 1/PROCESS_HZ
		if acc < step then return end
		acc -= step

		for i = #belts, 1, -1 do
			local bs = belts[i]
			if not bs.belt or not bs.belt.Parent then
				if bs.sensor then bs.sensor:Destroy() end
				table.remove(belts, i)
			else
				-- Refresh direction every tick in case the belt rotated
				bs.dir = bs.belt.CFrame.RightVector
				local speed = bs.speed

				-- Nudge everything currently touching
				for part in pairs(bs.touching) do
					if not part or not part.Parent then
						bs.touching[part] = nil
					else
						pushAlongBelt(part, bs.dir, speed)
					end
				end
			end
		end
	end)
end
