if lv1lua.isPSP then
	lv1lua.saveloc = "ms0:/PSP/GAME/"..loveconfi.identity.."/savedata/"
elseif lv1lua.mode == "PS3" then
	lv1lua.saveloc = lv1lua.dataloc.."/savedata/"
else
	lv1lua.saveloc = "ux0:/data/"..loveconfi.identity.."/savedata/"
end
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/filesystem.lua")

function love.filesystem.read(file)
	local openfile = io.open(lv1lua.saveloc..file, "r")
	local contents = openfile:read()
	openfile:close()
	return contents
end

function love.filesystem.write(file,datawrite)
	local openfile = io.open(lv1lua.saveloc..file, "w")
	openfile:write(datawrite)
	openfile:close()
end

function love.filesystem.load(file)
	return loadfile(lv1lua.saveloc..file)
end

function love.filesystem.getIdentity(id)
	return loveconfi.identity
end
