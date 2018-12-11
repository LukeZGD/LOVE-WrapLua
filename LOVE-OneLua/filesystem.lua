local saveloc = "ux0:/data/"..lv1lua.appname.."/savedata/"
if lv1lua.isPSP then
	saveloc = "ms0:/data/"..lv1lua.appname.."/savedata/"
end

if not files.exists(saveloc) then
	files.mkdir(saveloc)
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
	files.delete(saveloc..file)
end

function love.filesystem.load(file)
	dofile(saveloc..file)
end

function love.filesystem.isFile(file)
	return files.exists(saveloc..file)
end

function love.filesystem.getInfo(file)
	return love.filesystem.isFile(file)
end