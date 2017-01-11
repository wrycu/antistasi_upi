//Antistasi var settings
//If some setting can be modified it will be commented with a // after it.
//Make changes at your own risk!!
//You do not have enough balls to make any modification and after making a Bug report because something is wrong. You don't wanna be there. Believe me.
//Not commented lines cannot be changed.
//Don't touch them.
antistasiVersion = "v 0.5.1";

servidoresOficiales = ["Antistasi Official EU","Antistasi Official EU - TEST"];//this is for author's fine tune the official servers. If I get you including your server in this variable, I will create a special variable for your server. Understand?

debug = false;//debug variable, not useful for everything..

cleantime = 900;//time to delete dead bodies, vehicles etc..
distanciaSPWN = 1000;//initial spawn distance. Less than 1Km makes parked vehicles spawn in your nose while you approach.
musicON = true;
civPerc = 0.05;//initial % civ spawn rate
posHQ = getMarkerPos "respawn_guerrila";
minimoFPS = 15;//initial FPS minimum.
autoHeal = false;
allowPlayerRecruit = true;
recruitCooldown = 0;
AAFpatrols = 0;//0
planesAAFcurrent = 0;
helisAAFcurrent = 0;
APCAAFcurrent = 0;
tanksAAFcurrent= 0;
savingClient = false;
incomeRep = false;
zoneCheckInProgress = false;
distanciaMiss = 2500;
minMags = 20;
minWeaps = 12;
minPacks = 20;
minItems = 20;
minOptics = 12;

buenos = independent;
malos = west;
muyMalos = east;


staticATmalos = "B_T_static_AT_F";
staticATmuyMalos = "O_T_static_AT_F";
staticATBuenos = "I_Static_AT_F";
staticAABuenos = "I_Static_AA_F";
NATOMortar = "B_T_Mortar_01_F";
CSATMortar = "O_Mortar_01_F";
SDKMortar = "I_G_Mortar_01_F";
NATOMG = "B_HMG_01_high_F";
CSATMG = "O_HMG_01_high_F";
SDKMGStatic = "I_HMG_01_high_F";
staticCrewMalos = "B_T_support_MG_F";
staticCrewMuyMalos = "O_T_support_MG_F";
staticCrewBuenos = "I_G_Soldier_unarmed_F";

NATOPilot = "B_T_Pilot_F";
//vehNATOLightArmed = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_armed_F"];
vehNATOLightArmed = ["B_T_LSV_01_armed_F"];
vehNATOLightUnarmed = ["B_T_MRAP_01_F","B_T_LSV_01_unarmed_F"];
vehNATOTrucks = ["B_T_Truck_01_transport_F","B_T_Truck_01_covered_F"];
vehNATOAmmoTruck = "B_T_Truck_01_ammo_F";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
vehNATOAPC = ["B_T_APC_Wheeled_01_cannon_F","B_T_APC_Tracked_01_rcws_F"];//"B_T_APC_Tracked_01_CRV_F" has no cargo seats
vehNATOTank = "B_T_MBT_01_cannon_F";
vehNATOAA = "B_T_APC_Tracked_01_AA_F";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
vehNATOBoat = "B_T_Boat_Armed_01_minigun_F";
vehNATORBoat = "B_T_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"B_T_APC_Wheeled_01_cannon_F"];
vehNATOPlane = "B_Plane_CAS_01_F";
vehNATOPatrolHeli = "B_Heli_Light_01_F";
vehNATOTransportHelis = ["B_T_VTOL_01_infantry_F","B_Heli_Transport_03_F",vehNATOPatrolHeli,"B_Heli_Transport_01_camo_F"];
vehNATOAttackHelis = ["B_T_VTOL_01_armed_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane];
vehNATOUAV = "B_UAV_02_F";
vehNATOUAVSmall = "B_UAV_01_F";
vehNATOMRLS = "B_T_MBT_01_mrls_F";
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, "B_T_Truck_01_fuel_F", "B_T_Truck_01_medical_F", "B_T_Truck_01_repair_F","B_T_APC_Tracked_01_CRV_F"];
NATOFlag = "Flag_NATO_F";
cfgNATOInf = (configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry");
gruposNATOSentry = "B_T_InfSentry";
gruposNATOsmall = [gruposNATOSentry,"B_T_SniperTeam","B_T_ReconSentry"];
gruposNATOmid = ["B_T_InfTeam","B_T_InfTeam_AA","B_T_InfTeam_AT"];
NATOSquad = "B_T_InfSquad";
NATOSpecOp = (configfile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad");
gruposNATOSquad = [NATOSquad,"B_T_InfSquad_Weapons"];
NATOGrunt = "B_T_Soldier_F";
NATOOfficer = "B_T_Officer_F";
NATOBodyG = "B_CTRG_Soldier_tna_F";
NATOCrew = "B_T_Crew_F";
NATOUnarmed = "B_G_Survivor_F";
NATOMarksman = "B_T_Soldier_M_F";

FIARifleman = "B_G_Soldier_F";
FIAMarksman = "B_G_Sharpshooter_F";
vehFIAArmedCar = "B_G_Offroad_01_armed_F";
vehFIATruck = "B_G_van_01_transport_F";
vehFIACar = "B_G_Offroad_01_F";
cfgFIAInf = (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry");
gruposFIASmall = ["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];
gruposFIAMid = ["IRG_InfAssault","IRG_InfTeam","IRG_InfTeam_AT"];
FIASquad = "IRG_InfSquad";

vehPoliceCar = "B_GEN_OFFROAD_01_gen_F";

CSATPilot = "O_T_Pilot_F";
vehCSATLightArmed = ["O_T_MRAP_02_gmg_ghex_F","O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
vehCSATLightUnarmed = ["O_T_MRAP_02_ghex_F","O_T_LSV_02_unarmed_F"];
vehCSATTrucks = ["O_T_Truck_03_transport_ghex_F","O_T_Truck_03_covered_ghex_F"];
vehCSATAmmoTruck = "O_T_Truck_03_ammo_ghex_F";
vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;
vehCSATAPC = ["O_T_APC_Wheeled_02_rcws_ghex_F","O_T_APC_Tracked_02_cannon_ghex_F"];
vehCSATTank = "O_T_MBT_02_cannon_ghex_F";
vehCSATAA = "O_T_APC_Tracked_02_AA_ghex_F";
vehCSATAttack = vehCSATAPC + [vehCSATTank];
vehCSATBoat = "O_T_Boat_Armed_01_hmg_F";
vehCSATRBoat = "O_T_Boat_Transport_01_F";
vehCSATBoats = [vehCSATBoat,vehCSATRBoat,"O_T_APC_Wheeled_02_rcws_ghex_F"];
vehCSATPlane = "O_Plane_CAS_02_F";
vehCSATPatrolHeli = "O_Heli_Light_02_unarmed_F";
vehCSATTransportHelis = ["O_T_VTOL_02_infantry_F","O_Heli_Transport_04_bench_F",vehCSATPatrolHeli];
vehCSATAttackHelis = ["O_Heli_Light_02_F","O_Heli_Attack_02_F"];
vehCSATAir = vehCSATTransportHelis + vehCSATAttackHelis + [vehCSATPlane];
vehCSATUAV = "O_UAV_02_F";
vehCSATUAVSmall = "O_UAV_01_F";
vehCSATMRLS = "O_T_MBT_02_arty_ghex_F";
vehCSATNormal = vehCSATLight + vehCSATTrucks + [vehCSATAmmoTruck, "O_T_Truck_03_fuel_ghex_F", "O_T_Truck_03_medical_ghex_F", "O_T_Truck_03_repair_ghex_F"];
CSATFlag = "Flag_CSAT_F";
cfgCSATInf = (configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry");
gruposCSATSentry = "O_T_InfSentry";
gruposCSATsmall = [gruposCSATSentry,"O_T_reconSentry","O_T_SniperTeam"];
gruposCSATmid = ["O_T_InfTeam","O_T_InfTeam_AA","O_T_InfTeam_AT"];
CSATSquad = "O_T_InfSquad";
CSATSpecOp = (configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "SpecOps" >> "O_T_ViperTeam");
gruposCSATSquad = [CSATSquad,"O_T_InfSquad_Weapons"];
CSATGrunt = "O_T_Soldier_F";
CSATOfficer = "O_T_Officer_F";
CSATBodyG = "O_V_Soldier_ghex_F";
CSATCrew = "O_T_Crew_F";
CSATMarksman = "O_T_Soldier_M_F";

SDKSniper = ["I_C_Soldier_Bandit_5_F","I_C_Soldier_Para_7_F"];
SDKATman = ["I_C_Soldier_Bandit_2_F","I_C_Soldier_Para_5_F"];
SDKMedic = ["I_C_Soldier_Bandit_1_F","I_C_Soldier_Para_3_F"];
SDKMG = ["I_C_Soldier_Bandit_3_F","I_C_Soldier_Para_4_F"];
SDKExp = ["I_C_Soldier_Bandit_8_F","I_C_Soldier_Para_8_F"];
SDKGL = ["I_C_Soldier_Bandit_6_F","I_C_Soldier_Para_6_F"];
SDKMil = ["I_C_Soldier_Bandit_7_F","I_C_Soldier_Para_1_F"];
SDKSL = ["I_C_Soldier_Bandit_4_F","I_C_Soldier_Para_2_F"];
SDKEng = ["I_G_engineer_F","I_G_engineer_F"];
sdkTier1 = SDKMil + [staticCrewBuenos];
sdkTier2 = SDKMedic + SDKMG + SDKExp + SDKGL + SDKEng;
sdkTier3 = SDKATman + SDKSL + SDKSniper;
soldadosSDK = sdkTier1 + sdkTier2 + sdkTier3;
vehSDKBike = "I_G_Quadbike_01_F";
vehSDKLightArmed = "I_G_Offroad_01_armed_F";
vehSDKLightUnarmed = "I_C_Offroad_02_unarmed_F";
vehSDKTruck = "I_C_Van_01_Transport_F";
vehSDKHeli = "I_C_Heli_Light_01_civil_F";
vehSDKPlane = "I_C_Plane_civil_01_F";
vehSDKBoat = "I_C_Boat_Transport_01_F";
vehSDKRepair = "B_G_Offroad_01_repair_F";
vehFIA = [vehSDKBike,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATBuenos,staticAABuenos,vehSDKRepair];
SDKFlag = "Flag_Syndikat_F";
gruposSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
gruposSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
//["BanditShockTeam","ParaShockTeam"];
gruposSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
gruposSDKSniper = [SDKSniper,SDKSniper];
gruposSDKSentry = [SDKGL,SDKMil];
SDKUnarmed = "I_G_Survivor_F";

vehNormal = vehNATONormal + vehCSATNormal + [vehFIATruck,vehSDKTruck,vehSDKLightArmed,vehSDKBike,vehSDKRepair];
vehBoats = [vehNATOBoat,vehCSATBoat,vehSDKBoat];
vehAttack = vehNATOAttack + vehCSATAttack;
vehPlanes = vehNATOAir + vehCSATAir + [vehSDKPlane];
vehAttackHelis = vehCSATAttackHelis + vehNATOAttackHelis;
vehUAVs = [vehNATOUAV,vehCSATUAV];
vehAmmoTrucks = [vehNATOAmmoTruck,vehCSATAmmoTruck];
vehAPCs = vehNATOAPC + vehCSATAPC;
vehTanks = [vehNATOTank,vehCSATTank];
vehTrucks = vehNATOTrucks + vehCSATTrucks + [vehSDKTruck,vehFIATruck];
vehAA = [vehNATOAA,vehCSATAA];
vehMRLS = [vehCSATMRLS, vehNATOMRLS];
vehTransportAir = vehNATOTransportHelis + vehCSATTransportHelis + [vehSDKHeli];
vehFastRope = ["O_Heli_Light_02_unarmed_F","B_Heli_Transport_01_camo_F"];
sniperGroups = ["B_T_SniperTeam","O_T_SniperTeam"];
sniperUnits = ["O_T_Soldier_M_F","O_T_Sniper_F","O_T_ghillie_tna_F","O_V_Soldier_M_ghex_F","B_CTRG_Soldier_M_tna_F","B_T_soldier_M_F","B_T_Sniper_F","B_T_ghillie_tna_F"];

arrayCivs = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_scientist_F","C_Orestes","C_Nikos","C_Nikos_aged","C_Man_casual_1_F_tanoan","C_Man_casual_2_F_tanoan","C_Man_casual_3_F_tanoan","C_man_sport_1_F_tanoan","C_man_sport_2_F_tanoan","C_man_sport_3_F_tanoan","C_Man_casual_4_F_tanoan","C_Man_casual_5_F_tanoan","C_Man_casual_6_F_tanoan"];//array of possible civs. Only euro types picked (this is Greece). Add any civ classnames you wish here
arrayCivVeh =["C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F","C_Truck_02_transport_F","C_Truck_02_covered_F","C_Offroad_02_unarmed_F"];//possible civ vehicles. Add any mod classnames you wish here
civBoats = ["C_Boat_Civil_01_F","C_Scooter_Transport_01_F","C_Boat_Transport_02_F","C_Rubberboat"];
humo = ["SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellBlue","SmokeShellYellow","SmokeShellPurple","SmokeShellOrange"];
titanLaunchers = ["launch_B_Titan_F","launch_I_Titan_F","launch_O_Titan_ghex_F","launch_O_Titan_F","launch_B_Titan_tna_F"];
lamptypes = ["Lamps_Base_F", "PowerLines_base_F","Land_LampDecor_F","Land_LampHalogen_F","Land_LampHarbour_F","Land_LampShabby_F","Land_NavigLight","Land_runway_edgelight","Land_PowerPoleWooden_L_F"];
arrayids = ["Anthis","Costa","Dimitirou","Elias","Gekas","Kouris","Leventis","Markos","Nikas","Nicolo","Panas","Rosi","Samaras","Thanos","Vega"];
if (isMultiplayer) then {arrayids = arrayids + ["protagonista"]};
antitanqueAAF = ["launch_I_Titan_F","launch_I_Titan_short_F"];//possible Titan weapons that spawn in  ammoboxes
MantitanqueAAF = ["Titan_AT", "Titan_AP", "Titan_AA"];//possible Titan rockets that spawn in  ammoboxes
minasAAF = ["SLAMDirectionalMine_Wire_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag", "ATMine_Range_Mag","APERSTripMine_Wire_Mag","APERSMine_Range_Mag", "APERSBoundingMine_Range_Mag"];//possible mines that spawn in AAF ammoboxescomment "Exported from Arsenal by Alberto";

itemsAAF = ["FirstAidKit","Medikit","MineDetector","NVGoggles","ToolKit","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_acp","bipod_03_F_oli","muzzle_snds_338_green","muzzle_snds_93mmg_tan","Rangefinder","Laserdesignator","ItemGPS","acc_pointer_IR","ItemRadio"];//possible items that spawn in AAF ammoboxes
NVGoggles = ["NVGoggles_OPFOR","NVGoggles_INDEP","O_NVGoggles_hex_F","O_NVGoggles_urb_F","O_NVGoggles_ghex_F","NVGoggles_tna_F","NVGogglesB_blk_F","NVGogglesB_grn_F","NVGogglesB_gry_F"];
opticasAAF = ["optic_Arco","optic_Hamr","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","optic_SOS","optic_MRCO","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg","optic_DMS","optic_Yorris","optic_MRD","optic_LRPS","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_blk","optic_KHS_hex","optic_KHS_old","optic_KHS_tan","optic_Arco_blk_F","optic_Arco_ghex_F","optic_DMS_ghex_F","optic_Hamr_khk_F","optic_ERCO_blk_F","optic_ERCO_khk_F","optic_ERCO_snd_F","optic_SOS_khk_F","optic_LRPS_tna_F","optic_LRPS_ghex_F","optic_Holosight_blk_F","optic_Holosight_khk_F","optic_Holosight_smg_blk_F"];
armasNATO = ["arifle_MX_F","arifle_MX_GL_F","arifle_MX_SW_F","srifle_EBR_F","srifle_LRR_F","srifle_DMR_03_F","srifle_DMR_02_F","MMG_02_sand_F","arifle_MXM_F","SMG_01_F","arifle_AK12_F","arifle_AK12_GL_F"];//possible weapons that spawn in NATO ammoboxes
armasCSAT = ["srifle_DMR_01_F","LMG_Zafir_F","hgun_Pistol_heavy_02_F","arifle_Katiba_F","MMG_01_hex_F","srifle_DMR_04_F","arifle_Katiba_GL_F","SMG_02_F","srifle_GM6_camo_F","srifle_DMR_05_blk_F","arifle_AK12_F","arifle_AK12_GL_F"];
municionNATO = ["30Rnd_65x39_Caseless_mag","30Rnd_65x39_caseless_mag_Tracer","100Rnd_65x39_Caseless_mag","100Rnd_65x39_caseless_mag_Tracer","20Rnd_762x51_Mag","7Rnd_408_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_tracer_green","11Rnd_45ACP_Mag","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","1Rnd_Smoke_Grenade_shell","3Rnd_HE_Grenade_shell","HandGrenade","20Rnd_762x51_Mag","10Rnd_338_Mag","130Rnd_338_Mag"];//possible ammo that spawn in NATO ammoboxes
municionCSAT = ["30Rnd_65x39_caseless_green","10Rnd_762x54_Mag","150Rnd_762x54_Box","6Rnd_45ACP_Cylinder","150Rnd_93x64_Mag","10Rnd_127x54_Mag","30Rnd_9x21_Mag","5Rnd_127x108_Mag","10Rnd_93x64_DMR_05_Mag"];

cascos = ["H_HelmetB","H_HelmetB_camo","H_HelmetB_light","H_HelmetSpecB","H_HelmetSpecB_paint1","H_HelmetSpecB_paint2","H_HelmetSpecB_blk","H_HelmetSpecB_snakeskin","H_HelmetSpecB_sand","H_HelmetIA","H_HelmetB_grass","H_HelmetB_snakeskin","H_HelmetB_desert","H_HelmetB_black","H_HelmetB_sand","H_HelmetCrew_B","H_HelmetCrew_O","H_HelmetCrew_I","H_PilotHelmetFighter_B","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_PilotHelmetHeli_I","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_HelmetB_light_grass","H_HelmetB_light_snakeskin","H_HelmetB_light_desert","H_HelmetB_light_black","H_HelmetB_light_sand","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_RacingHelmet_1_F","H_RacingHelmet_2_F","H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_red_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_RacingHelmet_1_orange_F","H_Helmet_Skate","H_HelmetB_TI_tna_F","H_HelmetO_ViperSP_hex_F","H_HelmetO_ViperSP_ghex_F","H_HelmetB_tna_F","H_HelmetB_Enh_tna_F","H_HelmetB_Light_tna_F","H_HelmetSpecO_ghex_F","H_HelmetLeaderO_ghex_F","H_HelmetO_ghex_F","H_HelmetCrew_O_ghex_F","H_HelmetB_paint","H_HelmetB_plain_mcamo","H_HelmetB_plain_blk","H_HelmetIA_net","H_HelmetIA_camo"];
lockedMochis = ["Bag_Base","B_AssaultPack_Base","B_AssaultPack_khk","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_sgg","B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_mcamo","B_AssaultPack_ocamo","B_Kitbag_Base","B_Kitbag_rgr","B_Kitbag_mcamo","B_Kitbag_sgg","B_Kitbag_cbr","B_TacticalPack_Base","B_TacticalPack_rgr","B_TacticalPack_mcamo","B_TacticalPack_ocamo","B_TacticalPack_blk","B_TacticalPack_oli","B_FieldPack_Base","B_FieldPack_khk","B_FieldPack_ocamo","B_FieldPack_oucamo","B_FieldPack_cbr","B_FieldPack_blk","B_Carryall_Base","B_Carryall_ocamo","B_Carryall_oucamo","B_Carryall_mcamo","B_Carryall_khk","B_Carryall_cbr","B_Bergen_Base","B_Bergen_sgg","B_Bergen_mcamo","B_Bergen_rgr","B_Bergen_blk","B_OutdoorPack_Base","B_OutdoorPack_blk","B_OutdoorPack_tan","B_OutdoorPack_blu","B_HuntingBackpack","B_AssaultPackG","B_BergenG","B_BergenC_Base","B_BergenC_red","B_BergenC_grn","B_BergenC_blu","B_Parachute","B_FieldPack_oli","B_Carryall_oli","G_AssaultPack","G_Bergen","C_Bergen_Base","C_Bergen_red","C_Bergen_grn","C_Bergen_blu","B_AssaultPack_Kerry","B_AssaultPack_rgr_LAT","B_AssaultPack_rgr_Medic","B_AssaultPack_rgr_Repair","B_Assault_Diver","B_AssaultPack_blk_DiverExp","B_Kitbag_rgr_Exp","B_AssaultPack_mcamo_AT","B_AssaultPack_rgr_ReconMedic","B_AssaultPack_rgr_ReconExp","B_AssaultPack_rgr_ReconLAT","B_AssaultPack_mcamo_AA","B_AssaultPack_mcamo_AAR","B_AssaultPack_mcamo_Ammo","B_Kitbag_mcamo_Eng","B_Carryall_mcamo_AAA","B_Carryall_mcamo_AAT","B_Kitbag_rgr_AAR","B_FieldPack_blk_DiverExp","O_Assault_Diver","B_FieldPack_ocamo_Medic","B_FieldPack_cbr_LAT","B_FieldPack_cbr_Repair","B_Carryall_ocamo_Exp","B_FieldPack_ocamo_AA","B_FieldPack_ocamo_AAR","B_FieldPack_ocamo_ReconMedic","B_FieldPack_cbr_AT","B_FieldPack_cbr_AAT","B_FieldPack_cbr_AA","B_FieldPack_cbr_AAA","B_FieldPack_cbr_Medic","B_FieldPack_ocamo_ReconExp","B_FieldPack_cbr_Ammo","B_FieldPack_cbr_RPG_AT","B_Carryall_ocamo_AAA","B_Carryall_ocamo_Eng","B_Carryall_cbr_AAT","B_FieldPack_oucamo_AT","B_FieldPack_oucamo_LAT","B_Carryall_oucamo_AAT","B_FieldPack_oucamo_AA","B_Carryall_oucamo_AAA","B_FieldPack_oucamo_AAR","B_FieldPack_oucamo_Medic","B_FieldPack_oucamo_Ammo","B_FieldPack_oucamo_Repair","B_Carryall_oucamo_Exp","B_Carryall_oucamo_Eng","B_Carryall_ocamo_AAR","B_Carryall_oucamo_AAR","I_Fieldpack_oli_AA","I_Assault_Diver","I_Fieldpack_oli_Ammo","I_Fieldpack_oli_Medic","I_Fieldpack_oli_Repair","I_Fieldpack_oli_LAT","I_Fieldpack_oli_AT","I_Fieldpack_oli_AAR","I_Carryall_oli_AAT","I_Carryall_oli_Exp","I_Carryall_oli_AAA","I_Carryall_oli_Eng","G_TacticalPack_Eng","G_FieldPack_Medic","G_FieldPack_LAT","G_Carryall_Ammo","G_Carryall_Exp","B_TacticalPack_oli_AAR","B_BergenG_TEST_B_Soldier_overloaded","B_Respawn_TentDome_F","B_Respawn_TentA_F","B_Respawn_Sleeping_bag_F","B_Respawn_Sleeping_bag_blue_F","B_Respawn_Sleeping_bag_brown_F","Weapon_Bag_Base","B_HMG_01_support_F","O_HMG_01_support_F","I_HMG_01_support_F","B_HMG_01_support_high_F","O_HMG_01_support_high_F","I_HMG_01_support_high_F","B_HMG_01_weapon_F","O_HMG_01_weapon_F","I_HMG_01_weapon_F","B_HMG_01_A_weapon_F","O_HMG_01_A_weapon_F","I_HMG_01_A_weapon_F","B_GMG_01_weapon_F","O_GMG_01_weapon_F","I_GMG_01_weapon_F","B_GMG_01_A_weapon_F","O_GMG_01_A_weapon_F","I_GMG_01_A_weapon_F","B_HMG_01_high_weapon_F","O_HMG_01_high_weapon_F","I_HMG_01_high_weapon_F","B_GMG_01_high_weapon_F","O_GMG_01_high_weapon_F","I_GMG_01_high_weapon_F","B_Mortar_01_support_F","O_Mortar_01_support_F","I_Mortar_01_support_F","B_Mortar_01_weapon_F","O_Mortar_01_weapon_F","I_Mortar_01_weapon_F","B_B_Parachute_02_F","B_O_Parachute_02_F","B_I_Parachute_02_F","B_AA_01_weapon_F","O_AA_01_weapon_F","I_AA_01_weapon_F","B_AT_01_weapon_F","O_AT_01_weapon_F","I_AT_01_weapon_F","B_Static_Designator_01_weapon_F","O_Static_Designator_02_weapon_F","B_UAV_01_backpack_F","O_UAV_01_backpack_F","I_UAV_01_backpack_F","B_Bergen_Base_F","B_Bergen_mcamo_F","B_Bergen_dgtl_F","B_Bergen_hex_F","B_Bergen_tna_F","B_AssaultPack_tna_F","B_Carryall_ghex_F","B_FieldPack_ghex_F","B_ViperHarness_base_F","B_ViperHarness_blk_F","B_ViperHarness_ghex_F","B_ViperHarness_hex_F","B_ViperHarness_khk_F","B_ViperHarness_oli_F","B_ViperLightHarness_base_F","B_ViperLightHarness_blk_F","B_ViperLightHarness_ghex_F","B_ViperLightHarness_hex_F","B_ViperLightHarness_khk_F","B_ViperLightHarness_oli_F","B_Carryall_oli_BTAmmo_F","B_Carryall_oli_BTAAA_F","B_Carryall_oli_BTAAT_F","B_AssaultPack_tna_BTMedic_F","B_Kitbag_rgr_BTEng_F","B_Kitbag_rgr_BTExp_F","B_Kitbag_rgr_BTAA_F","B_Kitbag_rgr_BTAT_F","B_AssaultPack_tna_BTRepair_F","B_AssaultPack_rgr_BTLAT_F","B_Kitbag_rgr_BTReconExp_F","B_AssaultPack_rgr_BTReconMedic","B_HMG_01_support_grn_F","B_Mortar_01_support_grn_F","B_GMG_01_Weapon_grn_F","B_HMG_01_Weapon_grn_F","B_Mortar_01_Weapon_grn_F","B_Kitbag_rgr_CTRGExp_F","B_AssaultPack_rgr_CTRGMedic_F","B_AssaultPack_rgr_CTRGLAT_F","B_Carryall_ghex_OTAmmo_F","B_Carryall_ghex_OTAAR_AAR_F","B_Carryall_ghex_OTAAA_F","B_Carryall_ghex_OTAAT_F","B_FieldPack_ghex_OTMedic_F","B_Carryall_ghex_OTEng_F","B_Carryall_ghex_OTExp_F","B_FieldPack_ghex_OTAA_F","B_FieldPack_ghex_OTAT_F","B_FieldPack_ghex_OTRepair_F","B_FieldPack_ghex_OTLAT_F","B_Carryall_ghex_OTReconExp_F","B_FieldPack_ghex_OTReconMedic_F","B_FieldPack_ghex_OTRPG_AT_F","B_ViperHarness_hex_TL_F","B_ViperHarness_ghex_TL_F","B_ViperHarness_hex_Exp_F","B_ViperHarness_ghex_Exp_F","B_ViperHarness_hex_Medic_F","B_ViperHarness_ghex_Medic_F","B_ViperHarness_hex_M_F","B_ViperHarness_ghex_M_F","B_ViperHarness_hex_LAT_F","B_ViperHarness_ghex_LAT_F","B_ViperHarness_hex_JTAC_F","B_ViperHarness_ghex_JTAC_F","B_Kitbag_rgr_Para_3_F","B_Kitbag_cbr_Para_5_F","B_Kitbag_rgr_Para_8_F","B_FieldPack_cb_Bandit_3_F","B_Kitbag_cbr_Bandit_2_F","B_FieldPack_khk_Bandit_1_F","B_FieldPack_blk_Bandit_8_F"];
_vests = ["V_Rangemaster_belt","V_BandollierB_khk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_blk","V_BandollierB_oli","V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier2_blk","V_PlateCarrierGL_rgr","V_PlateCarrierGL_blk","V_PlateCarrierGL_mtp","V_PlateCarrier1_blk","V_PlateCarrierSpec_rgr","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_Chestrig_khk","V_Chestrig_rgr","V_Chestrig_blk","V_Chestrig_oli","V_TacVest_khk","V_TacVest_brn","V_TacVest_oli","V_TacVest_blk","V_TacVest_camo","V_TacVest_blk_POLICE","V_TacVestIR_blk","V_HarnessO_brn","V_HarnessOGL_brn","V_HarnessO_gry","V_HarnessOGL_gry","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_PlateCarrierIAGL_oli","V_RebreatherB","V_RebreatherIR","V_RebreatherIA","V_PlateCarrier_Kerry","V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG","V_I_G_resistanceLeader_F","V_Press_F","V_TacChestrig_grn_F","V_TacChestrig_oli_F","V_TacChestrig_cbr_F","V_PlateCarrier1_tna_F","V_PlateCarrier2_tna_F","V_PlateCarrierSpec_tna_F","V_PlateCarrierGL_tna_F","V_HarnessO_ghex_F","V_HarnessOGL_ghex_F","V_BandollierB_ghex_F","V_TacVest_gen_F","V_PlateCarrier1_rgr_noflag_F","V_PlateCarrier2_rgr_noflag_F","V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrier3_rgr","V_PlateCarrier3_rgr","V_TacVestCamo_khk","G_I_Diving"];//estos no salen en mi método: "V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrier3_rgr","V_PlateCarrier3_rgr","V_TacVestCamo_khk","G_I_Diving"
civUniforms = ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_Rangemaster","U_NikosBody","U_C_Poor_1","U_C_Poor_2","U_C_WorkerCoveralls","U_C_Poor_shorts_1","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_C_Man_casual_5_F","U_C_Man_casual_4_F","U_C_Man_casual_6_F","U_C_man_sport_3_F","U_C_man_sport_2_F","U_C_man_sport_1_F","U_C_Man_casual_2_F","U_C_Man_casual_1_F","U_C_Man_casual_3_F","U_Marshal"];
banditUniforms = ["U_I_C_Soldier_Bandit_4_F","U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_2_F","U_I_C_Soldier_Bandit_1_F","U_I_C_Soldier_Bandit_5_F"];
uniformsSDK = banditUniforms + ["U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Camo_F","U_I_C_Soldier_Para_1_F","U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_5_F","U_I_C_Soldier_Para_4_F"];

//All weapons, MOD ones included, will be added to this arrays, but it's useless without integration, as if those weapons don't spawn, players won't be able to collect them, and after, unlock them in the arsenal.
allMagazines = [];
_cfgmagazines = configFile >> "cfgmagazines";
for "_i" from 0 to (count _cfgMagazines) -1 do
	{
	_magazine = _cfgMagazines select _i;
	if (isClass _magazine) then
		{
		_nombre = configName (_magazine);
		allMagazines pushBack _nombre;
		};
	};

arifles = [];
srifles = [];
mguns = [];
hguns = [];
mlaunchers = [];
rlaunchers = [];

hayRHS = false;

lockedWeapons = ["Rangefinder","Laserdesignator"];

_allPrimaryWeapons = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 1 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allHandGuns = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 2 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allLaunchers = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 4 } } )
" configClasses ( configFile >> "cfgWeapons" );

primaryMagazines = [];
{
_nombre = configName _x;
_nombre = [_nombre] call BIS_fnc_baseWeapon;
if (not(_nombre in lockedWeapons)) then
	{
	_magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
	primaryMagazines pushBack (_magazines select 0);
	lockedWeapons pushBack _nombre;
	_weapon = [_nombre] call BIS_fnc_itemType;
	_weaponType = _weapon select 1;
	switch (_weaponType) do
		{
		case "AssaultRifle": {arifles pushBack _nombre};
		case "MachineGun": {mguns pushBack _nombre};
		case "SniperRifle": {srifles pushBack _nombre};
		case "Handgun": {hguns pushBack _nombre};
		case "MissileLauncher": {mlaunchers pushBack _nombre};
		case "RocketLauncher": {rlaunchers pushBack _nombre};
		};

	};
} forEach _allPrimaryWeapons + _allHandGuns + _allLaunchers;

mguns pushBack "LMG_Mk200_BI_F";
//arifles = arifles - ["LMG_Mk200_BI_F"];

//rhs detection and integration
/*
if ("rhs_weap_akms" in lockedWeapons) then
	{
	hayRHS = true;
	armasAAF = armasAAF + ["rhs_weap_rpg7","rhs_weap_pkm", "rhs_weap_svdp_wd", "rhs_weap_ak74m_gp25","rhs_weap_akms_gp25","hgun_PDW2000_F","hgun_ACPC2_F"];
	municionAAF = municionAAF + ["rhs_100Rnd_762x54mmR","rhs_rpg7_PG7VR_mag","rhs_rpg7_PG7VL_mag","rhs_30Rnd_545x39_AK","rhs_mag_rgd5","rhs_VOG25","rhs_30Rnd_762x39mm","rhs_10Rnd_762x54mmR_7N1","9Rnd_45ACP_Mag","30Rnd_9x21_Mag"];
	opticasAAF = opticasAAF + ["rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_pgo7v","rhs_acc_1p29","rhs_acc_pso1m2"];
	itemsAAF = itemsAAF + ["rhs_acc_dtk1l","rhs_acc_pbs1","rhs_acc_tgpa"] + ["rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_pgo7v","rhs_acc_1p29","rhs_acc_pso1m2"];
	};
//publicVariable "hayRHS";
*/
injuredSounds =
[
	"a3\sounds_f\characters\human-sfx\Person0\P0_moan_13_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_14_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_15_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_16_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_17_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_18_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_20_words.wss",
	"a3\sounds_f\characters\human-sfx\Person1\P1_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_20_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_21_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_22_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_23_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_24_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_25_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_26_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_27_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_28_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_29_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_30_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_31_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_32_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_33_words.wss",
	"a3\sounds_f\characters\human-sfx\Person2\P2_moan_19_words.wss"
];

missionPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

ladridos = ["Music\dog_bark01.wss", "Music\dog_bark02.wss", "Music\dog_bark03.wss", "Music\dog_bark04.wss", "Music\dog_bark05.wss","Music\dog_maul01.wss","Music\dog_yelp01.wss","Music\dog_yelp02.wss","Music\dog_yelp03.wss"];

if (!isServer and hasInterface) exitWith {};

AAFpatrols = 0;//0
smallCAmrk = [];
smallCApos = [];
bigAttackInProgress = false;
chopForest = false;
roadsMrk = ["road","road_1","road_2","road_3","road_4","road_5","road_6","road_7","road_8","road_9","road_10","road_11","road_12","road_13","road_14","road_15","road_16"];
roadsCentral = ["road","road_1","road_2","road_3","road_4"];
roadsCE = ["road_5","road_6"];
roadsCSE = ["road_7"];
roadsSE = ["road_8","road_9","road_10","road_11"];
roadsSW = ["road_12"];
roadsCW = ["road_13","road_14"];
roadsNW = ["road_15"];
roadsNE = ["road_16"];

//Pricing values for soldiers, vehicles
if (!isServer) exitWith {};

{server setVariable [_x,50,true]} forEach sdkTier1;
{server setVariable [_x,100,true]} forEach  sdkTier2;
{server setVariable [_x,150,true]} forEach sdkTier3;
{timer setVariable [_x,0,true]} forEach (vehAttack + vehNATOAttackHelis + [vehCSATPlane,vehNATOPlane] + vehCSATAttackHelis + vehAA + vehMRLS);

server setVariable ["C_Offroad_02_unarmed_F",200,true];//200
server setVariable ["C_Van_01_transport_F",600,true];//600
server setVariable ["C_Heli_Light_01_civil_F",5000,true];//5000
server setVariable [vehSDKHeli,12000,true];//12000
server setVariable [vehSDKBike,50,true];//50
server setVariable [vehSDKLightUnarmed,200,true];//200
server setVariable [vehSDKTruck,300,true];//300
server setVariable [vehSDKLightArmed,700,true];//700
{server setVariable [_x,400,true]} forEach [SDKMGStatic,vehSDKBoat,vehSDKRepair];//400
{server setVariable [_x,800,true]} forEach [SDKMortar,staticATBuenos,staticAABuenos];//800
server setVariable ["hr",8,true];//initial HR value
server setVariable ["resourcesFIA",1000,true];//Initial FIA money pool value
skillFIA = 0;//Initial skill level for FIA soldiers
prestigeNATO = 5;//Initial Prestige NATO
prestigeCSAT = 5;//Initial Prestige CSAT
prestigeOPFOR = 50;//Initial % support for NATO on each city
if (not cadetMode) then {prestigeOPFOR = 75};//if you play on vet, this is the number
prestigeBLUFOR = 0;//Initial % FIA support on each city
cuentaCA = 600;//600
bombRuns = 0;
lastIncome = 0;
cityIsSupportChanging = false;
resourcesIsChanging = false;
savingServer = false;
misiones = [];
revelar = false;
prestigeIsChanging = false;
staticsToSave = [];
napalmCurrent = false;
chungos = ["Tactical Coop","[GER] AntiStasi Tanoa by Opas Musterknaben | ACE3 | Taskforce","[REI] Regio Esercito Italiano PvP/TvT - TS:136.243.175.26", "GER|Public Coop|Takticsh|TS 31.172.86.185 for Joining", "[UNA] 24/7 HARDCORE - CooP - LOW PING","Numbian's Coop Server", "Antistasi Tanoa"];

unlockedWeapons = ["hgun_PDW2000_F","hgun_Pistol_01_F","hgun_ACPC2_F","Binocular","arifle_AKM_F","launch_RPG7_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];//"LMG_03_F"
unlockedRifles = ["hgun_PDW2000_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
unlockedMagazines = ["9Rnd_45ACP_Mag","30Rnd_9x21_Mag","30Rnd_762x39_Mag_F","MiniGrenade","1Rnd_HE_Grenade_shell","RPG7_F","30Rnd_545x39_Mag_F","30Rnd_9x21_Mag_SMG_02","10Rnd_9x21_Mag","200Rnd_556x45_Box_F","IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","IEDLandSmall_Remote_Mag","IEDUrbanSmall_Remote_Mag"];
initialRifles = ["hgun_PDW2000_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];

//The following are the initial weapons and mags unlocked and available in the Arsenal, vanilla or RHS
/*
if (!hayRHS) then
    {

    }
else
    {
    unlockedWeapons = ["rhs_weap_akms","rhs_weap_makarov_pmm","Binocular"];
    unlockedRifles = ["rhs_weap_akms"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
    unlockedMagazines = ["rhs_30Rnd_762x39mm","rhs_mag_9x18_12_57N181S"];
    };
    */
unlockedItems = ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_grn","H_Booniehat_dirty","H_Cap_oli","H_Cap_blk","H_MilCap_rucamo","H_MilCap_gry","H_BandMask_blk","H_Bandanna_khk","H_Bandanna_gry","H_Bandanna_camo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_ShemagOpen_tan","H_Beret_grn","H_Beret_grn_SF","H_Watchcap_camo","H_TurbanO_blk","H_Hat_camo","H_Hat_tan","H_Beret_blk","H_Beret_red","H_Beret_02","H_Watchcap_khk","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Balaclava_oli","G_Bandanna_beast","G_Tactical_Black","G_Aviator","G_Shades_Black","acc_flashlight","V_Chestrig_khk","I_UavTerminal","ACRE_PRC152"] + uniformsSDK + civUniforms;//Initial Arsenal available items


unlockedBackpacks = ["B_FieldPack_oli"];//Initial Arsenal available backpacks
lockedMochis = lockedMochis - unlockedBackpacks;
unlockedOptics = [];
garageIsUsed = false;
vehInGarage = [];
destroyedBuildings = []; publicVariable "destroyedBuildings";
reportedVehs = [];
hayTFAR = false;
hayACE = false;
hayACEhearing = false;
hayACEMedical = false;
//TFAR detection and config.
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then
    {
    hayTFAR = true;
    unlockedItems = unlockedItems + ["tf_microdagr","tf_anprc152"];//making this items Arsenal available.
    tf_no_auto_long_range_radio = true; publicVariable "tf_no_auto_long_range_radio";//set to false and players will start with LR radio, uncomment the last line of so.
	//tf_give_personal_radio_to_regular_soldier = false;
	//tf_buenos_radio_code = "";publicVariable "tf_buenos_radio_code";//to make enemy vehicles usable as LR radio
	//tf_east_radio_code = tf_buenos_radio_code; publicVariable "tf_east_radio_code"; //to make enemy vehicles usable as LR radio
	//tf_guer_radio_code = tf_buenos_radio_code; publicVariable "tf_guer_radio_code";//to make enemy vehicles usable as LR radio
	tf_same_sw_frequencies_for_side = true; publicVariable "tf_same_sw_frequencies_for_side";
	tf_same_lr_frequencies_for_side = true; publicVariable "tf_same_lr_frequencies_for_side";
	unlockedItems pushBack "ItemRadio";
    //unlockedBackpacks pushBack "tf_rt1523g_sage";//uncomment this if you are adding LR radios for players
    };
//ACE detection and ACE item availability in Arsenal
if (!isNil "ace_common_settingFeedbackIcons") then
	{
	unlockedItems = unlockedItems + ["ACE_EarPlugs","ACE_RangeCard","ACE_Clacker","ACE_M26_Clacker","ACE_DeadManSwitch","ACE_DefusalKit","ACE_MapTools","ACE_Flashlight_MX991","ACE_Sandbag_empty","ACE_wirecutter","ACE_SpraypaintBlue","ACE_SpraypaintGreen","ACE_SpraypaintRed","ACE_SpraypaintBlack"];
	itemsAAF = itemsAAF + ["ACE_Kestrel4500","ACE_ATragMX"];
	armasNATO = armasNATO + ["ACE_M84"];
	hayACE = true;
	if (isClass (configFile >> "CfgSounds" >> "ACE_EarRinging_Weak")) then
		{
		hayACEhearing = true;
		};
	if (isClass (ConfigFile >> "CfgSounds" >> "ACE_heartbeat_fast_3")) then
		{
		if (ace_medical_level != 0) then
			{
			hayACEMedical = true;
			unlockedItems = unlockedItems + ["ACE_atropine","ACE_fieldDressing","ACE_quikclot","ACE_bloodIV_250","ACE_epinephrine","ACE_morphine","ACE_personalAidKit","ACE_plasmaIV_250","ACE_salineIV_250","ACE_tourniquet","ACE_elasticBandage","ACE_packingBandage"];
			};
		};
	};

allItems = itemsAAF + opticasAAF + _vests + cascos + NVGoggles;

if (worldName == "Tanoa") then
	{
	{server setVariable [_x select 0,_x select 1]} forEach [["Lami01",277],["Lifou01",350],["Lobaka01",64],["LaFoa01",38],["Savaka01",33],["Regina01",303],["Katkoula01",413],["Moddergat01",195],["Losi01",83],["Tanouka01",380],["Tobakoro01",45],["Georgetown01",347],["Kotomo01",160],["Rautake01",113],["Harcourt01",325],["Buawa01",44],["SaintJulien01",353],["Balavu01",189],["Namuvaka01",45],["Vagalala01",174],["Imone01",31],["Leqa01",45],["Blerick01",71],["Yanukka01",189],["OuaOue01",200],["Cerebu01",22],["Laikoro01",29],["Saioko01",46],["Belfort01",240],["Oumere01",333],["Muaceba01",18],["Nicolet01",224],["Lailai01",23],["Doodstil01",101],["Tavu01",178],["Lijnhaven01",610],["Nani01",19],["PetitNicolet01",135],["PortBoise01",28],["SaintPaul01",136],["Nasua01",60],["Savu01",184],["Murarua01",258],["Momea01",159],["LaRochelle01",532],["Koumac01",51],["Taga01",31],["Buabua01",27],["Penelo01",189],["Vatukoula01",15],["Nandai01",130],["Tuvanaka01",303],["Rereki01",43],["Ovau01",226],["IndPort01",420],["Ba01",106]];
	call compile preprocessFileLineNumbers "roadsDB.sqf";
	};

publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";
publicVariable "miembros";
publicVariable "garageIsUsed";
publicVariable "vehInGarage";
publicVariable "reportedVehs";
publicVariable "hayACE";
publicVariable "hayTFAR";
publicVariable "hayACEhearing";
publicVariable "hayACEMedical";
publicVariable "misiones";
publicVariable "revelar";
publicVariable "prestigeNATO";
publicVariable "prestigeCSAT";
publicVariable "skillFIA";
publicVariable "staticsToSave";
publicVariable "bombRuns";
publicVariable "chopForest";
publicVariable "napalmCurrent";

if (isMultiplayer) then {[[petros,"hint","Variables Init Completed"],"commsMP"] call BIS_fnc_MP;};