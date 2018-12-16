--some info
lv1lua = {}
lv1lua.isPSP = os.cfw
lv1lua.dataloc = ""
love = {}
love.graphics = {}
love.timer = {}
love.audio = {}
love.event = {}
love.math = {}
love.system = {}
love.filesystem = {}
love.keyboard = {}

-- lv1lua conf, custom configs should go to lv1lua.lua
lv1luaconf = {
	keyconfset = "PS",
	img_scale = false,
	res_scale = false
}

-- love conf, custom configs go to game/conf.lua
t = {
	window = {},
	modules = {}
}
loveconfi = {
    identity = "LOVE-OneLua"
}

-- open conf files
if files.exists("lv1lua.lua") then
	dofile("lv1lua.lua")
end

if files.exists("game/conf.lua") then
	dofile("game/conf.lua")
	love.conf(t)
	loveconfi = t
end
t = nil

-- set key config
if lv1luaconf.keyconfset == "PS" then
	-- Sony Key Config (this should be self-explanatory hahaha)
	lv1lua.keyconf = {"circle","cross","triangle","square","l","r"}
	
elseif lv1luaconf.keyconfset == "NT" then
	--[[
	Nintendo Key Config
	a = circle
	b = cross
	x = triangle
	y = square
	lbutton = l trigger
	rbutton = r trigger
	]]
	lv1lua.keyconf = {"a","b","x","y","lbutton","rbutton"}
	
elseif lv1luaconf.keyconfset == "XB" then
	--[[
	Xbox Controller Key Config
	b = circle
	a = cross
	y = triangle
	x = square
	lbutton = l trigger
	rbutton = r trigger
	]]
	lv1lua.keyconf = {"b","a","y","x","lbutton","rbutton"}
	
end

--modules and stuff
dofile(lv1lua.dataloc.."LOVE-OneLua/graphics.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/timer.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/audio.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/event.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/math.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/system.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/filesystem.lua")
dofile(lv1lua.dataloc.."LOVE-OneLua/keyboard.lua")

--return LOVE 0.10.2
function love.getVersion()
	return 0, 10, 2
end

--require replacement?
function require(param)
	if string.sub(param, -4) == ".lua" then
		param = lv1lua.dataloc.."game/"..param
	else
		param = lv1lua.dataloc.."game/"..param..".lua"
	end
	dofile(param)
end

--START!
love.math.setRandomSeed(os.time())
dofile(lv1lua.dataloc.."game/main.lua")
if love.load then
	love.load()
end

--gamepadpressed or keypressed stuff
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
	if love.draw then
		love.draw()
	end
	screen.flip()
	
	--Update
	if tmr:time() >= 16 then
		dt = tmr:time() / 1000
		if love.update then
			love.update(dt)
		end
		tmr:reset(); tmr:start()
	end
	
	--Controls
	buttons.read()
	for i=1,#mask do
		if buttons[mask[i]] and mask[i] == "circle" then
			love.keypressed(lv1lua.keyconf[1])
		elseif buttons[mask[i]] and mask[i] == "cross" then
			love.keypressed(lv1lua.keyconf[2])
		elseif buttons[mask[i]] and mask[i] == "triangle" then
			love.keypressed(lv1lua.keyconf[3])
		elseif buttons[mask[i]] and mask[i] == "square" then
			love.keypressed(lv1lua.keyconf[4])
		elseif buttons[mask[i]] and mask[i] == "l" then
			love.keypressed(lv1lua.keyconf[5])
		elseif buttons[mask[i]] and mask[i] == "r" then
			love.keypressed(lv1lua.keyconf[6])
		elseif buttons[mask[i]] then
			love.keypressed(mask[i])
		end
		if buttons.released[mask[i]] and mask[i] == "circle" then
			love.keyreleased(lv1lua.keyconf[1])
		elseif buttons.released[mask[i]] and mask[i] == "cross" then
			love.keyreleased(lv1lua.keyconf[2])
		elseif buttons.released[mask[i]] and mask[i] == "triangle" then
			love.keyreleased(lv1lua.keyconf[3])
		elseif buttons.released[mask[i]] and mask[i] == "square" then
			love.keyreleased(lv1lua.keyconf[4])
		elseif buttons.released[mask[i]] and mask[i] == "l" then
			love.keyreleased(lv1lua.keyconf[5])
		elseif buttons.released[mask[i]] and mask[i] == "r" then
			love.keyreleased(lv1lua.keyconf[6])
		elseif buttons.released[mask[i]] then
			love.keyreleased(mask[i])
		end
	end
end