function love.system.getOS()
	if isPSP then
		return "PSP"
	else
		return "Vita"
	end
end