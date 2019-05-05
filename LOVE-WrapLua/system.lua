function love.system.getOS()
	if lv1lua.isPSP then
		return "LOVE-WrapLua", "PSP"
	elseif lv1lua.mode == "PS3" then
		return "LOVE-WrapLua", "PS3"
	else
		return "LOVE-WrapLua", "Vita"
	end
end

function love.system.getLanguage()
	if lv1lua.mode == "lpp-vita" then
		return System.getLanguage()
	elseif lv1lua.mode == "OneLua" then
		return os.language()
	end
end

function love.system.getUsername()
	if lv1lua.mode == "lpp-vita" then
		return System.getUsername()
	elseif lv1lua.mode == "OneLua" then
		return os.nick()
	end
end