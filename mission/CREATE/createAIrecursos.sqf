if (!isServer and hasInterface) exitWith{};

private ["_marcador","_vehiculos","_grupos","_soldados","_civs","_posicion","_pos","_tipogrupo","_tipociv","_size","_mrk","_ang","_cuenta","_grupo","_veh","_civ","_frontera","_tam","_bandera","_perro","_garrison","_lado","_cfg","_esFIA","_roads","_dist","_road","_roadscon","_roadcon","_dirveh","_cuentaTotal","_solMax","_bunker","_tipoVeh","_tipoUnit","_unit","_tipoGrupo","_stance"];

_marcador = _this select 0;

_posicion = getMarkerPos _marcador;

_size = [_marcador] call sizeMarker;

_civs = [];
_soldados = [];
_grupos = [];
_vehiculos = [];

_frontera = [_marcador] call isFrontline;
_garrison = garrison getVariable _marcador;
_lado = muyMalos;
_cfg = cfgCSATInf;
_esFIA = false;
if (_marcador in mrkNATO) then
	{
	_lado = malos;
	if (random 100 < prestigeNATO) then
		{
		_cfg = cfgNATOInf;
		}
	else
		{
		_esFIA = true;
		_cfg = cfgFIAInf;
		};
	};
_tam = if (_lado == malos) then {round (_size/50)} else {round (_size/30)};
if (_tam == 0) then {_tam = 1};
_roads = _posicion nearRoads _size;
_dist = 0;
_road = objNull;
{if ((position _x) distance _posicion > _dist) then {_road = _x;_dist = position _x distance _posicion}} forEach _roads;
_roadscon = roadsConnectedto _road;
_roadcon = objNull;
{if ((position _x) distance _posicion > _dist) then {_roadcon = _x}} forEach _roadscon;
_dirveh = [_roadcon, _road] call BIS_fnc_DirTo;

_cuentaTotal = 0;
_solMax = 8+(4*_tam);
if (_frontera) then
	{
	_solMax = _solMax + (4*_tam);
	if (count _roads != 0) then
		{
		_solMax = _solMax + 1;
		};
	};
_solMax = _solMax - _garrison;

if ((spawner getVariable _marcador) and _frontera and (_cuentaTotal + 1 <= _solMax)) then
	{
	if (count _roads != 0) then
		{
		if (!_esFIA) then
			{
			_grupo = createGroup _lado;
			_grupos pushBack _grupo;
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
			}
		else
			{
			_veh = vehFIAArmedCar createVehicle getPos _road;
			_veh setDir _dirveh + 90;
			_nul = [_veh] call AIVEHinit;
			_vehiculos pushBack _veh;
			sleep 1;
			_tipoGrupo = selectRandom gruposFIAMid;
			_grupo = [_posicion, _lado, cfgFIAInf >> _tipoGrupo] call BIS_Fnc_spawnGroup;
			_unit = _grupo createUnit [FIARifleman, _posicion, [], 0, "NONE"];
			_unit moveInGunner _veh;
			{_soldados pushBack _x; [_x,_marcador] call NATOinit} forEach units _grupo;
			};
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

while {(spawner getVariable _marcador) and (_cuenta < 4) and (_cuentaTotal + 2 <= _solMax)} do
	{
	_tipoGrupo = if (_lado == malos) then
		{
		if (!_esFIA) then {selectRandom gruposNATOsmall} else {selectRandom gruposFIASmall};
		}
	else
		{
		selectRandom gruposCSATsmall
		};
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
		_perro = _grupo createUnit ["Fin_random_F",_posicion,[],0,"FORM"];
		[_perro] spawn guardDog;
		sleep 1;
		};
	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "RANDOM","NOVEH2"] execVM "scripts\UPSMON.sqf";
	_grupos pushBack _grupo;
	{[_x,_marcador] call NATOinit; _soldados pushBack _x} forEach units _grupo;
	_cuenta = _cuenta +1;
	_cuentaTotal = _cuentaTotal + 2;
	};

_tipoVeh = if (_lado == malos) then {NATOFlag} else {CSATFlag};
_bandera = createVehicle [_tipoVeh, _posicion, [],0, "CAN_COLLIDE"];
_bandera allowDamage false;
[_bandera,"take"] remoteExec ["flagaction",[buenos,civilian],_bandera];
_vehiculos pushBack _bandera;

if (not(_marcador in destroyedCities)) then
	{
	if ((daytime > 8) and (daytime < 18)) then
		{
		_grupo = createGroup civilian;
		_grupos pushBack _grupo;
		for "_i" from 1 to 4 do
			{
			if (spawner getVariable _marcador) then
				{
				_civ = _grupo createUnit ["C_man_w_worker_F", _posicion, [],0, "NONE"];
				_nul = [_civ] spawn CIVinit;
				_civs pushBack _civ;
				_civ setVariable ["marcador",_marcador];
				sleep 0.5;
				_civ addEventHandler ["Killed",
					{
					if (({alive _x} count units group (_this select 0)) == 0) then
						{
						_marcador = (_this select 0) getVariable "marcador";
						_nombre = [_marcador] call localizar;
						destroyedCities pushBackUnique _marcador;
						publicVariable "destroyedCities";
						["TaskFailed", ["", format ["%1 Destroyed",_nombre]]] remoteExec ["BIS_fnc_showNotification",[buenos,civilian]];
						};
					}];
				};
			};
		//_nul = [_marcador,_civs] spawn destroyCheck;
		_nul = [leader _grupo, _marcador, "SAFE", "SPAWNED","NOFOLLOW", "NOSHARE","DORELAX","NOVEH2"] execVM "scripts\UPSMON.sqf";
		};
	};

_pos = _posicion findEmptyPosition [5,_size,"I_Truck_02_covered_F"];//donde pone 5 antes ponía 10
if (count _pos > 0) then
	{
	_tipoVeh = if (_lado == malos) then
		{
		if (!_esFIA) then {vehNATOTrucks} else {[vehFIATruck]};
		}
	else
		{
		vehCSATTrucks
		};
	_veh = createVehicle [selectRandom _tipoVeh, _pos, [], 0, "NONE"];
	_veh setDir random 360;
	_vehiculos pushBack _veh;
	_nul = [_veh] call AIVEHinit;
	sleep 1;
	};

_pos = [];
_tipoGrupo = "";
_cuenta = 0;

if (_frontera) then {_tam = _tam * 2};
while {(spawner getVariable _marcador) and (_cuenta < _tam) and (_cuentaTotal + 4 <= _solMax)} do
	{
	if ((diag_fps > minimoFPS) or (_cuenta == 0)) then
		{
		_tipoGrupo = if (_lado == malos) then
			{
			if (!_esFIA) then {selectRandom gruposNATOMid} else {selectRandom gruposFIAMid};
			}
		else
			{
			selectRandom gruposCSATMid;
			};
		_grupo = [_posicion,_lado, _cfg >> _tipogrupo] call BIS_Fnc_spawnGroup;
		sleep 1;
		_stance = "RANDOM";
		if (_cuenta == 0) then
			{
			_stance = "RANDOMUP"
			};
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED",_stance,"NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		_grupos pushBack _grupo;
		{[_x] call NATOinit; _soldados pushBack _x} forEach units _grupo;
		};
	_cuenta = _cuenta + 1;
	_cuentaTotal = _cuentaTotal + 4;
	};
/*
_periodista = objNull;
if ((random 100 < (((prestigeNATO) + (prestigeCSAT))/10)) and (spawner getVariable _marcador)) then
	{
	_pos = [];
	_grupo = createGroup civilian;
	while {true} do
		{
		_pos = [_posicion, round (random _size), random 360] call BIS_Fnc_relPos;
		if (!surfaceIsWater _pos) exitWith {};
		};
	_periodista = _grupo createUnit ["C_journalist_F", _pos, [],0, "NONE"];
	_nul = [_periodista] spawn CIVinit;
	_grupos pushBack _grupo;
	_nul = [_periodista, _marcador, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";
	};

waitUntil {sleep 1; (not (spawner getVariable _marcador)) or (({(not(vehicle _x isKindOf "Air"))} count ([_size,0,_posicion,"GREENFORSpawn"] call distanceUnits)) > 3*({(alive _x) and (!(captive _x)) and (_x distance _posicion < _size)} count _soldados))};
if ((spawner getVariable _marcador) and (not(_marcador in mrkSDK))) then
	{
	[_bandera] remoteExec ["mrkWIN",2];
	};
*/

/*
for "_i" from 1 to _garrison do
	{
	_unit = selectRandom _soldados;
	if (!(isNil "_unit")) then
		{
		if (vehicle _unit == _unit) then
			{
			_soldados = _soldados - [_unit];
			deleteVehicle _unit;
			};
		};
	};

*/
waitUntil {sleep 1; not (spawner getVariable _marcador)};

deleteMarker _mrk;
{
if (alive _x) then
	{
	deleteVehicle _x
	};
} forEach _soldados;
//if (!isNull _periodista) then {deleteVehicle _periodista};
{deleteGroup _x} forEach _grupos;
{deleteVehicle _x} forEach _civs;
{if (!([distanciaSPWN-_size,1,_x,"GREENFORSpawn"] call distanceUnits)) then {deleteVehicle _x}} forEach _vehiculos;
