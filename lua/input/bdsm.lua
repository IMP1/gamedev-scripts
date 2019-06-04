local bdsm = {
    _NAME        = 'Basic Device Subscription Manager',
    _AUTHOR      = 'Huw \'IMP1\' Taylor',
    _VERSION     = 'v0.1.0',
    _DESCRIPTION = [[
An input library for LÖVE, made to work similarly to Unity's InputSystem. 
Devices are managed separately to provide standardised input events and states.

    ]],
    _URL         = 'https://github.com/IMP1/gamedev-scripts/blob/master/lua/input/bdsm.lua',
    _LICENSE     = [[
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
    ]],
}

bdsm.actions = {
    PRESS   = "press",
    RELEASE = "release",
    MOVE    = "move",
}

local next_device_id = 1
local device_managers = {}

local input_mapping_schemes = {}

function bdsm.register_device(device_manager)
    local id = next_device_id
    device_managers[id] = device_manager
    next_device_id = next_device_id + 1
    return id
end

function bdsm.subscribe(love_event_name, func)
    local old_func = love.handlers[love_event_name]
    love.handlers[love_event_name] = function(...)
        old_func(...)
        func(...)
    end
end

function bdsm.get_device(device_id)
    return device_managers[id]
end

function bdsm.add_input_scheme(scheme)
    print("adding input scheme")
    table.insert(input_mapping_schemes, scheme)
end

function bdsm.remove_input_scheme(scheme)
    local index = 0
    for i, s in ipairs(input_mapping_schemes) do
        if scheme == s then
            index = i
            break
        end
    end
    if index > 0 then
        print("removing input scheme")
        table.remove(input_mapping_schemes, index)
    end
end

-- To be used by Device Managers only, push standardised virtual input events.
function bdsm.handle_device_event(device, event, ...)
    local event = {
        device     = device.id,
        devicename = device.name,
        keyname    = event.keyname,
        keytype    = event.keytype,
        key        = event.key,
        action     = event.action,
        params     = {...},
    }
    for _, scheme in pairs(input_mapping_schemes) do
        if scheme.uses_device(device.id) then
            scheme.handle_event(event)
        end
    end
end

function bdsm.get_device_state(device_id, key)
    local device_manager = device_managers[device_id]
    local state = device_manager.get_state(device_id, key)

    return {
        device     = device_id,
        devicename = state.devicename,
        keyname    = state.keyname,
        keytype    = state.keytype,
        key        = key,
        state      = state.properties,
    }
end

function bdsm.get_state(device_id, state_name)
    -- @TODO: use the current context to translate the state_name to a key_id
    --        maybe pass the context and key_id to the device manager? Or the scheme?

end

return bdsm
