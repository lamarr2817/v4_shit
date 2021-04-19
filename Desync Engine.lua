-- //////////////////////////////////////////////////////////////////////////////////// Version
local version = "B2"

-- //////////////////////////////////////////////////////////////////////////////////// Windows/Groupboxes
local groupbox_miscellaneous = gui.Reference("Settings", "Miscellaneous")
local desync_window = gui.Window( desync_window, "Lamarr's Desync Engine " .. version, 40, 40, 500, 355 )
local desync_window_groupbox_main = gui.Groupbox( desync_window, "Main", 5, 5, 245, 315 )
local desync_window_groupbox_controls = gui.Groupbox( desync_window, "Extra", 250, 5, 245, 315 )
local menuPressed = 1

-- //////////////////////////////////////////////////////////////////////////////////// GUI Elements
local desync_yaw = gui.Slider( desync_window_groupbox_main, "desync_yaw", "Desync Yaw", 0, -180, 180 )
local desync_sidemove_factor = gui.Slider( desync_window_groupbox_main, "desync_sidemove_factor", "Sidemove Factor", 0, 0, 5 )
local desync_sidemove_angle = gui.Slider( desync_window_groupbox_main, "desync_sidemove_angle", "Sidemove Angle", -1, -5, 5 )
local desync_forwardmove_factor = gui.Slider( desync_window_groupbox_main, "desync_forwardmove_factor", "Forward Factor", 0, 0, 5 )
local desync_forwardmove_angle = gui.Slider( desync_window_groupbox_main, "desync_forwardmove_angle", "Forward Angle", -1, -5, 5 )
local desync_viewer = gui.Checkbox(desync_window_groupbox_controls, "desync_viewer", "Desync Viewer", false)
local desync_viewer_options = gui.Multibox( desync_window_groupbox_controls, "Desync Viewer Options" )
local desync_debug = gui.Checkbox(desync_window_groupbox_controls, "desync_debug", "Debug", false)

local desync_showfake = gui.Checkbox(desync_viewer_options, "desync_showfake", "Client", false)
local desync_showreal = gui.Checkbox(desync_viewer_options, "desync_showreal", "Server", false)
local desync_showlby = gui.Checkbox(desync_viewer_options, "desync_showlby", "LBY", false)

local desync_jitter = gui.Checkbox(desync_window_groupbox_controls, "desync_jitter", "Desync Jitter", false)
local desync_jitter_range = gui.Slider( desync_window_groupbox_controls, "desync_jitter_range", "Desync Jitter Range", 16, 0, 180 )


local custom_color1 = gui.ColorEntry( "custom1", "Desync Engine Color", 50, 150, 5, 255 )

-- //////////////////////////////////////////////////////////////////////////////////// Desync

callbacks.Register( "CreateMove", function(UserCMD)

    UserCMD:SetSendPacket(1)


    if desync_jitter:GetValue() and UserCMD:GetSendPacket() then

        -- Desync Jittering (To be optimized)
        UserCMD:SetViewAngles(gui.GetValue("rbot_antiaim_stand_pitch_custom"), 0 - math.floor(desync_yaw:GetValue()) + math.random(0 - math.floor(desync_jitter_range:GetValue()), math.floor(desync_jitter_range:GetValue())))

    else
        UserCMD:SetViewAngles(gui.GetValue("rbot_antiaim_stand_pitch_custom"), 0 - math.floor(desync_yaw:GetValue())) -- Setting desync angle

        UserCMD:SetSideMove(desync_sidemove_factor:GetValue(), desync_sidemove_angle:GetValue()) -- Sidemove

        UserCMD:SetForwardMove(desync_forwardmove_factor:GetValue(), desync_forwardmove_angle:GetValue()) -- Forwardmove

    end

    UserCMD:SetSendPacket(0)
end)

-- //////////////////////////////////////////////////////////////////////////////////// Watermark

callbacks.Register("Draw", function()
    desync_window:SetActive(gui.Reference("MENU"):IsActive())

    if entities.GetLocalPlayer() ~= nil then
        x2,y2 = entities.GetLocalPlayer():GetProp('m_angEyeAngles')

        local_lby = entities.GetLocalPlayer():GetProp('m_flLowerBodyYawTarget')
    end

if desync_viewer:GetValue() == true and entities.GetLocalPlayer() ~= nil then



    local font = draw.CreateFont("Bahnschrift", 13, 1)
    draw.SetFont(font)
    draw.Color(custom_color1:GetValue())
    draw.TextShadow(20, 300, "Desync Engine " .. version)

    if desync_showfake:GetValue() or desync_showreal:GetValue() or desync_showlby:GetValue() == true then

        draw.Color(255, 255, 255, 55)
        draw.FilledRect(15, 315, 115, 415)

        draw.Color(custom_color1:GetValue())
        draw.OutlinedRect(15, 315, 115, 415)
        draw.OutlinedRect(16, 316, 116, 416)


        if desync_showlby:GetValue() == true then
        draw.Color(255, 255, 0)
        draw.Line(65 - local_lby * 0.27, 365, 65, 414)
        draw.Text(65 - local_lby * 0.27, 358, math.floor(local_lby))

        end

        if desync_showreal:GetValue() == true then
        draw.Color(gui.GetValue("clr_chams_ghost_server"))
        draw.Line(65 - y2 * 0.27, 365, 65, 414)
        draw.Text(65 - y2 * 0.27, 358, math.floor(y2))

        end

        if desync_showfake:GetValue() == true then
        draw.Color(gui.GetValue("clr_chams_ghost_client"))
        draw.Line(65 - y1 * 0.27, 365, 65, 414)
        draw.Text(65 - y1 * 0.27, 358, math.floor(y1))

        end
    end
end

    if desync_debug:GetValue() == true then

        draw.Color(255, 255, 255)
        draw.Text(250, 0, x1)
        draw.Text(250, 14, y1)
        draw.Text(250, 28, local_lby)
        draw.Text(250, 42, x2)
        draw.Text(250, 56, y2)
--        draw.Text(250, 70, z2)
    end

end)

--[[


[Changelog]

B1 10/12
+Basic Functionality
+GUI
+HvH/Legit Mode Options
+Pasted Shitty Window Manager

B2 10/13
+Improved GUI
+SideMove Options
+ForwardMove Options
+Angle Viewer
+Debug Viewer
+Desync Jittering


]]--