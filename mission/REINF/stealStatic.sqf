private ["_estatica","_cercano","_jugador"];

_estatica = _this select 0;
_jugador = _this select 1;

if (!alive _estatica) exitWith {hint "You cannot steal a destroyed static weapon"};

if (alive gunner _estatica) exitWith {hint "You cannot steal a static weapon when someone is using it"};

if ((alive assignedGunner _estatica) and (!isPlayer (assignedGunner _estatica))) exitWith {hint "The gunner of this static weapon is still alive"};

_cercano = [marcadores,_estatica] call BIS_fnc_nearestPosition;

if (not(_cercano in mrkSDK)) exitWith {hint "You have to conquer this zone in order to be able to steal this Static Weapon"};

_estatica setOwner (owner _jugador);

_tipoEst = typeOf _estatica;

_tipoB1 = "I_AT_01_weapon_F";
_tipoB2 = "I_HMG_01_support_F";

switch _tipoEst do
	{
	case staticATmalos: {_tipoB1 = "B_AT_01_weapon_F"; _tipoB2 = "B_HMG_01_support_F"};
	case staticATmuyMalos: {_tipoB1 = "O_AT_01_weapon_F"; _tipoB2 = "O_HMG_01_support_F"};
	case NATOMortar: {_tipoB1 = "B_Mortar_01_weapon_F"; _tipoB2 = "B_Mortar_01_support_F"};
	case NATOMG: {_tipoB1 = "B_HMG_01_high_weapon_F"; _tipoB2 = "B_HMG_01_support_high_F";};
	case CSATMG: {_tipoB1 = "O_HMG_01_high_weapon_F"; _tipoB2 = "O_HMG_01_support_high_F";};
	case "I_HMG_01_high_F": {_tipoB1 = "I_HMG_01_high_weapon_F"; _tipoB2 = "I_HMG_01_support_high_F";};
	case "I_static_AA_F": {_tipoB1 = "I_AA_01_weapon_F"};
	case SDKMortar: {_tipoB1 = "I_Mortar_01_weapon_F"; _tipoB2 = "I_Mortar_01_support_F"};
	};

_posicion1 = [_jugador, 1, (getDir _jugador) - 90] call BIS_fnc_relPos;
_posicion2 = [_jugador, 1, (getDir _jugador) + 90] call BIS_fnc_relPos;

deleteVehicle _estatica;

_bag1 = _tipoB1 createVehicle _posicion1;
_bag2 = _tipoB2 createVehicle _posicion2;

[_bag1] call AIVEHinit;
[_bag2] call AIVEHinit;

hint "Weapon Stolen. It won't despawn when you assemble it again";