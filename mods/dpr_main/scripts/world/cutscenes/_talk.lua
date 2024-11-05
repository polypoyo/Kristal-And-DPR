return {
    ---@param cutscene WorldCutscene
    main = function(cutscene, map, partyleader)
        if map == "grey_cliffside/cliffside_start" then
            if partyleader == "hero" then
                local hero = cutscene:getCharacter("hero")
                local heroFacing = hero.sprite.facing
                if #Game.party == 1 and not Game:getFlag("cliffside_askedDeltaWarrior") then
                    hero:setFacing("down")
                    cutscene:textTagged("* Well,[wait:5] here we are,[wait:5] our mission begins now.", nil, "hero")
                    cutscene:textTagged("* Say,[wait:5] you wouldn't happen to know whoever's responsible for this,[wait:5] would you?", nil, "hero")
                    local choicer = cutscene:choicer({"Yes", "Nope"})
                    if choicer == 1 then
                        cutscene:textTagged("* Great,[wait:5] what do they look like?", nil, "hero")
                        choicer = cutscene:choicer({"You But\nBlue", "Purple\nLizard", "Fluffy Goat", "Deer Girl"})
                        if choicer == 1 then
                            Game:setFlag("cliffside_askedDeltaWarrior", "kris")
                        elseif choicer == 2 then
                            Game:setFlag("cliffside_askedDeltaWarrior", "susie")
                        elseif choicer == 3 then
                            Game:setFlag("cliffside_askedDeltaWarrior", "ralsei")
                        else
                            Game:setFlag("cliffside_askedDeltaWarrior", "noelle")
                        end
                        cutscene:textTagged("* Got it.[wait:10]\n* I'll keep that in mind.", nil, "hero")
                    else
                        Game:setFlag("cliffside_askedDeltaWarrior", "dunno")
                        cutscene:textTagged("* Well it was worth a shot.", nil, "hero")
                        cutscene:textTagged("* Let's keep going, then.", nil, "hero")
                    end
                    hero:setFacing(heroFacing)
                elseif #Game.party == 1 and Game:getFlag("cliffside_askedDeltaWarrior") ~= "dunno" then
                    hero:setFacing("down")
                    if Game:getFlag("cliffside_askedDeltaWarrior") == "kris" then
                        cutscene:textTagged("* Someone who looks like me but blue...", nil, "hero")
                    elseif Game:getFlag("cliffside_askedDeltaWarrior") == "susie" then
                        cutscene:textTagged("* A purple lizard...", nil, "hero")
                    elseif Game:getFlag("cliffside_askedDeltaWarrior") == "ralsei" then
                        cutscene:textTagged("* Some kind of fluffy goat...", nil, "hero")
                    else
                        cutscene:textTagged("* Some sort of deer girl...", nil, "hero")
                    end
                    cutscene:textTagged("* I'll keep that in mind.", nil, "hero")
                    hero:setFacing(heroFacing)
                elseif #Game.party == 1 then
                    hero:setFacing("down")
                    cutscene:textTagged("* Let's keep going.", nil, "hero")
                    hero:setFacing(heroFacing)
                else
                end
            end
        elseif map == "field" then
            cutscene:text("* (You give a moment of silence for those in need...)")
            cutscene:text("[speed:0.1]* (...)\n[wait:10](...)\n[wait:10](...)")
            cutscene:text("* (There will always be hope.)")
        else
            cutscene:text("* (But your voice echoed aimlessly.)")
        end
    end,
}