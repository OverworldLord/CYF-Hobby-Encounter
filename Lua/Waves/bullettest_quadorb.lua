-- The chasing attack from the documentation example.

bullets = {}
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
	for i = 1, #bullets do
		local bullet = bullets[i]
		local xdifference = Player.x - chasingbullet.x
		local ydifference = Player.y - chasingbullet.y
		
		
		if(timer % 10 == 0) then
			if((xdifference > ydifference and ydifference > 0) or (xdifference < ydifference and ydifference < 0)) then --if |xdiff| > |ydiff|
				if(xdifference > 0) then	--if x > 0 > |y|
					xMov = 2
					yMov = 0
				else						--if x < 0 > -|y|
					xMov = -2
					yMov = 0
				end
			else
				if(ydifference > 0) then	--if y > 0 > |x|
					xMov = 0
					yMov = 2
				else						--if y < 0 > -|x|
					xMov = 0
					yMov = -2
				end
			end
			timer = 0
		end
			
		bullet.Move(xMov, yMov)
	end
	
	timer = timer + 1
end
