-- REGULAR FUCTIONS
function function1(x)
    return (2*x^2)/(x^2-9)
    -- return  math.abs(x+3) + math.abs(x-3)
    -- return math.sin(x)
end

function function2(x)
    local h,v, r = 0,0, 5  
    local y = {}
        y[1] = (r^2 - (x-h)^2)^0.5 + v
        y[2] = -(r^2 - (x-h)^2)^0.5 + v
    return y
end

function love.load()
    -- Background, Fonts and Text
    love.graphics.setBackgroundColor(40/255, 42/255,54/255)
    mainFont = love.graphics.newFont("JetBrains_Mono.ttf", 12)
    love.graphics.setFont(mainFont)
    text = love.graphics.newText(love.graphics.getFont())
    --

    -- Constants
    dim = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight()
    }
    relOrg = {x=dim.width/2, y=dim.height/2} -- Absolute coordinates of the relative Origin
    axisSeg = { -- The lenght of the segment between numbers
        x = {min=50, max=100, step=1, curr=50},
        y = {min=50, max=100, step=1, curr=50}
    }
    segLen = {x=5, y=5} -- The lenght of each "number segment"

    winPadding = { -- Absolute coordinates of the Frame Borders
        left=200, right=200, top=150, bottom=150,
    }

    updateStuff = function()
        absFrame = { -- Absolute coordinates of the Frame Borders
            x0 = winPadding.left ,
            xf = dim.width - winPadding.right ,
            y0 = winPadding.top ,
            yf = dim.height - winPadding.bottom ,
        }

        relFrame = { -- Relative coordinates of the Frame Borders
            x0 = winPadding.left - relOrg.x ,
            xf = dim.width - winPadding.right - relOrg.x ,
            y0 = winPadding.top - relOrg.y ,
            yf = dim.height - winPadding.bottom - relOrg.y ,
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

    -- Plot Objects
    func1 = {func = function1, color = {1,0.2,0.5}}
    func2 = {func = function2, color = {1,1,0}}

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


-- MOUSE CALLBACK
function love.mousepressed(x, y, button, istouch, presses)
    print(button)
    if button == 1 then
        if isInAbsFrame("both", x,y) then
            action = "updateAbsOrg"
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if action == nil then return end
    if isInAbsFrame("both", x,y) then
        if action == "updateAbsOrg" then
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
    love.graphics.setColor(1,1,1)
            
    -- X axis
    if isInRelFrame("y", 0) then love.graphics.line(relFrame.x0, 0, relFrame.xf, 0) end
    
    -- X segments and its numbers
    if isInRelFrame("y", 0, segLen.x + mainFont:getHeight()) then
        for i=segNum.x0, segNum.xf+1, 1 do
            
            if i == 0 then goto continue end
            
            local xcoor = i*axisSeg.x.curr
            text:set(tostring(i*axisSeg.x.step))
            
            -- blit the segments
            love.graphics.line(xcoor, -segLen.x, xcoor, segLen.x)
            -- blit the numbers
            if true then -- showNums is the boolean
                love.graphics.print(
                    tostring(i*axisSeg.x.step),
                    xcoor - text:getWidth()/2,
                    segLen.x
                )
            end
            ::continue::
        end
    
    end
end

function drawAxisY()
    -- Y axis 
    if isInRelFrame("x", 0) then love.graphics.line(0, relFrame.y0, 0, relFrame.yf) end
            
    -- Y segments and its numbers
    for i=segNum.y0, segNum.yf+1, 1 do 
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
        ::continue::
    end
end

function drawFunc(func)
    love.graphics.setColor(unpack(func.color))
    
    if type(func.func(0)) == "table" then
        if #func.func(0) == 2 then
            local points1, points2 = {}, {}
            for x=relFrame.x0, relFrame.xf, 1 do
                local y1 = func.func(x/(axisSeg.x.curr/axisSeg.x.step))[1]*(axisSeg.y.curr/axisSeg.y.step)
                local y2 = func.func(x/(axisSeg.x.curr/axisSeg.x.step))[2]*(axisSeg.y.curr/axisSeg.y.step)
                if isInRelFrame("y", y1, 10) then
                    table.insert(points1, x)
                    table.insert(points1, y1)
                elseif #points1 >= 4 then
                    love.graphics.line(unpack(points1))
                    points1 = {}
                end

                if isInRelFrame("y", y2, 10) then
                    table.insert(points2, x)
                    table.insert(points2, y2)
                elseif #points2 >= 4 then
                    love.graphics.line(unpack(points2))
                    points2 = {}
                end
            end
            if #points1 >= 4 then 
                love.graphics.line(unpack(points1))
            end
            if #points2 >= 4 then 
                love.graphics.line(unpack(points1))
            end
        end
        
    else
        
        local points = {}
        for x=relFrame.x0, relFrame.xf, 1 do
            local y = -func.func(x/(axisSeg.x.curr/axisSeg.x.step))*(axisSeg.y.curr/axisSeg.y.step)
            if isInRelFrame("y", y, 10) then
                table.insert(points, x)
                table.insert(points, y)
            elseif #points >= 4 then
                x2, y2 = points[#points-1], points[#points]
                x1, y1 = points[#points-3], points[#points-2]
                dx = x2 - x1
                dy = y2 - y1
                love.graphics.line(unpack(points))
                points = {}
            end

        end

        if #points >= 4 then 
            love.graphics.line(unpack(points))
        end
    end
end


-- LOVE.DRAW
function love.draw()
    love.graphics.push()
    love.graphics.translate(relOrg.x, relOrg.y) -- Draw the scene at an offset of relOrg.x, relOrg.y

        -- Draw a Frame
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", relFrame.x0, relFrame.y0, relFrame.xf-relFrame.x0, relFrame.yf-relFrame.y0)

        -- Draw circle at origin
        love.graphics.setColor(1,1,1)
        if isInRelFrame("both", 0,0) then love.graphics.circle("fill", 0, 0, 3, 50) end



        -- Each pixel touched by the func will have stencil value set to 1, the rest will be 0.
        -- love.graphics.stencil(stencilFunc, "replace", 1)
        -- Only allow rendering on pixels which have a stencil value greater than 0.
        -- love.graphics.setStencilTest("greater", 0)           
        
            drawAxisX()
            drawAxisY()
            drawFunc(func1)
            -- drawFunc(func2)
        
        -- restore rendering outside stencil function
        -- love.graphics.setStencilTest()

    love.graphics.pop() -- restores coordinate system to the one of the previous push()

    -- Draw relative coors
    love.graphics.setColor(1,1,1)
    love.graphics.print(relOrg.x, 30, 30)
    love.graphics.print(relOrg.y, 80, 30)
end