private ["_tipo","_coste","_posicionTel","_cantidad","_cantidadMax"];

if ("Mines" in misiones) exitWith {hint "We can only deploy one minefield at a time."};

if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};

_tipo = _this select 0;

_coste = (2*(server getVariable "B_G_Soldier_exp_F")) + (["B_G_Van_01_transport_F"] call vehiclePrice);
_hr = 2;
if (_tipo == "delete") then
	{
	_coste = _coste - (server getVariable "B_G_Soldier_exp_F");
	_hr = 1;
	};
if ((server getVariable "resourcesFIA" < _coste) or (server getVariable "hr" < _hr)) exitWith {hint format ["Not enought resources to recruit a mine deploying team (%1 € and %2 HR needed)",_coste,_hr]};

if (_tipo == "delete") exitWith
	{
	hint "Explosive Specialists is available on your High Command bar.\n\nSend him anywhere on the map and he will deactivate and load in his truck any mine he may find.\n\nReturning back to HQ will unload the mines he stored in his vehicle";
	[] remoteExec ["mineSweep",HCattack];
	};

openMap true;
posicionTel = [];
hint "Click on the position you wish to build the minefield.";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;

_cantidadMax = 40;
_cantidad = 0;

if (_tipo == "ATMine") then
	{
	_cantidadMax = 20;
	_cantidad = {_x == "ATMine_Range_Mag"} count (magazineCargo caja);
	};
if (_tipo == "APERSMine") then
	{
	_cantidad = {_x == "APERSMine_Range_Mag"} count (magazineCargo caja);
	};

if (_cantidad < 5) exitWith {hint "You need at least 5 mines of this type to build a Minefield"};

if (_cantidad > _cantidadMax) then
	{
	_cantidad = _cantidadMax;
	};

[_tipo,_posicionTel,_cantidad] remoteExec ["buildMinefield",HCattack];