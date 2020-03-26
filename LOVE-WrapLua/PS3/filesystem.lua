function love.filesystem.remove(file)
	
end

function love.filesystem.load(file)
	dofile(lv1lua.saveloc..file)
end

function love.filesystem.isFile(file)
	return love.filesystem.getInfo(file)
end

function love.filesystem.getInfo(file)
	return lv1lua.exists(lv1lua.saveloc..file)
end
