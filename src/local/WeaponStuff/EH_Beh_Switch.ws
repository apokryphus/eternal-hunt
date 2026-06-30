latent function ACS_BehSwitch(prevStateName : name)
{
	var stupidArray 	: array< name >;

	GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
	GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);

	stupidArray.Clear();
	
	if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
	{
		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}
	}
	else if (ACS_Is_DLC_Installed('e3arp_dlc') )
	{
		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}
	}
	else
	{
		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}
	}

	if ( prevStateName == 'PlayerDialogScene' )
	{
		thePlayer.ActivateBehaviors(stupidArray);
	}
	else if ( prevStateName == 'TraverseExploration' )
	{
		ACS_ExplorationBehSwitch();
	}
	else
	{
		if(
		prevStateName=='HorseRiding'
		||prevStateName=='DismountBoat'
		||prevStateName=='DismountHorse'
		||prevStateName=='DismountTheVehicle'
		||prevStateName=='Swimming'
		||prevStateName=='MountBoat'
		||prevStateName=='MountHorse'
		||prevStateName=='MountTheVehicle'
		||prevStateName=='Sailing'
		||prevStateName=='ApproachTheVehicle'
		||prevStateName=='UseVehicle')
		{
			thePlayer.ActivateBehaviors(stupidArray);
		}
		else
		{
			if( thePlayer.IsPerformingFinisher()
			|| thePlayer.HasTag('ACS_IsPerformingFinisher')
			|| thePlayer.HasTag('ACS_IsPerformingCombatDismember')
			) 
			{
				Sleep(0.75f / theGame.GetTimeScale( false ));
			}

			ACS_ExplorationBehSwitch();
		}
	}
}

function ACS_ExplorationBehSwitch()
{
	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	// 
	// 
	GetACSWatcher().RemoveTimer('CombatTauntDelay');
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 

	if (GetACSWatcher().swordWalkActive)
	{
		GetACSWatcher().setSwordwalkActive(false);
	}

	if (thePlayer.HasTag('ACS_IsSwordWalking'))
	{
		thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');thePlayer.RaiseEvent('ACS_SwordTauntEnd');
		
		thePlayer.RemoveTag('ACS_IsSwordWalking');
	}

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive()
	&& !ACS_New_Replacers_Female_Active()
	&& !thePlayer.IsThrowingItemWithAim()
	&& !thePlayer.IsThrowingItem()
	&& !thePlayer.IsThrowHold()
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	)
	{
		GetACSWatcher().CombatBehSwitch();

		GetACSWatcher().register_extra_inputs();

		GetACSWatcher().SetAdrenalineDrain(true);

		if (!thePlayer.IsInCombat() && !thePlayer.IsThreatened())
		{
			GetACSStorage().acs_deleteOnelinerByTag("ACS_Posture_Bar_Indicator");

			GetACSStorage().acs_deleteOnelinerByTag("ACS_Posture_Background_Bar_Indicator");

			GetACSWatcher().Ghost_Stance_Kill_Increment(false, 0);

			GetACSWatcher().IdleAdditiveBlockTemp();

			if(ACSGetCEntity('ACS_Viper_Dagger_L'))
			{
				thePlayer.RaiseEvent('ACS_LHandAttack01');
			}

			if(ACS_Settings_Main_Bool('acs_combat_main_settings','acs_enable_sword_auto_sheathe', false))
			{
				thePlayer.RemoveTimer('DelayedSheathSword');
				thePlayer.AddTimer('DelayedSheathSword', 2 / theGame.GetTimeScale(), false );
			}

			if(!thePlayer.IsAnyWeaponHeld())
			{
				GetACSWatcher().VampireClawsHybridLHandDestroy();

				thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');
				
				thePlayer.RaiseEvent('ACS_SwordTauntEnd');

				if (!ACSGetCEntity('acs_swimming_dagger'))
				{
					thePlayer.RaiseEvent('ACS_ForceHandClosedREnd');
				}

				if (!thePlayer.HasTag('ACS_Dual_Wield_Active') && !ACSGetCEntity('ACS_Viper_Dagger_L')){thePlayer.RaiseEvent('ACS_ForceHandClosedLEnd');}
			}

			GetACSWatcher().RemoveTimer('Air_Time_Trigger_Delay');

			if (thePlayer.HasTag('ACS_Air_Time'))
			{
				GetACSWatcher().RemoveTimer('Air_Time_Movement_Adjust_Delay');

				thePlayer.BlockAllActions( 'ACS_Air_Time_Init', false );

				thePlayer.EnableCollisions(true);

				thePlayer.RaiseEvent('ACS_FeetAdditiveEnd');

				thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_DrawWeapon, 		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_FastTravel, 		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_Movement,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_QuickSlots, 		'ACS_Air_Time');

				thePlayer.RemoveTag('ACS_Air_Time');
			}
			
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
				{
					//GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 1 / theGame.GetTimeScale(), false ); 

					GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 2 / theGame.GetTimeScale(), false ); 

					thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
				}
			}

			if (thePlayer.HasTag ('acs_summoned_shades'))
			{
				thePlayer.RemoveTag('acs_summoned_shades');
			}
			
			if (thePlayer.HasTag ('acs_ethereal_shout'))
			{
				thePlayer.RemoveTag('acs_ethereal_shout');
			}

			thePlayer.StopEffect('special_attack_only_black_fx');

			thePlayer.StopEffect('special_attack_fx');

			if ( FactsQuerySum("acs_transformation_activated") <= 0 
			&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
			)
			{
				thePlayer.BreakAttachment();
			}

			if (GetWitcherPlayer().HasTag ('acs_vampire_claws_equipped'))
			{
				GetACSWatcher().RemoveTimer('ClawDestroyDelay');

				if (thePlayer.HasTag('ACS_HasPerformedFinisher'))
				{
					GetACSWatcher().AddTimer('ClawDestroyDelay', 2 / theGame.GetTimeScale(), false );
				}
				else
				{
					GetACSWatcher().ClawDestroy();
				}
			}
			
			ACS_Skele_Destroy();

			ACS_Revenant_Destroy();

			thePlayer.StopEffect('drain_energy');

			GetACSWatcher().Remove_On_Hit_Tags();

			ACSGetCEntityDestroyAll('ACS_BerserkMark');

			ACS_HybridTagRemoval();

			ACS_Axii_Shield_Destroy_IMMEDIATE();

			ACS_Axii_Shield_Destroy();
			ACS_Axii_Shield_Destroy_DELAY();
			ACS_Quen_Monsters_Despawn();
			ACS_Bruxa_Camo_Decoy_Deactivate();
			ACS_AardPull_Deactivate();

			ACS_ThingsThatShouldBeRemoved();

			ACS_Bruxa_Camo_Decoy_Deactivate();

			GetACSWatcher().SetRageProcess(false);

			thePlayer.RemoveTag('ACS_In_Combat_Art');

			thePlayer.RemoveTag('ACS_ShadowFall');

			thePlayer.RemoveTag('ACS_Wolven_Flash');

			thePlayer.RemoveTag('ACS_Wolven_Cross');

			thePlayer.RemoveTag('ACS_Mortal_Draw');

			thePlayer.RemoveTag('ACS_Spiral_Cloud_Passage');

			thePlayer.RemoveTag('ACS_One_Mind');

			thePlayer.RemoveTag('ACS_Feainnewedd_Dance');

			//thePlayer.RemoveTag('ACS_Has_Summoned_Nekker_Guardian');
			
			//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2 / theGame.GetTimeScale(), false );

			ACSGetCEntityDestroyAll('ACS_Sign_Combo_Icon');

			ACSSignComboSystemRemoveTags();

			ACSGetCEntityDestroyAll('ACS_ShieldSpawnerShield');

			//ACSGetCEntityDestroyAll('ACS_Nekker_Life_Force');

			thePlayer.ACS_ClearAnimationSpeedMultipliers();

			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay_add1');
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay_add2');
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay_add3');
			
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay');

			GetACSWatcher().AddTimer('AdditionalSpawnsDelay', RandRangeF(ACS_Settings_Main_Float('acs_events_settings','acs_event_delay_maximum_time_in_seconds', 60), ACS_Settings_Main_Float('acs_events_settings','acs_event_delay_minimum_time_in_seconds', 30)) / theGame.GetTimeScale(), false );

			thePlayer.ResumeStaminaRegen( 'SignCast' );

			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_InstantKill) );

			if (theInput.GetActionValue('LockAndGuard') > 0.5)
			{
				if (thePlayer.GetPlayerCombatStance() != PCS_Guarded)
				{
					thePlayer.SetPlayerCombatStance(PCS_Guarded, true);
				}
			}
			else if (theInput.GetActionValue('LockAndGuard') == 0)
			{
				if (thePlayer.GetPlayerCombatStance() != PCS_Normal)
				{
					thePlayer.SetPlayerCombatStance(PCS_Normal, true);
				}
			}

			
		}
		else
		{
			thePlayer.RemoveTimer('DelayedSheathSword');
			
			thePlayer.ResumeStaminaRegen( 'SignCast' );

			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_InstantKill) );

			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 1 / theGame.GetTimeScale(), false ); 
			}

			if ( FactsQuerySum("ACS_Dual_Wield_Toggle_Enabled") > 0 
			&& thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			)
			{
				GetACSWatcher().RemoveTimer('DualWieldToggleInitDelay'); 
				GetACSWatcher().AddTimer('DualWieldToggleInitDelay', 0.25f / theGame.GetTimeScale(), false ); 
			}

			if ( FactsQuerySum("ACS_Spear_Transform_Toggle_Enabled") > 0 
			&& thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			)
			{
				GetACSWatcher().RemoveTimer('SpearTransformToggleInitDelay'); 
				GetACSWatcher().AddTimer('SpearTransformToggleInitDelay', 0.25f / theGame.GetTimeScale(), false ); 
			}

			if (ACS_Armor_Set_Check('acs_armor', false))
			{
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
			}
		}
	}
}

function ACS_CombatBehSwitch()
{
	GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
	GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);

	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	// 
	// 
	GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
	
	if (GetACSWatcher().swordWalkActive)
	{
		GetACSWatcher().setSwordwalkActive(false);
	}

	if (thePlayer.HasTag('ACS_IsSwordWalking'))
	{
		thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');thePlayer.RaiseEvent('ACS_SwordTauntEnd');

		thePlayer.RemoveTag('ACS_IsSwordWalking');
	}

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive()
	&& !ACS_New_Replacers_Female_Active()
	&& !thePlayer.IsThrowingItemWithAim()
	&& !thePlayer.IsThrowingItem()
	&& !thePlayer.IsThrowHold()
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	)
	{
		GetACSWatcher().CombatBehSwitch();

		GetACSWatcher().SetAdrenalineDrain(true);

		GetACSWatcher().register_extra_inputs();

		if (!thePlayer.IsInCombat() && !thePlayer.IsThreatened())
		{
			GetACSStorage().acs_deleteOnelinerByTag("ACS_Posture_Bar_Indicator");

			GetACSStorage().acs_deleteOnelinerByTag("ACS_Posture_Background_Bar_Indicator");

			GetACSWatcher().Ghost_Stance_Kill_Increment(false, 0);

			GetACSWatcher().IdleAdditiveBlockTemp();

			if(ACSGetCEntity('ACS_Viper_Dagger_L'))
			{
				thePlayer.RaiseEvent('ACS_LHandAttack01');
			}

			if(ACS_Settings_Main_Bool('acs_combat_main_settings','acs_enable_sword_auto_sheathe', false))
			{
				thePlayer.RemoveTimer('DelayedSheathSword');
				thePlayer.AddTimer('DelayedSheathSword', 2 / theGame.GetTimeScale(), false );
			}

			if(!thePlayer.IsAnyWeaponHeld())
			{
				GetACSWatcher().VampireClawsHybridLHandDestroy();

				thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');
				
				thePlayer.RaiseEvent('ACS_SwordTauntEnd');

				if (!ACSGetCEntity('acs_swimming_dagger'))
				{
					thePlayer.RaiseEvent('ACS_ForceHandClosedREnd');
				}

				if (!thePlayer.HasTag('ACS_Dual_Wield_Active') && !ACSGetCEntity('ACS_Viper_Dagger_L')){thePlayer.RaiseEvent('ACS_ForceHandClosedLEnd');}
			}
			
			GetACSWatcher().RemoveTimer('Air_Time_Trigger_Delay');

			if (thePlayer.HasTag('ACS_Air_Time'))
			{
				GetACSWatcher().RemoveTimer('Air_Time_Movement_Adjust_Delay');

				thePlayer.BlockAllActions( 'ACS_Air_Time_Init', false );

				thePlayer.EnableCollisions(true);

				thePlayer.RaiseEvent('ACS_FeetAdditiveEnd');

				thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_DrawWeapon, 		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_FastTravel, 		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_Movement,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_QuickSlots, 		'ACS_Air_Time');

				thePlayer.RemoveTag('ACS_Air_Time');
			}

			if (GetWitcherPlayer().HasTag ('acs_vampire_claws_equipped'))
			{
				GetACSWatcher().RemoveTimer('ClawDestroyDelay');

				if (thePlayer.HasTag('ACS_HasPerformedFinisher'))
				{
					GetACSWatcher().AddTimer('ClawDestroyDelay', 2 / theGame.GetTimeScale(), false );
				}
				else
				{
					GetACSWatcher().ClawDestroy();
				}
			}

			if (thePlayer.HasTag ('acs_summoned_shades'))
			{
				thePlayer.RemoveTag('acs_summoned_shades');
			}
			
			if (thePlayer.HasTag ('acs_ethereal_shout'))
			{
				thePlayer.RemoveTag('acs_ethereal_shout');
			}

			thePlayer.StopEffect('special_attack_only_black_fx');

			thePlayer.StopEffect('special_attack_fx');

			if ( FactsQuerySum("acs_transformation_activated") <= 0 
			&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
			)
			{
				thePlayer.BreakAttachment();
			}

			thePlayer.RemoveTag('ACS_In_Combat_Art');

			thePlayer.RemoveTag('ACS_ShadowFall');

			thePlayer.RemoveTag('ACS_Wolven_Flash');

			thePlayer.RemoveTag('ACS_Wolven_Cross');

			thePlayer.RemoveTag('ACS_Mortal_Draw');

			thePlayer.RemoveTag('ACS_Spiral_Cloud_Passage');

			thePlayer.RemoveTag('ACS_One_Mind');

			thePlayer.RemoveTag('ACS_Feainnewedd_Dance');
			
			ACS_Skele_Destroy();

			ACS_Revenant_Destroy();

			thePlayer.StopEffect('drain_energy');

			GetACSWatcher().Remove_On_Hit_Tags();

			ACSGetCEntityDestroyAll('ACS_BerserkMark');

			ACS_HybridTagRemoval();

			ACS_Axii_Shield_Destroy_IMMEDIATE();

			ACS_Axii_Shield_Destroy();
			ACS_Axii_Shield_Destroy_DELAY();
			ACS_Quen_Monsters_Despawn();
			ACS_Bruxa_Camo_Decoy_Deactivate();
			ACS_AardPull_Deactivate();

			ACS_ThingsThatShouldBeRemoved();

			ACS_Bruxa_Camo_Decoy_Deactivate();

			GetACSWatcher().SetRageProcess(false);

			//thePlayer.RemoveTag('ACS_Has_Summoned_Nekker_Guardian');
			
			//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2 / theGame.GetTimeScale(), false );

			ACSGetCEntityDestroyAll('ACS_Sign_Combo_Icon');

			ACSSignComboSystemRemoveTags();

			ACSGetCEntityDestroyAll('ACS_ShieldSpawnerShield');

			//ACSGetCEntityDestroyAll('ACS_Nekker_Life_Force');

			thePlayer.ACS_ClearAnimationSpeedMultipliers();

			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay_add1');
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay_add2');
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay_add3');
			
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay');

			GetACSWatcher().AddTimer('AdditionalSpawnsDelay', RandRangeF(ACS_Settings_Main_Float('acs_events_settings','acs_event_delay_maximum_time_in_seconds', 60), ACS_Settings_Main_Float('acs_events_settings','acs_event_delay_minimum_time_in_seconds', 30)) / theGame.GetTimeScale(), false );

			thePlayer.ResumeStaminaRegen( 'SignCast' );

			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_InstantKill) );

			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_InstantKill) );

			if (theInput.GetActionValue('LockAndGuard') > 0.5)
			{
				if (thePlayer.GetPlayerCombatStance() != PCS_Guarded)
				{
					thePlayer.SetPlayerCombatStance(PCS_Guarded, true);
				}
			}
			else if (theInput.GetActionValue('LockAndGuard') == 0)
			{
				if (thePlayer.GetPlayerCombatStance() != PCS_Normal)
				{
					thePlayer.SetPlayerCombatStance(PCS_Normal, true);
				}
			}
		
			
		}
		else
		{
			thePlayer.RemoveTimer('DelayedSheathSword');

			thePlayer.ResumeStaminaRegen( 'SignCast' );

			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_InstantKill) );
			
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 1 / theGame.GetTimeScale(), false ); 
			}

			if ( FactsQuerySum("ACS_Dual_Wield_Toggle_Enabled") > 0 
			&& thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			)
			{
				GetACSWatcher().RemoveTimer('DualWieldToggleInitDelay'); 
				GetACSWatcher().AddTimer('DualWieldToggleInitDelay', 0.25f / theGame.GetTimeScale(), false ); 
			}

			if ( FactsQuerySum("ACS_Spear_Transform_Toggle_Enabled") > 0 
			&& thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			)
			{
				GetACSWatcher().RemoveTimer('SpearTransformToggleInitDelay'); 
				GetACSWatcher().AddTimer('SpearTransformToggleInitDelay', 0.25f / theGame.GetTimeScale(), false ); 
			}

			if (ACS_Armor_Set_Check('acs_armor', false))
			{
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cBehSwitch
{
    function BehSwitch_Engage()
	{
		GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
		GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);
		this.PushState('BehSwitch_Engage');
	}

	function BehSwitch_Engage_2()
	{
		GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
		GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);
		this.PushState('BehSwitch_Engage_2');
	}

	function BehSwitch_Engage_3()
	{
		GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
		GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);
		this.PushState('BehSwitch_Engage_3');
	}
}

state BehSwitch_Engage_3 in cBehSwitch
{
	var stupidArray : array< name >;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
		{
			BehSwitch_SCAAR_3();
		}
		else if (ACS_Is_DLC_Installed('e3arp_dlc') )
		{
			BehSwitch_E3ARP_3();
		}
		else
		{
			BehSwitch_3();
		}	
	}

	entry function BehSwitch_E3ARP_3()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	entry function BehSwitch_SCAAR_3()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	entry function BehSwitch_3()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}

state BehSwitch_Engage_2 in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var stupidArray 									: array< name >;

	event OnEnterState(prevStateName : name)
	{
		defaultBehSwitchEntry();
	}

	entry function defaultBehSwitchEntry()
	{
		ACS_WeaponDestroyInit();

		ACS_HybridTagRemoval();

		if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}

		thePlayer.SetVisibility(true);

		thePlayer.EnableCollisions(true);

		thePlayer.SetCanPlayHitAnim(true); 

		thePlayer.EnableCharacterCollisions(true);

		thePlayer.RemoveBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative'); 
		thePlayer.RemoveBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical'); 
		thePlayer.RemoveBuffImmunity_AllNegative('ACS_Finisher_Immune_Negative'); 
		thePlayer.RemoveBuffImmunity_AllCritical('ACS_Finisher_Immune_Critical'); 

		Sleep(0.0625);

		if ( ACS_GetWeaponMode() == 0 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (ACS_GetWeaponMode() == 1 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();

			GetACSWatcher().SecondaryWeaponSwitch();
		}
		else if (ACS_GetWeaponMode() == 2 )
		{
			if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 0 )
			{
				if (!thePlayer.HasTag('ACSHybridDefaultWeaponTicket')){thePlayer.AddTag('ACSHybridDefaultWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 1 )
			{
				if (!thePlayer.HasTag('ACSHybridOlgierdWeaponTicket')){thePlayer.AddTag('ACSHybridOlgierdWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 2 )
			{
				if (!thePlayer.HasTag('ACSHybridEredinWeaponTicket')){thePlayer.AddTag('ACSHybridEredinWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 3 )
			{
				if (!thePlayer.HasTag('ACSHybridClawWeaponTicket')){thePlayer.AddTag('ACSHybridClawWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 4 )
			{
				if (!thePlayer.HasTag('ACSHybridImlerithWeaponTicket')){thePlayer.AddTag('ACSHybridImlerithWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 5 )
			{
				if (!thePlayer.HasTag('ACSHybridSpearWeaponTicket')){thePlayer.AddTag('ACSHybridSpearWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 6 )
			{
				if (!thePlayer.HasTag('ACSHybridGregWeaponTicket')){thePlayer.AddTag('ACSHybridGregWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 7 )
			{
				if (!thePlayer.HasTag('ACSHybridAxeWeaponTicket')){thePlayer.AddTag('ACSHybridAxeWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_light_attack', 0) == 8 )
			{
				if (!thePlayer.HasTag('ACSHybridGiantWeaponTicket')){thePlayer.AddTag('ACSHybridGiantWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
		}
		else if (ACS_GetWeaponMode() == 3 )
		{
			//GetACSWatcher().PrimaryWeaponSwitch();
		} 

		if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
		{
			ActivateBehaviors_SCAAR_Default();
		}
		else if (ACS_Is_DLC_Installed('e3arp_dlc') )
		{
			ActivateBehaviors_E3ARP_Default();
		}
		else
		{
			ActivateBehaviors_Default();
		}
	}

	latent function ActivateBehaviors_E3ARP_Default()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_SCAAR_Default()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_Default()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}
 
state BehSwitch_Engage in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var tags 											: array< name >;
	private var stupidArray 									: array< name >;

	event OnEnterState(prevStateName : name)
	{
		Beh_Switch_Entry();
	}
	
	entry function Beh_Switch_Entry()
	{
		if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
		{
			if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
			{
				BehSwitchPrime_SCAAR_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime_SCAAR();
			}
		}
		else if (ACS_Is_DLC_Installed('e3arp_dlc') )
		{
			if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
			{
				BehSwitchPrime_E3ARP_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime_E3ARP();
			}
		}
		else
		{
			if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
			{
				BehSwitchPrime_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime();
			}
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime()
	{
		ActivateBehaviors();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}

			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}

			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_silver', 'silver') && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_silver', 'silver') && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('imlerith_moveset_silver', 'silver') && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_silver', 'silver') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_steel', 'steel') && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_steel', 'steel') && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) || ACS_GetItem_Sword_IsEquipped('imlerith_moveset_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel')) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_steel', 'steel') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
						|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
					}
				}
			}
			
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_Passive_Taunt()
	{
		ActivateBehaviors_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


				
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_silver', 'silver') && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_silver', 'silver') && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('imlerith_moveset_silver', 'silver') && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_silver', 'silver') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_steel', 'steel') && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_steel', 'steel') && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) || ACS_GetItem_Sword_IsEquipped('imlerith_moveset_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel')) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_steel', 'steel') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
						|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}

		

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}

		

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_SCAAR()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}

		

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_SCAAR_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}

		

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR()
	{
		ActivateBehaviors_SCAAR();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh')
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_silver', 'silver') && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_silver', 'silver') && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('imlerith_moveset_silver', 'silver') && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_silver', 'silver') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_steel', 'steel') && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_steel', 'steel') && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) || ACS_GetItem_Sword_IsEquipped('imlerith_moveset_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel')) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_steel', 'steel') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
						|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_SCAAR_Passive_Taunt()
	{
		ActivateBehaviors_SCAAR_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_silver', 'silver') && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_silver', 'silver') && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('imlerith_moveset_silver', 'silver') && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_silver', 'silver') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_steel', 'steel') && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_steel', 'steel') && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) || ACS_GetItem_Sword_IsEquipped('imlerith_moveset_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel')) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_steel', 'steel') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
						|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_E3ARP()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}

		

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_E3ARP_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}

		

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP()
	{
		ActivateBehaviors_E3ARP();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh')
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh')
				{
					stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}

			if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_silver', 'silver') && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_silver', 'silver') && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('imlerith_moveset_silver', 'silver') && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_silver', 'silver') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_steel', 'steel') && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_steel', 'steel') && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) || ACS_GetItem_Sword_IsEquipped('imlerith_moveset_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel')) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_steel', 'steel') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
						|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_E3ARP_Passive_Taunt()
	{
		ActivateBehaviors_E3ARP_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_silver', 'silver') && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_silver', 'silver') && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('imlerith_moveset_silver', 'silver') && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_silver', 'silver') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Sword_IsEquipped('shield_sword_steel', 'steel') && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('claws_steel', 'steel') && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) || ACS_GetItem_Sword_IsEquipped('imlerith_moveset_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel')) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('olgierd_steel', 'steel') && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
						|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else if 
					(
						ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
			} 
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}

		if (GetACSWatcher().silver_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}


		if (GetACSWatcher().silver_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().silver_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_silver_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_fast_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_fast_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_group_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_group_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (GetACSWatcher().steel_strong_stance)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_steel_strong_beh' );
			}

			thePlayer.ActivateBehaviors(stupidArray);

			return;
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Spear_Transform_Sword_Steel')
		|| ACSGetCEntity('ACS_Spear_Transform_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_spear_transform_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (FactsQuerySum("ACS_Slayer_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}