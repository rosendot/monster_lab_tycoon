local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local belts = {}

local function trackBelt(belt: BasePart)
	if belts[belt] then return end
	local tex = belt:FindFirstChild("ConveyorArrows")
	if not (tex and tex:IsA("Texture")) then return end
	belts[belt] = { tex = tex, offsetV = 0 }
end

for _, belt in ipairs(CollectionService:GetTagged("ConveyorBelt")) do
	if belt:IsA("BasePart") then trackBelt(belt) end
end
CollectionService:GetInstanceAddedSignal("ConveyorBelt"):Connect(function(inst)
	if inst:IsA("BasePart") then trackBelt(inst) end
end)
CollectionService:GetInstanceRemovedSignal("ConveyorBelt"):Connect(function(inst)
	belts[inst] = nil
end)

RunService.RenderStepped:Connect(function(dt)
	for belt, data in pairs(belts) do
		if not belt or not belt.Parent then belts[belt] = nil continue end

		local tex = data.tex
		if not (tex and tex.Parent == belt) then
			tex = belt:FindFirstChild("ConveyorArrows")
			if not (tex and tex:IsA("Texture")) then
				continue
			else
				data.tex = tex
			end
		end

		local tileV = belt:GetAttribute("TileV") or tex.StudsPerTileV or 4
		local speed = belt:GetAttribute("ScrollSpeed") or 3
		if belt:GetAttribute("InvertArrows") == true then speed = -speed end

		data.offsetV = (data.offsetV + speed * dt) % tileV
		tex.OffsetStudsV = data.offsetV
	end
end)
