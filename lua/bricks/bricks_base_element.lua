local base_element = {}
base_element.__index = base_element

function base_element.new(element_name, id, position, options)
    if options.visible == nil then options.visible = true end

    local self = {}
    setmetatable(obj, base_element)

    self._name    = element_name
    self.id       = id
    self.position = position or {0, 0}
    self.anchor   = {0, 0}
    self.size     = {"100", "100"}
    self.data     = {}
    self.loaded   = false
    self.on_load  = options.onload or nil
    self.parent   = nil
    self.children = {}

    self.visible  = options.visible
    self.disabled = false
    self.hover    = false
    self.selected = false
    self.active   = false
    self.invalid  = false

    self.style    = {}

    return self
end

function base_element:load()
    if self.on_load then
        self:on_load()
    end
    self:load_content()
    self.loaded = true
end

function base_element:load_content()
    for _, child in pairs(self.children) do
        child:load()
    end
end

function base_element:getRelativePosition()
    local parent_size
    if self.parent then
        parent_size = self.parent:getAbsoluteSize()
    else
        parent_size = { love.graphics.getWidth(), love.graphics.getHeight() }
    end
    local x, y = self.position
    if type(x) == string then x = tonumber(x) * parent_size[1] / 100 end
    if type(y) == string then y = tonumber(y) * parent_size[2] / 100 end
    if x < 0 then x = x + parent_size[1] end
    if y < 0 then y = y + parent_size[2] end
    return {x, y}
end

function base_element:getAbsoluteBounds()
    local parent_bounds
    if self.parent then
        parent_bounds = self.parent:getAbsoluteBounds()
    else
        parent_bounds = {0, 0, love.graphics.getWidth(), love.graphics.getHeight()}
    end
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)
    if type(x) == string then x = tonumber(x) * parent_bounds[3] / 100 end
    if type(y) == string then y = tonumber(y) * parent_bounds[4] / 100 end
    if type(w) == string then w = tonumber(w) * parent_bounds[3] / 100 end
    if type(h) == string then h = tonumber(h) * parent_bounds[4] / 100 end
    if x < 0 then x = x + parent_bounds[3] end
    if y < 0 then y = y + parent_bounds[4] end
    x = x + parent_bounds[1]
    y = y + parent_bounds[2]
    return { x, y, w, h }
end

function base_element:getAbsolutePosition()
    local x, y, w, h = self:getAbsoluteBounds()
    return {x, y}
end

function base_element:getAbsoluteSize()
    local x, y, w, h = self:getAbsoluteBounds()
    return {w, h}
end

function base_element:isMouseOver(mx, my)
    local x, y, w, h = unpack(self:getAbsoluteBounds())
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function base_element:draw()
    if not self.visible then return end
    bricks.graphics.push()
    local x, y = unpack(self:getRelativePosition())
    local w, h = unpack(self:getAbsoluteSize())
    x, y, w, h = self:applyMargin(x, y, w, h)
    self:drawShape(x, y, w, h)
    x, y, w, h = self:applyPadding(x, y, w, h)
    love.graphics.push()
    love.graphics.translate(x, y)
    self:drawContent(w, h)
    love.graphics.pop()
    bricks.graphics.pop()
end

function base_element:drawContent(w, h)
end

function base_element:applyMargin(x, y, w, h)
    if self.style.margin then
        x = x + self.style.margin[1]
        y = y + self.style.margin[2]
        w = h - (self.style.margin[1] + self.style.margin[3])
        h = h - (self.style.margin[2] + self.style.margin[4])
    end
    return x, y, w, h
end

function base_element:applyPadding(x, y, w, h)
    if self.style.padding then
        x = x + self.style.padding[1]
        y = y + self.style.padding[2]
        w = h - (self.style.padding[1] + self.style.padding[3])
        h = h - (self.style.padding[2] + self.style.padding[4])
    end
    return x, y, w, h
end

function base_element:drawShape(x, y, w, h)
    local rx, ry = 0, 0
    if self.style.border_radius then
        rx, ry = unpack(self.style.border_radius)
    end
    function base_element:drawBackground(x, y, w, h, rx, ry)
    function base_element:drawBorder(x, y, w, h, rx, ry)
end

function base_element:drawBackground(x, y, w, h, rx, ry)
    if self.invalid and self.style.background_colour_invalid then
        bricks.graphics.setColor(self.style.background_colour_invalid)
    elseif self.active and self.style.background_colour_active then
        bricks.graphics.setColor(self.style.background_colour_active)
    elseif self.focus and self.style.background_colour_focus then
        bricks.graphics.setColor(self.style.background_colour_focus)
    elseif self.style.background_colour then
        bricks.graphics.setColor(self.style.background_colour)
    else
        return
    end
    love.graphics.rectangle("fill", x, y, w, h, rx, ry)
end

function base_element:drawBorder(x, y, w, h, rx, ry)
    if self.invalid and self.style.border_colour_invalid then
        bricks.graphics.setColor(self.style.border_colour_invalid)
    elseif self.active and self.style.border_colour_active then
        bricks.graphics.setColor(self.style.border_colour_active)
    elseif self.focus and self.style.border_colour_focus then
        bricks.graphics.setColor(self.style.border_colour_focus)
    elseif self.style.border_colour then
        bricks.graphics.setColor(self.style.border_colour)
    else
        return
    end
    -- TODO: set line style as well
    love.graphics.rectangle("line", x, y, w, h, rx, ry)
end

return base_element
