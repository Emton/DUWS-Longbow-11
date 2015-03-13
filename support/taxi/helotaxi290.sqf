_posplayer = _this select 0;
_radius = _this select 1;
_foundPickupPos = [];
taxiCanTakeOff = false;
Htaxi290InUse = true;

_music = call compile preprocessFile "support\taxi\random_music.sqf";


if (commandpointsblu1 < 10) exitWith {
  ["info",["Not enough command points","Not enough Command Points (1 CP required)"]] call bis_fnc_showNotification;
  sleep 15;
  _helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
  helotax290 = _helotax290;
  Htaxi80blInUse = false;
};


_foundPickupPos = [_posplayer, 0,_radius,10,0,0.2,0,[],[[0,0],[0,0]]] call BIS_fnc_findSafePos; // find a valid pos

// try to find a pos, if no pos is found exit the script
if (0 == _foundPickupPos select 0 && 0 == _foundPickupPos select 1) exitWith {hint "No valid LZ nearby"; sleep 5; _art = [player,"helo_taxi80bl"] call BIS_fnc_addCommMenuItem;};



// A POS NEAR THE PLAYER HAS BEEN FOUND, CHOOPA EN ROUTE
commandpointsblu1 = commandpointsblu1 - 10;
publicVariable "commandpointsblu1";

// create marker on LZ
_markerpickup = format["lz%1%2",_foundPickupPos]; // Define marker name
_markerstr = createMarker [str(_markerpickup), _foundPickupPos];
_markerstr setMarkerShape "ICON";
str(_markerpickup) setMarkerType "hd_end";
str(_markerpickup) setMarkerColor "ColorGreen";
str(_markerpickup) setMarkerText "LZ";



// create the chopper, gunners and pilots
_helo = createVehicle ["O_Heli_Transport_04_bench_F", [_posplayer select 0, (_posplayer select 1)+2000, 200],[], 0, "FLY"];
null = [_helo] execVM "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_bench_black.sqf";
_helogroup = createGroup west; 
_pilot = _helogroup createUnit ["B_Helipilot_F", [5,5,5], [], 0, "NONE"];
_copilot = _helogroup createUnit ["B_Helipilot_F", [5,5,5], [], 0, "NONE"];
_loader1 = _helogroup createUnit ["B_Helipilot_F", [5,5,5], [], 0, "NONE"];

_helo flyInHeight 150;
_helo addAction ["<t color='#00b7ff'>Give a LZ to the pilot</t>", "support\taxi\mapclickhelo.sqf", "", 0, true, true, "", "vehicle _this == _target"];
 
_pilot setcaptive true;
_pilot allowfleeing 0;
_pilot disableAI "Target"; 
 
_pilot moveindriver _helo;
_copilot moveInTurret [_helo, [0]]; 
_loader1 moveInTurret [_helo, [1]];


// create the helipad to land and the waypoints
_helipad1 = createVehicle ["Land_HelipadEmpty_F", _foundPickupPos, [], 0, "NONE"]; 
_wp = _helogroup addWaypoint [[_foundPickupPos select 0, (_foundPickupPos select 1)-75], 0];
_wp setWaypointType "MOVE";
[_helogroup, 1] setWaypointCombatMode "BLUE";

_fobname = [1] call compile preprocessFile "random_name.sqf";
_random1 = round random 9;
_random2 = round random 9;

_pilot sideChat format["This is %1 %2-%3, we're approaching your location for pick up, check your map for the LZ",_fobname,_random1,_random2];

// ADD ACTION MENU TO CANCEL CHOPPER IF DESIRED**********
_id = player addaction ["<t color='#F00000'>Detonate Taxi</t>","support\taxi\canceltaxi290.sqf",[_pilot,_copilot,_loader,_helo], 0, true, true, "", "_this == player"];


waitUntil {_foundpickuppos distance _helo < 350 or (getdammage _helo > 0.7 or !alive _pilot)}; // wait until the helo is near the lz
// IF THE PILOT IS DEAD OR CHOPPA DOWN ******************
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {
deleteVehicle _helipad1;
deleteMarker str(_markerpickup);
hint format["%1 %2-%2 is too damaged to continue the mission",_fobname,_random1,_random2];
// --- AJOUTER DE NOUVEAU LE SUPPORT
sleep 15;
_helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
}; 
// ****************************************************

// spawn smokeshell
_smokePos = [_foundpickuppos select 0, (_foundpickuppos select 1)+ random 5];
_smoke = "SmokeShellGreen" createVehicle _smokePos;
_chemlight = "Chemlight_green" createVehicle _smokePos;

_helo land "GET IN";


_inVehCheck = true;
while {_inVehCheck} do {
waitUntil {sleep 0.1;taxiCanTakeOff or (getdammage _helo > 0.7 or !alive _pilot)}; // wait until the player has given a validpos
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {}; // get out of the loop if choopa is down
// check if player is inside choppa
if (vehicle player != _helo) then {taxiCanTakeOff = false; _pilot sidechat format["This is %1 %2-%3, get back in, I can't transport you're not inside the chopper !",_fobname,_random1,_random2]; _helo addAction ["<t color='#00b7ff'>Give a LZ to the pilot</t>", "support\taxi\mapclickhelo.sqf", "", 0, true, true, "", "vehicle _this == _target"];} else {_inVehCheck = false;};
};

// IF THE PILOT IS DEAD OR CHOPPA DOWN  **************
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {
deleteVehicle _helipad1;
deleteMarker str(_markerpickup);
hint format["%1 %2-%2 is too damaged to continue the mission",_fobname,_random1,_random2];
sleep 15;
_helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
// --- AJOUTER DE NOUVEAU LE SUPPORT
}; 
// *****************************


// everything is ok, player is in choppa
playMusic [_music, 0];
// _helo lock true;
titleText ["Pilot: Roger that, we're oscar mike...", "PLAIN DOWN"];
str(_markerpickup) setMarkerPos ClickedTaxiPos; 

// create the helipad to land and the waypoints
_helipad = createVehicle ["Land_HelipadEmpty_F", ClickedTaxiPos, [], 0, "NONE"];
_wp = _helogroup addWaypoint [ClickedTaxiPos,0];
_wp setWaypointType "MOVE";
[_helogroup, 1] setWaypointCombatMode "BLUE";


waitUntil {sleep 0.5;_helo distance _helipad1 > 350  or (getdammage _helo > 0.7 or !alive _pilot)}; // wait until the helo is away from LZ
// IF THE PILOT IS DEAD OR CHOPPA DOWN  **************
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {
deleteVehicle _helipad1;
deleteVehicle _helipad;
// _helo lock false;
deleteMarker str(_markerpickup);
hint format["%1 %2-%2 is too damaged to continue the mission",_fobname,_random1,_random2];
// --- AJOUTER DE NOUVEAU LE SUPPORT
sleep 15;
_helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
}; 
// *****************************
if (enableChopperFastTravel) then {
// TELEPORT HELO NEAR LZ
deleteVehicle _helipad1;
titleText ["En route to LZ...", "BLACK OUT", 3];
sleep 3.5;
_helo setpos [getpos _helipad select 0, (getpos _helipad select 1)+1000, 150];
sleep 3;
titleText ["En route to LZ...", "BLACK IN", 4];
};


waitUntil {ClickedTaxiPos distance _helo < 200  or (getdammage _helo > 0.7 or !alive _pilot)}; // wait until the helo is near the lz
// IF THE PILOT IS DEAD OR CHOPPA DOWN  **************
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {
deleteVehicle _helipad;
// _helo lock false;
deleteMarker str(_markerpickup);
hint format["%1 %2-%2 is too damaged to continue the mission",_fobname,_random1,_random2];
// --- AJOUTER DE NOUVEAU LE SUPPORT
sleep 15;
_helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
}; 
// *****************************
_helo land "GET OUT";



// time to move ppl out of the helo;
waitUntil {(getpos _helo select 2 < 4 && _helo distance _helipad<20)  or (getdammage _helo > 0.7 or !alive _pilot)}; // wait until the helo is near the ground
// IF THE PILOT IS DEAD OR CHOPPA DOWN  **************
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {
deleteVehicle _helipad;
// _helo lock false;
hint format["%1 %2-%2 is too damaged to continue the mission",_fobname,_random1,_random2];
// --- AJOUTER DE NOUVEAU LE SUPPORT
sleep 15;
_helotax80bl = [player,"helo_taxi80bl"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
}; 
// *****************************
titleText ["Pilot: We've arrived at the LZ", "PLAIN DOWN"];
// _helo lock false;
{doGetOut _x; sleep 1;} forEach assignedCargo _helo; //units group player;


sleep 40;
_wp = _helogroup addWaypoint [[0,0,0],0];   // tell the helo to leave
_wp setWaypointType "MOVE";
deleteMarker str(_markerpickup);
deleteVehicle _helipad;

waitUntil {_helo distance player>100 or (getdammage _helo > 0.7 or !alive _pilot)}; // wait until the helo is near the ground
// IF THE PILOT IS DEAD OR CHOPPA DOWN  **************
if (getdammage _helo > 0.7 or !alive _pilot) exitWith {
hint format["%1 %2-%2 is too damaged to continue the mission",_fobname,_random1,_random2];
// --- AJOUTER DE NOUVEAU LE SUPPORT
sleep 300;
_helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
}; 
// *****************************
_pilot sideChat format["This is %1 %2-%3, we are RTB",_fobname,_random1,_random2];

sleep 60;
deleteVehicle _pilot;
deleteVehicle _copilot;
deleteVehicle _loader1;
deleteVehicle _helo;
player removeAction _id;

sleep 240;
_helotax290 = [player,"helo_taxi290"] call BIS_fnc_addCommMenuItem;
helotax290 = _helotax290;
Htaxi290InUse = false;
