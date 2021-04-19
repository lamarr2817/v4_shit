local swap = 1
function Zach_is_gay()
    local entity = entities.GetLocalPlayer();
    if entity ~= nil then

        if (gui.GetValue("rbot_antiaim_enable")) then
            if (swap == 1) then
                gui.SetValue("rbot_antiaim_stand_real_add", -72);
                gui.SetValue("rbot_antiaim_move_real_add", -72);
                gui.SetValue("rbot_antiaim_edge_real_add", -72);
                swap = 2
            elseif (swap == 2) then
                gui.SetValue("rbot_antiaim_stand_real_add", -22);
                gui.SetValue("rbot_antiaim_move_real_add", -22);
                gui.SetValue("rbot_antiaim_edge_real_add", -22);
                swap = 3
            elseif (swap == 3) then
                gui.SetValue("rbot_antiaim_stand_real_add", 24);
                gui.SetValue("rbot_antiaim_move_real_add", 24);
                gui.SetValue("rbot_antiaim_edge_real_add", 24);
                swap = 4
            elseif (swap == 4) then
                gui.SetValue("rbot_antiaim_stand_real_add", 54);
                gui.SetValue("rbot_antiaim_move_real_add", 54);
                gui.SetValue("rbot_antiaim_edge_real_add", 54);
                swap = 1
            end
        end
    end
end

callbacks.Register('CreateMove', 'Zach_is_gay', Zach_is_gay)