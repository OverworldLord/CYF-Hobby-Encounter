-- Inspired by everyone's favorite breakfast meat

local spawner = CreateProjectile('spawner', -50, 50)
spawner.SetVar('type', "spawner")

local bullets = {}
local spawntimer  = math.random(50)
local gotSpawnerTimer = 0

spawner.SetVar('velx', 0) -- We'll use this for horizontal speed. Random between -1/1
spawner.SetVar('vely', 0) -- We'll use this for fall speed. We're starting without downward movement.


function Update()
	if(spawntimer % 5 == 0 and spawntimer < 80 and spawner.isactive == true) then
	    local bullet = CreateProjectile('bullet', spawner.x, spawner.y)
		bullet.SetVar('type', "bullet")
		table.insert(bullets, bullet)
		
	elseif(spawntimer >= 100) then
		spawntimer = 0
	end
	
	for i=1,#bullets do
		local bullet = bullets[i]
		bullet.Move(0, -2)
	end


	if(spawner.isactive == true) then
		local velx = spawner.GetVar('velx') -- Get the X/Y velocity we just set
		local vely = spawner.GetVar('vely')
		local newposx = spawner.x + velx -- New position will be old position + velocity
		local newposy = spawner.y + vely
		
		if(velx > 0) then
			vely = spawner.x*.01
		else
			vely = -spawner.x*.01
		end
		
		if(spawner.x > 0) then
			velx = velx - .05
		else
			velx = velx + .05
		end
		
		
		spawner.MoveTo(newposx, newposy) -- and finally, move our spawner
		spawner.SetVar('vely', vely) -- and store our new fall speed into the spawner again.
		spawner.SetVar('velx', velx) -- We'll use this for horizontal speed. Random between -1/1
		spawntimer = spawntimer + 1
		
	elseif(gotSpawnerTimer < 30) then
		gotSpawnerTimer = gotSpawnerTimer + 1
	else
		State("ACTIONSELECT")
	end
end

function OnHit(projectile)
	if(projectile.GetVar('type') == "spawner") then
		Player.Heal(5)
		projectile.Remove()
	else -- type is regular bullet
		Player.Hurt(3)
	end
end