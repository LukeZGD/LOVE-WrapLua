function love.audio.newSource(source,sourcetype)
	local table = {
		loadsound = sound.load(lv1lua.dataloc.."game/"..source);
		type = sourcetype;
		play = function(self)
			love.audio.play(self);
		end;
		stop = function(self)
			love.audio.stop(self);
		end;
		getVolume = function(self)
			return sound.vol(self.loadsound);
		end;
		setVolume = function(self,vol)
			sound.vol(self.loadsound,vol*100)
		end;
		setLooping = function(self,setloop)
			if (setloop and not sound.looping(self.loadsound)) or (not setloop and sound.looping(self.loadsound)) then
				sound.loop(self.loadsound);
			end;
		end;
		isPlaying = function(self)
			return source.playing(self.loadsound);
		end;
		isLooping = function(self)
			return source.looping(self.loadsound);
		end;
		}
	return table
end

function love.audio.play(source)
	if source.type == "static" then
		sound.play(source.loadsound,2)
	else
		sound.play(source.loadsound,1)
	end
end

function love.audio.stop(source)
	sound.stop(source.loadsound)
end