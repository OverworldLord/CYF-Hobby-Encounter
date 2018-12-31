-- A basic encounter script skeleton you can copy and modify for your own creations.

encountertext = "Poseur strikes a pose!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"bullettest_roboorb"}
wavetimer = 8.0
arenasize = {155, 130}
wave = 0

--constants
SEQ_WAVE = 3

song = { 	"Battle",
			"vs_susie"
}

enemies = {
"poseur"
}

enemypositions = {
{0, 0}
}
	
-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"bullettest_bouncy", "bullettest_chaserorb", "bullettest_touhou",
					"bullet_quadorb","bullet_roboorb","bullet_touhou2","boss_ball","player_ddr"	}

function EncounterStarting()
	Audio.LoadFile(song[1]) --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
    Audio["hurtsound"] = "dogsecret"	--Set the player's hurt sound
	Player.name = "Frisk"				--Sets the player's name to frisk
    -- If you want to change the game state immediately, this is the place.
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
	
	
    if(wave == 1) then	--If we've finished the first attack
		if(Player.hp == 20) then	--If player's at full health
			enemies[1].SetVar('currentdialogue', {"Speedy,\naren't\nyou?"})			--Enemy recognizes success
		else						--If player's not at full health
			enemies[1].SetVar('currentdialogue', {"Guess\nI've\ngot a\nchance."})	--Enemy recognizes failure
		end							--endif (Player.hp == 20)
	end					--endif (wave == 1)
	
	
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
	nextwaves = { possible_attacks[math.random(#possible_attacks)] }	--Force the next attack to be randomized

end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
	wave = wave + 1	--Increment the current wave
    Audio["RESETDICTIONARY"] = "dogsecret"	--Reset the hurt sound to default
	Audio.Pitch(1);	--Reset the pitch of the sound
	
	if(wave >= SEQ_WAVE and wave < SEQ_WAVE + 4) then	--If our current wave is set to be in a sequence
		nextwaves = { possible_attacks[math.random(#possible_attacks)] }	--Force the next attack to be randomized
		if(wave == SEQ_WAVE) then					--If this is the first wave in the sequence
			Audio.LoadFile(song[2])					--Set the music (causes some noticable lag)
		end											--End inner if statement
		State("DEFENDING")													--Call the next attack
	end													--endif

end

function HandleSpare()
    State("ENEMYDIALOGUE")	--If we try sparing someone, enemy gets a turn
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end