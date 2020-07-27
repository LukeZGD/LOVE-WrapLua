function love.event.quit(re)
    if love.quit then
        love.quit()
    end
    EndGFX()
    snd.Finalize()
    lv1lua.running = false
end
