private ["_marcador","_isfrontier","_posicion","_mrkENY"];

_marcador = _this select 0;
_isfrontier = false;
//_mrkENY = [];
//if (_marcador in mrkNATO) then {_mrkENY = aeropuertos + puestos - mrkNATO} else {_mrkENY = aeropuertos + puestos - mrkCSAT};
_mrkENY = if (_marcador in mrkNATO) then {mrkSDK + mrkCSAT - recursos - controles - fabricas - puestosFIA} else {mrkSDK + mrkNATO - recursos - controles - fabricas - puestosFIA};
if (count _mrkENY > 0) then
	{
	_posicion = getMarkerPos _marcador;
	{if (_posicion distance (getMarkerPos _x) < distanciaSPWN) exitWith {_isFrontier = true}} forEach _mrkENY;
	};
_isfrontier