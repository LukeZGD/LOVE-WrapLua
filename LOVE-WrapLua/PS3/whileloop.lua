loadstring = load
dt = 0.0167
sys.UtilRegisterCallback()

function lv1lua.draw()
    StartGFX()
    if love.draw then love.draw() end
    FlipGFX()
end

function lv1lua.update() --this isn't really dt stuff, but ok heh
    if love.update then love.update(dt) end
    
    --Check ingame XMB
    local ret = sys.UtilCheckCallback(g_status)
    if ret == sys.SYSUTIL_EXIT_GAME then
        love.event.quit() --quit game over ingame XMB
    end
    
    --Play audio
    lv1lua.playsound()
end

function lv1lua.updatecontrols()
    --pressed
    if pad.circle(0) > 0 and lv1lua.key.circle == 0 then
        love.keypressed(lv1lua.keyset[1])
        lv1lua.key.circle = 1
    elseif pad.cross(0) > 0 and lv1lua.key.cross == 0 then
        love.keypressed(lv1lua.keyset[2])
        lv1lua.key.cross = 1
    elseif pad.triangle(0) > 0 and lv1lua.key.triangle == 0 then
        love.keypressed(lv1lua.keyset[3])
        lv1lua.key.triangle = 1
    elseif pad.square(0) > 0 and lv1lua.key.square == 0 then
        love.keypressed(lv1lua.keyset[4])
        lv1lua.key.square = 1
    elseif pad.L1(0) > 0 and lv1lua.key.l == 0 then
        love.keypressed(lv1lua.keyset[5])
        lv1lua.key.l = 1
    elseif pad.R1(0) > 0 and lv1lua.key.r == 0 then
        love.keypressed(lv1lua.keyset[6])
        lv1lua.key.r = 1
    elseif pad.up(0) > 0 and lv1lua.key.up == 0 then
        love.keypressed("up")
        lv1lua.key.up = 1
    elseif pad.down(0) > 0 and lv1lua.key.down == 0 then
        love.keypressed("down")
        lv1lua.key.down = 1
    elseif pad.left(0) > 0 and lv1lua.key.left == 0 then
        love.keypressed("left")
        lv1lua.key.left = 1
    elseif pad.right(0) > 0 and lv1lua.key.right == 0 then
        love.keypressed("right")
        lv1lua.key.right = 1
    elseif pad.select(0) > 0 and lv1lua.key.select == 0 then
        love.keypressed("back")
        lv1lua.key.select = 1
    elseif pad.start(0) > 0 and lv1lua.key.start == 0 then
        love.keypressed("start")
        lv1lua.key.start = 1
    end
    
    --released
    if pad.circle(0) == 0 and lv1lua.key.circle == 1 then
        love.keyreleased(lv1lua.keyset[1])
        lv1lua.key.circle = 0
    elseif pad.cross(0) == 0 and lv1lua.key.cross == 1 then
        love.keyreleased(lv1lua.keyset[2])
        lv1lua.key.cross = 0
    elseif pad.triangle(0) == 0 and lv1lua.key.triangle == 1 then
        love.keyreleased(lv1lua.keyset[3])
        lv1lua.key.triangle = 0
    elseif pad.square(0) == 0 and lv1lua.key.square == 1 then
        love.keyreleased(lv1lua.keyset[4])
        lv1lua.key.square = 0
    elseif pad.L1(0) == 0 and lv1lua.key.l == 1 then
        love.keyreleased(lv1lua.keyset[5])
        lv1lua.key.l = 0
    elseif pad.R1(0) == 0 and lv1lua.key.r == 1 then
        love.keyreleased(lv1lua.keyset[6])
        lv1lua.key.r = 0
    elseif pad.up(0) == 0 and lv1lua.key.up == 1 then
        love.keyreleased("up")
        lv1lua.key.up = 0
    elseif pad.down(0) == 0 and lv1lua.key.down == 1 then
        love.keyreleased("down")
        lv1lua.key.down = 0
    elseif pad.left(0) == 0 and lv1lua.key.left == 1 then
        love.keyreleased("left")
        lv1lua.key.left = 0
    elseif pad.right(0) == 0 and lv1lua.key.right == 1 then
        love.keyreleased("right")
        lv1lua.key.right = 0
    elseif pad.select(0) == 0 and lv1lua.key.select == 1 then
        love.keyreleased("back")
        lv1lua.key.select = 0
    elseif pad.start(0) == 0 and lv1lua.key.start == 1 then
        love.keyreleased("start")
        lv1lua.key.start = 0
    end
    
    --force quit
    if pad.L3(0) > 0 and pad.R3(0) > 0 then
        love.event.quit()
    end
end
