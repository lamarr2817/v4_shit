local settingsLoaded = false;
local ui = {};
local references = {
    aimware = gui.Reference("MENU"),
    miscGeneral = gui.Reference("SETTINGS", "Miscellaneous");
};
local windowW, windowH = 523, 400;
local luaName = "Godstep";
local luaKey = 'lynx_' .. luaName:lower():gsub(" ", "_") .. '_';

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

local function setUIVar(key, value)
    for i = 1, #ui do
        local v = ui[i];
        if (v[1] == luaKey .. key) then
            return v[2]:SetValue(value);
        end
    end
end

local showMenu = gui.Checkbox(references.miscGeneral, luaKey .. "showmenu", "[Lynx] " .. luaName, false);
local window = gui.Window(luaKey .. "tabs", "[Lynx Client] " .. luaName, 200, 200, windowW, windowH);

local gsgb = gui.Groupbox(window, "Godstep", 178, 5, 170, 307)
local abgb = gui.Groupbox(window, "Ragebot", 351, 5, 170, 148)
local aagb = gui.Groupbox(window, "Anti-Aim", 351, 158, 170, 154)
local ntgb = gui.Groupbox(window, "Nametags", 5, 5, 170, 148)
local visgb = gui.Groupbox(window, "Visuals", 5, 158, 170, 154)
local dtaps = gui.Multibox(abgb, "Double Tap Settings")

local tagbgc = gui.ColorEntry("tagbgc", "Nametag Background Color", 0, 0, 0, 100)
local tagolc = gui.ColorEntry("tagolc", "Nametag Outline Color", 0, 0, 0, 100)
local tagtc = gui.ColorEntry("tagtc", "Nametag Text Color", gui.GetValue("clr_esp_box_t_vis"))

local fonts = { "Verdana", "Tahoma", "Arial", "Bahnschrift", "Comic Sans MS", "Courier New" }

addGuiComp("stutterwalk", "Checkbox", abgb, "Randomize Slowwalk", false)
addGuiComp("stutterwalkbase", "Slider", abgb, "Slowwalk Randomizer Base", 25, 1, 100)
addGuiComp("stutterwalkfactor", "Slider", abgb, "Slowwalk Randomizer Factor", 15, 1, 100)

addGuiComp("yawjitter", "Checkbox", aagb, "Yaw Jitter", false)
addGuiComp("yawjitter_range", "Slider", aagb, "Yaw Jitter Range", 30, 0, 180)
addGuiComp("desync_slowwalk", "Checkbox", aagb, "Desync Slowwalk", false)
addGuiComp("gsps", "Combobox", gsgb, "Godstep", "Custom", "84° Solid", "96° Shift", "120° Shift", "Fake 167° Shift")

addGuiComp("tags", "Checkbox", ntgb, "Custom Nametags", false)
addGuiComp("tagsize", "Slider", ntgb, "Nametag Font Size", 13, 1, 36)
addGuiComp("tagfont", "Combobox", ntgb, "Nametag Font", "Verdana", "Tahoma", "Arial", "Bahnschrift", "Comic Sans MS", "Courier New")

addGuiComp("hitsound", "Checkbox", visgb, "Skeet Hitsound", false)
addGuiComp("killeffect", "Checkbox", visgb, "Kill Effect", false)
addGuiComp("postprocess", "Checkbox", visgb, "Disable Post-Processing", false)
addGuiComp("ghost_pulse", "Checkbox", visgb, "Pulsating Ghosts", false)
addGuiComp("indicators", "Checkbox", visgb, "Indicators", false)

addGuiComp("doubletap", "Checkbox", dtaps, "Disable Delay Shot", false)
addGuiComp("doubletap_autoscale", "Checkbox", dtaps, "Auto Scale", false)

addGuiComp("lby", "Checkbox", gsgb, "LBY Drift", false)
addGuiComp("lbyoffsethost", "Combobox", gsgb, "LBY Drift Host", "Desync", "Real", "Void", "Pitch")
addGuiComp("lbyoffset", "Slider", gsgb, "LBY Drift Factor", 0, -86, 86)
addGuiComp("ychoke", "Checkbox", gsgb, "Yaw Choke", false)
addGuiComp("ychokehost", "Combobox", gsgb, "Yaw Choke Host", "Desync", "Real", "Void", "Pitch")
addGuiComp("yoffset", "Slider", gsgb, "Yaw Choke Factor", 0, -86, 86)




--[[gui.Button(window, "Update", function()
    lynx.update("%product_id%", ui);
end);]]

callbacks.Register("CreateMove", function(UserCMD)
    if entities.GetLocalPlayer() then
        if UserCMD:GetSendPacket() then
            dx, dy = UserCMD:GetViewAngles()
        end
        rx, ry = entities.GetLocalPlayer():GetProp('m_angEyeAngles')
        local_lby = entities.GetLocalPlayer():GetProp("m_flLowerBodyYawTarget")
    end
end)

callbacks.Register("Draw", function()

    espfont = draw.CreateFont(fonts[getUIVar("tagfont") + 1], math.floor(getUIVar("tagsize")))

    window:SetActive(showMenu:GetValue() and references.aimware:IsActive());
    --[[    if (not settingsLoaded) then
            settingsLoaded = true;
            lynx.load("%product_id%", ui);
        end]]


    local r, g, b = gui.GetValue("clr_chams_ghost_client")
    local o = math.floor(math.sin((globals.RealTime()) * 10) * 88 + 144) - 55
    local font = draw.CreateFont("Verdana", 13, 12)

    if getUIVar("stutterwalk") then
        gui.SetValue("msc_slowwalkspeed", math.random(math.floor(getUIVar("stutterwalkbase")), math.floor(getUIVar("stutterwalkbase") + getUIVar("stutterwalkfactor"))) / 100)
    end

    if getUIVar("doubletap") then

        if gui.GetValue("rbot_doublefire") then
            gui.SetValue("rbot_delayshot", 0)
        else
            gui.SetValue("rbot_delayshot", 2)
        end
    end

    if getUIVar("doubletap_autoscale") then

        if gui.GetValue("rbot_doublefire") then
            gui.SetValue("rbot_autosniper_hitbox_auto_ps", 1)
        else
            gui.SetValue("rbot_autosniper_hitbox_auto_ps", 0)
        end
    end

    if getUIVar("indicators") and entities.GetLocalPlayer() ~= nil then
        draw.SetFont(font)
        draw.Color(math.abs(ry - local_lby), 255 - math.abs(ry - local_lby), 0)
        draw.OutlinedRect(218, 50, 272, 65)
        draw.TextShadow(220, 50, "LBYSync")

        draw.Color(math.abs(ry - dy), 255 - math.abs(ry - dy), 0)
        draw.OutlinedRect(218, 70, 265, 85)
        draw.TextShadow(220, 70, "Desync")
    end


    if getUIVar("desync_slowwalk") then

        if input.IsButtonDown(gui.GetValue("msc_slowwalk")) then

            if input.IsButtonDown(65) then
                gui.SetValue("rbot_antiaim_stand_desync", 3)
            end

            if input.IsButtonDown(68) then
                gui.SetValue("rbot_antiaim_stand_desync", 2)
            end
        end
    end

    if getUIVar("pitchjitter") then
        gui.SetValue("rbot_antiaim_stand_pitch_custom", math.random(66, 90))
    end

    if getUIVar("yawjitter") then
        gui.SetValue("rbot_antiaim_stand_real_add", math.random(math.floor(0 - getUIVar("yawjitter_range")), math.floor(getUIVar("yawjitter_range"))))
    end

    if getUIVar("postprocess") then
        client.SetConVar("mat_postprocess_enable", 0, true)
    else
        client.SetConVar("mat_postprocess_enable", 1, true)
    end

    if getUIVar("ghost_pulse") then
        gui.SetValue("clr_chams_ghost_client", r, g, b, o)
    end

    local lp = entities.GetLocalPlayer();

    if lp then

        local x2, y2 = lp:GetProp('m_angEyeAngles')

        if getUIVar("lby") then
            if getUIVar("lbyoffsethost") == 0 then
                lp:SetProp("m_flLowerBodyYawTarget", ry + getUIVar("lbyoffset"))
            elseif getUIVar("lbyoffsethost") == 1 then
                lp:SetProp("m_flLowerBodyYawTarget", y2 + getUIVar("lbyoffset"))
            elseif getUIVar("lbyoffsethost") == 2 then
                lp:SetProp("m_flLowerBodyYawTarget", math.huge)
            elseif getUIVar("lbyoffsethost") == 3 then
                lp:SetProp("m_flLowerBodyYawTarget", x2 + getUIVar("lbyoffset"))
            end
        end

        if getUIVar("ychoke") then
            if getUIVar("ychokehost") == 0 then
                lp:SetProp("m_angEyeAngles[1]", ry + getUIVar("yoffset"))
            elseif getUIVar("ychokehost") == 1 then
                lp:SetProp("m_angEyeAngles[1]", local_lby + getUIVar("yoffset"))
            elseif getUIVar("ychokehost") == 2 then
                lp:SetProp("m_angEyeAngles[1]", math.huge)
            elseif getUIVar("ychokehost") == 3 then
                lp:SetProp("m_angEyeAngles[1]", x2 + getUIVar("yoffset"))
            end
        end
    end


    if getUIVar("gsps") == 1 then
        setUIVar("lby", 1)
        setUIVar("lbyoffsethost", 1)
        setUIVar("lbyoffset", 0)
        setUIVar("ychoke", 1)
        setUIVar("ychokehost", 0)
        setUIVar("yoffset", 0)
    elseif getUIVar("gsps") == 2 then
        setUIVar("lby", 1)
        setUIVar("lbyoffsethost", 1)
        setUIVar("lbyoffset", 16)
        setUIVar("ychoke", 1)
        setUIVar("ychokehost", 0)
        setUIVar("yoffset", -36)
    elseif getUIVar("gsps") == 3 then
        setUIVar("lby", 1)
        setUIVar("lbyoffsethost", 0)
        setUIVar("lbyoffset", 86)
        setUIVar("ychoke", 1)
        setUIVar("ychokehost", 1)
        setUIVar("yoffset", 0)
    elseif getUIVar("gsps") == 4 then
        setUIVar("lby", 1)
        setUIVar("lbyoffsethost", 1)
        setUIVar("lbyoffset", -36)
        setUIVar("ychoke", 1)
        setUIVar("ychokehost", 0)
        setUIVar("yoffset", 46)
    end
end);


callbacks.Register("FireGameEvent", function(Event)

    if entities.GetLocalPlayer() ~= nil then

        if (Event:GetName() == 'player_death') then
            local ME = client.GetLocalPlayerIndex()

            local INT_UID = Event:GetInt('userid')
            local INT_ATTACKER = Event:GetInt('attacker')

            local INDEX_Victim = client.GetPlayerIndexByUserID(INT_UID)

            local INDEX_Attacker = client.GetPlayerIndexByUserID(INT_ATTACKER)

            if (INDEX_Attacker == ME and INDEX_Victim ~= ME) then
                if getUIVar("killeffect") then
                    entities.GetLocalPlayer():SetProp("m_flHealthShotBoostExpirationTime", globals.CurTime() + 1)
                    client.Command("playvol physics\\glass\\glass_pottery_break2 .5", true);
                end
            end
        end


        if getUIVar("hitsound") then

            if (Event:GetName() == 'player_hurt') then
                local ME = client.GetLocalPlayerIndex()

                local INT_UID = Event:GetInt('userid')
                local INT_ATTACKER = Event:GetInt('attacker')

                local INDEX_Victim = client.GetPlayerIndexByUserID(INT_UID)

                local INDEX_Attacker = client.GetPlayerIndexByUserID(INT_ATTACKER)

                if (INDEX_Attacker == ME and INDEX_Victim ~= ME) then
                    client.Command("play buttons\\arena_switch_press_02.wav", true)
                end
            end
        end
    end
end)

local function getESPCenter(ex1, ex2, width)
    return ex1 + ((ex2 - ex1) / 2) - (width / 2);
end

callbacks.Register("DrawESP", function(esp)



    draw.SetFont(espfont);
    local e = esp:GetEntity()
    if (e:IsPlayer() ~= true or entities.GetLocalPlayer() == nil) then return end
    local ex1, ey1, ex2, ey2 = esp:GetRect()
    local eName = client.GetPlayerNameByIndex(e:GetIndex())
    local eHealth = e:GetHealth()
    local nameWidth, nameHeight = draw.GetTextSize(eName .. " | hp " .. eHealth)

    if getUIVar("tags") then

        if (e:IsPlayer() ~= true or entities.GetLocalPlayer() == nil or eName == client.GetPlayerNameByIndex(client.GetLocalPlayerIndex())) then return end

        draw.Color(tagbgc:GetValue())
        draw.RoundedRectFill(getESPCenter(ex1, ex2, nameWidth) - 2, ey1 - nameHeight, getESPCenter(ex1, ex2, nameWidth) + nameWidth + 2, ey1 - nameHeight + nameHeight + 1)
        draw.Color(tagolc:GetValue())
        draw.RoundedRect(getESPCenter(ex1, ex2, nameWidth) - 2, ey1 - nameHeight, getESPCenter(ex1, ex2, nameWidth) + nameWidth + 2, ey1 - nameHeight + nameHeight + 1)
        draw.Color(tagtc:GetValue())
        draw.TextShadow(getESPCenter(ex1, ex2, nameWidth), ey1 - nameHeight, eName .. " | hp " .. eHealth)
    end
end);

client.AllowListener('player_hurt')
client.AllowListener('player_death')