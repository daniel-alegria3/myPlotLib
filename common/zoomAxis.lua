function zoomAxis(axis, coor)
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
