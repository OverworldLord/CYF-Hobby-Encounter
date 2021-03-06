-- You've seen this one in the trailer (if you've seen the trailer).
local yOff = 0
local xOff = 0
local guidesleft = 8
local finishingTimer = 0
local index  = 1
local index2 = 5

--This wave will give the player four different buttons to press, and the order in which to press them. If anything is pressed out of order,
--the player will take damage. There will be a time limit.

--Constant
OFFSET = 50

local spriteUsed = {false, false, false, false, false, false, false, false}
local sprite = {}

spriteVariations = {"guideBlackRed","guideRed","guideYellow","guidePurple","guide"}
possibleSprites = 	{}
					
for i=1,guidesleft do
	math.random(#possibleSprites)
	table.insert(possibleSprites, spriteVariations[math.random(#spriteVariations)])
end

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

local spriteUsed = {false, false, false, false, false, false, false, false}
local simon = {}

--Generate the simon prompt
for i=1,4 do
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
for i=5,8 do
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
local guide = CreateProjectile(sprite[5], OFFSET, OFFSET)
guide.SetVar('sprite', sprite[5])
local guide = CreateProjectile(sprite[6], -OFFSET, OFFSET)
guide.SetVar('sprite', sprite[6])
local guide = CreateProjectile(sprite[7], OFFSET, -OFFSET)
guide.SetVar('sprite', sprite[7])
local guide = CreateProjectile(sprite[8], -OFFSET, -OFFSET)
guide.SetVar('sprite', sprite[8])

--Create the prompt, we won't need to store the sprites because they're already stored
prompts = {}
local prompt = CreateProjectile(simon[1], -OFFSET/2 + 25, 100)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[2], -OFFSET/2 + 50, 100)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[3], OFFSET/2 + 25,  100)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[4], OFFSET/2 + 50,  100)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[5], -OFFSET/2 + 25, 85)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[6], -OFFSET/2 + 50, 85)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[7], OFFSET/2 + 25,  85)
table.insert(prompts, prompt)
local prompt = CreateProjectile(simon[8], OFFSET/2 + 50,  85)
table.insert(prompts, prompt)



local count = 0

function Update()
	count = count + 1
	if(count == 500 and guidesleft != 0) then
		hourglass = CreateProjectile('hourglass', -OFFSET/2 - 50, 100)
		Audio.pitch(1.05)
	elseif(count == 600 and guidesleft != 0) then
		hourglass.Remove()
		hourglassHurry = CreateProjectile('hourglassHurry', -OFFSET/2 - 50, 100)
		Audio.pitch(1.10)
	elseif(count == 700 and guidesleft != 0) then
		Audio.pitch(1.00)
		hourglass.Remove()
		Player.hurt(3)
		Misc.ShakeScreen(60, 7, true)
	elseif(count >= 800 and guidesleft != 0) then
		State("ACTIONSELECT")
	end


	if(guidesleft == 0) then						--If we've surpassed the number of elements in simon
		if(finishingTimer < 100) then				--If we're at less than
			finishingTimer = finishingTimer + 1		--Count to 100 ticks
		else										--If we've reached 100 ticks
			State("ACTIONSELECT")					--Finish
		end
	end
end

function OnHit(guide)
	--If there are more indexes to simon's prompt, the sprite is correct, and the player isn't taking damage
	if(index <= #simon and (guide.GetVar('sprite') == simon[index] or guide.GetVar('sprite') == simon[index2]) and Player.ishurting == false) then
		if(index <= #simon/2   and guide.GetVar('sprite') == simon[index]) then
			prompts[index].Remove()
			index = index + 1
			
		elseif(index2 <= #simon and guide.GetVar('sprite') == simon[index2]) then
			prompts[index2].Remove()
			index2 = index2 + 1
		end
		guidesleft = guidesleft - 1
		guide.Remove()
		
		if(guidesleft == 0) then	--If we're on the last guide
			Audio.PlaySound("sndadd1")
		else									--If we're on a different guide
			Audio.PlaySound("sndadd2")
		end
	else	--The player made a mistake
		Player.hurt(3)	--Hurt the player
	end
end