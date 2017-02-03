if (!isDedicated) then
	{
	if (side player == buenos) then
		{
		["gogglesPlayer"] call fn_LoadStat;
		["vestPlayer"] call fn_LoadStat;
		["outfit"] call fn_LoadStat;
		["hat"] call fn_LoadStat;
		{player removeMagazine _x} forEach magazines player;
		{player removeWeaponGlobal _x} forEach weapons player;
		removeBackpackGlobal player;
		if ("ItemGPS" in (assignedItems player)) then {player unlinkItem "ItemGPS"};
		if ((!hayTFAR) and ("ItemRadio" in (assignedItems player))) then {player unlinkItem "ItemRadio"};
		player setPos getMarkerPos "respawn_guerrila";
		if (isMultiplayer) then
			{
			if ([player] call isMember) then
				{
				["scorePlayer"] call fn_LoadStat;
				["rankPlayer"] call fn_LoadStat;
				};
			["dinero"] call fn_LoadStat;
			["personalGarage"] call fn_LoadStat;
			diag_log "Antistasi: MP Personal player stats loaded";
			}
		else
			{
			diag_log "Antistasi: SP Personal player stats loaded";
			};
		};
	};

if (!isServer) exitWith {};
statsLoaded = 0; publicVariable "statsLoaded";
//ADD STATS THAT NEED TO BE LOADED HERE.
petros allowdamage false;

["puestosFIA"] call fn_LoadStat; publicVariable "puestosFIA";
["mrkSDK"] call fn_LoadStat; mrkSDK = mrkSDK + puestosFIA; publicVariable "mrkSDK"; if (isMultiplayer) then {sleep 5};
["mrkNATO"] call fn_LoadStat;
["mrkCSAT"] call fn_LoadStat;
["destroyedCities"] call fn_LoadStat;
["minas"] call fn_LoadStat;
["cuentaCA"] call fn_LoadStat;
["antenas"] call fn_LoadStat;
["prestigeNATO"] call fn_LoadStat;
["prestigeCSAT"] call fn_LoadStat;
["hr"] call fn_LoadStat;
["armas"] call fn_LoadStat;
["municion"] call fn_LoadStat;
["items"] call fn_LoadStat;
["mochis"] call fn_LoadStat;
["fecha"] call fn_LoadStat;
["prestigeOPFOR"] call fn_LoadStat;
["prestigeBLUFOR"] call fn_LoadStat;
["resourcesFIA"] call fn_LoadStat;
["garrison"] call fn_LoadStat;
["skillFIA"] call fn_LoadStat;
["distanciaSPWN"] call fn_LoadStat;
["civPerc"] call fn_LoadStat;
["minimoFPS"] call fn_LoadStat;
//["smallCAmrk"] call fn_LoadStat;
["miembros"] call fn_LoadStat;
["unlockedItems"] call fn_LoadStat;
["unlockedMagazines"] call fn_LoadStat;
["unlockedWeapons"] call fn_LoadStat;
["unlockedBackpacks"] call fn_LoadStat;
["vehInGarage"] call fn_LoadStat;
["destroyedBuildings"] call fn_LoadStat;
["idlebases"] call fn_LoadStat;
["idleassets"] call fn_LoadStat;
//===========================================================================

unlockedRifles = unlockedweapons -  hguns -  mlaunchers - rlaunchers - ["Binocular","Laserdesignator","Rangefinder"] - srifles - mguns; publicVariable "unlockedRifles";

_marcadores = mrkSDK + mrkNATO + mrkCSAT;

{
_posicion = getMarkerPos _x;
_cercano = [_marcadores,_posicion] call BIS_fnc_nearestPosition;
if (_cercano in mrkSDK) then
	{
	if (_x in mrkNATO) then {mrkNATO = mrkNATO - [_x]};
	if (_x in mrkCSAT) then {mrkCSAT = mrkCSAT - [_x]};
	mrkSDK pushBackUnique _x;
	}
else
	{
	if (_cercano in mrkNATO) then {mrkNATO pushBackUnique _x} else {mrkCSAT pushBackUnique _x};
	};
} forEach controles;

{
if ((not(_x in mrkNATO)) and (not(_x in mrkSDK)) and (_x != "Synd_HQ") and (not(_x in mrkCSAT))) then {mrkNATO pushBack _x};
} forEach marcadores;

_marcadores = _marcadores + controles;
/*
{

if (_x in mrkSDK) then
	{
	private ["_mrkD"];
	if (_x != "Synd_HQ") then
		{
		_mrkD = format ["Dum%1",_x];
		_mrkD setMarkerColor "colorGUER";
		};
	if (_x in aeropuertos) then
		{
		_mrkD setMarkerText format ["SDK Airport: %1",count (garrison getVariable _x)];
		_mrkD setMarkerType "flag_FIA";
	    };
	if (_x in puestos) then
		{
		_mrkD setMarkerText format ["SDK Outpost: %1",count (garrison getVariable _x)];
		};
	if (_x in ciudades) then
		{
		if (_x in destroyedCities) then {[_x] call destroyCity};
		};
	if ((_x in recursos) or (_x in fabricas)) then
		{
		if (_x in recursos) then {_mrkD setMarkerText format ["Resource: %1",count (garrison getVariable _x)]} else {_mrkD setMarkerText format ["Factory: %1",count (garrison getVariable _x)]};
		if (_x in destroyedCities) then {[_x] call destroyCity};
		};
	if (_x in puertos) then
		{
		_mrkD setMarkerText format ["Sea Port: %1",count (garrison getVariable _x)];
		};
	if (_x in power) then
		{
		_mrkD setMarkerText format ["Power Plant: %1",count (garrison getVariable _x)];
		if (_x in destroyedCities) then {[_x] call destroyCity};
		};
	};

if (_x in mrkNATO) then
	{
	if (_x in destroyedCities) then {[_x] call destroyCity};
	};

} forEach _marcadores;
*/
{[_x] call mrkUpdate} forEach _marcadores;
{if (_x in destroyedCities) then {[_x] call destroyCity}} forEach ciudades;

{if (not (_x in _marcadores)) then {if (_x != "Synd_HQ") then {_marcadores pushBack _x; mrkNATO pushback _x} else {mrkNATO = mrkNATO - ["Synd_HQ"]; if (not("Synd_HQ" in mrkSDK)) then {mrkSDK = mrkSDK + ["Synd_HQ"]}}}} forEach marcadores;//por si actualizo zonas.

marcadores = _marcadores;
publicVariable "marcadores";
publicVariable "mrkNATO";
publicVariable "mrkSDK";
publicVariable "mrkCSAT";
["chopForest"] call fn_LoadStat;
["posHQ"] call fn_LoadStat;
["estaticas"] call fn_LoadStat;//tiene que ser el último para que el sleep del borrado del contenido no haga que despawneen

//call AAFassets;

if (isMultiplayer) then
	{
	{
	_jugador = _x;
	if (side _jugador == buenos) then
		{
		if ([_jugador] call isMember) then
			{
			{_jugador removeMagazine _x} forEach magazines _jugador;
			{_jugador removeWeaponGlobal _x} forEach weapons _jugador;
			removeBackpackGlobal _jugador;
			};
		_jugador setPos (getMarkerPos "respawn_guerrila");
		}
	} forEach playableUnits;
	}
else
	{
	{player removeMagazine _x} forEach magazines player;
	{player removeWeaponGlobal _x} forEach weapons player;
	removeBackpackGlobal player;
	player setPos (getMarkerPos "respawn_guerrila");
	};

[] call arsenalManage;

[[petros,"hintCS","Persistent Savegame Loaded"],"commsMP"] call BIS_fnc_MP;
diag_log "Antistasi: Server sided Persistent Load done";

sleep 25;
["tasks"] call fn_LoadStat;
/*
_tmpCAmrk = + smallCAmrk;
smallCAmrk = [];

{
_base = [_x] call findBasesForCA;
//if (_x == "puesto_13") then {_base = ""};
_radio = [_x] call radioCheck;
if ((_base != "") and (_radio) and (_x in mrkSDK) and (not(_x in smallCAmrk))) then
	{
	[_x] remoteExec ["patrolCA",HCattack];
	sleep 5;
	smallCAmrk pushBackUnique _x;
	[_x] remoteExec ["autoGarrison",HCattack];
	};
} forEach _tmpCAmrk;
publicVariable "smallCAmrk";
*/
petros allowdamage true;
//END
//hint "Stats loaded";
