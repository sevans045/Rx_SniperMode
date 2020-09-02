class Rx_HUD_Sniper extends Rx_HUD;

function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime = 60)
{
	local string cName, fMsg, rMsg;
	local int MessageType; // 0 = global, 1 = team, 2 = EVA, 3 = Radio

	if (Len(Msg) == 0)
		return;
	
	if ( bMessageBeep )
		PlayerOwner.PlayBeepSound();
 
	// Create Raw and Formatted Chat Messages

	if (PRI != None)
		cName = CleanHTMLMessage(PRI.PlayerName);
	else
		cName = "Host";


	if (MsgType == 'Special') 
	{
		if (MsgType == 'Special')
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$Msg$"</font>";
		PublicChatMessageLog $= fMsg $ "\n";
		rMsg = cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'Say') 
	{
		if (PRI == None)
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: " $ CleanHTMLMessage(Msg);
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: " $ CleanHTMLMessage(Msg);
		PublicChatMessageLog $= fMsg $ "\n";
		rMsg = cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'TeamSay') {
		if (PRI.GetTeamNum() == TEAM_GDI)
		{
			fMsg = "<font color='" $GDIColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= fMsg $ "\n";
			rMsg = cName $": "$ Msg;
			MessageType = 1;
		}
		else if (PRI.GetTeamNum() == TEAM_NOD)
		{
			fMsg = "<font color='" $NodColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= fMsg $ "\n";
			rMsg = cName $": "$ Msg;
			MessageType = 1;
		}
	}
	else if (MsgType == 'Radio') {
		Msg = ParseRadioMessage(Msg);

		if (Rx_PRI(PRI).bGetIsCommander()) {
			fMsg = "<font color='" $CommandTextColor $"'>" $ "[Commander]" $ cName $": "$ Msg $"</font>"; 
		}
		else {
			fMsg = "<font color='" $RadioColor $"'>" $ cName $": "$ Msg $"</font>"; 
		}

		fMsg = HighlightStructureNames(fMsg); 
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $ ": "$ Msg;
		MessageType = 3;
	}
	else if (MsgType == 'Commander') 
		{
			if (Left(Caps(msg), 2) == "/C") 
			{
				msg = Right(msg, Len(msg)-2);
				Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 120.0,,true);
			}
			else if (Left(Caps(msg), 2) == "/R") 
			{
				msg = Right(msg, Len(msg)-2);
				Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 360.0,,true);
			}
			fMsg = "<b><font color='" $CommandTextColor $"'>" $ "[Commander]"$ cName $": "$ CleanHTMLMessage(Msg) $"</font></b>";
			//PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
			MessageType = 1;
		}
	else if (MsgType == 'System') {
		if(InStr(Msg, "entered the game") >= 0)
			return;
		fMsg = CleanHTMLMessage(Msg);
		PublicChatMessageLog $= fMsg $ "\n";
		rMsg = Msg;
		MessageType = 0;
	}
	else if (MsgType == 'PM') {
		if (PRI != None)
			fMsg = "<font color='"$PrivateFromColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		else
			fMsg = "<font color='"$HostColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= fMsg $ "\n";
		rMsg = "Private from "$ cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'PM_Loopback') {
		fMsg = "<font color='"$PrivateToColor$"'>Private to "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= fMsg $ "\n";
		rMsg = "Private to "$ cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'CTEXT')
	{
		fMsg = Msg;
		MessageType = 4;
	}
	else if (MsgType == 'AdminMsg' || MsgType == 'PM_AdminMsg') {
		MessageType = 5;
		// TODO: This should go through to the HUD somewhere
		fMsg = "<font color='#FFFFFF' size='20'>" $ CleanHTMLMessage(Msg) $ "</font>";
	}
	else if (MsgType == 'AdminWarn' || MsgType == 'PM_AdminWarn') {
		MessageType = 5;
		fMsg = "<font color='#E67451' size='25'>You received a Warning from an Admin</font><br><br><font color='#E67451' size='20'>" $ CleanHTMLMessage(Msg) $ "</font>";
	}
	else
		MessageType = 2;

	// Add to currently active GUI | Edit by Yosh : Don't bother spamming the non-HUD chat logs with radio messages... it's pretty pointless for them to be there. 

	if(HudMovie != none && HudMovie.bMovieIsOpen)
	{
		if (MessageType == 0) {
			HudMovie.AddChatMessage(fMsg, rMsg);
		}
		else if (MessageType == 1) {
			HudMovie.AddChatMessage(fMsg, rMsg);
		}
		else if (MessageType == 2) {
			HudMovie.AddEVAMessage(CleanHTMLMessage(Msg));
		}
		else if (MessageType == 3) {
			HudMovie.AddRadioMessage(fMsg, rMsg);
		}
		else if (MessageType == 4) {
			HudMovie.AddCTextMessage(fMsg,LifeTime);	
		}
		else if (MessageType == 5) {
			HudMovie.PushAdminMessage(fMsg);
		}
	}	
	else
	{
		if(MsgType == 'System' 
			|| MsgType == 'CTEXT' 
			|| MsgType == 'AdminWarn' 
			|| MsgType == 'Radio'
			|| MessageType == 2) // these types are invalid and should not be registered in scoreboard/pause menu
			return;

		if (Scoreboard != none && Scoreboard.bMovieIsOpen) 
		{
			if (PlayerOwner.WorldInfo.GRI.bMatchIsOver) 
			{
				Scoreboard.AddChatMessage(fMsg, rMsg);
			}
		}		
		if (RxPauseMenuMovie != none && RxPauseMenuMovie.bMovieIsOpen) {
			if (RxPauseMenuMovie.ChatView != none) 
			{
				RxPauseMenuMovie.ChatView.AddChatMessage(fMsg, rMsg, MsgType=='PM' || MsgType=='PM_Loopback');
			}
			if(Rx_GRI(PlayerOwner.WorldInfo.GRI).bMatchIsOver)
			{
				LastEndScoreboardChats $= fMsg $ "\n";
			}
		}

	}
}