if (!isServer and hasInterface) exitWith{};

private ["_unit","_marcador","_posicion"];

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

_POWs = [];

_tiempolim = if (_dificil) then {30} else {120};//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;

_tsk = ["RES",[buenos,civilian],[format ["A group of POWs is awaiting for execution in %1. We must rescue them before %2:%3. Bring them to HQ",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"POW Rescue",_marcador],_posicion,"CREATED",5,true,true,"run"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

//_blacklistbld = ["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F"];
_poscasa = [];
_cuenta = 0;
_casas = nearestObjects [_posicion, ["house"], 50];
_casa = "";
_posibles = [];
for "_i" from 0 to (count _casas) - 1 do
	{
	_casa = (_casas select _i);
	_poscasa = [_casa] call BIS_fnc_buildingPositions;
	if (count _poscasa > 1) then {_posibles pushBack _casa};
	};

if (count _posibles > 0) then
	{
	_casa = _posibles call BIS_Fnc_selectRandom;
	_poscasa = [_casa] call BIS_fnc_buildingPositions;
	_cuenta = (count _poscasa) - 1;
	if (_cuenta > 10) then {_cuenta = 10};
	}
else
	{
	_cuenta = round random 10;
	for "_i" from 0 to _cuenta do
		{
		_postmp = [_posicion, 5, random 360] call BIS_Fnc_relPos;
		_poscasa pushBack _postmp;
		};
	};
_grpPOW = createGroup buenos;
for "_i" from 0 to _cuenta do
	{
	_unit = _grpPOW createUnit [SDKUnarmed, (_poscasa select _i), [], 0, "NONE"];
	_unit allowDamage false;
	[_unit,true] remoteExec ["setCaptive"];
	_unit disableAI "MOVE";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "TARGET";
	_unit setUnitPos "UP";
	_unit setBehaviour "CARELESS";
	_unit allowFleeing 0;
	//_unit disableAI "ANIM";
	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	sleep 1;
	//if (alive _unit) then {_unit playMove "UnaErcPoslechVelitele1";};
	_POWS pushBack _unit;
	[_unit,"prisionero"] remoteExec ["flagaction",[buenos,civilian],_unit];
	[_unit] call reDress;
	};

sleep 5;

{_x allowDamage true} forEach _POWS;

waitUntil {sleep 1; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 50)} count _POWs > 0) or (dateToNumber date > _fechalimnum)};

if (dateToNumber date > _fechalimnum) then
	{
	if (not (spawner getVariable _marcador)) then
		{
		{
		if (group _x == _grpPOW) then
			{
			_x setDamage 1;
			};
		} forEach _POWS;
		}
	else
		{
		{
		if (group _x == _grpPOW) then
			{
			[_x,false] remoteExec ["setCaptive"];
			_x enableAI "MOVE";
			_x doMove _posicion;
			};
		} forEach _POWS;
		};
	};

waitUntil {sleep 1; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 50)} count _POWs > 0)};

_bonus = if (_dificil) then {2} else {1};

if ({alive _x} count _POWs == 0) then
	{
	_tsk = ["RES",[buenos,civilian],[format ["A group of POWs is awaiting for execution in %1. We must rescue them before %2:%3. Bring them to HQ",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"POW Rescue",_marcador],_posicion,"FAILED",5,true,true,"run"] call BIS_fnc_setTask;
	{[_x,false] remoteExec ["setCaptive"]} forEach _POWs;
	[-10*_bonus,stavros] call playerScoreAdd;
	}
else
	{
	sleep 5;
	_tsk = ["RES",[buenos,civilian],[format ["A group of POWs is awaiting for execution in %1. We must rescue them before %2:%3. Bring them to HQ",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"POW Rescue",_marcador],_posicion,"SUCCEEDED",5,true,true,"run"] call BIS_fnc_setTask;
	_cuenta = {(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 150)} count _POWs;
	_hr = 2 * (_cuenta);
	_resourcesFIA = 100 * _cuenta*_bonus;
	[_hr,_resourcesFIA] remoteExec ["resourcesFIA",2];
	[0,10*_bonus,_posicion] remoteExec ["citySupportChange",2];
	//[_cuenta,0] remoteExec ["prestige",2];
	{if (_x distance getMarkerPos "respawn_guerrila" < 500) then {[_cuenta,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
	[round (_cuenta*_bonus/2),stavros] call playerScoreAdd;
	{[_x] join _grpPOW; [_x] orderGetin false} forEach _POWs;
	};

sleep 60;
{deleteVehicle _x} forEach _POWs;
deleteGroup _grpPOW;

_nul = [1200,_tsk] spawn borrarTask;

