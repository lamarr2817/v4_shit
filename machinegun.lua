callbacks.Register("Draw", function()

    gui.SetValue("rbot_antiaim_stand_pitch_real", 6)
    gui.SetValue("rbot_antiaim_move_pitch_real", 6)

    gui.SetValue("rbot_antiaim_stand_pitch_custom", math.random(60, 90))
    gui.SetValue("rbot_antiaim_move_pitch_custom", math.random(60, 90))

end)