local mask = {"up", "down", "left", "right", "cross", "circle", "square", "triangle", "r", "l", "start", "select", "home", "volup", "voldown"}
local homeHeldtime = 0
local homeCallbackThreshold = 0.04 --Next to 3 frames
local homeCallbackCancel = 1
local homeTime = 545

dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/callbacks.lua")

--Live area will be handled manually


function lv1lua.draw()
    if love.draw then love.draw() end
    screen.flip()
end

function lv1lua.update()
    if lv1lua.timer:time() >= 16 then
        dt = lv1lua.timer:time() / 1000
        if love.update then
            love.update(dt)
        end
        lv1lua.timer:reset()
        lv1lua.timer:start()
    end
end

function lv1lua.updatecontrols()
    -- buttons.homepopup(0)
    buttons.read()
    for i=1,#mask do
        if buttons[mask[i]] and mask[i] == "circle" then
            love.keypressed(lv1lua.keyset[1])
        elseif buttons[mask[i]] and mask[i] == "cross" then
            love.keypressed(lv1lua.keyset[2])
        elseif buttons[mask[i]] and mask[i] == "triangle" then
            love.keypressed(lv1lua.keyset[3])
        elseif buttons[mask[i]] and mask[i] == "square" then
            love.keypressed(lv1lua.keyset[4])
        elseif buttons[mask[i]] and mask[i] == "l" then
            love.keypressed(lv1lua.keyset[5])
        elseif buttons[mask[i]] and mask[i] == "r" then
            love.keypressed(lv1lua.keyset[6])
        elseif buttons[mask[i]] and mask[i] == "select" then
            love.keypressed("back")
        elseif buttons[mask[i]] then
            love.keypressed(mask[i])
        end
        if buttons.released[mask[i]] and mask[i] == "circle" then
            love.keyreleased(lv1lua.keyset[1])
        elseif buttons.released[mask[i]] and mask[i] == "cross" then
            love.keyreleased(lv1lua.keyset[2])
        elseif buttons.released[mask[i]] and mask[i] == "triangle" then
            love.keyreleased(lv1lua.keyset[3])
        elseif buttons.released[mask[i]] and mask[i] == "square" then
            love.keyreleased(lv1lua.keyset[4])
        elseif buttons.released[mask[i]] and mask[i] == "l" then
            love.keyreleased(lv1lua.keyset[5])
        elseif buttons.released[mask[i]] and mask[i] == "r" then
            love.keyreleased(lv1lua.keyset[6])
        elseif buttons.released[mask[i]] and mask[i] == "select" then
            love.keyreleased("back")
        elseif buttons.released[mask[i]] then
            love.keyreleased(mask[i])
        end
    end
    __checkGameRestart()
    if not lv1lua.isPSP then
        ___updateFrontTouch()
        -- __checkHomePress()
    end
end

function __checkGameRestart()
    if buttons.start and buttons.held.l and buttons.held.r and buttons.held.down
    then
        print("RESTART")
        os.restart()
    end
end

--WIP
function __checkHomePress()
    --When all analogs are 0 and not flicking, it means that home is pressed
    if(buttons.analoglx == 0 and buttons.analogly == 0 and buttons.analogrx == 0 and buttons.analogry == 0) then
        homeHeldtime = homeHeldtime + dt
    else
        if(homeHeldtime>= homeCallbackThreshold and homeHeldtime < homeCallbackCancel) then
            __goLiveArea()
        end
        __resume()
    end
end

function __goLiveArea()
    print("Live Area")
    onLiveArea()
    os.golivearea()
    os.delay(homeTime)
end

function __resume()
    if(homeHeldtime>= homeCallbackThreshold and homeHeldtime < homeCallbackCancel) then
        while(buttons.waitforkey(__HOME)) do
            os.delay(1)
        end
        print("Resume")
        homeHeldtime = 0
        onResume()
    end
end

function ___updateFrontTouch()
    local lastMouseDown = love.mouse.isDown()
    touch.read()
    love.touch.__getFrontTouches(touch)
    love.mouse.__updateMouse()

    local newMouseDown = love.mouse.isDown()
    if(not lastMouseDown and newMouseDown) then
        love.mousepressed(love.mouse.getX(), love.mouse.getY(), 1)
    end
end
