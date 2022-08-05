require("variables")

local xratio = axisSeg.x.curr/axisSeg.x.step
local yratio = axisSeg.y.curr/axisSeg.y.step

h = pxStep/xratio

function derivada(fun)
    -- deriv = ( f(x) - f(x0) ) / ( x - x0 )
    deriv = function(x)
        return ( fun(x+h) - fun(x) ) / h
    end

    return deriv
end

function tangente(fun, x0)
    m = derivada(fun)(x0)
    y0 = fun(x0)

    tang = function(x)
        return m * (x - x0) + y0
    end

    return tang
end

function normal(fun, x0)
    m = derivada(fun)(x0)
    y0 = fun(x0)

    norm = function(x)
        return -1/m * (x - x0) + y0
    end

    return norm
end


----- ###  MAIN BODY ### -----

f = function(x)
    return 3 * x^2 - x + 1
end

-- define derivadas
f1 = derivada(f) -- velocidad instantanea
f2 = derivada(f1) -- aceleracion

functions_table = {
    {func = f,   color = {1.0, 0.6, 0.6} },

    {func = f1,  color = {0.6, 1.0, 0.6} },
    {func = f2,  color = {0.6, 0.6, 1.0} },
}


f = function(x)
    return 2*x^3 - 3*x^2 - 3*x + 2
end
-- functions_table = {
--     {func = f,                color = {1.0, 0.6, 0.6} },
--     {func = tangente(f, 1.5), color = {0.7, 0.7, 0.0} },
--     {func = normal  (f, 1.5), color = {0.5, 0.5, 0.5} },
-- }

