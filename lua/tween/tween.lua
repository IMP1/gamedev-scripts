
local tween_object = {}
tween_object.__index = tween_object

function tween_object.new(duration, subject, target, easing_function)
    local self = {}
    setmetatable(self, tween_object)
    self.duration = duration
    self.subject = subject
    self.target = target
    self.easing_function = easing_function
    self.paused = false
    self.finished = false
    self.timer = 0
    self.initial_values = {}
    for k, _ in pairs(target) do
        if subject[k] then
            self.initial_values[k] = subject[k]
        end
    end
    return self
end

function tween_object:update(dt)
    if self.finished then return end
    if self.paused then return end

    self.timer = self.timer + dt
    if self.timer > self.duration then 
        self.timer = self.duration
        self.finished = true
    end
    for k, v in pairs(self.initial_values) do
        self.subject[k] = self.easing_function(self.timer, v, self.target[k], self.duration)
    end
end

local tween_manager = {}

local function linear(t, a, b, d)
    return a + (b - a) * (t / d)
end

local function quadIn(t, a, b, d)
    return a + (b - a) * math.pow(t / d, 2)
end

local function quadOut(t, a, b, d)
    return a + (a - b) * t * (t - 2 * d)
end

local function quadInOut(t, a, b, d)
    t = t / d * 2
    if t < 1 then 
        return (b - a) / 2 * pow(t, 2) + a 
    else
        return -(b - a) / 2 * ((t - 1) * (t - 3) - 1) + a
    end
end

local function quadOutIn(t, a, b, d)
    if t < d / 2 then 
        return quadOut(t * 2, a, (b - a) / 2, d) 
    else
        return quadIn((t * 2) - d, a + (b - a) / 2, (b - a) / 2, d)
    end
end

-- More easing functions found here: https://github.com/kikito/tween.lua/blob/master/tween.lua

tween_manager.easing_functions = {
    linear = linear,
    quadIn = quadIn,
    quadOut = quadOut,
    quadInOut = quadInOut,
    quadOutIn = quadOutIn,
}

local unfinished_tweens = {}

function tween_manager.new(time, subject, target, easing_function)
    local tween = tween_object.new(time, subject, target, easing_function or linear)
    table.insert(unfinished_tweens, tween)
    return tween
end

function tween_manager.update(dt)
    for _, tween in pairs(unfinished_tweens) do
        tween:update(dt)
    end
    for i = #unfinished_tweens, 1, -1 do
        if unfinished_tweens[i].finished then
            table.remove(unfinished_tweens, i)
        end
    end
end

return tween_manager
