function ACS_Equip_Weapon(weaponType : EPlayerWeapon)
{
	if ( ACS_Settings_Main_Bool('acs_main_settings','acs_mod_enabled', true) 
	&& !thePlayer.IsCiri() 
	&& !ACS_New_Replacers_Female_Active()
	&& !thePlayer.IsCiri()) 
	{
		GetACSWatcher().register_extra_inputs();

		ACS_WeaponDestroyInit();

		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');
			GetACSWatcher().AddTimer('ACS_WeaponEquipDelay', 0.15 / theGame.GetTimeScale(), false );
		}
		else
		{
			ACS_WeaponHolsterInit();
		}
	}
}