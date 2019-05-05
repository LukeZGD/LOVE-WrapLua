local saveloc = "ux0:/data/"..loveconfi.identity.."/"

if not System.doesDirExist(saveloc) then
	System.createDirectory(saveloc)
end

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
	system.deleteFile(saveloc..file)
end

function love.filesystem.load(file)
	dofile(saveloc..file)
end

function love.filesystem.isFile(file)
	return System.doesFileExist(saveloc..file)
end

function love.filesystem.getInfo(file)
	return System.doesFileExist(saveloc..file) or System.doesDirExist(saveloc..file)
end

function love.filesystem.getIdentity(id)
	return loveconfi.identity
end