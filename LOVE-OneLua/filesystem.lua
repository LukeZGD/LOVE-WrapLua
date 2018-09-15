function love.filesystem.read(file)
	local openfile = io.open(dataloc.."savedata/"..file, "r")
	local contents = openfile:read()
	io.close(openfile)
	return contents
end

function love.filesystem.write(file,data)
	local openfile = io.open(dataloc.."savedata/"..file, "w+")
	openfile:write(data)
	io.close(openfile)
end

function love.filesystem.isFile(file)
	return files.exists(dataloc.."savedata/"..file)
end

function love.filesystem.getInfo(file)
	return files.exists(dataloc.."savedata/"..file)
end