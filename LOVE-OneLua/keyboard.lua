function love.keyboard.isDown(key)
	if key == "a" then
		key = "circle"
	elseif key == "b" then
		key = "cross"
	elseif key == "x" then
		key = "triangle"
	elseif key == "y" then
		key = "square"
	end
	if buttons.held[key] then
		return true
	else
		return false
	end
end

function love.keyboard.setTextInput(boo)
	if boo then
		local text = osk.init("","")
		if text and love.textinput then love.textinput(text) end
	end
end