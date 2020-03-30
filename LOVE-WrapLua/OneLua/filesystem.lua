if not files.exists(lv1lua.saveloc) then
	files.mkdir(lv1lua.saveloc)
end

function love.filesystem.remove(file)
	files.delete(lv1lua.saveloc..file)
end

function love.filesystem.isFile(file)
	if files.exists(lv1lua.saveloc..file) or files.exists(lv1lua.dataloc.."game/"..file) then
		return true
	else
		return false
	end
end

function love.filesystem.getInfo(file)
	return love.filesystem.isFile(file)
end
