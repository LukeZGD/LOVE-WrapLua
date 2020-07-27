--timer stuff for update dt
lv1lua.timer = timer.new()
local gtimer = timer.new()
lv1lua.timer:start()
gtimer:start()
dt = 0

function love.timer.getTime()
    return gtimer:time() / 1000
end

function love.timer.getDelta()
    return dt
end
