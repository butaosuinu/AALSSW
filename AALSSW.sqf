waitUntil {time > 0};
waitUntil {!isNull player};

/*
Installation :

1. Copy file in root folder
2. Add line : [] execVM "AALSSW.sqf";
3. ???
4. Profit

hotheys : 
Hide weapon: buldTerrainShowNode key "H" by default
Switch weapon: Switch Gun / Launcher key "Right Ctrl + ;" by default

author steam page : http://steamcommunity.com/id/ArtyomAbramov/
*/

check_backWeapon = true;
aa_fnc_gearInterupt = 
{
	if (isNull (_this select 2)) then 
	{
		if (!isNil {(_this select 1) getVariable "AA_wpnHolder"}) then 
		{
			aa_grounds = [];
			_ground = "GroundWeaponHolder" createVehicle position player; 
			_ground setPosATL (player modelToWorld [0,0.4,0]);
			_ground setDir getDir player;
			_ground enableSimulation false;
			_ground setVariable ["tempHolder", true];
			_ground spawn {waitUntil {sleep 3; isNull (findDisplay 602)}; _this enableSimulation true};
			_nearSup = ((player modelToWorld [0,.8,1]) nearSupplies 2.3);
			{
				_x spawn
				{
					if (!(_this getVariable ['AA_wpnHolder',false])) then 
					{
						if !((_this isKindOf "man") && (alive _this)) then {aa_grounds = aa_grounds + [_this]}
					}
				}
			} forEach _nearSup;
			if (count aa_grounds > 0) then 
			{
				if (((aa_grounds select 0) isKindOf "man") && (!isNull wpnHolderLeft)) then 
				{
					_gear = "GroundWeaponHolder" createVehicle position player; 
					_gear attachTo [(_this select 1),[0,0,0], "pelvis"]; 
					detach _gear; 
					_gear enableSimulation false; 
					_gear setVariable ["tempHolder", true];
					_gear spawn 
					{
						waitUntil {!(isNull (findDisplay 602))};
						sleep 1;
						_this setPosATL (player modelToWorld [0,1,0]);
						_this enableSimulation true; 
						_this setDir getDir player; 
					};
					player action ["Gear", aa_grounds select 0];
				}
				else
				{
					player action ["Gear", aa_grounds select 0];		
				};
			}
			else
			{
				private "_ground";
				_ground = "GroundWeaponHolder" createVehicle position player; 
				_ground setPosATL (player modelToWorld [0,0.4,0]);
				_ground setDir getDir player;
				_ground setVariable ["tempHolder", true];
				player action ["Gear",_ground];
				waitUntil {!(isNull (findDisplay 602))};
				waitUntil {(isNull (findDisplay 602))};
				_ground spawn {waitUntil {sleep 3; isNull (findDisplay 602)}; _this enableSimulation true};
				sleep 1;
			};
			_ground enableSimulation true;
		}
		else 
		{
			if ((_this select 1) isKindOf "man") then 
			{
				_gear = "GroundWeaponHolder" createVehicle position player; 
				_gear attachTo [(_this select 1),[0,0,0], "pelvis"]; 
				detach _gear; 
				_gear enableSimulation false; 
				_gear setVariable ["tempHolder", true];
				_gear spawn 
				{
					sleep 1;
					waitUntil {!(isNull (findDisplay 602))};
					sleep 2;
					_this setPosATL ((_this select 1) modelToWorld [0,0,0]);
					_this enableSimulation true; 
					_this setDir getDir player; 
				};
				player action ["Gear", (_this select 1)];
			};
		};
	}
	else
	{
		if (!isNil {(_this select 2) getVariable "AA_wpnHolder"}) then 
		{
			_tempGear = (_this select 1);
			_tempGear spawn 
			{
				_gear = "GroundWeaponHolder" createVehicle position player; 
				_gear attachTo [player,[0,0,0], "pelvis"]; 
				detach _gear; 
				_gear enableSimulation false; 
				_gear setVariable ["tempHolder", true];
				_gear spawn 
				{
					waitUntil {!(isNull (findDisplay 602))};
					sleep 1;
					_this setPosATL (player modelToWorld [0,1,0]);
					_this enableSimulation true; 
					_this setDir getDir player; 
				};
				player action ["Gear",_this];
			};
		};
	};
};

aa_fnc_invInterupt = 
{
	aa_inventoryContainers = _this;
	waitUntil {(!(isNull (findDisplay 602)))};
	player setVariable ["InvOpened",1];
	waitUntil {sleep 0.001; (isNull (findDisplay 602))};
	player setVariable ["InvOpened",0];
	{if ((typeOf _x == "GroundWeaponHolder") && (!isNil {_x getVariable "tempHolder"})) then {if ((count ((itemCargo _x) + (weaponCargo _x) + (backpackCargo _x) + (magazineCargo _x))) == 0) then {deleteVehicle _x}}} forEach (player nearSupplies 3);
};

aa_fnc_switchWpn =
{
	_wpn = currentWeapon player;
	_stance = stance player;
	if (_wpn == "") then
	{
		_wpn = (player getVariable ["wpnHolster",""]);
		if (_wpn != "") then 
		{
			player setVariable ["wpnHolster",""];
			if ((_wpn == handgunWeapon player) && (_stance == "CROUCH")) then 
			{
				player selectWeapon _wpn; 
				player playMoveNow "AmovPknlMstpSnonWnonDnon_AmovPknlMstpSrasWpstDnon_end"; 
				[[player, {_this playMoveNow "AmovPknlMstpSnonWnonDnon_AmovPknlMstpSrasWpstDnon_end"}], "BIS_fnc_spawn", true, false, false] call BIS_fnc_MP
			}
			else
			{
				player selectWeapon _wpn; 
			};
		}
	}
	else
	{
		if ((_wpn == handgunWeapon player) && (_stance != "CROUCH")) then 
		{
			player setVariable ["wpnHolster",_wpn];
			player action ["switchWeapon", player, player, -1]
		};
		if (_wpn == primaryWeapon player) then 
		{
			if (_stance == "CROUCH") then 
			{
				player playMoveNow "AmovPknlMstpSrasWrflDnon_AmovPknlMstpSnonWnonDnon"; 
				[[player, {_this playMoveNow "AmovPknlMstpSrasWrflDnon_AmovPknlMstpSnonWnonDnon"}], "BIS_fnc_spawn", true, false, false] call BIS_fnc_MP
			};
			if (_stance == "PRONE") then 
			{
				player playMoveNow "AmovPpneMstpSrasWrflDnon_AmovPpneMstpSnonWnonDnon"; 
				[[player, {_this playMoveNow "AmovPpneMstpSrasWrflDnon_AmovPpneMstpSnonWnonDnon"}], "BIS_fnc_spawn", true, false, false] call BIS_fnc_MP
			};
			player setVariable ["wpnHolster",_wpn];
			player action ["switchWeapon", player, player, -1]
		};
		if (_wpn == secondaryWeapon player) then 
		{
			player setVariable ["wpnHolster",_wpn];
			player action ["switchWeapon", player, player,-1]
		};
		if (_wpn == binocular player) then 
		{
			player setVariable ["wpnHolster",_wpn];
			if (_stance == "CROUCH") then 
			{player action ["switchWeapon", player, player,-1]; player playMoveNow "amovpknlmstpsnonwnondnon"; [[player, {_this playMoveNow "amovpknlmstpsnonwnondnon"}], "BIS_fnc_spawn", true, false, false] call BIS_fnc_MP}
			else
			{player action ["switchWeapon", player, player,-1]}
		};
	};
};

aa_fnc_leftWeapon =
{
	check_backWeapon = false;
	_primaryWeapon = nil;
	
	if (primaryWeapon player != "") then {{if ((_x select 0) == (primaryWeapon player)) then  {_primaryWeapon = _x}} forEach (weaponsItems player);};
	
	if ((primaryWeapon player != "") && (isNil {player getVariable ["leftWeapon", nil]})) exitWith //Put on left
	{
		if (currentWeapon player != primaryWeapon player) then {player selectWeapon primaryWeapon player; sleep 0.2};
			if (handgunWeapon player == "") then 
			{
				[] spawn aa_fnc_switchWpn;
				sleep 0.8;
			}
			else
			{
				player selectWeapon handgunWeapon player; 
				sleep 0.2
				};	
		_man =createAgent ["VirtualMan_F", (player modelToWorld [0,-2,0]), [], 0, "NONE"]; 
		waitUntil {sleep 0.001; !isNil "_man"};
		_man attachTo [player,[0,0,10],"pelvis"];
		_man setAnimSpeedCoef 100;
		_man allowDamage false;
		_baseWeapon = (_primaryWeapon select 0);
		_man addWeapon _baseWeapon; 
		removeAllPrimaryWeaponItems _man;
		for "_n" from 1 to ((count _primaryWeapon) -1) do {_man addWeaponItem [_baseWeapon, _primaryWeapon select _n];};  
		wpnHolderLeft = "Weapon_Empty" createVehicle getPosATL player;
		wpnHolderLeft attachTo [player,[0.05,-0.03,-0.03],"launcher"];
		wpnHolderLeft setVariable ["AA_wpnHolder",true,true];
		handler_backWeapon = addMissionEventHandler ["EachFrame",{wpnHolderLeft setVectorDirAndUp [((player selectionPosition "rightShoulder") vectorAdd [-0.10,-0.11,-0.05]) vectorFromTo (player selectionPosition "leftshoulder"),(player selectionPosition "spine3") vectorFromTo (player selectionPosition "launcher")];}];
		_man action ["PutWeapon", wpnHolderLeft, primaryWeapon _man];
		waitUntil {sleep 0.001; ((weaponCargo wpnHolderLeft) select 0) == _baseWeapon};	
		player setUserActionText [action_putLeft, format [localize "str_action_weaponinhand", (getText (configfile >> "CfgWeapons" >> ((weaponCargo wpnHolderLeft) select 0) >> "displayName"))]];
		detach _man;
		deleteVehicle _man;
		wpnHolderLeft setDamage 1;
		player removeWeaponGlobal (primaryWeapon player);
		player setUserActionText [action_switchLeft, format [localize "str_action_weapononback", (getText (configfile >> "CfgWeapons" >> (primaryWeapon player) >> "displayName"))]];
		clearMagazineCargoGlobal wpnHolderLeft;
		clearItemCargoGlobal wpnHolderLeft;
		clearBackpackCargoGlobal wpnHolderLeft;
		
		sleep 1.618;
		player setVariable ["leftWeapon", _primaryWeapon];
		check_backWeapon = true;
	};
	
	if ((primaryWeapon player == "") && (!isNil {player getVariable ["leftWeapon", nil]})) exitWith //Take on left
	{
		player addMagazine (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "magazines") select 0);
		if (count (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "muzzles") select 0) == 2) then 
		{player addMagazine (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0)>> (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "muzzles") select 1) >> "magazines") select 0);};
		removeMissionEventHandler ["EachFrame", handler_backWeapon];
		detach wpnHolderLeft;
		deleteVehicle wpnHolderLeft;
		player addWeapon ((player getVariable ["leftWeapon",nil]) select 0);
		removeAllPrimaryWeaponItems player;
		player removePrimaryWeaponItem (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "magazines") select 0);
		if (count (player getVariable ["leftWeapon",nil]) == 7) then 
		{player removePrimaryWeaponItem (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0)>> (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "muzzles") select 1) >> "magazines") select 0);};
		for "_n" from 1 to (count (player getVariable ["leftWeapon",nil])) do {player addWeaponItem [((player getVariable ["leftWeapon",nil]) select 0), (player getVariable ["leftWeapon",nil]) select _n];};
		player selectWeapon primaryWeapon player;
	
		sleep 1.618;
		player setUserActionText [action_switchLeft, format [localize "str_action_weaponinhand", (getText (configfile >> "CfgWeapons" >> ((weaponCargo wpnHolderLeft) select 0) >> "displayName"))]];
		player setVariable ["leftWeapon",nil];
		check_backWeapon = true;
	};
	
	if ((primaryWeapon player != "") && (!isNil {player getVariable ["leftWeapon", nil]})) exitWith //Switch
	{
		if (primaryWeapon player == currentWeapon player) then 
		{if (binocular player == "") then {player addWeapon "Binocular";[] spawn {waitUntil {currentWeapon player == binocular player; sleep 0.3}; player removeWeaponGlobal "Binocular"};};player selectWeapon binocular player;}
		else
		{
			if (binocular player == "") then {player addWeapon "Binocular";[] spawn {waitUntil {currentWeapon player == binocular player; sleep 0.3}; player removeWeaponGlobal "Binocular"};};player selectWeapon binocular player; sleep 0.3;
		};
	
		_man =createAgent ["VirtualMan_F", (player modelToWorld [0,-2,0]), [], 0, "NONE"]; 
		waitUntil {sleep 0.001; !isNil "_man"};
		_man attachTo [player,[0,0,10],"pelvis"];
		_man setAnimSpeedCoef 100;
		_man allowDamage false;
		_baseWeapon = (_primaryWeapon select 0);
		_man addWeapon _baseWeapon; 
		removeAllPrimaryWeaponItems _man;
		for "_n" from 1 to ((count _primaryWeapon) -1) do {_man addWeaponItem [_baseWeapon, _primaryWeapon select _n];};
		removeMissionEventHandler ["EachFrame", handler_backWeapon];
		[wpnHolderLeft, _baseWeapon] spawn 
		{
			waitUntil {((weaponCargo wpnHolderLeft) select 0) == (_this select 1)};
			detach (_this select 0);
			deleteVehicle (_this select 0);
		};
		wpnHolderLeft = "Weapon_Empty" createVehicle getPosATL player;
		wpnHolderLeft attachTo [player,[0.05,-0.03,-0.03],"launcher"];
		wpnHolderLeft setVariable ["AA_wpnHolder",true,true];
		handler_backWeapon = addMissionEventHandler ["EachFrame",{wpnHolderLeft setVectorDirAndUp [((player selectionPosition "rightShoulder") vectorAdd [-0.10,-0.11,-0.05]) vectorFromTo (player selectionPosition "leftshoulder"),(player selectionPosition "spine3") vectorFromTo (player selectionPosition "launcher")];}];
		_man action ["PutWeapon", wpnHolderLeft, primaryWeapon _man];
		
		waitUntil {((weaponCargo wpnHolderLeft) select 0) == _baseWeapon};
		player addMagazine (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "magazines") select 0);
		if (count (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "muzzles") select 0) == 2) then 
		{player addMagazine (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0)>> (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "muzzles") select 1) >> "magazines") select 0);};
		player addWeapon ((player getVariable ["leftWeapon",nil]) select 0);
		removeAllPrimaryWeaponItems player;
		player removePrimaryWeaponItem (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "magazines") select 0);
		if (count (player getVariable ["leftWeapon",nil]) == 7) then 
		{player removePrimaryWeaponItem (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0)>> (getArray (configFile >> "CfgWeapons" >> ((player getVariable ["leftWeapon",nil]) select 0) >> "muzzles") select 1) >> "magazines") select 0);};
		for "_n" from 1 to (count (player getVariable ["leftWeapon",nil])) do {player addWeaponItem [((player getVariable ["leftWeapon",nil]) select 0), (player getVariable ["leftWeapon",nil]) select _n];};
		player selectWeapon primaryWeapon player;
		_man spawn {sleep  1.618; detach _this; deleteVehicle _this;};
		sleep 1.618;
		player setUserActionText [action_switchLeft, format [localize "str_action_weaponinhand", (getText (configfile >> "CfgWeapons" >> ((weaponCargo wpnHolderLeft) select 0) >> "displayName"))]];
		wpnHolderLeft setDamage 1;
		player setVariable ["leftWeapon", _primaryWeapon];
		check_backWeapon = true;
	};
};

action_hideWpn = player addAction ["Hide weapon",aa_fnc_switchWpn,[],0,false,true,"buldTerrainShowNode",'((vehicle player == player) && (currentWeapon player != "") && (currentWeapon player != binocular player) && (_this == _target))'];
action_switchLeft = player addAction ["Take weapon back",aa_fnc_leftWeapon,[],1,false,true,"SwitchWeapon",'((secondaryWeapon player == "") && (vehicle player == player) && (!isNil {player getVariable ["leftWeapon", nil]}) && (check_backWeapon) && (_this == _target))'];
action_putLeft = player addAction ["Put weapon on back",aa_fnc_leftWeapon,[],1,false,true,"SwitchWeapon",'((secondaryWeapon player == "") && (vehicle player == player) && (isNil {player getVariable ["leftWeapon", nil]}) && (player hasWeapon (primaryWeapon player)) && (check_backWeapon) && (_this == _target))'];

[] spawn 
{
	while{true} do 
	{
		sleep 0.1;
		if ((secondaryWeapon player != "") && (!isNil {player getVariable ["leftWeapon", nil]})) then 
		{
			player playAction "PutDown";
			detach wpnHolderLeft;
			wpnHolderLeft setVehiclePosition [(player modelToWorld [0,1,0]), [], 0, "CAN_COLLIDE"];
			wpnHolderLeft setVariable ["AA_wpnHolder",nil,true];
			wpnHolderLeft setDamage 0;
			player setVariable ["leftWeapon",nil];
		};
		if (check_backWeapon) then 
		{
			/* player setUserActionText [action_dropBack, format [localize "str_action_drop_weapon", (getText (configfile >> "CfgWeapons" >> ((weaponCargo wpnHolderBack) select 0) >> "displayName"))]];
			player setUserActionText [action_putBack, format [localize "str_action_weapononback", (getText (configfile >> "CfgWeapons" >> (primaryWeapon player) >> "displayName"))]];
			player setUserActionText [action_switchBack, format [localize "str_action_weaponinhand", (getText (configfile >> "CfgWeapons" >> ((weaponCargo wpnHolderBack) select 0) >> "displayName"))]]; */
			player setUserActionText [action_putLeft, format [localize "str_action_weapononback", (getText (configfile >> "CfgWeapons" >> (primaryWeapon player) >> "displayName"))]];
			if (!isNil {player getVariable ["leftWeapon", nil]}) then {player setUserActionText [action_switchLeft, format [localize "str_action_weaponinhand", (getText (configfile >> "CfgWeapons" >> (((player getVariable ["leftWeapon",nil]) select 0)) >> "displayName"))]];};
		};
		if (currentWeapon player != "") then 
		{
			player setUserActionText [action_hideWpn, format [localize "str_action_hide_weapon", (getText (configfile >> "CfgWeapons" >> (currentWeapon player) >> "displayName"))]];
		}
	}
};

player addEventHandler ["Respawn",
{
	action_hideWpn = player addAction ["Hide weapon",aa_fnc_switchWpn,[],0,false,true,"buldTerrainShowNode",'((vehicle player == player) && (currentWeapon player != "") && (currentWeapon player != binocular player) && (_this == _target))'];
	action_switchLeft = player addAction ["Take weapon back",aa_fnc_leftWeapon,[],1,false,true,"SwitchWeapon",'((secondaryWeapon player == "") && (vehicle player == player) && (!isNil {player getVariable ["leftWeapon", nil]}) && (check_backWeapon) && (_this == _target))'];
	action_putLeft = player addAction ["Put weapon on back",aa_fnc_leftWeapon,[],1,false,true,"SwitchWeapon",'((secondaryWeapon player == "") && (vehicle player == player) && (isNil {player getVariable ["leftWeapon", nil]}) && (player hasWeapon (primaryWeapon player)) && (check_backWeapon) && (_this == _target))'];
}];
player addEventHandler ["Killed",{detach wpnHolderLeft; wpnHolderLeft setVehiclePosition [getPosASL player, [], 0, "CAN_COLLIDE"]; wpnHolderLeft setVariable ["AA_wpnHolder",nil,true]; player setVariable ["leftWeapon",nil]; wpnHolderLeft setDamage 0;removeMissionEventHandler ["EachFrame",handler_backWeapon];}];
player addEventHandler ["InventoryOpened", 
{
	if (vehicle player != player) exitWith {if (player getVariable ["InvOpened",0] != 1) then {_this spawn aa_fnc_invInterupt}};
	if (isNil {player getVariable ["leftWeapon", nil]}) exitWith {if (player getVariable ["InvOpened",0] != 1) then {_this spawn aa_fnc_invInterupt}};
	if (((isNil {(_this select 1) getVariable "AA_wpnHolder"}) && (isNil {(_this select 2) getVariable "AA_wpnHolder"})) && (!((_this select 1) isKindOf "man"))) exitWith {if (player getVariable ["InvOpened",0] != 1) then {_this spawn aa_fnc_invInterupt}};
	if (((_this select 1) isKindOf "man") && (({typeOf _x == "GroundWeaponHolder"} count ((_this select 1) nearSupplies 3)) != 0)) exitWith {if (player getVariable ["InvOpened",0] != 1) then {_this spawn aa_fnc_invInterupt}};
	[0, _this select 1, _this select 2] spawn aa_fnc_gearInterupt; true
}];