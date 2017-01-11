private ["_marcador","_lado","_salir","_enemy1","_enemy2","_winner"];

_marcador = _this select 0;
_lado = _this select 1;

waitUntil {sleep 1; !zoneCheckInProgress};
zoneCheckInProgress = true;
_salir = true;
_enemy1 = "";
_enemy2 = "";

if ((_lado == buenos) and (_marcador in mrkSDK)) then
	{
	_salir = false;
	_enemy1 = "OPFORSpawn";
	_enemy2 = "BLUFORSpawn";
	}
else
	{
	if ((_lado == malos) and (_marcador in mrkNATO)) then
		{
		_salir = false;
		_enemy1 = "OPFORSpawn";
		_enemy2 = "GREENFORSpawn";
		}
	else
		{
		if ((_lado == muyMalos) and (_marcador in mrkCSAT)) then
			{
			_salir = false;
			_enemy1 = "BLUFORSpawn";
			_enemy2 = "GREENFORSpawn";
			};
		};
	};

if (_salir) exitWith {zoneCheckInProgress = false};
_salir = true;
_size = [_marcador] call sizeMarker;
_posicion = getMarkerPos _marcador;
if ({((_x getVariable [_enemy1,false]) or (_x getVariable [_enemy2,false])) and (not(vehicle _x isKindOf "Air")) and (alive _x) and (!captive _x) and (!fleeing _x) and (_x distance _posicion <= _size)} count allUnits > 3*({(alive _x) and (!captive _x) and (!fleeing _x) and (_x getVariable ["marcador",""] == _marcador) and (_x isKindOf "Man")} count allUnits)) then
	{
	_salir = false;
	};
if (_salir) exitWith {zoneCheckInProgress = false};

_winner = _enemy1;
if ({(_x getVariable [_enemy1,false]) and (not(vehicle _x isKindOf "Air")) and (alive _x) and (!captive _x) and (!fleeing _x) and (_x distance _posicion <= _size)} count allUnits <= {(_x getVariable [_enemy2,false]) and (not(vehicle _x isKindOf "Air")) and (alive _x) and (!captive _x) and (!fleeing _x) and (_x distance _posicion <= _size)} count allUnits) then {_winner = _enemy2};

[_winner,_marcador] remoteExec ["markerChange",2];

if (_winner == "GREENFORSpawn") then
	{
	waitUntil {sleep 1; _marcador in mrkSDK};
	}
else
	{
	if (_winner == "BLUFORSpawn") then {waitUntil {sleep 1;(_marcador in mrkNATO)}} else {waitUntil {sleep 1;(_marcador in mrkCSAT)}};
	};
zoneCheckInProgress = false;
