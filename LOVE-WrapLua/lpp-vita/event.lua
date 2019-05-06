function love.event.quit(re)
	if love.quit then
		love.quit()
	end
	
	if re == "restart" then
		System.launchApp(System.getTitleID())
	else
		lv1lua.running = false
		System.exit()
	end
end