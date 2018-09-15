local sec = 0

function love.load()
	imagee = love.graphics.newImage("image.png")
	audioe = love.audio.newSource("audio.ogg")
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
