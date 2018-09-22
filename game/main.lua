local sec = 0
local textdisp = ""

function love.load()
	if love.system.getOS() == "PSP" then
		imagee = love.graphics.newImage("imagePSP.png")
	else
		imagee = love.graphics.newImage("image.png")
	end
	audioe = love.audio.newSource("audio.mp3","stream")
	audioe:setLooping(true)
	audioe:play()
	love.keyboard.setTextInput(true)
end

function love.draw()
	love.graphics.draw(imagee)
	love.graphics.print("Hello World")
	love.graphics.print(sec,0,30)
	love.graphics.print("Text Input: "..textdisp,0,60)
end

function love.update(dt)
	sec = sec + dt
end

function love.textinput(text)
	textdisp = text
end