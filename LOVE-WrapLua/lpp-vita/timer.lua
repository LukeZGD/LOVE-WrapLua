--timer stuff for update dt
lv1lua.timer = Timer.new()
local gtimer = Timer.new()
dt = 0

function love.timer.getTime()
    return Timer.getTime(gtimer) / 1000
end

function love.timer.getDelta()
    return dt
end
