autostop_keys = {
    "rbot_autosniper_autostop",
    "rbot_sniper_autostop",
    "rbot_scout_autostop",
    "rbot_revolver_autostop",
    "rbot_pistol_autostop",
    "rbot_smg_autostop",
    "rbot_rifle_autostop",
    "rbot_shotgun_autostop",
    "rbot_lmg_autostop",
    "rbot_shared_autostop"
}

autostop_user_saved_values = {}
for i = 1, #autostop_keys do
    autostop_user_saved_values[i] = gui.GetValue(autostop_keys[i]);
end

callbacks.Register("Draw", function()
    local slowWalkBind = gui.GetValue("msc_slowwalk");
    if (slowWalkBind == nil or slowWalkBind == 0) then return end
    local lPlayer = entities.GetLocalPlayer();
    if (lPlayer == nil) then return end
    local slowWalkEnabled = input.IsButtonDown(slowWalkBind);
    for i = 1, #autostop_keys do
        if slowWalkEnabled and lPlayer:IsAlive() then
            local text = "Slowalk Desync enable"
            local textWidth, textHeight = draw.GetTextSize(text);
            local top = 590
            draw.Color(150, 185, 1, 255);
            draw.FilledRect(0, top, textWidth + 30, top + textHeight + 20);
            draw.Color(16, 0, 0, 255);
            draw.FilledRect(0, top, textWidth + 20, top + textHeight + 20);
            draw.Color(255, 255, 255, 255);
            draw.Text(10, top + 10, text);
            gui.SetValue(autostop_keys[i], 0);
        else
            gui.SetValue(autostop_keys[i], autostop_user_saved_values[i])
        end
    end
end)