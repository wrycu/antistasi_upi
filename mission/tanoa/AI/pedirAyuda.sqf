private ["_unit","_distancia","_hayMedico","_medico","_units","_ayudando","_pidiendoAyuda"];
_unit = _this select 0;
_ayudado = _unit getVariable "ayudado";
if (!isNil "_ayudado") exitWith {};

_distancia = 81;
_medico = objNull;
//if (count _this == 1) then {_units = units group _unit} else {_units = units (_this select 1)};
_units = units group _unit;
{
if (!isPlayer _x) then
	{
	if (typeOf _x in SDKMedic) then
		{
		if ((alive _x) and ("FirstAidKit" in (items _x)) and (not (_x getVariable "inconsciente")) and (vehicle _x == _x) and (_x distance _unit < 81)) then
			{
			_hayMedico = true;
			_ayudando = _x getVariable "ayudando";
			if ((isNil "_ayudando") and (!(_x getVariable ["rearming",false]))) then
				{
				_medico = _x;
				_distancia = _x distance _unit;
				};
			};
		};
	};
} forEach _units;

if ((isNull _medico) or (_unit getVariable "inconsciente")) then
	{
	{
	if (!isPlayer _x) then
		{
		if (not(typeOf _x in SDKMedic)) then
			{
			if ((alive _x) and ("FirstAidKit" in (items _x)) and (not (_x getVariable "inconsciente")) and (vehicle _x == _x) and (_x distance _unit < _distancia)) then
				{
				_ayudando = _x getVariable "ayudando";
				if ((isNil "_ayudando") and (!(_x getVariable ["rearming",false]))) then
					{
					_medico = _x;
					_distancia = _x distance _unit;
					};
				};
			};
		};
	} forEach _units;
	};

if (!isNull _medico) then
	{
	[_unit,_medico] spawn ayudar;
	};

_medico