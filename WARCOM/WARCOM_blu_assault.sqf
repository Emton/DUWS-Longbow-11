_loop = true;

WARCOM_blu_attack_wave_type = "";
WARCOM_blu_attack_wave_avalaible = false;
aliveAllUnits = {alive _x} count allunits;

// Type of attack wave
[] spawn {

	waitUntil {sleep 1;WARCOM_blufor_ap>=15};
	[West,"HQ"] sidechat "This is HQ, BLUFOR troops just arrived on the island, soon they will push to the enemy lines!";
	WARCOM_blu_attack_wave_avalaible = true;
	WARCOM_blu_attack_wave_type = (configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam");

	waitUntil {sleep 1;WARCOM_blufor_ap>40};          
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"); 

	waitUntil {sleep 1;WARCOM_blufor_ap>65};
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad_Weapons"); 

	waitUntil {sleep 1;WARCOM_blufor_ap>90};          
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInfSquad");

	waitUntil {sleep 1;WARCOM_blufor_ap>140};
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInf_AT");

	waitUntil {sleep 1;WARCOM_blufor_ap>190};
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInf_AA");

	waitUntil {sleep 1;WARCOM_blufor_ap>240};
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Armored" >> "BUS_TankSection");

	waitUntil {sleep 1;WARCOM_blufor_ap>290};
	WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Armored" >> "BUS_TankPlatoon_AA");
      
};




// Attack waves main
if (Warcom_Limiter_Param == 1) then {

[] spawn {
          waitUntil {sleep 6; WARCOM_blu_attack_wave_avalaible;};

          while {true} do {
		  aliveAllUnits = {alive _x} count allunits;
		  waitUntil {sleep (random 30); aliveAllUnits < 130};
		  _group = [WARCOM_blu_hq_pos, WEST, WARCOM_blu_attack_wave_type,[],[],blufor_ai_skill] call BIS_fnc_spawnGroup;
          _TFname = [1] call compile preprocessFile "random_name.sqf";
          [West,"HQ"] sidechat format["This is HQ, We are sending Task Force %1, we will try to push as far as possible in enemy territory",_TFname];
          _blu_assault = [_group] execVM "WARCOM\WARCOM_wp.sqf";
          _blu_assault = [_group,_TFname] execVM "WARCOM\WARCOM_gps_marker.sqf";
		  sleep (WARCOM_blu_attack_delay + (random 600)); //was 900
          
          };
};
}

else {

[] spawn {
          waitUntil {sleep 6; WARCOM_blu_attack_wave_avalaible;};

          while {true} do {
		  aliveAllUnits = {alive _x} count allunits;
		  waitUntil {sleep (random 30); aliveAllUnits < 200;};
		  _group = [WARCOM_blu_hq_pos, WEST, WARCOM_blu_attack_wave_type,[],[],blufor_ai_skill] call BIS_fnc_spawnGroup;
          _TFname = [1] call compile preprocessFile "random_name.sqf";
          [West,"HQ"] sidechat format["This is HQ, We are sending Task Force %1, we will try to push as far as possible in enemy territory",_TFname];
          _blu_assault = [_group] execVM "WARCOM\WARCOM_wp.sqf";
          _blu_assault = [_group,_TFname] execVM "WARCOM\WARCOM_gps_marker.sqf";		  
          sleep (WARCOM_blu_attack_delay + (random 600)); //was 900		 
          
          };
};
};
