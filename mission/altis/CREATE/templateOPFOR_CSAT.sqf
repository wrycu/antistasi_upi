// (un-)armed transport helicopters
opHeliTrans = 		["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];

// helicopter that dismounts troops
opHeliDismount = 	"O_Heli_Transport_04_bench_F"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"O_Heli_Light_02_unarmed_F"; // PO-30 Orca (Unarmed)

// gunship
opGunship = 		"O_Heli_Attack_02_F"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			"O_Plane_CAS_02_F"; // To-199 Neophron (CAS)

// small UAV (Darter, etc)
opUAVsmall = 		"O_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F","O_Heli_Attack_02_F","O_Plane_CAS_02_F","O_Heli_Light_02_F"];

// self-propelled anti air
opSPAA = 			"O_APC_Tracked_02_AA_F";

opTruck = 			"O_Truck_02_transport_F";

opMRAPu = 			"O_MRAP_02_F";

// infantry classes, to allow for class-specific skill adjustments and pricing
opIOfficer = 		"O_officer_F"; // officer/official
opIPilot = 			"O_helipilot_F"; // pilot
opIOfficer_2 = 		"O_G_officer_F"; // officer/traitor
opIUSL = 			"O_SoldierU_SL_F"; // squad leader, urban camo
opIURifle = 		"O_soldierU_F"; // rifleman, urban camo
opICrew = 			"O_crew_F"; // crew

opGroupAA = 		"OIA_InfTeam_AA";


// config path for infantry groups
opCfgInf = 			(configfile >> "CfgGroups" >> "east" >> "OPF_F" >> "Infantry");

// standard group arrays, used for spawning groups
opISniper = 		"OI_SniperTeam"; // sniper team
opISpecOps = 		"OI_reconTeam"; // spec opcs
opISquad = 			"OIA_InfSquad"; // squad

// the affiliation
side_red = 			east;

opFlag = 			"Flag_CSAT_F";