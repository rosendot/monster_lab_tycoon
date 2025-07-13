local ENABLE_LOGGING = false

local INCLUDED_SERVICES = {
    ["Workspace"] = true,
    ["ReplicatedStorage"] = true,
    ["ServerScriptService"] = true,
    ["StarterPlayer"] = true,
    ["StarterGui"] = true,
    ["ServerStorage"] = true
}

local function dump(object, indent)
    indent = indent or ""

    if object == game or INCLUDED_SERVICES[object.Name] or object:IsDescendantOf(game.Workspace) or
        object:IsDescendantOf(game.ReplicatedStorage) or object:IsDescendantOf(game.ServerScriptService) or
        object:IsDescendantOf(game.StarterPlayer) or object:IsDescendantOf(game.StarterGui) or
        object:IsDescendantOf(game.ServerStorage) then
        print(indent .. object.Name .. " [" .. object.ClassName .. "]")
        for _, child in ipairs(object:GetChildren()) do
            dump(child, indent .. "  ")
        end
    end
end

if ENABLE_LOGGING then
    dump(game)
end
