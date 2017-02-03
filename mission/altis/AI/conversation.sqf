_unit = _this select 0;
_jugador = _this select 1;

if (!alive _unit) exitWith {};

/*
_jugador globalChat "Petros is looking for some dwarves for a little side project of his. Word on the street is that if you require specialities, Nomad is the guy to talk to.";

sleep 6;

//if (round random 100 < 50) then {
//	_unit globalChat "Luckily for you, an associate of mine just received a fresh shipment of merchandise. I'll have him get in touch with Petros.";
//}
//else {
	_unit globalChat "Ol' Petros is into smut again, isn't he? After what happened to the last score of live merchandise, he's been blacklisted. Tell him that. If he wants the goods again, he needs to poke a hockey stick with the intangible concept of a pejorative plutocracy.";
	sleep 8;
	_jugador globalChat "Huh?";
	sleep 2;
	_unit globalChat "Swallow the sunshine baboon.";
	sleep 3;
	_jugador globalChat "What now?";
	sleep 2;
	_unit globalChat "Handing a turban to the planet Jupiter.";
	sleep 3;
	_jugador globalChat "Are you high?";
	sleep 2;
	_unit globalChat "Garnish the glory-giver.";
	sleep 3;
	_jugador globalChat "Ahhhh... how about I become your strawberry instead?";
	sleep 3;
	_unit globalChat "Piss off.";
//};
*/

line2 = [name _jugador, "Petros is looking for some dwarves for a little side project of his. Word on the street is that if you require specialities, Devin is the guy to talk to."];
line3 = ["Devin", "Ol' Petros is into smut again, isn't he? After what happened to the last score of live merchandise, he's been blacklisted. Tell him that. If he wants the goods again, he needs to poke a hockey stick with the intangible concept of a pejorative plutocracy."];
line4 = [name _jugador, "Huh?"];
line5 = ["Devin", "Swallow the sunshine baboon."];
line6 = [name _jugador, "What now?"];
line7 = ["Devin", "Handing a turban to the planet Jupiter."];
line8 = [name _jugador, "Are you high?"];
line9 = ["Devin", "Garnish the glory-giver."];
line10 = [name _jugador, "Ahhhh... how about I become your strawberry instead?"];
line11 = ["Devin", "Piss off."];

[[line2,line3,line4,line5,line6,line7,line8,line9,line10,line11],"DIRECT",0.15] execVM "createConv.sqf";