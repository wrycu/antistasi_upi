private ["_resourcesAAF","_coste","_destroyedCities","_destroyed","_nombre"];

_resourcesAAF = server getVariable "resourcesAAF";

waitUntil {!resourcesIsChanging};
resourcesIsChanging = true;

_multiplicador = 1;

if (!isMultiplayer) then {_multiplicador = 2};

_cuenta = count (mrkSDK - puestosFIA - ["Synd_HQ"] - ciudades);

if (_resourcesAAF > 5000) then
	{
	_destroyedCities = destroyedCities - mrkSDK - ciudades;
	if (count _destroyedCities > 0) then
		{
		{
		_destroyed = _x;
		if ((_resourcesAAF > 5000) and (not(spawner getVariable _destroyed))) then
			{
			_resourcesAAF = _resourcesAAF - 5000;
			destroyedCities = destroyedCities - [_destroyed];
			publicVariable "destroyedCities";
			[10,0,getMarkerPos _destroyed] remoteExec ["citySupportChange",2];
			[-5,0] remoteExec ["prestige",2];
			_nombre = [_destroyed] call localizar;
			[["TaskFailed", ["", format ["%1 rebuilt by AAF",_nombre]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
			};
		} forEach _destroyedCities;
		}
	else
		{
		if ((count antenasMuertas > 0) and (not("REP" in misiones))) then
			{
			{
			if (_resourcesAAF > 5000) exitWith
				{
				_marcador = [marcadores, _x] call BIS_fnc_nearestPosition;
				if ((_marcador in mrkNATO) and (not(spawner getVariable _marcador))) exitWith
					{
					[_marcador,_x] remoteExec ["REP_Antena",HCattack];
					};
				};
			} forEach antenasMuertas;
			};
		};
	};

if (_cuenta == 0) exitWith {resourcesIsChanging = false};

if (((planesAAFcurrent < planesAAFmax) and (helisAAFcurrent > 3)) and (_cuenta > 6)) then
	{
	if (_resourcesAAF > (17500*_multiplicador)) then
		{
		if (count planesAAF < 2) then {planesAAF = planesAAF + ["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]; publicVariable "planesAAF"};
		planesAAFcurrent = planesAAFcurrent + 1; publicVariable "planesAAFcurrent";
		_resourcesAAF = _resourcesAAF - (17500*_multiplicador);
		};
	};
if (((tanksAAFcurrent < tanksAAFmax) and (APCAAFcurrent > 3)) and (_cuenta > 5) and (planesAAFcurrent != 0)) then
	{
	if (_resourcesAAF > (15000*_multiplicador)) then
		{
		if (not ("I_MBT_03_cannon_F" in vehAAFAT)) then
	        {
	        vehAAFAT = vehAAFAT +  ["I_MBT_03_cannon_F"]; publicVariable "vehAAFAT";
	        };
	    tanksAAFcurrent = tanksAAFcurrent + 1; publicVariable "tanksAAFcurrent";
	    _resourcesAAF = _resourcesAAF - (15000*_multiplicador);
		};
    };
if (((helisAAFcurrent < helisAAFmax) and ((helisAAFcurrent < 4) or (planesAAFcurrent > 3))) and (_cuenta > 3)) then
	{
	if (_resourcesAAF > (10000*_multiplicador)) then
		{
		if (not ("I_Heli_light_03_F" in planesAAF)) then {planesAAF = planesAAF + ["I_Heli_light_03_F"]; publicVariable "planesAAF"};
		helisAAFcurrent = helisAAFcurrent + 1; publicVariable "helisAAFcurrent";
		_resourcesAAF = _resourcesAAF - (10000*_multiplicador);
		};
	};
if ((APCAAFcurrent < APCAAFmax) and ((tanksAAFcurrent > 2) or (APCAAFcurrent < 4)) and (_cuenta > 2)) then
	{
	if (_resourcesAAF > (5000*_multiplicador)) then
		{
		if (not ("I_APC_Wheeled_03_cannon_F" in vehAAFAT)) then
	    	{
	        vehAAFAT = vehAAFAT +  ["I_APC_Wheeled_03_cannon_F"]; publicVariable "vehAAFAT";
	        };
	    if (not ("I_APC_tracked_03_cannon_F" in vehAAFAT)) then
	    	{
	        vehAAFAT = vehAAFAT +  ["I_APC_tracked_03_cannon_F"]; publicVariable "vehAAFAT";
	        };
	    APCAAFcurrent = APCAAFcurrent + 1; publicVariable "APCAAFcurrent";
	    _resourcesAAF = _resourcesAAF - (5000*_multiplicador);
		};
	};

if ((skillAAF < (skillFIA) + 2) and (skillAAF < 13)) then
	{
	_coste = 1000 + (1.5*(skillAAF *750));
	if (_coste < _resourcesAAF) then
		{
		skillAAF = skillAAF + 1;
		publicVariable "skillAAF";
		_resourcesAAF = _resourcesAAF - _coste;
		{
		_coste = server getVariable _x;
		_coste = round (_coste + (_coste * (skillAAF/280)));
		server setVariable [_x,_coste,true];
		} forEach soldadosAAF;
		};
	};

if (_resourcesAAF > 2000) then
	{
	{
	if (_resourcesAAF < 2000) exitWith {};
	if ([_x] call isFrontline) then
		{
		_cercano = [mrkSDK,getMarkerPos _x] call BIS_fnc_nearestPosition;
		_minefieldDone = false;
		_minefieldDone = [_cercano,_x] call minefieldAAF;
		if (_minefieldDone) then {_resourcesAAF = _resourcesAAF - 2000};
		};
	} forEach (aeropuertos - mrkSDK);
	};

_resourcesAAF = round _resourcesAAF;

server setVariable ["resourcesAAF",_resourcesAAF,true];

resourcesIsChanging = false;