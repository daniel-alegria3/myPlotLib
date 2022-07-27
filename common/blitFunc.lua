require("variables")

function getFuncPointsFromX(obj)
    local isDiv = {}

    local xratio = axisSeg.x.curr/axisSeg.x.step
    local yratio = axisSeg.y.curr/axisSeg.y.step

    obj.ssNum = obj.ssNum or 1
    local ssPoints = {}
    for i=1, obj.ssNum, 1 do ssPoints[i] = {} end

    for x=relFrame.x0, relFrame.xf, pxStep do -- step is accuracy
        -- x = tonumber(string.format("%.1f", x))

        local ySS = obj.func(x/xratio)
        if not ySS or type(ySS) == "number" then ySS = {ySS} end -- check if ySS is truly a solution set

        for i=1, obj.ssNum, 1 do
            local points = ssPoints[i]

            if not ySS then
                table.insert(points, "sep")
                isDiv[i] = true

            elseif ySS[i] then
                ------------------
                if y and isInRelFrame("y", y) then
                end

                local y = -ySS[i]*yratio

                if y and isInRelFrame("y", y) then
                    table.insert(points, x)
                    table.insert(points, y)

                elseif points[#points] ~= "sep" then
                    table.insert(points, "sep")
                    isDiv[i] = true

                end
                ------------------
            end
        end

    end

    return ssPoints, isDiv
end

function getFuncPointsFromY(obj)
    local isDiv = {}

    local xratio = axisSeg.x.curr/axisSeg.x.step
    local yratio = axisSeg.y.curr/axisSeg.y.step

    obj.ssNum = obj.ssNum or 1
    local ssPoints = {}
    for i=1, obj.ssNum, 1 do ssPoints[i] = {} end

    for y=relFrame.y0, relFrame.yf, pxStep do -- step is accuracy
        -- y = tonumber(string.format("%.1f", y))

        local xSS = obj.func(-y/yratio)
        if not xSS or type(xSS) == "number" then xSS = {xSS} end -- check if ySS is truly a solution set

        for i=1, obj.ssNum, 1 do
            local points = ssPoints[i]

            if not xSS then
                table.insert(points, "sep")
                isDiv[i] = true

            elseif xSS[i] then
                ------------------

                local x = xSS[i]*xratio

                if x and isInRelFrame("x", x) then
                    table.insert(points, x)
                    table.insert(points, y)

                elseif points[#points] ~= "sep" then
                    table.insert(points, "sep")
                    isDiv[i] = true

                end
                ------------------
            end
        end

    end

    return ssPoints, isDiv
end

function drawFunc(obj)
    if obj.color then love.graphics.setColor(unpack(obj.color)) end

    local getFuncPoints

    ---///
    if not obj.axis or obj.axis == "x" then
        getFuncPoints = getFuncPointsFromX
    elseif obj.axis == "y" then
        getFuncPoints = getFuncPointsFromY
    end

    local ssPoints, isDiv = getFuncPoints(obj)
    ---///

    for i=1, obj.ssNum, 1 do
        local points = ssPoints[i]
        ------------------
        if isDiv[i] then

            local part = {}
            for _, coor in ipairs(points) do

                if coor ~= "sep" then
                    table.insert(part, coor)

                elseif coor == "sep" and #part >= 4 then
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
