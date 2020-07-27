function love.event.quit(re)
    if love.quit then
        love.quit()
    end
    
    if re == "restart" then
        System.launchEboot("app0:/eboot.bin")
    else
        lv1lua.running = false
        System.exit()
    end
end
