local defaultfont
local scale = 0.75
local fontscale = 0.75
local defaultMinificationFilter = 3
local defaultMagnificationFilter = 3
local anisotropy = 1

local Transform =
{
	_scaleX = 1,
	_scaleY = 1,
	_offsetX = 0,
	_offsetY = 0,
	_usingScissor = false,
	_scissorX = 0,
	_scissorY = 0,
	_scissorWidth = 0,
	_scissorHeight = 0,
	new = function(self)
		local obj = {}
		setmetatable(obj, self)
		return obj
	end
}

local _transformStack = {}

--default print font
if not lv1lua.isPSP then
	defaultfont = {font=font.load(lv1lua.dataloc.."LOVE-WrapLua/Vera.ttf"),size=12}
	font.setdefault(defaultfont.font)
else
	defaultfont = {font=font.load("oneFont.pgf"),size=15}
	font.setdefault(defaultfont.font)
	scale = 0.375
	fontscale = 0.6
end

--set up stuff
lv1lua.current = {font=defaultfont,color=color.new(255,255,255,255)}

function love.graphics.newImage(filename)
	img = image.load(lv1lua.dataloc.."game/"..filename)

	if lv1luaconf.imgscale == true then
		image.scale(img,scale*100)
	end
	
	return img
end

function love.graphics.translate(offsetX, offsetY)
	_transformStack[#_transformStack]._offsetX = offsetX
	_transformStack[#_transformStack]._offsetY = offsetY
end

function love.graphics.scale(scaleX, scaleY)
	_transformStack[#_transformStack]._scaleX = scaleX
	_transformStack[#_transformStack]._scaleY = scaleY
end

function love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)
	_transformStack[#_transformStack].usingScissor = (scissorX ~= nil)
	_transformStack[#_transformStack]._scissorX = scissorX
	_transformStack[#_transformStack]._scissorY = scissorY
	_transformStack[#_transformStack]._scissorWidth = scissorWidth
	_transformStack[#_transformStack]._scissorHeight = scissorHeight
end

function love.graphics.push()
	_transformStack[#_transformStack + 1] = Transform:new()
end
function love.graphics.pop()
	_transformStack[#_transformStack] = nil
end


function love.graphics.setDefaultFilter(min, mag, anisotropy)
	--Point/Nearest
	--Apoint (Not supported from love)
	--Linear
	--Alinear (Not supported from love)
	if(min == "linear") then
		min = __IMG_FILTER_LINEAR
	elseif(min == "nearest" or min == "point") then
		min = __IMG_FILTER_POINT
	end
	if(mag == "linear") then
		mag = __IMG_FILTER_LINEAR
	elseif(mag == "nearest" or mag == "point") then
		mag = __IMG_FILTER_POINT
	end
	defaultMinificationFilter = min
	defaultMagnificationFilter = mag
	anisotropy = (anisotropy == nil) and 1 or anisotropy
end
function love.graphics.getDefaultFilter()
	return defaultMinificationFilter, defaultMagnificationFilter, anisotropy
end


function love.graphics.draw(drawable,x,y,r,sx,sy)
	if not x then x = 0 end
	if not y then y = 0 end
	if sx and not sy then sy = sx end
	
	--scale 1280x720 to 960x540(vita) or 480x270(psp)
	if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
		x = x * scale; y = y * scale
	end
	
	if r then
		image.rotate(drawable,(r/math.pi)*180) --radians to degrees
	end
	
	if sx then
		if(sx > 1) then
			image.setfilter(drawable, defaultMagnificationFilter)
		else
			image.setfilter(drawable, defaultMinificationFilter)
		end
		image.resize(drawable,image.getrealw(drawable)*sx,image.getrealh(drawable)*sy)
	end
	
	if drawable then
		image.blittint(drawable,x,y, lv1lua.current.color)
	end
end

function love.graphics.newFont(setfont, setsize)	
	if tonumber(setfont) then
		setsize = setfont
	elseif not setsize then
		setsize = 12
	end
	
	if tonumber(setfont) or lv1lua.isPSP then
		setfont = defaultfont.font
	elseif setfont then
		setfont = font.load(lv1lua.dataloc.."game/"..setfont)
	end
		
	local table = {
		font = setfont;
		size = setsize;
	}
	return table
end

function love.graphics.setFont(setfont,setsize)
	if not lv1lua.isPSP and setfont then
		lv1lua.current.font = setfont
	else
		lv1lua.current.font = defaultfont
	end
	
	if setsize then
		lv1lua.current.font.size = setsize
	end
end

function love.graphics.print(text,x,y)
	local fontsize = lv1lua.current.font.size/18.5
	if not x then x = 0 end
	if not y then y = 0 end
	
	--scale 1280x720 to 960x540(vita) or 480x270(psp)
	if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
		x = x * scale; y = y * scale
		fontsize = fontsize*fontscale
	end
	
	if text then
		screen.print(lv1lua.current.font.font,x,y,text,fontsize,lv1lua.current.color)
	end
end

function ___getAlignX(x, align, size, wrapSize)
	if(align == "center") then
		return x - size / 2 + wrapSize / 2
	elseif(align == "right") then
		return x + wrapSize - size
	else
		return x
	end
end

function love.graphics.printf(text, x, y, wrapWidth, align)
	--Accepteds alignments
	--Left, Right and Center
	local fontsize = lv1lua.current.font.size/18.5

	if text then

		local lineJumpOn = wrapWidth / lv1lua.current.font.size
		local tempPhraseSize = 0
		local wordSize = 0
		local phrase = ""
		for word in string.gmatch(text, "%a+") do
			wordSize = string.len(word)
			if(wordSize + tempPhraseSize >= lineJumpOn) then
				love.graphics.print(phrase, ___getAlignX(x, align, tempPhraseSize, wrapWidth), y)
				y = y + screen.textheight(lv1lua.current.font.font, fontsize) --Jump line
				phrase = word
				tempPhraseSize = wordSize
			else
				tempPhraseSize = tempPhraseSize + wordSize
				phrase = phrase .. word
			end
		end
		if(phrase ~= "") then
			love.graphics.print(phrase, ___getAlignX(x, align, tempPhraseSize, wrapWidth), y)
		end

		
	end

end

function love.graphics.setColor(r,g,b,a)
	if not a then a = 255 end
	lv1lua.current.color = color.new(r,g,b,a)
end

function love.graphics.setBackgroundColor(r,g,b)
	screen.clear(color.new(r,g,b))
end

function love.graphics.rectangle(mode, x, y, w, h)
	--scale 1280x720 to 960x540(vita) or 480x270(psp)
	if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
		x = x * scale; y = y * scale; w = w * scale; h = h * scale
	end
	
	if mode == "fill" then
		draw.fillrect(x, y, w, h, lv1lua.current.color)
	elseif mode == "line" then
		draw.rect(x, y, w, h, lv1lua.current.color)
	end
end

function love.graphics.line(x1,y1,x2,y2)
	draw.line(x1,y1,x2,y2,lv1lua.current.color)
end

function love.graphics.circle(x,y,radius)
	draw.circle(x,y,radius,lv1lua.current.color,30)
end
