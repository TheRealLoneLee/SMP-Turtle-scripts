local attack_fail = 0
local entity_indicator = 0
wall_number = 1
height_indicator = 0
down_indicator = 0
attack_action = {
    [0] = function ()
        if not turtle.detect() then
            if not turtle.detectDown() then
                if height_indicator > 0 then
                    local height_indicator_temp = height_indicator
                    for move = 1,height_indicator do
                        if not turtle.detectDown() then
                            turtle.down()
                            height_indicator_temp = height_indicator_temp - 1
                        else
                            attack_action[0]()
                            do break end
                        end
                    end
                    height_indicator = height_indicator_temp
                else
                    while not turtle.detectDown() do
                        turtle.down()
                        height_indicator = height_indicator - 1
                    end
                    if not turtle.detect() then
                        turtle.forward()
                    else
                        while height_indicator < 0 do
                            turtle.up()
                            height_indicator = height_indicator + 1
                            if not turtle.detect() then
                                if height_indicator ~= 0 then
                                    down_indicator = 1
                                    do break end
                                end
                            end
                        end
                        turtle.forward()
                    end
                end
            elseif not turtle.detectUp() then
                if height_indicator < 0 and down_indicator == 0 then
                    local height_indicator_temp = height_indicator
                    for move = 1,height_indicator do
                        if not turtle.detectUp() then
                            turtle.up()
                            height_indicator_temp = height_indicator_temp + 1
                        else
                            attack_action[0]()
                            do break end
                        end
                    end
                    height_indicator = height_indicator_temp
                else
                    turtle.forward()
                end
            else
                turtle.forward()
            end
        else
            if down_indicator == 0 then
                for turn = 1,3 do
                    if wall_number == 1 then
                        turtle.turnRight()
                    else
                        turtle.turnLeft()
                    end
                    if not turtle.detect() then
                        turtle.forward()
                        if wall_number == 1 then
                            turtle.turnRight()
                            wall_number = wall_number + 1
                        else
                            turtle.turnLeft()
                            wall_number = 1
                        end
                        do break end
                    elseif turn == 3 then
                        if not turtle.detectUp() then
                            turtle.up()
                            height_indicator = height_indicator + 1
                        else
                            if not turtle.detectDown() then
                                turtle.down()
                                height_indicator = height_indicator - 1
                            end
                        end
                        turtle.turnRight()
                    end
                end
            else
                while height_indicator < 0 do
                    if not turtle.detectUp() then
                        turtle.up()
                        height_indicator = height_indicator + 1
                        if not turtle.detect() then
                            if height_indicator < 0 then
                                do break end
                            else
                                down_indicator = 0
                                do break end
                            end
                        end
                    else
                        down_indicator = 0
                        do break end
                    end
                end
                turtle.forward()
            end
        end
    end,
    [1] = function (attack_fail,knockback_distance,entity_indicator)
        local aa_loop_count_1 = 0
        while turtle.attack() do
            entity_indicator = 1
            aa_loop_count_1 = aa_loop_count_1 + 1
            attack_fail = 0
            if not turtle.detect() then
                for knockback_compensation = 1,knockback_distance do 
                    turtle.forward() 
                end
            end
        end
        if aa_loop_count_1 == 0 then 
            attack_fail = attack_fail + 1 
        end
        if attack_fail == 4 then
            if entity_indicator == 1 then
                attack_action[4](knockback_distance,entity_indicator)
            else
                attack_action[0]()
            end
        elseif not turtle.detectUp() then
            attack_action[2](attack_fail,knockback_distance,entity_indicator)
        elseif not turtle.detectDown() then
            attack_action[3](attack_fail,knockback_distance,entity_indicator)
        else
            attack_action[1](3,knockback_distance,entity_indicator)
        end
    end,
    [2] = function (attack_fail,knockback_distance,entity_indicator)
        local aa_loop_count_2 = 0
        while turtle.attackUp() do
            entity_indicator = 1
            aa_loop_count_2 = aa_loop_count_2 + 1
            attack_fail = 0
        end
        if aa_loop_count_2 == 0 then 
            attack_fail = attack_fail + 1 
        end
        if attack_fail == 4 then
            if entity_indicator == 1 then
                attack_action[4](knockback_distance,entity_indicator)
            else
                attack_action[0]()
            end
        elseif not turtle.detectDown() then
            attack_action[3](attack_fail,knockback_distance,entity_indicator)
        elseif not turtle.detect() then
            attack_action[1](attack_fail,knockback_distance,entity_indicator)
        else
            attack_action[2](3,knockback_distance,entity_indicator)
        end
    end,
    [3] = function (attack_fail,knockback_distance,entity_indicator)
        local aa_loop_count_3 = 0
        while turtle.attackDown() do
            entity_indicator = 1
            aa_loop_count_3 = aa_loop_count_3 + 1
            attack_fail = 0
        end
        if aa_loop_count_3 == 0 then 
            attack_fail = attack_fail + 1 
        end
        if attack_fail == 4 then
            if entity_indicator == 1 then
                attack_action[4](knockback_distance,entity_indicator)
            else
                attack_action[0]()
            end
        elseif not turtle.detect() then
            attack_action[1](attack_fail,knockback_distance,entity_indicator)
        elseif not turtle.detectUp() then
            attack_action[2](attack_fail,knockback_distance,entity_indicator)
        else
            attack_action[3](3,knockback_distance,entity_indicator)
        end
    end,
    [4] = function (knockback_distance,entity_indicator)
        for turn = 1,3 do
            turtle.turnRight()
            if not turtle.detect() then
                if turtle.attack() then
                    attack_action[1](0,knockback_distance,entity_indicator)
                    do break end
                end
            end
            if not turtle.detectUp() then
                if turtle.attackUp() then
                    attack_action[2](0,knockback_distance,entity_indicator)
                    do break end
                end
            end
            if not turtle.detectDown() then
                if turtle.attackDown() then
                    attack_action[3](0,knockback_distance,entity_indicator)
                    do break end
                end
            end
            if turn == 3 then
                turtle.turnRight()
            end
        end
        attack_action[0]()
    end
}
local knockback_distance = 3
local equip_slot_left = {
    ['Equipped'] = 0,
    ['Check'] = 0
}
local equip_slot_right = {
    ['Equipped'] = 0,
    ['Check'] = 0
}
for slot = 1,16 do
    if turtle.getItemCount(slot) == 0 then
        turtle.select(slot)
        if equip_slot_left['Equipped'] == 0 and equip_slot_left['Check'] == 0 then
            if turtle.equipLeft() then
                turtle.equipLeft()
                equip_slot_left['Equipped'] = 1
            end
            equip_slot_left['Check'] = 1
        end
        if equip_slot_right['Equipped'] == 0 and equip_slot_right['Check'] == 0 then
            if turtle.equipRight() then
                turtle.equipRight()
                equip_slot_right['Equipped'] = 1
            end
            equip_slot_right['Check'] = 1
        end
    end
    if equip_slot_left['Equipped'] == 1 and equip_slot_right['Equipped'] == 1 then
        do break end
    end
end
if turtle.getSelectedSlot() ~= 1 then
    turtle.select(1)
end
repeat
    if equip_slot_left['Equipped'] == 0 or equip_slot_right['Equipped'] == 0 then
        for slot = 1,16 do
            if turtle.getItemCount(slot) ~= 0 then
                turtle.select(slot)
                if equip_slot_left['Equipped'] == 0 then
                    if turtle.equipLeft() then
                        equip_slot_left['Equipped'] = 1
                    end
                elseif equip_slot_right['Equipped'] == 0 then
                    if turtle.equipRight() then
                        equip_slot_right['Equipped'] = 1
                    end
                end
                if equip_slot_left['Equipped'] == 1 and equip_slot_right['Equipped'] == 1 then
                    do break end
                end
            end
        end
        if turtle.getSelectedSlot() ~= 1 then
            turtle.select(1)
        end
    end
    if turtle.getFuelLimit() ~= 0 and turtle.getFuelLevel() == 0 then
        for slot = 1,16 do
            if turtle.getFuelLevel() ~= turtle.getFuelLimit() then
                if turtle.getItemCount(slot) ~= 0 then
                    turtle.select(slot)
                    if turtle.getItemCount() <= turtle.getFuelLimit() - turtle.getFuelLevel() then
                        turtle.refuel()
                    else
                        turtle.refuel(turtle.getFuelLimit() - turtle.getFuelLevel())
                    end
                end
            else
                do break end
            end
        end
        if turtle.getSelectedSlot() ~= 1 then
            turtle.select(1)
        end
    end
    entity_indicator = 0
    if not turtle.detect() then
        attack_action[1](attack_fail,knockback_distance,entity_indicator)
    elseif not turtle.detectUp() then
        attack_action[2](attack_fail,knockback_distance,entity_indicator)
    elseif not turtle.detectDown() then
        attack_action[3](attack_fail,knockback_distance,entity_indicator)
    else
        attack_action[0]()
    end
until false