if (!isServer) exitWith{};

scriptName "resyncArsenal";

publicVariable "unlockedWeapons";
publicVariable "unlockedMagazines";
publicVariable "unlockedItems";
publicVariable "unlockedBackpacks";

[caja,unlockedWeapons,true,false] call BIS_fnc_addVirtualWeaponCargo;
[caja,unlockedMagazines,true,false] call BIS_fnc_addVirtualMagazineCargo;
[caja,unlockedItems,true,false] call BIS_fnc_addVirtualItemCargo;
[caja,unlockedBackpacks,true,false] call BIS_fnc_addVirtualBackpackCargo;

[[petros,"hint","Arsenal synchronized"],"commsMP"] call BIS_fnc_MP;