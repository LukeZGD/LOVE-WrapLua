local sec = 0

function love.load()
	if love.system.getOS() == "PSP" then
		imagee = love.graphics.newImage("imagePSP.png")
	else
		imagee = love.graphics.newImage("image.png")
	end
	audioe = love.audio.newSource("audio.mp3")
	audioe:setLooping(true)
	audioe:play()
end

function love.draw()
	love.graphics.draw(imagee)
	love.graphics.print("Hello World")
	love.graphics.print(sec,0,30)
end

function love.update(dt)
	sec = sec + dt
end
