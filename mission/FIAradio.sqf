private ["_chance","_pos","_marcador"];

_chance = 5;
{_pos = getPos _x;
_marcador = [puestos,_pos] call BIS_fnc_nearestPosition;
if ((_marcador in mrkSDK) and (alive _x)) then {_chance = _chance + 2.25};
} forEach antenas;

if (debug) then {_chance = 100};

if (random 100 < _chance) then
	{
	if (not revelar) then
		{
		[["TaskSucceeded", ["", "Enemy Comms Intercepted"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		revelar = true; publicVariable "revelar";
		[] remoteExec ["revealToPlayer"];
		};
	}
else
	{
	if (revelar) then
		{
		[["TaskFailed", ["", "Enemy Comms Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		revelar = false; publicVariable "revelar";
		};
	};