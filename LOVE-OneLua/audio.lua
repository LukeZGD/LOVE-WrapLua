function love.audio.newSource(source)
	local table = {
		loadsound = sound.load(dataloc.."game/"..source);
		setLooping = function(self,setloop)
			if (setloop and not sound.looping(self.loadsound)) or (not setloop and sound.looping(self.loadsound)) then
				sound.loop(self.loadsound);
			end;
		end;
		play = function(self)
			love.audio.play(self);
		end;
		stop = function(self)
			love.audio.stop(self);
		end;
		}
	return table
end

function love.audio.play(source)
	sound.play(source.loadsound)
end

function love.audio.stop(source)
	sound.stop(source.loadsound)
end