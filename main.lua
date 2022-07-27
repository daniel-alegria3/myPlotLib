
function love.load()
    -- Plot Objects
    require("functions")


    -- Background, Fonts and Text
    love.graphics.setBackgroundColor(40/255, 42/255,54/255)
    mainFont = love.graphics.newFont("JetBrains_Mono.ttf", 13)
    secFont = love.graphics.newFont("JetBrains_Mono.ttf", 13)
    love.graphics.setFont(secFont)
    text = love.graphics.newText(mainFont)
    --

    -- VARIABLES
    require("variables")

    updateStuff()


    require("common/isInFrame")
    require("common/zoomAxis")
    require("common/blitAxis")
    require("common/blitFunc")


    --FPS CAP
    min_dt = 1/30
    next_time = love.timer.getTime()

end


function love.update(dt)
    -- FPS CAP
    next_time = next_time + min_dt
end


-- FUCTIONS TO CHECK IF POINT IS IN FRAME

-- RESIZE CALLBACK
function love.resize(w, h)
    dim.width, dim.height = w, h
    updateStuff()
end

-- ZOOM IMPLEMENTATION
function love.wheelmoved(x, y)
    -- y is the direction of the mousewheel, x is like a horizontal wheel
    zoomAxis("x", y)
    zoomAxis("y", y)
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

-- LOVE.DRAW
function love.draw()
    love.graphics.push() -- Draw the scene at an offset of relOrg.x, relOrg.y
    love.graphics.translate(relOrg.x, relOrg.y)

        -- Draw a Frame
        love.graphics.setColor(253/255,246/255,227/255)
        love.graphics.rectangle(
            "line", 
            relFrame.x0, 
            relFrame.y0, 
            relFrame.xf-relFrame.x0,
            relFrame.yf-relFrame.y0
        )

        -- Each pixel touched by the func will have stencil value set to 1, the rest will be 0.
        love.graphics.stencil(stencilFunc, "replace", 1)
        -- Only allow rendering on pixels which have a stencil value greater than 0.
        love.graphics.setStencilTest("greater", 0)

            drawAxisX()
            drawAxisY()


            for _, obj in pairs(functions_table) do
                drawFunc(obj)
            end


        -- restore rendering outside stencil function
        love.graphics.setStencilTest()


    love.graphics.pop() -- restores coordinate system to the one of the previous push()

    -- Draw relative coors
    love.graphics.setColor(1,1,1)
    -- love.graphics.print(relOrg.x, 40, 30)
    -- love.graphics.print(relOrg.y, 80, 30)

end
