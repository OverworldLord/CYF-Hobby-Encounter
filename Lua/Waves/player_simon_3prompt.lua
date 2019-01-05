-- You've seen this one in the trailer (if you've seen the trailer).
Player.SetControlOverride(true)
local yOff = 0
local xOff = 0
local guidesleft = 4
local finishingTimer = 0
local index = 1

--This wave will give the player four different buttons to press, and the order in which to press them. If anything is pressed out of order,
--the player will take damage. There will be a time limit.

--Constant
OFFSET = 50

local spriteUsed = {false, false, false, false}
local sprite = {}

possibleSprites = {"guideBlackRed","guideRed","guideYellow","guidePurple"}

--Generate the guides and their sprite values
for i=1,guidesleft do
	spriteIndex = math.random(#possibleSprites)
	
	while(spriteUsed[spriteIndex] == true) do
		if(spriteIndex == #possibleSprites) then
			spriteIndex = 1
		else
			spriteIndex = spriteIndex + 1
		end
	end
	spriteUsed[spriteIndex] = true
	spriteToUse = possibleSprites[spriteIndex]
	table.insert(sprite, spriteToUse)
end

local spriteUsed = {false, false, false, false}
local simon = {}

--Generate the simon prompt
for i=1,guidesleft-1 do
	spriteIndex = math.random(#possibleSprites)
	
	while(spriteUsed[spriteIndex] == true) do
		if(spriteIndex == #possibleSprites) then
			spriteIndex = 1
		else
			spriteIndex = spriteIndex + 1
		end
	end
	spriteUsed[spriteIndex] = true
	spriteToUse = possibleSprites[spriteIndex]
	table.insert(simon, spriteToUse)
end

--Create the guides, store their sprites
local guide = CreateProjectile(sprite[1], OFFSET, 0)
guide.SetVar('sprite', sprite[1])
local guide = CreateProjectile(sprite[2], 0, OFFSET)
guide.SetVar('sprite', sprite[2])
local guide = CreateProjectile(sprite[3], 0, -OFFSET)
guide.SetVar('sprite', sprite[3])
local guide = CreateProjectile(sprite[4], -OFFSET, 0)
guide.SetVar('sprite', sprite[4])

--Create the prompt, we won't need to store the sprites because they're already stored
local prompt = CreateProjectile(simon[1], -OFFSET/2 + 50, 100)
local prompt = CreateProjectile(simon[2], 0 + 50, 		  100)
local prompt = CreateProjectile(simon[3], OFFSET/2 + 50,  100)



local count = 0

function Update()
	count = count + 1
	if(count == 150 and index < #simon) then
		hourglass = CreateProjectile('hourglass', -OFFSET/2 - 50, 100)
		Audio.pitch(1.01)
	elseif(count == 250 and index < #simon) then
		hourglass.Remove()
		hourglassHurry = CreateProjectile('hourglassHurry', -OFFSET/2 - 50, 100)
		Audio.pitch(1.02)
	elseif(count == 300 and index < #simon) then
		hourglass.Remove()
		Player.hurt(3)
		Audio.pitch(1.00)
	elseif(count == 400 and index < #simon) then
		State("ACTIONSELECT")
	end
	
	
	
	
	



	if(index > #simon) then							--If we've surpassed the number of elements in simon
		if(finishingTimer < 100) then				--If we're at less than
			finishingTimer = finishingTimer + 1		--Count to 100 ticks
		else										--If we've reached 100 ticks
			State("ACTIONSELECT")					--Finish
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
	--If there are more indexes to simon's prompt, the sprite is correct, and the player isn't taking damage
	if(index <= #simon and guide.GetVar('sprite') == simon[index] and Player.ishurting == false) then
		guide.Remove()
		index = index + 1
		guidesleft = guidesleft - 1
		if(index > 3) then	--If we're on the last guide
			Audio.PlaySound("sndadd1")
			Player.SetControlOverride(false)
		else									--If we're on a different guide
			Audio.PlaySound("sndadd2")
		end
	else	--The player made a mistake
		Player.hurt(3)	--Hurt the player
	end
end