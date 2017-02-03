private ["_veh","_tipo"];

_veh = _this select 0;

if ((_veh isKindOf "FlagCarrier") or (_veh isKindOf "Building") or (_veh isKindOf "ReammoBox_F")) exitWith {};
//if (_veh isKindOf "ReammoBox_F") exitWith {[_veh] call NATOcrate};

_tipo = typeOf _veh;

if (((_tipo) in vehNormal) or ((_tipo) in vehAttack) or (_tipo in vehBoats)) then
	{
	if !(_tipo in vehAttack) then
		{
		if (_tipo in vehAmmoTrucks) then
			{
			if (_veh distance getMarkerPos "respawn_guerrila" > 50) then {if (_tipo == vehNatoAmmoTruck) then {_nul = [_veh] call NATOcrate} else {_nul = [_veh] call CSATcrate}};
			};
		if (_veh isKindOf "Car") then
			{
			_veh addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and ((_this select 4=="") or (side (_this select 3) != buenos)) and (!isPlayer driver (_this select 0))) then {0} else {(_this select 2)}}];
			if ({"SmokeLauncher" in (_veh weaponsTurret _x)} count (allTurrets _veh) > 0) then
				{
				_veh setVariable ["dentro",true];
				_veh addEventHandler ["GetOut", {private ["_veh"]; _veh = _this select 0; if (side (_this select 2) != buenos) then {if (_veh getVariable "dentro") then {_veh setVariable ["dentro",false]; [_veh] call smokeCoverAuto}}}];
				_veh addEventHandler ["GetIn", {private ["_veh"]; _veh = _this select 0; if (side (_this select 2) != buenos) then {_veh setVariable ["dentro",true]}}];
				};
			};
		}
	else
		{
		if (_tipo in vehAPCs) then
			{
			_veh addEventHandler ["killed",
				{
				private ["_veh","_tipo"];
				_veh = _this select 0;
				_tipo = typeOf _veh;
				if (side (_this select 1) == buenos) then
					{
					if (_tipo in vehNATOAPC) then {[-2,2,position (_veh)] remoteExec ["citySupportChange",2]};
					};
				[_veh,30] call addTimeForIdle;
				}];
			_veh addEventHandler ["HandleDamage",{private ["_veh"]; _veh = _this select 0; if (!canFire _veh) then {[_veh] call smokeCoverAuto};if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_veh))) then {0;} else {(_this select 2);}}];
			_veh setVariable ["dentro",true];
			_veh addEventHandler ["GetOut", {private ["_veh"];  _veh = _this select 0; if (side (_this select 2) != buenos) then {if (_veh getVariable "dentro") then {_veh setVariable ["dentro",false];[_veh] call smokeCoverAuto}}}];
			_veh addEventHandler ["GetIn", {private ["_veh"];_veh = _this select 0; if (side (_this select 2) != buenos) then {_veh setVariable ["dentro",true]}}];
			}
		else
			{
			if (_tipo in vehTanks) then
				{
				_veh addEventHandler ["killed",
					{
					private ["_veh","_tipo"];
					_veh = _this select 0;
					_tipo = typeOf _veh;
					if (side (_this select 1) == buenos) then
						{
						if (_tipo == vehNATOTank) then {[-5,5,position (_veh)] remoteExec ["citySupportChange",2]};
						};
					[_veh,60] call addTimeForIdle;
					}];
				_veh addEventHandler ["HandleDamage",{private ["_veh"]; _veh = _this select 0; if (!canFire _veh) then {[_veh] call smokeCoverAuto}}];
				};
			};
		};
	}
else
	{
	if (_tipo in vehPlanes) then
		{
		_veh addEventHandler ["killed",
			{
			private ["_veh","_tipo"];
			{if ((side _x == malos) or (side _x == muyMalos)) then {_x setDamage 1}} forEach (crew (_this select 0));
			}];
		_veh addEventHandler ["GetIn",
			{
			_posicion = _this select 1;
			if (_posicion == "driver") then
				{
				_unit = _this select 2;
				if ((!isPlayer _unit) and (_unit getVariable ["GREENFORSpawn",false])) then
					{
					moveOut _unit;
					hint "Only Humans can pilot an air vehicle";
					};
				};
			}];
		if (_veh isKindOf "Helicopter") then
			{
			if (_tipo in vehTransportAir) then
				{
				_veh setVariable ["dentro",true];
				_veh addEventHandler ["GetOut", {private ["_veh"];_veh = _this select 0; if ((isTouchingGround _veh) and (isEngineOn _veh)) then {if (side (_this select 2) != buenos) then {if (_veh getVariable "dentro") then {_veh setVariable ["dentro",false]; [_veh] call smokeCoverAuto}}}}];
				_veh addEventHandler ["GetIn", {private ["_veh"];_veh = _this select 0; if (side (_this select 2) != buenos) then {_veh setVariable ["dentro",true]}}];
				}
			else
				{
				_veh addEventHandler ["killed",
					{
					private ["_veh","_tipo"];
					_veh = _this select 0;
					_tipo = typeOf _veh;
					if (side (_this select 1) == buenos) then
						{
						if (_tipo in vehNATOAttackHelis) then {[-5,5,position (_veh)] remoteExec ["citySupportChange",2]};
						};
					[_veh,30] call addTimeForIdle;
					}];
				};
			};
		if (_veh isKindOf "Plane") then
			{
			_veh addEventHandler ["killed",
				{
				private ["_veh","_tipo"];
				_veh = _this select 0;
				_tipo = typeOf _veh;
				if (side (_this select 1) == buenos) then
					{
					if (_tipo == vehNATOPlane) then {[-8,8,position (_veh)] remoteExec ["citySupportChange",2]};
					};
				[_veh,15] call addTimeForIdle;
				}];
			};
		}
	else
		{
		if (_veh isKindOf "StaticWeapon") then
			{
			if ((not (_veh in staticsToSave)) and (side gunner _veh != buenos)) then
				{
				[_veh,"steal"] remoteExec ["flagaction",[buenos,civilian],_veh];
				}
			else
				{
				if (_tipo == SDKMortar) then
					{
					if (!isNull gunner _veh) then
						{
						[_veh,"steal"] remoteExec ["flagaction",[buenos,civilian],_veh];
						};
					_veh addEventHandler ["Fired",
						{
						if (random 100 < 8) then
							{
							_mortero = _this select 0;
							if (_mortero distance posHQ < 200) then
								{
								if (!("DEF_HQ" in misiones)) then
									{
									_lider = leader (gunner _mortero);
									if (!isPlayer _lider) then
										{
										[] remoteExec ["ataqueHQ",HCattack];
										}
									else
										{
										if ([_lider] call isMember) then {[] remoteExec ["ataqueHQ",HCattack]};
										};
									};
								}
							else
								{
								_bases = (aeropuertos - mrkSDK) select {(getMarkerPos _x distance _posDestino < 15000) and (not(spawner getVariable [_x,false])) and (dateToNumber date > server getVariable _x)};
								if (count _bases > 0) then
									{
									_base = [_bases,position _mortero] call BIS_fnc_nearestPosition;
									_lado = if (_base in mrkNATO) then {malos} else {muyMalos};
									[position _mortero,_lado] remoteExec ["patrolCA",HCattack];
									};
								};
							};
						}];
					};
				};
			}
		else
			{
			if ((_tipo in vehAA) or (_tipo in vehMRLS)) then
				{
				_veh addEventHandler ["killed",
					{
					private ["_veh","_tipo"];
					_veh = _this select 0;
					_tipo = typeOf _veh;
					if (side (_this select 1) == buenos) then
						{
						if (_tipo == vehNATOAA) then {[-5,5,position (_veh)] remoteExec ["citySupportChange",2]};
						};
					[_veh,60] call addTimeForIdle;
					}];
				};
			};
		};
	};

[_veh] spawn cleanserVeh;

_veh addEventHandler ["Killed",{[_this select 0] spawn postmortem}];

if (not(_veh in staticsToSave)) then
	{
	if (((count crew _veh) > 0) and (not (_tipo in vehAA)) and (not (_tipo in vehMRLS))) then
		{
		[_veh] spawn VEHdespawner
		}
	else
		{
		_veh addEventHandler ["GetIn",
			{
			_unit = _this select 2;
			if ((side _unit == buenos) or (isPlayer _unit)) then {[_this select 0] spawn VEHdespawner};
			}
			];
		};
	if (_veh distance getMarkerPos "respawn_guerrila" <= 50) then
		{
		clearMagazineCargoGlobal _veh;
		clearWeaponCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
		};
	};