-- You've seen this one in the trailer (if you've seen the trailer).
Player.SetControlOverride(true)
local yOff = 0
local xOff = 0
local guidesleft = 9
local finishingTimer = 0

--Constant
OFFSET = 50

local guide = CreateProjectile("guide", OFFSET, OFFSET)
local guide = CreateProjectile("guide", OFFSET, 0)
local guide = CreateProjectile("guide", OFFSET, -OFFSET)
local guide = CreateProjectile("guide", 0, OFFSET)
local guide = CreateProjectile("guide", 0, 0)
local guide = CreateProjectile("guide", 0, -OFFSET)
local guide = CreateProjectile("guide", -OFFSET, OFFSET)
local guide = CreateProjectile("guide", -OFFSET, 0)
local guide = CreateProjectile("guide", -OFFSET, -OFFSET)

function Update()
	if(guidesleft <= 0) then
		if(finishingTimer < 100) then
			finishingTimer = finishingTimer + 1
		else
			State("ACTIONSELECT")
		end

	else
		if(Input.Up == Input.Down and Input.Up == 2) then			--Up + Down are both active
			yOff = 0
		elseif(Input.Up == 2) then									--Up alone is active
			yOff = 1
		elseif(Input.Down == 2) then			 					--Down alone is active
			yOff = -1
		else														--Neither are active
			yOff = 0
		end
		
		if(Input.Left == Input.Right == 1 and Input.Left == 2) then	--Left + Right are both active
			xOff = 0
		elseif(Input.Right == 2) then								--Right alone is active
			xOff = 1
		elseif(Input.Left  == 2) then			 					--Left alone is active
			xOff = -1
		else														--Neither are active
			xOff = 0
		end
	
		Player.MoveTo(xOff*OFFSET, yOff*OFFSET, false)				--Set the player's position based on their pressed buttons
	end
end

function OnHit(guide)
	guide.Remove()
	guidesleft = guidesleft - 1
	if(guidesleft == 0) then
		Audio.PlaySound("sndadd1")
		Player.SetControlOverride(false)
	else
		Audio.PlaySound("sndadd2")
	end
end