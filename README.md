# LOVE-WrapLua

A small and simple LOVE2D wrapper for OneLua, lpp-vita, and Lua Player PS3

You can use this to make LOVE2D stuff for a PSP, PS Vita, and/or PS3! As an example, this is used on [DDLC-LOVE](https://github.com/LukeZGD/DDLC-LOVE/)

This is made just for fun and will only have the basic stuff.

- See `Implemented.md` for the list of implemented stuff
- `script.lua` is the main file for LOVE-WrapLua (required)
- `index.lua` is for lpp-vita to run `script.lua` (required for lpp-vita only)
- `app.lua` is for Lua Player PS3 to run `script.lua` (required for Lua Player PS3 only)
- `lv1luaconf` in `conf.lua` is to set up some settings for key configuration `keyconf`, resolution scale `resscale`, and image scale `imgscale`. This is optional; See `script.lua` for the default values

## Changelog
- By Hipreme/MrcSnm:
### OneLua Only
- Support most of love.graphics functions 
- touch.lua and mouse.lua added 
- Added command for resetting (Hold LEFT, UP, SQUARE, TRIANGLE, L and press R)
- Support for quads, global scale and offset
- Backwards WrapLua compatibility
- Now it supports love2d objects (Now you can call imageInstance:getWidth() etc)
- Added some do-nothing functions for not breaking code compatibility with desktop version

### Needing
- Rotated text
- Blend modes
- Shader support
- Tint blit for everything
- Better image.blit for quads


#### Known Issues
- Calling screen.textwidth(font, text, size) will make the font passed on the argument to blur, the current workaround is creating a clone e.g loading the same font 2 times and then using the guinea pig to get the text width
- Calling image.blit() for a resized image quad will mantain the texture size, the current workaround is loading a image copy with image.copyscale() for the size needed, it will cache this resized image until it's scale is changed, the problem is that it will lag a bit when caching, don't know to what extent this is possible, and doing scale animations with images from quad is really inusable
- The only supported audio that didn't crash the engine was mp3 at a 44100 sample rate, wav file didn't crash, but sounded strange, need more tests
