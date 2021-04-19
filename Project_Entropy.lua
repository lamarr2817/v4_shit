local windowInfo;
local settingsLoaded = false;
local ui = {};
local references = {
    aimware = gui.Reference("MENU"),
    miscGeneral = gui.Reference("SETTINGS", "Miscellaneous");
};
local caches = {
    vis_view_fov = gui.GetValue("vis_view_fov"),
    clr_chams_ghost_client = { gui.GetValue('clr_chams_ghost_client') },
    clr_chams_ghost_server = { gui.GetValue('clr_chams_ghost_server') },
    rbot_delayshot = gui.GetValue('rbot_delayshot');
    msc_fakelatency_enable = gui.GetValue('msc_fakelatency_enable');
    msc_fakelag_enable = gui.GetValue('msc_fakelag_enable'),
    msc_fakelag_mode = gui.GetValue('msc_fakelag_mode'),
    msc_fakelag_key = gui.GetValue('msc_fakelag_key'),
    msc_fakelag_attack = gui.GetValue('msc_fakelag_attack')
}
local windowW, windowH = 790, 550;
local luaName = "Project Entropy";
local luaKey = 'lynx_' .. luaName:lower():gsub(" ", "_") .. '_';

local keyHolder = {

    -- Simple Anti Aim
    simple_main = luaKey .. 'simple_main',
    simple_main_moving = luaKey .. 'simple_main_moving',

    -- Anti Aim
    desync_cycle_speed = luaKey .. 'desync_cycle_speed',
    real_cycle_speed = luaKey .. 'real_cycle_speed',
    real_swap_speed = luaKey .. 'real_swap_speed',
    desync_inverse = luaKey .. 'desync_inverse',
    desync_1 = luaKey .. 'desync_1',
    desync_2 = luaKey .. 'desync_2',
    desync_3 = luaKey .. 'desync_3',
    real_1 = luaKey .. 'real_1',
    real_2 = luaKey .. 'real_2',
    real_3 = luaKey .. 'real_3',
    angle_1 = luaKey .. 'angle_1';
    angle_2 = luaKey .. 'angle_2';

    -- Anti Aim Moving
    desync_cycle_speed_moving = luaKey .. 'desync_cycle_speed_moving',
    real_cycle_speed_moving = luaKey .. 'real_cycle_speed_moving',
    real_swap_speed_moving = luaKey .. 'real_swap_speed_moving',
    desync_inverse_moving = luaKey .. 'desync_inverse_moving',
    desync_1_moving = luaKey .. 'desync_1_moving',
    desync_2_moving = luaKey .. 'desync_2_moving',
    desync_3_moving = luaKey .. 'desync_3_moving',
    real_1_moving = luaKey .. 'real_1_moving',
    real_2_moving = luaKey .. 'real_2_moving',
    real_3_moving = luaKey .. 'real_3_moving',
    angle_1_moving = luaKey .. 'angle_1_moving';
    angle_2_moving = luaKey .. 'angle_2_moving';

    -- Visuals
    custom_hit_sound = luaKey .. 'custom_hit_sound';
    kill_effect = luaKey .. 'kill_effect';
    full_bright = luaKey .. 'full_bright';
    watermark = luaKey .. 'watermark';
    engine_radar = luaKey .. 'engine_radar';
    disable_postprocess = luaKey .. 'disable_postprocess';
    sniper_crosshair = luaKey .. 'sniper_crosshair';
    double_scope = luaKey .. 'double_scope';
    transparent_on_scope = luaKey .. 'transparent_scope';
    spread_tracers = luaKey .. 'spread_tracers';
    spread_tracers_duration = luaKey .. 'spread_tracers_duration';

    -- Ragebot
    rbot_scoutresolver_key = luaKey .. 'rbot_scoutresolver_key';
    rbot_scoutresolver_fakelatency = luaKey .. 'rbot_scoutresolver_fakelatency';
    rbot_scoutresolver_delayshot = luaKey .. 'rbot_scoutresolver_delayshot';

    -- Miscellaneous
    slowwalk_shuffle = luaKey .. 'slowwalk_shuffle';
    slowwalk_shuffle_mode = luaKey .. 'slowwalk_shuffle_mode';
    slowwalk_shuffle_ws = luaKey .. 'slowwalk_shuffle_ws';
    rgb_mode = luaKey .. 'rgb_mode';

    -- Curve
    lbot_pistol_curve = luaKey .. 'lbot_pistol_curve';
    lbot_pistol_curve_min = luaKey .. 'lbot_pistol_curve_min';
    lbot_pistol_curve_max = luaKey .. 'lbot_pistol_curve_max';
    lbot_smg_curve = luaKey .. 'lbot_smg_curve';
    lbot_smg_curve_min = luaKey .. 'lbot_smg_curve_min';
    lbot_smg_curve_max = luaKey .. 'lbot_smg_curve_max';
    lbot_rifle_curve = luaKey .. 'lbot_rifle_curve';
    lbot_rifle_curve_min = luaKey .. 'lbot_rifle_curve_min';
    lbot_rifle_curve_max = luaKey .. 'lbot_rifle_curve_max';
    lbot_sniper_curve = luaKey .. 'lbot_sniper_curve';
    lbot_sniper_curve_min = luaKey .. 'lbot_sniper_curve_min';
    lbot_sniper_curve_max = luaKey .. 'lbot_sniper_curve_max';

    -- Smooth
    lbot_pistol_smooth = luaKey .. 'lbot_pistol_smooth';
    lbot_pistol_smooth_min = luaKey .. 'lbot_pistol_smooth_min';
    lbot_pistol_smooth_max = luaKey .. 'lbot_pistol_smooth_max';
    lbot_smg_smooth = luaKey .. 'lbot_smg_smooth';
    lbot_smg_smooth_min = luaKey .. 'lbot_smg_smooth_min';
    lbot_smg_smooth_max = luaKey .. 'lbot_smg_smooth_max';
    lbot_rifle_smooth = luaKey .. 'lbot_rifle_smooth';
    lbot_rifle_smooth_min = luaKey .. 'lbot_rifle_smooth_min';
    lbot_rifle_smooth_max = luaKey .. 'lbot_rifle_smooth_max';
    lbot_sniper_smooth = luaKey .. 'lbot_sniper_smooth';
    lbot_sniper_smooth_min = luaKey .. 'lbot_sniper_smooth_min';
    lbot_sniper_smooth_max = luaKey .. 'lbot_sniper_smooth_max';

    -- Legit Miscellaneous
    lbot_triggerbot = luaKey .. 'lbot_triggerbot';
    lbot_triggerbot_min = luaKey .. 'lbot_triggerbot_min';
    lbot_triggerbot_max = luaKey .. 'lbot_triggerbot_max';
    lbot_backtrack = luaKey .. 'lbot_backtrack';
    lbot_backtrack_min = luaKey .. 'lbot_backtrack_min';
    lbot_backtrack_max = luaKey .. 'lbot_backtrack_max';
}

local showMenu = gui.Checkbox(references.miscGeneral, luaKey .. "showmenu", "[Lynx] " .. luaName, false);
local window = gui.Window(luaKey .. "tabs", "[Lynx Client] " .. luaName, 200, 200, windowW, windowH);
local advancedWindow = gui.Window(luaKey .. "tabs", "[Lynx Client] " .. luaName, 100, 100, 199, 505);

local groupW, groupH = 190, 230;

local groups = {

    -- Side Double
    anti_aim_simple = gui.Groupbox(window, "Anti-Aim", 5, 5, groupW, (groupH * 2) + 5);

    -- UP Row
    anti_aim = gui.Groupbox(advancedWindow, "Anti-Aim", 5, 5, groupW, groupH);
    visuals = gui.Groupbox(window, "Visuals", 5 * 2 + groupW, 5, groupW, groupH);
    ragebot = gui.Groupbox(window, "Ragebot", 5 * 3 + groupW * 2, 5, groupW, groupH);
    miscellaneous = gui.Groupbox(window, "Miscellaneous", 5 * 4 + groupW * 3, 5, groupW, groupH);

    -- Down Row
    anti_aim_moving = gui.Groupbox(advancedWindow, "Anti-Aim Moving", 5, 5 * 2 + groupH, groupW, groupH);
    curve = gui.Groupbox(window, "Curve", 5 * 2 + groupW, 5 * 2 + groupH, groupW, groupH);
    smoothing = gui.Groupbox(window, "Smoothing", 5 * 3 + groupW * 2, 5 * 2 + groupH, groupW, groupH);
    legit_miscellaneous = gui.Groupbox(window, "Legit Miscellaneous", 5 * 4 + groupW * 3, 5 * 2 + groupH, groupW, groupH);

}

local function unpack(t, i)
    i = i or 1
    if t[i] ~= nil then
        return t[i], unpack(t, i + 1)
    end
end

--[==========================[Simple Anti Aim Options]==========================]
ui[keyHolder.simple_main] = gui.Combobox(groups.anti_aim_simple, keyHolder.simple_main, "Standing Anti-Aim", "Custom", "Standard", "Special", "God Spin");
ui[keyHolder.simple_main_moving] = gui.Combobox(groups.anti_aim_simple, keyHolder.simple_main_moving, "Moving Anti-Aim", "Custom", "Standard", "Special", "God Spin");
local showAdvanced = gui.Checkbox(groups.anti_aim_simple, luaKey .. "showAdvanced", "Advanced Options", false);

--[==========================[Anti Aim Options]==========================]

ui[keyHolder.desync_cycle_speed] = gui.Combobox(groups.anti_aim, keyHolder.desync_cycle_speed, "Desync Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme");
ui[keyHolder.real_cycle_speed] = gui.Combobox(groups.anti_aim, keyHolder.real_cycle_speed, "Yaw Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme");
ui[keyHolder.real_swap_speed] = gui.Combobox(groups.anti_aim, keyHolder.real_swap_speed, "Angle Swap Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme");
ui[keyHolder.desync_inverse] = gui.Combobox(groups.anti_aim, keyHolder.desync_inverse, "Inverse on Desync", "Off", "Match", "Reverse", "Wide Match", "Wide Reverse", "Half Match", "Half Reverse");
ui[keyHolder.desync_1] = gui.Combobox(groups.anti_aim, keyHolder.desync_1, "Desync 1", "Off", "Still", "Balance", "Stretch", "Jitter");
ui[keyHolder.desync_2] = gui.Combobox(groups.anti_aim, keyHolder.desync_2, "Desync 2", "Off", "Still", "Balance", "Stretch", "Jitter");
ui[keyHolder.desync_3] = gui.Combobox(groups.anti_aim, keyHolder.desync_3, "Desync 3", "Off", "Still", "Balance", "Stretch", "Jitter");
ui[keyHolder.real_1] = gui.Combobox(groups.anti_aim, keyHolder.real_1, "Real 1", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift");
ui[keyHolder.real_2] = gui.Combobox(groups.anti_aim, keyHolder.real_2, "Real 2", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift");
ui[keyHolder.real_3] = gui.Combobox(groups.anti_aim, keyHolder.real_3, "Real 3", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift");
ui[keyHolder.angle_1] = gui.Slider(groups.anti_aim, keyHolder.angle_1, "Custom Angle (Default: -90)", -90, -180, 180);
ui[keyHolder.angle_2] = gui.Slider(groups.anti_aim, keyHolder.angle_2, "Custom Angle (Default: 90)", 90, -180, 180);

--[==========================[Anti Aim Moving Options]==========================]

ui[keyHolder.desync_cycle_speed_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.desync_cycle_speed_moving, "Desync Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme");
ui[keyHolder.real_cycle_speed_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.real_cycle_speed_moving, "Yaw Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme");
ui[keyHolder.real_swap_speed_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.real_swap_speed_moving, "Angle Swap Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme");
ui[keyHolder.desync_inverse_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.desync_inverse_moving, "Inverse on Desync", "Off", "Match", "Reverse", "Wide Match", "Wide Reverse", "Half Match", "Half Reverse");
ui[keyHolder.desync_1_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.desync_1_moving, "Desync 1", "Off", "Still", "Balance", "Stretch", "Jitter");
ui[keyHolder.desync_2_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.desync_2_moving, "Desync 2", "Off", "Still", "Balance", "Stretch", "Jitter");
ui[keyHolder.desync_3_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.desync_3_moving, "Desync 3", "Off", "Still", "Balance", "Stretch", "Jitter");
ui[keyHolder.real_1_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.real_1_moving, "Real 1", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift");
ui[keyHolder.real_2_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.real_2_moving, "Real 2", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift");
ui[keyHolder.real_3_moving] = gui.Combobox(groups.anti_aim_moving, keyHolder.real_3_moving, "Real 3", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift");
ui[keyHolder.angle_1_moving] = gui.Slider(groups.anti_aim_moving, keyHolder.angle_1_moving, "Custom Angle (Default: -90)", -90, -180, 180);
ui[keyHolder.angle_2_moving] = gui.Slider(groups.anti_aim_moving, keyHolder.angle_2_moving, "Custom Angle (Default: 90)", 90, -180, 180);

--[==========================[Visual Options]==========================]

ui[keyHolder.custom_hit_sound] = gui.Combobox(groups.visuals, keyHolder.custom_hit_sound, "Hitsound", "Off", "Entropy", "Skeet", "Chicken", "Casino")
ui[keyHolder.kill_effect] = gui.Combobox(groups.visuals, keyHolder.kill_effect, "Kill Effect", "Off", "Red", "Green", "Blue")
ui[keyHolder.full_bright] = gui.Checkbox(groups.visuals, keyHolder.full_bright, "Fullbright", false)
ui[keyHolder.watermark] = gui.Checkbox(groups.visuals, keyHolder.watermark, "Watermark", false)
ui[keyHolder.engine_radar] = gui.Checkbox(groups.visuals, keyHolder.engine_radar, "Engine Radar", false)
ui[keyHolder.disable_postprocess] = gui.Checkbox(groups.visuals, keyHolder.disable_postprocess, "Disable Post-Processing", false)
ui[keyHolder.sniper_crosshair] = gui.Checkbox(groups.visuals, keyHolder.sniper_crosshair, "Force Crosshair on Sniper", false)
ui[keyHolder.double_scope] = gui.Checkbox(groups.visuals, keyHolder.double_scope, "Zoom on Double Scope", false)
ui[keyHolder.transparent_on_scope] = gui.Checkbox(groups.visuals, keyHolder.transparent_on_scope, "Transparent on Scope", false)
ui[keyHolder.spread_tracers] = gui.Checkbox(groups.visuals, keyHolder.spread_tracers, "Spread Tracers", false)
ui[keyHolder.spread_tracers_duration] = gui.Slider(groups.visuals, keyHolder.spread_tracers_duration, "Spread Tracer Duration", 2, 1, 10)

--[==========================[Ragebot Options]==========================]

ui[keyHolder.rbot_scoutresolver_key] = gui.Keybox(groups.ragebot, keyHolder.rbot_scoutresolver_key, "Scout Resolver", 4);
local resolverCustomizations = gui.Multibox(groups.ragebot, "Scout Resolver Customization");
ui[keyHolder.rbot_scoutresolver_fakelatency] = gui.Checkbox(resolverCustomizations, keyHolder.rbot_scoutresolver_fakelatency, "Disable Fake latency", false)
ui[keyHolder.rbot_scoutresolver_delayshot] = gui.Checkbox(resolverCustomizations, keyHolder.rbot_scoutresolver_delayshot, "Accurate Unlag", false)

--[==========================[Miscellaneous Options]==========================]

ui[keyHolder.slowwalk_shuffle] = gui.Checkbox(groups.miscellaneous, keyHolder.slowwalk_shuffle, "Slow Walk Fakelag", false)
ui[keyHolder.slowwalk_shuffle_mode] = gui.Combobox(groups.miscellaneous, keyHolder.slowwalk_shuffle_mode, "Slow Walk Fakelag Mode", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek")
ui[keyHolder.slowwalk_shuffle_ws] = gui.Checkbox(groups.miscellaneous, keyHolder.slowwalk_shuffle_ws, "While Shooting", false)
ui[keyHolder.rgb_mode] = gui.Combobox(groups.miscellaneous, keyHolder.rgb_mode, "RGB Color Scheme", "Default", "Miami")


--[==========================[Curve]==========================]
ui[keyHolder.lbot_pistol_curve] = gui.Checkbox(groups.curve, keyHolder.lbot_pistol_curve, "Randomize Curve (Pistols)", false)
ui[keyHolder.lbot_pistol_curve_min] = gui.Slider(groups.curve, keyHolder.lbot_pistol_curve_min, "Minimum Curve Value (Pistols)", 0.2, 0, 2);
ui[keyHolder.lbot_pistol_curve_max] = gui.Slider(groups.curve, keyHolder.lbot_pistol_curve_max, "Maximum Curve Value (Pistols)", 0.4, 0, 2);

ui[keyHolder.lbot_smg_curve] = gui.Checkbox(groups.curve, keyHolder.lbot_smg_curve, "Randomize Curve (SMGs)", false)
ui[keyHolder.lbot_smg_curve_min] = gui.Slider(groups.curve, keyHolder.lbot_smg_curve_min, "Minimum Curve Value (SMGs)", 0.2, 0, 2);
ui[keyHolder.lbot_smg_curve_max] = gui.Slider(groups.curve, keyHolder.lbot_smg_curve_max, "Maximum Curve Value (SMGs)", 0.4, 0, 2);

ui[keyHolder.lbot_rifle_curve] = gui.Checkbox(groups.curve, keyHolder.lbot_rifle_curve, "Randomize Curve (Rifles)", false)
ui[keyHolder.lbot_rifle_curve_min] = gui.Slider(groups.curve, keyHolder.lbot_rifle_curve_min, "Minimum Curve Value (Rifles)", 0.2, 0, 2);
ui[keyHolder.lbot_rifle_curve_max] = gui.Slider(groups.curve, keyHolder.lbot_rifle_curve_max, "Maximum Curve Value (Rifles)", 0.4, 0, 2);

ui[keyHolder.lbot_sniper_curve] = gui.Checkbox(groups.curve, keyHolder.lbot_sniper_curve, "Randomize Curve (Snipers)", false)
ui[keyHolder.lbot_sniper_curve_min] = gui.Slider(groups.curve, keyHolder.lbot_sniper_curve_min, "Minimum Curve Value (Snipers)", 0.2, 0, 2);
ui[keyHolder.lbot_sniper_curve_max] = gui.Slider(groups.curve, keyHolder.lbot_sniper_curve_max, "Maximum Curve Value (Snipers)", 0.4, 0, 2);

--[==========================[Smoothing]==========================]
ui[keyHolder.lbot_pistol_smooth] = gui.Checkbox(groups.smoothing, keyHolder.lbot_pistol_smooth, "Randomize Smooth (Pistols)", false)
ui[keyHolder.lbot_pistol_smooth_min] = gui.Slider(groups.smoothing, keyHolder.lbot_pistol_smooth_min, "Minimum Smooth Value (Pistols)", 5, 1, 30)
ui[keyHolder.lbot_pistol_smooth_max] = gui.Slider(groups.smoothing, keyHolder.lbot_pistol_smooth_max, "Maximum Smooth Value (Pistols)", 6, 1, 30)

ui[keyHolder.lbot_smg_smooth] = gui.Checkbox(groups.smoothing, keyHolder.lbot_smg_smooth, "Randomize Smooth (SMGs)", false)
ui[keyHolder.lbot_smg_smooth_min] = gui.Slider(groups.smoothing, keyHolder.lbot_smg_smooth_min, "Minimum Smooth Value (SMGs)", 5, 1, 30)
ui[keyHolder.lbot_smg_smooth_max] = gui.Slider(groups.smoothing, keyHolder.lbot_smg_smooth_max, "Maximum Smooth Value (SMGs)", 6, 1, 30)

ui[keyHolder.lbot_rifle_smooth] = gui.Checkbox(groups.smoothing, keyHolder.lbot_rifle_smooth, "Randomize Smooth (Rifles)", false)
ui[keyHolder.lbot_rifle_smooth_min] = gui.Slider(groups.smoothing, keyHolder.lbot_rifle_smooth_min, "Minimum Smooth Value (Rifles)", 5, 1, 30)
ui[keyHolder.lbot_rifle_smooth_max] = gui.Slider(groups.smoothing, keyHolder.lbot_rifle_smooth_max, "Maximum Smooth Value (Rifles)", 6, 1, 30)

ui[keyHolder.lbot_sniper_smooth] = gui.Checkbox(groups.smoothing, keyHolder.lbot_sniper_smooth, "Randomize Smooth (Snipers)", false)
ui[keyHolder.lbot_sniper_smooth_min] = gui.Slider(groups.smoothing, keyHolder.lbot_sniper_smooth_min, "Minimum Smooth Value (Snipers)", 5, 1, 30)
ui[keyHolder.lbot_sniper_smooth_max] = gui.Slider(groups.smoothing, keyHolder.lbot_sniper_smooth_max, "Maximum Smooth Value (Snipers)", 6, 1, 30)

--[==========================[Legit Misc]==========================]
ui[keyHolder.lbot_triggerbot] = gui.Checkbox(groups.legit_miscellaneous, keyHolder.lbot_triggerbot, "Randomize Triggerbot", false)
ui[keyHolder.lbot_triggerbot_min] = gui.Slider(groups.legit_miscellaneous, keyHolder.lbot_triggerbot_min, "Minimum Triggerbot Delay", 0.03, 0.00, 1.00)
ui[keyHolder.lbot_triggerbot_max] = gui.Slider(groups.legit_miscellaneous, keyHolder.lbot_triggerbot_max, "Maximum Triggerbot Delay", 0.03, 0.00, 1.00)
ui[keyHolder.lbot_backtrack] = gui.Checkbox(groups.legit_miscellaneous, keyHolder.lbot_backtrack, "Randomize Backtrack", false)
ui[keyHolder.lbot_backtrack_min] = gui.Slider(groups.legit_miscellaneous, keyHolder.lbot_backtrack_min, "Minimum Backtrack Ticks", 0.001, 0, 0.2)
ui[keyHolder.lbot_backtrack_max] = gui.Slider(groups.legit_miscellaneous, keyHolder.lbot_backtrack_max, "Maximum Backtrack Ticks", 0.001, 0, 0.2)

local RGBChams = gui.Multibox(groups.visuals, "RGB Chams");
local RGBVars = { "clr_vis_glow_ct", "clr_vis_glow_t", "clr_vis_glow_other", "clr_vis_glow_local", "clr_chams_ct_vis", "clr_chams_ct_invis", "clr_chams_t_vis", "clr_chams_t_invis", "clr_chams_other_vis", "clr_chams_other_invis", "clr_chams_weapon_primary", "clr_chams_weapon_secondary", "clr_chams_ghost_client", "clr_chams_ghost_server", "clr_chams_historyticks", "clr_esp_box_ct_vis", "clr_esp_box_ct_invis", "clr_esp_box_t_vis", "clr_esp_box_t_invis", "clr_esp_box_other_vis", "clr_esp_box_other_invis", "clr_esp_crosshair_recoil" }
-- Too Lazy To Do this rn
local RGBNames = {

}
for i = 1, #RGBVars do
    local RGBVar = RGBVars[i];
    -- TODO: Take from RGBNames instead of setting var as name
    ui[luaKey .. RGBVar .. '_rgb'] = gui.Checkbox(RGBChams, luaKey .. RGBVar .. '_rgb', RGBVar, false);
end
--[==========================[Utils]==========================]
local function drawRectFill(r, g, b, a, x, y, w, h)
    draw.Color(r, g, b, a);
    draw.RoundedRectFill(x, y, x + w, y + h);
end

local function drawOutline(r, g, b, x, y, w, h)
    for i = 1, 15 do
        local a = 255 / i * h;
        draw.Color(r, g, b, a);
        draw.OutlinedRect(x - i, y - i, x + w + i, y + h + i)
    end
end

local function drawText(r, g, b, a, x, y, text, font)
    draw.SetTexture(r, g, b, a);
    if (font ~= nil) then
        draw.SetFont(font);
    end
    draw.Color(r, g, b, a);
    if (text ~= nil) then
        draw.Text(x, y, text);
        return draw.GetTextSize(text);
    end
    return 0, 0;
end

local function urlEncode(url)
    if url ~= nil then
        url = url:gsub("\n", "\r\n")
        url = url:gsub("([^%w ])", function(c)
            string.format("%%%02X", string.byte(c))
        end)
        url = url:gsub(" ", "+")
    end
    return url
end

--[[

local function update()
    if (windowInfo == nil) then
        windowInfo = {};
    end
    for i, v in pairs(ui) do
        windowInfo[i] = v:GetValue();
    end
    local responseToSend = json.encode(windowInfo);
    http.Get('https://forums.lynxmods.com/v1/editConfig?username=%username%&password=%password%&product=%product_id%&config=' .. urlEncode(responseToSend), function(_)
    end);
end

]]--

local function getSmoothRandom(min, max, mult)
    return (ui[min]:GetValue() + mult + math.random() * (ui[max]:GetValue() - ui[min]:GetValue()));
end

local function makeLegitSmooth(var, var2, min, max, mult)
    if (ui[var]:GetValue()) then
        gui.SetValue(var2, getSmoothRandom(min, max, mult));
    end
end

--[[

gui.Button(window, "Update", function()
    update();
end);
--]]

--[==========================[START Anti Aim Functions]==========================]
local function doCycle(var, ui1, ui2, ui3, speed)
    local cache = caches[var];
    if (cache == nil) then
        caches[var] = { ['ticks'] = 0, ['change'] = false, ['swap'] = false };
        cache = caches[var];
    end
    local ticks, change, swap = cache['ticks'], cache['change'], cache['swap'];
    local speed = ui[speed]:GetValue();
    if (ticks > 25) then
        if (change) then
            gui.SetValue(var, swap and ui[ui1]:GetValue() or ui[ui2]:GetValue());
            cache['swap'] = not cache['swap'];
            cache['change'] = false;
        else
            gui.SetValue(var, ui[ui3]:GetValue());
            cache['change'] = true;
        end
        ticks = 0;
    end
    cache['ticks'] = speed > 0 and (ticks + speed) or 0;
end

local function doYawSwap(var, speedVar, angle1, angle2)
    local cache = caches[var];
    if (cache == nil) then
        caches[var] = { ['ticks'] = 0 };
        cache = caches[var];
    end
    local speed, ticks = ui[speedVar]:GetValue(), cache['ticks'];
    if (speed) then
        if ticks > 20 then
            if ticks > 40 then
                gui.SetValue(var, ui[angle1]:GetValue());
                cache['ticks'] = 0;
            end
        else
            gui.SetValue(var, ui[angle2]:GetValue());
            cache['ticks'] = ticks + speed;
        end
    end
end

local function inverseDesync(var, var2, var3, var4)
    local inverseDesync = ui[var]:GetValue();
    if (inverseDesync > 0) then
        ui[var2]:SetValue(0);
        local values = { 58, -58, 116, -116, 29, -29 };
        local curValue = values[inverseDesync];
        local desync = gui.GetValue(var3);
        if (desync == 2 or desync == 3) then
            gui.SetValue(var4, desync == 2 and curValue or (0 - curValue));
        end
    end
end

local function handleSimpleAA(var, settings)
    if (ui[var] == nil or ui[var]:GetValue() == 0) then
        return
    end
    local curSettings = settings[ui[var]:GetValue()];
    for i = 1, #curSettings do
        local sVar, sValue = curSettings[i][1], curSettings[i][2];
        gui.SetValue(sVar, sValue);
    end
end

local function handleSimpleAntiAim()
    -- Standing
    local settings = {
        {
            { keyHolder.desync_cycle_speed, 1 },
            { keyHolder.real_cycle_speed, 0 },
            { keyHolder.real_swap_speed, 0 },
            { keyHolder.desync_inverse, 5 },
            { keyHolder.desync_1, 2 },
            { keyHolder.desync_2, 2 },
            { keyHolder.desync_3, 3 },
            { "rbot_antiaim_stand_real", 1 },
        },
        {
            { keyHolder.desync_cycle_speed, 1 },
            { keyHolder.real_cycle_speed, 0 },
            { keyHolder.real_swap_speed, 0 },
            { keyHolder.desync_inverse, 0 },
            { keyHolder.desync_1, 2 },
            { keyHolder.desync_2, 3 },
            { keyHolder.desync_3, 1 },
            { "rbot_antiaim_stand_real" , 1 },
            { "rbot_antiaim_stand_switch_speed", .15 },
            { "rbot_antiaim_stand_switch_range", 26 },
            { "rbot_antiaim_stand_real_add", 16 },
        },
        {
            { keyHolder.desync_cycle_speed, 1 },
            { keyHolder.real_cycle_speed, 0 },
            { keyHolder.real_swap_speed, 0 },
            { keyHolder.desync_inverse, 0 },
            { keyHolder.desync_1, 2 },
            { keyHolder.desync_2, 3 },
            { keyHolder.desync_3, 1 },
            { "rbot_antiaim_stand_real", 2 },
            { "rbot_antiaim_stand_spinbot_speed", -0.8 },
        }
    }
    handleSimpleAA(keyHolder.simple_main, settings);

    -- Moving
    local settings = {
        {
            { keyHolder.desync_cycle_speed_moving, 1 },
            { keyHolder.real_cycle_speed_moving, 0 },
            { keyHolder.real_swap_speed_moving, 0 },
            { keyHolder.desync_inverse_moving, 5 },
            { keyHolder.desync_1_moving, 2 },
            { keyHolder.desync_2_moving, 2 },
            { keyHolder.desync_3_moving, 3 },
            { "rbot_antiaim_move_real", 1 },
        },
        {
            { keyHolder.desync_cycle_speed_moving, 1 },
            { keyHolder.real_cycle_speed_moving, 0 },
            { keyHolder.real_swap_speed_moving, 0 },
            { keyHolder.desync_inverse_moving, 0 },
            { keyHolder.desync_1_moving, 2 },
            { keyHolder.desync_2_moving, 3 },
            { keyHolder.desync_3_moving, 1 },
            { "rbot_antiaim_move_real", 1 },
            { "rbot_antiaim_move_switch_speed", .15 },
            { "rbot_antiaim_move_switch_range", 26 },
            { "rbot_antiaim_move_real_add", 16 },
        },
        {
            { keyHolder.desync_cycle_speed_moving, 1 },
            { keyHolder.real_cycle_speed_moving, 0 },
            { keyHolder.real_swap_speed_moving, 0 },
            { keyHolder.desync_inverse_moving, 0 },
            { keyHolder.desync_1_moving, 2 },
            { keyHolder.desync_2_moving, 3 },
            { keyHolder.desync_3_moving, 1 },
            { "rbot_antiaim_move_real", 2 },
            { "rbot_antiaim_move_spinbot_speed", -0.8 },
        }
    };
    handleSimpleAA(keyHolder.simple_main_moving, settings);
end


--[==========================[END Anti Aim Functions]==========================]

--[==========================[Handlers]==========================]

local function handleAntiAim()

    -- Standing
    doCycle('rbot_antiaim_stand_desync', keyHolder.desync_1, keyHolder.desync_2, keyHolder.desync_3, keyHolder.desync_cycle_speed);
    doCycle('rbot_antiaim_stand_real', keyHolder.real_1, keyHolder.real_2, keyHolder.real_3, keyHolder.real_cycle_speed);
    doYawSwap('rbot_antiaim_stand_real_add', keyHolder.real_swap_speed, keyHolder.angle_1, keyHolder.angle_1);
    inverseDesync(keyHolder.desync_inverse, keyHolder.real_swap_speed, 'rbot_antiaim_stand_desync', 'rbot_antiaim_stand_real_add');

    -- Moving
    doCycle('rbot_antiaim_move_desync', keyHolder.desync_1_moving, keyHolder.desync_2_moving, keyHolder.desync_3_moving, keyHolder.desync_cycle_speed_moving);
    doCycle('rbot_antiaim_move_real', keyHolder.real_1_moving, keyHolder.real_2_moving, keyHolder.real_3_moving, keyHolder.real_cycle_speed_moving);
    doYawSwap('rbot_antiaim_move_real_add', keyHolder.real_swap_speed_moving, keyHolder.angle_1_moving, keyHolder.angle_1_moving);
    inverseDesync(keyHolder.desync_inverse_moving, keyHolder.real_swap_speed_moving, 'rbot_antiaim_move_desync', 'rbot_antiaim_move_real_add');
end

local function handleVisuals()
    local lp = entities.GetLocalPlayer();
    if (lp == nil) then
        return
    end ;
    -- Kill Feed
    local kill_effect = ui[keyHolder.kill_effect]:GetValue();
    if (caches['kill_effect'] and kill_effect > 0) then
        local timer = caches['kill_effect_timer'];
        local mats = { 'mat_ambient_light_r', 'mat_ambient_light_g', 'mat_ambient_light_b' };
        if (timer == nil) then
            -- Set this to 20 and not 0 to make kill effect show on first kill ;)
            caches['kill_effect_timer'] = 40;
            timer = caches['kill_effect_timer'];
        end
        if (timer < 2) then
            caches['kill_effect'] = false;
            caches['kill_effect_timer'] = 40;
            for i = 1, #mats do
                client.SetConVar(mats[i], 0, true);
            end
        else
            client.SetConVar(mats[kill_effect], timer * 0.01, true);
            caches['kill_effect_timer'] = timer - 1;
        end
    end

    -- Full Bright
    client.SetConVar("mat_fullbright", ui[keyHolder.full_bright]:GetValue() and 1 or 0, true);

    -- Watermark, Design by Rab
    if (ui[keyHolder.watermark]:GetValue()) then
        if (caches['watermark'] == nil) then
            caches['watermark'] = { x = 50, y = 50, w = 200, h = 50, mouseX = 0, mouseY = 0, dx = 0, dy = 0, shouldDrag = false, fontTiny = draw.CreateFont("Tahoma", 11), fontSmall = draw.CreateFont("Tahoma", 13); }
        end
        local watermark = caches['watermark'];
        local time = string.gsub(os.date("%X"), ":", " : ");
        drawRectFill(8, 8, 8, 255, watermark.x, watermark.y, watermark.w, watermark.h);
        drawOutline(8, 8, 8, watermark.x, watermark.y, watermark.w, watermark.h);
        draw.SetFont(watermark.fontSmall);
        local msg = 'Welcome %username%'
        local tw, th = draw.GetTextSize(msg);
        local y = watermark.y + 5;
        drawText(128, 128, 128, 255, watermark.x + (watermark.w - tw) / 2, y, msg, watermark.fontSmall);
        y = y + th + 2;
        draw.SetFont(watermark.fontTiny);
        msg = 'Project Entropy'
        tw, th = draw.GetTextSize(msg)
        drawText(128, 128, 128, 255, watermark.x + (watermark.w - tw) / 2, y, msg, watermark.fontTiny);
        y = y + th + 3;
        draw.SetFont(watermark.fontTiny);
        msg = time;
        tw, th = draw.GetTextSize(msg)
        drawText(128, 128, 128, 255, watermark.x + (watermark.w - tw) / 2, y, msg, watermark.fontTiny);
        y = y + th + 2;
        -- Drag
        if (input.IsButtonDown(1)) then
            watermark. mouseX, watermark.mouseY = input.GetMousePos();
            if watermark.shouldDrag then
                watermark.x = watermark.mouseX - watermark.dx;
                watermark.y = watermark.mouseY - watermark.dy;
            end
            if watermark.mouseX >= watermark.x - 15 and watermark.mouseX <= watermark.x + watermark.w + 15 and watermark.mouseY >= watermark.y - 15 and watermark.mouseY <= watermark.y + watermark.h + 15 then
                watermark. shouldDrag = true;
                watermark.dx = watermark.mouseX - watermark.x;
                watermark.dy = watermark.mouseY - watermark.y;
            end
        else
            watermark. shouldDrag = false;
        end
    end

    -- Engine Radar
    local engine_radar = ui[keyHolder.engine_radar]:GetValue();
    local CCSPlayer = entities.FindByClass("CCSPlayer");
    if engine_radar then
        caches['engine_radar_spotted'] = true
        for _, p in pairs(CCSPlayer) do
            p:SetProp("m_bSpotted", 1);
        end
    elseif not engine_radar and caches['engine_radar_spotted'] then
        caches['engine_radar_spotted'] = false
        for _, p in pairs(CCSPlayer) do
            p:SetProp("m_bSpotted", 0);
        end
    end

    -- Disable Post Processing
    client.SetConVar("mat_postprocess_enable", ui[keyHolder.disable_postprocess]:GetValue() and 0 or 1, true);

    -- Sniper crosshair
    if (ui[keyHolder.sniper_crosshair]:GetValue()) then
        local shouldShowCrosshair = lp ~= nil and lp:IsAlive() and gui.GetValue("vis_thirdperson_dist") == 0 and lp:GetProp("m_bIsScoped") == 0;
        client.SetConVar("weapon_debug_spread_show", shouldShowCrosshair and 3 or 0, true);
    end

    -- Double scope
    if (ui[keyHolder.double_scope]:GetValue()) then
        gui.SetValue("vis_view_fov", lp ~= nil and lp:GetProp("m_bIsScoped") ~= 0 and 0 or caches['vis_view_fov']);
    end

    -- Transparent On Scope
    if (ui[keyHolder.transparent_on_scope]:GetValue()) then
        local sR, sG, sB, sA = unpack(caches['clr_chams_ghost_server']);
        local cR, cG, cB, cA = unpack(caches['clr_chams_ghost_client']);
        if (lp ~= nil and lp:GetProp("m_bIsScoped") == 1) then
            sA, cA = 10, 10;
        end
        gui.SetValue("clr_chams_ghost_client", sR, sG, sB, sA);
        gui.SetValue("clr_chams_ghost_server", cR, cG, cB, cA);
    end

    -- Spread Tracers
    if (ui[keyHolder.spread_tracers]:GetValue()) then
        client.SetConVar("cl_weapon_debug_show_accuracy", 1, true);
        client.SetConVar("cl_weapon_debug_show_accuracy_duration", ui[keyHolder.spread_tracers_duration]:GetValue(), true);
    else
        client.SetConVar("cl_weapon_debug_show_accuracy", 0, true);
    end

    -- RGB Chams
    for i = 1, #RGBVars do
        local RGBVar = RGBVars[i];
        if (ui[luaKey .. RGBVar .. '_rgb']:GetValue()) then

            if (ui[keyHolder.rgb_mode]:GetValue()) == 0 then

                local r = math.floor(math.sin((globals.RealTime()) * 2) * 127 + 128)
                local g = math.floor(math.sin((globals.RealTime()) * 2 + 2) * 127 + 128)
                local b = math.floor(math.sin((globals.RealTime()) * 2 + 4) * 127 + 128)
                gui.SetValue(RGBVar, r, g, b);

            else

                local r = math.floor(math.sin((globals.RealTime()) * 2) * 85 + 144)
                local g = math.floor(math.sin((globals.RealTime()) * 2 + 2) * 85 + 144)
                local b = math.floor(math.sin((globals.RealTime()) * 2 + 4) * 85 + 144)
                gui.SetValue(RGBVar, r, g, b);
            end
        end
    end
end
local function handleRageBot()
    -- Scout Resolver
    local scoutResolverKey = ui[keyHolder.rbot_scoutresolver_key]:GetValue();
    if (scoutResolverKey > 0 and input.IsButtonDown(scoutResolverKey)) then
        local msc_fakelatency_enable, rbot_delayshot = caches['msc_fakelatency_enable'], caches['rbot_delayshot'];
        local scoutFakeLag, scoutDelayshot = ui[keyHolder.rbot_scoutresolver_fakelatency]:GetValue(), ui[keyHolder.rbot_scoutresolver_delayshot]:GetValue();
        gui.SetValue('msc_fakelatency_enable', scoutFakeLag and false or msc_fakelatency_enable);
        gui.SetValue('rbot_delayshot', scoutDelayshot and 1 or rbot_delayshot);
    end
end

local function handleMisc()
    -- Slow-Walk Shuffle
    local slowwalkShuffle = ui[keyHolder.slowwalk_shuffle]:GetValue();
    local slowwalkKey = gui.GetValue("msc_slowwalk");
    if (slowwalkShuffle) then
        local isSlowwalking = input.IsButtonDown(slowwalkKey);
        local fakeLagVars = { 'msc_fakelag_attack', 'msc_fakelag_mode', 'msc_fakelag_enable', 'msc_fakelag_key' };
        local override = { ui[keyHolder.slowwalk_shuffle_ws]:GetValue(), ui[keyHolder.slowwalk_shuffle_mode]:GetValue(), true, slowwalkKey }
        for i = 1, #fakeLagVars do
            local var = fakeLagVars[i];
            gui.SetValue(var, isSlowwalking and override[i] or caches[var]);
        end
    end
end

local function handleLegitbot()
    -- Curve
    makeLegitSmooth(keyHolder.lbot_pistol_curve, 'lbot_pistol_curve', keyHolder.lbot_pistol_curve_min, keyHolder.lbot_pistol_curve_max, 0.1);
    makeLegitSmooth(keyHolder.lbot_smg_curve, 'lbot_smg_curve', keyHolder.lbot_smg_curve_min, keyHolder.lbot_smg_curve_max, 0.1);
    makeLegitSmooth(keyHolder.lbot_rifle_curve, 'lbot_rifle_curve', keyHolder.lbot_rifle_curve_min, keyHolder.lbot_rifle_curve_max, 0.1);
    makeLegitSmooth(keyHolder.lbot_sniper_curve, 'lbot_sniper_curve', keyHolder.lbot_sniper_curve_min, keyHolder.lbot_sniper_curve_max, 0.1);

    -- Smoothing
    makeLegitSmooth(keyHolder.lbot_pistol_smooth, 'lbot_pistol_smooth', keyHolder.lbot_pistol_smooth_min, keyHolder.lbot_pistol_smooth_max, 0.1);
    makeLegitSmooth(keyHolder.lbot_smg_smooth, 'lbot_smg_smooth', keyHolder.lbot_smg_smooth_min, keyHolder.lbot_smg_smooth_max, 0.1);
    makeLegitSmooth(keyHolder.lbot_rifle_smooth, 'lbot_rifle_smooth', keyHolder.lbot_rifle_smooth_min, keyHolder.lbot_rifle_smooth_max, 0.1);
    makeLegitSmooth(keyHolder.lbot_sniper_smooth, 'lbot_sniper_smooth', keyHolder.lbot_sniper_smooth_min, keyHolder.lbot_sniper_smooth_max, 0.1);

    -- Triggerbot
    makeLegitSmooth(keyHolder.lbot_triggerbot, 'lbot_trg_delay', keyHolder.lbot_triggerbot_min, keyHolder.lbot_triggerbot_max, 0.01);

    -- Bcaktrack
    local backtrackTicks = caches['backtrack_ticks'];
    if (backtrackTicks == nil) then
        caches['backtrack_ticks'] = 0;
        backtrackTicks = caches['backtrack_ticks'];
    end
    if (ui[keyHolder.lbot_backtrack]:GetValue()) then
        if (backtrackTicks > 20) then
            caches['backtrack_ticks'] = 0;
            gui.SetValue('lbot_positionadjustment', getSmoothRandom(keyHolder.lbot_backtrack_min, keyHolder.lbot_backtrack_max, 0.001))
        else
            caches['backtrack_ticks'] = backtrackTicks + 0.05;
        end
    end
end

--[==========================[Callbacks]==========================]
callbacks.Register("FireGameEvent", function(event)
    if (event == nil) then
        return
    end ;
    local en = event:GetName();
    local lp = entities.GetLocalPlayer();
    if (lp == nil) then
        return
    end ;
    local lpIndex = lp:GetIndex();
    local user, aent = entities.GetByUserID(event:GetInt("userid")), entities.GetByUserID(event:GetInt("attacker"))
    local uid, attacker = 0, 0;
    if (user ~= nil) then
        uid = user:GetIndex();
    end
    if (aent ~= nil) then
        attacker = aent:GetIndex()
    end
    if (en == 'player_hurt') then
        -- Handle Hitsound
        local hitsound = ui[keyHolder.custom_hit_sound]:GetValue();
        if (hitsound > 0) then
            -- Silence aimwares hitmarker, peasant.
            if (gui.GetValue('msc_hitmarker_volume') ~= 0) then
                gui.SetValue("msc_hitmarker_volume", 0);
            end
            if (attacker == lpIndex and uid ~= lpIndex) then
                local hitsoundPaths = { 'weapons\\scar20\\scar20_boltback', 'buttons\\arena_switch_press_02.wav', 'ambient\\creatures\\chicken_death_01', 'training\\pointscored' };
                local hitsoundPath = hitsoundPaths[hitsound];
                client.Command('play ' .. hitsoundPath, true);
            end
        end
    elseif (en == 'player_death') then
        -- Kill Effect
        if (attacker == lpIndex and uid ~= lpIndex) then
            if ui[keyHolder.kill_effect]:GetValue() > 0 then
                caches['kill_effect'] = true
            end
        end
    end
end);

callbacks.Register("Draw", function()
    window:SetActive(showMenu:GetValue() and references.aimware:IsActive());
    advancedWindow:SetActive(showAdvanced:GetValue() and references.aimware:IsActive());

    -- P Clean Code
    handleAntiAim();
    handleVisuals();
    handleRageBot();
    handleMisc();
    handleLegitbot();
    handleSimpleAntiAim();
end);

client.AllowListener("player_hurt");
client.AllowListener("player_death");