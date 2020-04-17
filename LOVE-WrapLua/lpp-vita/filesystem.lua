if not System.doesDirExist(lv1lua.saveloc) then
	System.createDirectory("ux0:/data/"..loveconfi.identity)
	System.createDirectory(lv1lua.saveloc)
end

function love.filesystem.remove(file)
	System.deleteFile(lv1lua.saveloc..file)
end

function love.filesystem.isFile(file)
	return love.filesystem.getInfo(file)
end

function love.filesystem.getInfo(file)
	if System.doesFileExist(lv1lua.saveloc..file) or System.doesDirExist(lv1lua.saveloc..file) or
	   System.doesFileExist(lv1lua.dataloc.."game/"..file) or System.doesDirExist(lv1lua.dataloc.."game/"..file) then
		return true
	else
		return false
	end
end
