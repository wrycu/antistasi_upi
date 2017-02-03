if !(isPlayer stavros) exitWith {};

private ["_veh","_tipo"];
_veh = _this select 0;
_tipo = typeOf _veh;

if ((_tipo == "I_APC_tracked_03_cannon_F") or (_tipo == "I_APC_Wheeled_03_cannon_F")) then
	{
	APCAAFcurrent = APCAAFcurrent -1;
	if (APCAAFcurrent < 1) then
		{
		if (APCAAFcurrent < 0) then {APCAAFcurrent = 0};
		vehAAFAT = vehAAFAT - ["I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F"]; publicVariable "vehAAFAT";
		};
	publicVariable "APCAAFcurrent";
	}
else
	{
	if (_tipo == "I_MBT_03_cannon_F") then
		{
		tanksAAFcurrent = tanksAAFcurrent - 1;
		if (tanksAAFcurrent < 1) then
			{
			if (tanksAAFcurrent < 0) then {tanksAAFcurrent = 0};
			vehAAFAT = vehAAFAT - ["I_MBT_03_cannon_F"];publicVariable "vehAAFAT";
			};
		publicVariable "tanksAAFcurrent";
		}
	else
		{
		if (_veh isKindOf "Helicopter") then
			{
			helisAAFcurrent = helisAAFcurrent -1;
			if (helisAAFcurrent < 1) then
				{
				if (helisAAFcurrent < 0) then {helisAAFcurrent = 0};
				planesAAF = planesAAF - ["I_Heli_light_03_F"]; publicVariable "planesAAF";
				};
			publicVariable "helisAAFcurrent";
			}
		else
			{
			planesAAFcurrent = planesAAFcurrent - 1;
			if (planesAAFcurrent < 1) then
				{
				if (planesAAFcurrent < 0) then {planesAAFcurrent = 0};
				planesAAF = planesAAF - ["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]; publicVariable "planesAAF";
				};
			publicVariable "planesAAFcurrent";
			};
		};
	};
