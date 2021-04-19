local flickticks = 0;-- Dont change 
local breakticks = 0;-- Dont change 

local lastfake = 1;-- Dont change 
local lastreal = 1;-- Dont change 

local flickpertick = 60; -- If tick = then flick

local clearflicks = 90; -- Fake Desync time in ticks

local realontick = 1; -- Time to set real after reset either it will set fake

local desyncfake = 6; -- Set fake desync mode still/balance/stretch/jitter
local desyncreal = 1; -- Set real desync mode still/balance/stretch/jitter



desyncs = {
   "Jitter",
   "Zero"
}


function DesyncFlick2()
  
  if (flickticks > flickpertick) then
 
        gui.SetValue("rbot_antiaim_stand_pitch_real", desyncfake);
        lastfake = gui.GetValue("rbot_antiaim_stand_pitch_real");
		
		        gui.SetValue("rbot_antiaim_move_pitch_real", desyncfake);
        lastfake = gui.GetValue("rbot_antiaim_move_pitch_real");
		
        pitch = 2;
        if( flickticks == clearflicks) then
        
        flickticks = 0;
        end 
            else
        if (breakticks > realontick) then
        
       gui.SetValue("rbot_antiaim_stand_pitch_real", desyncreal);
        lastreal = gui.GetValue("rbot_antiaim_stand_pitch_real");
		
		gui.SetValue("rbot_antiaim_move_pitch_real", desyncreal);
        lastreal = gui.GetValue("rbot_antiaim_move_pitch_real");
        
        
        pitch = 3;
        breakticks = 0;
        end    
           
      
     
    end

    flickticks = flickticks + 1;
    breakticks = breakticks + 1;

end

function StringDraw()
    
    local x = draw.CreateFont("Verdana", 20, 700)


end

callbacks.Register( "Draw", "StringDraw", StringDraw );

callbacks.Register( "Draw", "DesyncFlick2", DesyncFlick2);