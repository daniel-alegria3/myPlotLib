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
            love.graphics.draw(
                text,
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
            love.graphics.draw(
                text,
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
