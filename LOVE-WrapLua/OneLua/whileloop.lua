local mask = {"up", "down", "left", "right", "cross", "circle", "square", "triangle", "r", "l", "start", "select", "home", "volup", "voldown"}
local homeHeldtime = 0
local homeCallbackThreshold = 0.04 --Next to 3 frames
local homeCallbackCancel = 1

dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/callbacks.lua")

buttons.homepopup(0) -- Block out to livearea.
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
		elseif buttons[mask[i]] and mask[i] == "home" then
			__resume()
		elseif buttons.released[mask[i]] then
			love.keyreleased(mask[i])
		end
	end
	__checkGameRestart()
	___updateFrontTouch()
	__checkHomePress()
end

function __checkGameRestart()
	if buttons.r and buttons.held.up and buttons.held.left and buttons.held.triangle and buttons.held.square and buttons.held.l
	then
		print("RESTART")
		os.restart()
	end
end

function __checkHomePress()
	--When all analogs are 0 and not flicking, it means that home is pressed
	if(buttons.analoglx == 0 and buttons.analogly == 0 and buttons.analogrx == 0 and buttons.analogry == 0) then
		homeHeldtime = homeHeldtime + dt
	else
		if(homeHeldtime>= homeCallbackThreshold and homeHeldtime < homeCallbackCancel) then
			__goLiveArea()
		end
		homeHeldtime = 0
	end
end

function __goLiveArea()
	-- buttons.homepopup(1)
	print("Live Area")
	onLiveArea()
	os.golivearea()
end

function __resume()
	-- buttons.homepopup(0)
	if(homeHeldtime>= homeCallbackThreshold and homeHeldtime < homeCallbackCancel) then
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