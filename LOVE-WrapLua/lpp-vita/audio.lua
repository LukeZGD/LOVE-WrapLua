Sound.init()

function love.audio.newSource(source,sourcetype)
    local table = {
        loadsound = Sound.open(lv1lua.dataloc.."game/"..source);
        type = sourcetype;
        play = function(self)
            if self.loadsound then love.audio.play(self) end;
        end;
        stop = function(self)
            if self.loadsound then love.audio.stop(self) end;
        end;
        getVolume = function(self)
            if self.loadsound then return (Sound.getVolume(self.loadsound))/32767 end;
        end;
        setVolume = function(self,vol)
            if self.loadsound then Sound.setVolume(self.loadsound,vol*32767) end;
        end;
        setLooping = function(self,setloop)
            self.loop = setloop
        end;
        isPlaying = function(self)
            if self.loadsound then return Sound.isPlaying(self.loadsound) end;
        end;
        isLooping = function(self)
            if self.loadsound then return self.loop end;
        end;
        }
    return table
end

function love.audio.play(source)
    if not source.loop then
        source.loop = false
    end
    Sound.play(source.loadsound,source.loop)
end

function love.audio.stop(source)
    Sound.pause(source.loadsound)
    Sound.close(source.loadsound)
end
