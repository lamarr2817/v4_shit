local gui_set = gui.SetValue
local gui_get = gui.GetValue
local b_toggle = input.IsButtonDown
local auto = gui_get("rbot_autosniper_autostop")
local awp = gui_get("rbot_sniper_autostop")
local ssg = gui_get("rbot_scout_autostop")
local rev = gui_get("rbot_revolver_autostop")
local pist = gui_get("rbot_pistol_autostop")
local smg = gui_get("rbot_smg_autostop")
local rifle = gui_get("rbot_rifle_autostop")
local shotg = gui_get("rbot_shotgun_autostop")
local lmg = gui_get("rbot_lmg_autostop")
local shared = gui_get("rbot_shared_autostop")
local slowwalk_key = gui_get("msc_slowwalk")
local disable_on_scope = 2; -- 0 for off, 1 for always, 2 for if lines are enabled

-- reference
local reference =  gui.Reference("SETTINGS", "Miscellaneous")
-- checkboxes
local indicator = gui.Checkbox(reference, "indicate_on", "Indicators", 0);
-- groupboxes
local switchparent = gui.Groupbox(reference, "Switch stand", 0, 390, 215, 175)
local switchmoveparent = gui.Groupbox(reference, "Switch move", 0, 575, 215, 125)
-- indicator things
local indiatorcolor = gui.ColorEntry("mazk_aa_lua_color", "Indicator colors", 151, 220, 54,200);
-- switch things
local switchspeed = gui.Slider(switchparent, "switch_speed", "Switch Speed", 32, 0, 120);
local switchrange1 = gui.Slider(switchparent, "switch_range", "Stand Switch range", 0, 0, 119);
local switchrange2 = gui.Slider(switchparent, "switch_range2", "Stand Switch range 2", 14, 0, 120);
local switchrangemove = gui.Slider(switchmoveparent, "switch_rangemove", "Move Switch range", 0, 0, 119);
local switchrangemove2 = gui.Slider(switchmoveparent, "switch_rangemove2", "Move Switch range 2", 14, 0, 120);

function rangeswitch()
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));
local switchvalue = switchspeed:GetValue()
local switchget = math.floor(switchrange1:GetValue())
local switchget2 = math.floor(switchrange2:GetValue())

   if globals.TickCount() % math.floor(switchvalue) == 0 and FinalVelocity < threshold then
if switchget < switchget2 then
local switchrange = math.random(switchget, switchget2)
gui_set("rbot_antiaim_stand_switch_range", switchrange)
else
switchmove()
end
end
end

function switchmove()
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));
local switchvalue = switchspeed:GetValue()
local switchgetmove = math.floor(switchrangemove:GetValue())
local switchgetmove2 = math.floor(switchrangemove2:GetValue())

   if globals.TickCount() % math.floor(switchvalue) == 0 and FinalVelocity > threshold then
if switchgetmove < switchgetmove2 then
local switchrangemoveget = math.random(switchgetmove, switchgetmove2)
gui_set("rbot_antiaim_move_switch_range", switchrangemoveget)
else
rangeswitch()
end
end
end

function drawrange()
if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then

local font = draw.CreateFont("Gobold", 30)
draw.SetFont(font);

local w, h = draw.GetScreenSize()
local w = w/2
local h = h/2
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));
local antiaimstand = gui.GetValue("rbot_antiaim_stand_switch_range");
local antiaimmove = gui.GetValue("rbot_antiaim_move_switch_range");

if FinalVelocity < threshold then
   draw.Color(gui.GetValue("mazk_aa_lua_color"));
   draw.Text(w-940.5,h+30, "S: " .. math.floor(antiaimstand))
draw.TextShadow(w-940.5,h+30, "S: " .. math.floor(antiaimstand))
elseif FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+30, "S: " .. math.floor(antiaimmove))
draw.TextShadow(w-940.5,h+30, "S: " .. math.floor(antiaimmove)) 
end
end
end


function desyncindicator()
if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then

local font = draw.CreateFont("Gobold", 30);

draw.SetFont(font);

local w, h = draw.GetScreenSize()
local w = w/2
local h = h/2

local antiaim2 = gui.GetValue("rbot_antiaim_stand_desync")
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));

if antiaim2 == 0 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+60, "D: Off")
draw.TextShadow(w-940.5,h+60, "D: Off")
   elseif antiaim2 == 1 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+60, "D: Still")
draw.TextShadow(w-940.5,h+60, "D: Still")
   elseif antiaim2 == 2 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+60, "D: Balance")
draw.TextShadow(w-940.5,h+60, "D: Balance")
elseif antiaim2 == 3 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+60, "D: Stretch")
draw.TextShadow(w-940.5,h+60, "D: Stretch")
elseif antiaim2 == 4 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+60, "D: Jitter")
draw.TextShadow(w-940.5,h+60, "D: Jitter")
elseif FinalVelocity > threshold then
desyncindicatormove()
end
end
end

function desyncindicatormove()
if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then

local font = draw.CreateFont("Gobold", 30);

draw.SetFont(font);

local w, h = draw.GetScreenSize()
local w = w/2
local h = h/2

local antiaim2 = gui.GetValue("rbot_antiaim_move_desync")
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));

if antiaim2 == 0 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+60, "D: Off")
draw.TextShadow(w-940.5,h+60, "D: Off")
   elseif antiaim2 == 1 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+60, "D: Still")
draw.TextShadow(w-940.5,h+60, "D: Still")
   elseif antiaim2 == 2 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+60, "D: Balance")
draw.TextShadow(w-940.5,h+60, "D: Balance")
elseif antiaim2 == 3 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+60, "D: Stretch")
draw.TextShadow(w-940.5,h+60, "D: Stretch")
elseif antiaim2 == 4 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+60, "D: Jitter")
draw.TextShadow(w-940.5,h+60, "D: Jitter")
elseif FinalVelocity < threshold then
realindicator()
end
end
end

function yawindicator()
if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then
local font = draw.CreateFont("Gobold", 30);
draw.SetFont(font);
local w, h = draw.GetScreenSize()
local w = w/2
local h = h/2
local autodir = gui.GetValue("rbot_antiaim_autodir")
local antiaimvalue = gui.GetValue("rbot_antiaim_stand_real_add")
local antiaimvalue2 = gui.GetValue("rbot_antiaim_move_real_add")
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));

if autodir ~= 0 then
draw.Color(gui.GetValue("mazk_aa_lua_color"));draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+90, "Y: Auto")
draw.TextShadow(w-940.5,h+90, "Y: Auto")
   elseif FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+90, "Y: " .. math.floor(antiaimvalue))
draw.TextShadow(w-940.5,h+90, "Y: " .. math.floor(antiaimvalue))
elseif FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+90, "Y: " .. math.floor(antiaimvalue2))
draw.TextShadow(w-940.5,h+90, "Y: " .. math.floor(antiaimvalue2))
end
end
end

function autostopoff()
   local player = entities.GetLocalPlayer()
   slowwalk_key = gui_get("msc_slowwalk")
   if b_toggle(slowwalk_key) and player:IsAlive() then
       local screen_x, screen_y = draw.GetScreenSize()
       gui_set("rbot_autosniper_autostop", 0)
       gui_set("rbot_lmg_autostop", 0)
       gui_set("rbot_pistol_autostop", 0)
       gui_set("rbot_revolver_autostop", 0)
       gui_set("rbot_rifle_autostop", 0)
       gui_set("rbot_scout_autostop", 0)
       gui_set("rbot_shared_autostop", 0)
       gui_set("rbot_shotgun_autostop", 0)
       gui_set("rbot_smg_autostop", 0)
       gui_set("rbot_sniper_autostop", 0)
   else
       gui_set("rbot_autosniper_autostop", auto)
       gui_set("rbot_lmg_autostop", lmg)
       gui_set("rbot_pistol_autostop", pist)
       gui_set("rbot_revolver_autostop", rev)
       gui_set("rbot_rifle_autostop", rifle)
       gui_set("rbot_scout_autostop", ssg)
       gui_set("rbot_shared_autostop", shared)
       gui_set("rbot_shotgun_autostop", shotg)
       gui_set("rbot_smg_autostop", smg)
       gui_set("rbot_sniper_autostop", awp)

   end
end

function realindicator()
if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then

local font = draw.CreateFont("Gobold", 30);
draw.SetFont(font);

local w, h = draw.GetScreenSize()
local w = w/2
local h = h/2

local getyaw = gui.GetValue("rbot_antiaim_stand_real")
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));

if getyaw == 0 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+120, "R: Off")
draw.TextShadow(w-940.5,h+120, "R: Off")
elseif getyaw == 1 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+120, "R: Static")
draw.TextShadow(w-940.5,h+120, "R: Static")
elseif getyaw == 2 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+120, "R: Spinbot")
draw.TextShadow(w-940.5,h+120, "R: Spinbot")
elseif getyaw == 3 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Jitter")
draw.TextShadow(w-940.5,h+120, "R: Jitter")
elseif getyaw == 4 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Zero")
draw.TextShadow(w-940.5,h+120, "R: Zero")
   elseif getyaw == 5 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Switch")
draw.TextShadow(w-940.5,h+120, "R: Switch")
elseif getyaw == 6 and FinalVelocity < threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Shift")
draw.TextShadow(w-940.5,h+120, "R: Shift")
elseif FinalVelocity > threshold then
realindicatormove()
end
end
end

function realindicatormove()
if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then

local font = draw.CreateFont("Gobold", 30);
draw.SetFont(font);

local w, h = draw.GetScreenSize()
local w = w/2
local h = h/2

local getyawmove = gui.GetValue("rbot_antiaim_move_real")
local threshold = gui.GetValue("rbot_antiaim_stand_velocity");
local LocalPlayer = entities.GetLocalPlayer();
local velocityX = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[0]");
local velocityY = LocalPlayer:GetPropFloat("localdata", "m_vecVelocity[1]");
local velocity = math.sqrt(velocityX^2 + velocityY^2);
local FinalVelocity = tonumber(math.floor(math.min(9999, velocity) + 0.2));

if getyawmove == 0 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+120, "R: Off")
draw.TextShadow(w-940.5,h+120, "R: Off")
elseif getyawmove == 1 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+120, "R: Static")
draw.TextShadow(w-940.5,h+120, "R: Static")
elseif getyawmove == 2 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.TextShadow(w-940.5,h+120, "R: Spinbot")
draw.TextShadow(w-940.5,h+120, "R: Spinbot")
elseif getyawmove == 3 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Jitter")
draw.TextShadow(w-940.5,h+120, "R: Jitter")
elseif getyawmove == 4 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Zero")
draw.TextShadow(w-940.5,h+120, "R: Zero")
   elseif getyawmove == 5 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Switch")
draw.TextShadow(w-940.5,h+120, "R: Switch")
elseif getyawmove == 6 and FinalVelocity > threshold then
draw.Color(gui.GetValue("mazk_aa_lua_color"));
draw.Text(w-940.5,h+120, "R: Shift")
draw.TextShadow(w-940.5,h+120, "R: Shift")
elseif FinalVelocity < threshold then
realindicator()
end
end
end


function fadingfake()
  local speed = 3
  local r = 0
  local g = 100
  local b = 255
  local a = math.floor(math.sin(globals.RealTime() * speed + 4) * 70 + 70)

  for k,v in pairs({  "clr_chams_ghost_client",
                      "clr_chams_ghost_client",
                      "clr_chams_ghost_client",
                      "clr_chams_ghost_client"}) do

      gui.SetValue(v, r,g,b,a)

  end
end

function fakelagindicator()
   if entities.GetLocalPlayer() ~= nil and indicator:GetValue() and entities.GetLocalPlayer():IsAlive() then

   local font = draw.CreateFont("Gobold", 30);
   draw.SetFont(font);

   local w, h = draw.GetScreenSize()
   local w = w/2
   local h = h/2

local fakelagon = gui.GetValue("msc_fakelag_enable")
   local fakelagmode = gui.GetValue("msc_fakelag_mode")
local fakelagvalue = gui.GetValue("msc_fakelag_value")

if fakelagmode == 0 and fakelagon then
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Factor " .. math.floor(fakelagvalue))
       draw.TextShadow(w-940.5,h+150, "F: Factor " .. math.floor(fakelagvalue))
   elseif fakelagmode == 1 and fakelagon then
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Switch " .. math.floor(fakelagvalue))
       draw.TextShadow(w-940.5,h+150, "F: Switch " .. math.floor(fakelagvalue))
   elseif fakelagmode == 2 and fakelagon then
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Adaptive " .. math.floor(fakelagvalue))
       draw.TextShadow(w-940.5,h+150, "F: Adaptive " .. math.floor(fakelagvalue))
   elseif fakelagmode == 3 and fakelagon then
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Random " .. math.floor(fakelagvalue))
       draw.TextShadow(w-940.5,h+150, "F: Random " .. math.floor(fakelagvalue))
   elseif fakelagmode == 4 and fakelagon then
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Peek " .. math.floor(fakelagvalue))
       draw.TextShadow(w-940.5,h+150, "F: Peek " .. math.floor(fakelagvalue))
   elseif fakelagmode == 5 and fakelagon then
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Rapid Peek " .. math.floor(fakelagvalue))
       draw.TextShadow(w-940.5,h+150, "F: Rapid Peek " .. math.floor(fakelagvalue))
else
       draw.Color(gui.GetValue("mazk_aa_lua_color"));
       draw.Text(w-940.5,h+150, "F: Off")
       draw.TextShadow(w-940.5,h+150, "F: Off")
      end
   end
end

callbacks.Register("CreateMove", "switchmove", switchmove)
callbacks.Register("CreateMove", "rangeswitch", rangeswitch)
callbacks.Register("Draw", "autostopoff", autostopoff)
callbacks.Register("Draw", "fadingfake", fadingfake)
callbacks.Register("Draw", "drawrange", drawrange)
callbacks.Register("Draw", "desyncindicator", desyncindicator)
callbacks.Register("Draw", "yawindicator", yawindicator)
callbacks.Register("Draw", "realindicator", realindicator)
callbacks.Register("Draw", "fakelagindicator", fakelagindicator)