--default print font
local defaultfont = Font.load(lv1lua.dataloc.."LOVE-WrapLua/Vera.ttf")
Font.setPixelSizes(defaultfont,12)

--set up stuff
lv1lua.current = {
    font = defaultfont,
    color = Color.new(255,255,255,255),
    bgcolor=Color.new(0,0,0,255)
}

function love.graphics.newImage(filename)
    local img = Graphics.loadImage(lv1lua.dataloc.."game/"..filename)
    return img
end

function love.graphics.draw(drawable,x,y,r,sx,sy)
    if not x then x = 0 end
    if not y then y = 0 end
    if not r then r = 0 end
    if not sx then sx = 1 end
    if not sy then sy = 1 end
    if sx and not sy then sy = sx end
    
    --scale 1280x720 to 960x540(vita)
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        x = x * 0.75; y = y * 0.75
    end
    
    if lv1luaconf.imgscale == true then
        sx = sx * 0.75
        sy = sy * 0.75
    end
    
    if drawable then
        Graphics.drawScaleImage(x,y,drawable,sx,sy,lv1lua.current.color)
        --[[
        Graphics.drawImageExtended(
            x,y,drawable, --x,y,image
            x,y,Graphics.getImageWidth(drawable),Graphics.getImageHeight(drawable), --partial draw (not needed)
            r, --rotation
            sx,sy, --scale
            lv1lua.current.color
        )
        ]]
    end
end

function love.graphics.newFont(setfont, setsize)
    if tonumber(setfont) then
        setsize = setfont
    elseif not setsize then
        setsize = 12
    end
    
    if tonumber(setfont) then
        setfont = defaultfont
    elseif setfont then
        setfont = Font.load(lv1lua.dataloc.."game/"..setfont)
    end
    
    --scale 1280x720 to 960x540
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        setsize = setsize*0.825
    end
    Font.setPixelSizes(setfont,setsize)
    
    return setfont
end

function love.graphics.setFont(setfont,setsize)
    if setsize then
        Font.setPixelSizes(setfont,setsize)
    end
    lv1lua.current.font = setfont
end

function love.graphics.setNewFont(setfont,setsize)
    newfont = love.graphics.newFont(setfont, setsize)
    love.graphics.setFont(newfont, setsize)
    return newfont
end

function love.graphics.print(text,x,y)
    if not x then x = 0 end
    if not y then y = 0 end
    
    --scale 1280x720 to 960x540
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        x = x * 0.75; y = y * 0.75
    end
    
    if text then
        Font.print(lv1lua.current.font,x,y,text,lv1lua.current.color)
    end
end

function love.graphics.setColor(r,g,b,a)
    if not a then a = 255 end
    lv1lua.current.color = Color.new(r,g,b,a)
end

function love.graphics.setBackgroundColor(r,g,b)
    lv1lua.current.bgcolor = Color.new(r,g,b,255)
end

function love.graphics.rectangle(mode, x, y, w, h)
    --scale 1280x720 to 960x540
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        x = x * 0.75; y = y * 0.75; w = w * 0.75; h = h * 0.75
    end
    
    if mode == "fill" then
        Graphics.fillRect(x, x+w, y, y+h, lv1lua.current.color)
    elseif mode == "line" then
        Graphics.fillEmptyRect(x, x+w, y, y+h, lv1lua.current.color)
    end
end

function love.graphics.line(x1,y1,x2,y2)
    Graphics.drawLine(x1,y1,x2,y2,lv1lua.current.color)
end

function love.graphics.circle(x,y,radius)
    Graphics.fillCircle(x,y,radius,lv1lua.current.color)
end
