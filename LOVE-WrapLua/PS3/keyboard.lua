pad.InitPads(1)
lv1lua.key = {
	up=0,down=0,left=0,right=0,
	cross=0,circle=0,square=0,triangle=0,
	l=0,r=0,select=0,start=0
}

function love.keyboard.isDown(key)
	if  (pad.up(0)>0 and key=="up") or (pad.down(0)>0 and key=="down") or
		(pad.left(0)>0 and key=="left") or (pad.right(0)>0 and key=="right") or
		(pad.circle(0)>0 and key==lv1lua.keyconf[1]) or (pad.cross(0)>0 and key==lv1lua.keyconf[2]) or
		(pad.triangle(0)>0 and key==lv1lua.keyconf[3]) or (pad.square(0)>0 and key==lv1lua.keyconf[4]) or
		(pad.L1(0)>0 and key==lv1lua.keyconf[5]) or (pad.R1(0)>0 and key==lv1lua.keyconf[6]) or
		(pad.select(0)>0 and key=="select") or (pad.start(0)>0 and key=="start") then
		return true
	else
		return false
	end	
end

function love.keyboard.setTextInput(enable)
	if enable then
		
	end
end