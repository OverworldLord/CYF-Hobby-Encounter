-- The chasing attack from the documentation example.

local chasingbullet = CreateProjectile('bullet', Arena.width/2, Arena.height/2)

local last = -2
local timer = 0
local xArenasize = 300
local yArenasize = 130
local pitch = 1
Arena.Resize(xArenasize, 130)

function Update()
	local xdifference = Player.x - chasingbullet.x
    local ydifference = Player.y - chasingbullet.y
	
	
	
	if(xdifference > 0) then
		xMov = 1
	else
		xMov = -1
	end
	
	if(ydifference > 0) then
		yMov = 1
	else
		yMov = -1
	end
	
	if(last != xMov + yMov and timer <= 0 and xArenasize > 90) then
		xArenasize = xArenasize*.8
		pitch = pitch*1.03
		Audio.pitch(pitch)
		Arena.Resize(xArenasize, yArenasize)
		timer = 30
		last = xMov + yMov
	end
	
	if(xArenasize <= 90 and yArenasize > xArenasize) then
		pitch = pitch*1.0006
		Audio.pitch(pitch)
		yArenasize = yArenasize - 0.4
		Arena.Resize(xArenasize, yArenasize)
	end
	
	timer = timer - 1
	
	chasingbullet.Move(xMov, yMov)
end
