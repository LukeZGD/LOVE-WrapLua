--timer stuff for update dt
tmr = Timer.new()
stmr = Timer.new()
dt = 0

function love.timer.getTime()
	return Timer.getTime(stmr) / 1000
end

function love.timer.getDelta()
	return dt
end