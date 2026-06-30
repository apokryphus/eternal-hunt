function ACS_SignSwitchArsenalInit()
{
	if (!GetWitcherPlayer().IsPerformingFinisher() 
	&& !GetWitcherPlayer().IsCrossbowHeld() 
	&& !GetWitcherPlayer().IsInHitAnim() 
	&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
	)		
	{
		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
		
		ACS_ThingsThatShouldBeRemoved();

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
		else if ( ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2
		|| ACS_GetWeaponMode() == 3
		)
		{
			GetACSWatcher().PrimaryWeaponSwitch();
			ACS_TauntInit();
		}
	}
}