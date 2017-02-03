//if (player != Stavros) exitWith {hint "Only Commander can ask for NATO support"};
_tipo = _this select 0;

if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};
if (_tipo in misiones) exitWith {hint "NATO is already busy with this kind of mission"};
if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};

_s = antenas - mrkAAF;
_c = 0;

if (count _s > 0) then {
	for [{_i=0},{_i<=((count _s)-1)},{_i=_i+1}] do {
		_antenna = _s select _i;
		_cercano = [marcadores, getPos _antenna] call BIS_fnc_nearestPosition;
		if (_cercano in mrkFIA) then {_c = _c + 1};
	};
};

if (_c < 1) exitWith {
	_l1 = ["Radio Operator", "I cannot get NATO on the horn. I might have more luck if I were able to jerry-rig this radio to a proper radio tower..."];
	[[_l1],"SIDE",0.15] execVM "createConv.sqf";
};

_bases = bases - mrkAAF;

if (((_tipo == "NATOArty") or (_tipo == "NATOArmor") or (_tipo == "NATORoadblock")) and (count _bases == 0)) exitWith {hint "You need to conquer at least one base to perform this action"};

_costeNATO = 5;
_textoHint = "";
if (_tipo == "NATOCA") then {_costeNATO = 20;_textohint = "Click on the Base or Airport you want NATO to attack"};
if (_tipo == "NATOArmor") then {_costeNATO = 20;_textohint = "Click on the Base from which you want NATO to attack"};
if (_tipo == "NATOAmmo") then {_textohint = "Click on the spot where you want the Ammodrop"};
if ((_tipo == "NATOArty") or (_tipo == "NATOCAS")) then {_costeNATO = 10; _textohint = "Click on the base from which you want Artillery Support"};
if (_tipo == "NATORoadblock") then {_costeNATO = 10;_textohint = "Click on the spot where you want the roadblock"};

_NATOSupp = server getVariable "prestigeNATO";

if (_NATOSupp < _costeNATO) exitWith {hint format ["We lack of enough NATO Support in order to proceed with this request (%1 needed)",_costeNATO]};

//if (_tipo == "NATOCAS") exitWith {[[],_tipo, false] call BIS_fnc_MP};
if (_tipo == "NATOCAS") exitWith {[] remoteExec [_tipo,HCattack]};
//if (_tipo == "NATOArty") exitWith {[] remoteExec [_tipo,HCattack]};
if (_tipo == "NATOUAV") exitWith {[] remoteExec [_tipo,HCattack]};

posicionTel = [];

hint format ["%1",_textohint];

openMap true;
onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;
if ((_tipo != "NATOArmor") or (_tipo == "NATORoadblock")) then {openMap false};
_salir = false;

if (_tipo == "NATORoadblock") exitWith {
	_check = isOnRoad _posicionTel;
	if !(_check) exitWith {hint "Roadblocks can only be placed on roads."};
	[_posicionTel] remoteExec [_tipo,HCattack];
};


//if (_tipo == "NATOAmmo") exitWith {[[_posiciontel,_NATOSupp],_tipo] call BIS_fnc_MP;};
if (_tipo == "NATOAmmo") exitWith {[_posiciontel,_NATOSupp] remoteExec [_tipo,HCattack]};

_sitio = [marcadores, _posicionTel] call BIS_Fnc_nearestPosition;

if (_posicionTel distance getMarkerPos _sitio > 50) exitWith {hint "You must click near a map marker"};

if (_tipo == "NATOArty") exitWith {
	if (not(_sitio in _bases)) exitWith {hint "Artillery support can only be obtained from bases."};
	[_sitio] remoteExec [_tipo,HCattack];
};

// if ((_tipo == "NATOArty") or (_tipo == "NATOArmor")) then
if (_tipo == "NATOArmor") then
	{
	if (not(_sitio in _bases)) then
		{
		_salir = true;
		hint "You must click near a friendly base";
		}
	else
		{
		if (_tipo == "NATOArmor") then
			{
			posicionTel = [];

			hint "Click on the Armored Column destination";

			openMap true;
			onMapSingleClick "posicionTel = _pos;";

			waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
			onMapSingleClick "";

			if (!visibleMap) then {_salir = true};

			_posicionTel = posicionTel;
			openMap false;
			_destino = [marcadores, _posicionTel] call BIS_Fnc_nearestPosition;
			if (_posicionTel distance getMarkerPos _destino > 50) then
				{
				hint "You must click near a map marker";
				_salir = true
				}
			else
				{
				///[[_sitio,_destino],_tipo, false] call BIS_fnc_MP;
				[_sitio,_destino] remoteExec ["NATOArmor",HCattack];
				};
			};
		};
	};

if (_tipo == "NATOCA") then
	{
	if ((_sitio in ciudades) or (_sitio in controles) or (_sitio in colinas)) then {_salir = true; hint "NATO won't attack this kind of zone."};
	if (_sitio in mrkFIA) then {_salir = true; hint "NATO Attacks may be only ordered on AAF controlled zones"};
	};

if (_salir) exitWith {};

if ((_tipo == "NATOCA") or (_tipo == "NATOArty")) then
	{
	[_sitio] remoteExec [_tipo,HCattack];
	};
