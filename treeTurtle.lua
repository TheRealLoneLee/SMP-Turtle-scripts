-- Check fuel

function checkFuel()
  local fuelLevel = turtle.getFuelLevel()
  if fuelLevel < 10 then
    print("Fuel level is low, waiting for fuel...")
    while turtle.getItemCount(16) == 0 do
      os.sleep(1) -- Wait for 1 second before checking again
    end
    print("Fuel found, refueling...")
    turtle.select(16)
    turtle.refuel(15)
    print("Refueled")
    return false
  end
  return true
end

-- Plant saplings

function plantSapling()
  local success, data = turtle.inspect()
  if data.name == "minecraft:oak_log" or data.name == "treechop:chopped_log_entity" then
    print("Found tree, cutting...")
    turtle.dig()
    while turtle.getItemCount(1) == 0 do
      os.sleep(1) -- Wait for 1 second before checking again
    end
    turtle.select(1)
    turtle.place()
    print("Sapling planted")
  end
end

-- Cut trees

function fellTree()
  local success, data = turtle.inspect()
  if data.name == "minecraft:oak_log" or data.name == "treechop:chopped_log_entity" then
    print("Found tree, cutting...")
    turtle.dig()
    while turtle.getItemCount(1) == 0 do
      os.sleep(1) -- Wait for 1 second before checking again
    end
    turtle.select(1)
    turtle.place()
    print("Sapling planted")
  end
end

-- Main loop

local startup = true
while true do 
  if startup then
    if fuelLevel < 10 then
    print("Fuel level is low, waiting for fuel...")
    while turtle.getItemCount(16) == 0 do
      os.sleep(1) -- Wait for 1 second before checking again
    end
    print("Fuel found, refueling...")
    turtle.select(16)
    turtle.refuel(1)
    print("Refueled")
    return false
  end
      startup = false
  end
  
  if not startup then
    plantSapling()
    fellTree()
  end
  
  turtle.suck()
  turtle.forward()
  turtle.forward()
  turtle.forward()
end
