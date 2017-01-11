_tiempo = _this select 0;
_mayor = if (_tiempo >= 3600) then {true} else {false};
_tiempo = _tiempo - (lastIncome) - (50*(count (mrkSDK - puestosFIA)));

if (_tiempo < 0) then {_tiempo = 0};

cuentaCA = cuentaCA + round (random _tiempo);

if (_mayor and (cuentaCA < 1200)) then {cuentaCA = 1200};
publicVariable "cuentaCA";




