local sectimer = 0
local pos = 0
local lg = love.graphics

local lgsetColor = lg.setColor
function lg.setColor(...)
    local args = {...}
    local ver = love.getVersion()
    if ver >= 11 then
        for i = 1, #args do
            if args[i] > 0 then
                args[i] = args[i] / 255
            end
        end
    end
    lgsetColor(args[1],args[2],args[3],args[4])
end

function love.load()
    image = lg.newImage("image.png")
    local def = lg.setNewFont(24)
end

function love.draw()
    lg.draw(image, pos, pos)
    lg.setColor(128,128,128,128)
    lg.rectangle("fill",40,40,130,35)
    lg.setColor(255,255,255,255)
    if sectimer <= 1 then
        lg.print("No game!",44,42)
    end
end

function love.update(dt)
    sectimer = sectimer + dt
    if sectimer >= 2 then sectimer = 0 end
    
    pos = pos - 0.625
    if pos <= -200 then
        pos = -50
    end
end
