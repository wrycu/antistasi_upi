if (!isServer and hasInterface) exitWith {};

private ["_marcador","_esMarcador","_exit","_radio","_base","_aeropuerto","_posDestino","_soldados","_vehiculos","_grupos","_roads","_posorigen","_tam","_tipoVeh","_vehicle","_veh","_vehCrew","_grupoVeh","_landPos","_tipoGrupo","_grupo","_soldado","_threatEval","_pos","_timeOut"];

_marcador = _this select 0;
_aeropuerto = _this select 1;
_inWaves = false;
_lado = malos;
_posOrigen = [];

if (_aeropuerto isEqualType "") then
	{
	_inWaves = true;
	_lado = if (_aeropuerto in mrkCSAT) then {muyMalos};
	_posOrigen = getMarkerPos _marcador;
	};

if ((!_inWaves) and (diag_fps < minimoFPS)) exitWith {};

_esMarcador = false;
_exit = false;
if (_marcador isEqualType "") then
	{
	_esMarcador = true;
	if (!_inWaves) then {if (_marcador in smallCAmrk) then {_exit = true}};
	}
else
	{
	_cercano = [smallCApos,_marcador] call BIS_fnc_nearestPosition;
	if (_cercano distance _marcador < (distanciaSPWN/2)) then
		{
		_exit = true;
		}
	else
		{
		if (count smallCAmrk > 0) then
			{
			_cercano = [smallCAmrk,_marcador] call BIS_fnc_nearestPosition;
			if (getMarkerPos _cercano distance _marcador < (distanciaSPWN/2)) then {_exit = true};
			};
		};
	};

if (_exit) exitWith {};

_posDestino = _marcador;
if (_esMarcador) then
	{
	_posDestino = getMarkerPos _marcador;
	};

if (!_inWaves) then
	{
	_lado = _aeropuerto;
	_aeropuertos = if (_lado == malos) then {aeropuertos - mrkSDK - mrkCSAT} else {aeropuertos - mrkSDK - mrkNATO};
	_aeropuertos = _aeropuertos select 	{(getMarkerPos _x distance _posDestino < 15000) and (not(spawner getVariable [_x,false])) and (dateToNumber date > server getVariable _x)};
	if (count _aeropuertos == 0) then
		{
		_exit = true;
		}
	else
		{
		_aeropuerto = [_aeropuertos,_posDestino] call BIS_fnc_nearestPosition;
		_posOrigen = getMarkerPos _aeropuerto;
		};
	};

if (_exit) exitWith {};

_base = if ((_posOrigen distance _posDestino < 5000) and ([_posDestino,_posOrigen] call isTheSameIsland)) then {_aeropuerto} else {""};

if (_base == "") then
	{
	_threatEval = [_posDestino] call AAthreatEval;
	if (_threatEval > 15) then
		{
		_exit = true;
		};
	};

if (_exit) exitWith {};

if ((_base == "") or (!_esMarcador)) then
	{
	_plane = if (_lado == malos) then {vehNATOPlane} else {vehCSATPlane};
	if ([_plane] call vehAvailable) then
		{
		_amigos = if (_lado == malos) then {allUnits select {(_x distance _posDestino < 300) and (alive _x) and ((side _x == malos) or (side _x == civilian))}} else {(_x distance _posDestino < 300) and (alive _x) and (side _x == muyMalos)};
		if (count _amigos == 0) then
			{
			_enemigos = if (_lado == malos) then {allUnits select {_x distance _posDestino < 300 and (side _x != _lado) and (side _x != civilian) and (alive _x)}} else {allUnits select {_x distance _posicion < 300 and (side _x != _lado) and (alive _x)}};
			_tipo = "NAPALM";
			{
			if (vehicle _x isKindOf "Tank") then
				{
				_tipo = "HE"
				}
			else
				{
				if (vehicle _x != _x) then {_tipo = "CLUSTER"};
				};
			if (_tipo == "HE") exitWith {};
			} forEach _enemigos;
			_exit = true;
			smallCApos pushBack _marcador;
			[_posDestino,_lado,_tipo] spawn airStrike;
			if (debug) then {hint format ["Bombardeo de %1 en %2 por los %3",_tipo,_posDestino,_lado]};
			sleep 120;
			smallCApos = smallCApos - [_marcador];
			};
		};
	};

if (_exit) exitWith {};

if (_base != "") then
	{
	_threatEval = [_posDestino] call landThreatEval;
	if (_threatEval > 15) then
		{
		_base = "";
		}
	};
_esSDK = false;
if (_esMarcador) then
	{
	smallCAmrk pushBackUnique _marcador; publicVariable "smallCAmrk";
	if (_marcador in mrkSDK) then
		{
		_esSDK = true;
		_nombreDest = [_marcador] call localizar;
		if (!_inWaves) then {["IntelAdded", ["", format ["QRF sent to %1",_nombreDest]]] remoteExec ["BIS_fnc_showNotification",_lado]};
		}
	else
		{
		forcedSpawn pushBackUnique _marcador; publicVariable "forcedSpawn";
		};
	}
else
	{
	smallCApos pushBack _marcador;
	};

if (debug) then {hint format ["Nos contraatacan desde %1 o desde el aeropuerto %2 hacia %3", _base, _aeropuerto,_marcador]; sleep 5};

_config = if (_lado == malos) then {cfgNATOInf} else {cfgCSATInf};

_soldados = [];
_vehiculos = [];
_grupos = [];
_roads = [];

if (_base != "") then
	{
	_aeropuerto = "";

	if (!_inWaves) then {[_base,10] call addTimeForIdle};
	_indice = aeropuertos find _base;
	_spawnPoint = spawnPoints select _indice;
	_pos = getMarkerPos _spawnPoint;
	/*
	_roads = [];
	_tam = [_base] call sizeMarker;
	while {true} do
		{
		_roads = _posOrigen nearRoads _tam;
		if (count _roads > 0) exitWith {};
		};
	*/
	_vehPool = if (_lado == malos) then {vehNATOAttack} else {vehCSATAttack};
	if (_esMarcador) then
		{
		_rnd = random 100;
		if (_lado == malos) then
			{
			if (_rnd > prestigeNATO) then
				{
				_vehPool = _vehPool - [vehNATOTank];
				};
			}
		else
			{
			if (_rnd > prestigeCSAT) then
				{
				_vehPool = _vehPool - [vehCSATTank];
				};
			};
		};
	if (count _vehPool == 0) then {if (_lado == malos) then {_vehPool = vehNATOTrucks} else {_vehPool = vehCSATTrucks}};
	_tipoVeh = selectRandom _vehPool;
	if (not([_tipoVeh] call vehAvailable)) then
		{
		_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTrucks} else {selectRandom vehCSATTrucks};
		_vehPool = _vehPool - [_tipoVeh];
		if (count _vehPool == 0) then {if (_lado == malos) then {_vehPool = vehNATOTrucks} else {_vehPool = vehCSATTrucks}};
		};
	//_road = _roads select 0;
	_timeOut = 0;
	_pos = _pos findEmptyPosition [0,100,_tipoveh];
	while {_timeOut < 60} do
		{
		if (count _pos > 0) exitWith {};
		_timeOut = _timeOut + 1;
		_pos = _pos findEmptyPosition [0,100,_tipoveh];
		sleep 1;
		};
	if (count _pos == 0) then {_pos = getMarkerPos _spawnPoint};
	_vehicle=[_pos, markerDir _spawnPoint,_tipoveh, _lado] call bis_fnc_spawnvehicle;
	_veh = _vehicle select 0;
	_vehCrew = _vehicle select 1;
	{[_x] call NATOinit} forEach _vehCrew;
	[_veh] call AIVEHinit;
	_grupoVeh = _vehicle select 2;
	_soldados = _soldados + _vehCrew;
	_grupos pushBack _grupoVeh;
	_vehiculos pushBack _veh;
	_landPos = [];
	_landPos = [_posdestino,_pos,_threatEval] call findSafeRoadToUnload;
	if (not(_tipoVeh in vehTanks)) then
		{
		_tipogrupo = [_tipoVeh,_lado] call cargoSeats;
		_grupo = [_posorigen,_lado,_config >> _tipogrupo] call BIS_Fnc_spawnGroup;
		{[_x] call NATOinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x} forEach units _grupo;
		if (not(_tipoVeh in vehTrucks)) then
			{
			_grupos pushBack _grupo;
			if ((_base == "airport") or (_base == "airport_2")) then {[_base,_landPos,_grupoVeh] call WPCreate};
			_Vwp0 = (wayPoints _grupoVeh) select 0;
			_Vwp0 setWaypointBehaviour "SAFE";
			_Vwp0 = _grupoVeh addWaypoint [_landPos,count (wayPoints _grupoVeh)];
			_Vwp0 setWaypointType "TR UNLOAD";
			//_Vwp0 setWaypointStatements ["true", "[vehicle this] call smokeCoverAuto"];
			_Vwp1 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
			_Vwp1 setWaypointType "SAD";
			_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
			_Vwp1 setWaypointBehaviour "COMBAT";
			_Vwp2 = _grupo addWaypoint [_landPos, 0];
			_Vwp2 setWaypointType "GETOUT";
			_Vwp0 synchronizeWaypoint [_Vwp2];
			_Vwp3 = _grupo addWaypoint [_posDestino, 1];
			_Vwp3 setWaypointType "MOVE";
			_Vwp3 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
			_Vwp3 = _grupo addWaypoint [_posDestino, 1];
			_Vwp3 setWaypointType "SAD";
			[_veh,"APC"] spawn inmuneConvoy;
			_veh allowCrewInImmobile true;
			}
		else
			{
			{[_x] join _grupoVeh} forEach units _grupo;
			deleteGroup _grupo;
			_tipoSoldado = if (_lado == malos) then {NATOGrunt} else {CSATGrunt};
			for "_i" from 1 to 8 do
				{
				_soldado = _grupoVeh createUnit [_tipoSoldado, _posorigen, [],0, "NONE"];
				[_soldado] call NATOinit;
				_soldado assignAsCargo _veh;
				_soldado moveInCargo _veh;
				_soldados pushBack _soldado;
				};
			_grupoVeh selectLeader (units _grupoVeh select 1);
			if ((_base == "airport") or (_base == "airport_2")) then {[_base,_landPos,_grupoVeh] call WPCreate};
			_Vwp0 = (wayPoints _grupoVeh) select 0;
			_Vwp0 setWaypointBehaviour "SAFE";
			_Vwp0 = _grupoVeh addWaypoint [_landPos, count (wayPoints _grupoVeh)];
			_Vwp0 setWaypointType "GETOUT";
			_Vwp1 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
			if (_esMarcador) then
				{
				if ((count (garrison getVariable _marcador)) < 4) then
					{
					_Vwp1 setWaypointType "MOVE";
					_Vwp1 setWaypointBehaviour "AWARE";
					}
				else
					{
					_Vwp1 setWaypointType "SAD";
					_Vwp1 setWaypointBehaviour "COMBAT";
					};
				}
			else
				{
				_Vwp1 setWaypointType "SAD";
				_Vwp1 setWaypointBehaviour "COMBAT";
				};
			[_veh,"Inf Truck."] spawn inmuneConvoy;
			};
		}
	else
		{
		if ((_base == "airport") or (_base == "airport_2")) then {[_base,_posDestino,_grupoVeh] call WPCreate};
		_Vwp0 = (wayPoints _grupoVeh) select 0;
		_Vwp0 setWaypointBehaviour "SAFE";
		_Vwp0 = _grupoVeh addWaypoint [_posDestino, count (waypoints _grupoVeh)];
		[_veh,"Tank"] spawn inmuneConvoy;
		_Vwp0 setWaypointType "SAD";
		_Vwp0 setWaypointBehaviour "AWARE";
		_veh allowCrewInImmobile true;
		};
	};
if (_aeropuerto != "") then
	{
	if (!_inWaves) then {[_aeropuerto,10] call addTimeForIdle};
	_vehPool = [];
	_cuenta = 1;
	_tipoVeh = "";
	if (_esMarcador) then {_cuenta = 2};
	for "_i" from 1 to _cuenta do
		{
		if (_i < _cuenta) then
			{
			if (_threatEval <= 5) then
				{
				_vehPool = if (_lado == malos) then {vehNATOAir} else {vehCSATAir}
				}
			else
				{
				if (_threatEval > 10) then
					{
					_tipoVeh = if (_lado == malos) then {vehNATOPlane} else {vehCSATPlane}
					}
				else
					{
					if (_threatEval > 5) then
						{
						_vehPool = if (_lado == malos) then {vehNATOAttackHelis + [vehNATOPlane]} else {vehCSATAttackHelis + [vehCSATPlane]};
						};
					};
				};
			if (count _vehPool > 0) then {_tipoveh = selectRandom _vehPool} else {_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTransportHelis} else {selectRandom vehNATOTransportHelis}};
			}
		else
			{
			if (_lado == malos) then {selectRandom vehNATOTransportHelis} else {selectRandom vehNATOTransportHelis}
			};
		_timeOut = 0;
		_pos = _posorigen findEmptyPosition [0,100,_tipoveh];
		while {_timeOut < 60} do
			{
			if (count _pos > 0) exitWith {};
			_timeOut = _timeOut + 1;
			_pos = _posorigen findEmptyPosition [0,100,_tipoveh];
			sleep 1;
			};
		if (count _pos == 0) then {_pos = _posorigen};
		_vehicle=[_pos, random 360,_tipoVeh, malos] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		_grupoVeh = _vehicle select 2;
		_soldados = _soldados + _vehCrew;
		_grupos pushBack _grupoVeh;
		_vehiculos pushBack _veh;
		{[_x] call NATOinit} forEach units _grupoVeh;
		[_veh] call AIVEHinit;
		if (not (_tipoVeh in vehTransportAir)) then
			{
			_Hwp0 = _grupoVeh addWaypoint [_posdestino, 0];
			_Hwp0 setWaypointBehaviour "AWARE";
			_Hwp0 setWaypointType "SAD";
			[_veh,"Air Attack"] spawn inmuneConvoy;
			}
		else
			{
			_tipogrupo = [_tipoVeh,_lado] call cargoSeats;
			_grupo = [_posorigen,_lado, _config >> _tipogrupo] call BIS_Fnc_spawnGroup;
			{[_x] call NATOinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x} forEach units _grupo;
			_grupos pushBack _grupo;
			_landpos = [];
			_proceder = false;
			if (_esMarcador) then
				{
				if (_marcador in aeropuertos) then
					{
					_proceder = false;
					[_veh,_grupo,_marcador,_aeropuerto] spawn airdrop;
					}
				else
					{
					if (_esSDK) then
						{
						if (((count(garrison getVariable _marcador)) < 10) and (_tipoVeh in vehFastRope)) then
							{
							_proceder = false;
							[_veh,_grupo,_posDestino,_posOrigen,_grupoVeh] spawn fastrope;
							};
						};
					};
				};
			if (_proceder) then
				{
				_pos = _posDestino getPos [(random 500) + 300, random 360];
				_landPos = _pos findEmptyPosition [0,100,_tipoveh];
				if (count _landPos > 0) then
					{
					_isFlatEmpty = !(_landPos isFlatEmpty  [1, -1, 0.1, 15, -1, false, objNull] isEqualTo []);
					if (!_isFlatEmpty) then
						{
						_landPos = [];
						};
					};
				if (count _landPos > 0) then
					{
					_landPos set [2, 0];
					_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
					_vehiculos pushBack _pad;
					_wp0 = _grupoVeh addWaypoint [_landpos, 0];
					_wp0 setWaypointType "TR UNLOAD";
					_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';[vehicle this] call smokeCoverAuto"];
					_wp0 setWaypointBehaviour "CARELESS";
					_wp3 = _grupo addWaypoint [_landpos, 0];
					_wp3 setWaypointType "GETOUT";
					_wp0 synchronizeWaypoint [_wp3];
					_wp4 = _grupo addWaypoint [_posDestino, 1];
					_wp4 setWaypointType "MOVE";
					_wp4 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
					_wp4 = _grupo addWaypoint [_posDestino, 1];
					_wp4 setWaypointType "SAD";
					_wp2 = _grupoVeh addWaypoint [_posOrigen, 1];
					_wp2 setWaypointType "MOVE";
					_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
					[_grupoVeh,1] setWaypointBehaviour "AWARE";
					}
				else
					{
					if (_tipoVeh in vehFastRope) then
						{
						[_veh,_grupo,_pos,_posOrigen,_grupoVeh] spawn fastrope;
						}
					else
						{
						{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _grupo;
						[_veh,_grupo,_marcador,_aeropuerto] spawn airdrop;
						};
					};
				};
			};
		sleep 30;
		};
	};

if (_esMarcador) then
	{
	_tiempo = time + 3600;
	_solMax = round ((count _soldados)/3);
	_size = [_marcador] call sizeMarker;
	if (_lado == malos) then
		{
		waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < _solMax) or (time > _tiempo) or (_marcador in mrkNATO) or (({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits))};
		if  ((({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits)) and (not(_marcador in mrkNATO))) then
			{
			["BLUFORSpawn",_marcador] remoteExec ["markerChange",2];
			};
		sleep 10;
		if (!(_marcador in mrkNATO)) then {{_x doMove _posorigen} forEach _soldados}
		}
	else
		{
		waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < _solMax) or (time > _tiempo) or (_marcador in mrkCSAT) or (({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits))};
		if  ((({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits)) and (not(_marcador in mrkCSAT))) then
			{
			["OPFORSpawn",_marcador] remoteExec ["markerChange",2];
			};
		sleep 10;
		if (!(_marcador in mrkCSAT)) then {{_x doMove _posorigen} forEach _soldados}
	};

	smallCAmrk = smallCAmrk - [_marcador]; publicVariable "smallCAmrk";

	waitUntil {sleep 1; not (spawner getVariable _marcador)};
	}
else
	{
	_ladoENY = if (_lado == malos) then {"OPFORSpawn"} else {"BLUFORSpawn"};
	waitUntil {sleep 1; (!([distanciaSPWN,1,_posDestino,"GREENFORSpawn"] call distanceUnits) and !([distanciaSPWN,1,_posDestino,_ladoENY] call distanceUnits))};
	smallCApos = smallCApos - [_marcador];
	};

if (_marcador in forcedSpawn) then {forcedSpawn = forcedSpawn - [_marcador]; publicVariable "forcedSpawn"};

{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)) then {deleteVehicle _x};
} forEach _vehiculos;
{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)) then {deleteVehicle _x; _soldados = _soldados - [_x]};
} forEach _soldados;

if (count _soldados > 0) then
	{
	{
	_veh = _x;
	waitUntil {sleep 1; !([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)};
	deleteVehicle _veh;
	} forEach _soldados;
	};

{deleteGroup _x} forEach _grupos;
