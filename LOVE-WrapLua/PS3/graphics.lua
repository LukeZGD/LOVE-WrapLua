InitGFX(720,480)
InitFont("/dev_flash/data/font/SCE-PS3-RD-R-LATIN.TTF", 12)
defaultfont = nil

--set up stuff
lv1lua.current = {font=defaultfont,color=nil}

function love.graphics.newImage(filename)
    local img = surface()
    img:LoadIMG(lv1lua.dataloc.."game/"..filename)
    return img
end

function love.graphics.draw(drawable,x,y,r,sx,sy)
    if not x then x = 0 end
    if not y then y = 0 end
    if not r then r = 0 end
    if not sx then sx = 1 end
    if not sy then sy = 1 end
    if sx and not sy then sy = sx end
    
    --scale 1280x720 to 720x480
    x = x * 0.5625; y = y * 0.5625
    y = y + 37
    
    if not lv1lua.isPSP and lv1luaconf.imgscale == true then
        sx = sx * 0.5625
        sy = sy * 0.5625
    end
    
    if drawable then
        drawable:setRectPos(x,y)
        BlitToScreen(drawable)
    end
end

function love.graphics.newFont(setfont, setsize)
    if tonumber(setfont) then
        setsize = setfont
    elseif not setsize then
        setsize = 12
    end
    
    if tonumber(setfont) or lv1lua.isPSP then
        setfont = defaultfont
    elseif setfont then
        --setfont = Font.load(lv1lua.dataloc.."game/"..setfont)
        setfont = nil
    end
    
    --scale 1280x720 to 960x540(vita) or 480x270(psp)
    if not lv1lua.isPSP and (lv1luaconf.imgscale == true or lv1luaconf.resscale == true) then
        setsize = setsize*0.75
    elseif lv1lua.isPSP and lv1luaconf.resscale == true then
        setsize = setsize*0.6
    end
    --Font.setPixelSizes(setfont,setsize)
    
    return setfont
end

function love.graphics.setFont(setfont,setsize)
    if setsize then
        --Font.setPixelSizes(setfont,setsize)
    end
    --lv1lua.current.font = setfont
end

function love.graphics.setNewFont(setfont,setsize)
    newfont = love.graphics.newFont(setfont, setsize)
    love.graphics.setFont(newfont, setsize)
    return newfont
end

function love.graphics.print(text,x,y)
    if not x then x = 0 end
    if not y then y = 0 end
    
    --scale 1280x720 to 720x480
    x = x * 0.5625; y = y * 0.5625
    y = y + 37
    
    if text then
        DrawText(x,y,text)
    end
end

function love.graphics.setColor(r,g,b,a)
    if not a then a = 255 end
    --lv1lua.current.color = Color.new(r,g,b,a)
end

function love.graphics.setBackgroundColor(r,g,b)
    --Screen.clear(Color.new(r,g,b))
end

function love.graphics.rectangle(mode, x, y, w, h)
    --scale 1280x720 to 720x480
    x = x * 0.5625; y = y * 0.5625; w = w * 0.5625; h = h * 0.5625
    
    if mode == "fill" then
        --Graphics.fillRect(x, x+w, y, y+h, lv1lua.current.color)
    elseif mode == "line" then
        --Graphics.fillEmptyRect(x, x+w, y, y+h, lv1lua.current.color)
    end
end

function love.graphics.line(x1,y1,x2,y2)
    --Graphics.drawLine(x1,y1,x2,y2,lv1lua.current.color)
end

function love.graphics.circle(x,y,radius)
    --Graphics.fillCircle(x,y,radius,lv1lua.current.color)
end
