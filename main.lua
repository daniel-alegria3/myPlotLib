-- REGULAR FUCTIONS

function function1(x)
    local y = {}

    if x < 4  then y[1] = -(x - 4) end
    if x == 4 then y[2] = 4 end
    if x > 4  then y[3] = x - 4 end

    return y
end

function function2(x)
    local y = {}
    
    local h,v, r = 0,0, 5  
    
    y[1] =  ( r^2 - (x-h)^2 )^0.5 + v
    y[2] = -(( r^2 - (x-h)^2 )^0.5) + v
    
    return y
end

function love.load()
    -- Plot Objects
    functions_table = {
        func1 = {func = function1, color = {1.0, 0.2, 0.5}, ssNum=3}, -- "Solution Set Number"
        func2 = {func = function2, color = {1.0, 1.0, 0.0}, ssNum=2},
        func3 = {func = function(x) return x^2 end, color = {0.0, 1.0, 1.0}}
    }


    -- Background, Fonts and Text
    love.graphics.setBackgroundColor(40/255, 42/255,54/255)
    mainFont = love.graphics.newFont("JetBrains_Mono.ttf", 12)
    love.graphics.setFont(mainFont)
    text = love.graphics.newText(love.graphics.getFont())
    --

    dim = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight()
    }
    relOrg = {x=dim.width/2, y=dim.height/2} -- Absolute coordinates of the relative Origin

    axisSeg = { -- The lenght of the segment between numbers
        x = {min=50, max=100, step=1, curr=50},
        y = {min=50, max=100, step=1, curr=50},
    }

    segLen = {x=5, y=5} -- The lenght of each "number segment"

    winPadding = { -- Absolute coordinates of the Frame Borders
        left=100, right=100, top=100, bottom=100,
    }

    updateStuff = function()
        absFrame = { -- Absolute coordinates of the Frame Borders
            x0 = winPadding.left ,
            xf = dim.width - winPadding.right ,
            y0 = winPadding.top ,
            yf = dim.height - winPadding.bottom ,
        }

        relFrame = { -- Relative coordinates of the Frame Borders
            x0 = absFrame.x0 - relOrg.x,
            xf = absFrame.xf - relOrg.x,
            y0 = absFrame.y0 - relOrg.y,
            yf = absFrame.yf - relOrg.y,
        }

        segNum = { -- The number of "number segments"
            x0 = math.floor(relFrame.x0/axisSeg.x.curr),
            xf = math.floor(relFrame.xf/axisSeg.x.curr),
            y0 = math.floor(relFrame.y0/axisSeg.y.curr),
            yf = math.floor(relFrame.yf/axisSeg.y.curr),
        }
    
        stencilFunc = function() 
            love.graphics.rectangle("fill", relFrame.x0, relFrame.y0, relFrame.xf-relFrame.x0, relFrame.yf-relFrame.y0) 
        end
    end

    updateStuff()

end


function love.update(dt)
end

-- USEFUL FUNCTIONS

function isInAbsFrame(axis, arg1, arg2, arg3) -- arg(1|2|3) could be an axis, a coordinate or a "Margin Error"
    local mrgerr

    if axis == "x" then
        mrgerr = arg2 or 0
        x = arg1
        local inX = (absFrame.x0 - mrgerr < x and x < absFrame.xf + mrgerr)
        return inX
        
    elseif axis == "y" then
        mrgerr = arg2 or 0
        y = arg1
        local inY = (absFrame.y0 - mrgerr < y and y < absFrame.yf + mrgerr)
        return inY
        
    elseif axis == "both" then
        mrgerr = arg3 or 0
        x, y = arg1, arg2
        local inX = (absFrame.x0 - mrgerr < x and x < absFrame.xf + mrgerr)
        local inY = (absFrame.y0 - mrgerr < y and y < absFrame.yf + mrgerr)
        return inX and inY
        
    else error("Bad axis string") end
    
end

function isInRelFrame(axis, arg1, arg2, arg3) -- this are the relative coors
    local mrgerr
    
    if axis == "x" then
        mrgerr = arg2 or 0
        x = arg1
        local inX = (relFrame.x0 - mrgerr < x and x < relFrame.xf + mrgerr)
        return inX
        
    elseif axis == "y" then
        mrgerr = arg2 or 0
        y = arg1
        local inY = (relFrame.y0 - mrgerr < y and y < relFrame.yf + mrgerr)
        return inY
        
    elseif axis == "both" then
        mrgerr = arg3 or 0
        x, y = arg1, arg2
        local inX = (relFrame.x0 - mrgerr < x and x < relFrame.xf + mrgerr)
        local inY = (relFrame.y0 - mrgerr < y and y < relFrame.yf + mrgerr)
        return inX and inY
        
    else error("Bad axis string") end

end


-- RESIZE CALLBACK
function love.resize(w, h)
    dim.width, dim.height = w, h
    updateStuff()
end


-- ZOOM IMPLEMENTATION
function axisZoom(axis, coor)
    tabl = axisSeg[axis]
    
    local newXcurr = tabl.curr + coor*2

    if newXcurr > tabl.max then
        tabl.curr = tabl.min + newXcurr - tabl.max
        tabl.step = tabl.step/2
    elseif newXcurr < tabl.min then
        tabl.curr = tabl.max - (tabl.min - newXcurr)
        tabl.step = tabl.step*2
    else
        tabl.curr = newXcurr
    end
end

function love.wheelmoved(x, y)
    -- y is the direction of the mousewheel, x is like a horizontal wheel
    axisZoom("x", y)
    axisZoom("y", y)
    updateStuff()
end


-- MOUSE CALLBACKS
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if isInAbsFrame("both", x,y) then
            action = "updateRelOrg"
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if action == nil then return end
    if isInAbsFrame("both", x,y) then
        if action == "updateRelOrg" then
            relOrg.x, relOrg.y = relOrg.x + dx, relOrg.y + dy
            updateStuff()
        end
    else action = nil end
end

function love.mousereleased(x, y, button, istouch, presses)
    action = nil
end


-- AXIS BLITING
function drawAxisX()
    
    -- blit X axis
    love.graphics.setColor(1,1,1)
    if isInRelFrame("y", 0) then love.graphics.line(relFrame.x0, 0, relFrame.xf, 0) end
    
    -- X axis segments and its numbers
    for i=segNum.x0, segNum.xf+1, 1 do
        love.graphics.setColor(1,1,1)

        -- skip at origin
        if i == 0 then goto continue end
        
        local xcoor = i*axisSeg.x.curr
        text:set(i*axisSeg.x.step)

        if isInRelFrame("y", 0, segLen.x + text:getHeight()) then
            -- blit the segments
            love.graphics.line(xcoor, -segLen.x, xcoor, segLen.x)
            -- blit the numbers
            love.graphics.print(
                i*axisSeg.x.step,
                xcoor - text:getWidth()/2,
                segLen.x
            )
        end

        -- Vertical Grid lines
        love.graphics.setColor(1,1,1,0.1)
        love.graphics.line(xcoor, relFrame.y0, xcoor, relFrame.yf)

        ::continue::
    end
    
end

function drawAxisY()
    
    -- blit Y axis
    love.graphics.setColor(1,1,1)
    if isInRelFrame("x", 0) then love.graphics.line(0, relFrame.y0, 0, relFrame.yf) end
    
    -- Y segments and its numbers
    for i=segNum.y0, segNum.yf+1, 1 do 
        love.graphics.setColor(1,1,1)

        -- skip at origin
        if i == 0 then goto continue end
        
        local ycoor = i*axisSeg.y.curr
        text:set(tostring(-i*axisSeg.x.step))
        
        if isInRelFrame("x", 0, segLen.y + text:getWidth()) then 
            -- blit the segments
            love.graphics.line(-segLen.y, ycoor, segLen.y, ycoor)
            -- blit the numbers
            love.graphics.print(
                tostring(-i*axisSeg.x.step),
                -segLen.y-text:getWidth() -3 ,
                ycoor - text:getHeight()/2
            )
        end

        -- Horizontal Grid lines
        love.graphics.setColor(1,1,1,0.1)
        love.graphics.line(relFrame.x0, ycoor, relFrame.xf, ycoor)

        ::continue::
    end
end

-- FUNCTION DRAWER
function getFuncPoints(obj)
    local isDiv = {}

    local xratio = axisSeg.x.curr/axisSeg.x.step
    local yratio = axisSeg.y.curr/axisSeg.y.step
    
    obj.ssNum = obj.ssNum or 1
    local ssPoints = {}
    for i=1, obj.ssNum, 1 do ssPoints[i] = {} end

    for x=relFrame.x0, relFrame.xf, 0.01 do -- step is accuracy
        local ySS = obj.func(x/xratio)
        if type(ySS) == "number" then ySS = {ySS} end -- check if ySS is truly a solution set
        
        for i=1, obj.ssNum, 1 do
            local points = ssPoints[i]

            if ySS[i] and ySS[i] == ySS[i] then
                ------------------
                local y = -ySS[i]*yratio

                if y and isInRelFrame("y", y) then
                    table.insert(points, x)
                    table.insert(points, y)

                elseif points[#points] ~= "nil" then
                    table.insert(points, "nil")
                    isDiv[i] = true

                end
                ------------------
            end
        end

    end

    return ssPoints, isDiv
end

function drawFunc(obj)
    love.graphics.setColor(unpack(obj.color))

    local ssPoints, isDiv = getFuncPoints(obj)

    for i=1, obj.ssNum, 1 do
        local points = ssPoints[i]
        ------------------
        if isDiv[i] then

            local part = {}
            for _, coor in ipairs(points) do

                if coor ~= "nil" then
                    table.insert(part, coor)

                elseif coor == "nil" and #part >= 4 then
                    love.graphics.line(part)
                    part = {}
                end
                
            end
            
            points = part
        end
            
        if #points >= 4 then 
            love.graphics.line(points)
        end
        ------------------
    end

end

-- LOVE.DRAW
function love.draw()
    love.graphics.push() -- Draw the scene at an offset of relOrg.x, relOrg.y
    love.graphics.translate(relOrg.x, relOrg.y)

        -- Draw a Frame
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle(
            "line", 
            relFrame.x0, 
            relFrame.y0, 
            relFrame.xf-relFrame.x0,
            relFrame.yf-relFrame.y0
        )      

            drawAxisX()
            drawAxisY()
            
            for _, obj in pairs(functions_table) do
                drawFunc(obj)
            end


    love.graphics.pop() -- restores coordinate system to the one of the previous push()

    -- Draw relative coors
    love.graphics.setColor(1,1,1)
    love.graphics.print(relOrg.x, 30, 30)
    love.graphics.print(relOrg.y, 80, 30)
end