function love.audio.newSource(source,sourcetype)
	local table = {
		loadsound = sound.load(lv1lua.dataloc.."game/"..source);
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