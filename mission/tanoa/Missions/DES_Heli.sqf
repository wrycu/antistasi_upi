if (!isServer and hasInterface) exitWith{};

private ["_poscrash","_marcador","_posicion","_mrkfin","_tipoveh","_efecto","_heli","_vehiculos","_soldados","_grupos","_unit","_roads","_road","_vehicle","_veh","_tipogrupo","_tsk","_humo","_emitterArray"];

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
_posHQ = getMarkerPos "respawn_guerrila";

_tiempolim = 120;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_ang = random 360;
_cuenta = 0;
_dist = if (_dificil) then {2000} else {3000};
while {true} do
	{
	_poscrashOrig = _posicion getPos [_dist,_ang];
	if ((!surfaceIsWater _poscrash) and (_poscrash distance _posHQ < 4000)) exitWith {};
	_ang = _ang + 1;
	_cuenta = _cuenta + 1;
	if (_cuenta > 360) then
		{
		_cuenta = 0;
		_dist = _dist - 500;
		};
	};

_tipoVeh = selectRandom (vehPlanes + vehAttackHelis + vehTransportAir);

_posCrashMrk = [_poscrash,random 500,random 360] call BIS_fnc_relPos;
_posCrash = _posCrashOrig findEmptyPosition [0,100,_tipoVeh];
if (count _posCrash == 0) then
	{
	if (!isMultiplayer) then {{ _x hideObject true } foreach (nearestTerrainObjects [_posCrashOrig,["tree","bush"],50])} else {{[_x,true] remoteExec ["hideObjectGlobal",2]} foreach (nearestTerrainObjects [_posCrashOrig,["tree","bush"],50])};
	_posCrash = _posCrashOrig;
	};
_mrkfin = createMarker [format ["DES%1", random 100], _posCrashMrk];
_mrkfin setMarkerShape "ICON";
//_mrkfin setMarkerType "hd_destroy";
//_mrkfin setMarkerColor "ColorRed";
//_mrkfin setMarkerText "Destroy Downed Chopper";

_nombrebase = [_marcador] call localizar;

_tsk = ["DES",[buenos,civilian],[format ["We have downed air vehicle. It is a good chance to destroy it before it is recovered. Do it before a recovery team from the %1 reaches the place. MOVE QUICKLY",_nombrebase],"Destroy Air",_mrkfin],_posCrashMrk,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_tsk1 = ["DES1",[_lado],[format ["The rebels managed to shot down a helicopter. A recovery team departing from the %1 is inbound to recover it. Cover them while they perform the whole operation",_nombrebase],"Helicopter Down",_mrkfin],_posCrash,"CREATED",5,true,true,"Defend"] call BIS_fnc_setTask;
_vehiculos = [];
_soldados = [];
_grupos = [];

_efecto = createVehicle ["CraterLong", _poscrash, [], 0, "CAN_COLLIDE"];
_heli = createVehicle [_tipoVeh, _poscrash, [], 0, "CAN_COLLIDE"];
_heli attachTo [_efecto,[0,0,1.5]];
_humo = "test_EmptyObjectForSmoke" createVehicle _poscrash; _humo attachTo[_heli,[0,1.5,-1]];
_heli setDamage 0.9;
_heli lock 2;
_vehiculos = _vehiculos + [_heli,_efecto];
/*
_grpcrash = createGroup _lado;
_grupos pushBack _grpcrash;

_unit = _grpcrash createUnit ["I_Pilot_F", _poscrash, [], 0, "NONE"];
_unit setDamage 1;
_unit moveInDriver _heli;
_soldados pushBack _unit;
*/
_tam = 100;

while {true} do
	{
	_roads = _posicion nearRoads _tam;
	if (count _roads > 0) exitWith {};
	_tam = _tam + 50;
	};

_road = _roads select 0;
_tipoVeh = if (_lado == malos) then {selectRandom vehNATOLightUnarmed} else {selectRandom vehCSATLightUnarmed};
_vehicle=[position _road, 0,_tipoVeh, _lado] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
[_veh] call AIVEHinit;
[_veh,"Escort"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] call NATOinit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos pushBack _grupoVeh;
_vehiculos pushBack _veh;

sleep 1;
_tipogrupo = if (_lado == malos) then {gruposNATOSentry} else {gruposCSATSentry};
_cfg = if (_lado == malos) then {cfgNATOInf} else {cfgCSATInf};
_grupo = [_posicion, _lado, _cfg >> _tipogrupo] call BIS_Fnc_spawnGroup;

{_x assignAsCargo _veh; _x moveInCargo _veh; _soldados pushBack _x; [_x] join _grupoveh; [_x] call NATOinit} forEach units _grupo;
deleteGroup _grupo;
//[_veh] spawn smokeCover;

_Vwp0 = _grupoVeh addWaypoint [_poscrash, 0];
_Vwp0 setWaypointType "TR UNLOAD";
_Vwp0 setWaypointBehaviour "SAFE";
_Gwp0 = _grupo addWaypoint [_poscrash, 0];
_Gwp0 setWaypointType "GETOUT";
_Vwp0 synchronizeWaypoint [_Gwp0];

sleep 15;
_tipoVeh = if (_lado == malos) then {vehNATOTrucks select 0} else {vehCSATTrucks select 0};
_vehicleT=[position _road, 0,_tipoVeh, _lado] call bis_fnc_spawnvehicle;
_vehT = _vehicleT select 0;
[_vehT] call AIVEHinit;
[_vehT,"Recover Truck"] spawn inmuneConvoy;
_vehCrewT = _vehicle select 1;
{[_x] call NATOinit} forEach _vehCrewT;
_grupoVehT = _vehicleT select 2;
_soldados = _soldados + _vehCrewT;
_grupos pushBack _grupoVehT;
_vehiculos pushBack _vehT;

_Vwp0 = _grupoVehT addWaypoint [_poscrash, 0];
_Vwp0 setWaypointType "MOVE";
_Vwp0 setWaypointBehaviour "SAFE";
waitUntil {sleep 1; (not alive _heli) or (_vehT distance _heli < 50) or (dateToNumber date > _fechalimnum)};

if (_vehT distance _heli < 50) then
	{
	_vehT doMove position _heli;
	sleep 60;
	if (alive _heli) then
		{
		_heli attachTo [_vehT,[0,-3,2]];
		_emitterArray = _humo getVariable "effects";
		{deleteVehicle _x} forEach _emitterArray;
		deleteVehicle _humo;
		};

	_Vwp0 = _grupoVehT addWaypoint [_posicion, 1];
	_Vwp0 setWaypointType "MOVE";
	_Vwp0 setWaypointBehaviour "SAFE";

	_Vwp0 = _grupoVeh addWaypoint [_poscrash, 0];
	_Vwp0 setWaypointType "LOAD";
	_Vwp0 setWaypointBehaviour "SAFE";
	_Gwp0 = _grupo addWaypoint [_poscrash, 0];
	_Gwp0 setWaypointType "GETIN";
	_Vwp0 synchronizeWaypoint [_Gwp0];

	_Vwp0 = _grupoVeh addWaypoint [_posicion, 2];
	_Vwp0 setWaypointType "MOVE";
	_Vwp0 setWaypointBehaviour "SAFE";

	};

waitUntil {sleep 1; (not alive _heli) or (_vehT distance _posicion < 100) or (dateToNumber date > _fechalimnum)};

_bonus = if (_dificil) then {2} else {1};

if (not alive _heli) then
	{
	_tsk = ["DES",[buenos,civilian],[format ["We have downed air vehicle. It is a good chance to destroy it before it is recovered. Do it before a recovery team from the %1 reaches the place. MOVE QUICKLY",_nombrebase],"Destroy Air",_mrkfin],_posCrashMrk,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[0,300*_bonus] remoteExec ["resourcesFIA",2];
	if (typeOf _heli in vehCSATAir) then {[0,3] remoteExec ["prestige",2]} else {[3,0] remoteExec ["prestige",2]};
	//[-3,3,_posicion] remoteExec ["citySupportChange",2];
	[1800*_bonus] remoteExec ["timingCA",2];
	{if (_x distance _heli < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
	[5*_bonus,stavros] call playerScoreAdd;
	_tsk1 = ["DES1",[_lado],[format ["The rebels managed to shot down a helicopter. A recovery team departing from the %1 is inbound to recover it. Cover them while they perform the whole operation",_nombrebase],"Helicopter Down",_mrkfin],_posCrash,"FAILED",5,true,true,"Defend"] call BIS_fnc_setTask;
	}
else
	{
	_tsk = ["DES",[buenos,civilian],[format ["We have downed air vehicle. It is a good chance to destroy it before it is recovered. Do it before a recovery team from the %1 reaches the place. MOVE QUICKLY",_nombrebase],"Destroy Air",_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	_tsk1 = ["DES1",[_lado],[format ["The rebels managed to shot down a helicopter. A recovery team departing from the %1 is inbound to recover it. Cover them while they perform the whole operation",_nombrebase],"Helicopter Down",_mrkfin],_posCrash,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
	//[3,0,_posicion] remoteExec ["citySupportChange",2];
	[-600*_bonus] remoteExec ["timingCA",2];
	[-10*_bonus,stavros] call playerScoreAdd;
	};

if (!isNull _humo) then
	{
	_emitterArray = _humo getVariable "effects";
	{deleteVehicle _x} forEach _emitterArray;
	deleteVehicle _humo;
	};

_nul = [1200,_tsk] spawn borrarTask;
_nul = [0,_tsk1] spawn borrarTask;
deleteMarker _mrkfin;
{
waitUntil {sleep 1;(!([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits))};
deleteVehicle _x} forEach _vehiculos;
{deleteVehicle _x} forEach _soldados;
{deleteGroup _x} forEach _grupos;

//sleep (600 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;




