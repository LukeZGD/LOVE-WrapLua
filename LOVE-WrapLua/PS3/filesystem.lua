local saveloc = lv1lua.dataloc

function love.filesystem.read(file)
	local openfile = io.open(saveloc..file, "r")
	local contents = openfile:read()
	io.close(openfile)
	return contents
end

function love.filesystem.write(file,datawrite)
	local openfile = io.open(saveloc..file, "w+")
	openfile:write(datawrite)
	io.close(openfile)
end

function love.filesystem.remove(file)
	
end

function love.filesystem.load(file)
	dofile(saveloc..file)
end

function love.filesystem.isFile(file)
	return love.filesystem.getInfo(file)
end

function love.filesystem.getInfo(file)
	return lv1lua.exists(saveloc..file)
end

function love.filesystem.getIdentity(id)
	return loveconfi.identity
end