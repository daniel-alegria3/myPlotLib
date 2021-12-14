function love.load()
    -- Background and Fonts
    love.graphics.setBackgroundColor(40/255, 42/255,54/255)
    mainFont = love.graphics.newFont("JetBrains_Mono.ttf", 12)
    love.graphics.setFont(mainFont)

    -- Constants
    dim = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight()
    }
    absOrg = {x=dim.width/2, y=dim.height/2} -- Absolute coordinates of the relative Origin
    axisSeg = {x=30, y=20} -- The lenght of the segment between numbers
    numSeg = {x=5, y=5} -- The lenght of the number segment

    absFrame = { -- Absolute coordinates of the Frame Borders
        x0=100, xf=50, y0=80, yf=30,
    }

    relFrame = { -- Relative coordinates of the Frame Borders
        x0 = absFrame.x0 - absOrg.x ,
        xf = dim.width - absFrame.xf - absOrg.x ,
        y0 = absFrame.y0 - absOrg.y ,
        yf = dim.height - absFrame.yf - absOrg.y ,
    }

    -- Plot Objects

end

function love.update(dt)
end

-- USEFUL FUNCTIONS
function updateStuff()
    relFrame = { -- Relative coordinates of the Frame Borders
        x0 = absFrame.x0 - absOrg.x ,
        xf = dim.width - absFrame.xf - absOrg.x ,
        y0 = absFrame.y0 - absOrg.y ,
        yf = dim.height - absFrame.yf - absOrg.y ,
    }
end

function isInFrameAbs(x,y)
    local x0 = absFrame.x0 - x
    local xf = dim.width - absFrame.xf - x
    local y0 = absFrame.y0 - y
    local yf = dim.height - absFrame.yf - y
    
    return (x0 < 0 and 0 < xf) and (y0 < 0 and 0 < yf) 
end


-- MOUSE CALLBACK
function love.resize(w, h)
    dim.width, dim.height = w, h
    updateStuff()
end

function love.mousepressed(x, y, button, istouch, presses)
    print(button)
    if button == 1 then
        print("test")
        if isInFrameAbs(x,y) then
            action = "updateAbsOrg"
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if action == nil then return end
    if isInFrameAbs(x,y) then
        if action == "updateAbsOrg" then
            absOrg.x, absOrg.y = absOrg.x + dx, absOrg.y + dy
            updateStuff()
        end
    else action = nil end
end

function love.mousereleased(x, y, button, istouch, presses)
    action = nil
end

function love.draw()
    -- Draw the scene at an offset of relx, rely:
    love.graphics.push()
    love.graphics.translate(absOrg.x, absOrg.y)

        -- Draw a Frame
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", relFrame.x0, relFrame.y0, relFrame.xf-relFrame.x0, relFrame.yf-relFrame.y0)

        -- Draw circle at origin
        love.graphics.setColor(1,1,1)
        love.graphics.circle("fill", 0, 0, 3, 50)



        -- Each pixel touched by the func will have stencil value set to 1, the rest will be 0.
        love.graphics.stencil(
            function() 
                love.graphics.rectangle("fill", relFrame.x0, relFrame.y0, relFrame.xf-relFrame.x0, relFrame.yf-relFrame.y0) 
            end, "replace", 1
        )
        -- Only allow rendering on pixels which have a stencil value greater than 0.
        love.graphics.setStencilTest("greater", 0)           
        
        
        -- restore rendering outside stencil function
        love.graphics.setStencilTest()


    -- restores coordinate system to the one of the previous push()
    love.graphics.pop()

    -- Draw relative coors
    love.graphics.setColor(1,1,1)
    love.graphics.print(absOrg.x, 30, 30)
    love.graphics.print(absOrg.y, 80, 30)
end