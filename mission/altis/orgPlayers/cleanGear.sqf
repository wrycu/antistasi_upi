private ["_items","_gps"];

_gps = false;

removeAllWeapons player;

_items = assignedItems player;
if ("ItemGPS" in _items) then {_gps = true};
removeAllAssignedItems player;
removeAllItems player;
removeVest player;
removeBackpack player;

player addBackpack "B_TacticalPack_blk";
if (_gps) then {player addItemToBackpack "ItemGPS"; player assignItem "ItemGPS";};

player addItemToBackpack "ItemMap";
player assignItem "ItemMap";
player addItemToBackpack "ItemCompass";
player assignItem "ItemCompass";