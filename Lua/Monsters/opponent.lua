-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"Sand is floating around in here.", "It's just about time to wrap\nthings up.", "The music is at it's regular\ntempo.[w:15] For now, at least."}
commands = {"Taunt", "Joke", "Compliment"}
randomdialogue = {"Maybe I should use\ndigital clocks.", "Too fast for you?[w:10]\nI guess I can\nslow down.[w:20] Not.", "Lets go, come on!"}

sprite = "poseur" --Always PNG. Extension is added automatically.
name = "????????"
hp = 10
atk = 3
def = 2
check = "A mysterious and impatient foe.[w:10]\nNot worth the effort."
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = true

numJokes = 0
numTaunt = 0
numCompl = 0

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        -- player did actually attack
    end
end
 
-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
    if command == "TAUNT" then
		BattleDialog({"You complain about how slow\ntheir attacks are."})
		if(GetGlobal("wave") > 0) then
			currentdialogue = {"[func:shake]Well, let's speed\nthings up a bit,\nthen."}
		else
			currentdialogue = {"What? I didn't\neven attack yet..."}
		end
		numTaunt = numTaunt + 1
    elseif command == "JOKE" then
		BattleDialog({"You ask if he has the time."})
        currentdialogue = {"Uh huh."}
		numJokes = numJokes + 1
    elseif command == "COMPLIMENT" then
		BattleDialog({"You tell them that they have a\nnice hourglass.[w:10] Except the top."})
        currentdialogue = {"[noskip]Oh. Well, uh, thank y[next]","[instant][effect:twitch]Oh. Well, uh, nobody\ncares what you\nthink."}
		canspare = true
		numCompl = numCompl + 1
    end
    
end

function HandleSpare()
	if(canspare) then
		Spare()
	else
		BattleDialog({"Your efforts are futile.\nMaybe it was just bad timing."})
        currentdialogue = {"Why would I let you go?[w:10]\nIt's playtime!"}
	end
end

function shake()
	Misc.ShakeScreen(60,7,true)
end