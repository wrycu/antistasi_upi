private ["_marcador","_mrkD"];

_marcador = _this select 0;


_mrkD = format ["Dum%1",_marcador];
if (markerColor _mrkD != "colorBLUFOR") then {_mrkD setMarkerColor "colorBLUFOR"};

if (_marcador in aeropuertos) then {_mrkD setMarkerText format ["FIA Airport: %1",count (garrison getVariable _marcador)];_mrkD setMarkerType "flag_FIA"} else {
if (_marcador in puestos) then {
_stringArray = format["%1", _marcador] splitString "_"; 
_str = _stringArray select 1; _mrkD setMarkerText format ["FIA Outpost %2: %1",count (garrison getVariable _marcador), _str]} else {
if (_marcador in bases) then {_stringArray = format["%1", _marcador] splitString "_"; _str = _stringArray select 1; _mrkD setMarkerText format ["FIA Base %2: %1",count (garrison getVariable _marcador), _str];_mrkD setMarkerType "flag_FIA"} else {
if (_marcador in recursos) then {_stringArray = format["%1", _marcador] splitString "_"; _str = _stringArray select 1; _mrkD setMarkerText format ["Resource %2: %1",count (garrison getVariable _marcador), _str]} else {
if (_marcador in fabricas) then {_stringArray = format["%1", _marcador] splitString "_"; _str = _stringArray select 1; _mrkD setMarkerText format ["Factory %2: %1",count (garrison getVariable _marcador), _str]} else {
if (_marcador in puertos) then {_stringArray = format["%1", _marcador] splitString "_"; _str = _stringArray select 1; _mrkD setMarkerText format ["Sea Port %2: %1",count (garrison getVariable _marcador), _str]} else {
if (_marcador in power) then {_stringArray = format["%1", _marcador] splitString "_"; _str = _stringArray select 1; _mrkD setMarkerText format ["Power Plant %2: %1",count (garrison getVariable _marcador), _str]};
		};};};};};};
