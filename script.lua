--some info
appmode = "TEST"
appname = "testrun"
dataloc = ""

if appmode == "TEST" then
	dataloc = "ux0:/data/"..appname.."/"
end	

love = {}
love.graphics = {}
love.timer = {}
love.audio = {}
love.event = {}
love.math = {}
love.system = {}
love.filesystem = {}

--modules and stuff
dofile(dataloc.."LOVE-OneLua/graphics.lua")
dofile(dataloc.."LOVE-OneLua/timer.lua")
dofile(dataloc.."LOVE-OneLua/audio.lua")
dofile(dataloc.."LOVE-OneLua/event.lua")
dofile(dataloc.."LOVE-OneLua/math.lua")
dofile(dataloc.."LOVE-OneLua/system.lua")
dofile(dataloc.."LOVE-OneLua/filesystem.lua")

function love.getVersion()
	return 0, 10, 2
end

--require replacement?
function require(param)
	if string.sub(param, -4) == ".lua" then
		param = dataloc.."game/"..param
	else
		--param = string.gsub(param, "/.", "//")
		param = dataloc.."game/"..param..".lua"
	end
	dofile(param)
end

--START!
dofile(dataloc.."game/main.lua")
love.load()

--gamepadpressed or keypressed stuff
local joy = nil
local mask = {"up", "down", "left", "right", "cross", "circle", "square", "triangle", "r", "l", "start", "select"}
if not love.keypressed and love.gamepadpressed then
	function love.keypressed(key)
		love.gamepadpressed(joy,button)
	end
elseif not love.keypressed then
	love.keypressed = function() end
end
if not love.keyreleased and love.gamepadreleased then
	function love.keyreleased(key)
		love.gamepadreleased(joy,button)
	end
elseif not love.keyreleased then
	love.keyreleased = function() end
end

--Main loop
while true do
	--Draw
	love.draw()
	screen.flip()
	
	--Update
	if tmr:time() >= 16 then
		dt = tmr:time() / 1000
		love.update(dt)
		tmr:reset(); tmr:start()
	end
	
	--Controls
	buttons.read()
	for i=1,#mask do
		if buttons[mask[i]] and mask[i] == "circle" then
			love.keypressed("a")
		elseif buttons[mask[i]] and mask[i] == "cross" then
			love.keypressed("b")
		elseif buttons[mask[i]] and mask[i] == "triangle" then
			love.keypressed("x")
		elseif buttons[mask[i]] and mask[i] == "square" then
			love.keypressed("y")
		elseif buttons[mask[i]] then
			love.keypressed(mask[i])
		end
		if buttons.released[mask[i]] and mask[i] == "circle" then
			love.keyreleased("a")
		elseif buttons.released[mask[i]] and mask[i] == "cross" then
			love.keyreleased("b")
		elseif buttons.released[mask[i]] and mask[i] == "triangle" then
			love.keyreleased("x")
		elseif buttons.released[mask[i]] and mask[i] == "square" then
			love.keyreleased("y")
		elseif buttons.released[mask[i]] then
			love.keyreleased(mask[i])
		end
	end
end