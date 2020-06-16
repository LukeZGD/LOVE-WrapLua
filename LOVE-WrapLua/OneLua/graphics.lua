local defaultfont
local scale = 0.75
local fontscale = 0.75
local defaultMinificationFilter = 3
local defaultMagnificationFilter = 3
local anisotropy = 0

local Transform =
{
	new = function(self)
		local obj = {}
		setmetatable(obj, self)
		obj._scaleX = 1
		obj._scaleY = 1
		obj._offsetX = 0
		obj._offsetY = 0
		obj._usingScissor = false
		obj._scissorX = 0
		obj._scissorY = 0
		obj._scissorWidth = 0
		obj._scissorHeight = 0
		return obj
	end
}

local _transformStack = 
{
	transform = Transform:new(),
	stack = {},
	_dirty = true,
	updateTransform = 
	function (self)
		if(not self._dirty) then
			return
		end
		local x = 0
		local y = 0
		local scaleX = 1
		local scaleY = 1
		local usingScissor = false
		local scissorX = 0
		local scissorY = 0
		local scissorWidth = 0
		local scissorHeight = 0

		local transforms = self.stack
		for i = 1, #transforms do
			x = x * transforms[i]._scaleX + transforms[i]._offsetX
			y = y * transforms[i]._scaleY + transforms[i]._offsetY
			scaleX = scaleX * transforms[i]._scaleX
			scaleY = scaleY * transforms[i]._scaleY
			if transforms[i].usingScissor then usingScissor = true end
			if(usingScissor) then
				scissorX = transforms[i]._scissorX
				scissorY = transforms[i]._scissorY
				scissorWidth = transforms[i]._scissorWidth
				scissorHeight = transforms[i]._scissorHeight
			end
		end
		self.transform._offsetX= x
		self.transform._offsetY= y
		self.transform._scaleX= scaleX
		self.transform._scaleY= scaleY
		self.transform._usingScissor= usingScissor
		self.transform._scissorX= scissorX
		self.transform._scissorY= scissorY
		self.transform._scissorWidth= scissorWidth
		self.transform._scissorHeight= scissorHeight
		self._dirty = false
	end
}

function __mathRound(value)
	local remain = value % 1
	if(remain % 1 >= 0.49) then
		return value + 1 - remain
	else
		return value - remain
	end
end
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

--Set up compatibility from old to new api
local _oldImageGetW = image.getw
local _oldImageGetH = image.geth
function image.getw(img)
	if(img.imgData ~= nil) then
		return image.getrealw(img.imgData)
	else
		return _oldImageGetW(img)
	end
end
function image.geth(img)
	if(img.imgData ~= nil) then
		return image.getrealh(img.imgData)
	else
		return _oldImageGetH(img)
	end
end


function love.graphics.newImage(filename)
	img = image.load(lv1lua.dataloc.."game/"..filename)

	if lv1luaconf.imgscale == true then
		image.scale(img,scale*100)
	end
	local imgWrapper = 
	{
		imgData = img,
		flipX = false,
		flipY = false,
		getWidth = function(self)return image.getw(self)end,
		getHeight = function(self)return image.geth(self)end,
		getDimensions = function(self) return image.getw(self), image.geth(self)end
	}
	--Necessary to execute the same behavior from love2d desktop
	function imgWrapper:__handleNegativeScale(x, y, sx, sy)
		if(sx > 0 and self.flipX) then
			image.fliph(self.imgData)
			self.flipX = not self.flipX
		elseif(sx < 0 and self.flipX == false) then
			image.fliph(self.imgData)
			self.flipX = not self.flipX
		end
		if(sy > 0 and self.flipY) then
			image.flipv(self.imgData)
			self.flipY = not self.flipY
		elseif(sy < 0 and self.flipY == false) then
			image.flipv(self.imgData)
			self.flipY = not self.flipY
		end
		if(sx < 0) then
			x = x + (self:getWidth() * sx)
		end
		if(sy < 0) then
			y = y + self:getHeight() * sy
		end
		return x,y
	end
	
	return imgWrapper
end

function love.graphics.newQuad(x, y, width, height, sw, sh)
	local quad = 
	{
		x=x,y=y,width=width,height=height,sw=sw,sh=sh,

		_savedScaleX = 1,
		_savedScaleY = 1,
		_bufferImage = nil,
		getTextureDimensions = function(self)return sw,sh end,
		getViewport = function(self)return self.x, self.y, self.width, self.height end,
		setViewport = function(self, x, y, width, height)self.x = x; self.y = y; self.width = width; self.height = height; end
	}
	function quad:getViewportScaled(sx, sy)
		return self.x * sx, self.y * sy, self.width * sx, self.height * sy 
	end
	function quad:getTextureDimensionsScaled(sx, sy)
		return sw * sx,sh * sy
	end
	function quad:updateBufferScaled(drawable, sx, sy)
		--This function can lag a bit, but it is required, as I could not find in OneLua any other way to scale a image frame
		if(sx ~= self._savedScaleX or sy ~= self._savedScaleY or self._bufferImage == nil) then
			self._bufferImage = image.copyscale(drawable, self:getTextureDimensionsScaled(sx, sy))
			self._savedScaleX = sx
			self._savedScaleY = sy
		end
	end
	function quad:draw(drawable, x, y, r, sx, sy)
		self:updateBufferScaled(drawable, sx,sy)
		love.graphics._defaultDraw(self._bufferImage, x, y, r, sx, sy, self:getViewportScaled(sx, sy))
	end
	return quad
end

function love.graphics.translate(offsetX, offsetY)
	_transformStack.stack[#_transformStack.stack]._offsetX = offsetX
	_transformStack.stack[#_transformStack.stack]._offsetY = offsetY
	_transformStack._dirty = true
end

function love.graphics.scale(scaleX, scaleY)
	_transformStack.stack[#_transformStack.stack]._scaleX = scaleX
	_transformStack.stack[#_transformStack.stack]._scaleY = scaleY
	_transformStack._dirty = true
end

function love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)
	_transformStack.stack[#_transformStack.stack].usingScissor = (scissorX ~= nil)
	_transformStack.stack[#_transformStack.stack]._scissorX = scissorX
	_transformStack.stack[#_transformStack.stack]._scissorY = scissorY
	_transformStack.stack[#_transformStack.stack]._scissorWidth = scissorWidth
	_transformStack.stack[#_transformStack.stack]._scissorHeight = scissorHeight
	_transformStack._dirty = true
end

function love.graphics.push()
	_transformStack.stack[#_transformStack.stack + 1] = Transform:new()
end
love.graphics.push()

function love.graphics.pop()
	_transformStack.stack[#_transformStack.stack] = nil
	_transformStack._dirty = true
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
	anisotropy = (anisotropy == nil) and 0 or 1
end

function love.graphics.getDefaultFilter()
	return defaultMinificationFilter, defaultMagnificationFilter, anisotropy
end

function love.graphics._defaultDraw(drawable,x,y,r,sx,sy, xf, yf, w, h)
	if drawable == nil then print("No drawable passed"); return end
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
			image.setfilter(drawable, defaultMagnificationFilter, anisotropy)
		else
			image.setfilter(drawable, defaultMinificationFilter, anisotropy)
		end
		image.resize(drawable,image.getrealw(drawable)*sx,image.getrealh(drawable)*sy)
	end
	if(xf ~= nil) then
		image.blit(drawable,x,y, xf, yf, w, h, color.a(lv1lua.current.color))
	else
		image.blit(drawable,x,y,color.a(lv1lua.current.color))
	end
end

function love.graphics.draw(drawable,xOrQuad,y,r,sx,sy, x)
	local isDrawableNew = (type(drawable) == "table")
	
	local _x, _y, _r, _sx, _sy
	_transformStack:updateTransform()
	local transform = _transformStack.transform
	if (type(xOrQuad) == "table") then
		_x = (y == nil) and transform._offsetX or y + transform._offsetX
		_y = (r == nil) and transform._offsetY or r + transform._offsetY
		_r = sx
		_sx = (sy == nil) and transform._scaleX or sy * transform._scaleX
		_sy = (x == nil) and transform._scaleY or x * transform._scaleY
		local absSx, absSy = math.abs(_sx), math.abs(_sy)
		_x = __mathRound(_x * absSx)
		_y = __mathRound(_y * absSy)

		if(isDrawableNew) then
			_x, _y = drawable:__handleNegativeScale(_x, _y, _sx, _sy)
			xOrQuad:draw(drawable.imgData, _x, _y, _r, absSx, absSy)
		else
			xOrQuad:draw(drawable, _x, _y, _r, absSx, absSy)
		end
	else
		_x = xOrQuad
		_y = y
		_sx = (sx == nil) and transform._scaleX or sx * transform._scaleX
		_sy = (sy == nil) and transform._scaleY or sy * transform._scaleY
		_x = __mathRound(_x * math.abs(_sx))
		_y = __mathRound(_y * math.abs(_sy))
		local absSx, absSy = math.abs(_sx), math.abs(_sy)
		
		if isDrawableNew then
			_x, _y = drawable:__handleNegativeScale(_x, _y, _sx, _sy)
			love.graphics._defaultDraw(drawable.imgData, _x, _y, r, absSx, absSy)
		else
			love.graphics._defaultDraw(drawable, _x, _y, r, absSx, absSy)
		end
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

function love.graphics._defaultPrint(text, x, y, fontsize)
	if not x then x = 0 end
	if not y then y = 0 end
	fontsize = ((fontsize == nil) and lv1lua.current.font.size/18.5 or fontsize)
	
	--scale 1280x720 to 960x540(vita) or 480x270(psp)
	if lv1luaconf.imgscale == true or lv1luaconf.resscale == true then
		x = x * scale; y = y * scale
		fontsize = fontsize*fontscale
	end
	
	if text then
		screen.print(lv1lua.current.font.font,x,y,text,fontsize,lv1lua.current.color)
	end
end

function love.graphics.print(text,x,y)
	_transformStack:updateTransform()

	local fontsize = lv1lua.current.font.size/18.5 * _transformStack.transform._scaleX
	x = x * _transformStack.transform._scaleX 
	y = y * _transformStack.transform._scaleY + screen.textheight(lv1lua.current.font.font, fontsize)
	

	love.graphics._defaultPrint(text, x, y, fontsize)
end

function ___getAlignX(x, align, size, wrapSize)
	if(align == "center") then
		return x + (wrapSize - size) / 2
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
		wrapWidth = wrapWidth * _transformStack.transform._scaleX
		local lineJumpOn = wrapWidth / lv1lua.current.font.size
		local tempPhraseSize = 0
		local wordSize = 0
		local phrase = ""
		for word in string.gmatch(text, "%S+") do
			wordSize = string.len(word)
			if(wordSize + tempPhraseSize >= lineJumpOn) then
				love.graphics.print(phrase, ___getAlignX(x, align, lv1lua.current.font.size * wordSize, wrapWidth), y)
				y = y + screen.textheight(lv1lua.current.font.font, fontsize) --Jump line
				phrase = word
				tempPhraseSize = wordSize
			else
				tempPhraseSize = tempPhraseSize + wordSize + 1
				phrase = phrase .. " " ..  word
			end
		end
		if(phrase ~= "") then
			love.graphics.print(phrase, ___getAlignX(x, align, lv1lua.current.font.size * _transformStack.transform._scaleX * wordSize, wrapWidth), y)
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
		draw.fillrect(x, y, w * _transformStack.transform._scaleX, h * _transformStack.transform._scaleY, lv1lua.current.color)
	elseif mode == "line" then
		draw.rect(x, y, w * _transformStack.transform._scaleX, h * _transformStack.transform._scaleY, lv1lua.current.color)
	end
end

function love.graphics.line(x1,y1,x2,y2)
	draw.line(x1,y1,x2,y2,lv1lua.current.color)
end

function love.graphics.circle(x,y,radius)
	draw.circle(x,y,radius * _transformStack.transform._scaleX,lv1lua.current.color,30)
end
