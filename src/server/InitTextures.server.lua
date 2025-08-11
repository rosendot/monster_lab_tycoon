local CollectionService = game:GetService("CollectionService")

-- === CONFIG ===
local ARROW_TEXTURE_ID = "rbxassetid://1234567890" -- replace with your arrow tile asset id
local DEFAULT_SCROLL_SPEED = 3 -- studs/sec (visual only)
local TILE_U = 2               -- studs per tile across belt width
local TILE_V = 4               -- studs per tile along belt length
-- ==============

local function attachTexture(belt: BasePart)
	local old = belt:FindFirstChild("ConveyorArrows")
	if old and old:IsA("Texture") then old:Destroy() end

	local tex = Instance.new("Texture")
	tex.Name = "ConveyorArrows"
	tex.Texture = ARROW_TEXTURE_ID
	tex.Face = Enum.NormalId.Top
	tex.StudsPerTileU = TILE_U
	tex.StudsPerTileV = TILE_V
	tex.Transparency = 0
	tex.Color3 = Color3.new(1,1,1)
	tex.Parent = belt

	-- Attributes clients will read to animate
	if belt:GetAttribute("ScrollSpeed") == nil then
		belt:SetAttribute("ScrollSpeed", DEFAULT_SCROLL_SPEED)
	end
	if belt:GetAttribute("TileU") == nil then
		belt:SetAttribute("TileU", TILE_U)
	end
	if belt:GetAttribute("TileV") == nil then
		belt:SetAttribute("TileV", TILE_V)
	end
	if belt:GetAttribute("InvertArrows") == nil then
		belt:SetAttribute("InvertArrows", false)
	end
end

-- Attach to all currently tagged belts
for _, belt in ipairs(CollectionService:GetTagged("ConveyorBelt")) do
	if belt:IsA("BasePart") then
		attachTexture(belt)
	end
end

-- Attach to any belts tagged later
CollectionService:GetInstanceAddedSignal("ConveyorBelt"):Connect(function(inst)
	if inst:IsA("BasePart") then
		attachTexture(inst)
	end
end)
