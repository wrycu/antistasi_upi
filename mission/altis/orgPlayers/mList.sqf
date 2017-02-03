if (!isServer and hasInterface) exitWith {};

_mList = ["123","872"];

for [{_i=0},{_i<= (count _mList)},{_i=_i+1}] do {
	diag_log (_mList select _i)
	//miembros pushBackUnique (_mList select _i);
};