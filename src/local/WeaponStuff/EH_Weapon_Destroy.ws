function ACS_WeaponDestroyInit()
{
	if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
	{
		GetACSWatcher().ClawDestroy();
	}

	if (GetWitcherPlayer().HasTag('acs_sorc_fists_equipped'))
	{
		GetACSWatcher().SorcFistDestroy();
	}

	ACS_IgniSwordDestroy();
	ACS_QuenSwordDestroy(true);
	ACS_AardSwordDestroy(true);
	ACS_YrdenSwordDestroy(true);
	ACS_AxiiSwordDestroy(true);	
	ACS_IgniSecondarySwordDestroy();
	ACS_QuenSecondarySwordDestroy(true);
	ACS_AardSecondarySwordDestroy(true);
	ACS_YrdenSecondarySwordDestroy(true);
	ACS_AxiiSecondarySwordDestroy(true);

	ACS_BowDestroy();

	ACS_CrossbowDestroy();

	ACS_Yrden_Sidearm_Destroy();

	ACS_BowArrowDestroy();

	ACS_SwordTrailDestroy();

	if (ACSGetCEntity('ACS_Frost_Sword_Ent'))
	{
		ACSGetCEntity('ACS_Frost_Sword_Ent').Destroy();
	}

	if (ACSGetCEntity('ACS_Fire_Sword_Ent'))
	{
		ACSGetCEntity('ACS_Fire_Sword_Ent').Destroy();

		ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').Destroy();

		ACSGetCEntity('ACS_Fire_Sword_Ground_Fx_Ent').Destroy();
	}

	if (ACSGetCEntity('ACS_Armor_Ether_Sword'))
	{
		ACSGetCEntity('ACS_Armor_Ether_Sword').Destroy();
	}
}

statemachine class cACSClawDestroy
{
    function ClawDestroy_Engage()
	{
		this.PushState('ClawDestroy_Engage');
	}

	function ClawDestroy_WITH_EFFECT_Engage()
	{
		this.PushState('ClawDestroy_WITH_EFFECT_Engage');
	}

	function SorcFistDestroy_Engage()
	{
		this.PushState('SorcFistDestroy_Engage');
	}
}

state ClawDestroy_Engage in cACSClawDestroy
{
	private var stupidArray 							: array< name >;
	private var morphManager 							: CMorphedMeshManagerComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}

	entry function ClawDestroy_Entry()
	{
		ACS_Blood_Armor_Destroy(true);

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');
		}

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R1').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R2').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R3').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R4').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R5').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L1').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L2').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L3').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L4').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L5').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

		
		ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

		
		ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

		
		ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

		
		ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

		
		ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

		
		ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

		
		ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

		
		ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

		
		ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

		
		ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');
	
		
		GetWitcherPlayer().RemoveTag('acs_vampire_claws_equipped');	
			
		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		if (thePlayer.IsEffectActive('acs_armor_effect_1', false))
		{
			thePlayer.StopEffect('acs_armor_effect_1');
		}
		
		if (thePlayer.IsEffectActive('acs_armor_effect_2', false))
		{
			thePlayer.StopEffect('acs_armor_effect_2');
		}

		if (thePlayer.IsEffectActive('demon_cs', false))
		{
			thePlayer.StopEffect('demon_cs');
		}

		if (thePlayer.IsEffectActive('him_smoke_red', false))
		{
			thePlayer.StopEffect('him_smoke_red');
		}

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						stupidArray.PushBack( 'igni_primary_beh' );
					}
				}
			}

			//Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}
}

state ClawDestroy_WITH_EFFECT_Engage in cACSClawDestroy
{
	private var morphManager 							: CMorphedMeshManagerComponent;
	private var components 								: array < CComponent >;
	private var drawableComponent 						: CDrawableComponent;
	private var i										: int;
	private var stupidArray 							: array< name >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_WithEffect_Entry();
	}
	
	entry function ClawDestroy_WithEffect_Entry()
	{
		ACS_Blood_Armor_Destroy(true);

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');
		}
		
		if (!ACS_GetItem_VampClaw('shades'))
		{
			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R1').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R2').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R3').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R4').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R5').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L1').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L2').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L3').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L4').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L5').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

			
			ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

			
			ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

			
			ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

			
			ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

			
			ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

			
			ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

			
			ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

			
			ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

			
			ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

			
			ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');
		}
			
		GetWitcherPlayer().RemoveTag('acs_vampire_claws_equipped');	

		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInCombat()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						stupidArray.PushBack( 'igni_primary_beh' );
					}
				}
			}

			//Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}
}

state SorcFistDestroy_Engage in cACSClawDestroy
{
	private var stupidArray 							: array< name >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		SorcFistDestroy_Entry();
	}
	
	entry function SorcFistDestroy_Entry()
	{
		GetWitcherPlayer().RemoveTag('acs_sorc_fists_equipped');	

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						stupidArray.PushBack( 'igni_primary_beh' );
					}
				}
			}

			if (stupidArray.Size() > 0)
			{
				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}
}

function ACS_Blood_Armor_Destroy( backclaw_destroy : bool )
{
	if (ACSGetCEntity('acs_vampire_extra_arms_1'))
	{
		ACSGetCEntity('acs_vampire_extra_arms_1').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_1').RemoveTag('acs_vampire_extra_arms_1');
	}

	if (ACSGetCEntity('acs_vampire_extra_arms_2'))
	{
		ACSGetCEntity('acs_vampire_extra_arms_2').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_2').RemoveTag('acs_vampire_extra_arms_2');
	}

	if (ACSGetCEntity('acs_vampire_extra_arms_3'))
	{
		ACSGetCEntity('acs_vampire_extra_arms_3').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_3').RemoveTag('acs_vampire_extra_arms_3');
	}

	if (ACSGetCEntity('acs_vampire_extra_arms_4'))
	{	

		ACSGetCEntity('acs_vampire_extra_arms_4').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_4').RemoveTag('acs_vampire_extra_arms_4');
	}

	if (ACSGetCEntity('acs_extra_arms_anchor_l'))
	{
		ACSGetCEntity('acs_extra_arms_anchor_l').BreakAttachment(); 
		ACSGetCEntity('acs_extra_arms_anchor_l').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_extra_arms_anchor_l').DestroyAfter(0.00125);
		ACSGetCEntity('acs_extra_arms_anchor_l').RemoveTag('acs_extra_arms_anchor_l');
	}

	if (ACSGetCEntity('acs_extra_arms_anchor_r'))
	{
		ACSGetCEntity('acs_extra_arms_anchor_r').BreakAttachment(); 
		ACSGetCEntity('acs_extra_arms_anchor_r').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_extra_arms_anchor_r').DestroyAfter(0.00125);
		ACSGetCEntity('acs_extra_arms_anchor_r').RemoveTag('acs_extra_arms_anchor_r');
	}

	if (ACSGetCEntity('acs_vampire_head_anchor'))
	{
		ACSGetCEntity('acs_vampire_head_anchor').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_head_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_head_anchor').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_head_anchor').RemoveTag('acs_vampire_head_anchor');
	}

	if (ACSGetCEntity('acs_vampire_head'))
	{
		thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP_Stop" );

		ACSGetCEntity('acs_vampire_head').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_head').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_head').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_head').RemoveTag('acs_vampire_head');
	}

	if (backclaw_destroy)
	{
		if (ACSGetCEntity('acs_vampire_back_claw'))
		{
			ACSGetCEntity('acs_vampire_back_claw').BreakAttachment(); 
			ACSGetCEntity('acs_vampire_back_claw').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('acs_vampire_back_claw').DestroyAfter(0.00125);
			ACSGetCEntity('acs_vampire_back_claw').RemoveTag('acs_vampire_back_claw');
		}

		if (ACSGetCEntity('acs_vampire_claw_anchor'))
		{
			ACSGetCEntity('acs_vampire_claw_anchor').BreakAttachment(); 
			ACSGetCEntity('acs_vampire_claw_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('acs_vampire_claw_anchor').DestroyAfter(0.00125);
			ACSGetCEntity('acs_vampire_claw_anchor').RemoveTag('acs_vampire_claw_anchor');
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_IgniSwordDestroy()
{	
	GetWitcherPlayer().RemoveTag('acs_igni_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_igni_sword_equipped_TAG');

	GetWitcherPlayer().RemoveTag('acs_igni_sword_effect_played');
}
	
function ACS_IgniSecondarySwordDestroy()
{	
	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_equipped_TAG');

	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_effect_played');
}
	
function ACS_QuenSwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_quen_sword_1'))
	{
		ACSGetCEntity('acs_quen_sword_1').BreakAttachment();
		ACSGetCEntity('acs_quen_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_sword_1').RemoveTag('acs_quen_sword_1');
	}

	if (ACSGetCEntity('acs_quen_sword_2'))
	{
		ACSGetCEntity('acs_quen_sword_2').BreakAttachment();
		ACSGetCEntity('acs_quen_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_sword_2').RemoveTag('acs_quen_sword_2');
	}

	if (ACSGetCEntity('acs_quen_sword_3'))
	{
		ACSGetCEntity('acs_quen_sword_3').BreakAttachment();
		ACSGetCEntity('acs_quen_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_sword_3').RemoveTag('acs_quen_sword_3');
	}
			
	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_quen_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_quen_sword_effect_played');
}
	
function ACS_QuenSecondarySwordDestroy(remove_tag : bool)
{	
	if (ACSGetCEntity('acs_quen_secondary_sword_1'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_1').RemoveTag('acs_quen_secondary_sword_1');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_2'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_2').RemoveTag('acs_quen_secondary_sword_2');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_3'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_3').RemoveTag('acs_quen_secondary_sword_3');
	}

	if (ACSGetCEntity('acs_quen_secondary_sword_4'))
	{	
		ACSGetCEntity('acs_quen_secondary_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_4').RemoveTag('acs_quen_secondary_sword_4');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_5'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_5').RemoveTag('acs_quen_secondary_sword_5');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_6'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_6').RemoveTag('acs_quen_secondary_sword_6');
	}

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_effect_played');
}
	
function ACS_AardSwordDestroy(remove_tag : bool)
{	
	if (ACSGetCEntity('acs_l_hand_anchor_1'))
	{
		ACSGetCEntity('acs_l_hand_anchor_1').BreakAttachment(); 
		ACSGetCEntity('acs_l_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_l_hand_anchor_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_l_hand_anchor_1').RemoveTag('acs_l_hand_anchor_1');
	}

	if (ACSGetCEntity('acs_r_hand_anchor_1'))
	{
		ACSGetCEntity('acs_r_hand_anchor_1').BreakAttachment(); 
		ACSGetCEntity('acs_r_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_r_hand_anchor_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_r_hand_anchor_1').RemoveTag('acs_r_hand_anchor_1');
	}

	if (ACSGetCEntity('acs_aard_blade_1'))
	{
		ACSGetCEntity('acs_aard_blade_1').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_1').RemoveTag('acs_aard_blade_1');
	}	

	if (ACSGetCEntity('acs_aard_blade_2'))
	{
		ACSGetCEntity('acs_aard_blade_2').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_2').RemoveTag('acs_aard_blade_2');
	}	

	if (ACSGetCEntity('acs_aard_blade_3'))
	{	
		ACSGetCEntity('acs_aard_blade_3').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_3').RemoveTag('acs_aard_blade_3');
	}

	if (ACSGetCEntity('acs_aard_blade_4'))
	{		
		ACSGetCEntity('acs_aard_blade_4').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_4').RemoveTag('acs_aard_blade_4');
	}

	if (ACSGetCEntity('acs_aard_blade_5'))
	{		
		ACSGetCEntity('acs_aard_blade_5').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_5').RemoveTag('acs_aard_blade_5');
	}

	if (ACSGetCEntity('acs_aard_blade_6'))
	{		
		ACSGetCEntity('acs_aard_blade_6').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_6').RemoveTag('acs_aard_blade_6');
	}

	if (ACSGetCEntity('acs_aard_blade_7'))
	{
		ACSGetCEntity('acs_aard_blade_7').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_7').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_7').RemoveTag('acs_aard_blade_7');
	}

	if (ACSGetCEntity('acs_aard_blade_8'))
	{
		ACSGetCEntity('acs_aard_blade_8').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_8').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_8').RemoveTag('acs_aard_blade_8');
	}
	
	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_aard_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_aard_sword_effect_played');
}

function ACS_AardSecondarySwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_aard_secondary_sword_1'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_1').RemoveTag('acs_aard_secondary_sword_1');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_2'))
	{	
		ACSGetCEntity('acs_aard_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_2').RemoveTag('acs_aard_secondary_sword_2');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_3'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_3').RemoveTag('acs_aard_secondary_sword_3');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_4'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_4').RemoveTag('acs_aard_secondary_sword_4');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_5'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_5').RemoveTag('acs_aard_secondary_sword_5');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_6'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_6').RemoveTag('acs_aard_secondary_sword_6');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_7'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_7').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_7').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_7').RemoveTag('acs_aard_secondary_sword_7');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_8'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_8').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_8').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_8').RemoveTag('acs_aard_secondary_sword_8');
	}	

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_effect_played');
}

function ACS_YrdenSwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_yrden_sword_1'))
	{
		ACSGetCEntity('acs_yrden_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_1').RemoveTag('acs_yrden_sword_1');
	}

	if (ACSGetCEntity('acs_yrden_sword_2'))
	{
		ACSGetCEntity('acs_yrden_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_2').RemoveTag('acs_yrden_sword_2');
	}

	if (ACSGetCEntity('acs_yrden_sword_3'))
	{		
		ACSGetCEntity('acs_yrden_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_3').RemoveTag('acs_yrden_sword_3');
	}

	if (ACSGetCEntity('acs_yrden_sword_4'))
	{		
		ACSGetCEntity('acs_yrden_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_4').RemoveTag('acs_yrden_sword_4');
	}

	if (ACSGetCEntity('acs_yrden_sword_5'))
	{		
		ACSGetCEntity('acs_yrden_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_5').RemoveTag('acs_yrden_sword_5');
	}

	if (ACSGetCEntity('acs_yrden_sword_6'))
	{		
		ACSGetCEntity('acs_yrden_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_6').RemoveTag('acs_yrden_sword_6');
	}

	if (ACSGetCEntity('acs_yrden_sword_7'))
	{
		ACSGetCEntity('acs_yrden_sword_7').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_7').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_7').RemoveTag('acs_yrden_sword_7');
	}

	if (ACSGetCEntity('acs_yrden_sword_8'))
	{
		ACSGetCEntity('acs_yrden_sword_8').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_8').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_8').RemoveTag('acs_yrden_sword_8');
	}		

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_yrden_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_yrden_sword_effect_played');
}
	
function ACS_YrdenSecondarySwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_yrden_secondary_sword_1'))
	{
		ACSGetCEntity('acs_yrden_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_1').RemoveTag('acs_yrden_secondary_sword_1');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_2'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_2').RemoveTag('acs_yrden_secondary_sword_2');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_3'))
	{	
		ACSGetCEntity('acs_yrden_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_3').RemoveTag('acs_yrden_secondary_sword_3');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_4'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_4').RemoveTag('acs_yrden_secondary_sword_4');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_5'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_5').RemoveTag('acs_yrden_secondary_sword_5');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_6'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_6').RemoveTag('acs_yrden_secondary_sword_6');
	}

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_effect_played');
}

function ACS_AxiiSwordDestroy( remove_tag : bool )
{
	if (ACSGetCEntity('acs_axii_sword_1'))
	{
		ACSGetCEntity('acs_axii_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_1').RemoveTag('acs_axii_sword_1');
	}

	if (ACSGetCEntity('acs_axii_sword_2'))
	{	
		ACSGetCEntity('acs_axii_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_2').RemoveTag('acs_axii_sword_2');
	}

	if (ACSGetCEntity('acs_axii_sword_3'))
	{		
		ACSGetCEntity('acs_axii_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_3').RemoveTag('acs_axii_sword_3');
	}

	if (ACSGetCEntity('acs_axii_sword_4'))
	{		
		ACSGetCEntity('acs_axii_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_4').RemoveTag('acs_axii_sword_4');
	}

	if (ACSGetCEntity('acs_axii_sword_5'))
	{		
		ACSGetCEntity('acs_axii_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_5').RemoveTag('acs_axii_sword_5');
	}	

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_axii_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_axii_sword_effect_played');
}
	
function ACS_AxiiSecondarySwordDestroy( remove_tag : bool )
{
	if (ACSGetCEntity('acs_axii_secondary_sword_1'))
	{
		ACSGetCEntity('acs_axii_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_axii_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_secondary_sword_1').RemoveTag('acs_axii_secondary_sword_1');
	}	

	if (ACSGetCEntity('acs_axii_secondary_sword_2'))
	{	
		ACSGetCEntity('acs_axii_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_axii_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_secondary_sword_2').RemoveTag('acs_axii_secondary_sword_2');
	}	

	if (ACSGetCEntity('acs_axii_secondary_sword_3'))
	{		
		ACSGetCEntity('acs_axii_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_axii_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_secondary_sword_3').RemoveTag('acs_axii_secondary_sword_3');
	}	

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_effect_played');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BowDestroy()
{
	if (ACSGetCEntity('acs_bow'))
	{
		ACSGetCEntity('acs_bow').BreakAttachment(); 
		ACSGetCEntity('acs_bow').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_bow').DestroyAfter(0.00125);
		ACSGetCEntity('acs_bow').RemoveTag('acs_bow');

		GetACSWatcher().AzkarFXCreate();

		GetWitcherPlayer().RemoveTag('acs_bow_equipped');
	}
}

function ACS_BowArrowDestroy()
{
	if (ACSGetCEntity('ACS_Bow_Arrow'))
	{
		ACSGetCEntity('ACS_Bow_Arrow').BreakAttachment();
		ACSGetCEntity('ACS_Bow_Arrow').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
		ACSGetCEntity('ACS_Bow_Arrow').DestroyAfter(0.125);
		ACSGetCEntity('ACS_Bow_Arrow').RemoveTag('ACS_Bow_Arrow');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_CrossbowDestroy()
{
	if (ACSGetCEntity('acs_crossbow'))
	{
		ACSGetCEntity('acs_crossbow').BreakAttachment(); 
		ACSGetCEntity('acs_crossbow').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_crossbow').DestroyAfter(0.00125);
		ACSGetCEntity('acs_crossbow').RemoveTag('acs_crossbow');
			
		GetWitcherPlayer().RemoveTag('acs_crossbow_equipped');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SwordTrailDestroy()
{
	if (ACSGetCEntity('acs_sword_trail_1'))
	{
		ACSGetCEntity('acs_sword_trail_1').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_2'))
	{
		ACSGetCEntity('acs_sword_trail_2').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_3'))
	{
		ACSGetCEntity('acs_sword_trail_3').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_4'))
	{
		ACSGetCEntity('acs_sword_trail_4').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_5'))
	{
		ACSGetCEntity('acs_sword_trail_5').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_6'))
	{
		ACSGetCEntity('acs_sword_trail_6').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_7'))
	{
		ACSGetCEntity('acs_sword_trail_7').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_8'))
	{
		ACSGetCEntity('acs_sword_trail_8').Destroy();
	}

	if (ACSGetCEntity('acs_jingubang_trail_1'))
	{
		ACSGetCEntity('acs_jingubang_trail_1').Destroy();
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_HybridTagRemoval()
{
	if (GetWitcherPlayer().HasTag('ACSHybridDefaultWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridDefaultWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridDefaultSecondaryWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridDefaultSecondaryWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridEredinWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridEredinWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridClawWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridClawWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridImlerithWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridImlerithWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridOlgierdWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridOlgierdWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridSpearWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridSpearWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridGregWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridGregWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridAxeWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridAxeWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridGiantWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridGiantWeaponTicket');
	}
}