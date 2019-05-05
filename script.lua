--set up lv1lua
lv1lua = {}
lv1lua.isPSP = os.cfw

if lv1lua_mode then
	lv1lua.mode = lv1lua_mode
	lv1lua_mode = nil
end

if not lv1lua.mode then
	lv1lua.dataloc = ""
	lv1lua.mode = "OneLua"
else
	lv1lua.dataloc = lv1lua_dataloc
	lv1lua_dataloc = nil
end

--set up love
love = {}
love.graphics = {}
love.timer = {}
love.audio = {}
love.event = {}
love.math = {}
love.system = {}
love.filesystem = {}
love.keyboard = {}

--lv1lua conf, custom configs should go to lv1lua.lua
lv1luaconf = {
	keyconfset = "SE",
	img_scale = false,
	res_scale = false
}

--love conf, custom configs go to game/conf.lua
t = {
	window = {},
	modules = {}
}
loveconfi = t

--check conf files
function lv1lua.exists(file)
	local f = io.open(file, "r")
	if f ~= nil then io.close(f) return true else return false end
end

lv1lua.confexists = lvl1ua.exists(lv1lua.dataloc.."lv1lua.lua")
lv1lua.loveconfexists = lvl1ua.exists(lv1lua.dataloc.."game/conf.lua")

--open conf files
if lv1lua.confexists then
	dofile(lv1lua.dataloc.."lv1lua.lua")
end

if lv1lua.loveconfexists then
	dofile(lv1lua.dataloc.."game/conf.lua")
	love.conf(t)
	loveconfi = t
	if not loveconfi.identity then
		loveconfi.identity = "LOVE-WrapLua"
	end
end

t = nil

--set key config
if lv1luaconf.keyconfset == "SE" then
	local confirm = false
	
	if lv1lua.mode == "lpp-vita" then
		if Controls.getEnterButton() == SCE_CTRL_CIRCLE then confirm = true end
	elseif lv1lua.mode = "OneLua" then
		if buttons.assign() == 0 then confirm = true end
	end
	
	if confirm then
		lv1luaconf.keyconfset = "NT"
	else
		lv1luaconf.keyconfset = "XB"
	end
end

if lv1luaconf.keyconfset == "PS" then
	lv1lua.keyconf = {"circle","cross","triangle","square","l","r"}
elseif lv1luaconf.keyconfset == "NT" then
	lv1lua.keyconf = {"a","b","x","y","lbutton","rbutton"}	
elseif lv1luaconf.keyconfset == "XB" then
	lv1lua.keyconf = {"b","a","y","x","lbutton","rbutton"}	
end

--modules and stuff
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/whileloop.lua")

dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/graphics.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/timer.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/audio.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/event.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/filesystem.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/"..lv1lua.mode.."/keyboard.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/math.lua")
dofile(lv1lua.dataloc.."LOVE-WrapLua/system.lua")

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
	lv1lua.draw()
	
	--Update
	lv1lua.update()
	
	--Controls
	lv1lua.updatecontrols()
end