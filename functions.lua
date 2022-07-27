require("variables")

local xratio = axisSeg.x.curr/axisSeg.x.step

-- 4*x^4
-- math.sin(x)
f = function (x) return 0.25*x^2 end
x0 = 2
y0 = f(x0)

h = pxStep / xratio / 100

function derivada(x)
    y = ( f(x+h) - f(x) ) / h 
    return y
end

m = derivada(x0)

function tangente(x)
    return m * (x - x0) + y0
end

functions_table = {
    {func = f,          color = {0.0, 1.0, 1.0} },
    {func = derivada,   color = {1.0, 1.0, 0.0} },
    {func = tangente,   color = {1.0, 0.0, 1.0} },
}

