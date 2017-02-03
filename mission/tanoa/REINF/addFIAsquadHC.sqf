
if (player != Stavros) exitWith {hint "Only Commander Stavros has access to this function"};
if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};
if (markerAlpha "respawn_guerrila" == 0) exitWith {hint "You cant recruit a new squad while you are moving your HQ"};
if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};
_chequeo = false;
{
	if (((side _x == muyMalos) or (side _x == malos)) and (_x distance petros < 500) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot Recruit Squads with enemies near your HQ"};

private ["_tipogrupo","_esinf","_tipoVeh","_coste","_costeHR","_exit","_formato","_pos","_hr","_resourcesFIA","_grupo","_roads","_road","_grupo","_camion","_vehicle","_mortero","_morty"];


_tipogrupo = _this select 0;
_esinf = false;
_tipoVeh = "";
_coste = 0;
_costeHR = 0;
_exit = false;
_formato = [];
_format = "";

_hr = server getVariable "hr";
_resourcesFIA = server getVariable "resourcesFIA";

private ["_grupo","_roads","_camion"];

if (_tipoGrupo isEqualType []) then
	{
	//_tipoGrupo = if (random 20 <= skillFIA) then {_tipoGrupo select 1} else {_tipoGrupo select 0};
	//_formato = (cfgSDKInf >> _tipogrupo);
	//_unidades = [_formato] call groupComposition;
	{
	_tipoUnidad = if (random 20 <= skillFIA) then {_x select 1} else {_x select 0};
	_formato pushBack _tipoUnidad;
	_coste = _coste + (server getVariable _tipoUnidad); _costeHR = _costeHR +1
	} forEach _tipoGrupo;

	//if (_costeHR > 4) then {_tipoVeh = "B_G_Van_01_transport_F"} else {_tipoVeh = "B_G_Offroad_01_F"};
	//_coste = _coste + ([_tipoVeh] call vehiclePrice);
	_esinf = true;
	}
else
	{
	_coste = _coste + (2*(server getVariable (SDKMil select 0)));
	_costeHR = 2;
	_coste = _coste + ([_tipogrupo] call vehiclePrice) + ([vehSDKTruck] call vehiclePrice);
	};

if (_hr < _costeHR) then {_exit = true;hint format ["You do not have enough HR for this request (%1 required)",_costeHR]};

if (_resourcesFIA < _coste) then {_exit = true;hint format ["You do not have enough money for this request (%1 € required)",_coste]};

if (_exit) exitWith {};

_nul = [- _costeHR, - _coste] remoteExec ["resourcesFIA",2];

_pos = getMarkerPos "respawn_guerrila";
_tam = 10;
while {true} do
	{
	_roads = _pos nearRoads _tam;
	if (count _roads > 0) exitWith {};
	_tam = _tam + 10;
	};
_road = _roads select 0;

if (_esinf) then
	{
	//_camion = _tipoveh createVehicle _pos;
	_pos = [(getMarkerPos "respawn_guerrila"), 30, random 360] call BIS_Fnc_relPos;
	_grupo = [_pos, buenos, _formato] call BIS_Fnc_spawnGroup;
	if (_tipogrupo isEqualTo gruposSDKSquad) then {_format = "Squd-"};
	if (_tipogrupo isEqualTo gruposSDKmid) then {_format = "Tm-"};
	if (_tipogrupo isEqualTo gruposSDKAT) then {_format = "AT-"};
	if (_tipogrupo isEqualTo gruposSDKSniper) then {_format = "Snpr-"};
	if (_tipogrupo isEqualTo gruposSDKSentry) then {_format = "Stry-"};
	_format = format ["%1%2",_format,{side (leader _x) == buenos} count allGroups];
	_grupo setGroupId [_format];
	//_nul = [_grupo] spawn dismountFIA;
	//_grupo addVehicle _camion;
	}
else
	{
	_pos = position _road findEmptyPosition [1,30,vehSDKTruck];
	_vehicle=[_pos, 0,vehSDKTruck, buenos] call bis_fnc_spawnvehicle;
	_camion = _vehicle select 0;
	_grupo = _vehicle select 2;
	_pos = _pos findEmptyPosition [1,30,SDKMortar];
	_mortero = _tipogrupo createVehicle _pos;
	_nul = [_mortero] call AIVEHinit;
	_morty = _grupo createUnit [staticCrewBuenos, _pos, [],0, "NONE"];
	//_mortero attachTo [_camion,[0,-1.5,0.2]];
	//_mortero setDir (getDir _camion + 180);
	_grupo setVariable ["staticAutoT",false,true];
	if (_tipogrupo == SDKMortar) then
		{
		_morty moveInGunner _mortero;
		[_morty,_camion,_mortero] spawn mortyAI;
		_grupo setGroupId [format ["Mort-%1",{side (leader _x) == buenos} count allGroups]];
		//artyFIA synchronizeObjectsAdd [_morty];
		//_morty synchronizeObjectsAdd [artyFIA];
		//[player, apoyo, artyFIA] call BIS_fnc_addSupportLink;
		}
	else
		{
		_mortero attachTo [_camion,[0,-1.5,0.2]];
		_mortero setDir (getDir _camion + 180);
		_morty moveInGunner _mortero;
		if (_tipogrupo == staticATBuenos) then {_grupo setGroupId [format ["M.AT-%1",{side (leader _x) == buenos} count allGroups]]};
		if (_tipogrupo == staticAABuenos) then {_grupo setGroupId [format ["M.AA-%1",{side (leader _x) == buenos} count allGroups]]};
		};
	driver _camion action ["engineOn", vehicle driver _camion];
	_nul = [_camion] call AIVEHinit;
	};

{[_x] call FIAinit} forEach units _grupo;
leader _grupo setBehaviour "SAFE";
Stavros hcSetGroup [_grupo];
petros directSay "SentGenReinforcementsArrived";
hint format ["Group %1 at your command.\n\nGroups are managed from the High Command bar (Default: CTRL+SPACE)\n\nIf the group gets stuck, use the AI Control feature to make them start moving. Mounted Static teams tend to get stuck (solving this is WiP)\n\nTo assign a vehicle for this group, look at some vehicle, and use Vehicle Squad Mngmt option in Y menu", groupID _grupo];

if (!_esinf) exitWith {};

if (count _formato == 2) then
	{
	_tipoVeh = vehSDKBike;
	}
else
	{
	if (count _formato > 4) then
		{
		_tipoVeh = vehSDKTruck;
		}
	else
		{
		_tipoVeh = vehSDKLightUnarmed;
		};
	};

_coste = [_tipoVeh] call vehiclePrice;
private ["_display","_childControl"];
if (_coste > server getVariable "resourcesFIA") exitWith {};

_nul = createDialog "veh_query";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
	{
	_ChildControl = _display displayCtrl 104;
	_ChildControl  ctrlSetTooltip format ["Buy a vehicle for this squad for %1 €",_coste];
	_ChildControl = _display displayCtrl 105;
	_ChildControl  ctrlSetTooltip "Barefoot Infantry";
	};

waitUntil {(!dialog) or (!isNil "vehQuery")};

if ((!dialog) and (isNil "vehQuery")) exitWith {};

//if (!vehQuery) exitWith {vehQuery = nil};

vehQuery = nil;
//_resourcesFIA = server getVariable "resourcesFIA";
//if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money for this vehicle: %1 € required",_coste]};
_pos = position _road findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
_mortero = _tipoVeh createVehicle _pos;
_nul = [_mortero] call AIVEHinit;
_grupo addVehicle _mortero;
_mortero setVariable ["owner",_grupo,true];
_nul = [0, - _coste] remoteExec ["resourcesFIA",2];
leader _grupo assignAsDriver _mortero;
{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _grupo;
hint "Vehicle Purchased";
petros directSay "SentGenBaseUnlockVehicle";
