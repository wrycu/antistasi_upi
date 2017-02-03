private ["_flag","_tipo"];

if (isDedicated) exitWith {};

_flag = _this select 0;
_tipo = _this select 1;

switch _tipo do
	{
	case "take": {removeAllActions _flag; _flag addAction ["Take the Flag", {[[_this select 0, _this select 1],"mrkWIN"] call BIS_fnc_MP;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "unit": {_flag addAction ["Unit Recruitment", {nul=[] execVM "Dialogs\unit_recruit.sqf";;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "vehicle": {_flag addAction ["Buy Vehicle", {nul = createDialog "vehicle_option";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "mission": {petros addAction ["Mission Request", {nul=CreateDialog "mission_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "camion": {accion = _flag addAction ["Transfer Ammobox to Truck", "Municion\transfer.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "heal": {if (player != _flag) then {_flag addAction ["Revive", "Revive\actionRevive.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]}};
	case "remove":
		{
		if (player == _flag) then
			{
			if (isNil "accion") then
				{
				removeAllActions _flag;
				}
			else
				{
				_flag removeAction accion;
				};
			}
		else
			{
			removeAllActions _flag
			};
		};
	case "refugiado": {_flag addAction ["Liberate", "AI\liberaterefugee.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "prisionero": {_flag addAction ["Liberate POW", "AI\liberatePOW.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "interrogar": {_flag addAction ["Interrogate", "AI\interrogar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "capturar": {_flag addAction ["Liberate\Free POW", "AI\capturar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "buildHQ": {_flag addAction ["Build HQ here", {[] spawn buildHQ},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "seaport": {_flag addAction ["Buy Boat", "REINF\buyBoat.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "steal": {_flag addAction ["Steal Static", "REINF\stealStatic.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "garage":
		{
		if (isMultiplayer) then
			{
			_flag addAction ["Personal Garage", {nul = [true] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
			_flag addAction ["SDK Garage", {nul = [false] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
			}
		else
			{
			_flag addAction ["SDK Garage", {nul = [false] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]
			};
		};
	case "fuego":
		{
		fuego addAction ["Rest for 8 Hours", "skiptime.sqf",nil,0,false,true,"","(isPlayer _this)"];
		fuego addAction ["Clear Nearby Forest", "clearForest.sqf",nil,0,false,true,"","(isPlayer _this)"];
		fuego addAction ["On\Off Lamp", "onOffLamp.sqf",nil,0,false,true,"","(isPlayer _this)"];
		};
	case "missionGiver": {_flag addAction ["Mission Request", "Missions\missionGiver.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	};