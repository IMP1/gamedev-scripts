local stack = {}

local metatable = {}
function metatable.__index(table, key)
    if key:find("set") and love.graphics[key] then
        local getter = key:gsub("set", "get", 1)
        local current_value = { love.graphics[getter]() }
        local top_level = stack[#stack]
        if not top_level[getter] then
            top_level[getter] = current_value
        end
        return love.graphics[key]

    elseif key:find("get") and love.graphics[key] then
        local i = #stack
        local top_level = stack[i]
        while top_level[key] == nil and i > 0 do
            i = i - 1
            top_level = stack[i]
        end
        return top_level[key] or love.graphics[key]

    else
        return rawget(table, key)
    end
end

local graphics = {}
setmetatable(graphics, metatable)

function graphics.push()
    table.insert(stack, {})
end

function graphics.pop()
    local top_level = table.remove(stack)
    for key, value in pairs(top_level) do
        local setter = key:gsub("get", "set", 1)
        love.graphics[setter](unpack(value))
    end
end

return graphics
