client.AllowListener( 'player_death' );
callbacks.Register( 'FireGameEvent', function( Event )

    if ( Event:GetName() == 'player_death' ) then

        local ME = client.GetLocalPlayerIndex();

        local INT_UID = Event:GetInt( 'userid' );
        local INT_ATTACKER = Event:GetInt( 'attacker' );

        local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

        local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );

        if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then

            client.ChatSay("that's a neck")

        end

    end

end);