--Mouse is a wrapper for simpler integration with touch
love.mouse = {
    _lastX = 0,
    _lastY = 0
}

love.mousepressed = function(x,y,button)end

love.mouse.getX = function()
    return love.mouse._lastX
end

love.mouse.getY = function()
    return love.mouse._lastY
end

love.mouse.getPosition = function()
    return love.mouse.getX(), love.mouse.getY()
end


love.mouse.isDown = function()
    return love.touch.getPressure(love.touch._count) == 1
end

love.mouse.__updateMouse = function()
    love.mouse._lastX, love.mouse._lastY =  love.touch.getPosition(1)
end