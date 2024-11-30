---@type table<string, fun(cutscene: WorldCutscene, master: NPC)>
local tutorialmaster = {
    bepis = function(cutscene, master)
        cutscene:setTextboxTop(true)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Bepi Master.\n[wait:5]* Ask me about BEPI's.")
        local choices = { "Pipis", "2", "3" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            master:setAnimation({ "idle" })
            cutscene:text("* This question is out of my domain")
            master:setAnimation({ "bop" })
            cutscene:text("* So how about you wake up and taste the [color:red]pain[color:reset]?")
        elseif c == 2 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING TWO.")
        elseif c == 3 then
            cutscene:text("* Three's an odd number.")
            if Utils.containsValue(Game.party, Game:getPartyMember("susie")) then
                cutscene:text("* Even I could tell you that, no wonder.", "smile", "susie")
                master:setAnimation({ "shocked" })
                cutscene:text("* I.. I meant it FIGURATIVELY!")
            end
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] kid.")
        end
        master:setAnimation({ "idle" })
    end
}
return tutorialmaster
