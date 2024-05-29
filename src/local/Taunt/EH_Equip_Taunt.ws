statemachine class cEquipTaunt
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cEquipTaunt
{
	private var m_tauntTime													: float;
	private var movementAdjustor											: CMovementAdjustor;
	private var ticket 														: SMovementAdjustmentRequestTicket;
	private var actor 														: CActor;
	private var watcher														: W3ACSWatcher;
	
	event OnEnterState(prevStateName : name)
	{
		EquipTauntSwitch();
	}
	
	entry function EquipTauntSwitch()
	{
		watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Equip_Taunt_Movement_Adjust' );

		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
			
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );

		movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( actor.GetAttitude(thePlayer) == AIA_Hostile && actor.IsAlive() )
		{	
			if (!thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()) {movementAdjustor.RotateTowards( ticket, actor );}  
		}

		if 
		(
			!theGame.IsDialogOrCutscenePlaying() 
			&& !thePlayer.IsInNonGameplayCutscene() 
			&& !thePlayer.IsInGameplayScene()
			&& !thePlayer.IsSwimming()
			&& !thePlayer.IsUsingHorse()
			&& !thePlayer.IsUsingVehicle()
			&& !thePlayer.IsInAir()
			&& theInput.GetActionValue('GI_AxisLeftY') == 0 && theInput.GetActionValue('GI_AxisLeftX') == 0
		)
		{	
			if ( ACS_GetWeaponMode() == 0 )
			{	
				if (thePlayer.IsAnyWeaponHeld())
				{
					if ( !thePlayer.IsWeaponHeld( 'fist' ) )
					{
						if ( thePlayer.GetEquippedSign() == ST_Quen)
						{
							if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
							{
								RegularTaunt();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
							{
								OlgierdTaunt();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
							{
								EredinTaunt();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
							{
								ClawTaunt();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
							{
								ImlerithTaunt();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Aard)
						{
							if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
							{
								RegularTaunt();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
							{
								OlgierdTaunt();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
							{
								EredinTaunt();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
							{
								ClawTaunt();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
							{
								ImlerithTaunt();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Axii)
						{
							if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
							{
								RegularTaunt();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
							{
								OlgierdTaunt();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
							{
								EredinTaunt();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
							{
								ClawTaunt();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
							{
								ImlerithTaunt();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Yrden)
						{
							if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
							{
								RegularTaunt();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
							{
								OlgierdTaunt();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
							{
								EredinTaunt();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
							{
								ClawTaunt();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
							{
								ImlerithTaunt();
							}	
						}	
						else if ( thePlayer.GetEquippedSign() == ST_Igni)
						{
							if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
							{
								RegularTaunt();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
							{
								OlgierdTaunt();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
							{
								EredinTaunt();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
							{
								ClawTaunt();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
							{
								ImlerithTaunt();
							}
						}
					}
					else
					{
						if (ACS_GetFistMode() == 1)
						{
							ClawTaunt();
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

							Sleep(0.025);

							thePlayer.RaiseEvent( 'CombatTaunt' );
						}
					}
				}
			}
			else if ( ACS_GetWeaponMode() == 1 )
			{
				if ( 
				ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') 
				)
				{
					OlgierdTaunt();
				}
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') 
				)
				{
					ClawTaunt();
				}
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped')
				)
				{
					EredinTaunt();	
				}
				else if ( ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') 
				)
				{
					ImlerithTaunt();	
				}	
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped')
				|| ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped')
				)
				{
					RegularTaunt();	
				}
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
				)
				{
					ImlerithTaunt();	
				}
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
				)
				{
					EredinTaunt();	
				}
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 6  && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
				)
				{
					ImlerithTaunt();	
				}
				else if ( 
				ACS_GetFocusModeSilverWeapon() == 8  && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
				)
				{
					RegularTaunt();	
				}
				else if ( thePlayer.IsWeaponHeld( 'fist' ) )
				{
					if ( ACS_GetFistMode() == 1 )
					{
						ClawTaunt();	
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

						Sleep(0.025);
							
						thePlayer.RaiseEvent( 'CombatTaunt' );
					}
				}
			}
			
			else if ( ACS_GetWeaponMode() == 2 )
			{
				if 
				(
					thePlayer.HasTag('acs_quen_sword_equipped')
				)
				{
					OlgierdTaunt();
				}
				else if 
				(
					thePlayer.HasTag('acs_aard_sword_equipped')
				)
				{
					ClawTaunt();
				}
				else if 
				(
					thePlayer.HasTag('acs_axii_sword_equipped')
				)
				{
					EredinTaunt();	
				}
				else if
				(
					thePlayer.HasTag('acs_yrden_sword_equipped')
				)
				{
					ImlerithTaunt();	
				}	
				else if
				(
					thePlayer.HasTag('acs_igni_secondary_sword_equipped')
				)
				{
					RegularTaunt();	
				}
				else if 
				( 
					thePlayer.HasTag('acs_quen_secondary_sword_equipped')
				)
				{
					ImlerithTaunt();	
				}
				else if 
				(
					thePlayer.HasTag('acs_axii_secondary_sword_equipped')
				)
				{
					EredinTaunt();	
				}
				else if 
				( 
					thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
				)
				{
					ImlerithTaunt();	
				}
				else if 
				( 
					thePlayer.HasTag('acs_aard_secondary_sword_equipped')
				)
				{
					RegularTaunt();	
				}
				else if ( thePlayer.IsWeaponHeld( 'fist' ) )
				{
					if ( ACS_GetFistMode() == 1 )
					{
						ClawTaunt();	
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

						Sleep(0.025);

						thePlayer.RaiseEvent( 'CombatTaunt' );
					}
				}
			}
			
			else if ( ACS_GetWeaponMode() == 3 )
			{
				if ( 
				ACS_GetItem_Olgierd_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') 
				|| ACS_GetItem_Olgierd_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped')
				)
				{
					OlgierdTaunt();
				}
				else if ( 
				ACS_GetItem_Claws_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') 
				|| ACS_GetItem_Claws_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped')
				)
				{
					ClawTaunt();
				}
				else if ( 
				ACS_GetItem_Eredin_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') 
				|| ACS_GetItem_Eredin_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped')
				)
				{
					EredinTaunt();	
				}
				else if ( 
				ACS_GetItem_Imlerith_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') 
				|| ACS_GetItem_Imlerith_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped')
				)
				{
					ImlerithTaunt();	
				}	
				else if ( 
				ACS_GetItem_Spear_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
				|| ACS_GetItem_Spear_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
				)
				{
					ImlerithTaunt();	
				}
				else if ( 
				ACS_GetItem_Greg_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
				|| ACS_GetItem_Greg_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
				)
				{
					EredinTaunt();	
				}
				else if ( 
				ACS_GetItem_Hammer_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
				|| ACS_GetItem_Hammer_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
				)
				{
					ImlerithTaunt();	
				}
				else if ( 
				ACS_GetItem_Axe_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
				|| ACS_GetItem_Axe_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
				)
				{
					RegularTaunt();	
				}
				else if ( thePlayer.IsWeaponHeld( 'fist' ) )
				{
					if( ( ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()) )
					{
						ClawTaunt();	
					}
					else
					{
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

						Sleep(0.025);

						thePlayer.RaiseEvent( 'CombatTaunt' );
					}
				}
				else
				{
					RegularTaunt();	
				}
			}

			if ( RandF() < 0.25 )
			{
				playerTaunt();
			}
		}	
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
		}
	}

	latent function playerTaunt() 
	{
		if (theGame.GetEngineTimeAsSeconds() - m_tauntTime < 2) return;

		if (thePlayer.IsInCombat())
		{
			watcher.player_comment_index_EQUIP_TAUNT = RandDifferent(watcher.previous_player_comment_index_EQUIP_TAUNT , 5);

			switch (watcher.player_comment_index_EQUIP_TAUNT) 
			{
				case 4:
				thePlayer.PlayBattleCry( 'BattleCryHumansEnd', 1, true, true);
				break;			
						
				case 3:
				thePlayer.PlayBattleCry( 'BattleCryMonstersEnd', 1, true, true);
				break;	
						
				case 2:
				thePlayer.PlayBattleCry( 'BattleCryHumansHit', 1, true, true);
				break;	
						
				case 1:
				thePlayer.PlayBattleCry( 'BattleCryMonstersHit', 1, true, true);
				break;	
						
				default:
				thePlayer.PlayBattleCry('BattleCryTaunt', 1, true, true);
				break;
			}

			watcher.previous_player_comment_index_EQUIP_TAUNT = watcher.player_comment_index_EQUIP_TAUNT;
		}
		
		m_tauntTime = theGame.GetEngineTimeAsSeconds();
	}
	
	latent function OlgierdTaunt() 
	{
		var anim_names						: array< name >;
	
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if(thePlayer.IsInCombat())
		{
			if(thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.5)
			{
				anim_names.Clear();
				anim_names.PushBack('ethereal_wakeup_buff_idle_001_ACS');
				anim_names.PushBack('ethereal_wakeup_buff_idle_002_ACS');
				anim_names.PushBack('ethereal_wakeup_buff_idle_003_ACS');
				anim_names.PushBack('ethereal_wakeup_buff_idle_004_ACS');
				anim_names.PushBack('ethereal_buff_idle_001_ACS');
				anim_names.PushBack('ethereal_buff_idle_002_ACS');
				anim_names.PushBack('ethereal_buff_idle_003_ACS');
				anim_names.PushBack('ethereal_buff_idle_004_ACS');

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( anim_names[RandRange(anim_names.Size())], 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f) );	
			}
			else
			{	
				watcher.olgierd_taunt_index = RandDifferent(watcher.previous_olgierd_taunt_index , 24);

				switch (watcher.olgierd_taunt_index) 
				{	
					case 23:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_righttoleft_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					case 22:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_lefttoright_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;

					case 21:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_9_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 20:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_8_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 19:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_8_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 18:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 17:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 16:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 15:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 14:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 13:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 12:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 11:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;
						
					case 10:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					case 9:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_down_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
					
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_005_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;			
						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
						
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_intro_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
					break;	
				}

				watcher.previous_olgierd_taunt_index = watcher.olgierd_taunt_index;
			}
		}
	}
					
	latent function RegularTaunt() 
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if(thePlayer.IsInCombat())
		{
			watcher.regular_taunt_index = RandDifferent(watcher.previous_regular_taunt_index , 24);

			switch (watcher.regular_taunt_index) 
			{
				case 23:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 22:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 21:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 20:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 19:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 18:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_3_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_3_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_2_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_2_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_19_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_18_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_17_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_16_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_15_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_14_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_13_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_12_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_11_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_10_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_1_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_1_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}
			watcher.previous_regular_taunt_index = watcher.regular_taunt_index;
		}
	}
			
	latent function EredinTaunt() 
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if(thePlayer.IsInCombat())
		{
			watcher.eredin_taunt_index = RandDifferent(watcher.previous_eredin_taunt_index , 17);

			switch (watcher.eredin_taunt_index) 
			{	
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_taunt_2_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_taunt_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_05_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_04_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_03_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_02_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_01_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}
			watcher.previous_eredin_taunt_index = watcher.eredin_taunt_index;
		}
	}
			
	latent function ImlerithTaunt() 
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if(thePlayer.IsInCombat())
		{
			watcher.imlerith_taunt_index = RandDifferent(watcher.previous_imlerith_taunt_index , 14);

			switch (watcher.imlerith_taunt_index) 
			{				
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_03_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_02_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_01_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_04_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
			}
			watcher.previous_imlerith_taunt_index = watcher.imlerith_taunt_index;
		}
	}
			
	latent function ClawTaunt() 
	{
		var vamp_sound_names																											: array< string >;

		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}

		vamp_sound_names.Clear();
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt_claws");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big_short");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_roar");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_heavy_charge");

		thePlayer.SoundEvent(vamp_sound_names[RandRange(vamp_sound_names.Size())]);
		
		watcher.claw_taunt_index = RandDifferent(watcher.previous_claw_taunt_index , 2);

		switch (watcher.claw_taunt_index) 
		{	
			case 1:
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_taunt_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
			break;	
					
			default:
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_taunt_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
			break;	
		}

		watcher.previous_claw_taunt_index = watcher.claw_taunt_index;
	}
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}