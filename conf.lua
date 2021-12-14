function love.conf(t)
    t.window.title = "PlotLib"
    t.window.icon = "icon.jpeg"

    t.window.width = 700
    t.window.height = 600
    
    t.console = true
    t.window.resizable = true
    t.window.minwidth = 300
    t.window.minheight = 300
    
    t.modules.joystick = false
    t.modules.physics = false
end