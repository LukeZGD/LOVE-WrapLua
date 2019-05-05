function love.event.quit(re)
	if love.quit then
		love.quit()
	end
	
	if re == "restart" then
		System.launchApp(System.getTitleID())
	else
		System.exit()
	end
end