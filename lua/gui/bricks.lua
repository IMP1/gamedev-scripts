local bricks = {
    _VERSION      = "0.0.0",
    _DESCRIPTION  = 'A Lua GUI library for LÖVE games',
    _AUTHOR       = "Huw 'IMP1' Taylor",
    _URL          = 'https://imp1.github.io/gamedev-scripts/scripts/lua/bricks_and_mortar/',
    _LICENSE      = [[
        MIT License
        Copyright (c) 2020 Huw Taylor
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

bricks.graphics = require 'bricks_graphics'

local base_element = require 'bricks_base_element'
local selected_element = nil

function base_element:select()
    if selected_element then
        selected_element:deselect()
    end
    self.selected = true
    selected_element = self
end

function base_element:deselect()
    self.selected = false
end

function base_element:matches(selector)
    local parts = {}
    for p in selector:gsub("[^.]*") do
        table.insert(parts, p)
    end
    local id_match   = (parts[1] == "*" or parts[1] == self.id)
    local type_match = (parts[2] == "*" or parts[2] == self._name)
    return id_match and type_match
end

function base_element:find(selector)
    if selector == nil or selector == "" then return nil end
    --[[
    Use filepath-style stuff.
             any number of descendants
     any id  |
     |       |  element id
     |       |  |  element_type
     |       |  |  |
     V       V  V  V
    /*.group/**/id.text_input
    --]]
end

return bricks
