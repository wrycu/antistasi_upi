private ["_veh","_lado","_return","_totalSeats","_crewSeats","_cargoSeats"];
_veh = _this select 0;
_lado = _this select 1;

_return = "";
_totalSeats = [_veh, true] call BIS_fnc_crewCount; // Number of total seats: crew + non-FFV cargo/passengers + FFV cargo/passengers
_crewSeats = [_veh, false] call BIS_fnc_crewCount; // Number of crew seats only
_cargoSeats = _totalSeats - _crewSeats;

if (_cargoSeats <= 2) exitwith {diag_log format ["Error en cargoseats al intentar buscar para un %1",_veh];_return};
if ((_cargoSeats >= 2) and (_cargoSeats < 4)) then
	{
	switch (_lado) do
		{
		case malos: {_return = gruposNATOSentry};
		case muyMalos: {_return = gruposCSATSentry};
		};
	}
else
	{
	if ((_cargoSeats >= 4) and (_cargoSeats < 8)) then
		{
		switch (_lado) do
			{
			case malos: {_return = selectRandom gruposNATOmid};
			case muyMalos: {_return = selectRandom gruposCSATmid};
			};
		}
	else
		{
		switch (_lado) do
			{
			case malos: {_return = selectRandom gruposNATOSquad};
			case muyMalos: {_return = selectRandom gruposCSATSquad};
			};
		};
	};
_return