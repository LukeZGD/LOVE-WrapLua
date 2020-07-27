function love.event.quit(re)
    if love.quit then
        love.quit()
    end
    
    if re == "restart" then
        os.restart()
    else
        lv1lua.running = false
        os.exit()
    end
end
