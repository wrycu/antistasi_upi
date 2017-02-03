if (!isServer and hasInterface) exitWith{};

private ["_marcador","_posicion","_fechalim","_fechalimnum","_nombredest","_tipoVeh","_texto","_camionCreado","_size","_pos","_veh","_grupo","_unit"];

_marcador = _this select 0;

_chance = skillFIA + (20*({_x in aeropuertos} count mrkSDK));
_dificil = if (random 100 < _chance) then {true} else {false};
_salir = false;
_contacto = objNull;
_grpContacto = grpNull;
_tsk = "";
if (_dificil) then
	{
	_posHQ = getMarkerPos "respawn_guerrila";
	_ciudades = ciudades select {getMarkerPos _x distance _posHQ < distanciaMiss};

	if (count _ciudades == 0) exitWith {_dificil = false};
	_ciudad = selectRandom _ciudades;

	_tam = [_ciudad] call sizeMarker;
	_posicion = getMarkerPos _ciudad;
	_casas = nearestObjects [_posicion, ["house"], _tam];
	_posCasa = [];
	_casa = objNull;
	while {count _posCasa == 0} do
		{
		_casa = selectRandom _casas;
		_posCasa = [_casa] call BIS_fnc_buildingPositions;
		_casas = _casas - [_casa];
		};
	_grpContacto = createGroup civilian;
	_contacto = _grpContacto createUnit [selectRandom arrayCivs, selectRandom _posCasa, [], 0, "NONE"];
	_contacto allowDamage false;
	_contacto setVariable ["statusAct",false,true];
	_contacto forceSpeed 0;
	_contacto setUnitPos "UP";
	[_contacto,"missionGiver"] remoteExec ["flagaction",[buenos,civilian],_contacto];

	_nombredest = [_ciudad] call localizar;
	_tiempolim = 15;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;

	_tsk = ["DES",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"CREATED",5,true,true,"talk"] call BIS_fnc_setTask;
	misiones pushBack _tsk; publicVariable "misiones";

	waitUntil {sleep 1; (_contacto getVariable "statusAct") or (dateToNumber date > _fechalimnum)};
	if (dateToNumber date > _fechalimnum) then
		{
		_salir = true
		}
	else
		{
		if (_marcador in mrkSDK) then
			{
			_salir = true;
			{
			if (isPlayer _x) then {[_contacto,"globalChat","My information is useless now"] remoteExec ["commsMP",_x]}
			} forEach ([50,0,position _casa,"GREENFORSpawn"] call distanceUnits);
			};
		};
	[_contacto] spawn
		{
		_contacto = _this select 0;
		sleep cleanTime;
		deleteVehicle _contacto;
		deleteGroup _grpContacto;
		};
	if (_salir) exitWith
		{
		if (_contacto getVariable "statusAct") then
			{
			[0,_tsk] spawn borrarTask;
			}
		else
			{
			_tsk = ["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"FAILED",5,true,true,"talk"] call BIS_fnc_setTask;
			[1200,_tsk] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,_tsk] spawn borrarTask;
	waitUntil {sleep 1; !(_tsk in misiones)};
	};
_posicion = getMarkerPos _marcador;
_lado = if (_marcador in mrkNATO) then {malos} else {muyMalos};
_tiempolim = if (_dificil) then {30} else {120};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;

_tipoVeh = if (_lado == malos) then {vehNATOAA} else {vehCSATAA};

_tsk = ["DES",[buenos,civilian],[format ["We know an enemy armor (%4) is stationed in %1. It is a good chance to destroy or steal it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,getText (configFile >> "CfgVehicles" >> (_tipoVeh) >> "displayName")],"Steal or Destroy Armor",_marcador],_posicion,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_camionCreado = false;

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (spawner getVariable _marcador)};
_bonus = if (_dificil) then {2} else {1};
if (spawner getVariable _marcador) then
	{
	_camionCreado = true;
	_size = [_marcador] call sizeMarker;
	_pos = [];
	if (_size > 40) then {_pos = [_posicion, 10, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos} else {_pos = _posicion findEmptyPosition [10,60,_tipoVeh]};
	_veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
	_veh allowdamage false;
	_veh setDir random 360;
	[_veh] call AIVEHinit;

	_grupo = createGroup _lado;

	sleep 5;
	_veh allowDamage true;
	_tipo = if (_lado == malos) then {NATOCrew} else {CSATCrew};
	for "_i" from 1 to 3 do
		{
		_unit = _grupo createUnit [_tipo, _pos, [], 0, "NONE"];
		[_unit,""] call NATOinit;
		sleep 2;
		};

	if (_dificil) then
		{
		_grupo addVehicle _veh;
		}
	else
		{
		waitUntil {sleep 1;({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"GREENFORSpawn"] call distanceUnits) > 0) or (dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0)};

		if ({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"GREENFORSpawn"] call distanceUnits) > 0) then {_grupo addVehicle _veh;};
		};

	waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0)};

	if ((not alive _veh) or ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0)) then
		{
		_tsk = ["DES",[buenos,civilian],[format ["We know an enemy armor (%4) is stationed in a %1. It is a good chance to steal or destroy it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,getText (configFile >> "CfgVehicles" >> (_tipoVeh) >> "displayName")],"Steal or Destroy Armor",_marcador],_posicion,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		if ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0) then
			{
			["TaskFailed", ["", format ["AA Stolen in %1",_nombreDest]]] remoteExec ["BIS_fnc_showNotification",_lado];
			};
		[0,300*_bonus] remoteExec ["resourcesFIA",2];
		if (_lado == muyMalos) then {[0,3] remoteExec ["prestige",2]; [0,10*_bonus,_posicion] remoteExec ["citySupportChange",2]} else {[3,0] remoteExec ["prestige",2];[0,5*_bonus,_posicion] remoteExec ["citySupportChange",2]};
		[1200*_bonus] remoteExec ["timingCA",2];
		{if (_x distance _veh < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5*_bonus,stavros] call playerScoreAdd;
		};
	}
else
	{
	_tsk = ["DES",[buenos,civilian],[format ["We know an enemy armor (%4) is stationed in a %1. It is a good chance to steal or destroy it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,getText (configFile >> "CfgVehicles" >> (_tipoVeh) >> "displayName")],"Steal or Destroy Armor",_marcador],_posicion,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[-5*_bonus,-100*_bonus] remoteExec ["resourcesFIA",2];
	[5*_bonus,0,_posicion] remoteExec ["citySupportChange",2];
	[-600*_bonus] remoteExec ["timingCA",2];
	[-10*_bonus,stavros] call playerScoreAdd;
	};

_nul = [1200,_tsk] spawn borrarTask;

waitUntil {sleep 1; not (spawner getVariable _marcador)};

if (_camionCreado) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits)) then {deleteVehicle _veh};
	};
