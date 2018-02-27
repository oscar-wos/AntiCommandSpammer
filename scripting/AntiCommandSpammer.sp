/* AntiCommandSpammer
*
* Copyright (C) 2017-2018 Oscar Wos // github.com/OSCAR-WOS | theoscar@protonmail.com
*
* This program is free software: you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the Free
* Software Foundation, either version 3 of the License, or (at your option)
* any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this program. If not, see http://www.gnu.org/licenses/.
*/

// Compiler Info: Pawn 1.8 - build 6041

#define PLUGIN_VERSION "1.00"

#include <sourcemod>

StringMap g_smPlayerCommands[MAXPLAYERS + 1];
StringMap g_smCommands;
bool g_bReady;

public Plugin myinfo = {
	name = "AntiCommandSpammer",
	author = "Oscar Wos (OSWO)",
	description = "Allows excessive configuration of what commands are able to be spammed / not spammed and at what interval.",
	version = PLUGIN_VERSION,
	url = "https://github.com/OSCAR-WOS / https://steamcommunity.com/id/OSWO",
}

public void OnPluginStart() {
	LoadTranslations("anticommandspammer.phrases");
	AddCommandListener(Listener_Global);

	BuildStringmaps();
	LoadCommands();
}

public void OnClientPostAdminCheck(int iClient) {
	delete g_smPlayerCommands[iClient];
	g_smPlayerCommands[iClient] = new StringMap();
}

void BuildStringmaps() {
	g_bReady = false;
	g_smCommands = new StringMap()

	for (int i = 0; i <= MaxClients; i++) {
		g_smPlayerCommands[i] = new StringMap()
	}

	g_bReady = true;
}

void LoadCommands() {
	g_bReady = false;

	char cPath[512];
	BuildPath(Path_SM, cPath, sizeof(cPath), "configs/acs.cfg");

	if (!FileExists(cPath)) SetFailState("[ACS] - Config File (%s) Not Found!", cPath);

	File fConfig = OpenFile(cPath, "r");

	while (fConfig.EndOfFile()) {
		char cLine[512];
		char cSplit[2][256];

		fConfig.ReadLine(cLine, sizeof(cLine));
		ExplodeString(cLine, " ", cSplit, 2, 256);

		g_smCommands.SetValue(cSplit[0], StringToInt(cSplit[1]));
	}

	delete fConfig;

	g_bReady = true;
}

public Action Listener_Global(int iClient, const char[] cCommand, int iArgc) {
	if (!g_bReady) return Plugin_Continue;
	int iCommandValue;

	if (g_smCommands.GetValue(cCommand, iCommandValue)) {
		float fGameTime = GetGameTime();
		float fPlayerCommandValue;

		if (!g_smPlayerCommands[iClient].GetValue(cCommand, fPlayerCommandValue)) {
			g_smPlayerCommands[iClient].SetValue(cCommand, fGameTime);
		} else {
			float fDiff = (fPlayerCommandValue + float(iCommandValue)) - fGameTime;
			g_smPlayerCommands[iClient].SetValue(cCommand, fGameTime);

			if (fDiff > 0.0) {
				char cFormattedDiff[512];
				FormatDiffTime(fDiff, cFormattedDiff, sizeof(cFormattedDiff));

				ReplyToCommand(iClient, "%t", "Blocked", cCommand, cFormattedDiff);
				return Plugin_Stop;
			}
		}
	}

	return Plugin_Continue;
}

void FormatDiffTime(float fTime, char[] cBuffer, int iMaxLength) {
	if (fTime >= 60.0) {
		Format(cBuffer, iMaxLength, "%im ", RoundToFloor(fTime / 60));
	}

	if (fTime >= 1.0) {
		Format(cBuffer, iMaxLength, "%s%is ", cBuffer, RoundToFloor(fTime / 1));
	}
}
