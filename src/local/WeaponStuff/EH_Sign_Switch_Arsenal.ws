function ACS_SignSwitchArsenalInit()
{
	if (!GetWitcherPlayer().IsPerformingFinisher() 
	&& !GetWitcherPlayer().IsCrossbowHeld() 
	&& !GetWitcherPlayer().IsInHitAnim() 
	&& !GetWitcherPlayer().HasTag('blood_sucking')
	)		
	{
		GetWitcherPlayer().ClearAnimationSpeedMultipliers();
		
		ACS_ThingsThatShouldBeRemoved();
		
		if ( ACS_GetWeaponMode() == 0 )
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni
				|| GetWitcherPlayer().GetEquippedSign() == ST_Axii
				|| GetWitcherPlayer().GetEquippedSign() == ST_Aard
				|| GetWitcherPlayer().GetEquippedSign() == ST_Yrden
				|| GetWitcherPlayer().GetEquippedSign() == ST_Quen
				)
				&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
			else 
			{
				ACS_TauntInit();
			}
		}
		else if ( ACS_GetWeaponMode() == 1 )
		{
			if 
			(
				ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();	
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
			else
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
		}
		else if ( ACS_GetWeaponMode() == 2 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();
			ACS_TauntInit();
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();
			ACS_TauntInit();
		}
	}
}