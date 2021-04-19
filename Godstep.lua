local wnd_lua_gstep = gui.Window("wnd_lua_gstep", "Godstep", 250, 50, 200, 350)

local gb_lua_gstep = gui.Groupbox(wnd_lua_gstep, "Main", 5, 5, 190, 308)

local lua_gstep_lby = gui.Checkbox(gb_lua_gstep, "lua_gstep_lby", "LBY Drift", false)
local lua_gstep_lbyoffsethost = gui.Combobox(gb_lua_gstep, "lua_gstep_lbyoffsethost", "LBY Drift Host", "Desync", "Real", "Void", "Pitch")
local lua_gstep_lbyoffset = gui.Slider(gb_lua_gstep, "lua_gstep_lbyoffset", "LBY Drift Factor", 0, -86, 86)

local lua_gstep_ychoke = gui.Checkbox(gb_lua_gstep, "lua_gstep_ychoke", "Yaw Choke", false)
local lua_gstep_ychokehost = gui.Combobox(gb_lua_gstep, "lua_gstep_ychokehost", "Yaw Choke Host", "Desync", "Real", "Void", "Pitch")
local lua_gstep_yoffset = gui.Slider(gb_lua_gstep, "lua_gstep_yoffset", "Yaw Choke Factor", 0, -86, 86)

local lua_gstep_pitchjitter = gui.Checkbox(gb_lua_gstep, "lua_gstep_pitchjitter", "Pitch Jitter", false)

callbacks.Register("CreateMove", function(UserCMD)

    if entities.GetLocalPlayer() ~= nil then
        if UserCMD:GetSendPacket() then
        x1, y1 = UserCMD:GetViewAngles()
        end
    end
end)

callbacks.Register("Draw", function()

    local lp = entities.GetLocalPlayer();

    if lp ~= nil then
        local x2, y2 = lp:GetProp('m_angEyeAngles')
        local local_lby = lp:GetProp('m_flLowerBodyYawTarget')

        if lua_gstep_lby:GetValue() then
            if lua_gstep_lbyoffsethost:GetValue() == 0 then
                lp:SetProp("m_flLowerBodyYawTarget", y1 + lua_gstep_lbyoffset:GetValue())
            elseif lua_gstep_lbyoffsethost:GetValue() == 1 then
                lp:SetProp("m_flLowerBodyYawTarget", y2 + lua_gstep_lbyoffset:GetValue())
            elseif lua_gstep_lbyoffsethost:GetValue() == 2 then
                lp:SetProp("m_flLowerBodyYawTarget", math.huge)
            elseif lua_gstep_lbyoffsethost:GetValue() == 3 then
                lp:SetProp("m_flLowerBodyYawTarget", x2 + lua_gstep_lbyoffset:GetValue())
            end
        end

        if lua_gstep_ychoke:GetValue() then
            if lua_gstep_ychokehost:GetValue() == 0 then
                lp:SetProp("m_angEyeAngles[1]", y1 + lua_gstep_yoffset:GetValue())
            elseif lua_gstep_ychokehost:GetValue() == 1 then
                lp:SetProp("m_angEyeAngles[1]", local_lby + lua_gstep_yoffset:GetValue())
            elseif lua_gstep_ychokehost:GetValue() == 2 then
                lp:SetProp("m_angEyeAngles[1]", math.huge)
            elseif lua_gstep_ychokehost:GetValue() == 3 then
                lp:SetProp("m_angEyeAngles[1]", x2 + lua_gstep_yoffset:GetValue())
            end
        end
    end

    -- Pitch Jittering
    if lua_gstep_pitchjitter:GetValue() then
        gui.SetValue("rbot_antiaim_stand_pitch_real", 6)
        gui.SetValue("rbot_antiaim_stand_pitch_custom", math.random(60, 90))
    end

    wnd_lua_gstep:SetActive(gui.Reference("MENU"):IsActive())

end)