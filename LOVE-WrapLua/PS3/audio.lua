snd.Init()
snd.SetVolumeBGMusic(127)
local audioplaying = {}

function lv1lua.playsound()
    for i = 1, #audioplaying do
        if audioplaying[i] == 1 then
            snd.PlayVoice(i,0,0,200,200,0)
            sys.TimerUsleep(0)
        end
    end
end

function love.audio.newSource(source,sourcetype)
    local ch
    
    if sourcetype == "stream" then
        ch = 1
        audioplaying[ch] = 0
        ret = snd.SetVoice(ch,lv1lua.dataloc.."game/"..source)
    end
    
    local table = {
        channel = ch;
        type = sourcetype;
        play = function(self)
            love.audio.play(self)
        end;
        stop = function(self)
            love.audio.stop(self)
        end;
        getVolume = function(self)
            --if self.loadsound then return (Sound.getVolume(self.loadsound))/100 end
        end;
        setVolume = function(self,vol)
            --if self.loadsound then Sound.setVolume(self.loadsound,vol*100) end
        end;
        setLooping = function(self,setloop)
            --all voices are looping in PS3 Lua Player unless stopped
        end;
        isPlaying = function(self)
            --if self.loadsound then return Sound.isPlaying(self.loadsound) end;
        end;
        isLooping = function(self)
            --if self.loadsound then return self.loop end;
        end;
        }
    return table
end

function love.audio.play(source)
    if source.channel then
        audioplaying[source.channel] = 1
    end
end

function love.audio.stop(source)
    if source.channel then
        audioplaying[source.channel] = 0
        snd.StopVoice(source.channel)
        snd.FreeVoice(source.channel)
        table.remove(audioplaying,source.channel)
    end
end
