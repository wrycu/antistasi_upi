private ["_unit","_muerto","_killer","_skill","_nombre","_tipo"];

_unit = _this select 0;

[_unit] call initRevive;
_unit setVariable ["BLUFORSpawn",true,true];

_skillFIA = server getVariable "skillFIA";

_unit allowFleeing 0;
_skill = 0.2 + (_skillFIA * 0.04);
if ((!isMultiplayer) and (leader _unit == stavros)) then {_skill = _skill + 0.2};
_unit setSkill _skill;
_aiming = _skill;
_spotD = _skill;
_spotT = _skill;
_cour = _skill;
_comm = _skill;
_aimingSh = _skill;
_aimingSp = _skill;
_reload = _skill;

_tipo = typeOf _unit;
//_emptyUniform = false;
_skillSet = 0;

if (not("ItemRadio" in unlockedItems)) then
	{
	if ((_unit != leader _unit) and (_tipo != "b_g_soldier_unarmed_f")) then {_unit unlinkItem "ItemRadio"};
	};

if !(hayRHS) then {
	switch _tipo do {
		case "B_G_Soldier_LAT_F": {
			if ("launch_I_Titan_short_F" in unlockedWeapons) then {
				for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do {
					_unit removeMagazine "RPG32_F";
					};
				_unit removeMagazine "RPG32_HE_F";
				_unit removeWeaponGlobal "launch_RPG32_F";
				[_unit, "launch_I_Titan_short_F", 4, 0] call BIS_fnc_addWeapon;
				}
			else {
				if ("launch_NLAW_F" in unlockedWeapons) then {
					for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do {
						_unit removeMagazine "RPG32_F";
						};
					_unit removeMagazine "RPG32_HE_F";
					_unit removeWeaponGlobal "launch_RPG32_F";
					[_unit, "launch_NLAW_F", 4, 0] call BIS_fnc_addWeapon;
					};
				};
			[_unit,true,true,true,false] call randomRifle;
			};
		case "B_G_Soldier_F": {
			[_unit,true,true,true,true] call randomRifle;
			if (loadAbs _unit < 340) then {
				if ((random 20 < _skillFIA) and ("launch_I_Titan_F" in unlockedWeapons)) then {
					_unit addbackpack "B_AssaultPack_blk";
					[_unit, "launch_I_Titan_F", 2, 0] call BIS_fnc_addWeapon;
					removeBackpack _unit;
					}
				else {
					if ((random 20 < _skillFIA) and ("launch_NLAW_F" in unlockedWeapons)) then {
						_unit addbackpack "B_AssaultPack_blk";
						[_unit, "launch_RPG32_F", 2, 0] call BIS_fnc_addWeapon;
						removeBackPack _unit;
						};
					};
				};
			};
		case "B_G_Soldier_GL_F": {
			[_unit,false,true,true,false] call randomRifle;
			};
		case "B_G_Soldier_lite_F": {
			[_unit,true,true,true,true] call randomRifle;
			_skillSet = 1;
			};
		case "b_g_soldier_unarmed_f": {
			_skilleSet = 1;
			};
		case "B_G_Soldier_SL_F": {
			[_unit,false,true,true,false] call randomRifle;
			_skillSet = 2;
			};
		case "B_G_Soldier_TL_F": {
			[_unit,false,true,true,false] call randomRifle;
			_skillSet = 3;
			};
		case "B_G_Soldier_AR_F": {
			[_unit,false,true,true,false] call randomRifle;
			_skillSet = 4;
			};
		case "B_G_medic_F": {
			_skillSet = 5;
			[_unit,true,true,true,false] call randomRifle;
			};
		case "B_G_engineer_F": {
			_skillSet = 5;
			[_unit,true,true,true,false] call randomRifle;
			};
		case "B_G_Soldier_exp_F": {
			_skillSet = 5;
			[_unit,true,true,true,false] call randomRifle;
			_unit addmagazine "ATMine_Range_Mag";
			};
		case "B_G_Soldier_A_F": {
			_skillSet = 5;
			[_unit,true,true,true,false] call randomRifle;
			};
		case "B_G_Soldier_M_F": {
			if ("srifle_GM6_F" in unlockedWeapons) then {
				for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do {
					_unit removeMagazine "30Rnd_556x45_Stanag";
					};
				_unit removeWeaponGlobal (primaryWeapon _unit);
				[_unit, "srifle_GM6_SOS_F", 8, 0] call BIS_fnc_addWeapon;
				};
			_skillSet = 6;
			};
		case "B_G_Sharpshooter_F": {
			_skillSet = 6;
			};
		};
	}
else {
	removeVest _unit;
	_unit addVest "V_Chestrig_oli";
	_unit addItem "FirstAidKit";
	_unit addItem "FirstAidKit";
	_unit addMagazine "rhs_mag_rdg2_white";
	_unit addMagazine "rhs_mag_rgd5";

	switch _tipo do {
		case "B_G_Soldier_LAT_F": {
			removeBackpack _unit;
			_unit addBackpack "rhs_rpg_empty";
			for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do {
				_unit removeMagazine "RPG32_F";
			};
			_unit removeMagazine "RPG32_HE_F";
			_unit removeWeaponGlobal "launch_RPG32_F";
			[_unit, "rhs_weap_rpg7", 4, 0] call BIS_fnc_addWeapon;
			[_unit,true,true,true,false] call randomRifle;
		};
		case "B_G_Soldier_F": {
			[_unit,true,true,true,true] call randomRifle;

			if ((random 25 < _skillFIA) and ("rhs_weap_igla" in unlockedWeapons)) then {
				_unit addbackpack "B_AssaultPack_blk";
				[_unit, "rhs_weap_igla", 2, 0] call BIS_fnc_addWeapon;
				removeBackpack _unit;
			}
			else {
				if ((random 25 < _skillFIA) and ("rhs_weap_rpg26" in unlockedWeapons)) then {
					[_unit, "rhs_weap_rpg26", 1] call BIS_fnc_addWeapon;
				};
			};
		};
		case "B_G_Soldier_GL_F": {
			removeAllItemsWithMagazines _unit;
			_unit addbackpack "rhs_sidor";
			[_unit,false,true,true,true] call randomRifle;
			for "_i" from 1 to 4 do {_unit addItemToVest "rhs_30Rnd_762x39mm"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_akms_gp25";
			_unit addbackpack "rhs_sidor";
			_unit addItem "FirstAidKit";
			_unit addItem "FirstAidKit";
		};
		case "B_G_Soldier_lite_F": {
			[_unit,true,true,true,true] call randomRifle;
			_skillSet = 1;
		};
		case "b_g_soldier_unarmed_f": {
			_skilleSet = 1;
		};
		case "B_G_Soldier_SL_F": {
			_skillSet = 2;
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_7N10_AK"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_ak74m_gp25";
			_unit addPrimaryWeaponItem "rhs_acc_1p29";
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShell";
		};
		case "B_G_Soldier_TL_F": {
			[_unit,false,true,true,false] call randomRifle;
			_skillSet = 3;
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_7N10_AK"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_ak74m_gp25";
			_unit addPrimaryWeaponItem "rhs_acc_1p29";
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShell";
		};
		case "B_G_Soldier_AR_F": {
			[_unit,false,true,true,true] call randomRifle;
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			_unit addbackpack "rhs_sidor";
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addWeaponGlobal "rhs_weap_pkm";
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addItem "FirstAidKit";
			_unit addItem "FirstAidKit";
			_emptyUniform = true;
			_skillSet = 4;
		};
		case "B_G_medic_F": {
			[_unit,false,true,true,false] call randomRifle;
			removeVest _unit;
			_unit addVest "rhs_6b23_digi_medic";
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			_unit addWeaponGlobal "rhs_weap_aks74u";
			for "_i" from 1 to 4 do {_unit addItemToVest "rhs_30Rnd_545x39_7N10_AK";};
			removeBackpackGlobal _unit;
			_unit addBackpack "rhs_assault_umbts_medic";
			_skillSet = 5;
		};
		case "B_G_engineer_F": {
			[_unit,false,true,true,false] call randomRifle;
			removeVest _unit;
			_unit addVest "rhs_6b23_digi_engineer";
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			_unit addWeaponGlobal "rhs_weap_aks74u";
			for "_i" from 1 to 4 do {_unit addItemToVest "rhs_30Rnd_545x39_7N10_AK";};
			removeBackpackGlobal _unit;
			_unit addBackpack "rhs_assault_umbts_engineer";
			_skillSet = 5;
		};
		case "B_G_Soldier_exp_F": {
			_skillSet = 5;
			[_unit,true,true,true,true] call randomRifle;
			removeBackpackGlobal _unit;
			_unit addBackpack "B_Carryall_oli";
			_unit addItemToBackpack "rhs_mine_tm62m_mag";
			_unit addItem "SatchelCharge_Remote_Mag";
			_unit addItem "DemoCharge_Remote_Mag";
		};
		case "B_G_Soldier_A_F": {
			_skillSet = 5;
			[_unit,true,true,true,true] call randomRifle;
		};
		case "B_G_Soldier_M_F": {
			for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do {
			_unit removeMagazine "30Rnd_556x45_Stanag";
			};
			if !("srifle_GM6_F" in unlockedWeapons) then	{
				[_unit, "rhs_weap_svdp_wd", 8, 0] call BIS_fnc_addWeapon; _unit addPrimaryWeaponItem "rhs_acc_pso1m2";
			}
			else {
				[_unit, "srifle_GM6_SOS_F", 8, 0] call BIS_fnc_addWeapon;
			};
			_skillSet = 6;
		};
		case "B_G_Sharpshooter_F": {
			for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do {
			_unit removeMagazine "30Rnd_556x45_Stanag";
			};
			if !("srifle_GM6_F" in unlockedWeapons) then	{
				[_unit, "rhs_weap_svdp_wd", 8, 0] call BIS_fnc_addWeapon; _unit addPrimaryWeaponItem "rhs_acc_pso1m2";
			}
			else {
				[_unit, "srifle_GM6_SOS_F", 8, 0] call BIS_fnc_addWeapon;
			};
			_skillSet = 6;
		};
	};
};

switch _skillSet do
	{
	case 0:
		{
		_aiming = _aiming -0.2;
		_aimingSh = _aimingSh - 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
		};
	case 1:
		{
		_aiming = _aiming -0.1;
		_spotD = _spotD - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp + 0.2;
		_reload = _reload + 0.1;
		};
	case 2:
		{
		_aiming = _aiming - 0.1;
		_spotD = _spotD + 0.2;
		_spotT = _spotT + 0.2;
		_cour = _cour + 0.1;
		_comm = _comm + 0.2;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.2;
		};
	case 3:
		{
		_aiming = _aiming + 0.1;
		_spotD = _spotD + 0.1;
		_spotT = _spotT + 0.1;
		_cour = _cour + 0.1;
		_comm = _comm + 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		};
	case 4:
		{
		_aiming = _aiming - 0.1;
		_aimingSh = _aimingSh + 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
		};
	case 5:
		{
		_aiming = _aiming - 0.1;
		_spotD = _spotD - 0.1;
		_spotT = _spotT - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		};
	case 6:
		{
		_aiming = _aiming + 0.2;
		_spotD = _spotD + 0.4;
		_spotT = _spotT + 0.2;
		_cour = _cour - 0.1;
		_comm = _comm - 0.1;
		_aimingSh = _aimingSh + 0.1;
		_aimingSp = _aimingSp + 0.1;
		_reload = _reload - 0.4;
		};
	};

_unit selectWeapon (primaryWeapon _unit);

if (sunOrMoon < 1) then
	{
	if ((indNVG in unlockedItems) or (indNVG in unlockedItems)) then
		{
		_unit linkItem indNVG;
		if (indLaser in unlockedItems) then
			{
			_unit addPrimaryWeaponItem indLaser;
	        _unit assignItem indLaser;
	        _unit enableIRLasers true;
	        };
		}
	else
		{
		if (indFL in unlockedItems) then
			{
			_unit unassignItem indLaser;
	        _unit removePrimaryWeaponItem indLaser;
	        _unit addPrimaryWeaponItem indFL;
	        _unit assignItem indFL;
	        _unit enableGunLights "forceOn";
			_spotD = ((_spotD - 0.2) max 0.2);
			_spotT = ((_spotT - 0.2) max 0.2);
	    	};
		};
	};

if ((_tipo != "B_G_Soldier_M_F") and (_tipo != "B_G_Sharpshooter_F")) then {if (_aiming > 0.35) then {_aiming = 0.35}};

_unit setskill ["aimingAccuracy",_aiming];
_unit setskill ["spotDistance",_spotD];
_unit setskill ["spotTime",_spotT];
_unit setskill ["courage",_cour];
_unit setskill ["commanding",_comm];
_unit setskill ["aimingShake",_aimingSh];
_unit setskill ["aimingSpeed",_aimingSp];
_unit setskill ["reloadSpeed",_reload];

if (player == leader _unit) then
	{
	_EHkilledIdx = _unit addEventHandler ["killed", {
		_muerto = _this select 0;
		[_muerto] spawn postmortem;
		if (typeOf _muerto != "b_g_survivor_F") then {arrayids = arrayids + [name _muerto]};
		_nul = [0.25,0,getPos _muerto] remoteExec ["citySupportChange",2];
		_muerto setVariable ["BLUFORSpawn",nil,true];
		}];
	if (_tipo != "b_g_survivor_F") then
		{
		_idUnit = arrayids call BIS_Fnc_selectRandom;
		arrayids = arrayids - [_idunit];
		_unit setIdentity _idUnit;
		if (captive player) then {[_unit] spawn undercoverAI};
		};
	_unit setVariable ["rearming",false];
	if (not("ItemRadio" in unlockedItems)) then
		{
		while {alive _unit} do
			{
			sleep 10;
			if (("ItemRadio" in assignedItems _unit) and ([player] call hasRadio)) exitWith {_unit groupChat format ["This is %1, radiocheck OK",name _unit]};
			if (unitReady _unit) then
				{
				if ((alive _unit) and (_unit distance (getMarkerPos "respawn_west") > 50) and (_unit distance leader group _unit > 500) and ((vehicle _unit == _unit) or ((typeOf (vehicle _unit)) in arrayCivVeh))) then
					{
					hint format ["%1 lost communication, he will come back with you if possible", name _unit];
					[_unit] join rezagados;
					if ((vehicle _unit isKindOf "StaticWeapon") or (isNull (driver (vehicle _unit)))) then {unassignVehicle _unit; [_unit] orderGetIn false};
					_unit doMove position player;
					_tiempo = time + 900;
					waitUntil {sleep 1;(!alive _unit) or (_unit distance player < 500) or (time > _tiempo)};
					if ((_unit distance player >= 500) and (alive _unit)) then {_unit setPos (getMarkerPos "respawn_west")};
					[_unit] join group player;
					};
				};
			};
		};
	}
else
	{
	_EHkilledIdx = _unit addEventHandler ["killed", {
		_muerto = _this select 0;
		_killer = _this select 1;
		[_muerto] remoteExec ["postmortem",2];
		if (isPlayer _killer) then
			{
			if (!isMultiPlayer) then
				{
				_nul = [0,20] remoteExec ["resourcesFIA",2];
				_killer addRating 1000;
				};
			};
		[_muerto] spawn postmortem;
		_muerto setVariable ["BLUFORSpawn",nil,true];
		_nul = [0,-0.25,getPos _muerto] remoteExec ["citySupportChange",2];
		}];
	};


