local mask = {"up", "down", "left", "right", "cross", "circle", "square", "triangle", "r", "l", "start", "select"}

function lv1lua.draw()
	if love.draw then love.draw() end
	screen.flip()
end

function lv1lua.update()
	if tmr:time() >= 16 then
		dt = tmr:time() / 1000
		if love.update then
			love.update(dt)
		end
		tmr:reset(); tmr:start()
	end
end

function lv1lua.updatecontrols()
	buttons.read()
	for i=1,#mask do
		if buttons[mask[i]] and mask[i] == "circle" then
			love.keypressed(lv1lua.keyconf[1])
		elseif buttons[mask[i]] and mask[i] == "cross" then
			love.keypressed(lv1lua.keyconf[2])
		elseif buttons[mask[i]] and mask[i] == "triangle" then
			love.keypressed(lv1lua.keyconf[3])
		elseif buttons[mask[i]] and mask[i] == "square" then
			love.keypressed(lv1lua.keyconf[4])
		elseif buttons[mask[i]] and mask[i] == "l" then
			love.keypressed(lv1lua.keyconf[5])
		elseif buttons[mask[i]] and mask[i] == "r" then
			love.keypressed(lv1lua.keyconf[6])
		elseif buttons[mask[i]] then
			love.keypressed(mask[i])
		end
		if buttons.released[mask[i]] and mask[i] == "circle" then
			love.keyreleased(lv1lua.keyconf[1])
		elseif buttons.released[mask[i]] and mask[i] == "cross" then
			love.keyreleased(lv1lua.keyconf[2])
		elseif buttons.released[mask[i]] and mask[i] == "triangle" then
			love.keyreleased(lv1lua.keyconf[3])
		elseif buttons.released[mask[i]] and mask[i] == "square" then
			love.keyreleased(lv1lua.keyconf[4])
		elseif buttons.released[mask[i]] and mask[i] == "l" then
			love.keyreleased(lv1lua.keyconf[5])
		elseif buttons.released[mask[i]] and mask[i] == "r" then
			love.keyreleased(lv1lua.keyconf[6])
		elseif buttons.released[mask[i]] then
			love.keyreleased(mask[i])
		end
	end
end