local luaName = "Project Entropy";
local luaKey = 'lynx_' .. luaName:lower():gsub(" ", "_") .. '_';
local mx, my;
local curTab = 1;
local ui = {};
local windowInfo;
local settingsLoaded = false;
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

local references = {
    aimware = gui.Reference("MENU"),
    miscGeneral = gui.Reference("SETTINGS", string.char(77, 105, 115, 99, 101, 108, 108, 97, 110, 101, 111, 117, 115));
};
local fonts = {
    ['tab'] = draw.CreateFont("Segoe UI", 16, 600);
}

--[==========================[Start Lynx API]==========================]
local function inBounds(x, y, x1, y1)
    return mx >= x and mx <= x1 and my >= y and my <= y1;
end

local function unpack(t, i)
    i = i or 1
    if t[i] ~= nil then
        return t[i], unpack(t, i + 1)
    end
end

local function addGuiComp(key, comp, group, ...)
    ui[#ui + 1] = { luaKey .. key, _G['gui'][comp](group, luaKey .. key, ...) };
end

local function getUIVar(key)
    for i = 1, #ui do
        local v = ui[i];
        if (v[1] == luaKey .. key) then
            return v[2]:GetValue();
        end
    end
end
--[==========================[End Lynx API]==========================]
local showMenu = gui.Checkbox(references.miscGeneral, luaKey .. "showmenu", "[Lynx] " .. luaName, false);
local mainWindow = gui.Window("test_window", "Project Entropy - Presented by Lynx", 100, 100, 800, 70);

local subWindows = {
    gui.Window("lynx_etropy_rage_tab", "", 0, 0, 800, 530);
    gui.Window("lynx_etropy_legit_tab", "", 0, 0, 800, 530);
    gui.Window("lynx_etropy_visuals_tab", "", 0, 0, 800, 530);
}

-- Rage Window
local groupW = 240;
local groupH = 430;
local rageWindow = subWindows[1];

-- Anti Aim Preset
local antiAimPresetH = 120;
local antiAim = gui.Groupbox(rageWindow, "Anti-Aim-Presets", 20, 15, groupW, antiAimPresetH);
local presets = { "Custom", "Standard", "Special", "God Spin" };
addGuiComp("standing_anti_aim", "Combobox", antiAim, "Standing AA Preset", unpack(presets));
addGuiComp("moving_anti_aim", "Combobox", antiAim, "Moving AA Preset", unpack(presets));

-- Fake Lag
local slowWalkH = 120;
local slowWalk = gui.Groupbox(rageWindow, "Slow Walk", 20, 15 * 2 + slowWalkH, groupW, 160);
addGuiComp("slowwalk_fakelag", "Checkbox", slowWalk, "Slow Walk Fake Lag", true);
addGuiComp("slowwalk_shuffle_mode", "Combobox", slowWalk, "Slow Walk Fakelag Mode", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek");
addGuiComp("slowwalk_shuffle_ws", "Checkbox", slowWalk, "Slow Walk Fake Lag While Shooting", false);

-- Resolver
local resolver = gui.Groupbox(rageWindow, "Resolver", 20, 15 * 3 + slowWalkH * 2 + 40, groupW, 120);
addGuiComp("scout_resolver_key", "Keybox", resolver, "Scout Resolver", 4);
local resolverCustomizations = gui.Multibox(resolver, "Scout Resolver Customization");
addGuiComp("scout_resolver_fakelatency", "Checkbox", resolverCustomizations, "Disable Fake latency", false);
addGuiComp("scout_resolver_delayshot", "Checkbox", resolverCustomizations, "Accurate Unlag", false);

-- Anti Aim Standing
local antiAimStanding = gui.Groupbox(rageWindow, "Standing Anti-Aim", 20 * 2 + groupW, 15, groupW, groupH);

-- Anti Aim Moving
local antiAimMoving = gui.Groupbox(rageWindow, "Moving Anti-Aim", 20 * 3 + groupW * 2, 15, groupW, groupH);

-- Anti Aim Settings
local antiAimComps = {
    { "desync_cycle_speed", "Combobox", { "Desync Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme" } },
    { "real_cycle_speed", "Combobox", { "Yaw Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme" } },
    { "real_swap_speed", "Combobox", { "Angle Swap Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme" } },
    { "desync_inverse", "Combobox", { "Inverse on Desync", "Off", "Match", "Reverse", "Wide Match", "Wide Reverse", "Half Match", "Half Reverse" } },
    { "desync_1", "Combobox", { "Desync 1", "Off", "Still", "Balance", "Stretch", "Jitter" } },
    { "desync_2", "Combobox", { "Desync 2", "Off", "Still", "Balance", "Stretch", "Jitter" } },
    { "desync_3", "Combobox", { "Desync 3", "Off", "Still", "Balance", "Stretch", "Jitter" } },
    { "real_1", "Combobox", { "Real 1", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift" } },
    { "real_2", "Combobox", { "Real 2", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift" } },
    { "real_3", "Combobox", { "Real 3", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift" } },
    { "angle_1", "Slider", { "Custom Angle (Default: -90)", -90, -180, 180 } },
    { "angle_2", "Slider", { "Custom Angle (Default: 90)", 90, -180, 180 } }
}

for i = 1, #antiAimComps do
    local antiAimComp = antiAimComps[i];
    addGuiComp(antiAimComp[1], antiAimComp[2], antiAimStanding, unpack(antiAimComp[3]));
    addGuiComp(antiAimComp[1] .. '_moving', antiAimComp[2], antiAimMoving, unpack(antiAimComp[3]));
end

-- Legit Window
local groupW = 240;
local groupH = 430;
local legitWindow = subWindows[2];

-- Curve
local curve = gui.Groupbox(legitWindow, "Curve", 20, 15, groupW, groupH);

-- smoothing
local smoothing = gui.Groupbox(legitWindow, "Smoothing", 20 * 2 + groupW, 15, groupW, groupH);

local legitWeapons = { "Pistol", "SMG", "Rifle", "Shotgun", "Sniper" }
for i = 1, #legitWeapons do
    local legitWeapon = legitWeapons[i];
    local var = legitWeapon:lower();
    addGuiComp('lbot_' .. var .. '_curve', 'Checkbox', curve, legitWeapon .. ' Random Curve', false)
    addGuiComp('lbot_' .. var .. '_curve_min', 'Slider', curve, legitWeapon .. ' Random Curve Min', 0.2, 0, 2)
    addGuiComp('lbot_' .. var .. '_curve_max', 'Slider', curve, legitWeapon .. ' Random Curve Max', 0.4, 0, 2)
    addGuiComp('lbot_' .. var .. '_smooth', 'Checkbox', smoothing, legitWeapon .. ' Random Smooth', false)
    addGuiComp('lbot_' .. var .. '_smooth_min', 'Slider', smoothing, legitWeapon .. ' Random Smooth Min', 5, 1, 30)
    addGuiComp('lbot_' .. var .. '_smooth_max', 'Slider', smoothing, legitWeapon .. ' Random Smooth Max', 6, 1, 30)
end

-- Anti Aim Moving
local legitMisc = gui.Groupbox(legitWindow, "Miscellaneous", 20 * 3 + groupW * 2, 15, groupW, groupH);
addGuiComp('lbot_triggerbot', 'Checkbox', legitMisc, "Randomize Triggerbot", false);
addGuiComp('lbot_triggerbot_min', 'Slider', legitMisc, "Minimum Triggerbot Delay", 0.03, 0.00, 1.00);
addGuiComp('lbot_triggerbot_max', 'Slider', legitMisc, "Maximum Triggerbot Delay", 0.03, 0.00, 1.00);
addGuiComp('lbot_backtrack', 'Checkbox', legitMisc, "Randomize Backtrack", false);
addGuiComp('lbot_backtrack_min', 'Slider', legitMisc, "Minimum Backtrack Ticks", 0.001, 0, 0.2);
addGuiComp('lbot_backtrack_max', 'Slider', legitMisc, "Maximum Backtrack Ticks", 0.001, 0, 0.2);

-- Visuals Window
local visualsWindow = subWindows[3];
local main = gui.Groupbox(visualsWindow, "Main", 20, 15, groupW, groupH);
addGuiComp('custom_hit_sound', 'Combobox', main, "Hitsound", "Off", "Entropy", "Skeet", "Chicken", "Casino");
addGuiComp('kill_effect', 'Combobox', main, "Kill Effect", "Off", "Red", "Green", "Blue");
addGuiComp('full_bright', 'Checkbox', main, "Fullbright", false);
addGuiComp('watermark', 'Checkbox', main, "Watermark", false);
addGuiComp('engine_radar', 'Checkbox', main, "Engine Radar", false);
addGuiComp('disable_postprocess', 'Checkbox', main, "Disable Post-Processing", false);
addGuiComp('sniper_crosshair', 'Checkbox', main, "Force Crosshair on Sniper", false);
addGuiComp('double_scope', 'Checkbox', main, "Zoom on Double Scope", false);
addGuiComp('transparent_on_scope', 'Checkbox', main, "Transparent on Scope", false);
addGuiComp('spread_tracers', 'Checkbox', main, "Spread Tracers", false);
addGuiComp('spread_tracers_duration', 'Slider', main, "Spread Tracer Duration", 2, 1, 10);
local RGBChams = gui.Multibox(main, "RGB Chams");
local RGBVars = { "clr_vis_glow_ct", "clr_vis_glow_t", "clr_vis_glow_other", "clr_vis_glow_local", "clr_chams_ct_vis", "clr_chams_ct_invis", "clr_chams_t_vis", "clr_chams_t_invis", "clr_chams_other_vis", "clr_chams_other_invis", "clr_chams_weapon_primary", "clr_chams_weapon_secondary", "clr_chams_ghost_client", "clr_chams_ghost_server", "clr_chams_historyticks", "clr_esp_box_ct_vis", "clr_esp_box_ct_invis", "clr_esp_box_t_vis", "clr_esp_box_t_invis", "clr_esp_box_other_vis", "clr_esp_box_other_invis", "clr_esp_crosshair_recoil" }
-- Too Lazy To Do this rn
local RGBNames = {}
for i = 1, #RGBVars do
    local RGBVar = RGBVars[i];
    -- TODO: Take from RGBNames instead of setting var as name
    addGuiComp(luaKey .. RGBVar .. '_rgb', 'Checkbox', RGBChams, RGBVar, false);
end

-- Tab
gui.Custom(mainWindow, "lynx_entropy_tab", 155, 5, 0, 0, function(x, y)
    local tabs = { 'RAGE', 'LEGIT', "VISUALS" };
    local dpiscale = gui.GetValue("dpi_Scale");
    for i, v in ipairs(tabs) do
        local w, h = 101 * dpiscale, 30 * dpiscale;
        local x = x + (w * i);
        local inBound = inBounds(x, y, x + w, y + h);
        curTab = (inBound and input.IsButtonPressed(1)) and i or curTab;

        -- Render Tab Background
        draw.Color(gui.GetValue('clr_gui_tablist' .. ((i == curTab or inBound) and '2' or '1')));
        draw.FilledRect(x, y, x + w, y + h);

        -- Render Tab Text
        draw.SetFont(fonts['tab']);
        local tw, th = draw.GetTextSize(v);
        draw.Color(gui.GetValue('clr_gui_tablist4'));
        draw.Text(x + (w - tw) / 2, y + (h - th) / 2, v);
    end
end);

local function getSmoothRandom(min, max, mult)
    return (getUIVar(min) + mult + math.random() * (getUIVar(max) - getUIVar(min)));
end

local function makeLegitSmooth(var, var2, min, max, mult)
    if (getUIVar(var)) then
        gui.SetValue(var2, getSmoothRandom(min, max, mult));
    end
end

--[==========================[START Anti Aim Functions]==========================]
local function doCycle(var, ui1, ui2, ui3, speed)
    local cache = caches[var];
    if (cache == nil) then
        caches[var] = { ['ticks'] = 0, ['change'] = false, ['swap'] = false };
        cache = caches[var];
    end
    local ticks, change, swap = cache['ticks'], cache['change'], cache['swap'];

    local speed = getUIVar(speed);
    if (ticks > 25) then
        if (change) then
            gui.SetValue(var, swap and getUIVar(ui1) or getUIVar(ui2));
            cache['swap'] = not cache['swap'];
            cache['change'] = false;
        else
            gui.SetValue(var, getUIVar(ui3));
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
    local speed, ticks = getUIVar(speedVar), cache['ticks'];
    if (speed) then
        if ticks > 20 then
            if ticks > 40 then
                gui.SetValue(var, getUIVar(angle1));
                cache['ticks'] = 0;
                return
            end
        end
        gui.SetValue(var, getUIVar(angle2));
        cache['ticks'] = ticks + speed;
    end
end

local function inverseDesync(var, var2, var3, var4)
    local inverseDesync = getUIVar(var);
    if (inverseDesync > 0) then
        gui.SetValue(var2, 0);
        --ui[var2]:SetValue(0);
        local values = { 58, -58, 116, -116, 29, -29 };
        local curValue = values[inverseDesync];
        local desync = gui.GetValue(var3);
        if (desync == 2 or desync == 3) then
            gui.SetValue(var4, desync == 2 and curValue or (0 - curValue));
        end
    end
end

local function handleSimpleAA(var, settings)

    if (getUIVar(var) == nil or getUIVar(var) == 0) then
        return
    end

    local curSettings = settings[getUIVar(var)];
    for i = 1, #curSettings do
        local sVar, sValue = curSettings[i][1], curSettings[i][2];
        gui.SetValue(sVar, sValue);
    end
end

local function handlePresets()
    -- Standing
    local settings = {
        {
            { luaKey .. 'desync_cycle_speed', 1 },
            { luaKey .. 'real_cycle_speed', 0 },
            { luaKey .. 'real_swap_speed', 0 },
            { luaKey .. 'desync_inverse', 5 },
            { luaKey .. 'desync_1', 2 },
            { luaKey .. 'desync_2', 2 },
            { luaKey .. 'desync_3', 3 },
            { "rbot_antiaim_stand_real", 1 },
        },
        {
            { luaKey .. 'desync_cycle_speed', 1 },
            { luaKey .. 'real_cycle_speed', 0 },
            { luaKey .. 'real_swap_speed', 0 },
            { luaKey .. 'desync_inverse', 0 },
            { luaKey .. 'desync_1', 2 },
            { luaKey .. 'desync_2', 3 },
            { luaKey .. 'desync_3', 1 },
            { "rbot_antiaim_stand_real", 1 },
            { "rbot_antiaim_stand_switch_speed", .15 },
            { "rbot_antiaim_stand_switch_range", 26 },
            { "rbot_antiaim_stand_real_add", 16 },
        },
        {
            { luaKey .. 'desync_cycle_speed', 1 },
            { luaKey .. 'real_cycle_speed', 0 },
            { luaKey .. 'real_swap_speed', 0 },
            { luaKey .. 'desync_inverse', 0 },
            { luaKey .. 'desync_1', 2 },
            { luaKey .. 'desync_2', 3 },
            { luaKey .. 'desync_3', 1 },
            { "rbot_antiaim_stand_real", 2 },
            { "rbot_antiaim_stand_spinbot_speed", -0.8 },
        }
    }
    handleSimpleAA('standing_anti_aim', settings);

    -- Moving
    local settings = {
        {
            { luaKey .. 'desync_cycle_speed_moving', 1 },
            { luaKey .. 'real_cycle_speed_moving', 0 },
            { luaKey .. 'real_swap_speed_moving', 0 },
            { luaKey .. 'desync_inverse_moving', 5 },
            { luaKey .. 'desync_1_moving', 2 },
            { luaKey .. 'desync_2_moving', 2 },
            { luaKey .. 'desync_3_moving', 3 },
            { "rbot_antiaim_move_real", 1 },
        },
        {
            { luaKey .. 'desync_cycle_speed_moving', 1 },
            { luaKey .. 'real_cycle_speed_moving', 0 },
            { luaKey .. 'real_swap_speed_moving', 0 },
            { luaKey .. 'desync_inverse_moving', 0 },
            { luaKey .. 'desync_1_moving', 2 },
            { luaKey .. 'desync_2_moving', 3 },
            { luaKey .. 'desync_3_moving', 1 },
            { "rbot_antiaim_move_real", 1 },
            { "rbot_antiaim_move_switch_speed", .15 },
            { "rbot_antiaim_move_switch_range", 26 },
            { "rbot_antiaim_move_real_add", 16 },
        },
        {
            { luaKey .. 'desync_cycle_speed_moving', 1 },
            { luaKey .. 'real_cycle_speed_moving', 0 },
            { luaKey .. 'real_swap_speed_moving', 0 },
            { luaKey .. 'desync_inverse_moving', 0 },
            { luaKey .. 'desync_1_moving', 2 },
            { luaKey .. 'desync_2_moving', 3 },
            { luaKey .. 'desync_3_moving', 1 },
            { "rbot_antiaim_move_real", 2 },
            { "rbot_antiaim_move_spinbot_speed", -0.8 },
        }
    };
    handleSimpleAA('moving_anti_aim', settings);
end

--[==========================[END Anti Aim Functions]==========================]


--[==========================[Handlers]==========================]

local function handleAntiAim()

    -- Standing
    doCycle('rbot_antiaim_stand_desync', 'desync_1', 'desync_2', 'desync_3', 'desync_cycle_speed');
    doCycle('rbot_antiaim_stand_real', 'real_1', 'real_2', 'real_3', 'real_cycle_speed');
    doYawSwap('rbot_antiaim_stand_real_add', 'real_swap_speed', 'angle_1', 'angle_2');
    inverseDesync('desync_inverse', luaKey .. 'real_swap_speed', 'rbot_antiaim_stand_desync', 'rbot_antiaim_stand_real_add');

    -- Moving
    doCycle('rbot_antiaim_move_desync', 'desync_1_moving', 'desync_2_moving', 'desync_3_moving', 'desync_cycle_speed_moving');
    doCycle('rbot_antiaim_move_real', 'real_1_moving', 'real_2_moving', 'real_3_moving', 'real_cycle_speed_moving');
    doYawSwap('rbot_antiaim_move_real_add', 'real_swap_speed_moving', 'angle_1_moving', 'angle_2_moving');
    inverseDesync('desync_inverse_moving', luaKey .. 'real_swap_speed_moving', 'rbot_antiaim_move_desync', 'rbot_antiaim_move_real_add');
end

local function handleResolver()
    -- Scout Resolver
    local scoutResolverKey = getUIVar('scout_resolver_key');
    if (scoutResolverKey > 0 and input.IsButtonDown(scoutResolverKey)) then
        local msc_fakelatency_enable, rbot_delayshot = caches['msc_fakelatency_enable'], caches['rbot_delayshot'];
        local scoutFakeLag, scoutDelayshot = getUIVar('scout_resolver_fakelatency'), getUIVar('scout_resolver_delayshot');
        gui.SetValue('msc_fakelatency_enable', scoutFakeLag and false or msc_fakelatency_enable);
        gui.SetValue('rbot_delayshot', scoutDelayshot and 1 or rbot_delayshot);
    end
end

local function handleSlowwalk()
    -- Slow-Walk Shuffle
    local slowwalkShuffle = getUIVar('slowwalk_fakelag');
    local slowwalkKey = gui.GetValue("msc_slowwalk");
    if (slowwalkShuffle) then
        local isSlowwalking = slowwalkKey > 0 and input.IsButtonDown(slowwalkKey);
        local fakeLagVars = { 'msc_fakelag_attack', 'msc_fakelag_mode', 'msc_fakelag_enable', 'msc_fakelag_key' };
        local override = { getUIVar('slowwalk_shuffle_ws'), getUIVar('slowwalk_shuffle_mode'), true, slowwalkKey }
        for i = 1, #fakeLagVars do
            local var = fakeLagVars[i];
            gui.SetValue(var, isSlowwalking and override[i] or caches[var]);
        end
    end
end

local function handleLegitbot()
    -- Curve
    makeLegitSmooth('lbot_pistol_curve', 'lbot_pistol_curve', 'lbot_pistol_curve_min', 'lbot_pistol_curve_max', 0.1);
    makeLegitSmooth('lbot_smg_curve', 'lbot_smg_curve', 'lbot_smg_curve_min', 'lbot_smg_curve_max', 0.1);
    makeLegitSmooth('lbot_shotgun_curve', 'lbot_shotgun_curve', 'lbot_shotgun_curve_min', 'lbot_shotgun_curve_max', 0.1);
    makeLegitSmooth('lbot_rifle_curve', 'lbot_rifle_curve', 'lbot_rifle_curve_min', 'lbot_rifle_curve_max', 0.1);
    makeLegitSmooth('lbot_sniper_curve', 'lbot_sniper_curve', 'lbot_sniper_curve_min', 'lbot_sniper_curve_max', 0.1);

    -- Smoothing
    makeLegitSmooth('lbot_pistol_smooth', 'lbot_pistol_smooth', 'lbot_pistol_smooth_min', 'lbot_pistol_smooth_max', 0.1);
    makeLegitSmooth('lbot_smg_smooth', 'lbot_smg_smooth', 'lbot_smg_smooth_min', 'lbot_smg_smooth_max', 0.1);
    makeLegitSmooth('lbot_rifle_smooth', 'lbot_rifle_smooth', 'lbot_rifle_smooth_min', 'lbot_rifle_smooth_max', 0.1);
    makeLegitSmooth('lbot_sniper_smooth', 'lbot_sniper_smooth', 'lbot_sniper_smooth_min', 'lbot_sniper_smooth_max', 0.1);
    makeLegitSmooth('lbot_shotgun_smooth', 'lbot_shotgun_smooth', 'lbot_shotgun_smooth_min', 'lbot_shotgun_smooth_max', 0.1);

    -- Triggerbot
    makeLegitSmooth('lbot_triggerbot', 'lbot_trg_delay', 'lbot_triggerbot_min', 'lbot_triggerbot_max', 0.01);

    -- Bcaktrack
    local backtrackTicks = caches['backtrack_ticks'];
    if (backtrackTicks == nil) then
        caches['backtrack_ticks'] = 0;
        backtrackTicks = caches['backtrack_ticks'];
    end
    if (getUIVar('lbot_backtrack')) then
        if (backtrackTicks > 20) then
            caches['backtrack_ticks'] = 0;
            gui.SetValue('lbot_positionadjustment', getSmoothRandom('lbot_backtrack_min', 'lbot_backtrack_max', 0.001))
        else
            caches['backtrack_ticks'] = backtrackTicks + 0.05;
        end
    end
end

local function handleVisuals()
    local lp = entities.GetLocalPlayer();
    if (lp == nil) then
        return
    end ;
    -- Kill Feed
    local kill_effect = getUIVar('kill_effect');
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
    client.SetConVar("mat_fullbright", getUIVar('full_bright') and 1 or 0, true);

    -- Watermark, Design by Rab
    if (getUIVar('watermark')) then
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
    local engine_radar = getUIVar('engine_radar');
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
    client.SetConVar("mat_postprocess_enable", getUIVar('disable_postprocess') and 0 or 1, true);

    -- Sniper crosshair
    if (getUIVar('sniper_crosshair')) then
        local shouldShowCrosshair = lp ~= nil and lp:IsAlive() and gui.GetValue("vis_thirdperson_dist") == 0 and lp:GetProp("m_bIsScoped") == 0;
        client.SetConVar("weapon_debug_spread_show", shouldShowCrosshair and 3 or 0, true);
    end

    -- Double scope
    if (getUIVar('double_scope')) then
        gui.SetValue("vis_view_fov", lp ~= nil and lp:GetProp("m_bIsScoped") ~= 0 and 0 or caches['vis_view_fov']);
    end

    -- Transparent On Scope
    if (getUIVar('transparent_on_scope')) then
        local sR, sG, sB, sA = unpack(caches['clr_chams_ghost_server']);
        local cR, cG, cB, cA = unpack(caches['clr_chams_ghost_client']);
        if (lp ~= nil and lp:GetProp("m_bIsScoped") == 1) then
            sA, cA = 10, 10;
        end
        gui.SetValue("clr_chams_ghost_client", sR, sG, sB, sA);
        gui.SetValue("clr_chams_ghost_server", cR, cG, cB, cA);
    end

    -- Spread Tracers
    if (getUIVar('spread_tracers')) then
        client.SetConVar("cl_weapon_debug_show_accuracy", 1, true);
        client.SetConVar("cl_weapon_debug_show_accuracy_duration", getUIVar('spread_tracers_duration'), true);
    else
        client.SetConVar("cl_weapon_debug_show_accuracy", 0, true);
    end

    -- RGB Chams
    for i = 1, #RGBVars do
        local RGBVar = RGBVars[i];
        if (getUIVar(luaKey .. RGBVar .. '_rgb')) then
            local r = math.floor(math.sin((globals.RealTime()) * 2) * 127 + 128)
            local g = math.floor(math.sin((globals.RealTime()) * 2 + 2) * 127 + 128)
            local b = math.floor(math.sin((globals.RealTime()) * 2 + 4) * 127 + 128)
            gui.SetValue(RGBVar, r, g, b);
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
        local hitsound = getUIVar('custom_hit_sound');
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
            if getUIVar('kill_effect') > 0 then
                caches['kill_effect'] = true
            end
        end
    end
end);

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

--[[local function update()
    if (windowInfo == nil) then
        windowInfo = {};
    end
    for i = 1, #ui do
        local v = ui[i];
        windowInfo[i] = gui.GetValue(v[1]);
    end
    local responseToSend = json.encode(windowInfo);
    -- print(#responseToSend);
    http.Get('https://forums.lynxmods.com/v1/editConfig?username=%username%&password=%password%&product=%product_id%&config=' .. urlEncode(responseToSend), function(_)
    end);
end
for i = 1, #subWindows do
    gui.Button(subWindows[i], "Update", function()
        print('Saving Config')
        update();
    end);
end]]

callbacks.Register("Draw", function()
    mainWindow:SetActive(showMenu:GetValue() and references.aimware:IsActive());

    -- Load Settings From Server
--[[    if (not settingsLoaded) then
        settingsLoaded = true;
        http.Get('https://forums.lynxmods.com/v1/getConfig?username=%username%&password=%password%&product=%product_id%', function(response)
            response = json.decode(response);
            windowInfo = response['content'];

            if (windowInfo == nil) then
                update();
            else
                for i = 1, #windowInfo do
                    local info = windowInfo[i];
                    gui.SetValue(ui[i][1], info)
                end
            end
        end);
    end]]

    -- Update mouse x, y;
    mx, my = input.GetMousePos();
    local mainx, mainy = mainWindow:GetValue();

    -- Manage Tabs
    local dpiscale = gui.GetValue("dpi_Scale");
    for i = 1, #subWindows do
        local subWindow = subWindows[i];
        subWindow:SetValue(mainx, mainy + math.floor(70 * dpiscale));
        subWindow:SetActive(mainWindow:IsActive() and i == curTab);
    end

    -- Anti Leak: Remove this line for debugging rage bot
    if (references.aimware:IsActive()) then
        return
    end ;
    -- P Clean Code
    handleAntiAim();
    handlePresets();
    handleResolver();
    handleSlowwalk();
    handleLegitbot();
    handleVisuals();
end);