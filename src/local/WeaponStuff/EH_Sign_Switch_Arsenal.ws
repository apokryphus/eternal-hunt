function ACS_SignSwitchArsenalInit()
{
	if (!GetWitcherPlayer().IsPerformingFinisher() 
	&& !GetWitcherPlayer().IsCrossbowHeld() 
	&& !GetWitcherPlayer().IsInHitAnim() 
	&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
	)		
	{
		GetWitcherPlayer().ClearAnimationSpeedMultipliers();
		
		ACS_ThingsThatShouldBeRemoved(false);

		//thePlayer.RaiseEvent('ACS_GoPloughYourself');
		
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
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();	
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
				ACS_TauntInit();
			}
				
			else if 
			(
				ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' )
				|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' )
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