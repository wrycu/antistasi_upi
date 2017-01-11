private ["_unit","_veh"];

_unit = _this select 0;
_tipo = typeOf _unit;
if (typeOf _unit == "Fin_random_F") exitWith {};
_lado = side _unit;
_unit setVariable ["lado",_lado];
_unit addEventHandler ["HandleDamage",handleDamageAAF];

_unit addEventHandler ["killed",AAFKilledEH];
if (count _this > 1) then
	{
	if (_this select 1 != "") then
		{
		_unit setVariable ["marcador",(_this select 1)];
		};
	}
else
	{
	if (vehicle _unit != _unit) then
		{
		_veh = vehicle _unit;
		if (_unit in (assignedCargo _veh)) then
			{
			//if (typeOf _veh in vehAPCs) then {if (isMultiplayer) then {[_unit,false] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation false}};
			_unit addEventHandler ["GetOutMan",
				{
				_unit = _this select 0;
				_veh = _this select 2;
				_driver = driver _veh;
				if (!isNull _driver) then
					{
					if ((_driver getVariable ["BLUFORSpawn",false]) or (_driver getVariable ["OPFORSpawn",false])) then
						{
						if ((not(_unit getVariable ["BLUFORSpawn",false])) or ((not(_unit getVariable ["OPFORSpawn",false])))) then
							{
							_lado = _unit getVariable "lado";
							if (_lado == malos) then {_unit setVariable ["BLUFORSpawn",true,true]} else {_unit setVariable ["OPFORSpawn",true,true]};
							//if (!simulationEnabled _unit) then {if (isMultiplayer) then {[_unit,true] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation true}};
							};
						};
					};
				}];
			}
		else
			{
			if (_lado == malos) then {_unit setVariable ["BLUFORSpawn",true,true]} else {_unit setVariable ["OPFORSpawn",true,true]};
			};
		}
	else
		{
		if (_lado == malos) then {_unit setVariable ["BLUFORSpawn",true,true]} else {_unit setVariable ["OPFORSpawn",true,true]};
		};
	};
/*
_unit addEventHandler ["killed", {
	_muerto = _this select 0;
	_killer = _this select 1;
	if (side _killer == buenos) then {_nul = [0,0.25,getPos _muerto] remoteExec ["citySupportChange",2]} else {if (side _killer == muyMalos) then {_nul = [-0.25,0,getPos _muerto] remoteExec ["citySupportChange",2]}};
	[_muerto] spawn postmortem;
	}];
*/

_skill = 0;

if ((faction _unit != "BLU_GEN_F") and (faction _unit != "BLU_G_F")) then
	{
	if (side _unit == malos) then
		{
		_skill = 0.2 + (skillFIA * 0.2);
		}
	else
		{
		if (count _this > 1) then
			{
			_skill = 0.2 + (skillFIA * 0.2);
			}
		else
			{
			_skill = 0.3 + (skillFIA * 0.2);
			};
		};
	}
else
	{
	if (faction _unit == "BLU_G_F") then
		{
		_skill = 0.1 + (skillFIA * 0.2);
		}
	else
		{
		_skill = skillFIA * 0.2;
		if (skillFIA > 1) then
			{
			_rifleFinal = primaryWeapon _unit;
			_magazines = getArray (configFile / "CfgWeapons" / _rifleFinal / "magazines");
			{_unit removeMagazines _x} forEach _magazines;
			/*
			for "_i" from 1 to ({_x == _mag} count magazines _unit) do
				{
				_unit removeMagazine _mag;
				};
			*/
			_unit removeWeaponGlobal (_rifleFinal);
			if (_skill < 5) then {[_unit, "arifle_MX_Black_F", 6, 0] call BIS_fnc_addWeapon} else {[_unit, "arifle_AK12_F", 6, 0] call BIS_fnc_addWeapon};
			};
		};
	};

if (_skill > 0.58) then {_skill = 0.58} else {if (_skill < 0.3) then {if ((faction _unit != "BLU_GEN_F") and (faction _unit != "BLU_G_F")) then {_skill = 0.3}}};
_unit setSkill _skill;
if (not(_tipo in sniperUnits)) then {if (_unit skill "aimingAccuracy" > 0.35) then {_unit setSkill ["aimingAccuracy",0.35]}};
if (_unit == leader _unit) then
	{
	_unit setskill ["courage",_skill + 0.2];
	_unit setskill ["commanding",_skill + 0.2];
	};
_hmd = hmd _unit;
if (sunOrMoon < 1) then
	{
	if ((faction _unit != "BLU_CTRG_F") and (faction _unit != "OPF_V_F") and (_unit != leader (group _unit))) then
		{
		if (_hmd != "") then
			{
			if ((random 20 > skillFIA) and (not("NVGoggles" in unlockedItems))) then
				{
				_unit unassignItem _hmd;
				_unit removeItem _hmd;
				_hmd = "";
				};
			};
		};
	if (_hmd != "") then
		{
		if ("acc_pointer_IR" in primaryWeaponItems _unit) then
			{
			_unit action ["IRLaserOn", _unit]
			};
		}
	else
		{
		if (not("acc_flashlight" in primaryWeaponItems _unit)) then
			{
			_compatibles = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
			if ("acc_flashlight" in _compatibles) then
				{
				_unit addPrimaryWeaponItem "acc_flashlight";
			    _unit assignItem "acc_flashlight";
				};
			};
		_unit enableGunLights "AUTO";
		_unit setskill ["spotDistance",_skill - 0.2];
		_unit setskill ["spotTime",_skill - 0.2];
		};
	}
else
	{
	if ((faction _unit != "BLU_CTRG_F") and (faction _unit != "OPF_V_F")) then
		{
		if (_hmd != "") then
			{
			_unit unassignItem _hmd;
			_unit removeItem _hmd;
			};
		};
	};