if lv1lua.isPSP then
    love._console_name = "PSP"
elseif lv1lua.mode == "PS3" then
    love._console_name = "PS3"
else
    love._console_name = "Vita"
end

function love.system.getOS()
    return "LOVE-WrapLua"
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
