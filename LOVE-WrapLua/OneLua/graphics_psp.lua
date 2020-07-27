-- old graphics.lua for psp compat
local defaultfont
local scale = 0.375
local fontscale = 0.6

--default print font
defaultfont = {font=font.load("oneFont.pgf"),size=15}
font.setdefault(defaultfont.font)

--set up stuff
lv1lua.current = {font=defaultfont,color=color.new(255,255,255,255)}

function love.graphics.newImage(filename)
    img = image.load(lv1lua.dataloc.."game/"..filename)
    
    if lv1luaconf.imgscale == true then
        image.scale(img,scale*100)
    end
    
    return img
end

function love.graphics.draw(drawable,x,y,r,sx,sy)
    if not x then x = 0 end
    if not y then y = 0 end
    if sx and not sy then sy = sx end
    
    --scale 1280x720 to 480x270(psp)
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        x = x * scale; y = y * scale
    end
    
    if r then
        image.rotate(drawable,(r/math.pi)*180) --radians to degrees
    end
    
    if sx then
        image.resize(drawable,image.getrealw(drawable)*sx,image.getrealh(drawable)*sy)
    end
    
    if drawable then
        image.blit(drawable,x,y,color.a(lv1lua.current.color))
    end
end

function love.graphics.newFont(setfont, setsize)
    if tonumber(setfont) then
        setsize = setfont
    elseif not setsize then
        setsize = 12
    end
    
    if tonumber(setfont) or lv1lua.isPSP then
        setfont = defaultfont.font
    elseif setfont then
        setfont = font.load(lv1lua.dataloc.."game/"..setfont)
    end
        
    local table = {
        font = setfont;
        size = setsize;
    }
    return table
end

function love.graphics.setFont(setfont,setsize)
    if not lv1lua.isPSP and setfont then
        lv1lua.current.font = setfont
    else
        lv1lua.current.font = defaultfont
    end
    
    if setsize then
        lv1lua.current.font.size = setsize
    end
end

function love.graphics.print(text,x,y)
    local fontsize = lv1lua.current.font.size/18.5
    if not x then x = 0 end
    if not y then y = 0 end
    
    --scale 1280x720 to 480x270(psp)
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        x = x * scale; y = y * scale
        fontsize = fontsize*fontscale
    end
    
    if text then
        screen.print(lv1lua.current.font.font,x,y,text,fontsize,lv1lua.current.color)
    end
end

function love.graphics.setColor(r,g,b,a)
    if not a then a = 255 end
    lv1lua.current.color = color.new(r,g,b,a)
end

function love.graphics.setBackgroundColor(r,g,b)
    screen.clear(color.new(r,g,b))
end

function love.graphics.rectangle(mode, x, y, w, h)
    --scale 1280x720 to 480x270(psp)
    if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
        x = x * scale; y = y * scale; w = w * scale; h = h * scale
    end
    
    if mode == "fill" then
        draw.fillrect(x, y, w, h, lv1lua.current.color)
    elseif mode == "line" then
        draw.rect(x, y, w, h, lv1lua.current.color)
    end
end

function love.graphics.line(x1,y1,x2,y2)
    draw.line(x1,y1,x2,y2,lv1lua.current.color)
end

function love.graphics.circle(x,y,radius)
    draw.circle(x,y,radius,lv1lua.current.color,30)
end
