-- You've seen this one in the trailer (if you've seen the trailer).
local spawntimer = 0
local bullets = {}
local yOffset = 180
local mult = 0.5
local pitch = 1

function Update()
    spawntimer = spawntimer + 1
    if(spawntimer % 5 == 0) then
        local numbullets = 3
        for i=1,numbullets+1 do
            local bullet = CreateProjectile('bullet', 0, yOffset)
			table.insert(bullets, bullet)
			local bullet = CreateProjectile('bullet', -spawntimer*.6, yOffset)
			table.insert(bullets, bullet)
			local bullet = CreateProjectile('bullet', spawntimer*.6, yOffset)
            table.insert(bullets, bullet)
        end
    end

    for i=1,#bullets do
		local bullet = bullets[i]
		local xdifference = Player.x - bullet.x
		local ydifference = Player.y - bullet.y
		if(xdifference > 0) then
			xMov = 1.105
		else
			xMov = -1.105
		end
		
		if(ydifference > 0) then
			yMov = 0.65
		else
			yMov = -0.95
		end
		bullet.Move(xMov, yMov)
    end
	
		pitch = pitch*1.002
		Audio.pitch(pitch)
end