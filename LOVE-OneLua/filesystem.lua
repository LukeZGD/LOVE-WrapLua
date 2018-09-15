local saveloc = "ux0:/data/"..appname.."/savedata/"

function love.filesystem.read(file)
	local openfile = io.open(saveloc..file, "r")
	local contents = openfile:read()
	io.close(openfile)
	return contents
end

function love.filesystem.write(file,data)
	local openfile = io.open(saveloc..file, "w+")
	openfile:write(data)
	io.close(openfile)
end

function love.filesystem.isFile(file)
	return files.exists(saveloc..file)
end

function love.filesystem.getInfo(file)
	return files.exists(saveloc..file)
end