if (!isServer and hasInterface) exitWith{};

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
	_ciudades = _ciudades - [_marcador];
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

_tam = [_marcador] call sizeMarker;
_casas = nearestObjects [_posicion, ["house"], _tam];
_poscasa = [];
_casa = _casas select 0;
while {count _poscasa < 3} do
	{
	_casa = _casas call BIS_Fnc_selectRandom;
	_poscasa = [_casa] call BIS_fnc_buildingPositions;
	if (count _poscasa < 3) then {_casas = _casas - [_casa]};
	};

//_mrkfin = createMarker [format ["RES%1", random 100], getPos _casa];
//_mrkfin setMarkerShape "ICON";
//_mrkfin setMarkerType "hd_destroy";
//_mrkfin setMarkerColor "ColorBlue";
//_mrkfin setMarkerText "Evac Refugees";
_nombredest = [_marcador] call localizar;
_tiempolim = if (_dificil) then {30} else {60};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_lado = if (_marcador in mrkNATO) then {malos} else {muyMalos};
_texto = if (_lado == malos) then {format ["A group of smugglers have been arrested in %1 and they are about to be sent to prison. Go there and free them in order to make them join our cause. Do this before %2:%3",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4]} else {format ["A group of SDK supportes are hidden in %1 awaiting for evacuation. We have to find them before CSAT does it. If not, there will be a certain death for them. Bring them back to HQ",_nombredest]};
_posTsk = if (_lado == malos) then {(position _casa) getPos [random 100, random 360]} else {position _casa};

_tsk = ["RES",[buenos,civilian],[_texto,"Refugees Evac",_nombredest],_posTsk,"CREATED",5,true,true,"run"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_grupoPOW = createGroup buenos;
for "_i" from 1 to (count _poscasa) - 1 do
	{
	_unit = _grupoPOW createUnit [SDKUnarmed, _poscasa select _i, [], 0, "NONE"];
	_unit allowdamage false;
	_unit disableAI "MOVE";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "TARGET";
	_unit setBehaviour "CARELESS";
	_unit allowFleeing 0;
	_unit setSkill 0;
	_POWs = _POWs + [_unit];
	[_unit,"refugiado"] remoteExec ["flagaction",[buenos,civilian],_unit];
	if (_lado == malos) then {[_unit,true] remoteExec ["setCaptive"]};
	[_unit] call reDress;
	sleep 0.5;
	};

sleep 5;

{_x allowDamage true} forEach _POWs;

sleep 30;
_mrk = "";
_grupo = grpNull;
_veh = objNull;
_grupo1 = grpNull;
if (_lado == muyMalos) then
	{
	_nul = [_casa] spawn
		{
		private ["_casa"];
		_casa = _this select 0;
		if (_dificil) then {sleep 300} else {sleep 300 + (random 1800)};
		if ("RES" in misiones) then
			{
			_aeropuertos = aeropuertos select {(_x in mrkCSAT) and (dateToNumber date > server getVariable _x) and (not(spawner getVariable [_x,false]))};
			_aeropuerto = [_aeropuertos, position casa] call BIS_fnc_nearestPosition;
			[position _casa,_aeropuerto] remoteExec ["patrolCA",HCattack];
			};
		};
	}
else
	{
	_posVeh = [];
	_dirVeh = 0;
	_roads = [];
	_radius = 20;
	while {count _roads == 0} do
		{
		_roads = (getPos _casa) nearRoads _radius;
		_radius = _radius + 10;
		};
	_road = _roads select 0;
	_posroad = getPos _road;
	_roadcon = roadsConnectedto _road; if (count _roadCon == 0) then {diag_log format ["Antistasi Error: Esta carretera no tiene conexión: %1",position _road]};
	if (count _roadCon > 0) then
		{
		_posrel = getPos (_roadcon select 0);
		_dirveh = [_posroad,_posrel] call BIS_fnc_DirTo;
		}
	else
		{
		_dirVeh = getDir _road;
		};
	_posVeh = [_posroad, 3, _dirveh + 90] call BIS_Fnc_relPos;
	_veh = "B_GEN_Offroad_01_gen_F" createVehicle _posVeh;
	_veh allowDamage false;
	_veh setDir _dirVeh;
	sleep 15;
	_veh allowDamage true;
	_nul = [_veh] call AIVEHinit;
	_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], getPos _casa];
	_mrk setMarkerShapeLocal "RECTANGLE";
	_mrk setMarkerSizeLocal [50,50];
	_mrk setMarkerTypeLocal "hd_warning";
	_mrk setMarkerColorLocal "ColorRed";
	_mrk setMarkerBrushLocal "DiagGrid";
	_mrk setMarkerAlphaLocal 0;
	if ((random 100 < prestigeNATO) or (_dificil)) then
		{
		_grupo = [getPos _casa,malos, cfgNATOInf >> NATOSquad] call BIS_Fnc_spawnGroup;
		sleep 1;
		}
	else
		{
		_grupo = createGroup malos;
		_grupo = [getPos _casa,malos,["B_GEN_Commander_F","B_GEN_Soldier_F","B_GEN_Soldier_F","B_GEN_Soldier_F","B_GEN_Soldier_F","B_GEN_Soldier_F","B_GEN_Soldier_F","B_GEN_Soldier_F"]] call BIS_fnc_spawnGroup;
		};
	if (random 10 < 2.5) then
		{
		_perro = _grupo createUnit ["Fin_random_F",_posicion,[],0,"FORM"];
		[_perro] spawn guardDog;
		};
	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "NOVEH2","RANDOM", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	{[_x,""] call NATOinit} forEach units _grupo;
	_grupo1 = [_casa buildingExit 0, malos, (configfile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol")] call BIS_Fnc_spawnGroup;
	};

_bonus = if (_dificil) then {2} else {1};

if (_lado == malos) then
	{
	waitUntil {sleep 1; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 50)} count _POWs > 0) or (dateToNumber date > _fechalimnum)};
	if ({(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 50)} count _POWs > 0) then
		{
		sleep 5;
		_tsk = ["RES",[buenos,civilian],[_texto,"Refugees Evac",_nombredest],_posTsk,"SUCCEEDED",5,true,true,"run"] call BIS_fnc_setTask;
		_cuenta = {(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 150)} count _POWs;
		_hr = _cuenta;
		_resourcesFIA = 100 * _cuenta;
		[_hr,_resourcesFIA*_bonus] remoteExec ["resourcesFIA",2];
		[3,0] remoteExec ["prestige",2];
		{if (_x distance getMarkerPos "respawn_guerrila" < 500) then {[_cuenta*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[round (_cuenta*_bonus/2),stavros] call playerScoreAdd;
		{[_x] join _grupoPOW; [_x] orderGetin false} forEach _POWs;
		}
	else
		{
		_tsk = ["RES",[buenos,civilian],[_texto,"Refugees Evac",_nombredest],_posTsk,"FAILED",5,true,true,"run"] call BIS_fnc_setTask;
		[-10*_bonus,stavros] call playerScoreAdd;
		};
	}
else
	{
	waitUntil {sleep 1; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 50)} count _POWs > 0)};
	if ({alive _x} count _POWs == 0) then
		{
		_tsk = ["RES",[buenos,civilian],[_texto,"Refugees Evac",_nombredest],_posTsk,"FAILED",5,true,true,"run"] call BIS_fnc_setTask;
		[-10*_bonus,stavros] call playerScoreAdd;
		}
	else
		{
		_tsk = ["RES",[buenos,civilian],[_texto,"Refugees Evac",_nombredest],_posTsk,"SUCCEEDED",5,true,true,"run"] call BIS_fnc_setTask;
		_cuenta = {(alive _x) and (_x distance getMarkerPos "respawn_guerrila" < 150)} count _POWs;
		_hr = _cuenta;
		_resourcesFIA = 100 * _cuenta;
		[_hr,_resourcesFIA*_bonus] remoteExec ["resourcesFIA",2];
		{if (_x distance getMarkerPos "respawn_guerrila" < 500) then {[_cuenta*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[round (_cuenta*_bonus/2),stavros] call playerScoreAdd;
		{[_x] join _grupoPOW; [_x] orderGetin false} forEach _POWs;
		};
	};

sleep 60;
{deleteVehicle _x} forEach _POWs;
deleteGroup _grupoPOW;

if (_lado == malos) then
	{
	deleteMarkerLocal _mrk;
	if (!isNull _veh) then {if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits)) then {deleteVehicle _veh}};
	{
	waitUntil {sleep 1; !([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits)};
	deleteVehicle _x;
	} forEach units _grupo;
	deleteGroup _grupo;
	if (!isNull _grupo1) then
		{
		{
		waitUntil {sleep 1; !([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits)};
		deleteVehicle _x;
		} forEach units _grupo1;
		deleteGroup _grupo1;
		};
	};
//sleep (540 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
//deleteMarker _mrkfin;

_nul = [1200,_tsk] spawn borrarTask;


