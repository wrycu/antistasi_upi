if (!isServer and hasInterface) exitWith{};

private ["_pos","_roadscon","_veh","_roads","_conquistado","_dirVeh","_marcador","_posicion","_vehiculos","_soldados","_tam","_bunker","_grupoE","_unit","_tipogrupo","_grupo","_tiempolim","_fechalim","_fechalimnum","_base","_perro","_lado","_cfg","_esFIA","_salir","_esControl","_tam","_tipoVeh","_tipoUnit","_marcadores","_frontera","_uav","_grupoUAV","_allUnits","_closest","_winner","_tiempolim","_fechalim","_fechalimNum","_size","_base","_mina"];

_marcador = _this select 0;
if (_marcador in mrkSDK) exitWith {};

_vehiculos = [];
_soldados = [];
_conquistado = false;
_posicion = getMarkerPos _marcador;

_lado = muyMalos;
_cfg = cfgCSATInf;
_esFIA = false;
_salir = false;

_esControl = if (isOnRoad _posicion) then {true} else {false};

if (_esControl) then
	{
	if (_marcador in mrkNATO) then
		{
		if (random 100 < prestigeNATO) then
			{
			_lado = malos;
			_cfg = cfgNATOInf;
			}
		else
			{
			_esFIA = true;
			_lado = malos;
			_cfg = cfgFIAInf;
			};
		};

	_tam = 20;
	while {true} do
		{
		_roads = _posicion nearRoads _tam;
		if (count _roads > 1) exitWith {};
		_tam = _tam + 5;
		};

	_roadscon = roadsConnectedto (_roads select 0);

	_dirveh = [_roads select 0, _roadscon select 0] call BIS_fnc_DirTo;
	if ((isNull (_roads select 0)) or (isNull (_roadscon select 0))) then {diag_log format ["Antistasi Roadblock error report: %1 position is bad",_marcador]};

	if (!_esFIA) then
		{
		_pos = [getPos (_roads select 0), 7, _dirveh + 270] call BIS_Fnc_relPos;
		_bunker = "Land_BagBunker_01_Small_green_F" createVehicle _pos;
		_vehiculos pushBack _bunker;
		_bunker setDir _dirveh;
		_pos = getPosATL _bunker;
		_tipoVeh = if (_lado == malos) then {NATOMG} else {CSATMG};
		_veh = _tipoVeh createVehicle _posicion;
		_vehiculos pushBack _veh;
		_veh setPosATL _pos;
		_veh setDir _dirVeh;

		_grupoE = createGroup _lado;
		_tipoUnit = if (_lado == malos) then {staticCrewMalos} else {staticCrewMuyMalos};
		_unit = _grupoE createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
		_unit moveInGunner _veh;
		_soldados pushBack _unit;
		sleep 1;
		_pos = [getPos (_roads select 0), 7, _dirveh + 90] call BIS_Fnc_relPos;
		_bunker = "Land_BagBunker_01_Small_green_F" createVehicle _pos;
		_vehiculos pushBack _bunker;
		_bunker setDir _dirveh + 180;
		_pos = getPosATL _bunker;
		_veh = _tipoVeh createVehicle _posicion;
		_vehiculos pushBack _veh;
		_veh setPosATL _pos;
		_veh setDir _dirVeh;
		sleep 1;
		_unit = _grupoE createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
		_unit moveInGunner _veh;
		_soldados pushBack _unit;
		sleep 1;
		_pos = [getPos _bunker, 6, getDir _bunker] call BIS_fnc_relPos;
		_tipoVeh = if (_lado == malos) then {NATOFlag} else {CSATFlag};
		_veh = createVehicle [_tipoVeh, _pos, [],0, "CAN_COLLIDE"];
		_vehiculos pushBack _veh;

		{_nul = [_x] call AIVEHinit} forEach _vehiculos;

		_tipogrupo = if (_lado == malos) then {gruposNATOmid call BIS_fnc_selectRandom} else {gruposCSATmid call BIS_fnc_selectRandom};
		_grupo = [_posicion,_lado, _cfg >> _tipogrupo] call BIS_Fnc_spawnGroup;
		{[_x] join _grupo} forEach units _grupoE;
		deleteGroup _grupoE;
		if (random 10 < 2.5) then
			{
			_perro = _grupo createUnit ["Fin_random_F",_posicion,[],0,"FORM"];
			[_perro,_grupo] spawn guardDog;
			};
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		{[_x,""] call NATOinit; _soldados pushBack _x} forEach units _grupo;
		}
	else
		{
		_veh = vehFIAArmedCar createVehicle getPos (_roads select 0);
		_veh setDir _dirveh + 90;
		_nul = [_veh] call AIVEHinit;
		_vehiculos pushBack _veh;
		sleep 1;
		_tipogrupo = selectRandom gruposFIAMid;
		_grupo = [_posicion, _lado, cfgFIAInf >> _tipoGrupo] call BIS_Fnc_spawnGroup;
		_unit = _grupo createUnit [FIARifleman, _posicion, [], 0, "NONE"];
		_unit moveInGunner _veh;
		{_soldados pushBack _x; [_x,""] call NATOinit} forEach units _grupo;
		};
	}
else
	{
	_marcadores = mrkSDK select {getMarkerPos _x distance _posicion < distanciaSPWN};
	_marcadores = _marcadores - ["Synd_HQ"] - puestosFIA;
	_frontera = if (count _marcadores > 0) then {true} else {false};
	if (_frontera) then
		{
		_cfg = CSATSpecOp;
		if (_marcador in mrkNATO) then
			{
			_cfg = NATOSpecOp;
			_lado = malos;
			};
		_grupo = [_posicion,_lado, _cfg] call BIS_Fnc_spawnGroup;
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED","RANDOM","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		sleep 1;
		_tipoVeh = if (_lado == malos) then {vehNATOUAVSmall} else {vehCSATUAVSmall};
		_uav = createVehicle [_tipoVeh, _posicion, [], 0, "FLY"];
		createVehicleCrew _uav;
		_vehiculos pushBack _uav;
		_grupoUAV = group (crew _uav select 1);
		{[_x] joinSilent _grupo} forEach units _grupoUAV;
		deleteGroup _grupoUAV;
		{[_x,""] call NATOinit; _soldados pushBack _x} forEach units _grupo;
		}
	else
		{
		_salir = true;
		};
	};
if (_salir) exitWith {};
waitUntil {sleep 1;(not (spawner getVariable _marcador))  or ({alive _x} count _soldados == 0) or ({fleeing _x} count _soldados == {alive _x} count _soldados)};

_conquistado = false;
_winner = malos;
if (spawner getVariable _marcador) then
	{
	_conquistado = true;
	_allUnits = allUnits select {(side _x != civilian) and (side _x != _lado) and (alive _x) and (!captive _x)};
	_closest = [_allUnits,_posicion] call BIS_fnc_nearestPosition;
	_winner = side _closest;
	if (_esControl) then
		{
		["TaskSucceeded", ["", "Roadblock Destroyed"]] remoteExec ["BIS_fnc_showNotification",_winner];
		["TaskFailed", ["", "Roadblock Lost"]] remoteExec ["BIS_fnc_showNotification",_lado];
		};
	if (_marcador in mrkNATO) then
		{
		mrkNATO = mrkNATO - [_marcador];
		publicVariable "mrkNATO";
		if (_winner == muyMalos) then
			{
			mrkCSAT pushBackUnique _marcador;
			publicVariable "mrkCSAT";
			_nul = [-5,0,_posicion] remoteExec ["citySupportChange",2];
			}
		else
			{
			mrkSDK pushBack _marcador;
			publicVariable "mrkSDK";
			};
		}
	else
		{
		mrkCSAT = mrkCSAT - [_marcador];
		publicVariable "mrkCSAT";
		if (_winner == malos) then
			{
			mrkNATO pushBackUnique _marcador;
			publicVariable "mrkNATO";
			_nul = [5,0,_posicion] remoteExec ["citySupportChange",2];
			}
		else
			{
			mrkSDK pushBack _marcador;
			publicVariable "mrkSDK";
			_nul = [0,5,_posicion] remoteExec ["citySupportChange",2];
			};
		};
	if (_winner == buenos) then {[_posicion,_lado] remoteExec ["patrolCA",HCattack]};
	};

waitUntil {sleep 1;not (spawner getVariable _marcador)};

{_veh = _x;
if (not(_veh in staticsToSave)) then
	{
	if ((!([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits))) then {deleteVehicle _x}
	};
} forEach _vehiculos;
{
if (alive _x) then {deleteVehicle _x}} forEach _soldados;
deleteGroup _grupo;

if (_conquistado) then
	{
	_tiempolim = 120;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;
	waitUntil {sleep 60;(dateToNumber date > _fechalimnum)};
	_base = [(marcadores - controles),_posicion] call BIS_fnc_nearestPosition;
	if (_base in mrkNATO) then
		{
		mrkNATO pushBackUnique _marcador;
		publicVariable "mrkNATO";
		}
	else
		{
		if (_base in mrkCSAT) then
			{
			mrkCSAT pushBackUnique _marcador;
			publicVariable "mrkCSAT";
			};
		};
	if ((!_esControl) and (_winner == buenos) and (not(_marcador in mrkSDK))) then
		{
		_size = [_marcador] call sizeMarker;
		for "_i" from 1 to 60 do
			{
			_mina = createMine ["APERSMine",_pos,[],_size];
			if (_marcador in mrkNATO) then {malos revealMine _mina} else {muyMalos revealMine _mina};
			};
		};
	};

