local safeword = {}

local SAVEDATA_FILENAME = "safeword"

local save_data = {}
local used_keys = {}

local function decompress(file_text)
    -- TODO: Add compression/decompression
    return file_text
end

local function compress(text_data)
    -- TODO: Add compression/decompression
    return text_data
end

local function escape_string(str)
    return str -- TODO: Escape special characters
end

local function to_string(obj, depth)
    if type(obj) == "number" or type(obj) == "boolean" or type(obj) == nil then
        return tostring(obj)
    elseif type(obj) == "string" then
        return "\"" .. escape_string(obj) .. "\""
    elseif type(obj) == "table" then
        local padding = string.rep("\t", depth or 0)
        local str = "{\n"
        for k, v in pairs(obj) do
            str = str .. padding .. "\t[" .. to_string(k, (depth or 0) + 1) .. "] = " .. to_string(v, (depth or 0) + 1) .. ",\n"
        end
        return str .. padding .. "}"
    end
end

function safeword.load()
    local info = love.filesystem.getInfo(SAVEDATA_FILENAME)
    if info then
        local saved_data = decompress(love.filesystem.read(SAVEDATA_FILENAME))
        local all_data = loadstring(saved_data)()
        save_data = all_data.save_data
        used_keys = all_data.used_keys
    else
        save_data = {}
        used_keys = {}
    end
end

function safeword.save()
    save_filedata = {
        save_data = save_data,
        used_keys = used_keys
    }
    local save_data = "return " .. to_string(save_filedata)
    local success = love.filesystem.write(SAVEDATA_FILENAME, compress(save_data))
    return success
end

function safeword.get(key, default)
    if used_keys[key] then
        return save_data[key]
    else
        return default
    end
end

function safeword.set(key, value)
    save_data[key] = value
    used_keys[key] = true
end

function safeword.delete(key)
    save_data[key] = nil
    used_keys[key] = nil
end

return safeword
