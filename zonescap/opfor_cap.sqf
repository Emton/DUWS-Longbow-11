_place   =   _this select 0; 
_points =   _this select 1;
_markername = _this select 2;
_markername2 = _this select 3;
_triggerPos = _this select 4;

amount_zones_captured = amount_zones_captured - 1;
[["us_lostcontrol",[_place]],"bis_fnc_showNotification"] call BIS_fnc_MP;

// remove the zone of list of zones under blu control//NOT SURE WHAT KIBOT'S DOING HERE?//
//_index = 0;
//{
//if ((_x select 0 == _triggerPos select 0) && (_x select 1 == _triggerPos select 1) && (_x select 2 == _triggerPos select 2)) exitWith {
//WARCOM_zones_controled_by_BLUFOR set [_index,-1];
//WARCOM_zones_controled_by_BLUFOR = WARCOM_zones_controled_by_BLUFOR - [-1];
//}; 
//_index = _index + 1;
//} forEach WARCOM_zones_controled_by_BLUFOR;
////////////////////////////////////////////////////////////////////////////////////////

// TELL THE ZONE IS UNDER OPF CONTROL
WARCOM_zones_controled_by_OPFOR = WARCOM_zones_controled_by_OPFOR + [_triggerPos];

// TELL THE ZONE IS REMOVED FROM BLUFOR CONTROL
WARCOM_zones_controled_by_BLUFOR = WARCOM_zones_controled_by_BLUFOR - [_triggerPos];

// MODIFY NUMBER OF CONTROLLED ZONES
zoneundercontrolblu = zoneundercontrolblu - 1;
publicVariable "zoneundercontrolblu";

// MODIFY ARMY POWER
WARCOM_opfor_ap = WARCOM_opfor_ap + _points;
WARCOM_blufor_ap = WARCOM_blufor_ap - (_points/2);
publicVariable "WARCOM_blufor_ap";
publicVariable "WARCOM_opfor_ap";

// MODIFY MARKER ICON
str(_markername) setMarkerColor "ColorRed";
// hint str(_markername);
// MODIFY MARKER ELLIPSE
str(_markername2) setMarkerColor "ColorRed";

// RECALL VARNAME FOR ZONE TRIGGER --> use the pos of the trigger
private "_trg";
call compile format["_trg = trigger%1%2",round (_triggerPos select 0),round (_triggerPos select 1)];
//// MAKE THE TRIGGER CAPTURABLE FOR BLUFOR
_trg setTriggerActivation["WEST SEIZED","PRESENT",true];
_trg setTriggerStatements["this", format["[""%1"",%2,""%3"",""%4"",%5] execvm 'zonescap\blufor_cap.sqf'",_place,_points,_markername,_markername2,_triggerPos], ""];


