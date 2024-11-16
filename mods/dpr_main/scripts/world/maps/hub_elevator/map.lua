local Elevator, super = Class(Map)

function Elevator:onEnter()
    Game.world.timer:after(1/30, function()
    local elevator = Game.world.map:getEvent("elevator")
    if ELEVATOR_TRANSITION then -- We've just come in from another mod

        Game.fader:fadeOut(nil, {speed = 0})


        Game.world:startCutscene(function(cutscene)            
            -- Manually restart the elevator movement. I've tried doing it with elevator:moveTo, but something always broke when I did.
            if (elevator.movecon == 0) then
                elevator.movecon = 1
            end
            elevator.con = 101
            Game.world.music:play("elevator", 0, 0.5)

            elevator.pitchcount = 0.5
            elevator.volcount = 0
            elevator.pitchtimer = 0
            elevator.continuetimer = 0
            -- Infinite, so that it won't end until we've fully faded back in.
            elevator.infinite = true

            cutscene:wait(1)
            cutscene:detachFollowers()

            -- Copy data from ELEVATOR_TRANSITION to the elevator.
            elevator.target_floor =    ELEVATOR_TRANSITION["target_floor"]
            elevator.dir =             ELEVATOR_TRANSITION["target_dir"]
            Game.world.player.x =      ELEVATOR_TRANSITION.party_data[1].x
            Game.world.player.y =      ELEVATOR_TRANSITION.party_data[1].y
            Game.world.player:setFacing(ELEVATOR_TRANSITION.party_data[1].facing)
            for i, chara in ipairs(Game.world.followers) do
                chara.x =       ELEVATOR_TRANSITION.party_data[i+1].x
                chara.y =       ELEVATOR_TRANSITION.party_data[i+1].y
                chara:setFacing(ELEVATOR_TRANSITION.party_data[i+1].facing)
            end

            Game.world.timer:tween(3, elevator, {volcount = 0.7}, "linear")
            Game.fader:fadeIn(nil, {speed = 3})
            cutscene:wait(4)
            elevator.charadjustcon = 0
            elevator.infinite = false

            cutscene:interpolateFollowers()
            cutscene:attachFollowers()

            ELEVATOR_TRANSITION = nil



        end)
        
            
            
            
            
        end
    end)
end

return Elevator