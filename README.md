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

local currentY = -1
local currentHeight = 0
local blockCountOne = 0
local blockCountTwo = 0
local direction = "left"
local keepDigging = true
local digBlock = peripheral.wrap("right")

function CountBlocksAndMove()
    local blockCount = 0
    while turtle.detect() == false do
        blockCount = blockCount + 1
        turtle.forward()
    end
    return blockCount
end

function DepositItems()
    for n = 2, 16, 1 do
        turtle.select(n)
        turtle.drop()
    end
    turtle.select(1)
end

function AscendFromCurrentY()
    for n = 0, currentY, 1 do turtle.up() end
end

function DescendToCurrentY()
    for n = 0, currentY, 1 do turtle.down() end
end

function DigToDepth(down)
    for n = 1, down, 1 do
        turtle.digDown()
        turtle.down()
    end
    currentY = currentY + 1
end

function DigAndMoveForward()
    while turtle.detect() do
        digBlock.digBlock()
        turtle.suck()
    end
    turtle.forward()
end

function Dig(count)
    while count ~= 0 do
        DigAndMoveForward()
        if turtle.getItemCount(16) > 0 then
            ReturnToOperationStart()
            DepositItems()
        end
        count = count - 1
    end
end

function DigLayer()
    for count = 0, width, 1 do
        Dig(length)
        if count ~= width then Turn() end
    end
    currentHeight = currentHeight + 1
end

function AutoRefuel()
    if useCoal == "y" then
        for n = 2, 16, 1 do
            if turtle.getItemCount(n) > 0 then
                local itemData = turtle.getItemDetail(n)
                if string.lower(itemData.name) == "coal" then
                    turtle.select(n)
                    turtle.refuel()
                end
            end
        end
    end
    turtle.select(1)
end

function Turn()
    if direction == "left" then
        turtle.turnRight()
        direction = "right"
        Dig(1)
        turtle.turnRight()
    else
        turtle.turnLeft()
        direction = "left"
        Dig(1)
        turtle.turnLeft()
    end
end

function ReturnToOperationStart()
    blockCountOne = 0
    blockCountTwo = 0
    if direction == "left" then
        turtle.turnLeft()
        blockCountOne = CountBlocksAndMove()
        turtle.turnLeft()
        blockCountTwo = CountBlocksAndMove()
    else
        turtle.turnRight()
        blockCountOne = CountBlocksAndMove()
        turtle.turnLeft()
        blockCountTwo = CountBlocksAndMove()
    end
    AscendFromCurrentY()
end

function ReturnToCurrentOperation()
    if direction == "left" then
        for n = 1, blockCountTwo, 1 do turtle.forward() end
        turtle.turnRight()
        for n = 1, blockCountOne, 1 do turtle.forward() end
        turtle.turnLeft()
    else
        for n = 1, blockCountTwo, 1 do turtle.forward() end
        turtle.turnRight()
        for n = 1, blockCountOne, 1 do turtle.forward() end
        turtle.turnRight()
    end
    for n = 1, 2, 1 do turtle.turnRight() end
    DescendToCurrentY()
end

function DigToNextLayer()
    if currentHeight ~= height then
        DigToDepth(1)
        currentHeight = currentHeight + 1
    else
        ReturnToOperationStart()
        for n = 1, 2, 1 do turtle.turnRight() end
        keepDigging = false
        print("Finished!")
    end
end

function StartDig()
    if depth > 0 then DigToDepth(depth) end
    while keepDigging do
        DigLayer()
        AutoRefuel()
        ReturnToOperationStart()
        DigToNextLayer()
    end
end

StartDig()
