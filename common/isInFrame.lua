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
