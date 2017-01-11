
private ["_objetivos","_marcadores","_base","_objetivo","_cuenta","_aeropuerto","_datos","_prestigeOPFOR","_scoreLand","_scoreAir","_analizado","_garrison","_size","_estaticas","_salir"];

_objetivos = [];
_marcadores = [];
_cuentaFacil = 0;

_aeropuertos = (aeropuertos - mrkSDK) select {(dateToNumber date > server getVariable _x) and (not(spawner getVariable [_x,false]))};

_objetivos = marcadores - controles - puestosFIA - ["Synd_HQ","airport_1","airport_4"] - destroyedCities;
_objetivosFinal = [];
_basesFinal = [];
_cuentasFinal = [];
_objetivoFinal = "";
_faciles = [];
_puertoCSAT = if ({_x in puertos} count mrkCSAT >0) then {true} else {false};
_puertoNATO = if ({_x in puertos} count mrkNATO >0) then {true} else {false};

{
_base = _x;
_posBase = getMarkerPos _base;
_tmpObjetivos = [];
_baseNATO = true;
if (_base in mrkNATO) then {_tmpObjetivos = _objetivos - ciudades - mrkNATO} else {_baseNATO = false; _tmpObjetivos = _objetivos - mrkCSAT};
_tmpObjetivos = _tmpObjetivos select {getMarkerPos _x distance _posBase < 15000};
_cercano = [_tmpObjetivos,_base] call BIS_fnc_nearestPosition;
	{
	_proceder = true;
	_esCiudad = false;
	_posSitio = getMarkerPos _x;
	_esSDK = false;
	_isTheSameIsland = [_x,_base] call isTheSameIsland;
	if (_x in mrkSDK) then
		{
		_esSDK = true;
		_valor = prestigeCSAT;
		if (_baseNATO) then {_valor = prestigeNATO};
		if (random 100 > _valor) then
			{
			_proceder = false
			}
		else
			{
			if (count _faciles < 4) then
				{
				if (not _esCiudad) then
					{
					_sitio = _x;
					_garrison = garrison getVariable [_sitio,[]];
					_estaticas = staticsToSave select {_x distance _posSitio < distanciaSPWN};
					_puestos = puestosFIA select {getMarkerPos _x distance _posSitio < distanciaSPWN};
					_cuenta = ((count _garrison) + (3*(count puestos)) + (2*(count _estaticas)));
					if (_cuenta <= 4) then
						{
						_proceder = false;
						_faciles pushBack [_sitio,_base];
						};
					};
				};
			};
		};
	if (!_isTheSameIsland and (not(_x in aeropuertos))) then
		{
		if (!_esSDK) then {_proceder = false};
		}
	else
		{
		if (_x in ciudades) then {_esCiudad = true};
		};
	if (_proceder) then
		{
		_times = 1;
		if (_baseNATO) then
			{
			if ((_x in puestos) or (_x in puertos)) then
				{
				if (!_esSDK) then
					{
					if (({[_x] call vehAvailable} count vehNATOAttack > 0) or ({[_x] call vehAvailable} count vehNATOAttackHelis > 0)) then {_times = 2*_times} else {_times = 0};
					}
				else
					{
					_times = 2*_times;
					};
				}
			else
				{
				if (_x in aeropuertos) then
					{
					if (!_esSDK) then
						{
						if (([vehNATOPlane] call vehAvailable) or (!([vehCSATAA] call vehAvailable))) then {_times = 5*_times} else {_times = 0};
						}
					else
						{
						_times = 5*_times;
						};
					};
				};
			}
		else
			{
			_times = 2;
			if (_esCiudad) then
				{
				_times =1
				}
			else
				{
				if (_x in puertos) then
					{
					if (!_esSDK) then
						{
						if (({[_x] call vehAvailable} count vehCSATAttack > 0) or ({[_x] call vehAvailable} count vehCSATAttackHelis > 0)) then {_times = 2*_times} else {_times = 0};
						}
					else
						{
						_times = 2*_times;
						};
					}
				else
					{
					if (_x in recursos) then
						{
						if (!_esSDK) then
							{
							if (({[_x] call vehAvailable} count vehCSATAttack > 0) or ({[_x] call vehAvailable} count vehCSATAttackHelis > 0)) then {_times = 3*_times} else {_times = 0};
							}
						else
							{
							_times = 3*_times;
							};
						}
					else
						{
						if (_x in aeropuertos) then
							{
							if (!_esSDK) then
								{
								if (([vehCSATPlane] call vehAvailable) or (!([vehNATOAA] call vehAvailable))) then {_times = 5*_times} else {_times = 0};
								}
							else
								{
								_times = _times *5;
								};
							}
						}
					}
				};
			};
		if (!_esSDK) then {_times = _times + (floor((garrison getVariable [_x,0])/8))};
		if (_times > 0) then
			{
			if (_isTheSameIsland) then
				{
				if ((_posSitio distance _posBase < 5000) and (!_esCiudad)) then {_times = _times * 4};
				};
			if (!_esCiudad) then
				{
				_esMar = false;
				if ((_baseNATO and _puertoNATO) or (!_baseNATO and _puertoCSAT)) then
					{
					for "_i" from 0 to 3 do
						{
						_pos = _posSitio getPos [1000,(_i*90)];
						if (surfaceIsWater _pos) exitWith {_esMar = true};
						};
					};
				if (_esMar) then {_times = _times * 2};
				};
			if (_x == _cercano) then {_times = _times * 4};
			_times = round (_times);
			_index = _objetivosFinal find _x;
			if (_index == -1) then
				{
				_objetivosFinal pushBack _x;
				_basesFinal pushBack _base;
				_cuentasFinal pushBack _times;
				}
			else
				{
				if (_times > (_cuentasFinal select _index)) then
					{
					_objetivosFinal deleteAt _index;
					_basesFinal deleteAt _index;
					_cuentasFinal deleteAt _index;
					_objetivosFinal pushBack _x;
					_basesFinal pushBack _base;
					_cuentasFinal pushBack _times;
					};
				};
			};
		};
	} forEach _tmpObjetivos;
} forEach _aeropuertos;

{[_x select 0,_x select 1] remoteExec ["patrolCA",HCattack]} forEach _faciles;

if ((count _objetivosFinal > 0) and (count _faciles < 3)) then
	{
	_arrayFinal = [];
	{
	for "_i" from 1 to _x do
		{
		_arrayFinal pushBack [(_objetivosFinal select _forEachIndex),(_basesFinal select _forEachIndex)];
		};
	} forEach _cuentasFinal;
	_objetivoFinal = selectRandom _arrayFinal;
	if (not((_objetivoFinal select 0) in ciudades)) then {[_objetivoFinal select 0,_objetivoFinal select 1] remoteExec ["combinedCA",HCattack]} else {[_objetivoFinal select 0,_objetivoFinal select 1] remoteExec ["CSATpunish",HCattack]};
	};
if (not("CONVOY" in misiones)) then
	{
	if ((count _objetivoFinal == 0) and (count _faciles < 2)) then
		{
		_objetivos = [];
		{
		_base = [_x] call findBasesForConvoy;
		if (_base != "") then
			{
			_datos = server getVariable _x;
			_prestigeOPFOR = _datos select 2;
			_prestigeBLUFOR = _datos select 3;
			if (_prestigeOPFOR + _prestigeBLUFOR < 95) then
				{
				_objetivos pushBack [_x,_base];
				};
			};
		} forEach (ciudades - mrkNATO);
		if (count _objetivos > 0) then
			{
			_objetivo = selectRandom _objetivos;
			[(_objetivo select 0),(_objetivo select 1)] remoteExec ["CONVOY",HCattack];
			};
		};
	};
