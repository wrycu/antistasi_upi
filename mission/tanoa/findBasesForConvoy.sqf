private ["_marcador","_pos","_aeropuertosAAF","_aeropuertos","_base","_posbase","_busy"];

_marcador = _this select 0;
_pos = getMarkerPos _marcador;
_aeropuertosAAF = aeropuertos - mrkSDK;
_aeropuertos = [];
_base = "";
{
_base = _x;
_posbase = getMarkerPos _base;
_busy = if (dateToNumber date > server getVariable _base) then {false} else {true};
if ((_pos distance _posbase < 5000) and (_pos distance _posbase > 500) and (not (spawner getVariable _base)) and (not _busy) and ([_base,_marcador] call isTheSameIsland) and (!(_base in forcedSpawn))) then {_aeropuertos pushBack _base}
} forEach _aeropuertosAAF;
if (count _aeropuertos > 0) then {_base = [_aeropuertos,_pos] call BIS_fnc_nearestPosition} else {_base = ""};
_base