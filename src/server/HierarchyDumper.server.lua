local INCLUDE = {
    ["Workspace"] = true,
    ["ReplicatedStorage"] = true,
    ["ServerScriptService"] = true,
    ["StarterPlayer"] = true,
    ["StarterGui"] = true,
    ["ServerStorage"] = true
}

local function dump(object, indent)
    indent = indent or ""

    if object == game or INCLUDE[object.Name] or object:IsDescendantOf(workspace) or
        object:IsDescendantOf(game:GetService("ReplicatedStorage")) or
        object:IsDescendantOf(game:GetService("ServerScriptService")) or
        object:IsDescendantOf(game:GetService("StarterPlayer")) or object:IsDescendantOf(game:GetService("StarterGui")) or
        object:IsDescendantOf(game:GetService("ServerStorage")) then
        print(indent .. object.Name .. " [" .. object.ClassName .. "]")
        for _, child in ipairs(object:GetChildren()) do
            dump(child, indent .. "  ")
        end
    end
end

dump(game)
