pxStep = 40 -- precicion de las graficas en pixeles


dim = { -- program window dimensions
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
    left=60, right=60, top=100, bottom=60,
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
