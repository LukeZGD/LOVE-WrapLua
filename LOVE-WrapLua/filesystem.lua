if lv1lua.isPSP then
    lv1lua.saveloc = "ms0:/PSP/GAME/"..lv1lua.loveconf.identity.."/savedata/"
elseif lv1lua.mode == "PS3" then
    lv1lua.saveloc = lv1lua.dataloc.."savedata/"
else
    lv1lua.saveloc = "ux0:/data/"..lv1lua.loveconf.identity.."/savedata/"
end

if lv1lua.mode == "OneLua" then
    if not files.exists(lv1lua.saveloc) then
        files.mkdir(lv1lua.saveloc)
    end
elseif lv1lua.mode == "lpp-vita" then
    if not System.doesDirExist(lv1lua.saveloc) then
        System.createDirectory("ux0:/data/"..lv1lua.loveconf.identity)
        System.createDirectory(lv1lua.saveloc)
    end
end

function love.filesystem.read(file)
    if lv1lua.exists(lv1lua.saveloc..file) then
        file = lv1lua.saveloc..file
    elseif lv1lua.exists(lv1lua.dataloc.."game/"..file) then
        file = lv1lua.dataloc.."game/"..file
    end
    
    local openfile = io.open(file, "r")
    local contents
    if openfile then
        contents = openfile:read()
        openfile:close()
    end
    return contents
end

function love.filesystem.write(file,datawrite)
    local writetype
    if lv1lua.mode == "PS3" then
        writetype = "w+"
    else
        writetype = "w"
    end
    local openfile = io.open(lv1lua.saveloc..file, writetype)
    local success = openfile:write(datawrite)
    openfile:close()
    return success
end

function love.filesystem.append(file,datawrite)
    local openfile = io.open(lv1lua.saveloc..file, "a")
    local success = openfile:write(datawrite.."\n")
    openfile:close()
    return success
end

function love.filesystem.isFile(file)
    if lv1lua.exists(lv1lua.saveloc..file) or lv1lua.exists(lv1lua.dataloc.."game/"..file) then
        return true
    end
end

function love.filesystem.getInfo(file)
    return love.filesystem.isFile(file)
end

function love.filesystem.load(file)
    return loadfile(lv1lua.saveloc..file)
end

function love.filesystem.remove(file)
    local success
    if lv1lua.mode == "OneLua" then
        success = files.delete(lv1lua.saveloc..file)
    elseif lv1lua.mode == "lpp-vita" then
        success = System.deleteFile(lv1lua.saveloc..file)
    end
    return success
end

function love.filesystem.getIdentity()
    return lv1lua.loveconf.identity
end

function love.filesystem.getUserDirectory()
    return ""
end
function love.filesystem.getSaveDirectory()
    return ""
end
