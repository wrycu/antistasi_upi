private ["_veh","_grupo","_marcador","_posicion","_heli","_engagepos","_orig","_landpos","_exitpos","_wp","_wp1","_wp2","_wp3","_wp4"];

_veh = _this select 0;
_grupo = _this select 1;
_marcador = _this select 2;
_origen = _this select 3;

_posicion = _marcador;
if (typeName _marcador == typeName "") then {_posicion = getMarkerPos _marcador};
_heli = group driver _veh;
{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _heli;
_dist = 500;
_orig = getMarkerPos _origen;


_engagepos = [];
_landpos = [];
_exitpos = [];

_randAng = random 360;

while {true} do
	{
 	_landpos = [_posicion, _dist, _randang] call BIS_Fnc_relPos;
 	if (!surfaceIsWater _landpos) exitWith {};
   _randAng = _randAng + 1;
	};

_randang = _randang + 90;

while {true} do
	{
 	_exitpos = [_posicion, 400, _randang] call BIS_Fnc_relPos;
 	_randang = _randang + 1;
 	if ((!surfaceIsWater _exitpos) and (_exitpos distance _posicion > 300)) exitWith {};
	};

_randang = [_landpos,_exitpos] call BIS_fnc_dirTo;
_randang = _randang - 180;

_engagepos = [_landpos, 1000, _randang] call BIS_Fnc_relPos;

{_x setBehaviour "CARELESS"} forEach units _heli;
_veh flyInHeight 300;
_veh setCollisionLight false;

_wp = _heli addWaypoint [_engagepos, 0];
_wp setWaypointType "MOVE";
//_wp setWaypointSpeed "LIMITED";

_wp1 = _heli addWaypoint [_landpos, 1];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "LIMITED";

_wp2 = _heli addWaypoint [_exitpos, 2];
_wp2 setWaypointType "MOVE";

_wp3 = _heli addWaypoint [_orig, 3];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "NORMAL";
_wp3 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];

waitUntil {sleep 1; (currentWaypoint _heli == 3) or (not alive _veh) or (!canMove _veh)};

//[_veh] call puertasLand;

if (alive _veh) then
	{
	_veh setCollisionLight true;
	{
   	unAssignVehicle _x;
   	_x allowDamage false;
   	moveOut _x;
   	sleep 0.35;
   	//_chute = createVehicle ["NonSteerable_Parachute_F", (getPos _x), [], 0, "NONE"];
   	//_chute setPos (getPos _x);
   	//_x moveinDriver _chute;
   	_x allowDamage true;
   	sleep 0.5;
  	} forEach units _grupo;
	};

_wp4 = _grupo addWaypoint [_posicion, 0];
_wp4 setWaypointType "MOVE";
_wp4 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
_wp4 = _grupo addWaypoint [_posicion, 0];
_wp4 setWaypointType "SAD";
//[_veh] call puertasLand;
