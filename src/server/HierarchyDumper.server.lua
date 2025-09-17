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
    print(indent .. object.Name .. " [" .. object.ClassName .. "]")
    for _, child in ipairs(object:GetChildren()) do
        dump(child, indent .. "  ")
    end
end

if ENABLE_LOGGING then
    dump(workspace)
end
