private ["_esMarcador","_sitio","_time","_fechaNum","_fechaArr"];
_sitio = _this select 0;
_time = _this select 1;
_esMarcador = false;
if (_sitio isEqualType "") then {_esMarcador = true};
_fechaNum = if (_esMarcador) then {server getVariable [_sitio,0]} else {timer getVariable [(typeOf _sitio),0]};
if (_fechaNum < dateToNumber date) then {_fechaNum = dateToNumber date};

_fechaArr = numberToDate [2035,_fechaNum];

_fechaArr = [_fechaArr select 0, _fechaArr select 1, _fechaArr select 2, _fechaArr select 3, (_fechaArr select 4) + _time];

if (_esMarcador) then {server setVariable [_sitio,dateToNumber _fechaArr,true]} else {timer setVariable [(typeOf _sitio),dateToNumber _fechaArr,true]};

