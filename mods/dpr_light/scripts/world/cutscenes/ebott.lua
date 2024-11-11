return {
    lookout = function(cutscene)
        if not Game:getFlag("hometown_ebott") then
            Game:setFlag("hometown_ebott", true)
            cutscene:detachFollowers()
            local leader = cutscene:getCharacter(Game.party[1]:getActor().id)
            if #Game.party == 1 then
                leader:walkTo(320, 305, 2, "up", "up")
            elseif #Game.party >= 2 then
                local party2 = cutscene:getCharacter(Game.party[2]:getActor().id)
                if #Game.party == 3 then
                    local party3 = cutscene:getCharacter(Game.party[3]:getActor().id)
                    
                    leader:walkTo(320, 305, 2, "up", "up")
                    party2:walkTo(240, 320, 2, "up", "up")
                    party3:walkTo(400, 320, 2, "up", "up")
                else
                    leader:walkTo(280, 305, 2, "up", "up")
                    party2:walkTo(360, 300, 2, "up", "up")
                end
            end
            cutscene:wait(2.5)
            local susie = Game:hasPartyMember("susie")
            local hero = Game:hasPartyMember("hero")
            if susie then
                cutscene:showNametag("Susie")
                cutscene:text("* Hey,[wait:5] uhh...", "", "susie")
                cutscene:text("* Has this mountain always been here?", "", "susie")
                if hero then
                    cutscene:showNametag("Hero")
                    cutscene:text("* I mean,[wait:5] a huge mountain is kinda hard to miss.", nil, "hero")
                    cutscene:text("* This might seem like a stretch,[wait:5] but...", nil, "hero")
                    cutscene:text("* Maybe it just appeared here one day?", nil, "hero")
                    cutscene:text("* Reality IS kinda unstable right now.", nil, "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Hmm...", "", "susie")
                    cutscene:text("* Well,[wait:5] that just means we get to go on another cool adventure!", "", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Sounds good to me.", nil, "hero")
                end
                cutscene:hideNametag()
            end
            cutscene:text("* (Will you climb the mountain?)")
            cutscene:text("* (You have a feeling that you won't be able to return for a while if you do.)")
            local choice = cutscene:choicer({"Yes", "No"})
            if choice == 1 then
                
            else
                cutscene:text("* (You decided not to.)")
                cutscene:wait(cutscene:attachFollowers(1))
            end
        else
            cutscene:text("* (A large mountain looms over the distance.)")
            if not Game:getFlag("ebott_cleared") then
                cutscene:text("* (Will you climb it?)")
                local choice = cutscene:choicer({"Yes", "No"})
                if choice == 1 then
                    
                else
                    cutscene:text("* (You decided not to.)")
                end
            end
        end
    end,
}