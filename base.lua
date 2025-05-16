print("Note: The turtle will mine 1 block above and below the set Depth")
print()
term.write("Depth to begin mining at: ")
local depth = tonumber(read())
print()
print("Blocks in front of the Turtle")
term.write("Length: ")
local length = tonumber(read() - 1)
print()
print("Blocks to the right of the Turtle")
term.write("Width: ")
local width = tonumber(read() - 1)
local direction = "left"

function digForward(num)
    while num ~= 0 do
        while turtle.detect() do turtle.dig() end
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
        num = num - 1
    end
end

function moveBack(num)
    while num ~= 0 do
        turtle.back()
        num = num - 1
    end
end

function turn()
    if direction == "left" then
        turtle.turnRight()
        direction = "right"
        digForward(1)
        turtle.turnRight()
    else
        turtle.turnLeft()
        direction = "left"
        digForward(1)
        turtle.turnLeft()
    end
end

function digDown(d)
    turtle.digDown()
    for n = 1, d, 1 do 
        if d > 0 then turtle.down() end
        turtle.digDown()
    end
end

function digHole (w, l)
    for n = 0, w, 1 do
        print(n)
        digForward(l)
        if n ~= w then turn() end
    end
end

digDown(depth)
digHole(width, length)
