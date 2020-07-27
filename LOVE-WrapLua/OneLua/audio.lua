local _channel1 = nil
local _channel2 = nil


--Mode parameter should be private
-- -1 means invert state
--  0 means resume
--  1 means pause
function love.audio.pause(source, mode)
    if(mode == nil) then
        mode = 1
    end
    if(source == nil) then
        if(_channel1 ~= nil) then
            sound.pause(_channel1.loadsound, mode)
        end
        if(_channel2 ~= nil) then
            sound.pause(_channel2.loadsound, mode)
        end
    else
        sound.pause(source.loadsound, mode)
    end
end

function love.audio.resume(source)
    love.audio.pause(source, 0)
end

function __convertToSupported(source)
    local first, last = string.find(source, "%.%a+")
    local str = string.lower(string.sub(source, first+1, last))

    local default = "mp3"
    if(str == "wav" or str == "wma" or str == "m4a" or str == "3gp" or str == "ogg") then
        return string.sub(source, 1, first) ..default
    else
        return source
    end
end


function love.audio.newSource(source,sourcetype)
    local table = {
        loadsound = sound.load(__convertToSupported(lv1lua.dataloc.."game/"..source));
        type = sourcetype;
        play = function(self)
            if self.loadsound then love.audio.play(self) end;
        end;
        stop = function(self)
            if self.loadsound then love.audio.stop(self) end;
        end;
        getVolume = function(self)
            if self.loadsound then return sound.vol(self.loadsound) end;
        end;
        setVolume = function(self,vol)
            if self.loadsound then sound.vol(self.loadsound,vol*100) end;
        end;
        setLooping = function(self,setloop)
            if self.loadsound then
                if sound.looping(self.loadsound) ~= setloop then
                    sound.loop(self.loadsound);
                end;
            end
        end;
        isPlaying = function(self)
            if self.loadsound then return sound.playing(self.loadsound) end;
        end;
        isLooping = function(self)
            if self.loadsound then return sound.looping(self.loadsound) end;
        end;
        }
    return table
end

--OneLua limitation -> Just have 2 sound channels
function love.audio.play(source)
    if source.type == "static" then
        _channel1 = source
        sound.play(source.loadsound,1)
    else
        _channel2 = source
        sound.play(source.loadsound,2)
    end
end

function love.audio.stop(source)
    if(source == _channel1) then
        _channel1 = nil
    else
        _channel2 = nil
    end
    sound.stop(source.loadsound)
end
