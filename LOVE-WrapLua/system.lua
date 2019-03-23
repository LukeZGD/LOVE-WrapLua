function love.system.getOS()
	if lv1lua.isPSP then
		return "LOVE-WrapLua", "PSP"
	else
		return "LOVE-WrapLua", "Vita"
	end
end

function love.system.getLanguage()
	return os.language()
end

function love.system.getUsername()
	return os.nick()
end