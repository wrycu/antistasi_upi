if (!isServer) exitWith {};

private ["_tipo","_posbase","_posibles","_sitios","_exists","_sitio","_pos","_ciudad"];

_tipo = _this select 0;

_posbase = getMarkerPos "respawn_guerrila";
_posibles = [];
_sitios = [];
_exists = false;

_silencio = false;
if (count _this > 1) then {_silencio = true};

if (_tipo in misiones) exitWith {if (!_silencio) then {[petros,"globalChat","I already gave you a mission of this type"] remoteExec ["commsMP",stavros]}};

if (_tipo == "AS") then
	{
	_sitios = aeropuertos + ciudades + (controles select {!(isOnRoad getMarkerPos _x)}) - mrkSDK;
	if (count _sitios > 0) then
		{
		//_posibles = _sitios select {((getMarkerPos _x distance _posbase < distanciaMiss) and (not(spawner getVariable _x)))};
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if (_pos distance _posbase < distanciaMiss) then
				{
				if (_sitio in controles) then
					{
					_marcadores = mrkSDK select {getMarkerPos _x distance _pos < distanciaSPWN};
					_marcadores = _marcadores - ["Synd_HQ"];
					_frontera = if (count _marcadores > 0) then {true} else {false};
					if (_frontera) then
						{
						_posibles pushBack _sitio;
						};
					}
				else
					{
					if (not(spawner getVariable _sitio)) then {_posibles pushBack _sitio};
					};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no assasination missions for you. Move our HQ closer to the enemy or finish some other assasination missions in order to have better intel"] remoteExec ["commsMP",stavros];
			[petros,"hint","Assasination Missions require cities, Patrolled Jungles or Airports closer than 4Km from your HQ."] remoteExec ["commsMP",stavros];
			};
		}
	else
		{
		_sitio = selectRandom _posibles;
		if (_sitio in aeropuertos) then {[_sitio] remoteExec ["AS_Oficial",HCgarrisons]} else {if (_sitio in ciudades) then {[_sitio] remoteExec ["AS_Traidor",HCgarrisons]} else {[_sitio] remoteExec ["AS_SpecOP",HCgarrisons]}};
		};
	};
if (_tipo == "CON") then
	{
	_sitios = (controles select {isOnRoad (getMarkerPos _x)}) + puestos + recursos - mrkSDK;
	if (count _sitios > 0) then
		{
		_posibles = _sitios select {(getMarkerPos _x distance _posbase < distanciaMiss)};
		/*
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if ((_pos distance _posbase < 4000) and (_sitio in mrkNATO)) then {_posibles = _posibles + [_sitio]};
			};
		*/
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no Conquest missions for you. Move our HQ closer to the enemy or finish some other conquest missions in order to have better intel."] remoteExec ["commsMP",stavros];
			[petros,"hint","Conquest Missions require roadblocks or outposts closer than 4Km from your HQ."] remoteExec ["commsMP",stavros];
			};
		}
	else
		{
		_sitio = selectRandom _posibles;
		[_sitio] remoteExec ["CON_Puestos",HCgarrisons];
		};
	};
if (_tipo == "DES") then
	{
	_sitios = aeropuertos + antenas - mrkSDK;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			if (_sitio in marcadores) then {_pos = getMarkerPos _sitio} else {_pos = getPos _sitio};
			if (_pos distance _posbase < distanciaMiss) then
				{
				if (_sitio in marcadores) then
					{
					if (not(spawner getVariable _sitio)) then {_posibles pushBack _sitio};
					}
				else
					{
					_cercano = [marcadores, getPos _sitio] call BIS_fnc_nearestPosition;
					if (_cercano in mrkNATO) then {_posibles pushBack _sitio};
					};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no destroy missions for you. Move our HQ closer to the enemy or finish some other destroy missions in order to have better intel"] remoteExec ["commsMP",stavros];
			[petros,"hint","Destroy Missions require Airbases or Radio Towers closer than 4Km from your HQ."] remoteExec ["commsMP",stavros];
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in aeropuertos) then {if (random 10 < 8) then {[_sitio] remoteExec ["DES_Vehicle",HCgarrisons]} else {[_sitio] remoteExec ["DES_Heli",HCgarrisons]}};
		if (_sitio in antenas) then {[_sitio] remoteExec ["DES_antena",HCgarrisons]}
		};
	};
if (_tipo == "LOG") then
	{
	_sitios = puestos + ciudades;
	if (random 100 < 20) then {_sitios = _sitios + bancos};
	_sitios = _sitios - mrkSDK;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			if (_sitio in marcadores) then
				{
				_pos = getMarkerPos _sitio;
				}
			else
				{
				_pos = getPos _sitio;
				};
			if (_pos distance _posbase < distanciaMiss) then
				{
				if (_sitio in ciudades) then
					{
					if ([_pos,_posbase] call isTheSameIsland) then
						{
						_datos = server getVariable _sitio;
						_prestigeOPFOR = _datos select 2;
						_prestigeBLUFOR = _datos select 3;
						if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
							{
							_posibles pushBack _sitio;
							};
						};
					}
				else
					{
					if ([_pos,_posbase] call isTheSameIsland) then {_posibles pushBack _sitio};
					};
				};
			if (_sitio in bancos) then
				{
				_ciudad = [ciudades, _pos] call BIS_fnc_nearestPosition;
				if (_ciudad in mrkSDK) then {_posibles = _posibles - [_sitio]};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no logistics missions for you. Move our HQ closer to the enemy or finish some other logistics missions in order to have better intel"] remoteExec ["commsMP",stavros];
			[petros,"hint","Logistics Missions require Outposts, Cities or Banks closer than 4Km from your HQ."] remoteExec ["commsMP",stavros];
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[_sitio] remoteExec ["LOG_Suministros",HCgarrisons]};
		if (_sitio in puestos) then {[_sitio] remoteExec ["LOG_Ammo",HCgarrisons]};
		if (_sitio in bancos) then {[_sitio] remoteExec ["LOG_Bank",HCgarrisons]};
		};
	};
if (_tipo == "RES") then
	{
	//_sitios = ciudades + aeropuertos + puestos - mrkSDK;
	_sitios = aeropuertos + puestos + ciudades - mrkSDK;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if (_sitio in ciudades) then {if (_pos distance _posbase < distanciaMiss) then {_posibles pushBack _sitio}} else {if ((_pos distance _posbase < distanciaMiss) and (not(spawner getVariable _sitio))) then {_posibles = _posibles + [_sitio]}};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no rescue missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel"] remoteExec ["commsMP",stavros];
			[petros,"hint","Rescue Missions require Cities or Airports closer than 4Km from your HQ."] remoteExec ["commsMP",stavros];
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[_sitio] remoteExec ["RES_Refugiados",HCgarrisons]} else {[_sitio] remoteExec ["RES_Prisioneros",HCgarrisons]};
		};
	};
if (_tipo == "CONVOY") then
	{
	if (!bigAttackInProgress) then
		{
		_sitios = (aeropuertos + recursos + fabricas + puertos + ["puesto","puesto_1","puesto_3","puesto_7"] - mrkSDK) + ciudades;
		if (count _sitios > 0) then
			{
			for "_i" from 0 to ((count _sitios) - 1) do
				{
				_sitio = _sitios select _i;
				_pos = getMarkerPos _sitio;
				_base = [_sitio] call findBasesForConvoy;
				if ((_pos distance _posbase < distanciaMiss) and (_base !="")) then
					{
					if ((_sitio in ciudades) and (_sitio in mrkSDK)) then
						{
						if (_base in mrkNATO) then
							{
							_datos = server getVariable _sitio;
							_prestigeOPFOR = _datos select 2;
							_prestigeBLUFOR = _datos select 3;
							if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
								{
								_posibles pushBack _sitio;
								};
							}
						}
					else
						{
						if (((_sitio in mrkNATO) and (_base in mrkNATO)) or ((_sitio in mrkCSAT) and (_base in mrkCSAT))) then {_posibles pushBack _sitio};
						};
					};
				};
			};
		if (count _posibles == 0) then
			{
			if (!_silencio) then
				{
				[petros,"globalChat","I have no Convoy missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel"] remoteExec ["commsMP",stavros];
				[petros,"hint","Convoy Missions require Airports or Cities closer than 4Km from your HQ, and they must have an idle friendly base in their surroundings."] remoteExec ["commsMP",stavros];
				};
			}
		else
			{
			_sitio = _posibles call BIS_fnc_selectRandom;
			_base = [_sitio] call findBasesForConvoy;
			[_sitio,_base] remoteExec ["CONVOY",HCgarrisons];
			};
		}
	else
		{
		[petros,"globalChat","There is a big battle around, I don't think the enemy will send any convoy"] remoteExec ["commsMP",stavros];
		[petros,"hint","Convoy Missions require a clmaed status around the island, and now it is not the proper time."] remoteExec ["commsMP",stavros];
		};
	};

if ((count _posibles > 0) and (!_silencio)) then {[petros,"globalChat","I have a mission for you"] remoteExec ["commsMP",stavros]};