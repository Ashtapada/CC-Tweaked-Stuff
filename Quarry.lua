print("Place an Item storage directly behind me.")
print()

local useCoal = "maybe"
while useCoal ~= ("y" or "n") do 
    print("Should the turtle auto use coal as Fuel(Y/N).")
    term.write("Use Fuel: ")
    useCoal = string.lower(tostring(read()))
end

print()
print("Blocks in front of the Turtle.")
print("Include the block the Turtle is on.")
term.write("Length: ")
local length = tonumber(read()) - 1

print()
print("Blocks to the right of the Turtle.")
print("Include the block the Turtle is on.")
term.write("Width: ")
local width = tonumber(read()) - 1

print()
print("How tall should the Quarry be.")
term.write("Height: ")
local height = tonumber(read())

print()
print("Blocks down to begin Quarry at.")
term.write("Depth: ")
local depth = tonumber(read()) - 1

local currentY = 0 + depth

local currentHeight = 0

local direction = "left"

local canDigUp = true
local canDigDown = true
local keepDigging = true

if height == 1 then
    canDigUp = false
    canDigDown = false
end

if height == 2 then canDigUp = false end

function CountBlocksAndMove()
    local blockCount = 0
    while turtle.detect() == false do
        blockCount = blockCount + 1
        turtle.forward()
    end
    return blockCount
end

function ReturnAndStoreItems()
    for n = 0, currentY, 1 do turtle.up() end
    for n = 1, 16, 1 do
        turtle.select(n)
        turtle.drop()
    end
    turtle.select(1)
    for n = 0, currentY, 1 do turtle.down() end
    for n = 1, 2, 1 do turtle.turnRight() end
end

function DumpItems()
    local blockCountOne = 0
    local blockCountTwo = 0
    if direction == "left" then
        turtle.turnLeft()
        blockCountOne = CountBlocksAndMove()
        turtle.turnLeft()
        blockCountTwo = CountBlocksAndMove()
        ReturnAndStoreItems()
        for n = 1, blockCountTwo, 1 do turtle.forward() end
        turtle.turnRight()
        for n = 1, blockCountOne, 1 do turtle.forward() end
        turtle.turnLeft()
    else
        turtle.turnRight()
        blockCountOne = CountBlocksAndMove(blockCountOne)
        turtle.turnLeft()
        blockCountTwo = CountBlocksAndMove(blockCountTwo)
        ReturnAndStoreItems()
        for n = 1, blockCountTwo, 1 do turtle.forward() end
        turtle.turnRight()
        for n = 1, blockCountOne, 1 do turtle.forward() end
        turtle.turnRight()
    end
end

function DigToDepth(depth)
    for n = 0, depth, 1 do
        turtle.digDown()
        turtle.down()
    end
end

function DigAndMoveForward()
    while turtle.detect() do turtle.dig() end
    turtle.forward()
end

function DigAround(count)
    while count ~= 0 do
        if canDigUp then while turtle.detectUp() do turtle.digUp() end end
        if canDigDown then while turtle.detectDown() do turtle.digDown() end end
        DigAndMoveForward()
        if turtle.getItemCount(16) > 0 then DumpItems() end
        count = count - 1
    end
end

function DigLayer()
    for count = 0, width, 1 do
        DigAround(length)
        if count ~= width then Turn() end
    end
    currentHeight = currentHeight + 3
end

function AutoRefuel()
    if useCoal == "y" then
        for i = 1, 16, 1 do
            local itemData
            if turtle.getItemCount(i) > 0 then itemData = turtle.getItemDetail(i)
                if string.lower(itemData.name) == "coal" then
                    turtle.select(i)
                    turtle.refuel()
                end
            end
        end
    end
end

function Turn()
    if direction == "left" then
        turtle.turnRight()
        direction = "right"
        DigAround(1)
        turtle.turnRight()
    else
        turtle.turnLeft()
        direction = "left"
        DigAround(1)
        turtle.turnLeft()
    end
end

function ReturnToLayerStart()
    if direction == "left" then
        turtle.turnLeft()
        for n = 1, width, 1 do DigAndMoveForward() end
        turtle.turnLeft()
        for n = 1, length, 1 do DigAndMoveForward() end
        for n = 1 , 2, 1 do turtle.turnRight() end
    else
        turtle.turnRight()
        for n = 1, width, 1 do DigAndMoveForward() end
        turtle.turnRight()
        direction = "left"
    end
end

function DigToNextLayer()
    if currentHeight + 3 <= height then 
        DigToDepth(3)
        currentY = currentY + 3
    elseif currentHeight + 2 == height then 
        DigToDepth(2)
        currentY = currentY + 2
    elseif currentHeight + 1 == height then
        DigToDepth(1)
        currentY = currentY + 1
    else
        keepDigging = false
        print("Finished!")
    end
end

function StartDig()
    if depth > 0 then DigToDepth(depth) end
    while keepDigging do
        DigLayer()
        AutoRefuel()
        ReturnToLayerStart()
        DigToNextLayer()
    end
end

StartDig()