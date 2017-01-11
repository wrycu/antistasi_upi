_marcador = _this select 0;
_pos = getMarkerPos _marcador;
_forzado = false;
if (_marcador in forcedSpawn) then {forcedSpawn = forcedSpawn - [_marcador]; publicVariable "forcedSpawn"; _forzado = true};
_marcador setMarkerPos [0,0,0];
waitUntil {sleep 1; not(spawner getVariable _marcador)};
waitUntil {sleep 2; {_x getVariable [_marcador,false]} count allUnits == 0};
_marcador setMarkerPos _pos;
if (_forzado) then {forcedSpawn pushBackUnique _marcador; publicVariable "forcedSpawn"};