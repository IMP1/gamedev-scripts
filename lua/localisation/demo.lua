local flags = {
    {
        draw = function(x, y, w, h) 
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("fill", x, y, w, h)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(5)
            love.graphics.line(x, y, x + w, y + h)
            love.graphics.line(x + w, y, x, y + h)
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(4)
            love.graphics.line(x + w/2, y, x + w/2, y + h)
            love.graphics.line(x, y + h/2, x + w, y + h/2)
            love.graphics.setLineWidth(3)
            love.graphics.line(x, y, x + w, y + h)
            love.graphics.line(x + w, y, x, y + h)
        end,
        lang = "en-GB",
    },
    {
        draw = function(x, y, w, h) 
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("fill", x, y, w, h)
            love.graphics.setColor(1, 1, 1)
            for j = y, y + h/2, 4 do
                for i = x, x + w/3, 4 do
                    love.graphics.circle("fill", i, j, 1)
                end
            end
            for j = 1, 7 do
                if j % 2 == 0 then
                    love.graphics.setColor(1, 1, 1)
                else
                    love.graphics.setColor(1, 0, 0)
                end
                love.graphics.rectangle("fill", x + w/3, y + j * h/14, w*2/3, h/14)
            end
            for j = 1, 6 do
                if j % 2 == 0 then
                    love.graphics.setColor(1, 1, 1)
                else
                    love.graphics.setColor(1, 0, 0)
                end
                love.graphics.rectangle("fill", x, y + j * h/14, w, h/14)
            end
        end,
        lang = "en-US",
    },
        draw = function(x, y, w, h) 
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", x, y, w, h)
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("fill", x, y, w / 3, h)
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", x + 2 * w / 3, y, w / 3, h)
        end,
        lang = "fr",
    }
}

local T = sweet_nothings.localise

function love.load()
    sweet_nothings.set_language(flags[1].lang)
end

function love.mousepressed(mx, my, key)
    for i, flag in pairs(flags) do
        local x, y, w, h = i * 128, 12, 96, 96
        if mx >= x and mx <= x + w and my >= y and my <= y + h then
            sweet_nothings.set_language(flag.lang)
        end
    end
end

function love.draw()
    for i, flag in pairs(flags) do
        if flag.lang == sweet_nothings.get_language() then
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line", i*128 - 1, 11, 98, 98)
        end
        flag.draw(i * 128, 12, 96, 96)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(T"Hello world!", 0, 128, love.graphics.getWidth, "center")
    love.graphics.printf(T"All the colours of the rainbow.", 0, 144, love.graphics.getWidth, "center")
    love.graphics.printf(T"Dice the corgette and add to the aubergine.", 0, 160, love.graphics.getWidth, "center")
end
