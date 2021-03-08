local sweet_nothings = {
    _VERSION      = '1.0.0',
    _DESCRIPTION  = 'A Lua internationalisation library for LÖVE games',
    _AUTHOR       = "Huw 'IMP1' Taylor",
    _URL          = 'https://imp1.github.io/gamedev-scripts/scripts/lua/sweet_nothings/',
    _LICENSE      = [[
        MIT License
        Copyright (c) 2019 Huw Taylor
        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

sweet_nothings.actions = {
    ERROR        = 1,
    IGNORE       = 2,
    RETURN_BLANK = 3,
    RETURN_NIL   = 4,
}

sweet_nothings.settings = {
    -- BLANK, ERROR, IGNORE, NIL
    on_missing_localisation   = sweet_nothings.actions.IGNORE,
    add_missing_localisation  = true,
    -- BLANK, ERROR, IGNORE, NIL
    on_unset_language         = sweet_nothings.actions.ERROR,
    -- ERROR, IGNORE
    on_missing_language_file  = sweet_nothings.actions.ERROR,
    add_missing_language_file = false,
}

local current_language = nil
local language_directory = "lang"
local localisation_lookups = {}

local function add_localisation(newString)
    local files = love.filesystem.getDirectoryItems(language_directory)
    for _, file in pairs(files) do
        local path = language_directory .. "/" .. file
        local fileString = love.filesystem.read(path)
        local index = fileString:find("}[^}]*$")
        local newString = newString:gsub("\n", "\\n")
        local newContent = fileString:sub(1, index - 1) ..
                           "    [\"" .. newString .. "\"] = \"" .. newString .. "\", -- AUTOMATICALLY ADDED.\n" ..
                           fileString:sub(index)
        love.filesystem.write(path, newContent)
    end
end

local function localise(text, language)
    if not language then
        if sweet_nothings.settings.on_unset_language == sweet_nothings.actions.RETURN_BLANK then
            return ""
        elseif sweet_nothings.settings.on_unset_language == sweet_nothings.actions.ERROR then
            error("There is no language set. Use sweet_nothings.set_language() to set which language to use.")
        elseif sweet_nothings.settings.on_unset_language == sweet_nothings.actions.IGNORE then
            return text
        elseif sweet_nothings.settings.on_unset_language == sweet_nothings.actions.RETURN_NIL then
            return nil
        end
    else
        if localisation_lookups[language] and localisation_lookups[language][text] then
            return localisation_lookup[language][text]
        else
            if sweet_nothings.settings.add_missing_localisation then
                add_localisation(text)
            end
            if sweet_nothings.settings.on_missing_localisation == sweet_nothings.actions.RETURN_BLANK then
                return ""
            elseif sweet_nothings.settings.on_missing_localisation == sweet_nothings.actions.ERROR then
                error("Missing localisation for '" .. text .. "' in " .. current_language .. ".")
            elseif sweet_nothings.settings.on_missing_localisation == sweet_nothings.actions.IGNORE then
                return text
            elseif sweet_nothings.settings.on_missing_localisation == sweet_nothings.actions.RETURN_NIL then
                return nil
            end
        end
    end
end

function sweet_nothings.localise(text, language)
    if language then
        local previous_language = sweet_nothings.getLanguage()
        sweet_nothings.set_language(language or current_language)
        return localise(text, language)
        sweet_nothings.set_language(previous_language)
    else
        return localise(text, current_language)
    end
end

function sweet_nothings.defer_localise(text)
    -- add localisation if missing here, so that translation files have all possible text, 
    -- not just text that the player sees in one run.
    if localisation_lookups[language] and not localisation_lookups[language][text] then
        if sweet_nothings.settings.add_missing_localisation then
            add_localisation(text)
        end
    end
    -- return an object with original text that is translated on any tostring() calls.
    local obj = {}
    obj.original = text
    setmetatable(obj, {__tostring=function() return sweet_nothings.localise(text) end})
    return obj
end

function sweet_nothings.load_language(language)
    local path = language_directory .. "/" .. language
    local exists = love.filesystem.exists(path)
    if exists then
        localisation_lookup[language] = love.filesystem.load(path)()
    else
        if sweet_nothings.settings.add_missing_language_file then
            local f = love.filesystem.newFile(path)
            f:open('r')
            f:close()
        end
        if sweet_nothings.settings.on_missing_language_file == sweet_nothings.actions.ERROR then
            error("Missing language file '" .. language .. "'.")
        elseif sweet_nothings.settings.on_missing_language_file == sweet_nothings.actions.IGNORE then
            localisation_lookup[language] = {}
        end
    end
end

function sweet_nothings.set_language(language)
    sweet_nothings.load_language(language)
    current_language = language
end

function sweet_nothings.get_language()
    return current_language
end

function sweet_nothings.set_language_directory(path)
    language_directory = path
end

function sweet_nothings.get_language_directory(path)
    return language_directory
end

return sweet_nothings
