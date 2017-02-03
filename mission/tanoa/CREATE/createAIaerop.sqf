if (!isServer and hasInterface) exitWith{};

private ["_pos","_marcador","_vehiculos","_grupos","_soldados","_posicion","_busy","_buildings","_pos1","_pos2","_grupo","_cuenta","_tipoVeh","_veh","_unit","_arrayVehAAF","_nVeh","_frontera","_size","_ang","_mrk","_tipogrupo","_bandera","_perro","_tipoUnit","_garrison","_cuentaTotal","_solMax","_lado","_cfg","_max","_vehicle","_vehCrew","_grupoVeh","_roads","_dist","_road","_roadscon","_roadcon","_dirveh","_bunker","_tipoGrupo"];
_marcador = _this select 0;

_vehiculos = [];
_grupos = [];
_soldados = [];

_posicion = getMarkerPos (_marcador);
_pos = [];

_size = [_marcador] call sizeMarker;
_garrison = garrison getVariable _marcador;
_cuentaTotal = 0;
_frontera = [_marcador] call isFrontline;
_busy = if (dateToNumber date > server getVariable _marcador) then {false} else {true};
_nVeh = round (_size/60);

_solMax = (8*_nveh) + 8 + 8 + 4;
if (_frontera) then
	{
	_solMax = _solMax + 1 + (8*_nVeh);
	};
if (!_busy) then
	{
	_solMax = _solMax + 5;
	};
_solMax = _solMax - _garrison;

_lado = malos;
_cfg = cfgNATOInf;
if (_marcador in mrkCSAT) then
	{
	_lado = muyMalos;
	_cfg = cfgCSATInf;
	};

if (spawner getVariable _marcador) then
	{
	_tipoVeh = if (_lado == malos) then {vehNATOAA} else {vehCSATAA};
	if ([_tipoVeh] call vehAvailable) then
		{
		_max = if (_lado == malos) then {1} else {2};
		for "_i" from 1 to _max do
			{
			_pos = [_posicion, 50, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
			//_pos = _posicion findEmptyPosition [_size - 200,_size+50,_tipoveh];
			_vehicle=[_pos, random 360,_tipoVeh, _lado] call bis_fnc_spawnvehicle;
			_veh = _vehicle select 0;
			_vehCrew = _vehicle select 1;
			{[_x,_marcador] call NATOinit} forEach _vehCrew;
			[_veh] call AIVEHinit;
			_grupoVeh = _vehicle select 2;
			_soldados = _soldados + _vehCrew;
			_grupos pushBack _grupoVeh;
			_vehiculos pushBack _veh;
			sleep 1;
			};
		};
	};

if ((spawner getVariable _marcador) and _frontera and (_cuentaTotal + 1 <= _solMax)) then
	{
	_roads = _posicion nearRoads _size;
	if (count _roads != 0) then
		{
		_grupo = createGroup _lado;
		_grupos pushBack _grupo;
		_dist = 0;
		_road = objNull;
		{if ((position _x) distance _posicion > _dist) then {_road = _x;_dist = position _x distance _posicion}} forEach _roads;
		_roadscon = roadsConnectedto _road;
		_roadcon = objNull;
		{if ((position _x) distance _posicion > _dist) then {_roadcon = _x}} forEach _roadscon;
		_dirveh = [_roadcon, _road] call BIS_fnc_DirTo;
		_pos = [getPos _road, 7, _dirveh + 270] call BIS_Fnc_relPos;
		_bunker = "Land_BagBunker_Small_green_F" createVehicle _pos;
		_vehiculos pushBack _bunker;
		_bunker setDir _dirveh;
		_pos = getPosATL _bunker;
		_tipoVeh = if (_lado==malos) then {staticATmalos} else {staticATmuyMalos};
		_veh = _tipoVeh createVehicle _posicion;
		_vehiculos pushBack _veh;
		_veh setPos _pos;
		_veh setDir _dirVeh + 180;
		_tipoUnit = if (_lado==malos) then {staticCrewmalos} else {staticCrewMuyMalos};
		_unit = _grupo createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
		[_unit,_marcador] call NATOinit;
		[_veh] call AIVEHinit;
		_unit moveInGunner _veh;
		_soldados pushBack _unit;
		_cuentaTotal = _cuentaTotal + 1;
		};
	};

_mrk = createMarkerLocal [format ["%1patrolarea", random 100], _posicion];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [(distanciaSPWN/2),(distanciaSPWN/2)];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_ang = markerDir _marcador;
_mrk setMarkerDirLocal _ang;
if (!debug) then {_mrk setMarkerAlphaLocal 0};
_cuenta = 0;
_tipoUnit = if (_lado==malos) then {staticCrewmalos} else {staticCrewMuyMalos};
_tipoVeh = if (_lado == malos) then {NATOMortar} else {CSATMortar};
while {(spawner getVariable _marcador) and (_cuenta < 4) and (_cuentaTotal + 2 <= _solMax)} do
	{
	_tipoGrupo = if (_lado == malos) then {selectRandom gruposNATOsmall} else {selectRandom gruposCSATsmall};
	/*
	while {true} do
		{
		_pos = [_posicion, 150 + (random 350) ,random 360] call BIS_fnc_relPos;
		if (!surfaceIsWater _pos) exitWith {};
		};
	*/
	_grupo = [_posicion,_lado, _cfg >> _tipoGrupo] call BIS_Fnc_spawnGroup;
	sleep 1;
	if ((random 10 < 2.5) and (not(_tipogrupo in sniperGroups))) then
		{
		_perro = _grupo createUnit ["Fin_random_F",_pos,[],0,"FORM"];
		[_perro] spawn guardDog;
		sleep 1;
		};
	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "RANDOM", "NOVEH2"] execVM "scripts\UPSMON.sqf";
	_grupos pushBack _grupo;
	{[_x,_marcador] call NATOinit; _soldados pushBack _x} forEach units _grupo;
	_pos = [_posicion] call mortarPos;
	_veh = _tipoVeh createVehicle _pos;
	_nul=[_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";
	_unit = _grupo createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
	[_unit,_marcador] call NATOinit;
	_unit moveInGunner _veh;
	_soldados pushBack _unit;
	_vehiculos pushBack _veh;
	sleep 1;
	_cuenta = _cuenta +1;
	_cuentaTotal = _cuentaTotal + 2;
	};

if (!_busy) then
	{
	_buildings = nearestObjects [_posicion, ["Land_LandMark_F","Land_runway_edgelight"], _size / 2];
	if (count _buildings > 1) then
		{
		_pos1 = getPos (_buildings select 0);
		_pos2 = getPos (_buildings select 1);
		_ang = [_pos1, _pos2] call BIS_fnc_DirTo;

		_pos = [_pos1, 5,_ang] call BIS_fnc_relPos;
		_grupo = createGroup _lado;
		_grupos pushBack _grupo;
		_cuenta = 0;
		while {(spawner getVariable _marcador) and (_cuenta < 5) and (_cuentaTotal + 1 <= _solMax)} do
			{
			_tipoVeh = if (_lado == malos) then {selectRandom vehNATOAir} else {selectRandom vehCSATAir};
			_veh = createVehicle [_tipoveh, _pos, [],3, "NONE"];
			_veh setDir (_ang + 90);
			sleep 1;
			_vehiculos pushBack _veh;
			_nul = [_veh] call AIVEHinit;
			_pos = [_pos, 50,_ang] call BIS_fnc_relPos;
			_tipoUnit = if (_lado==malos) then {NATOpilot} else {CSATpilot};
			_unit = _grupo createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
			[_unit,_marcador] call NATOinit;
			_soldados pushBack _unit;
			_cuenta = _cuenta + 1;
			_cuentaTotal = _cuentaTotal + 1;
			};
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED","NOFOLLOW","NOVEH"] execVM "scripts\UPSMON.sqf";
		};
	};

_tipoVeh = if (_lado == malos) then {NATOFlag} else {CSATFlag};
_bandera = createVehicle [_tipoVeh, _posicion, [],0, "CAN_COLLIDE"];
_bandera allowDamage false;
[_bandera,"take"] remoteExec ["flagaction",[buenos,civilian],_bandera];
_vehiculos pushBack _bandera;
if (_lado == malos) then
	{
	_veh = "B_supplyCrate_F" createVehicle _posicion;
	_nul = [_veh] call NATOcrate;
	_vehiculos pushBack _veh;
	}
else
	{
	_veh = "O_supplyCrate_F" createVehicle _posicion;
	_nul = [_veh] call CSATcrate;
	_vehiculos pushBack _veh;
	};

_arrayVehAAF = if (_lado == malos) then {if (_busy) then {vehNATONormal} else {vehNATOAttack + vehNATONormal}} else {if (_busy) then {vehCSATNormal} else {vehCSATAttack + vehCSATNormal}};

_cuenta = 0;
while {(spawner getVariable _marcador) and (_cuenta < _nVeh)} do
	{
	if (diag_fps > minimoFPS) then
		{
		_tipoVeh = selectRandom _arrayVehAAF;
		_pos = [_posicion, 10, _size/2, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
		_veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
		_veh setDir random 360;
		_vehiculos = _vehiculos + [_veh];
		_nul = [_veh] call AIVEHinit;
		sleep 1;
		};
	_cuenta = _cuenta + 1;
	};

if ((spawner getVariable _marcador) and (_cuentaTotal + 8 <= _solMax)) then
	{
	_tipoGrupo = if (_lado == malos) then {selectRandom gruposNATOSquad} else {selectRandom gruposCSATSquad};
	_grupo = [_posicion, _lado, _cfg >> _tipoGrupo] call BIS_Fnc_spawnGroup;
	sleep 1;
	_nul = [leader _grupo, _marcador, "SAFE", "RANDOMUP","SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_grupos pushBack _grupo;
	{[_x,_marcador] call NATOinit; _soldados pushBack _x} forEach units _grupo;
	_cuentaTotal = _cuentaTotal + 8;
	};
_cuenta = 0;
if (_frontera) then {_nveh = _nveh * 2};
while {(spawner getVariable _marcador) and (_cuenta < _nveh) and (_cuentaTotal + 8 <= _solMax)} do
	{
	if (diag_fps > minimoFPS) then
		{
		/*
		while {true} do
			{
			_pos = [_posicion, random _size,random 360] call BIS_fnc_relPos;
			if (!surfaceIsWater _pos) exitWith {};
			};
		*/
		_grupo = [_posicion,_lado, _cfg >> _tipoGrupo] call BIS_Fnc_spawnGroup;
		/*
		if (random 10 < 2.5) then
			{
			_perro = _grupo createUnit ["Fin_random_F",_pos,[],0,"FORM"];
			[_perro] spawn guardDog;
			};
		*/
		sleep 1;
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED", "RANDOM","NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		_grupos pushBack _grupo;
		{[_x,_marcador] call NATOinit; _soldados pushBack _x} forEach units _grupo;
		};
	_cuenta = _cuenta + 1;
	_cuentaTotal = _cuentaTotal + 8;
	sleep 1;
	};
/*
for "_i" from 1 to _garrison do
	{
	if (!(isNil "_unit")) then
		{
		_unit = selectRandom _soldados;
		if (vehicle _unit == _unit) then
			{
			_soldados = _soldados - [_unit];
			deleteVehicle _unit;
			};
		};
	};
*/
waitUntil {sleep 1; not (spawner getVariable _marcador)};

//_variableENY = if (_lado == malos) then {"OPFORSpawn"} else {"BLUFORSpawn"};
deleteMarker _mrk;
{if (alive _x) then
	{
	deleteVehicle _x
	};
} forEach _soldados;
//if (!isNull _periodista) then {deleteVehicle _periodista};
{deleteGroup _x} forEach _grupos;
{
if (!(_x in staticsToSave)) then
	{
	//if ((!([distanciaSPWN-_size,1,_x,"GREENFORSpawn"] call distanceUnits)) and (!([distanciaSPWN-_size,1,_x,_variableENY] call distanceUnits))) then {deleteVehicle _x}
	if ((!([distanciaSPWN-_size,1,_x,"GREENFORSpawn"] call distanceUnits))) then {deleteVehicle _x}
	};
} forEach _vehiculos;


