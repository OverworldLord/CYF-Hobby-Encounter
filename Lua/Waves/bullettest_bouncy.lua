-- The bouncing bullets attack from the documentation example.
spawntimer = 0
bullets = {}

function Update()
	spawntimer = spawntimer + 1
	if(spawntimer % 20 == 0) then
		local posx = 30 - math.random(60)
		local posy = Arena.height
		local bullet = CreateProjectile('bullet', posx, posy)
		bullet.SetVar('velx', 1 - 2*math.random())
		bullet.SetVar('vely', 0)
		table.insert(bullets, bullet)
    end
    for i=1,#bullets do
        local bullet = bullets[i]
        local velx = bullet.GetVar('velx')
        local vely = bullet.GetVar('vely')
        local newposx = bullet.x + velx
		newposx = bullet.x + velx
        local newposy = bullet.y + vely
        if(bullet.x > -Arena.width/2 and bullet.x < Arena.width/2) then
            if(bullet.y < -Arena.height/2 + 8) then 
                newposy = -Arena.height/2 + 8
                vely = 0
            end
        end
        vely = vely - 0.10
        bullet.MoveTo(newposx, newposy)
        bullet.SetVar('vely', vely)
    end
end