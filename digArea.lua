print("Blocks in front of the Turtle")
term.write("Length: ")
local length = tonumber(read() - 1)

print()
print("Blocks to the right of the Turtle")
term.write("Width: ")
local width = tonumber(read() - 1)

print()
print("Blocks below the Turtle")
term.write("Height: ")
local height = tonumber(read() - 1)

print()
term.write("Blocks to Travel Down: ")
local depth = tonumber(read())

local direction = "left"
local canDigUp = true
local canDigDown = true

if height == 1 then 
    canDigUp = false
    canDigDown = false
end

if height == 2 then canDigUp = false end

function digDown(depth)
    turtle.digDown()
    for n = 1, depth, 1 do 
        if depth > 0 then turtle.down() end
        turtle.digDown()
    end
end

function digAndMoveForward ()
    while turtle.detect() do 
        turtle.dig() 
    end
    turtle.forward()
end

function digAround(count)
    while count ~= 0 do
        digAndMoveForward()
        if canDigUp then turtle.digUp() end
        if canDigDown then turtle.digDown() end
        count = count - 1
    end
end

function turn()
    if direction == "left" then
        turtle.turnRight()
        direction = "right"
        digAround(1)
        turtle.turnRight()
    else
        turtle.turnLeft()
        direction = "left"
        digAround(1)
        turtle.turnLeft()
    end
end

function returnToStart (width, length)
    if direction == "left" then
        turtle.turnLeft()
        for n = 1, width, 1 do digAndMoveForward() end
        turtle.turnLeft()
        for n = 1, length, 1 do digAndMoveForward() end
        turtle.turnRight(2)
    else
        turtle.turnRight()
        for n = 1, width, 1 do digAndMoveForward() end
        turtle.turnRight()
        direction = "left"
    end
end

function startDig (depth, width, length, height)
    digDown(depth)
    for currentHeight = 3, height + 3, 3 do
        for count = 0, width, 1 do
            digAround(length)
            if count ~= width then turn() end
        end

        returnToStart (width, length)
        if currentHeight + 3 < height then digDown(3)
        elseif currentHeight + 1 == height then digDown(0)
        elseif currentHeight + 2 == height then digDown(1)
        elseif currentHeight + 3 == height then print("Finished!")
        end
    end
end

startDig(depth, width, length, height)