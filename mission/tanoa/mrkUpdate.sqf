private ["_marcador","_mrkD"];

_marcador = _this select 0;

_mrkD = format ["Dum%1",_marcador];
if (_marcador in mrkSDK) then
	{
	_mrkD setMarkerColor "colorGUER";
	if (_marcador in aeropuertos) then {_mrkD setMarkerText "SDK Airbase";_mrkD setMarkerType "flag_Syndicat"} else {
	if (_marcador in puestos) then {_mrkD setMarkerText "SDK Outpost"}};
	}
else
	{
	if (_marcador in mrkNATO) then
		{
		_mrkD setMarkerColor "colorBLUFOR";
		if (_marcador in aeropuertos) then {_mrkD setMarkerText "NATO Airbase";_mrkD setMarkerType "flag_NATO"} else {
		if (_marcador in puestos) then {_mrkD setMarkerText "NATO Outpost"}};
		}
	else
		{
		_mrkD setMarkerColor "colorOPFOR";
		if (_marcador in aeropuertos) then {_mrkD setMarkerText "CSAT Airbase";_mrkD setMarkerType "flag_CSAT"} else {
		if (_marcador in puestos) then {_mrkD setMarkerText "CSAT Outpost"}};
		};
	};

