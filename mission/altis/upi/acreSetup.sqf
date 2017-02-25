//Sets up acre - Called by init.sqf

//Allows the ai to hear players speaking
[true] call acre_api_fnc_setRevealToAI;

//Turns off the terrain signal loss model
[0] call acre_api_fnc_setLossModelScale;

//Turns on full-duplex transmission (two-way)
[true] call acre_api_fnc_setFullDuplex;


//Sets up default radio channels - these are based on the UPI Task Force Horizon ORBAT
["ACRE_PRC148", "default", 1, "label", "TIGER PLTNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 2, "label", "ARCHER SQNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 3, "label", "LANCER SQNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 4, "label", "SABER SQNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 5, "label", "EXILE SUPNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 6, "label", "PHANTOM AIRNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 7, "label", "DRAGON ARINET"] call acre_api_fnc_setPresetChannelField;

["ACRE_PRC117F", "default", 1, "label", "TIGER PLTNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 2, "label", "ARCHER SQNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 3, "label", "LANCER SQNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 4, "label", "SABER SQNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 5, "label", "EXILE SUPNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 6, "label", "PHANTOM AIRNET"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 7, "label", "DRAGON ARINET"] call acre_api_fnc_setPresetChannelField;