local screenshake = {}

local shakes = {}
local rumbles = {}
local rumble_id = 0
local rumble_x, rumble_y = 0, 0
local total_shake_x, total_shake_y = 0, 0

function screenshake.add_screenshake(duration, x, y)
    table.insert(shakes, {
        duration = duration,
        timer = 0,
        strength_x = x,
        strength_y = (y or x),
    })
end

function screenshake.add_rumble(x, y)
    rumble_x = rumble_x + x
    rumble_y = rumble_y + (y or x)
    local r = {x, (y or x)}
    rumble_id = rumble_id + 1
    rumbles[rumble_id] = r
    return rumble_id
end

function screenshake.remove_rumble(index)
    local x, y = unpack(rumbles[index])
    rumbles[index] = nil
    rumble_x = rumble_x - x
    rumble_y = rumble_y - y
end

function screenshake.clear()
    total_shake_x = 0
    total_shake_y = 0
    rumble_x = 0
    rumble_y = 0
    shakes = {}
    rumbles = {}
end

function screenshake.update(dt)
    total_shake_x = rumble_x
    total_shake_y = rumble_y
    for i = #shakes, 1, -1 do
        local shake = shakes[i]
        shake.timer = shake.timer + dt
        if shake.timer >= shake.duration then
            table.remove(shakes, i)
        else
            total_shake_x = total_shake_x + shake.strength_x
            total_shake_y = total_shake_y + shake.strength_y
        end
    end
end

function screenshake.set()
    love.graphics.push()
    local x = math.random() * total_shake_x * 2 - total_shake_x
    local y = math.random() * total_shake_y * 2 - total_shake_y
    love.graphics.translate(x, y)
end

function screenshake.unset()
    love.graphics.pop()
end

return screenshake