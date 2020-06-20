love.touch = {
    _touches = {},
    _count = 0
}

love.touch.__getFrontTouches = function(touchUserData)
    love.touch._count = touchUserData.front.count
    for i = 1, touchUserData.front.count do
        love.touch._touches[i] = touchUserData.front[i]
    end

end

love.touch.getPosition = function(id)
    if(id >= love.touch._count) then
        return 0, 0
    end
    return love.touch._touches[id].x, love.touch._touches[id].y
end

love.touch.getPressure = function(id)
    if(love.touch._count >= id and love.touch._touches[id] and love.touch._touches[id].pressed) then
        return 1
    else
        return 0
    end
end

love.touch.getTouches = function()
    return love.touch._touches
end