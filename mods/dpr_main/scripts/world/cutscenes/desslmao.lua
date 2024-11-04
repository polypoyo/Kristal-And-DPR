return {
	dessbegin = function(cutscene)
		local dess = cutscene:getCharacter("dess")
		local susie = cutscene:getCharacter("susie")

		if cutscene:getCharacter("noel") then
			noel_here = 1
		end

		cutscene:showNametag("Dess Holiday?")
		if #Game.party == 1 then
			cutscene:text("* Yooo hey it's great to see you again", "condescending", "dess")
		else
			cutscene:text("* Yooo hey it's great to see you guys again", "condescending", "dess")
		end
		cutscene:showNametag("Dess")
		cutscene:text("* its me,[wait:5] dess,[wait:5] from hit kristal mod dark place", "heckyeah", "dess")
        if susie then
            cutscene:showNametag("Susie")
			cutscene:text("[speed:0.5]* ...", "neutral_side", "susie")
			cutscene:text("* I have literally never seen you before in my life.", "annoyed", "susie")
		elseif cutscene:getCharacter("hero") then
			cutscene:showNametag("Hero")
            cutscene:text("* Uh,[wait:5] am I supposed to know you?", nil, "hero")
		else
			cutscene:text("[speed:0.5]* ...", "heckyeah", "dess")
			cutscene:text("* hey why are you looking at me like that", "eyebrow", "dess")
        end
		cutscene:showNametag("Dess")
		cutscene:text("* aw c'mon don't tell me you guys forgot about me", "neutral", "dess")
		local remembered = false
		if cutscene:getCharacter("noel") then
			cutscene:showNametag("Noel")
			cutscene:text("* I remember you[wait:1][react:1]", "neutral", "noel",
			{
				reactions={
					{"'re [color:red]Dessimation\nRoutes[color:reset].", "right", "bottom", "neutral", "noel"}
				}
			})
			remembered = true
		end
		if remembered then
			cutscene:showNametag("Dess")
			cutscene:text("* ayyy finally someone remembers me", "condescending", "dess")
			cutscene:text("* anyways", "calm_b", "dess")
		end
		cutscene:text("* I've been training in the hyperbolic time chamber for 20 years", "condescending", "dess")
		cutscene:text("* got a whole entire attack point out of it", "heckyeah", "dess")
		cutscene:text("* you could call me pretty strong now", "challenging", "dess")
		cutscene:text("* a side effect tho is that i lost all of my character development", "genuine", "dess")
		cutscene:text("* cause this is a reboot babyyyyy", "challenging", "dess")
		if susie then
            cutscene:showNametag("Susie")
			cutscene:text("[speed:0.5]* ...", "nervous_side", "susie")
			cutscene:text("* I have no idea what anything you just said meant.", "nervous", "susie")
			cutscene:showNametag("Dess")
		end
		cutscene:text("* Oh yeah can I join your team btw", "neutral", "dess")

		cutscene:hideNametag()
		cutscene:text("* (Can she join your team btw?)")
		local can_she_join_your_team_btw = cutscene:choicer({"Yes", "No"})

		cutscene:showNametag("Dess")
		if can_she_join_your_team_btw == 1 then
			cutscene:text("* sick", "condescending", "dess")
		else
			cutscene:text("* Uhhh I don't care im joining anyways", "condescending", "dess")
		end
		cutscene:hideNametag()

		Game.world.music:stop()
		local fan = Music("fanfare", 1, 0.9, false)

		local leader = cutscene:getCharacter(Game.party[1].id)

		cutscene:detachFollowers()
		leader:slideTo(leader.x-50, leader.y, 2, "out-cubic")

		cutscene:walkTo("dess", dess.x - 50, dess.y + 10, 11, "left")
		cutscene:text("[noskip][speed:0.1]* (Dess joined the party!)[wait:70]\n\n[speed:1](Unfortunately)", {auto = true})
		Game.world.music:resume()

		cutscene:showNametag("Dess")
		cutscene:text("* Ok follow me guys", "heckyeah", "dess")
		if susie then
            cutscene:showNametag("Susie")
			susie:setSprite("shock_right")
			cutscene:text("* Wh-", "shock", "susie")
			susie:setSprite("exasperated_right")
			cutscene:text("* THAT'S NOT HOW THIS WORKS!", "teeth_b", "susie")
			cutscene:showNametag("Dess")
			cutscene:text("* uhhhh idc", "condescending", "dess")
			cutscene:text("* just be happy i didnt smack the party leader with my bat this time", "condescending", "dess")
			cutscene:showNametag("Susie")
			cutscene:text("* I-", "teeth", "susie")
			cutscene:hideNametag()
			susie:setSprite("walk_unhappy/right_1")
			susie:shake(5)
			Assets.stopAndPlaySound("wing")
			cutscene:wait(1)
			cutscene:showNametag("Susie")
			cutscene:text("* Ughhh,[wait:5] do I have much of a choice?", "annoyed", "susie")
			cutscene:showNametag("Dess")
			cutscene:text("* mmmmnope", "smug", "dess")
			cutscene:text("* hey if it makes you feel any better", "calm", "dess")
			cutscene:text("* i'll MAYBE give the leader's position back at the end of this", "condescending", "dess")
			cutscene:text("* MAYBE", "calm_b", "dess")
			cutscene:showNametag("Susie")
			cutscene:text("* ...[wait:10] Fine,[wait:5] lead the way.", "annoyed_down", "susie")
			cutscene:showNametag("Dess")
			cutscene:text("* awesome sauce", "challenging", "dess")
		elseif cutscene:getCharacter("hero") then
			cutscene:showNametag("Hero")
            cutscene:text("* Wait what.", nil, "hero")
		end
		cutscene:hideNametag()
		cutscene:wait(cutscene:fadeOut(1))
		cutscene:wait(1)

		-- Wooo party setup time
		Game:addPartyMember("dess", 1)
		if #Game.party == 4 then
			Game.world:spawnFollower(Game.party[4].id)
			Game:addFollower(Game.party[4].id)
			Game:removePartyMember(Game.party[4].id)
		end
		for i, v in ipairs(Game.world.followers) do
			if i ~= 3 then
				v:setActor(Game.party[i+1]:getActor())
			end
		end
		local fullparty = false
		if #Game.world.followers == 3 then
			fullparty = true
		end
		Game.world.player:setActor(Game.party[1]:getActor())
		dess:remove()
		leader = Game.world.player
		cutscene:wait(cutscene:slideTo(leader, 300, 750, 0.1))
		leader:setFacing("up")
		cutscene:attachCamera()
		cutscene:wait(cutscene:attachFollowers())
		for i, v in ipairs(Game.world.followers) do
			v.x = 300
			v.y = 750 + (i*50)
			v:setFacing("up")
		end
		cutscene:interpolateFollowers()
		cutscene:wait(0.5)

		cutscene:wait(cutscene:fadeIn(1))

		if fullparty then
			--[[if susie then
				-- I'll write dialogue for this later
			else
				cutscene:showNametag("Dess")
				cutscene:text("* oh yeah btw you can only have 3 party members at once", "heckyeah", "dess")
				cutscene:text("* they had to nerf that shit", "heckyeah", "dess")
				cutscene:text("* smth about it being too overpowered", "heckyeah", "dess")
				cutscene:text("* anyways lets go", "heckyeah", "dess")
			end]]
			cutscene:showNametag("Dess")
			cutscene:text("* oh yeah btw you can only have 3 party members at once", "neutral", "dess")
			cutscene:text("* they had to nerf that shit from last time", "angry", "dess")
			cutscene:text("* smth about it being too overpowered", "neutral_b", "dess")
			cutscene:text("* anyways lets go", "heckyeah", "dess")
		else
			cutscene:showNametag("Dess")
			cutscene:text("* ok lets go", "heckyeah", "dess")
		end
		cutscene:hideNametag()

        --Kristal.callEvent("completeAchievement", "starstruck") -- Uncomment this when we've added achievements
		Game:setFlag("gotDess", true)
		Game:unlockPartyMember("dess")

		local susie_party = Game:getPartyMember("susie")
        if cutscene:getCharacter("susie") then
            susie_party:addOpinion("dess", -10)
        end
  end,

	dessgetoverhere = function(cutscene, event)
		if Game:getFlag("gotDess") then
			cutscene:showNametag("Dess")
			cutscene:text("* Hey I can do a crazy impression watch this", "condescending", "dess")
			cutscene:text("* Look at meeee I'm FRISK from UNDERTALE lmao", "calm", "dess")

            if cutscene:getCharacter("susie") then
                cutscene:showNametag("Susie")
                cutscene:text("[speed:0.5]* ...", "nervous_side", "susie")
                cutscene:text("* (Who the hell is THAT?)", "nervous", "susie")
            end
			cutscene:hideNametag()
			Game:setFlag("dessThingy", true)
			event:remove()
		else
			local leader = Game.world.player
			
			cutscene:showNametag("???")
			cutscene:text("* Hey fucker you need to come talk to me first", "neutral", "dess")
			
			cutscene:hideNametag()
            leader.y = leader.y + 12
		end
	end,

	dessboss = function(cutscene)
		local boss = cutscene:getCharacter("ufoofdoom", 1)

		local susie = cutscene:getCharacter("susie")
		local leader = Game.world.player

		cutscene:detachFollowers()
		cutscene:detachCamera()

        for i,party in ipairs (Game.world.followers) do
            cutscene:walkTo(cutscene:getCharacter(party.actor.id), leader.x, leader.y+20*i, 1, "up")
        end

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Ugh,[wait:10] alright,[wait:5] is this the last one?!", "angry", "susie")

            cutscene:showNametag("Dess")
            cutscene:text("* Yep", "neutral", "dess")

            cutscene:showNametag("Susie")
            cutscene:text("* Alright...[wait:10] let's finally get outta here.", "annoyed_down", "susie")
        else
            cutscene:showNametag("Dess")
            cutscene:text("* This area is very well designed i'm so glad i have it all to myself", "condescending", "dess")
        end
		cutscene:hideNametag()

		cutscene:wait(1)
		boss:shake(8, 0)
		Assets.stopAndPlaySound("wing")
		cutscene:wait(2)

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Did you just see that??", "surprise_frown", "susie")
            cutscene:text("* Why did it just shake?", "shy_b", "susie")
            cutscene:showNametag("Dess")
            cutscene:text("* That's normal, all the other ones shake if you hit them", "neutral", "dess")
        else
            cutscene:showNametag("Dess")
            cutscene:text("* ...", "kind", "dess")
        end

		boss:shake(8, 0)
		Assets.stopAndPlaySound("wing")

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* But...[wait:10] we didn't hit it!", "shock_down", "susie")
        else
            cutscene:text("* ...", "neutral", "dess")
        end

		boss:shake(16, 0)
		Assets.stopAndPlaySound("wing")

		cutscene:showNametag("Dess")
        if susie then
            cutscene:text("* Yo wait you're right!", "wtf_b", "dess")
        else
            cutscene:text("* Oh shit!", "wtf_b", "dess")
        end
		boss:shake(8, 0)
		Assets.stopAndPlaySound("wing")

		cutscene:showNametag("???")
		cutscene:text("* Hee...")
		boss:shake(16, 0)
		Assets.stopAndPlaySound("wing")
		cutscene:text("* Uheeheehee!!")
		cutscene:hideNametag()

		boss:fadeTo(0, 0.1, function() boss:fadeTo(1, 0.05) end)
		cutscene:panTo(boss.x, boss.y+256, 2)
		boss:slideTo(boss.x, boss.y+256, 2, "in-out-quint")

		cutscene:wait(0.8)

        for i,party in ipairs (Game.world.followers) do
            cutscene:look(cutscene:getCharacter(party.actor.id), "down")
        end
        cutscene:look(leader, "down")
        
		cutscene:wait(1.2)
		cutscene:showNametag("???")
		cutscene:text("* I'm sorry![wait:10]\n* I simply couldn't contain myself!")
		cutscene:text("* Uheehee!")

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Who the hell are you?!", "angry", "susie")
        end

		cutscene:hideNametag()

		boss:fadeTo(0.2, 0.05)
		cutscene:wait(1)
		boss:setActor("susie")
		cutscene:look(boss, "up")
		boss:fadeTo(1, 0.05)
		cutscene:wait(1)
        cutscene:showNametag("???")
        if susie then
            cutscene:text("[face:susie_bangs/smile_b][voice:susie]* I'm you!")

            cutscene:showNametag("Susie")
            cutscene:text("* Wha-?![wait:10] What the hell??", "surprise_frown", "susie")
        else
            cutscene:text("[face:susie_bangs/smile_b][voice:susie]* LOOK at me![wait:10] I'm the Angry Dino Girl!")
        end

		cutscene:hideNametag()

		boss:fadeTo(0.2, 0.05)
		cutscene:wait(1)
		boss:setActor("kris")
		cutscene:look(boss, "up")
		boss:fadeTo(1, 0.05)
		cutscene:wait(1)
		cutscene:showNametag("???")

        if susie then
            cutscene:text("* SUSIE LOOK![wait:5]\n* IT'S ME[wait:5] [color:yellow]KRIS[color:reset]!")
        else
            cutscene:text("* AND NOW I'm the blue one!")
        end
		cutscene:text("* Uheeheehee!")
		cutscene:hideNametag()

		boss:fadeTo(0.2, 0.05)
		cutscene:wait(1)
		boss:setActor("ufoofdoom")
		boss:fadeTo(1, 0.05)
		cutscene:showNametag("Dess")
		cutscene:text("* Whatever can we fight now", "condescending", "dess")

		cutscene:showNametag("???")
		cutscene:text("* ...OH![wait:10] I see!")
		cutscene:text("* ...Uheehee!")
		cutscene:text("* You're even worse than me! Uhee!")

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Uhh,[wait:10] what do they mean by that?", "nervous", "susie")

            cutscene:showNametag("???")
            cutscene:text("* Uheehee![wait:10] You're much better!")
        end
        cutscene:showNametag("???")
		cutscene:text("* It's too easy to be who you want to be!")
		cutscene:text("* I know that is not the real Dess Holiday!")

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Huh???", "surprise_frown", "susie")

            cutscene:showNametag("???")
            cutscene:text("* Don't act all surprised!")
            cutscene:text("* I know that you aren't the real Susie either!")

            cutscene:showNametag("Susie")
            cutscene:text("* ...???", "suspicious", "susie")
            cutscene:text("* Uh.", "suspicious", "susie")
            cutscene:text("* Alright,[wait:5] let's smash this guy into a pulp.", "teeth_smile", "susie")

            cutscene:showNametag("Dess")
            cutscene:text("* Agreed", "neutral", "dess")
        else
            cutscene:showNametag("Dess")
            cutscene:text("* Whatever,[wait:5]I wanna smash you already", "neutral", "dess")
        end

		cutscene:showNametag("???")
		cutscene:text("* Suit yourself![wait:5] Uheehee!")

		cutscene:hideNametag()
		cutscene:attachCamera(1)
		cutscene:startEncounter("mimicboss", true, boss)

		Game:setFlag("mimicBossDone", true)
		Game:setFlag("mimic_defeated", true)
		boss:remove()
		cutscene:attachFollowers(5)
		cutscene:wait(1)

		cutscene:showNametag("Dess")
		cutscene:text("* well that was fun", "condescending", "dess")
		cutscene:text("* so whaddaya say we all go and smoke a ciggie outside a 7-11?", "genuine", "dess")
		if susie then
			cutscene:showNametag("Susie")
			cutscene:text("* What the hell is a 7-11?", "nervous_side", "susie")
			cutscene:showNametag("Dess")
			cutscene:text("* damn that's not what you said last time", "eyebrow", "dess")
			cutscene:showNametag("Susie")
			cutscene:text("* Why do you keep acting like I'm supposed to know you?", "suspicious", "susie")
			cutscene:showNametag("Dess")
			cutscene:text("* uhhh because you are?", "condescending", "dess")
			cutscene:text("* damn this really IS a reboot", "neutral_b", "dess")
			cutscene:text("* ok tell you what,[wait:5] I'll give the leader spot back", "genuine_b", "dess")
			cutscene:text("* IF and only IF", "calm_b", "dess")
			cutscene:text("* you promise to by me a Mug:tm: Root Beer when this is all over", "condescending", "dess")
			cutscene:showNametag("Susie")
			cutscene:text("* ...[wait:10] Fine.", "suspicious", "susie")
			cutscene:text("* You are the single weirdest person I've ever met.", "annoyed", "susie")
			cutscene:showNametag("Dess")
			cutscene:text("* i'll take that as a compliment", "heckyeah", "dess")
		else
			cutscene:text("[speed:0.5]* ...", "genuine", "dess")
			cutscene:text("* dang no takers then?", "neutral_b", "dess")
			cutscene:text("* oh well more ciggies for me then", "condescending", "dess")
		end
		cutscene:hideNametag()

		local susie_party = Game:getPartyMember("susie")
        if susie then
            susie_party:addOpinion("dess", -10)
        end

		if Game:getPartyMember("dess").kills >= 9 then
			cutscene:wait(3)
			cutscene:showNametag("Dess")
			cutscene:text("* Hey actually wait", "genuine", "dess")
			cutscene:text("* wouldn't it be cool if like...", "kind", "dess")
			cutscene:text("* All of the sensless murder we've been doing like...", "condescending", "dess")
			cutscene:text("* Allowed us to actually kill people normally?", "kind", "dess")
			cutscene:showNametag("Dess", {top = true})
			cutscene:text("* That'd be a cool reference to hit Deltarune fangame made by RynoGG know as Deltatraveler where in the section 2 obliteration route you can actually kill the animals and people if you clear out all the enemies in the first few rooms", "condescending", "dess", {top = true})
			if susie then
                cutscene:showNametag("Susie")
                cutscene:text("* ...", "neutral_side", "susie")
                cutscene:text("* Oooookay then...", "neutral", "susie")
			end
			Assets.playSound("ominous")
			Game:setFlag("can_kill", true)
		end
		cutscene:showNametag("Dess")
		if #Game.world.followers == 3 then
			cutscene:text("* anyways imma be chillin in the diner if you guys need me", "kind", "dess")
			cutscene:hideNametag()
			cutscene:wait(cutscene:fadeOut(1))
			cutscene:wait(1)

			-- Party setup 2: Desslectric boogaloo
			local newparty = Game.world.followers[3].actor.id
			Game:addPartyMember(newparty)
			Game:removePartyMember("dess")
			Game.world:removeFollower(newparty)
			cutscene:getCharacter(newparty):remove()
			cutscene:wait(0.5)
			for i, v in ipairs(Game.world.followers) do
				v:setActor(Game.party[i+1]:getActor())
			end
			Game.world.player:setActor(Game.party[1]:getActor())
			cutscene:interpolateFollowers()
			cutscene:wait(0.5)

			cutscene:wait(cutscene:fadeIn(1))
		else
			cutscene:text("* ok time to stop leading", "genuine", "dess")
			cutscene:hideNametag()
			cutscene:hideNametag()

			cutscene:wait(cutscene:fadeOut(1))
			cutscene:wait(1)
			Game:movePartyMember("dess", 2)
			for i, v in ipairs(Game.world.followers) do
				v:setActor(Game.party[i+1]:getActor())
			end
			Game.world.player:setActor(Game.party[1]:getActor())
			cutscene:interpolateFollowers()
			cutscene:wait(0.5)

			cutscene:wait(cutscene:fadeIn(1))
		end
		cutscene:text("* (Dess is no longer leading the party!)")
	end,
}
