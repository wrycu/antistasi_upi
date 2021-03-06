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

_tiempolim = if (_dificil) then {30} else {60};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;
_taskDescription = format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserved a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3. You may allways sell those supplies here, that money can be welcome. Just sell the truck and job is done",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4];
_tsk = ["LOG",[buenos,civilian],[_taskDescription,"City Supplies",_marcador],_posicion,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_pos = [];

if (!_dificil) then
	{
	_pos = (getMarkerPos "respawn_guerrila") findEmptyPosition [1,50,"C_Van_01_box_F"];
	}
else
	{
	_dirVeh = 0;
	_roads = [];
	_radius = 20;
	while {count _roads == 0} do
		{
		_roads = (getPos _contacto) nearRoads _radius;
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
	_pos = [_posroad, 3, _dirveh + 90] call BIS_Fnc_relPos;
	};

_camion = "C_Van_01_box_F" createVehicle _pos;
_camion allowDamage false;
[_camion] call AIVEHinit;
{_x reveal _camion} forEach (allPlayers - hcArray);
_camion setVariable ["destino",_nombredest,true];
_camion addEventHandler ["GetIn",
	{
	if (_this select 1 == "driver") then
		{
		_texto = format ["Bring this truck to %1 and deliver it's supplies to the population",(_this select 0) getVariable "destino"];
		_texto remoteExecCall ["hint",_this select 2];
		};
	}];

[_camion,"Mission Vehicle"] spawn inmuneConvoy;
if (_dificil) then {reportedVehs pushBack _camion; publicVariable "reportedVehs"};

waitUntil {sleep 1; (not alive _camion) or (dateToNumber date > _fechalimnum) or (_camion distance _posicion < 40)};
_bonus = if (_dificil) then {2} else {1};
if ((not alive _camion) or (dateToNumber date > _fechalimnum)) then
	{
	_tsk = ["LOG",[buenos,civilian],[_taskDescription,"City Supplies",_marcador],_posicion,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5*_bonus,-5*_bonus,_posicion] remoteExec ["citySupportChange",2];
	[-10*_bonus,stavros] call playerScoreAdd;
	}
else
	{
	_cuenta = 120*_bonus;//120
	[_posicion,malos] remoteExec ["patrolCA",HCattack];
	["TaskFailed", ["", format ["SDK deploying supplies in %1",_nombredest]]] remoteExec ["BIS_fnc_showNotification",malos];
	{_amigo = _x;
	if (captive _amigo) then
		{
		[_amigo,false] remoteExec ["setCaptive"];
		};
	{
	if ((side _x == malos) and (_x distance _posicion < distanciaSPWN)) then
		{
		if (_x distance _posicion < 300) then {_x doMove _posicion} else {_x reveal [_amigo,4]};
		};
	if ((side _x == civilian) and (_x distance _posicion < 300)) then {_x doMove position _camion};
	} forEach allUnits;
	} forEach ([300,0,_camion,"GREENFORSpawn"] call distanceUnits);
	while {(_cuenta > 0)/* or (_camion distance _posicion < 40)*/ and (alive _camion) and (dateToNumber date < _fechalimnum)} do
		{
		while {(_cuenta > 0) and (_camion distance _posicion < 40) and (alive _camion) and !({_x getVariable ["inconsciente",false]} count ([80,0,_camion,"GREENFORSpawn"] call distanceUnits) == count ([80,0,_camion,"GREENFORSpawn"] call distanceUnits)) and ({(side _x == malos) and (_x distance _camion < 50)} count allUnits == 0) and (dateToNumber date < _fechalimnum)} do
			{
			_formato = format ["%1", _cuenta];
			{if (isPlayer _x) then {[petros,"countdown",_formato] remoteExec ["commsMP",_x]}} forEach ([80,0,_camion,"GREENFORSpawn"] call distanceUnits);
			sleep 1;
			_cuenta = _cuenta - 1;
			};
		if (_cuenta > 0) then
			{
			_cuenta = 120*_bonus;//120
			if (((_camion distance _posicion > 40) or (not([80,1,_camion,"GREENFORSpawn"] call distanceUnits)) or ({(side _x == malos) and (_x distance _camion < 50)} count allUnits != 0)) and (alive _camion)) then {{[petros,"hint","Don't get the truck far from the city center, and stay close to it, and clean all BLUFOR presence in the surroundings or count will restart"] remoteExec ["commsMP",_x]} forEach ([100,0,_camion,"GREENFORSpawn"] call distanceUnits)};
			waitUntil {sleep 1; (!alive _camion) or ((_camion distance _posicion < 40) and ([80,1,_camion,"GREENFORSpawn"] call distanceUnits) and ({(side _x == malos) and (_x distance _camion < 50)} count allUnits == 0)) or (dateToNumber date > _fechalimnum)};
			};
		if ((alive _camion) and (_cuenta < 1)) exitWith {};
		};
		if ((alive _camion) and (dateToNumber date < _fechalimnum)) then
			{
			[petros,"hint","Supplies Delivered"] remoteExec ["commsMP",[buenos,civilian]];
			_tsk = ["LOG",[buenos,civilian],[_taskDescription,"City Supplies",_marcador],_posicion,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
			[0,15*_bonus,_marcador] remoteExec ["citySupportChange",2];
			[-3,0] remoteExec ["prestige",2];
			{if (_x distance _posicion < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
			[5*_bonus,stavros] call playerScoreAdd;
			}
		else
			{
			_tsk = ["LOG",[buenos,civilian],[_taskDescription,"City Supplies",_marcador],_posicion,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
			[5*_bonus,-5*_bonus,_posicion] remoteExec ["citySupportChange",2];
			[-10*_bonus,stavros] call playerScoreAdd;
			};
	};

_camion setFuel 0;

//sleep (600 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,_tsk] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_camion,"GREENFORSpawn"] call distanceUnits)) or (_camion distance (getMarkerPos "respawn_guerrila") < 60)};
deleteVehicle _camion;
