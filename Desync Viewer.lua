local groupbox_miscellaneous = gui.Reference("Settings", "Miscellaneous")
local desync_window = gui.Window( desync_window, "Desync Viewer Options", 40, 40, 175, 190 )
local desync_window_groupbox_controls = gui.Groupbox( desync_window, "Main", 5, 5, 165, 148 )
local menuPressed = 1

local desync_window_show = gui.Checkbox(groupbox_miscellaneous, "desync_window_show", "Desync Viewer Menu", false )
local desync_display = gui.Combobox(desync_window_groupbox_controls, "desync_display", "Display Mode", "Off", "Box Display", "Crosshair Display" )
local desync_viewer_options = gui.Multibox( desync_window_groupbox_controls, "Angles to Display" )
local desync_debug = gui.Checkbox(desync_window_groupbox_controls, "desync_debug", "List Angles", false )

local desync_showfake = gui.Checkbox(desync_viewer_options, "desync_showfake", "Client", false)
local desync_showreal = gui.Checkbox(desync_viewer_options, "desync_showreal", "Server", false)
local desync_showlby = gui.Checkbox(desync_viewer_options, "desync_showlby", "LBY", false)

local custom_color1 = gui.ColorEntry( "custom1", "Desync Engine Color", 50, 150, 5, 255 )

local font = draw.CreateFont("Bahnschrift", 13, 1)

callbacks.Register( "CreateMove", function(UserCMD)

    if entities.GetLocalPlayer() ~= nil then
        if UserCMD:GetSendPacket() then
            x1, y1 = UserCMD:GetViewAngles()
        end
    end

end)

function smax(var, max)
    if var > max then
        return max;
    else
        return var;
    end
end


callbacks.Register("Draw", function()


    if entities.GetLocalPlayer() ~= nil then
        x2,y2 = entities.GetLocalPlayer():GetProp('m_angEyeAngles')
        local_lby = entities.GetLocalPlayer():GetProp('m_flLowerBodyYawTarget')
        desync_difference = math.abs(math.floor(y1 - y2))
        absx, absy = entities.GetLocalPlayer():GetAbsOrigin()
    end

    local screenX, screenY = draw.GetScreenSize()
    local centerX = screenX * 0.5
    local centerY = screenY * 0.5


    draw.SetFont(font)

if desync_display:GetValue() ~= 0 and entities.GetLocalPlayer() ~= nil then

    draw.Color(custom_color1:GetValue())

        if desync_showfake:GetValue() or desync_showreal:GetValue() or desync_showlby:GetValue() == true then

            if desync_display:GetValue() == 1 then

            draw.Color(255, 255, 255, 55)
            draw.FilledRect(15, 315, 115, 415)

            draw.Color(custom_color1:GetValue())
            draw.OutlinedRect(15, 315, 115, 415)
            draw.OutlinedRect(16, 316, 116, 416)


            if desync_showlby:GetValue() == true then
            draw.Color(255, 255, 0, 150)
            draw.Line(65 - local_lby * 0.27, 365, 65, 414)
            draw.Text(65 - local_lby * 0.27, 358, math.floor(local_lby))

            end

            if desync_showreal:GetValue() == true then
            draw.Color(gui.GetValue("clr_chams_ghost_server"))
            draw.Line(65 - y1 * 0.27, 365, 65, 414)
            draw.Text(65 - y1 * 0.27, 358, math.floor(y2))

            end

            if desync_showfake:GetValue() == true then
            draw.Color(gui.GetValue("clr_chams_ghost_client"))
            draw.Line(65 - y2 * 0.27, 365, 65, 414)
            draw.Text(65 - y2 * 0.27, 358, math.floor(y1))


            end

            else

                if desync_showlby:GetValue() == true then
                    draw.Color(255, 255, 0, 150)
                    draw.Line(centerX - local_lby * 0.2, centerY - 35, centerX, centerY)
                    draw.Text(centerX - local_lby * 0.2, centerY - 35, math.floor(local_lby))

                end

                if desync_showreal:GetValue() == true then
                    draw.Color(gui.GetValue("clr_chams_ghost_server"))
                    draw.Line(centerX - y1 * 0.2, centerY - 35, centerX, centerY)
                    draw.Text(centerX - y1 * 0.2, centerY - 35, math.floor(y2))

                end

                if desync_showfake:GetValue() == true then
                    draw.Color(gui.GetValue("clr_chams_ghost_client"))
                    draw.Line(centerX - y2 * 0.2, centerY - 35, centerX, centerY)
                    draw.Text(centerX - y2 * 0.2, centerY - 35, math.floor(y1))

            end
            end
        end
end

    if desync_debug:GetValue() == true and entities.GetLocalPlayer() ~= nil then
        draw.Color(255, 255, 255)
        draw.TextShadow(250, 0, "Desync Pitch: " .. math.floor(x2))
        draw.TextShadow(250, 14, "Desync Yaw: " .. math.floor(y2))
        draw.TextShadow(250, 28, "LBY: " .. math.floor(local_lby))
        draw.TextShadow(250, 42, "Real Pitch: " .. math.floor(x1))
        draw.TextShadow(250, 56, "Real Yaw: " .. math.floor(y1))

        if math.floor(y1) ~= math.floor(local_lby) and math.ceil(y1) ~= math.floor(local_lby) then
            draw.Color(255, 0, 0)
        else
            draw.Color(0, 255, 0)
        end
            draw.TextShadow(250, 70, "LBY")

            draw.Color(255 - desync_difference * 2, desync_difference, 0)
            draw.TextShadow(250, 84, "Desync    " .. desync_difference)
            draw.FilledRect(350, 0, 355, smax(desync_difference * 0.5, 95))

            draw.Color(255, 255, 255)
            draw.OutlinedRect(350, 0, 355, 95)

    end


-- //////////////////////////////////////////////////////////////////////////////////// Window Management

    if desync_window_show:GetValue() == true

    then

        desync_window:SetActive(1)

    else

        desync_window:SetActive(0)

    end


    if input.IsButtonPressed(gui.GetValue("msc_menutoggle")) then
        menuPressed = menuPressed == 0 and 1 or 0;
    end
    if (desync_window_show:GetValue()) then
        desync_window:SetActive(menuPressed);
    else
        desync_window:SetActive(0);
    end

end)