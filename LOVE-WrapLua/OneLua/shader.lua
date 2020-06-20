__ALPHA = 0
__ADD = 1
__currentBlendMode = __ALPHA --This mode equals do nothing on shader

--No use of string comparison here
--Optimizations on this section is based on https://www.lua.org/gems/sample.pdf

local _pixels = {} --Copy of the screen
local _imageCache = {} --Cached image data
local _screenWidth = 0
local _screenHeight = 0
love.shader = {}

local c_ = color.new --Internal local
local p_ = image.pixel --Internal local

function love.shader.initialize(screenWidth, screenHeight)
    for y = 1, screenHeight do
        for x = 1, screenWidth do
            _pixels[y * screenWidth + x] = c_(0,0,0,0)
        end
    end
    _screenWidth = screenWidth
    _screenHeight = screenHeight
end

function love.shader.setPixel(x, y, color)
    _pixels[y * _screenWidth + x] = color
end

function love.shader.getPixel(x, y)
    return _pixels[y * _screenWidth + x]
end

function love.shader.getPixeCachel(img, x, y)
    return _imageCache[img].pixels[y * _screenWidth + x]
end


--This function will cache the image data
function love.shader.cacheData(img)
    if _imageCache[img] == nil then
        _imageCache[img] = {}
        _imageCache[img].pixels = {}
        local w = image.getrealw(img)
        local h = image.getrealh(img)

        _imageCache[img].width = w
        _imageCache[img].height = h
        for y = 1, h do
            for x = 1, w do
                _imageCache[img].pixels[y *w + x] = p_(img, x, y)
            end
        end
    end
end

--This function will load the data into the _pixels 
function love.shader.loadData(img, x, y)
    local data = _imageCache[img]
    local w, h = data.width, data.height

    for yCount = 1, h do
        for xCount = 1, w do
            love.shader.setPixel(xCount + x, yCount + y, data.pixels[yCount * w + xCount])
        end
    end
end


function love.shader.blend(img, x, y)
    love.shader.cacheData(img)
    if(__currentBlendMode == __ALPHA)then
        love.shader.loadData(img, x, y)
        return
    end
    if(__currentBlendMode == __ADD)then

    end
end

function love.shader.render()
    for y = 1, _screenHeight do
        for x = 1, _screenWidth do
            draw.rect(x, y, 1, 1, _pixels[y * _screenWidth + x])
        end
    end
end