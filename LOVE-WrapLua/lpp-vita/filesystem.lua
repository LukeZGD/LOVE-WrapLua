if not System.doesDirExist(lv1lua.saveloc) then
	System.createDirectory(lv1lua.saveloc)
end

function love.filesystem.remove(file)
	System.deleteFile(lv1lua.saveloc..file)
end

function love.filesystem.isFile(file)
	return System.doesFileExist(lv1lua.saveloc..file)
end

function love.filesystem.getInfo(file)
	return System.doesFileExist(lv1lua.saveloc..file) or System.doesDirExist(lv1lua.saveloc..file)
end
