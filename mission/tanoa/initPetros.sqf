removeHeadgear petros;
removeGoggles petros;
petros setSkill 1;
petros setVariable ["inconsciente",false,true];
petros setVariable ["respawning",false];
petros allowDamage false;
[petros, "srifle_DMR_06_camo_F", 8, 0] call BIS_fnc_addWeapon;
petros selectWeapon (primaryWeapon petros);
petros addEventHandler ["HandleDamage",
        {
        private ["_unit","_part","_dam","_injurer"];
        _part = _this select 1;
        _dam = _this select 2;
        _injurer = _this select 3;

        if (isPlayer _injurer) then
            {
            if (side _injurer == buenos) then
                {
                [_injurer,60] remoteExec ["castigo",_injurer];
                _dam = 0;
                };
            };
        if ((isNull _injurer) or (_injurer == petros)) then {_dam = 0};
        if (_part == "") then
            {
            if (_dam > 0.95) then
                {
                if (!(petros getVariable "inconsciente")) then
                    {
                    _dam = 0.9;
                    [petros] spawn inconsciente;
                    }
                else
                    {
                    petros removeAllEventHandlers "HandleDamage";
                    };
                };
            };
        _dam
        }];

petros addMPEventHandler ["mpkilled",
    {
    removeAllActions petros;
    _killer = _this select 1;
    if (isServer) then
        {
        if ((side _killer == muyMalos) or (side _killer == malos)) then
             {
            _nul = [] spawn
                {
                garrison setVariable ["Synd_HQ",[],true];
                for "_i" from 0 to round random 3 do
                    {
                    if (count unlockedWeapons > 2) then
                        {
                        _cosa = selectRandom unlockedWeapons;
                        unlockedWeapons = unlockedWeapons - [_cosa];
                        lockedWeapons = lockedWeapons + [_cosa];
                        if (_cosa in unlockedRifles) then {unlockedRifles = unlockedRifles - [_cosa]};
                        };
                    };
                publicVariable "unlockedWeapons";
                for "_i" from 0 to round random 8 do
                    {
                    _cosa = selectRandom unlockedMagazines;
                    if (!isNil "_cosa") then {unlockedMagazines = unlockedMagazines - [_cosa]};
                    };
                publicVariable "unlockedMagazines";
                for "_i" from 0 to round random 5 do
                    {
                    _cosa = selectRandom (unlockedItems - ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit"]);
                    unlockedItems = unlockedItems - [_cosa];
                    if (_cosa in unlockedOptics) then {unlockedOptics = unlockedOptics - [_cosa]; publicVariable "unlockedOptics"};
                    };
                publicVariable "unlockedItems";
                clearMagazineCargoGlobal caja;
                clearWeaponCargoGlobal caja;
                clearItemCargoGlobal caja;
                clearBackpackCargoGlobal caja;
                waitUntil {sleep 6; isPlayer stavros};
                [] remoteExec ["placementSelection",stavros];
               };
            if (!isPlayer stavros) then
                {
                {["petrosDead",false,1,false,false] remoteExec ["BIS_fnc_endMission",_x]} forEach (playableUnits select {(side _x != buenos) and (side _x != civilian)})
                }
            else
                {
                {
                if (side _x == malos) then {_x setPos (getMarkerPos "respawn_west")};
                } forEach playableUnits;
                };
            }
        else
            {
            _viejo = petros;
            grupoPetros = createGroup buenos;
            publicVariable "grupoPetros";
            petros = grupoPetros createUnit ["I_C_Soldier_Camo_F", position _viejo, [], 0, "NONE"];
            publicVariable "petros";
            grupoPetros setGroupId ["Maru","GroupColor4"];
            petros setIdentity "amiguete";
            petros setName "Maru";
            petros disableAI "MOVE";
            petros disableAI "AUTOTARGET";
            if (group _viejo == grupoPetros) then {[Petros,"mission"]remoteExec ["flagaction",[buenos,civilian],petros]} else {[Petros,"buildHQ"] remoteExec ["flagaction",[buenos,civilian],petros]};
            [] execVM "initPetros.sqf";
            deleteVehicle _viejo;
            };
        };
   }];
sleep 120;
petros allowDamage true;
