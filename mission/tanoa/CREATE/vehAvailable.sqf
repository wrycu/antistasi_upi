private ["_tipo","_return","_tiempo"];
_tipo = _this select 0;

_return = false;
_tiempo = timer getVariable "_tipo";
if (!isNil "_tiempo") then
	{
	if (dateToNumber date > _tiempo) then {_return = true};
	}
else
	{
	_return = true;
	};
_return;