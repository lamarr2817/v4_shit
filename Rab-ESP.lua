local espfont = draw.CreateFont("Verdana", 12, 16);

local function getESPCenter(ex1, ex2, width)
    return ex1 + ((ex2 - ex1) / 2) - (width / 2);
end

callbacks.Register("DrawESP", function(esp)

    draw.SetFont(espfont);
    local e = esp:GetEntity();
    if (e:IsPlayer() ~= true or entities.GetLocalPlayer() == nil) then return end;
    local ex1, ey1, ex2, ey2 = esp:GetRect();
    local eName = client.GetPlayerNameByIndex(e:GetIndex());
    local eHealth = e:GetHealth()
    local nameWidth, nameHeight = draw.GetTextSize(eName .. " | [hp " .. eHealth .. "]");

    draw.Color(0, 0, 0, 100)
    draw.FilledRect(getESPCenter(ex1, ex2, nameWidth) - 5, ey1 - nameHeight, getESPCenter(ex1, ex2, nameWidth) + nameWidth + 5, ey1 - nameHeight + nameHeight + 1)
    draw.OutlinedRect(getESPCenter(ex1, ex2, nameWidth) - 5, ey1 - nameHeight, getESPCenter(ex1, ex2, nameWidth) + nameWidth + 5, ey1 - nameHeight + nameHeight + 1)

    draw.Color(255, 255, 255)
    draw.TextShadow(getESPCenter(ex1, ex2, nameWidth), ey1 - nameHeight, eName .. " | [hp " .. eHealth .. "]");


end);