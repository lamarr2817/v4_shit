local wnd_eMain = gui.Window("wnd_eMain", "Project Entropy Configuration", 50, 50, 925, 600)
local eGBAA = gui.Groupbox(wnd_eMain, "Anti-Aim", 5, 5, 225, 274 )
local eGBAAM = gui.Groupbox(wnd_eMain, "Anti-Aim Moving", 5, 289, 225, 274 )
local eGBV = gui.Groupbox(wnd_eMain, "Visuals", 235, 5, 225, 274 )

local eGBL = gui.Groupbox(wnd_eMain, "Curve", 235, 289, 225, 274 )
local eGBL2 = gui.Groupbox(wnd_eMain, "Smoothing", 465, 289, 225, 274 )
local eGBLM = gui.Groupbox(wnd_eMain, "Legit Miscellaneous", 695, 289, 225, 274 )

local eGBM = gui.Groupbox(wnd_eMain, "Miscellaneous", 695, 5, 225, 274 )
local eGBR = gui.Groupbox(wnd_eMain, "Ragebot", 465, 5, 225, 274 )

local wnd_ShowMain = gui.Checkbox(gui.Reference("SETTINGS", "Miscellaneous"), "wnd_ShowMain", "Project Entropy Menu", false )
local entropy_customhitsound = gui.Combobox(eGBV, "entropy_customhitsound", "Hitsound", "Off", "Entropy", "Skeet", "Chicken", "Casino" )
local entropy_killeffect = gui.Combobox(eGBV, "entropy_killeffect", "Kill Effect", "Off", "Red", "Green", "Blue" )
local entropy_fullbright = gui.Checkbox( eGBV, "entropy_fullbright", "Fullbright", false )
local entropy_watermark = gui.Checkbox(eGBV, "entropy_watermark", "Watermark", false )
local entropy_engineradar = gui.Checkbox( eGBV, "entropy_engineradar", "Engine Radar", false )
local entropy_disablepostprocess = gui.Checkbox(eGBV, "entropy_disablepostprocess", "Disable Post-Processing", false )
local entropy_snipercrosshair = gui.Checkbox( eGBV, "entropy_snipercrosshair", "Force Crosshair on Sniper", false )
local entropy_doublescope = gui.Checkbox( eGBV, "entropy_doublescope", "Zoom on Double Scope", false )
local entropy_transparentonscope = gui.Checkbox( eGBV, "entropy_transparentonscope", "Transparent on Scope", false )
local entropy_spreadtracers = gui.Checkbox(eGBV, "entropy_spreadtracers", "Spread Tracers", false)
local entropy_spreadtracers_duration = gui.Slider(eGBV, "entropy_spreadtracers_duration", "Spread Tracer Duration", 2, 1, 10 )

local fSpeed = gui.Slider(eGBM, "fSpeed", "RGB Speed (High = Slow)", 5, 1, 10 )

local entropy_watermark_color = gui.ColorEntry( "entropy_watermark_color", "Entropy Watermark", 0, 126, 167, 255 )
local entropy_watermark_color_2 = gui.ColorEntry( "entropy_watermark_color_2", "Entropy Watermark Background", 240, 255, 255, 255 )

local oR, oG, oB, oO = gui.GetValue("clr_chams_ghost_client" )
local oR2, oG2, oB2, oO2 = gui.GetValue("clr_chams_ghost_server" )
local oFOV = gui.GetValue("vis_view_fov" )

local doKillEffectTimer = 0
local doKillEffect = false

local version = "II"
local font = draw.CreateFont("Courier New", 18, 12 )
local font2 = draw.CreateFont("Calibri", 12, 10 )
local font3 = draw.CreateFont("Courier New", 10, 10 )

local dTicks = 0;
local dSwap = false;
local lTicks = 0;
local lmTicks = 0;

local menuPressed = 1;

local dTicks2 = 0;
local dSwap2 = false;
local lTicks2 = 0;
local lmTicks2 = 0;

local pFPS = 0
local aFPS = 0

local rTicks = 0
local rTicks = 0
local yTicks = 0
local btTicks = 0
local rflTicks = 0

local rTicks2 = 0;
local rTicks2 = 0;
local yTicks2 = 0;
local btTicks2 = 0;
local rflTicks2 = 0;
local rChange = false;
local rSwap = false;
local rChange2 = false;
local rSwap2 = false;

local entropy_esp_rgb_multibox = gui.Multibox(eGBV, "RGB Chams")

local entropy_aa_desync_cycle_speed = gui.Combobox(eGBAA, "entropy_aa_desync_cycle_speed", "Desync Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme") -- Desync Cycle Speed
local entropy_aa_real_cycle_speed = gui.Combobox(eGBAA, "entropy_aa_real_cycle_speed", "Yaw Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme") -- Yaw Cycle Speed
local entropy_aa_real_swap_speed = gui.Combobox(eGBAA, "entropy_aa_real_swap_speed", "Angle Swap Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme") -- Custom Angle Swap Speed
local entropy_aa_desync_inverse = gui.Combobox(eGBAA, "entropy_aa_desync_inverse", "Inverse on Desync", "Off", "Match", "Reverse", "Wide Match", "Wide Reverse", "Half Match", "Half Reverse"); -- Desync Inverse

local entropy_aa_desync_1 = gui.Combobox(eGBAA, "entropy_aa_desync_1", "Desync 1", "Off", "Still", "Balance", "Stretch", "Jitter") -- Custom Desync 1
local entropy_aa_desync_2 = gui.Combobox(eGBAA, "entropy_aa_desync_2", "Desync 2", "Off", "Still", "Balance", "Stretch", "Jitter") -- Custom Desync 2
local entropy_aa_desync_3 = gui.Combobox(eGBAA, "entropy_aa_desync_3", "Desync 3", "Off", "Still", "Balance", "Stretch", "Jitter") -- Custom Desync 3

local entropy_aa_real_1 = gui.Combobox(eGBAA, "entropy_aa_real_1", "Real 1", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift") -- Custom Real 1
local entropy_aa_real_2 = gui.Combobox(eGBAA, "entropy_aa_real_2", "Real 2", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift") -- Custom Real 2
local entropy_aa_real_3 = gui.Combobox(eGBAA, "entropy_aa_real_3", "Real 3", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift") -- Custom Real 3
local entropy_aa_angle_1 = gui.Slider(eGBAA, "entropy_aa_angle_1", "Custom Angle (Default: -90)", -90, -180, 180 ) -- Custom Angle 1
local entropy_aa_angle_2 = gui.Slider(eGBAA, "entropy_aa_angle_2", "Custom Angle (Default: 90)", 90, -180, 180 ) -- Custom Angle 2

local entropy_aa_desync_cycle_speed_moving = gui.Combobox(eGBAAM, "entropy_aa_desync_cycle_speed_moving", "Desync Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme") -- Desync Cycle Speed
local entropy_aa_real_cycle_speed_moving = gui.Combobox(eGBAAM, "entropy_aa_real_cycle_speed_moving", "Yaw Cycle Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme") -- Yaw Cycle Speed
local entropy_aa_real_swap_speed_moving = gui.Combobox(eGBAAM, "entropy_aa_real_swap_speed_moving", "Angle Swap Speed", "Off", "Low", "Medium", "High", "Very High", "Extreme") -- Custom Angle Swap Speed
local entropy_aa_desync_inverse_moving = gui.Combobox(eGBAAM, "entropy_aa_desync_inverse_moving", "Inverse on Desync", "Off", "Match", "Reverse", "Wide Match", "Wide Reverse", "Half Match", "Half Reverse"); -- Desync Inverse

local entropy_aa_desync_moving_1 = gui.Combobox(eGBAAM, "entropy_aa_desync_moving_1", "Desync 1", "Off", "Still", "Balance", "Stretch", "Jitter") -- Custom Desync 1
local entropy_aa_desync_moving_2 = gui.Combobox(eGBAAM, "entropy_aa_desync_moving_2", "Desync 2", "Off", "Still", "Balance", "Stretch", "Jitter") -- Custom Desync 2
local entropy_aa_desync_moving_3 = gui.Combobox(eGBAAM, "entropy_aa_desync_moving_3", "Desync 3", "Off", "Still", "Balance", "Stretch", "Jitter") -- Custom Desync 3

local entropy_aa_real_moving_1 = gui.Combobox(eGBAAM, "entropy_aa_real_moving_1", "Real 1", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift") -- Custom Real 1
local entropy_aa_real_moving_2 = gui.Combobox(eGBAAM, "entropy_aa_real_moving_2", "Real 2", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift") -- Custom Real 2
local entropy_aa_real_moving_3 = gui.Combobox(eGBAAM, "entropy_aa_real_moving_3", "Real 3", "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch", "Shift") -- Custom Real 3
local entropy_aa_angle_moving_1 = gui.Slider(eGBAAM, "entropy_aa_angle_moving_1", "Custom Angle (Default: -90)", -90, -180, 180 ) -- Custom Angle 1
local entropy_aa_angle_moving_2 = gui.Slider(eGBAAM, "entropy_aa_angle_moving_2", "Custom Angle (Default: 90)", 90, -180, 180 ) -- Custom Angle 2

local entropy_lbot_pistol_curve = gui.Checkbox(eGBL, "entropy_lbot_pistol_curve", "Randomize Curve (Pistols)", false)
local entropy_lbot_pistol_curve_min = gui.Slider(eGBL, "entropy_lbot_pistol_curve_min", "Minimum Curve Value (Pistols)", 0.2, 0, 2)
local entropy_lbot_pistol_curve_max = gui.Slider(eGBL, "entropy_lbot_pistol_curve_max", "Maximum Curve Value (Pistols)", 0.4, 0, 2)
local entropy_lbot_smg_curve = gui.Checkbox(eGBL, "entropy_lbot_smg_curve", "Randomize Curve (SMGs)", false)
local entropy_lbot_smg_curve_min = gui.Slider(eGBL, "entropy_lbot_smg_curve_min", "Minimum Curve Value (SMGs)", 0.2, 0, 2)
local entropy_lbot_smg_curve_max = gui.Slider(eGBL, "entropy_lbot_smg_curve_max", "Maximum Curve Value (SMGs)", 0.4, 0, 2)
local entropy_lbot_rifle_curve = gui.Checkbox(eGBL, "entropy_lbot_rifle_curve", "Randomize Curve (Rifles)", false)
local entropy_lbot_rifle_curve_min = gui.Slider(eGBL, "entropy_lbot_rifle_curve_min", "Minimum Curve Value (Rifles)", 0.2, 0, 2)
local entropy_lbot_rifle_curve_max = gui.Slider(eGBL, "entropy_lbot_rifle_curve_max", "Maximum Curve Value (Rifles)", 0.4, 0, 2)
local entropy_lbot_sniper_curve = gui.Checkbox(eGBL, "entropy_lbot_sniper_curve", "Randomize Curve (Snipers)", false)
local entropy_lbot_sniper_curve_min = gui.Slider(eGBL, "entropy_lbot_sniper_curve_min", "Minimum Curve Value (Snipers)", 0.2, 0, 2)
local entropy_lbot_sniper_curve_max = gui.Slider(eGBL, "entropy_lbot_sniper_curve_max", "Maximum Curve Value (Snipers)", 0.4, 0, 2)

local entropy_lbot_triggerbot = gui.Checkbox(eGBLM, "entropy_lbot_triggerbot", "Randomize Triggerbot", false) -- Advanced Triggerbot
local entropy_lbot_triggerbot_min = gui.Slider(eGBLM, "entropy_lbot_triggerbot_min", "Minimum Triggerbot Delay", 0.03, 0.00, 1.00)
local entropy_lbot_triggerbot_max = gui.Slider(eGBLM, "entropy_lbot_triggerbot_max", "Maximum Triggerbot Delay", 0.03, 0.00, 1.00)

local entropy_lbot_backtrack = gui.Checkbox(eGBLM, "entropy_lbot_backtrack", "Randomize Backtrack", false) -- Advanced Backtrack
local entropy_lbot_backtrack_min = gui.Slider(eGBLM, "entropy_lbot_backtrack_min", "Minimum Backtrack Ticks", 0.001, 0, 0.2)
local entropy_lbot_backtrack_max = gui.Slider(eGBLM, "entropy_lbot_backtrack_max", "Maximum Backtrack Ticks", 0.001, 0, 0.2)

local entropy_fakelatency = gui.Checkbox(eGBLM, "entropy_fakelatency", "Randomize Fake Latency", false) -- Advanced Fake Latency
local entropy_fakelatency_min = gui.Slider(eGBLM, "entropy_fakelatency_min", "Minimum Latency", 0.001, 0.001, 1)
local entropy_fakelatency_max = gui.Slider(eGBLM, "entropy_fakelatency_max", "Maximum Latency", 0.5, 0.001, 1)
local entropy_fakelatency_swap_speed = gui.Slider(eGBLM, "entropy_fakelatency_swap_speed", "Latency Change Speed", 5, 0.01, 60)

local entropy_lbot_pistol_smooth = gui.Checkbox(eGBL2, "entropy_lbot_pistol_smooth", "Randomize Smoothing (Pistols)", false)
local entropy_lbot_pistol_smooth_min = gui.Slider(eGBL2, "entropy_lbot_pistol_smooth_min", "Minimum Smoothing Value (Pistols)", 5, 1, 30)
local entropy_lbot_pistol_smooth_max = gui.Slider(eGBL2, "entropy_lbot_pistol_smooth_max", "Maximum Smoothing Value (Pistols)", 6, 1, 30)
local entropy_lbot_smg_smooth = gui.Checkbox(eGBL2, "entropy_lbot_smg_smooth", "Randomize Smoothing (SMGs)", false)
local entropy_lbot_smg_smooth_min = gui.Slider(eGBL2, "entropy_lbot_smg_smooth_min", "Minimum Smoothing Value (SMGs)", 5, 1, 30)
local entropy_lbot_smg_smooth_max = gui.Slider(eGBL2, "entropy_lbot_smg_smooth_max", "Maximum Smoothing Value (SMGs)", 6, 1, 30)
local entropy_lbot_rifle_smooth = gui.Checkbox(eGBL2, "entropy_lbot_rifle_smooth", "Randomize Smoothing (Rifles)", false)
local entropy_lbot_rifle_smooth_min = gui.Slider(eGBL2, "entropy_lbot_rifle_smooth_min", "Minimum Smoothing Value (Rifles)", 5, 1, 30)
local entropy_lbot_rifle_smooth_max = gui.Slider(eGBL2, "entropy_lbot_rifle_smooth_max", "Maximum Smoothing Value (Rifles)", 6, 1, 30)
local entropy_lbot_sniper_smooth = gui.Checkbox(eGBL2, "entropy_lbot_rifle_sniper", "Randomize Smoothing (Snipers)", false)
local entropy_lbot_sniper_smooth_min = gui.Slider(eGBL2, "entropy_lbot_rifle_sniper_min", "Minimum Smoothing Value (Snipers)", 5, 1, 30)
local entropy_lbot_sniper_smooth_max = gui.Slider(eGBL2, "entropy_lbot_rifle_sniper_max", "Maximum Smoothing Value (Snipers)", 6, 1, 30)

local entropy_esp_rgb_CTV = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_CTV", "CT Visible Chams", false)
local entropy_esp_rgb_CTI = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_CTI", "CT Invisible Chams", false)
local entropy_esp_rgb_TV = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_TV", "T Visible Chams", false)
local entropy_esp_rgb_TI = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_TI", "T Invisible Chams", false)
local entropy_esp_rgb_CTVB = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_CTVB", "CT Visible Box", false)
local entropy_esp_rgb_CTIB = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_CTIB", "CT Invisible Box", false)
local entropy_esp_rgb_CTG = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_CTG", "CT Glow", false)
local entropy_esp_rgb_TVB = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_TVB", "T Visible Box", false)
local entropy_esp_rgb_TIB = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_TIB", "T Invisible Box", false)
local entropy_esp_rgb_TG = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_TG", "T Glow", false)
local entropy_esp_rgb_OV = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_OV", "Other Visible Chams", false)
local entropy_esp_rgb_OI = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_OI", "Other Invisible Chams", false)
local entropy_esp_rgb_OVB = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_OVB", "Other Visible Box", false)
local entropy_esp_rgb_OIB = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_OIB", "Other Invisible Box", false)
local entropy_esp_rgb_OG = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_OG", "Other Glow", false)
local entropy_esp_rgb_WP = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_WP", "Weapon Primary", false)
local entropy_esp_rgb_WS = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_WS", "Weapon Secondary", false)
local entropy_esp_rgb_GC = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_GC", "Ghost Clientside", false)
local entropy_esp_rgb_GS = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_GS", "Ghost Serverside", false)
local entropy_esp_rgb_LG = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_LG", "Local Glow", false)
local entropy_esp_rgb_HT = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_HT", "History Ticks", false)
local entropy_esp_rgb_SC = gui.Checkbox(entropy_esp_rgb_multibox, "entropy_esp_rgb_SC", "Spread Crosshair", false)

local entropy_rbot_scoutresolver_key = gui.Keybox(eGBR, "entropy_rbot_scoutresolver_key", "Scout Resolver", 4 )
local entropy_rbot_scoutresolver_multibox = gui.Multibox(eGBR, "Scout Resolver Customization" )
local entropy_rbot_scoutresolver_fakelatency = gui.Checkbox(entropy_rbot_scoutresolver_multibox, "entropy_rbot_scoutresolver_fakelatency", "Disable Fakelatency", true )
local entropy_rbot_scoutresolver_delayshot = gui.Checkbox(entropy_rbot_scoutresolver_multibox, "entropy_rbot_scoutresolver_delayshot", "Accurate Unlag", true )

local entropy_slowwalk_shuffle = gui.Checkbox(eGBM, "entropy_slowwalk_shuffle", "Slow Walk Fakelag", false )
local entropy_slowwalk_shuffle = gui.Combobox(eGBM, "entropy_slowwalk_shuffle_mode", "Slow Walk Fakelag Mode", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" )
local entropy_slowwalk_shuffle = gui.Checkbox(eGBM, "entropy_slowwalk_shuffle_ws", "While Shooting", false )

local oFakelag = gui.GetValue("msc_fakelag_enable")
local oFakelagMode = gui.GetValue("msc_fakelag_mode")
local oFakelagValue = gui.GetValue("msc_fakelag_value")
local oFakelatency = gui.GetValue("msc_fakelatency_enable")
local oFakelagKey = gui.GetValue("msc_fakelag_key")
local oFakelagWhileShooting = gui.GetValue("msc_fakelag_attack")
local oDelayShot = gui.GetValue("rbot_delayshot")

local entropy_legitaa = gui.Checkbox(eGBLM, "entropy_legitaa", "Legit Desync", false);
local entropy_legitaa_left = gui.Keybox(eGBLM, "entropy_legitaa_left", "Left", 0);
local entropy_legitaa_right = gui.Keybox(eGBLM, "entropy_legitaa_right", "Right", 0);

function legitAA()

  gui.SetValue("rbot_enable", 0);
  gui.SetValue("rbot_antiaim_stand_pitch_real",0);
  gui.SetValue("rbot_antiaim_move_pitch_real",0);
  gui.SetValue("rbot_antiaim_edge_pitch_real",0);
  gui.SetValue("rbot_antiaim_edge_real",0);
  gui.SetValue("rbot_antiaim_edge_desync",0);
  gui.SetValue("rbot_antiaim_enable",1);
  gui.SetValue("rbot_speedlimit",0);

if gui.GetValue("entropy_legitaa") == true then

    gui.SetValue("rbot_antiaim_autodir",0);
	gui.SetValue("rbot_antiaim_at_targets",0);

		if gui.GetValue("entropy_legitaa_left") ~= 0 then
			if input.IsButtonPressed(gui.GetValue("entropy_legitaa_left")) then
				gui.SetValue("rbot_antiaim_stand_real",1);
				gui.SetValue("rbot_antiaim_stand_real_add",180)
				gui.SetValue("rbot_antiaim_stand_desync",3);
				gui.SetValue("rbot_antiaim_move_real", 1);
				gui.SetValue("rbot_antiaim_move_real_add",180);
				gui.SetValue("rbot_antiaim_move_desync", 3);
			end
		end

		if gui.GetValue("entropy_legitaa_right") ~= 0 then
			if input.IsButtonPressed(gui.GetValue("entropy_legitaa_right")) then
				gui.SetValue("rbot_antiaim_stand_real",1);
				gui.SetValue("rbot_antiaim_stand_real_add",180)
				gui.SetValue("rbot_antiaim_stand_desync",2);
				gui.SetValue("rbot_antiaim_move_real", 1);
				gui.SetValue("rbot_antiaim_move_real_add", 180);
				gui.SetValue("rbot_antiaim_move_desync", 2);
			end
		end

		if input.IsButtonDown(gui.GetValue("lbot_key")) then
		  gui.SetValue("rbot_active",0);
		else
		  gui.SetValue("rbot_active",1);
		end

	else

    gui.SetValue("rbot_antiaim_stand_real",0);
    gui.SetValue("rbot_antiaim_stand_desync",0);
    gui.SetValue("rbot_antiaim_move_real",0);
    gui.SetValue("rbot_antiaim_move_desync",0);

end
end

function slowwalkShuffle()

	if gui.GetValue("entropy_slowwalk_shuffle") == true then

		if input.IsButtonDown(gui.GetValue("msc_slowwalk")) then
			
			gui.SetValue("msc_fakelag_attack", gui.GetValue("entropy_slowwalk_shuffle_ws"))
			gui.SetValue("msc_fakelag_mode", gui.GetValue("entropy_slowwalk_shuffle_mode"))
			gui.SetValue("msc_fakelag_enable", true)
			gui.SetValue("msc_fakelag_key", gui.GetValue("msc_slowwalk"))
			
			else
			
			gui.SetValue("msc_fakelag_attack", oFakelagWhileShooting)
			gui.SetValue("msc_fakelag_mode", oFakelagMode)
			gui.SetValue("msc_fakelag_enable", oFakelag)
			gui.SetValue("msc_fakelag_key", oFakelagKey)
			
		end
	
	else
	end
end

function scoutResolver()

	if gui.GetValue("entropy_rbot_scoutresolver_key") > 0 then

		if input.IsButtonDown(gui.GetValue("entropy_rbot_scoutresolver_key")) == true then

			if gui.GetValue("entropy_rbot_scoutresolver_fakelatency") == true then

			gui.SetValue("msc_fakelatency_enable", false)

			end

			if gui.GetValue("entropy_rbot_scoutresolver_delayshot") == true then

			gui.SetValue("rbot_delayshot", 1)

			end
			
		else
		
		gui.SetValue("rbot_delayshot", oDelayShot)
		gui.SetValue("msc_fakelatency_enable", oFakelatency)
		
		end
	end
end

function InverseDesync()

  if gui.GetValue("entropy_aa_desync_inverse") > 0 then

    gui.SetValue("entropy_aa_real_swap_speed", 0);

    if gui.GetValue("entropy_aa_desync_inverse") == 1 then

      if gui.GetValue("rbot_antiaim_stand_desync") == 2 then

        gui.SetValue("rbot_antiaim_stand_real_add", 58);

      end

      if gui.GetValue("rbot_antiaim_stand_desync") == 3 then

        gui.SetValue("rbot_antiaim_stand_real_add", -58);


      end
    end

    if gui.GetValue("entropy_aa_desync_inverse") == 2 then



      if gui.GetValue("rbot_antiaim_stand_desync") == 2 then

        gui.SetValue("rbot_antiaim_stand_real_add", -58);

      end

      if gui.GetValue("rbot_antiaim_stand_desync") == 3 then

        gui.SetValue("rbot_antiaim_stand_real_add", 58);

      end
    end

    if gui.GetValue("entropy_aa_desync_inverse") == 3 then


      if gui.GetValue("rbot_antiaim_stand_desync") == 2 then

        gui.SetValue("rbot_antiaim_stand_real_add", 116);

      end

      if gui.GetValue("rbot_antiaim_stand_desync") == 3 then

        gui.SetValue("rbot_antiaim_stand_real_add", -116);

      end
    end

    if gui.GetValue("entropy_aa_desync_inverse") == 4 then


      if gui.GetValue("rbot_antiaim_stand_desync") == 2 then

        gui.SetValue("rbot_antiaim_stand_real_add", -116);

      end

      if gui.GetValue("rbot_antiaim_stand_desync") == 3 then

        gui.SetValue("rbot_antiaim_stand_real_add", 116);

      end
    end

    if gui.GetValue("entropy_aa_desync_inverse") == 5 then


      if gui.GetValue("rbot_antiaim_stand_desync") == 2 then

        gui.SetValue("rbot_antiaim_stand_real_add", 29);

      end

      if gui.GetValue("rbot_antiaim_stand_desync") == 3 then

        gui.SetValue("rbot_antiaim_stand_real_add", -29);

      end
    end

    if gui.GetValue("entropy_aa_desync_inverse") == 6 then

      gui.SetValue("entropy_aa_real_swap_speed", 0);


      if gui.GetValue("rbot_antiaim_stand_desync") == 2 then

        gui.SetValue("rbot_antiaim_stand_real_add", -29);

      end

      if gui.GetValue("rbot_antiaim_stand_desync") == 3 then

        gui.SetValue("rbot_antiaim_stand_real_add", 29);

      end
    end
  end

  if gui.GetValue("entropy_aa_desync_inverse_moving") > 0 then

    gui.SetValue("entropy_aa_real_swap_speed_moving", 0);

    if gui.GetValue("entropy_aa_desync_inverse_moving") == 1 then

      if gui.GetValue("rbot_antiaim_move_desync") == 2 then

        gui.SetValue("rbot_antiaim_move_real_add", 58);

      end

      if gui.GetValue("rbot_antiaim_move_desync") == 3 then

        gui.SetValue("rbot_antiaim_move_real_add", -58);


      end
    end

    if gui.GetValue("entropy_aa_desync_inverse_moving") == 2 then


      if gui.GetValue("rbot_antiaim_move_desync") == 2 then

        gui.SetValue("rbot_antiaim_move_real_add", -58);

      end

      if gui.GetValue("rbot_antiaim_move_desync") == 3 then

        gui.SetValue("rbot_antiaim_move_real_add", 58);


      end
    end

    if gui.GetValue("entropy_aa_desync_inverse_moving") == 3 then

      if gui.GetValue("rbot_antiaim_move_desync") == 2 then

        gui.SetValue("rbot_antiaim_move_real_add", 116);

      end

      if gui.GetValue("rbot_antiaim_move_desync") == 3 then

        gui.SetValue("rbot_antiaim_move_real_add", -116);


      end
    end

    if gui.GetValue("entropy_aa_desync_inverse_moving") == 4 then


      if gui.GetValue("rbot_antiaim_move_desync") == 2 then

        gui.SetValue("rbot_antiaim_move_real_add", -116);

      end

      if gui.GetValue("rbot_antiaim_move_desync") == 3 then

        gui.SetValue("rbot_antiaim_move_real_add", 116);


      end
    end
    if gui.GetValue("entropy_aa_desync_inverse_moving") == 5 then


      if gui.GetValue("rbot_antiaim_move_desync") == 2 then

        gui.SetValue("rbot_antiaim_move_real_add", 29);

      end

      if gui.GetValue("rbot_antiaim_move_desync") == 3 then

        gui.SetValue("rbot_antiaim_move_real_add", -29);


      end
    end

    if gui.GetValue("entropy_aa_desync_inverse_moving") == 6 then


      if gui.GetValue("rbot_antiaim_move_desync") == 2 then

        gui.SetValue("rbot_antiaim_move_real_add", -29);

      end

      if gui.GetValue("rbot_antiaim_move_desync") == 3 then

        gui.SetValue("rbot_antiaim_move_real_add", 29);


      end
    end

  end
end

function legitATrigger()

  if entropy_lbot_triggerbot:GetValue() == true then

    gui.SetValue("lbot_trg_delay",(entropy_lbot_triggerbot_min:GetValue() + 0.01 + math.random() * ( entropy_lbot_triggerbot_max:GetValue() - entropy_lbot_triggerbot_min:GetValue() )) );

  end

end

function legitABT()

  if entropy_lbot_backtrack:GetValue() == true then

    if btTicks > 20 then

      gui.SetValue("lbot_positionadjustment",(entropy_lbot_backtrack_min:GetValue() + 0.001 + math.random() * ( entropy_lbot_backtrack_max:GetValue() - entropy_lbot_backtrack_min:GetValue() )) );

      btTicks = 0;

    else

      btTicks = btTicks + 0.05;
    end
  end
end

function legitASmooth()

  if entropy_lbot_pistol_smooth:GetValue() == true then


    gui.SetValue("lbot_pistol_smooth",(entropy_lbot_pistol_smooth_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_pistol_smooth_max:GetValue() - entropy_lbot_pistol_smooth_min:GetValue() )) );

  end

  if entropy_lbot_smg_smooth:GetValue() == true then


    gui.SetValue("lbot_smg_smooth",(entropy_lbot_smg_smooth_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_smg_smooth_max:GetValue() - entropy_lbot_smg_smooth_min:GetValue() )) );

  end

  if entropy_lbot_rifle_smooth:GetValue() == true then


    gui.SetValue("lbot_rifle_smooth",(entropy_lbot_rifle_smooth_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_rifle_smooth_max:GetValue() - entropy_lbot_rifle_smooth_min:GetValue() )) );

  end


  if entropy_lbot_sniper_smooth:GetValue() == true then


    gui.SetValue("lbot_sniper_smooth",(entropy_lbot_sniper_smooth_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_sniper_smooth_max:GetValue() - entropy_lbot_sniper_smooth_min:GetValue() )) );

  end

end

function legitACurve()

  if entropy_lbot_pistol_curve:GetValue() == true then


    gui.SetValue("lbot_pistol_curve",(entropy_lbot_pistol_curve_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_pistol_curve_max:GetValue() - entropy_lbot_pistol_curve_min:GetValue() )) );

  end

  if entropy_lbot_smg_curve:GetValue() == true then


    gui.SetValue("lbot_smg_curve",(entropy_lbot_smg_curve_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_smg_curve_max:GetValue() - entropy_lbot_smg_curve_min:GetValue() )) );

  end

  if entropy_lbot_rifle_curve:GetValue() == true then


    gui.SetValue("lbot_rifle_curve",(entropy_lbot_rifle_curve_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_rifle_curve_max:GetValue() - entropy_lbot_rifle_curve_min:GetValue() )) );

  end


  if entropy_lbot_sniper_curve:GetValue() == true then


    gui.SetValue("lbot_sniper_curve",(entropy_lbot_sniper_curve_min:GetValue() + 0.1 + math.random() * ( entropy_lbot_sniper_curve_max:GetValue() - entropy_lbot_sniper_curve_min:GetValue() )) );

  end

end

function formulaUtils()

 rRed = math.sin((globals.RealTime() / fSpeed:GetValue()) * 4) * 127 + 128;
 rGreen = math.sin((globals.RealTime() / fSpeed:GetValue()) * 4 + 2) * 127 + 128;
 rBlue = math.sin((globals.RealTime() / fSpeed:GetValue()) * 4 + 4) * 127 + 128;
 oFade = math.sin((globals.RealTime() / fSpeed:GetValue()) * 4 + 4) * 127 + 128;
	
local w, h = draw.GetScreenSize()
local centerW, centerH = draw.GetScreenSize()


pFPS = 0.9 * pFPS + (1.0 - 0.9) * globals.AbsoluteFrameTime();
aFPS = math.floor((1.0 / pFPS) + 0.5);

end

function watermark()

local w, h = draw.GetScreenSize()
local centerW = w / 2 * .83
local centerH = h / 2 * .83

local date = os.date("*t")

	if gui.GetValue("entropy_watermark") == true then

      draw.SetFont(font)
	  draw.Color(gui.GetValue("entropy_watermark_color_2"))
	  draw.FilledRect(centerW, 2, centerW + 255, 18)
	  draw.Color(0, 0, 0, 255)
	  draw.OutlinedRect(centerW, 2, centerW + 255, 18)
      draw.Color(gui.GetValue("entropy_watermark_color"))
	  draw.Text(centerW + 140, 0, "" .. aFPS .. "")
      draw.Text(centerW + 10,0, "Entropy ".. version .. " |    | " .. string.format("%02d:%02d", date.hour, date.min))

	end
end

function sniperCrosshair()

	if gui.GetValue("entropy_snipercrosshair") == true then 

		if entities.GetLocalPlayer() ~= nil then

			if entities.GetLocalPlayer():IsAlive() then
			
				if gui.GetValue( "vis_thirdperson_dist" ) == 0 then
				
					if entities.GetLocalPlayer():GetPropInt( "m_bIsScoped" ) == 0 then
					
						client.SetConVar( "weapon_debug_spread_show", 3, true );
						
						else
						
						client.SetConVar( "weapon_debug_spread_show", 0, true );

						end
					
					
				else
				
				client.SetConVar( "weapon_debug_spread_show", 0, true );
				
				end
				
			else
			
			client.SetConVar( "weapon_debug_spread_show", 0, true );
			
			end
		end
	end
end

function doubleScope()

if gui.GetValue("entropy_doublescope") == true then 

		if entities.GetLocalPlayer() ~= nil then
		
			if entities.GetLocalPlayer():GetProp( "m_bIsScoped" ) > 0 then
			
				gui.SetValue( "vis_view_fov", 0 );
				
			else
			
				gui.SetValue( "vis_view_fov", oFOV );
				
			end
		end
	end
end

function TransOnScope()

	if gui.GetValue("entropy_transparentonscope") == true then
	
		if entities.GetLocalPlayer() ~= nil then
		
			if entities.GetLocalPlayer():GetProp( "m_bIsScoped" ) > 0 then
			
				gui.SetValue( "clr_chams_ghost_client", oR, oG, oB, 10 );
				gui.SetValue( "clr_chams_ghost_server", oR2, oG2, oB2, 10 );
				
			else
			
				gui.SetValue( "clr_chams_ghost_client", oR, oG, oB, oO );
				gui.SetValue( "clr_chams_ghost_server", oR2, oG2, oB2, oO2 );
				
			end
		end
	end
end

function disablePostProcessing()

	if gui.GetValue("entropy_disablepostprocess") == true then

		client.SetConVar("mat_postprocess_enable", 0, true );

	else

		client.SetConVar("mat_postprocess_enable", 1, true );

	end
	
end

function engineRadar()

	for index, Player in pairs( entities.FindByClass( "CCSPlayer" ) ) do
        Player:SetProp( "m_bSpotted", engineRadar );
    end
	
	if entropy_engineradar:GetValue() then
		engineRadar = 1
	else
		engineRadar = 0
	end
	
end

function hitSound(Event)

  if gui.GetValue("entropy_customhitsound") > 0 then
      gui.SetValue( "msc_hitmarker_volume", 0);

      if ( Event:GetName() == "player_hurt" ) then

        local ME = client.GetLocalPlayerIndex();

        local INT_UID = Event:GetInt( "userid" );
        local INT_ATTACKER = Event:GetInt( "attacker" );

        local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
        local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

        local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
        local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );

        if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then

          if gui.GetValue("entropy_customhitsound") == 1 then

            client.Command( "play weapons\\scar20\\scar20_boltback", true );

          end

          if gui.GetValue("entropy_customhitsound") == 2 then

            client.Command( "play buttons\\arena_switch_press_02.wav", true );

          end

          if gui.GetValue("entropy_customhitsound") == 3 then

            client.Command( "play ambient\\creatures\\chicken_death_01", true );

          end

          if gui.GetValue("entropy_customhitsound") == 4 then

            client.Command( "play training\\pointscored", true );

          end
		  
		  
        end

      end

    end

end

function playerKilled(Event)

		  if ( Event:GetName() == "player_death" ) then

			local ME = client.GetLocalPlayerIndex();

			local INT_UID = Event:GetInt( "userid" );
			local INT_ATTACKER = Event:GetInt( "attacker" );

			local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
			local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

			local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
			local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );

			if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then

			if gui.GetValue("entropy_killeffect") > 0 then 
			
			doKillEffect = true 
		
		
			end
		end
	end
end

function worldFade()

	if doKillEffect == true then 
	
		if doKillEffectTimer < 2 then
		
		doKillEffect = false
		
		doKillEffectTimer = 20
		
		client.SetConVar("mat_ambient_light_r", 0, true);
		client.SetConVar("mat_ambient_light_g", 0, true);
		client.SetConVar("mat_ambient_light_b", 0, true);
		
		else
		
		if gui.GetValue("entropy_killeffect") == 1 then
		
		client.SetConVar("mat_ambient_light_r", doKillEffectTimer / 100, true);
		end
		
		if gui.GetValue("entropy_killeffect") == 2 then
		
		client.SetConVar("mat_ambient_light_g", doKillEffectTimer / 100, true);
		end
		
		if gui.GetValue("entropy_killeffect") == 3 then
		
		client.SetConVar("mat_ambient_light_b", doKillEffectTimer / 100, true);
		end
		
		doKillEffectTimer = doKillEffectTimer - 1

		end
	end
end

function yawSwap()

if gui.GetValue("entropy_aa_real_swap_speed") > 0 then

		if yTicks > 10 then
	  
			if yTicks > 20 then

			gui.SetValue("rbot_antiaim_stand_real_add", oAngle + gui.GetValue("entropy_aa_angle_1"));

			yTicks = 0;
			
			end

		else
		
		gui.SetValue("rbot_antiaim_stand_real_add", oAngle + gui.GetValue("entropy_aa_angle_2"));

		yTicks = yTicks + gui.GetValue("entropy_aa_real_swap_speed");

		end
	end
end

function antiaim()

  if rTicks > 10 then

    if rTicks > 20 then

      if rChange == true then

        if rSwap == true then

          gui.SetValue("rbot_antiaim_stand_real", entropy_aa_real_1:GetValue());
          rSwap = false;

        else

          gui.SetValue("rbot_antiaim_stand_real", entropy_aa_real_2:GetValue());
          rSwap = true;

        end

        rChange = false;

      else

        gui.SetValue("rbot_antiaim_stand_real", entropy_aa_real_3:GetValue());
        rChange = true;

      end

      rTicks = 0;

    end


  end


  if entropy_aa_real_cycle_speed:GetValue() > 0

  then

    rTicks = rTicks + entropy_aa_real_cycle_speed:GetValue();


  else

    rTicks = 0;

  end

end

function desync()


  if dTicks > 10 then

    if dTicks > 20 then

      if dChange == true then

        if dSwap == true then

          gui.SetValue("rbot_antiaim_stand_desync", entropy_aa_desync_1:GetValue());
          dSwap = false;

        else

          gui.SetValue("rbot_antiaim_stand_desync", entropy_aa_desync_2:GetValue());
          dSwap = true;

        end

        dChange = false;

      else

        gui.SetValue("rbot_antiaim_stand_desync", entropy_aa_desync_3:GetValue());
        dChange = true;

      end

      dTicks = 0;

    else
    end

  end


  if entropy_aa_desync_cycle_speed:GetValue() > 0

  then

    dTicks = dTicks + entropy_aa_desync_cycle_speed:GetValue();

  else

    dTicks = 0;

  end


end

function antiaimMoving()

  if rTicks2 > 10 then

    if rTicks2 > 20 then

      if rChange2 == true then

        if rSwap2 == true then

          gui.SetValue("rbot_antiaim_move_real", entropy_aa_real_moving_1:GetValue());
          rSwap2 = false;

        else

          gui.SetValue("rbot_antiaim_move_real", entropy_aa_real_moving_2:GetValue());
          rSwap2 = true;

        end

        rChange2 = false;

      else

        gui.SetValue("rbot_antiaim_move_real", entropy_aa_real_moving_3:GetValue());
        rChange2 = true;

      end

      rTicks2 = 0;

    end


  end


  if entropy_aa_real_cycle_speed_moving:GetValue() > 0

  then

    rTicks2 = rTicks2 + entropy_aa_real_cycle_speed_moving:GetValue();


  else

    rTicks2 = 0;

  end

end

function yawSwapMoving()

  if entropy_aa_real_swap_speed:GetValue() > 0 then

  if yTicks2 > 10 then

    if yTicks2 < 20 then

        gui.SetValue("rbot_antiaim_move_real_add", entropy_aa_angle_moving_1:GetValue());

      end

    else

        gui.SetValue("rbot_antiaim_move_real_add", entropy_aa_angle_moving_2:GetValue());

      end

      yTicks2 = 0;
	  
	  end

    yTicks2 = yTicks2 + entropy_aa_real_swap_speed:GetValue();

  end
  
function desyncMoving()


  if dTicks2 > 10 then

    if dTicks2 > 20 then

      if dChange2 == true then

        if dSwap2 == true then

          gui.SetValue("rbot_antiaim_move_desync", entropy_aa_desync_moving_1:GetValue());
          dSwap2 = false;

        else

          gui.SetValue("rbot_antiaim_move_desync", entropy_aa_desync_moving_2:GetValue());
          dSwap2 = true;

        end

        dChange2 = false;

      else

        gui.SetValue("rbot_antiaim_move_desync", entropy_aa_desync_moving_3:GetValue());
        dChange2 = true;

      end

      dTicks2 = 0;



    else
    end

  end


  if entropy_aa_desync_cycle_speed_moving:GetValue() > 0

  then

    dTicks2 = dTicks2 + entropy_aa_desync_cycle_speed_moving:GetValue();

  else

    dTicks2 = 0;

  end


end

function bulletFX()

  if gui.GetValue("entropy_spreadtracers") == true then

    client.SetConVar( "cl_weapon_debug_show_accuracy", 1, true );
    client.SetConVar( "cl_weapon_debug_show_accuracy_duration", gui.GetValue("entropy_spreadtracers_duration"), true );

  else

    client.SetConVar( "cl_weapon_debug_show_accuracy", 0, true );

  end
end

function windowManager()

  if wnd_ShowMain:GetValue() == true

  then

    wnd_eMain:SetActive(1)

  else

    wnd_eMain:SetActive(0)

	end
	
	
    if input.IsButtonPressed(gui.GetValue("msc_menutoggle")) then
        menuPressed = menuPressed == 0 and 1 or 0;
    end
    if (wnd_ShowMain:GetValue()) then
        wnd_eMain:SetActive(menuPressed);
    else
        wnd_eMain:SetActive(0);
    end

end

function peVisuals()

    if gui.GetValue("entropy_esp_rgb_CTG") == true then

      gui.SetValue("clr_vis_glow_ct", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_TG") == true then

      gui.SetValue("clr_vis_glow_t", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_OG") == true then

      gui.SetValue("clr_vis_glow_other", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_LG") == true then

      gui.SetValue("clr_vis_glow_local", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_CTV") == true then

      gui.SetValue("clr_chams_ct_vis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_CTI") == true then

      gui.SetValue("clr_chams_ct_invis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_TV") == true then

      gui.SetValue("clr_chams_t_vis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_TI") == true then

      gui.SetValue("clr_chams_t_invis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_OV") == true then

      gui.SetValue("clr_chams_other_vis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_OI") == true then

      gui.SetValue("clr_chams_other_invis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_WP") == true then

      gui.SetValue("clr_chams_weapon_primary", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_WS") == true then

      gui.SetValue("clr_chams_weapon_secondary", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_GC") == true then

      gui.SetValue("clr_chams_ghost_client", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_GS") == true then

      gui.SetValue("clr_chams_ghost_server", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_HT") == true then

      gui.SetValue("clr_chams_historyticks", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_CTVB") == true then

      gui.SetValue("clr_esp_box_ct_vis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_CTIB") == true then

      gui.SetValue("clr_esp_box_ct_invis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_TVB") == true then

      gui.SetValue("clr_esp_box_t_vis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_TIB") == true then

      gui.SetValue("clr_esp_box_t_invis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_OVB") == true then

      gui.SetValue("clr_esp_box_other_vis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_OIB") == true then

      gui.SetValue("clr_esp_box_other_invis", math.floor(rRed), math.floor(rBlue), math.floor(rGreen))
    end

    if gui.GetValue("entropy_esp_rgb_SC") == true then

      gui.SetValue("clr_esp_crosshair_recoil", math.floor(rRed), math.floor(rBlue), math.floor(rGreen), 80)
    end

end

function fullbright()
	
	if gui.GetValue("entropy_fullbright") == true then
		client.SetConVar( "mat_fullbright", 1, true )
	else
		client.SetConVar( "mat_fullbright", 0, true )
	end
	
end

client.AllowListener( "player_hurt" )
client.AllowListener( "player_death" )
client.AllowListener( "weapon_fire" )

callbacks.Register("Draw", legitAA);
callbacks.Register( "Draw", antiaim )
callbacks.Register( "Draw", antiaimMoving )
callbacks.Register( "Draw", bulletFX )
callbacks.Register( "Draw", desync )
callbacks.Register( "Draw", desyncMoving )
callbacks.Register( "Draw", disablePostProcessing )
callbacks.Register( "Draw", doubleScope )
callbacks.Register( "Draw", engineRadar )
callbacks.Register( "Draw", formulaUtils )
callbacks.Register( "Draw", fullbright )
callbacks.Register( "Draw", InverseDesync )
callbacks.Register( "Draw", legitABT )
callbacks.Register( "Draw", legitACurve )
callbacks.Register( "Draw", legitASmooth )
callbacks.Register( "Draw", legitATrigger )
callbacks.Register( "Draw", peVisuals )
callbacks.Register( "Draw", scoutResolver )
callbacks.Register( "Draw", slowwalkShuffle )
callbacks.Register( "Draw", sniperCrosshair )
callbacks.Register( "Draw", TransOnScope )
callbacks.Register( "Draw", watermark )
callbacks.Register( "Draw", windowManager )
callbacks.Register( "Draw", worldFade )
callbacks.Register( "Draw", yawSwap )
callbacks.Register( "Draw", yawSwapMoving )

callbacks.Register( "FireGameEvent", hitSound )
callbacks.Register( "FireGameEvent", playerKilled )