-- A basic encounter script skeleton you can copy and modify for your own creations.
deathtext  = "[voice:ruredy][color:ffff00]Frisk![color:ffffff][w:5] You can't\ndo anything[w:10], so\ndon't even try!"
deathmusic = "Sunset Heights [Beta Mix]"
encountertext = "Playing with time, huh?" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"bullettest_roboorb"}
wavetimer = 64
arenasize = {155, 130}
wave = 0
SetGlobal("wave", wave)

Inventory.AddCustomItems({"DogeMeat", "SAVESTATE.EXE"}, {0, 0})
Inventory.SetInventory({"DogeMeat", "SAVESTATE.EXE"})

--constants
SEQ_WAVE = 3
OVERRIDE_ATTACKS = false
ATTACK_WHEN_OVER = "player_simon_8prompt_regcont"	--Attack to perform whilst override is on
SONG_SETLIST = math.random(3)

if(SONG_SETLIST == 1) then
	song = { 	"Battle",
				"vs_susie"
	}
elseif(SONG_SETLIST == 2) then
	song = { 	"ChemPastZone2a",
				"ChemPastZone2"
	}
else
	song = {	"AUDIO_STORY3part1",
				"AUDIO_STORY3part2"
	}
end

enemies = {
"opponent"
}

enemypositions = {
{0, 0}
}
	
-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.

					
if(OVERRIDE_ATTACKS == false) then
	easy_attacks = {"boss_ball","player_simon_3prompt","player_simon_4prompt","player_simon_learn8"}
	medi_attacks = {"player_simon_8prompt_regcont","player_simon_8prompt","bullet_roboorb"}
else
	easy_attacks = {ATTACK_WHEN_OVER}
	medi_attacks = {ATTACK_WHEN_OVER}
end

function EncounterStarting()
	Audio.LoadFile(song[1]) --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
    --Audio["hurtsound"] = "dogsecret"	--Set the player's hurt sound
	Player.name = "Frisk"				--Sets the player's name to frisk
    -- If you want to change the game state immediately, this is the place.
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
		
    if(wave == 1) then	--If we've finished the first attack
		if(Player.hp == 20) then	--If player's at full health
			enemies[1].SetVar('currentdialogue', {"Great, you can do\nthe simplest puzzle\nout there. How about\nI add a timer?"})			--Enemy recognizes success
		else						--If player's not at full health
			enemies[1].SetVar('currentdialogue', {"You're hurt? Look,\nit's not that hard.\njust look at the\nprompt, alright?"})	--Enemy recognizes failure
		end							--endif (Player.hp == 20)
	end					--endif (wave == 1)
	
	
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
	
	if(wave < 5) then
		nextwaves = { easy_attacks[math.random(#easy_attacks)] }	--Force the next attack to be randomized (regular)
	else
		nextwaves = { medi_attacks[math.random(#medi_attacks)] }	--Force the next attack to be randomized (simon)
	end
	
	if(wave == 0 and not OVERRIDE_ATTACKS) then -- we're about to start
		nextwaves = {"player_simon_learn"}
	elseif(wave == 5) then
		Audio.LoadFile(song[2])					--Set the music (causes some noticable lag)		
	end
end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
	wave = wave + 1	--Increment the current wave
	SetGlobal("wave", wave)
    Audio["RESETDICTIONARY"] = "dogsecret"	--Reset the hurt sound to default
	Audio.Pitch(1);	--Reset the pitch of the sound
end

function HandleSpare()
    State("ENEMYDIALOGUE")	--If we try sparing someone, enemy gets a turn
end

function HandleItem(ItemID)
	if(ItemID == "DOGEMEAT") then
		BattleDialog({"You eat the doge's meat.[w:10] Disgusting."})
		Player.Heal(5)
	elseif(ItemID == "SAVESTATE.EXE") then
		BattleDialog({"It feels bad cheating, but\nyou gotta do what you\ngotta do."})
		Player.Heal(20)
	end
end