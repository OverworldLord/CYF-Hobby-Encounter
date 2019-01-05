-- The chasing attack from the documentation example.

local bullets = {}
local chasingbullet = CreateProjectile('bullet', Arena.width/2, Arena.height/2)
table.insert(bullets, chasingbullet)
local chasingbullet = CreateProjectile('bullet', Arena.width, Arena.height/2)
table.insert(bullets, chasingbullet)
local chasingbullet = CreateProjectile('bullet', Arena.width/2, Arena.height)
table.insert(bullets, chasingbullet)
local chasingbullet = CreateProjectile('bullet', Arena.width, Arena.height)
table.insert(bullets, chasingbullet)

local last = -2
local timer = 0
local xArenasize = 250
local yArenasize = 250
local pitch = 1
Arena.Resize(xArenasize, yArenasize)

function Update()
	if(timer % 120 == 0) then
		local chasingbullet = CreateProjectile('bullet', Arena.width/2, Arena.height/2)
		table.insert(bullets, chasingbullet)
		timer = 0
	end
	

	
	for i = 1, #bullets do
		local randTrans = 3 - (math.random(6))
		local bullet = bullets[i]
		local xdifference = Player.x - bullet.x
		local ydifference = Player.y - bullet.y
		
		if(timer % 20) then
			if((xdifference > ydifference and ydifference > 0) or (xdifference < ydifference and ydifference < 0)) then --if |xdiff| > |ydiff|
				if(xdifference > 0) then	--if x > 0 > |y|
					xMov = (math.random(10)*.2)
					yMov = randTrans
				else						--if x < 0 > -|y|
					xMov = -(math.random(10)*.2)
					yMov = randTrans
				end
			else
				if(ydifference > 0) then	--if y > 0 > |x|
					xMov = randTrans
					yMov = (math.random(10)*.2)
				else						--if y < 0 > -|x|
					xMov = randTrans
					yMov = -(math.random(10)*.2)
				end
			end
		end
			
		bullet.Move(xMov, yMov)
	end
	
	timer = timer + 1
	
	if(#bullets >= 10) then
		State("ACTIONSELECT")
	end
end
