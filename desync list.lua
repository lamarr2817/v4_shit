callbacks.Register( "CreateMove", function(UserCMD)

    if entities.GetLocalPlayer() ~= nil then
        dx, dy = UserCMD:GetViewAngles()

    end

end)

callbacks.Register("Draw", function()
    if entities.GetLocalPlayer() ~= nil then
        localplayer = entities.GetLocalPlayer()
        rx,ry = localplayer:GetProp('m_angEyeAngles')
        local_lby = localplayer:GetProp('m_flLowerBodyYawTarget')
        absx, absy = localplayer:GetAbsOrigin()

        draw.Text(200, 110, "Desync Pitch: " .. math.floor(dx))
        draw.Text(200, 120, "Desync Yaw: " .. math.floor(dy))
        draw.Text(200, 130, "Real Pitch: " .. math.floor(rx))
        draw.Text(200, 140, "Real Yaw: " .. math.floor(ry))
        draw.Text(200, 150, "LBY: " .. math.floor(local_lby))

    end
end)