function love.keyboard.isDown(key)
	if key == lv1lua.keyconf[1] then
		key = "circle"
	elseif key == lv1lua.keyconf[2] then
		key = "cross"
	elseif key == lv1lua.keyconf[3] then
		key = "triangle"
	elseif key == lv1lua.keyconf[4] then
		key = "square"
	elseif key == lv1lua.keyconf[5] then
		key = "l"
	elseif key == lv1lua.keyconf[6] then
		key = "r"
	end
	if buttons.held[key] then
		return true
	else
		return false
	end
end

function love.keyboard.setTextInput(enable)
	if enable then
		local text = osk.init("","")
		if text and text ~= "" then love.textinput(text) end
	end
end