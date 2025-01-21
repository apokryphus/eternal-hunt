@wrapMethod( CTicketBaseAlgorithm ) function ShouldAskForTicket() : bool
{
	var target 				: CActor = GetCombatTarget();
	var owner 				: CActor = GetActor();
	var morale : float;
	var playerState : name;

	if(false) 
	{
		wrappedMethod();
	}
	
	if ( target == thePlayer )
	{
		playerState = thePlayer.substateManager.GetStateCur();
		
		if ( playerState == 'Climb' || playerState == 'Interaction' )
		{
			return false;
		}
		
		if ( thePlayer.IsInHitAnim() )
			return false;
			
		if ( thePlayer.IsCurrentlyDodging() )
			return false;
		
		if ( resetImportanceOnSpecialCombatAction && ((W3PlayerWitcher)target) )
		{
			if ( ((W3PlayerWitcher)target).IsInCombatAction_SpecialAttackHeavy() )
				return false;
		}
		
		if ( thePlayer.IsPerformingFinisher() )
			return false;
			
		if (thePlayer.HasTag('ACS_IsPerformingFinisher')
		|| thePlayer.HasTag('acs_blood_sucking')
		|| ( ( CNewNPC ) owner ).HasTag('ACS_Final_Fear_Stack')
		|| thePlayer.HasTag('ACS_Transformation_Bruxa_Cloaked')
		|| thePlayer.HasTag('ACS_Ghost_Stance_Active')
		|| thePlayer.HasTag('ACS_Is_Sneaking')
		)
		{
			return false;
		}
		
	}
	
	
	
	
	
	if ( !( ( CNewNPC ) owner ).CanAttackKnockeddownTarget() && ( target.HasBuff(EET_Knockdown) || target.HasBuff(EET_HeavyKnockdown) ) )
	{
		return false;
	}
	
	
	morale = owner.GetStatPercents(BCS_Morale);
	if( morale != -1 && morale < 1.f )
		return false;
	
	
	if ( owner == thePlayer.GetTarget() && thePlayer.IsInCombatAction_Attack() && !thePlayer.GetBIsInputAllowed() )
	{
		return false;
	}
	
	
	if ( target != thePlayer && !target.GetGameplayVisibility() && !owner.HasTag( 'regis' ) ) 
	{
		return false;
	}
	
	return true;
}
	
@wrapMethod( CTicketAlgorithmApproach ) function CalculateTicketImportance() : float
{
	var importance : float = 100.f;
	var owner : CActor = GetActor();

	if(false) 
	{
		wrappedMethod();
	}
	
	if ( !ShouldAskForTicket() )
		return 0;	
	
	importance += GetDistanceImportance();
	
	importance += GetActivationImportance();
	
	importance += GetThreatLevelImportance();

	if (thePlayer.IsPerformingFinisher()
	|| thePlayer.HasTag('ACS_IsPerformingFinisher')
	|| thePlayer.HasTag('acs_blood_sucking')
	|| ( ( CNewNPC ) owner ).HasTag('ACS_Final_Fear_Stack')
	|| thePlayer.HasTag('ACS_Transformation_Bruxa_Cloaked')
	|| thePlayer.HasTag('ACS_Ghost_Stance_Active')
	|| thePlayer.HasTag('ACS_Is_Sneaking')
	)
	{
		if ( thePlayer.GetAttitude( ( ( CNewNPC ) owner ) ) == AIA_Hostile  )
		{
			return 0;
		}
	}
	
	return importance;
}

@wrapMethod( CTicketAttackAlgorithm ) function CalculateTicketImportance() : float
{
	var importance 			: float = 100.f;
	var npc					: CNewNPC = GetNPC();
	
	if(false) 
	{
		wrappedMethod();
	}
	
	if ( npc && npc.ShouldAttackImmidiately() )
	{
		overrideTicketsCount = 0;
		return 10000;
	}
	
	if ( !ShouldAskForTicket() )
		return 0;
	
	if ( denyTicketWhenNotInFrame && !thePlayer.WasVisibleInScaledFrame( npc, 1.f, 1.f ) )
		return 0;
		
	if ( !invertDistanceImportance )
		importance += GetDistanceImportance();
	else
		importance += GetInvertedDistanceImportance();
	
	importance += GetActivationImportance();
	
	importance += GetThreatLevelImportance();
	
	if ( importance <= 100 )
	{
		LogChannel('CombatTicketSystem',"Warning! Ticket Importance for: " + GetActor() + " less then 100.");
	}
	
	if ( overrideDefaultTicketCount )
	{
		if ( !GetCombatTarget().IsRotatedTowards( npc, 150 ) )
		{
			overrideTicketsCount = overridenValueWhenInBack;
		}
		else
			overrideTicketsCount = overridenValueWhenInFront;
	}

	if (ACS_Enabled())
	{
		overrideTicketsCount = 0;
		
		importance = ACS_AttackImportance(npc);

	}//EternalHunt

	return importance;
}

///////////////////////////////////////////////////////////////////////////////////

@wrapMethod(CR4IngameMenu) function OnChangeKeybind(keybindTag:name, newKeybindValue:EInputKey):void
{
	var newSettingString : string;
	var exisitingKeybind : name;
	var groupIndex : int;
	var keybindChangedMessage : string;
	var numKeybinds : int;
	var i : int;
	var currentBindingTag : name;
	
	var iterator_KeybindName : name;
	var iterator_KeybindKey : string;

	if(false) 
	{
		wrappedMethod(keybindTag, newKeybindValue);
	}
	
	hasChangedOption = true;
	
	newSettingString = newKeybindValue;
	
	
	
	{
		groupIndex = IngameMenu_GetPCInputGroupIndex();
	
		if (groupIndex != -1)
		{
			numKeybinds = mInGameConfigWrapper.GetVarsNumByGroupName('PCInput');
			currentBindingTag = 'input_overlap5'; //EternalHunt
			
			for (i = 0; i < numKeybinds; i += 1)
			{
				iterator_KeybindName = mInGameConfigWrapper.GetVarName(groupIndex, i);
				iterator_KeybindKey = mInGameConfigWrapper.GetVarValue('PCInput', iterator_KeybindName);
				
				iterator_KeybindKey = StrReplace(iterator_KeybindKey, ";IK_None", ""); 
				iterator_KeybindKey = StrReplace(iterator_KeybindKey, "IK_None;", "");
				
				if (iterator_KeybindKey == newSettingString && iterator_KeybindName != keybindTag && 
					(currentBindingTag == '' || currentBindingTag != 'input_overlap5')) //EternalHunt
				{
					if (keybindChangedMessage != "")
					{
						keybindChangedMessage += ", ";
					}
					keybindChangedMessage += IngameMenu_GetLocalizedKeybindName(iterator_KeybindName);
					OnClearKeybind(iterator_KeybindName);
				}
			}
		}
		
		if (keybindChangedMessage != "")
		{
			keybindChangedMessage += " </br>" + GetLocStringByKeyExt("key_unbound_message");
			showNotification(keybindChangedMessage);
		}
	}
	
	newSettingString = newKeybindValue + ";IK_None"; 
	mInGameConfigWrapper.SetVarValue('PCInput', keybindTag, newSettingString);
	SendKeybindData();
	
	
	if(keybindTag == 'DrinkPotion1')
		OnChangeKeybind('DrinkPotion1Hold', newKeybindValue);
	else if(keybindTag == 'DrinkPotion2')
		OnChangeKeybind('DrinkPotion2Hold', newKeybindValue);
	else if(keybindTag == 'DrinkPotion3')
		OnChangeKeybind('DrinkPotion3Hold', newKeybindValue);
	else if(keybindTag == 'DrinkPotion4')
		OnChangeKeybind('DrinkPotion4Hold', newKeybindValue);
	
}

///////////////////////////////////////////////////////////////////////////////////

@wrapMethod( CR4LocomotionPlayerControllerScript) function CalculateMoveSpeed() : float
{
	var speedVec 		: Vector;
	var speed 			: float;		
	var rawRightJoyVec	: Vector;		
	var tempInt			: int;		
	var terrainAngles	: EulerAngles;		
	var currentTime		: float;		
	var forceWalkSpeed	: bool;		
	
	if(false) 
	{
		wrappedMethod();
	}
	
	if ( thePlayer.IsCameraControlDisabled( 'Finisher' ) || thePlayer.HasTag('ACS_IsPerformingFinisher'))
	{
		speed = 0;
	}
	else if ( _inputLocoEnabled )
	{
		speed = _inputMagLastCached;
	}
	else
	{
		
		
		speed	= thePlayer.substateManager.m_InputO.GetModuleF();
	}
	
	
	if( thePlayer.IsSwimming() )
	{
		if ( thePlayer.rangedWeapon 
			&& thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait'
			&& thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponHolster' )
		{
			speed = 0;
		}
	}
	
	player.terrainPitch 		= 90.0f - player.substateManager.m_MoverO.GetRealSlideAngle();
	
	
	
	
	
	
	if( ACS_CanSprint( speed ) ) // EternalHunt
	{
		if ( thePlayer.IsInCombat() 
			&& thePlayer.moveTarget 
			&& VecDistance( thePlayer.moveTarget.GetWorldPosition(), thePlayer.GetWorldPosition() ) < thePlayer.findMoveTargetDistMax )
		{
			thePlayer.SetIsSprinting(true);
			
			if ( thePlayer.modifyPlayerSpeed || thePlayer.interiorCamera )
				thePlayer.EnableSprintingCamera( false );
			else if ( thePlayer.GetSprintingTime() > 0.2 && !thePlayer.IsInCombatAction() )
				thePlayer.EnableSprintingCamera( true );
			else
				thePlayer.EnableSprintingCamera( false );
		}
		else 
		{
			thePlayer.SetIsSprinting(true);
			
			if ( thePlayer.modifyPlayerSpeed || thePlayer.interiorCamera  )
				thePlayer.EnableSprintingCamera( false );
			else
				thePlayer.EnableSprintingCamera( true );
		}
	}
	else
	{
		
		if ( !player.disableSprintingTimerEnabled && player.GetIsSprinting() )
		{
			player.disableSprintingTimerEnabled = true;
			player.AddTimer( 'DisableSprintingTimer', 0.25f );	
		}		
	}
	
	
	if ( player.modifyPlayerSpeed )
	{
		if ( speed > 0.0f )
		{
			if ( thePlayer.IsRunPressed() )
				speed = speedRunning;
			else
				speed = ClampF( speed, 0.f, speedWalkingMax );
		}
	}
	
	else if( !thePlayer.IsActionAllowed( EIAB_Sprint ) && thePlayer.IsActionAllowed( EIAB_RunAndSprint ) && !thePlayer.IsCombatMusicEnabled() )
	{	
		if ( speed <= 0.f )
		{
			player.playerMoveType = PMT_Idle;
		}
		else if( thePlayer.IsSprintActionPressed() )
		{
			
			if(theInput.LastUsedGamepad() && thePlayer.GetLeftStickSprint() && thePlayer.IsInInterior() && !thePlayer.GetIsSprintToggled())
			{
				speed = MapF( MinF( speed, speedRunning ), 0.0f, speedRunning, 0.0f,  speedWalkingMax );
				player.playerMoveType = PMT_Walk;
			}	
			
			else if ( speed > 0.8f )
			{
				speed = MinF( speed, speedRunning );
				player.playerMoveType = PMT_Run;
			}
			else
			{
				speed = speedWalkingMax;
				player.playerMoveType = PMT_Walk;
			}
		}
		else
		{
			speed = MapF( MinF( speed, speedRunning ), 0.0f, speedRunning, 0.0f,  speedWalkingMax );
			player.playerMoveType = PMT_Walk;
		}			
	}
	
	else
	{
		if ( theInput.LastUsedGamepad() )
		{
			if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodWalkingByDefaultEnabled', true))
			{
				if ( theInput.GetActionValue('Sprint') > 0.1 )
				{
					thePlayer.SetWalkToggle(false);
				}
				else
				{
					thePlayer.SetWalkToggle(true);
				}
			}
			else
			{
				thePlayer.SetWalkToggle(false);
			}
		}
		
		if ( speed <= 0.f )
		{
			player.playerMoveType = PMT_Idle;
		}
		else if (!theGame.IsFading() && !theGame.IsBlackscreen())
		{
			if ( player.GetIsSprinting() )
			{	
				speed = speedSprinting;
				player.playerMoveType = PMT_Sprint;
			}
			else if ( speed > thePlayer.GetInputModuleNeededToRun()
					&& ( thePlayer.IsActionAllowed( EIAB_RunAndSprint ) || thePlayer.IsCombatMusicEnabled() )
					&& ( ( thePlayer.GetPlayerCombatStance() == PCS_Normal && !thePlayer.GetIsWalkToggled() )
						|| thePlayer.GetPlayerCombatStance() == PCS_AlertFar 
						|| ( !thePlayer.GetIsWalkToggled() && !thePlayer.IsInCombat() && VecLength2D( speedVec ) > thePlayer.GetInputModuleNeededToRun() ) )
					)
			{
				speed =  MinF( speed, speedRunning );
				player.playerMoveType = PMT_Run;
				
				currentTime = EngineTimeToFloat( theGame.GetEngineTime() );
				
				if ( localMoveDirection > 0.7f )
				{
					if ( !isCheckingCommitToRightTurn )
					{
						isCheckingCommitToRightTurn = true;
						commitToRightTurnTimeStamp = currentTime;
					}
					
					if ( isCheckingCommitToRightTurn )
					{
						if ( currentTime >= commitToRightTurnTimeStamp + 0.25 )
						{
							directionSwitchTimeStampDelta = 0.f;
							isCheckingCommitToRightTurn = false;
							isTurningRight = true;
						}
					}
				}
				else if ( localMoveDirection < -0.7f )
				{				
					if ( !isCheckingCommitToLeftTurn )
					{
						isCheckingCommitToLeftTurn = true;
						commitToLeftTurnTimeStamp = currentTime;
					}
					
					if ( isCheckingCommitToLeftTurn )
					{
						if ( currentTime >= commitToLeftTurnTimeStamp + 0.25f )
						{
							directionSwitchTimeStampDelta = 0.f;
							isCheckingCommitToLeftTurn = false;
							isTurningLeft = true;
						}
					}	
				}
				
				if ( localMoveDirection > 0.f )
				{
					useLeftTurnTimeStamp = false;
					if ( isTurningLeft )
					{
						directionSwitchTimeStamp = currentTime;
						directionSwitchTimeStampDelta = 1.f;
						startRightTurnTimeStamp = currentTime;
						useRightTurnTimeStamp = true;
					}
					
					if ( useRightTurnTimeStamp && localMoveDirection > 0.3f )
					{
						if ( currentTime >= startRightTurnTimeStamp + 0.25 )
						{
							directionSwitchTimeStampDelta = 0.f;
						}
					}
						
					isTurningLeft = false;
					isCheckingCommitToLeftTurn = false;							
				}
				else if ( localMoveDirection < 0.f )
				{
					useRightTurnTimeStamp = false;
					if ( isTurningRight )
					{
						directionSwitchTimeStamp = currentTime;
						directionSwitchTimeStampDelta = 1.f;
						startLeftTurnTimeStamp = currentTime;
						useLeftTurnTimeStamp = true;
					}

					if ( useLeftTurnTimeStamp && localMoveDirection < -0.3f )
					{						
						if ( currentTime >= startLeftTurnTimeStamp + 0.25f )
						{
							directionSwitchTimeStampDelta = 0.f;
						}
					}
						
					isTurningRight = false;
					isCheckingCommitToRightTurn = false;							
				}					
				
				if ( currentTime < directionSwitchTimeStamp + directionSwitchTimeStampDelta )
				{
					if ( localMoveDirection >= -0.3f && localMoveDirection <= 0.3f )
					{
						if ( !isCheckingCentered )
						{
							isCheckingCentered = true;
							directionCenteredTimeStamp = currentTime;
						}
						else
						{
							if ( currentTime >= directionCenteredTimeStamp + 0.f )
							{
								isCheckingCentered = false;
								directionSwitchTimeStampDelta = 0.f;
								isCheckingCommitToRightTurn = false;
								isCheckingCommitToLeftTurn = false;
							}
						}
					}	
					else
						isCheckingCentered = false;				
				
					forceWalkSpeed = true;
					speed = speedWalkingMax;
				}
				else
					isCheckingCentered = false;
				
				if ( forceWalkSpeed )
					player.SetBehaviorVariable( 'forceWalkSpeed', 1 );
				else
					player.SetBehaviorVariable( 'forceWalkSpeed', 0 );
			}
			else
			{
				speed = speedWalkingMax; 
				player.playerMoveType = PMT_Walk;					
			}
		}
		else
		{
			speed = speedWalkingMax; 
			player.playerMoveType = PMT_Walk;
		}
	}
	
	if ( player.playerMoveType < PMT_Walk || (player.playerMoveType <= PMT_Run && !theGame.IsFocusModeActive() && !thePlayer.IsInAir()) )	
	{	
		if(thePlayer.IsInInterior() && player.playerMoveType >= PMT_Walk )
		{
			if(thePlayer.IsInCombat() && thePlayer.GetStatPercents(BCS_Stamina) <= 0.f)
				thePlayer.SetSprintToggle( false );
		}
		else if(!thePlayer.IsActionAllowed( EIAB_Sprint ) && thePlayer.IsActionAllowed( EIAB_RunAndSprint ) && player.playerMoveType >= PMT_Walk)
		{}
		else
			thePlayer.SetSprintToggle( false );
	}
	
	
	
		
	
	tempInt = (int)( player.playerMoveType );
	player.substateManager.SetBehaviorParamBool(  'onSteepSlope', thePlayer.IsTerrainTooSteepToRunUp() );    
	player.SetBehaviorVariable( 'terrainPitch', player.terrainPitch );
	player.SetBehaviorVariable( 'playerMoveType', tempInt );
	player.SetBehaviorVariable( 'playerMoveTypeForOverlay', tempInt );
	player.substateManager.SetBehaviorParamBool( 'runInputPressed', thePlayer.IsSprintActionPressed() );		
	player.substateManager.SetBehaviorParamBool( 'ikWeight',  player.playerMoveType == PMT_Walk || player.playerMoveType == PMT_Idle );
	
	
	
	rawRightJoyVec.X = theInput.GetActionValue( 'GI_AxisRightX' ); 
	rawRightJoyVec.Y = theInput.GetActionValue( 'GI_AxisRightY' );
	player.SetBehaviorVariable( 'cameraSpeed', VecLength2D( rawRightJoyVec ) );
	
	
	return speed;
}

///////////////////////////////////////////////////////////////////////////////////

@wrapMethod( WeaponHolster ) function GetMostConvenientMeleeWeapon( targetToDrawAgainst : CActor, optional ignoreActionLock : bool ) : EPlayerWeapon
{
	var ret : EPlayerWeapon;
	var inv : CInventoryComponent;
	var heldItems	: array<name>;
	var mountedItems	: array<name>;
	var hasPhysicalWeapon, disableAutoSheathe : bool;
	var i : int;
	var npc : CNewNPC;
	var inGameConfigWrapper : CInGameConfigWrapper;

	if(false) 
	{
		wrappedMethod(targetToDrawAgainst, ignoreActionLock);
	}
	
	if ( (W3ReplacerCiri)thePlayer  )
	{
		if ( targetToDrawAgainst )
			return PW_Steel;
		else
			return PW_None;
	}
	
	
	
	if( !automaticUnholster )
	{
		return PW_Fists;
	}
	
	
	if ( !targetToDrawAgainst )
	{
		return PW_Fists;
	}
	
	
	targetToDrawAgainst.GetInventory().GetAllHeldAndMountedItemsCategories( heldItems, mountedItems );
	
	if ( heldItems.Size() > 0 )
	{
		for ( i = 0; i < heldItems.Size(); i += 1 )
		{
			if ( heldItems[i] != 'fist' )
			{
				hasPhysicalWeapon = true;
				break;
			}
		}
	}
	
	if ( !hasPhysicalWeapon && targetToDrawAgainst.GetInventory().HasHeldOrMountedItemByTag( 'ForceMeleeWeapon' ) )
	{
		hasPhysicalWeapon = true;
	}
	
	npc = (CNewNPC)targetToDrawAgainst;
	
	if ( targetToDrawAgainst.IsHuman() && ( !hasPhysicalWeapon || ( targetToDrawAgainst.GetAttitude( thePlayer ) != AIA_Hostile ) ) ) 
	{
		ret = PW_Fists;
	}
	else if ( npc.IsHorse() && !npc.GetHorseComponent().IsDismounted() ) 
	{
		ret = PW_Fists;
	}
	else
	{
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		disableAutoSheathe = inGameConfigWrapper.GetVarValue( 'Gameplay', 'DisableAutomaticSwordSheathe' );
		
		if( disableAutoSheathe )
		{
			ret = PW_Fists;
		}
		else
		{
			
			if(targetToDrawAgainst.UsesVitality())
			{
				ret = PW_Steel;
			}
			else if(targetToDrawAgainst.UsesEssence())
			{
				ret = PW_Silver;
			}
			else
			{
				LogAssert(false, "CR4Player.weaponHolsterSelectWeaponToDraw: target has neither vitality nor essesnce - don't know which weapon to use!");
				ret = PW_Fists;
			}
		}
	}
	
	inv = GetOwner().GetInventory();
	if(ret == PW_Steel && !GetWitcherPlayer().IsItemEquippedByCategoryName( 'steelsword' ) )
	{
		ret = PW_Fists;
	}
	else if(ret == PW_Silver && !GetWitcherPlayer().IsItemEquippedByCategoryName( 'silversword' ) )
	{
		ret = PW_Fists;
	}
	
	if ( thePlayer.IsWeaponActionAllowed( ret ) || ignoreActionLock )
	{
		return ACS_GetMostConvenientMeleeWeapon(targetToDrawAgainst); //EternalHunt
	}
	else
	{
		return PW_None;
	}
}

@wrapMethod( SelectingWeapon ) function OnEquippedMeleeWeapon( weaponType : EPlayerWeapon )
{
	wrappedMethod(weaponType);
	
	ACS_Equip_Weapon( weaponType );
}

@wrapMethod( SelectingWeapon ) function EquipMeleeWeapon( weapontype : EPlayerWeapon, optional sheatheIfAlreadyEquipped : bool )
{
	var isAWeapon																								: bool;
	var fists 																									: W3PlayerWitcherStateCombatFists;
	var item, item2, steelid, silverid 																			: SItemUniqueId;
	var items 																									: array<SItemUniqueId>;
	var owner 																									: CActor;
		
	if(false) 
	{
		wrappedMethod(weapontype, sheatheIfAlreadyEquipped);
	}

	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

	if (thePlayer.HasTag('ACS_IsSwordWalking'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalking');
	}

	if( thePlayer.GetCurrentStateName() == 'PlayerDialogScene' )
	{
		thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');

		return;
	}	

	thePlayer.SetBehaviorVariable( 'holsterReadyToSkip', 0.0f, true );
	
	parent.UnqueueMeleeWeapon( );
	
	
	isAWeapon	= weapontype == PW_Silver || weapontype == PW_Steel;	
	
	
	if( parent.IsThisWeaponAlreadyEquipped( weapontype ) )
	{
		if( sheatheIfAlreadyEquipped && isAWeapon )
		{
			if( thePlayer.IsInCombat() )
			{
				weapontype	= PW_Fists;
			}
			else
			{
				weapontype	= PW_None;
			}
			isAWeapon	= false;
		}
		
		else
		{
			return;
		}
	}	
	
	owner = parent.GetOwner();
	
	
	fists = ((W3PlayerWitcherStateCombatFists)owner.GetState('Combat'));
	if( fists )
	{
		fists.comboPlayer.StopAttack();
	}

	parent.SetCurrentMeleWeapon( weapontype );	
	
	Lock();
	
	parent.UpdateBehGraph();

	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

	if (thePlayer.IsCiri() || thePlayer.IsSwimming() || thePlayer.IsDiving())
	{
		switch( weapontype )
		{
			case PW_None :
				thePlayer.SetRequiredItems('Any', 'None');
				thePlayer.ProcessRequiredItems();
				break;
			case PW_Fists : 

				if ( !thePlayer.inv.HasItem('Geralt fists') && !thePlayer.IsFistFightMinigameEnabled() )
				{
					thePlayer.inv.AddAnItem( 'Geralt fists', 1, true, true, false );
				}
				thePlayer.SetRequiredItems('Any', 'fist' );
				thePlayer.ProcessRequiredItems();
				break;
			case PW_Steel:
				if( GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, item) )
				{
					thePlayer.DrawItemsLatent(item);
				}
				else if ( (W3ReplacerCiri)thePlayer )
				{
					items = thePlayer.GetInventory().GetItemsByName(theGame.params.CIRI_SWORD_NAME);
					if ( items.Size() > 0 )
					{
						thePlayer.DrawItemsLatent(items[0]);
					}
				}
				break;
			case PW_Silver:
				if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, item) )
				{
					thePlayer.DrawItemsLatent(item);
				}
				break;
		}

		parent.UpdateRealWeapon();
	
		Unlock();		
		parent.SetCurrentMeleWeapon( weapontype );	

		return;
	}

	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverid);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelid);
	
	if ( ACS_CloakEquippedCheck() && !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodShowWeaponsWhileCloaked', false) ) 
	{ 
		switch( weapontype )
		{
			case PW_None :
			if ( thePlayer.GetInventory().IsItemHeld(steelid) )
			{
				if ( ACS_DoNotCreateMeshCheck_Steel(steelid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( steelid, true );

					OnWeaponHolsterReady();
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(false);
					
					thePlayer.RaiseEvent('ACS_HolsterSwordHip');
					
					ACS_CreateSteelSwordDummy();

					OnWeaponHolsterReady();
				}
			}
			else if ( thePlayer.GetInventory().IsItemHeld(silverid) )
			{
				if ( ACS_DoNotCreateMeshCheck_Silver(silverid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( silverid, true );

					OnWeaponHolsterReady();
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordHip');

					ACS_CreateSilverSwordDummy();

					OnWeaponHolsterReady();
				}
			}
			break;

			case PW_Fists : 
			if ( thePlayer.GetInventory().IsItemHeld(steelid) )
			{ 
				if ( !ACS_DoNotCreateMeshCheck_Steel(steelid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordHip');

					ACS_CreateSteelSwordDummy();

					OnWeaponHolsterReady();
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( steelid, true );

					OnWeaponHolsterReady();
				}	
			}
			else if ( thePlayer.GetInventory().IsItemHeld(silverid) )
			{ 
				if ( !ACS_DoNotCreateMeshCheck_Silver(silverid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordHip');

					ACS_CreateSilverSwordDummy();

					OnWeaponHolsterReady();
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( silverid, true );

					OnWeaponHolsterReady();
				}
			}
		
			if ( !thePlayer.inv.HasItem('Geralt fists') && !thePlayer.IsFistFightMinigameEnabled() )
			{
				thePlayer.inv.AddAnItem( 'Geralt fists', 1, true, true, false );
			}
			thePlayer.SetRequiredItems('Any', 'fist' );
			thePlayer.ProcessRequiredItems();
			break;

			case PW_Steel:
			if( GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, item) )
			{
				if( thePlayer.GetInventory().IsItemHeld(silverid) )
				{
					if (ACS_DoNotCreateMeshCheck_Silver(silverid))
					{
						ACS_MeleeWeaponEquipSwordFlair(false);

						thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

						Sleep( 1.25 );

						ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').BreakAttachment();

						ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

						ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').DestroyAfter(0.125f);

						ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').RemoveTag('ACS_SwordOnHip_Silver_Sword_Dummy');

						ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').BreakAttachment();

						ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

						ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').DestroyAfter(0.125f);

						ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').RemoveTag('ACS_SwordOnHip_Silver_Scabbard_Dummy');

						thePlayer.GetInventory().UnmountItem( silverid, true );

						OnWeaponHolsterReady();

						Sleep( 0.75 );
					}
					else
					{
						ACS_MeleeWeaponEquipSwordFlair(false);

						thePlayer.RaiseEvent('ACS_HolsterSwordHip');

						ACS_CreateSilverSwordDummy();

						OnWeaponHolsterReady();

						Sleep( 0.5 );
					}
				}

				if (ACS_DoNotCreateMeshCheck_Steel(steelid))
				{
					//Sleep( 0.3 );

					//ACS_MeleeWeaponEquipSwordFlair(false);

					if (thePlayer.HasTag('ACS_IsSwordWalking') )
					{
						thePlayer.RemoveTag('ACS_IsSwordWalking');
					}

					GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
					GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
					GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch');
					GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

					thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');

					Sleep( 0.3 );

					thePlayer.RaiseEvent('ACS_DrawSwordAlt');

					Sleep( 0.5 );

					thePlayer.GetInventory().MountItem( item, true );  

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').RemoveTag('ACS_SwordOnHip_Steel_Sword_Dummy');

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').RemoveTag('ACS_SwordOnHip_Steel_Scabbard_Dummy');

					Sleep(1);

					OnWeaponDrawReady();

					thePlayer.SetCombatIdleStance( 1.f );
				}
				else
				{
					GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
					GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
					GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch');
					GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

					if (thePlayer.HasTag('ACS_IsSwordWalking') && GetACSWatcher().AnimProgressCheck())
					{thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RemoveTag('ACS_IsSwordWalking');}
					
					thePlayer.RaiseEvent('ACS_DrawSwordHip');

					Sleep( 0.3 );

					thePlayer.GetInventory().MountItem( item, true );  

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').RemoveTag('ACS_SwordOnHip_Steel_Sword_Dummy');

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').RemoveTag('ACS_SwordOnHip_Steel_Scabbard_Dummy');

					Sleep(0.5);

					OnWeaponDrawReady();

					thePlayer.SetCombatIdleStance( 1.f );
				}
			}
			break;

			case PW_Silver:
			if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, item) )
			{
				if( thePlayer.GetInventory().IsItemHeld(steelid) )
				{
					if (ACS_DoNotCreateMeshCheck_Steel(steelid))
					{
						ACS_MeleeWeaponEquipSwordFlair(false);

						thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

						Sleep( 1.25 );

						ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').BreakAttachment();

						ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

						ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').DestroyAfter(0.125f);

						ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').RemoveTag('ACS_SwordOnHip_Steel_Sword_Dummy');

						ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').BreakAttachment();

						ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

						ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').DestroyAfter(0.125f);

						ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').RemoveTag('ACS_SwordOnHip_Steel_Scabbard_Dummy');

						thePlayer.GetInventory().UnmountItem( steelid, true );

						OnWeaponHolsterReady();

						Sleep( 0.75 );
					}
					else
					{	
						ACS_MeleeWeaponEquipSwordFlair(false);

						thePlayer.RaiseEvent('ACS_HolsterSwordHip');

						ACS_CreateSteelSwordDummy();

						OnWeaponHolsterReady();

						Sleep( 0.5 );
					}
				}

				if (ACS_DoNotCreateMeshCheck_Silver(silverid))
				{
					//Sleep( 0.3 );

					//ACS_MeleeWeaponEquipSwordFlair(false);

					if (thePlayer.HasTag('ACS_IsSwordWalking') )
					{
						thePlayer.RemoveTag('ACS_IsSwordWalking');
					}

					GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
					GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
					GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch');
					GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

					thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');

					Sleep( 0.3 );

					thePlayer.RaiseEvent('ACS_DrawSwordAlt');

					Sleep( 0.5 );

					thePlayer.GetInventory().MountItem( item, true );  

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').RemoveTag('ACS_SwordOnHip_Silver_Sword_Dummy');

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').RemoveTag('ACS_SwordOnHip_Silver_Scabbard_Dummy');

					Sleep(1);

					OnWeaponDrawReady();

					thePlayer.SetCombatIdleStance( 1.f );
				}
				else
				{
					GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
					GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
					GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch');
					GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

					if (thePlayer.HasTag('ACS_IsSwordWalking') && GetACSWatcher().AnimProgressCheck()){thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RemoveTag('ACS_IsSwordWalking');}

					//theGame.GetGuiManager().ShowNotification("test");

					thePlayer.RaiseEvent('ACS_DrawSwordHip');

					Sleep( 0.3 );

					thePlayer.GetInventory().MountItem( item, true );  

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').RemoveTag('ACS_SwordOnHip_Silver_Sword_Dummy');

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').BreakAttachment();

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').DestroyAfter(0.125f);

					ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').RemoveTag('ACS_SwordOnHip_Silver_Scabbard_Dummy');

					Sleep(0.5);
					
					OnWeaponDrawReady();

					thePlayer.SetCombatIdleStance( 1.f );
				}
			}
			break;
		}
	}
	else 
	{ 
		switch( weapontype )
		{
			case PW_None :
			if ( thePlayer.GetInventory().IsItemHeld(steelid) )
			{
				if ( ACS_DoNotCreateMeshCheck_Steel(steelid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( steelid, false );

					Sleep(0.0125);

					if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SteelSword, item) )
					{
						if (item == steelid)
						{
							thePlayer.GetInventory().MountItem( steelid, false );
						}
					}

					OnWeaponHolsterReady();
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(true);
					thePlayer.SetRequiredItems('Any', 'None');
					thePlayer.ProcessRequiredItems();
				}
			}
			else if ( thePlayer.GetInventory().IsItemHeld(silverid) )
			{
				if ( ACS_DoNotCreateMeshCheck_Silver(silverid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( silverid, true );

					Sleep(0.0125);

					if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, item) )
					{
						if (item == silverid)
						{
							thePlayer.GetInventory().MountItem( silverid, false );
						}
					}

					OnWeaponHolsterReady();
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(true);
					thePlayer.SetRequiredItems('Any', 'None');
					thePlayer.ProcessRequiredItems();
				}
			}
			break;
			case PW_Fists : 

			if ( thePlayer.GetInventory().IsItemHeld(steelid) )
			{ 
				if ( !ACS_DoNotCreateMeshCheck_Steel(steelid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(true);
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( steelid, true );

					Sleep(0.0125);
					
					if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SteelSword, item) )
					{
						if (item == steelid)
						{
							thePlayer.GetInventory().MountItem( steelid, false );
						}
					}

					OnWeaponHolsterReady();
				}	
			}
			else if ( thePlayer.GetInventory().IsItemHeld(silverid) )
			{ 
				if ( !ACS_DoNotCreateMeshCheck_Silver(silverid) )
				{
					ACS_MeleeWeaponEquipSwordFlair(true);
				}
				else
				{
					ACS_MeleeWeaponEquipSwordFlair(false);

					thePlayer.RaiseEvent('ACS_HolsterSwordAlt');

					Sleep( 1.25 );

					thePlayer.GetInventory().UnmountItem( silverid, true );

					Sleep(0.0125);

					if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, item) )
					{
						if (item == silverid)
						{
							thePlayer.GetInventory().MountItem( silverid, false );
						}
					}

					OnWeaponHolsterReady();
				}
			}

			if ( !thePlayer.inv.HasItem('Geralt fists') && !thePlayer.IsFistFightMinigameEnabled() )
			{
				thePlayer.inv.AddAnItem( 'Geralt fists', 1, true, true, false );
			}
			thePlayer.SetRequiredItems('Any', 'fist' );
			thePlayer.ProcessRequiredItems();
			break;

			case PW_Steel:
			if( GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, item) )
			{
				if ( thePlayer.GetInventory().IsItemHeld(silverid) )
				{
					thePlayer.AddTag('ACS_SwordWalkPause');
					GetACSWatcher().RemoveTimer('SwordWalkPauseRemove');
					GetACSWatcher().AddTimer('SwordWalkPauseRemove', 3, false);
				}

				thePlayer.DrawItemsLatent(item);
			}
			break;

			case PW_Silver:
			if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, item) )
			{
				if ( thePlayer.GetInventory().IsItemHeld(steelid) )
				{
					thePlayer.AddTag('ACS_SwordWalkPause');
					GetACSWatcher().RemoveTimer('SwordWalkPauseRemove');
					GetACSWatcher().AddTimer('SwordWalkPauseRemove', 3, false);
				}

				thePlayer.DrawItemsLatent(item);
			}
			break;

			/*
			case PW_Steel:
			if( GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, item) )
			{
				thePlayer.DrawItemsLatent(item);
			}
			break;

			case PW_Silver:
			if( GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, item) )
			{
				thePlayer.DrawItemsLatent(item);
			}
			break;
			*/
		}
	}

	parent.UpdateRealWeapon();
	
	Unlock();		
	parent.SetCurrentMeleWeapon( weapontype );	

	if ( ACS_Enabled() ) 
	{ 
		if (!thePlayer.IsAnyWeaponHeld())
		{
			ACS_WeaponHolsterInit();
		}
	}
}

latent function ACS_MeleeWeaponEquipSwordFlair( interrupt_overlay : bool )
{
	if (!thePlayer.IsInCombat() 
	&& !thePlayer.IsThreatened()
	&& !thePlayer.GetIsSprinting() 
	&& ACS_Settings_Main_Int('EHmodMiscSettings','EHmodSwordFlair', 1) != 0)
	{
		Sleep(0.1);
		
		GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
		GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
		GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch');
		GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 
		
		GetACSWatcher().AddTimer('SwordTauntSwitch', 0.01  , false);

		Sleep(1.45);
	}
	else
	{
		if (GetACSWatcher().AnimProgressCheck())
		{
			if (interrupt_overlay)
			{
				GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
				GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
				GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch');
				GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

				thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');
			}
		}
	}
}

latent function ACS_CreateSteelSwordDummy()
{
	var steelid 																								: SItemUniqueId;
	var swordsteel, steelcopy, steelScabbardEnt, dummycomp														: CEntity; 
	var steelScabbardscomp 																						: CDrawableComponent;
	var boneIndex																								: int;
	var steelScabbardMeshComponent 																				: CMeshComponent;
	var bonePosition																							: Vector;
	var boneRotation																							: EulerAngles;
	var swordOnHip_steel_position																				: Vector;
	var swordOnHip_steel_scabbard_position																		: Vector;
	var swordOnHip_steel_rotation																				: EulerAngles;
	var swordOnHip_steel_scabbard_rotation																		: EulerAngles;
	var steel_pos_x,steel_pos_y,steel_pos_z   																	: Float;
	var steel_scab_pos_x,steel_scab_pos_y,steel_scab_pos_z  													: Float;
	var steel_roll, steel_pitch, steel_yaw 																		: Float; 
	var steel_scab_roll, steel_scab_pitch, steel_scab_yaw														: Float; 

	swordOnHip_steel_position.X = 0;    
	swordOnHip_steel_position.Y = 0;    
	swordOnHip_steel_position.Z = 0;     

	swordOnHip_steel_rotation.Pitch = 0;
	swordOnHip_steel_rotation.Roll = 0;
	swordOnHip_steel_rotation.Yaw = 0;
	
	swordOnHip_steel_position.X += -0.19;
	swordOnHip_steel_position.Y += -0.17; // - up + down
	swordOnHip_steel_position.Z += -0.15; // - left + right

	swordOnHip_steel_rotation.Pitch += 107;
	swordOnHip_steel_rotation.Roll += 18;
	swordOnHip_steel_rotation.Yaw += 140;

	//////////////////////////////////////////////////////////////////////////////////////////
	// Steel Scabbard Position

	swordOnHip_steel_scabbard_position.X = 0;    
	swordOnHip_steel_scabbard_position.Y = 0;    
	swordOnHip_steel_scabbard_position.Z = 0;     

	swordOnHip_steel_scabbard_rotation.Pitch = 0;
	swordOnHip_steel_scabbard_rotation.Roll = 0;
	swordOnHip_steel_scabbard_rotation.Yaw = 0;
	
	swordOnHip_steel_scabbard_position.X += 0.61;
	swordOnHip_steel_scabbard_position.Y -= 0.09;
	swordOnHip_steel_scabbard_position.Z -= -1.71;

	swordOnHip_steel_scabbard_rotation.Pitch += 180;
	swordOnHip_steel_scabbard_rotation.Roll += -24.3;
	swordOnHip_steel_scabbard_rotation.Yaw += 14.4 + 0.41;

	//////////////////////////////////////////////////////////////////////////////////////////
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelid);

	if ( !theGame.GetEntityByTag('ACS_SwordOnHip_Dummy_Attachment') )
	{
		boneIndex = thePlayer.GetBoneIndex( 'pelvis' );	
		thePlayer.GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent",true ), thePlayer.GetWorldPosition() + Vector( 0, 0, -100 ) );
		dummycomp.AddTag('ACS_SwordOnHip_Dummy_Attachment');
		dummycomp.CreateAttachmentAtBoneWS(thePlayer, 'pelvis', bonePosition, boneRotation );
	}

	if ( !theGame.GetEntityByTag('ACS_SwordOnHip_Steel_Sword_Dummy') )
	{
		swordsteel = thePlayer.GetInventory().GetItemEntityUnsafe( steelid );

		steelcopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

		swordsteel.GetReadableName()

		,true ), thePlayer.GetWorldPosition() + Vector(0,0,-100), thePlayer.GetWorldRotation());

		steelcopy.AddTag('ACS_SwordOnHip_Steel_Sword_Dummy');
	}

	if ( !theGame.GetEntityByTag('ACS_SwordOnHip_Steel_Scabbard_Dummy') )
	{
		if (!StrContains( swordsteel.GetReadableName(), "sabre" )
		&& !StrContains( swordsteel.GetReadableName(), "saber" )
		&& !StrContains( swordsteel.GetReadableName(), "knife" )
		&& !StrContains( swordsteel.GetReadableName(), "axe" )
		&& !StrContains( swordsteel.GetReadableName(), "hammmer" )
		&& !StrContains( swordsteel.GetReadableName(), "poker" )
		&& !StrContains( swordsteel.GetReadableName(), "wildhunt" )
		&& !StrContains( swordsteel.GetReadableName(), "wild_hunt" )
		&& !StrContains( swordsteel.GetReadableName(), "eredin" )
		&& !StrContains( swordsteel.GetReadableName(), "olgierd" )
		&& !StrContains( swordsteel.GetReadableName(), "iris" )
		&& !StrContains( swordsteel.GetReadableName(), "novalis" )
		)
		{
			steelScabbardEnt = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

			"dlc\bob\data\items\bodyparts\geralt_items\scabbards\steel_scabbards\witcher_steel_wolf_scabbard_ep2.w2ent"

			,true ), thePlayer.GetWorldPosition() + Vector(0,0,-100), thePlayer.GetWorldRotation());

			steelScabbardMeshComponent = ( CMeshComponent ) steelScabbardEnt.GetComponentByClassName( 'CMeshComponent' );

			steelScabbardMeshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

			steelScabbardEnt.AddTag('ACS_SwordOnHip_Steel_Scabbard_Dummy');
		}
	}

	Sleep( 0.75 );

	thePlayer.GetInventory().UnmountItem( steelid, true );

	ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_SwordOnHip_Dummy_Attachment'),,swordOnHip_steel_position, swordOnHip_steel_rotation );

	ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy'),,swordOnHip_steel_scabbard_position, swordOnHip_steel_scabbard_rotation );
}

latent function ACS_CreateSilverSwordDummy()
{
	var silverid 																								: SItemUniqueId;
	var silverScabbardItems 																					: array<SItemUniqueId>;
	var swordsilver, silvercopy, silverScabbardEnt, dummycomp													: CEntity; 
	var  silverScabbardscomp 																					: CDrawableComponent;
	var boneIndex																								: int;
	var  silverScabbardMeshComponent 																			: CMeshComponent;
	var bonePosition																							: Vector;
	var boneRotation																							: EulerAngles;
	var swordOnHip_silver_position																				: Vector;
	var swordOnHip_silver_scabbard_position																		: Vector;
	var swordOnHip_silver_rotation																				: EulerAngles;
	var swordOnHip_silver_scabbard_rotation																		: EulerAngles;

	var silver_pos_x,silver_pos_y,silver_pos_z   																: Float;
	var silver_scab_pos_x,silver_scab_pos_y,silver_scab_pos_z  													: Float;
	var silver_roll, silver_pitch, silver_yaw 																	: Float; 
	var silver_scab_roll,silver_scab_pitch,silver_scab_yaw														: Float; 

	//////////////////////////////////////////////////////////////////////////////////////////
	// Silver Sword Position

	swordOnHip_silver_position.X = 0;    
	swordOnHip_silver_position.Y = 0;    
	swordOnHip_silver_position.Z = 0;     

	swordOnHip_silver_rotation.Pitch = 0;
	swordOnHip_silver_rotation.Roll = 0;
	swordOnHip_silver_rotation.Yaw = 0;
	
	swordOnHip_silver_position.X += -0.17;
	swordOnHip_silver_position.Y += -0.15;
	swordOnHip_silver_position.Z += -0.19;

	swordOnHip_silver_rotation.Pitch += -113;
	swordOnHip_silver_rotation.Roll += -44;
	swordOnHip_silver_rotation.Yaw += 300;

	//////////////////////////////////////////////////////////////////////////////////////////
	// Silver Scabbard Position

	swordOnHip_silver_scabbard_position.X = 0;    
	swordOnHip_silver_scabbard_position.Y = 0;    
	swordOnHip_silver_scabbard_position.Z = 0;     

	swordOnHip_silver_scabbard_rotation.Pitch = 0;
	swordOnHip_silver_scabbard_rotation.Roll = 0;
	swordOnHip_silver_scabbard_rotation.Yaw = 0;
	
	swordOnHip_silver_scabbard_position.X += 0.61 + 0.025;
	swordOnHip_silver_scabbard_position.Y += 0.09 - 0.085;
	swordOnHip_silver_scabbard_position.Z += 1.71 - 0.07;

	swordOnHip_silver_scabbard_rotation.Pitch += 180 - 1.5;
	swordOnHip_silver_scabbard_rotation.Roll += -24.3 - 5.5;
	swordOnHip_silver_scabbard_rotation.Yaw += 14.4 + 3.5;

	//////////////////////////////////////////////////////////////////////////////////////////

	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverid);

	if ( !theGame.GetEntityByTag('ACS_SwordOnHip_Dummy_Attachment') )
	{
		boneIndex = thePlayer.GetBoneIndex( 'pelvis' );	
		thePlayer.GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent",true ), thePlayer.GetWorldPosition() + Vector( 0, 0, -100 ) );
		dummycomp.AddTag('ACS_SwordOnHip_Dummy_Attachment');
		dummycomp.CreateAttachmentAtBoneWS(thePlayer, 'pelvis', bonePosition, boneRotation );
	}

	if ( !theGame.GetEntityByTag('ACS_SwordOnHip_Silver_Sword_Dummy') )
	{
		swordsilver = thePlayer.GetInventory().GetItemEntityUnsafe( silverid );

		silvercopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

		swordsilver.GetReadableName()

		,true ), thePlayer.GetWorldPosition() + Vector( 0, 0, -100 ), thePlayer.GetWorldRotation());

		silvercopy.AddTag('ACS_SwordOnHip_Silver_Sword_Dummy');
	}

	if ( !theGame.GetEntityByTag('ACS_SwordOnHip_Silver_Scabbard_Dummy') )
	{
		if (!StrContains( swordsilver.GetReadableName(), "sabre" )
		&& !StrContains( swordsilver.GetReadableName(), "saber" )
		&& !StrContains( swordsilver.GetReadableName(), "knife" )
		&& !StrContains( swordsilver.GetReadableName(), "axe" )
		&& !StrContains( swordsilver.GetReadableName(), "hammmer" )
		&& !StrContains( swordsilver.GetReadableName(), "poker" )
		&& !StrContains( swordsilver.GetReadableName(), "wildhunt" )
		&& !StrContains( swordsilver.GetReadableName(), "wild_hunt" )
		&& !StrContains( swordsilver.GetReadableName(), "eredin" )
		&& !StrContains( swordsilver.GetReadableName(), "olgierd" )
		&& !StrContains( swordsilver.GetReadableName(), "iris" )
		&& !StrContains( swordsilver.GetReadableName(), "novalis" )
		)
		{
			silverScabbardEnt = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

			"dlc\bob\data\items\bodyparts\geralt_items\scabbards\silver_scabbards\witcher_silver_wolf_scabbard_ep2.w2ent"

			,true ), thePlayer.GetWorldPosition() + Vector( 0, 0, -100 ), thePlayer.GetWorldRotation());

			silverScabbardMeshComponent = ( CMeshComponent ) silverScabbardEnt.GetComponentByClassName( 'CMeshComponent' );

			silverScabbardMeshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

			silverScabbardEnt.AddTag('ACS_SwordOnHip_Silver_Scabbard_Dummy');
		}
	}

	Sleep( 0.75 );

	thePlayer.GetInventory().UnmountItem( silverid, true );

	ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_SwordOnHip_Dummy_Attachment'),,swordOnHip_silver_position, swordOnHip_silver_rotation );

	ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy'),,swordOnHip_silver_scabbard_position, swordOnHip_silver_scabbard_rotation );
}

///////////////////////////////////////////////////////////////////////////////////

@wrapMethod( SwordAttack ) function DoAttack()
{
	var horse : CNewNPC;
	var speed : float;
	var currHorizontalVal : float;
	var entities : array<CGameplayEntity>;
	var attackRanges : array<name>;
	var res : bool;

	if(false) 
	{
		wrappedMethod();
	}

	if (thePlayer.HasTag('ACS_IsSwordWalking'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalking');
	}

	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

	if ( GetACSWatcher().AnimProgressCheck() )
	{
		thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');
	}

	res = rider.WaitForBehaviorNodeActivation( 'HorseAttackEndStarted', 0.5f );
	if( !res )
		return;

	horse = (CNewNPC)(rider.GetUsedVehicle());
	speed = horse.GetMovingAgentComponent().GetRelativeMoveSpeed();
	currHorizontalVal = rider.GetBehaviorVariable( 'aimHorizontalSword' );
	attackRanges = FillAttackRangesArray( currHorizontalVal );
	entities.Clear();
	ACS_MountedCombatAttack(speed, currHorizontalVal); return; //EternalHunt
	if( thePlayer.GetHorseCombatSlowMo() )
	{
		Sleep( 0.12 );
		entities = GatherEntitiesInAttackRanges( speed, attackRanges );
	
		if( entities.Size() > 0 )
		{
			DealDamageToHostiles( entities, speed, BASE_DAMAGE );
		}
	}
	else
	{
		Sleep( FIRST_SWEEP_DELAY );
		entities = GatherEntitiesInAttackRanges( speed, attackRanges );
	
		if( entities.Size() > 0 )
		{
			DealDamageToHostiles( entities, speed, BASE_DAMAGE );
		}
		else
		{
			Sleep( SECOND_SWEEP_DELAY );
			entities = GatherEntitiesInAttackRanges( speed, attackRanges );
			
			if( entities.Size() > 0 )
			{
				DealDamageToHostiles( entities, speed, BASE_DAMAGE );
			}
		}
	}
}

@wrapMethod( SwordAttack ) function CanPerformAttack() : bool
{
	if(false) 
	{
		wrappedMethod();
	}
	
	return true;
}

///////////////////////////////////////////////////////////////////////////////////

@wrapMethod( Combat ) function OnEnterState( prevStateName : name )
{
	wrappedMethod(prevStateName);

	if ( ACS_Enabled() ) { ACS_CombatBehSwitch(); } //EternalHunt
}

@wrapMethod( Combat ) function CombatEndCheck( timeDelta : float , id : int)
{
	if(false) 
	{
		wrappedMethod(timeDelta, id);
	}

	if( !parent.IsInCombat() )
	{
		if( timeToCheckCombatEndCur < 0.0f && ACS_CombatToExplorationCheck() ) //EternalHunt
		{
			parent.GoToExplorationIfNeeded(); 
		}
		else
		{
			timeToCheckCombatEndCur	-= timeDelta;
		}
	}
	else
	{
		timeToCheckCombatEndCur	= timeToCheckCombatEndMax;
	}
}

@wrapMethod( Combat ) function PerformEvade( playerEvadeType : EPlayerEvadeType, isRolling : bool )
{
	var rawDodgeHeading				: float;
	var predictedDodgePos			: Vector;
	var lineWidth					: float;
	var noCreatureOnLine			: bool;
	
	var tracePosFrom				: Vector;
	var playerToTargetRot			: EulerAngles;
	var predictedDodgePosNormal		: Vector;
	var dodgeNum					: float;
	var randNum						: int;
	var randMax						: int;
	var i							: int;
	var submergeDepth				: float;

	var dodgeLength					: float;
	var intersectPoint				: Vector;		
	var intersectLength				: float;
	var playerToPoint				: float;

	var moveTargets					: array<CActor>;
	var playerToTargetAngleDiff		: float;
	var playerToRawAngleDiff		: float;
	var playerToCamAngleDiff		: float;
	
	var targetCapsuleRadius 		: float;
	var perkStats 					: SAbilityAttributeValue;

	if(false) 
	{
		wrappedMethod(playerEvadeType, isRolling);
	}

	parent.ResetUninterruptedHitsCount();		
	parent.SetIsCurrentlyDodging(true, isRolling);

	parent.RemoveTimer( 'UpdateDodgeInfoTimer' );

	if ( parent.IsHardLockEnabled() && parent.GetTarget() )
		evadeTarget = parent.GetTarget();
	else
	{
		parent.FindMoveTarget();
		evadeTarget = parent.moveTarget;		
	}

	if ( ACS_Enabled())
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
		)
		{	
			//vACS_Dodge.ACS_Dodge_Engage();

			if( ACS_Armor_Equipped_Check()
			|| ACS_Wolf_School_Check()
			|| ACS_Bear_School_Check()
			|| ACS_Cat_School_Check()
			|| ACS_Griffin_School_Check()
			|| ACS_Manticore_School_Check()
			|| ACS_Forgotten_Wolf_Check()
			|| ACS_Viper_School_Check()
			)
			{	

			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaCostAction', false))
				{
					thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_Settings_Main_Float('EHmodStaminaSettings','EHmodDodgeStaminaCost', 0.05), ACS_Settings_Main_Float('EHmodStaminaSettings','EHmodDodgeStaminaRegenDelay', 1) );
				}
			}
			
		}
	}

	if ( isRolling )
	{
		dodgeLength = 6.5f;
	}
	else
	{
		if ( parent.GetCurrentStateName() == 'CombatFists' )
			dodgeLength = 3.f;
		else
			dodgeLength = 3.5f;
	}
			
	intersectLength = dodgeLength * 0.75;

	evadeTargetPos = evadeTarget.PredictWorldPosition( 0.4f ); 
	
	dodgeDirection = GetEvadeDirection( playerEvadeType );
	rawDodgeHeading = GetRawDodgeHeading();
	parent.evadeHeading = rawDodgeHeading;
	
	
	predictedDodgePos = VecFromHeading( rawDodgeHeading ) * dodgeLength + parent.GetWorldPosition();
	parent.GetVisualDebug().AddSphere('predictedDodgePos', 0.25, predictedDodgePos, true, Color(0,128,256), 5.0f );
	parent.GetVisualDebug().AddSphere('evadeTargetPos', 0.25, evadeTargetPos, true, Color(255,255,0), 5.0f );
	parent.GetVisualDebug().AddArrow( 'DodgeVector', parent.GetWorldPosition(), predictedDodgePos, 1.f, 0.2f, 0.2f, true, Color(0,128,256), true, 5.f );

	turnInPlaceBeforeDodge = false;		
	
	
	if ( evadeTarget )
	{
		intersectPoint = VecFromHeading( rawDodgeHeading ) * VecDot( VecFromHeading( rawDodgeHeading ), evadeTargetPos - parent.GetWorldPosition() ) + parent.GetWorldPosition();
		parent.GetVisualDebug().AddArrow( 'DodgeVector', parent.GetWorldPosition(), VecFromHeading( rawDodgeHeading ) * intersectLength + parent.GetWorldPosition(), 1.f, 0.2f, 0.2f, true, Color(0,128,256), true, 5.f );
		parent.GetVisualDebug().AddArrow( 'DodgeVector2', intersectPoint, evadeTargetPos, 1.f, 0.2f, 0.2f, true, Color(0,128,256), true, 5.f );
		moveTargets = parent.GetMoveTargets();
		
		playerToTargetAngleDiff = AbsF( AngleDistance( parent.GetHeading(), VecHeading( evadeTargetPos - parent.GetWorldPosition() ) ) );
		playerToRawAngleDiff = AbsF( AngleDistance( rawDodgeHeading, parent.GetHeading() ) );
		
		if ( parent.playerMoveType == PMT_Run || ( parent.playerMoveType > PMT_Run && parent.GetSprintingTime() > 0.12 ) )
		{
			if ( playerToRawAngleDiff < 90 )
			{
				dodgeDirection = PED_Forward;
			}
			else
			{
				dodgeDirection = PED_Back;
				turnInPlaceBeforeDodge = true;
			}
		}
		else
		{
			
			if ( playerToTargetAngleDiff > 90 )
			{
				
				if ( playerToRawAngleDiff < 90 )
				{
					dodgeDirection = PED_Forward;
					turnInPlaceBeforeDodge = true;
				}
				else
				{
					
					if ( VecLength( intersectPoint - parent.GetWorldPosition() ) < intersectLength )
					{
						if ( theGame.TestNoCreaturesOnLine( parent.GetWorldPosition(), predictedDodgePos, 0.1, parent, NULL, true ) )
							
						{
							dodgeDirection = PED_Back;					
						}
						else 
						{
							dodgeDirection = PED_Back;
							turnInPlaceBeforeDodge = true;	
						}
					}
					else
					{
						dodgeDirection = PED_Back;
						turnInPlaceBeforeDodge = true;							
					}
				}
			}
			else
			{
				
				if ( playerToRawAngleDiff < 90 )
				{
					
					if ( VecLength( intersectPoint - parent.GetWorldPosition() ) < intersectLength )
					{
						if ( theGame.TestNoCreaturesOnLine( parent.GetWorldPosition(), predictedDodgePos, 0.1, parent, NULL, true ) )
							
						{
							dodgeDirection = PED_Forward;
							turnInPlaceBeforeDodge = true;
						}
						else
							dodgeDirection = PED_Forward;
					}
					else
						dodgeDirection = PED_Forward;
				}
				else
				{
					
					if ( VecLength( intersectPoint - parent.GetWorldPosition() ) < intersectLength && AbsF( AngleDistance( VecHeading( intersectPoint - parent.GetWorldPosition() ), rawDodgeHeading ) ) < 10.f  )
					{
						if ( theGame.TestNoCreaturesOnLine( parent.GetWorldPosition(), predictedDodgePos, 0.1, parent, NULL, true ) )
							
						{
							dodgeDirection = PED_Back;
						}
						else
						{
							dodgeDirection = PED_Back;
							turnInPlaceBeforeDodge = true;
						}
					}          
					else
					{
						dodgeDirection = PED_Back;
					}
				}
			}
			targetCapsuleRadius = ( (CMovingPhysicalAgentComponent)evadeTarget.GetMovingAgentComponent() ).GetCapsuleRadius();
			if ( parent.IsHardLockEnabled() && targetCapsuleRadius > 0.8f )
			{
				playerToCamAngleDiff = AbsF( AngleDistance( parent.GetHeading(), VecHeading( theCamera.GetCameraDirection() ) ) );
				if ( playerToCamAngleDiff > 0 && playerToCamAngleDiff < 110 )			
				{
					
					if ( playerToRawAngleDiff < 90 )
					{
						dodgeDirection = PED_Forward;
						turnInPlaceBeforeDodge = false;	
					}
				}	
				
				if ( playerToCamAngleDiff > 60 && playerToCamAngleDiff < 135 )
				{
					
					if ( playerToRawAngleDiff > 120 )
					{					
						dodgeDirection = PED_Back;
						turnInPlaceBeforeDodge = true;
					}
				}					
			}				
		}
	}		

	if(!SkipStaminaDodgeEvadeCost())
	{
		if(isRolling)
			parent.DrainStamina(ESAT_Roll);
		else
			parent.DrainStamina(ESAT_Dodge);
	}
	
	
	if( parent.CanUseSkill(S_Perk_21) )
	{
		if( isRolling )
		{
			GetWitcherPlayer().GainAdrenalineFromPerk21( 'roll' );
		}
		else
		{
			GetWitcherPlayer().GainAdrenalineFromPerk21( 'dodge' );
		}
	}
	
	if ( dodgeDirection == PED_Forward )
	{
		if ( evadeTarget )
		{
			evadeTarget.SignalGameplayEventParamInt('Time2Dodge', (int)EDT_Fear );
			
			if ( wasLockedToTarget  )
				parent.SetUnpushableTarget( evadeTarget );
		}
	}
	
	if ( !theGame.GetWorld().StaticTrace( predictedDodgePos + Vector(0,0,5), predictedDodgePos + Vector(0,0,-5) , predictedDodgePos, predictedDodgePosNormal ) )
		playerToTargetRot.Pitch = 0.f;
	else	
		playerToTargetRot = VecToRotation( predictedDodgePos - parent.GetWorldPosition() );
	
	submergeDepth = ((CMovingPhysicalAgentComponent)parent.GetMovingAgentComponent()).GetSubmergeDepth();
	
	FillDodgePlaylists( isRolling );
	
	if ( !parent.GetWeaponHolster().IsMeleeWeaponReady() )
	{
		dodgeNum = 0;
	}
	else if ( !turnInPlaceBeforeDodge )
	{
		if ( dodgeDirection == PED_Back )
		{
			parent.SetBehaviorVariable( 'dodgeNum', dodgePlaylistBck[ dodgePlaylistBck.Size() - 1 ] ); 
			dodgePlaylistBck.EraseFast( dodgePlaylistBck.Size() - 1 );
		}
		else
		{
			parent.SetBehaviorVariable( 'dodgeNum', dodgePlaylistFwd[ dodgePlaylistFwd.Size() - 1 ] ); 
			dodgePlaylistFwd.EraseFast( dodgePlaylistFwd.Size() - 1 );			
		}
	}
	else
	{
		if ( dodgeDirection == PED_Forward )
		{
			parent.SetBehaviorVariable( 'dodgeNum', dodgePlaylistFlipFwd[ dodgePlaylistFlipFwd.Size() - 1 ] ); 
			dodgePlaylistFlipFwd.EraseFast( dodgePlaylistFlipFwd.Size() - 1 );			
		}
	}
	
		
	
	parent.SetBehaviorVariable( 'combatActionType', (int)CAT_Dodge );
	parent.SetBehaviorVariable(	'playerEvadeDirection', (int)( dodgeDirection ) ) ;
	parent.SetBehaviorVariable(	'turnInPlaceBeforeDodge', 0.f ) ;
	parent.SetBehaviorVariable(	'isRolling', (int)isRolling ) ;
	
	if ( turnInPlaceBeforeDodge )
		parent.SetBehaviorVariable(	'turnInPlaceBeforeDodge', 1.f ) ;
		
	if ( parent.RaiseForceEvent( 'CombatAction' ) )
		virtual_parent.OnCombatActionStart();
	
	parent.SetCustomRotation( 'Dodge', GetDodgeHeading( playerEvadeType ), 0.0f, 0.1f, false );
	
	if (  turnInPlaceBeforeDodge )
		Sleep( 0.4f );
	else
		Sleep( 0.3f );

	
	if ( parent.bLAxisReleased )
		cachedRawDodgeHeading = rawDodgeHeading;
	else
		cachedRawDodgeHeading = GetRawDodgeHeading();
		
	
		parent.SetCustomRotation( 'Dodge', GetDodgeHeadingForMovementHeading( cachedRawDodgeHeading ), 90.0f, 0.0f, false );
	
	parent.BindMovementAdjustmentToEvent( 'Dodge', 'Dodge' );
	parent.AddTimer( 'UpdateDodgeInfoTimer', 0, true );	

	parent.WaitForBehaviorNodeDeactivation( 'DodgeComplete', 0.7f );
	parent.RemoveTimer( 'UpdateDodgeInfoTimer' );
	
	
	parent.SetIsCurrentlyDodging(false);
	
}

///////////////////////////////////////////////////////////////////////////////////

/*
@wrapMethod( Exploration ) function ExplorationInit( prevStateName : name )
{
	var stupidArray : array< name >;
	var comp	: CMovingPhysicalAgentComponent;

	if(false) 
	{
		wrappedMethod(prevStateName);
	}
	
	stupidArray.PushBack( 'Gameplay' );
	
	parent.LockEntryFunction( true );
	
	m_lastUsedPCInput = false;
	
	parent.BlockAllActions('ExplorationInit', true, , true, parent);

	if (ACS_Enabled() && !ACS_New_Replacers_Female_Active()) 
	{
		ACS_BehSwitch(prevStateName); 
	}
	else
	{
		if ( prevStateName == 'TraverseExploration' || prevStateName == 'PlayerDialogScene' )
		{
			parent.ActivateBehaviors(stupidArray);
		}
		else
		{
			parent.ActivateAndSyncBehaviors(stupidArray);
		}
	}
	
	parent.OnCombatActionEndComplete();
	
	if ( !parent.pcGamePlayInitialized )
	{
		parent.pcGamePlayInitialized = true;
		parent.RaiseForceEvent( 'ForceIdle' );
	}
	
	parent.BlockAllActions('ExplorationInit', false);
	
	
	parent.UnblockAction(EIAB_MeditationWaiting, 'vehicle');
	
	
	if ( parent.IsInShallowWater() )
		parent.SetBehaviorVariable( 'shallowWater',1.0);
	
	parent.SetOrientationTarget( OT_Player );
	parent.ClearCustomOrientationInfoStack();
	parent.SetBIsInputAllowed(true, 'ExplorationInit');
	
	parent.AddTimer( 'ResetStanceTimer', 1.f );
	
	parent.findMoveTargetDistMin = 10.f;
	
	InitCamera();
	
	parent.LockEntryFunction( false );
	
	while ( !comp )
	{
		comp = ( (CMovingPhysicalAgentComponent) parent.GetMovingAgentComponent() );
	}
	
	comp.SetTerrainInfluence(0.f);
	
	parent.SetBehaviorVariable( 'proudWalk', (float)( parent.proudWalk ) );
	if ( parent.injuredWalk )
	{
		parent.SetBehaviorVariable( 'alternateWalk', 1.0f );
	}
	else if ( parent.tiedWalk )
	{
		parent.SetBehaviorVariable( 'alternateWalk', 2.0f );
	}
	else
	{
		parent.SetBehaviorVariable( 'alternateWalk', 0.0f );
	}
	parent.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)PGMM_Default );
	
	
	parent.AddTimer( 'ExplorationLoop', 0.01f, true );
}

@wrapMethod( Exploration ) function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
	if(false) 
	{
		wrappedMethod(moveData, dt);
	}

	if( super.OnGameCameraTick( moveData, dt ) )
	{
		return true;
	}
	
	if( m_lastUsedPCInput != theInput.LastUsedPCInput() )
	{
		m_lastUsedPCInput = theInput.LastUsedPCInput();
		
		if ( m_lastUsedPCInput )
		{
			theGame.GetGameCamera().SetManualRotationHorTimeout( 5 );
			theGame.GetGameCamera().SetManualRotationVerTimeout( 3 );
		}
		else
		{
			theGame.GetGameCamera().SetManualRotationHorTimeout( 1.5 );
			theGame.GetGameCamera().SetManualRotationVerTimeout( 3 );
		}
	}
	//if (thePlayer.IsInAir()){UpdateCameraInterior( moveData, dt );} //EternalHunt
	switch( parent.GetPlayerAction() )
	{
		case PEA_Meditation 	: UpdateCameraMeditation( moveData, dt ); break;	
		case PEA_ExamineGround 	: UpdateCameraClueGround( moveData, dt ); break;
	
		default:
		{
			if ( parent.IsCameraLockedToTarget() )
			{
				UpdateCameraInterior( moveData, dt );
			}			
			else if ( !thePlayer.interiorCamera && parent.IsInShallowWater() )
			{
				return false;
			}
			else if( (parent.movementLockType == PMLT_NoSprint || parent.movementLockType == PMLT_NoRun) && !parent.GetExplCamera() ) 
			{
				if ( parent.IsCombatMusicEnabled() || parent.GetPlayerMode().GetForceCombatMode() )
					UpdateCameraInterior( moveData, dt );
				else	
					parent.UpdateCameraInterior( moveData, dt );
			}
			else
			{
				
				if ( parent.IsSprintActionPressed() )
					parent.wasRunning = false; 
					
				return false;
			}
		}
		
		return true;
	}
}
*/

///////////////////////////////////////////////////////////////////////////////////

/*
@wrapMethod( CActor ) function OnTakeDamage( action : W3DamageAction )
{
	var playerAttacker : CPlayer;
	var attackName : name;
	var animatedComponent : CAnimatedComponent;
	var buff : W3Effect_Frozen;
	var buffs : array<CBaseGameplayEffect>;
	var i : int;
	var mutagen : CBaseGameplayEffect;
	var min, max : SAbilityAttributeValue;
	var lifeLeech, health, stamina : float;
	var wasAlive : bool;
	var hudModuleDamageType : EFloatingValueType;
	var dontShowDamage : bool;

	if(false) 
	{
		wrappedMethod(action);
	}

	playerAttacker = (CPlayer)action.attacker;
	wasAlive = IsAlive();

	if(ACS_Enabled())
	{
		ACS_OnTakeDamage( action );
	}

	buffs = GetBuffs(EET_Frozen);
	for(i=0; i<buffs.Size(); i+=1)
	{
		buff = (W3Effect_Frozen)buffs[i];
		if(buff.KillOnHit())
		{
			action.processedDmg.vitalityDamage = GetStatMax(BCS_Vitality);
			action.processedDmg.essenceDamage = GetStatMax(BCS_Essence);
			if ( action.attacker == thePlayer )
			{
				ShowFloatingValue(EFVT_InstantDeath, 0, false);
			}
			break;
		}
	}

	if(action.processedDmg.vitalityDamage > 0 && UsesVitality())
	{
		
		if(this.HasAlternateQuen() && this.HasTag('mq1060_witcher'))
		{
			dontShowDamage = true;
		}
		else
		{
			DrainVitality(action.processedDmg.vitalityDamage);
			action.SetDealtDamage();
		}
		
	}
	if(action.processedDmg.essenceDamage > 0 && UsesEssence())
	{
		DrainEssence(action.processedDmg.essenceDamage);
		action.SetDealtDamage();
	}
	if(action.processedDmg.moraleDamage > 0)
		DrainMorale(action.processedDmg.moraleDamage);
	if(action.processedDmg.staminaDamage > 0)
		DrainStamina(ESAT_FixedValue, action.processedDmg.staminaDamage, 0);
		
	
	ShouldAttachArrowToPlayer( action );
	
	
	if( ((action.attacker && action.attacker == thePlayer) || (CBaseGameplayEffect)action.causer) && !action.GetUnderwaterDisplayDamageHack() )
	{
		if(action.GetInstantKillFloater())
		{
			hudModuleDamageType = EFVT_InstantDeath;
		}
		else if(action.IsCriticalHit())
		{
			hudModuleDamageType = EFVT_Critical;
		}
		else if(action.IsDoTDamage())
		{
			hudModuleDamageType = EFVT_DoT;
		}
		else
		{
			hudModuleDamageType = EFVT_None;
		}			
	
		
		if(!dontShowDamage)
			ShowFloatingValue(hudModuleDamageType, action.GetDamageDealt(), (hudModuleDamageType == EFVT_DoT) );
	}
	
	
	if(action.attacker && !action.IsDoTDamage() && wasAlive && action.GetDTCount() > 0 && !action.GetUnderwaterDisplayDamageHack())
	{
		theGame.witcherLog.CacheCombatDamageMessage(action.attacker, this, action.GetDamageDealt());
		theGame.witcherLog.AddCombatDamageMessage(action.DealtDamage());
	}
		
	
	if(playerAttacker)
	{
		if (thePlayer.HasBuff(EET_Mutagen07))
		{
			mutagen = thePlayer.GetBuff(EET_Mutagen07);
			theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'lifeLeech', min, max);
			lifeLeech = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
			if (UsesVitality())
				lifeLeech = lifeLeech * action.processedDmg.vitalityDamage;
			else if (UsesEssence())
				lifeLeech = lifeLeech * action.processedDmg.essenceDamage;
			else
				lifeLeech = 0;
			
			thePlayer.GainStat(BCS_Vitality, lifeLeech);
		}			
	}
	
	
	if(playerAttacker && action.IsActionMelee())
	{
		attackName = ((W3Action_Attack)action).GetAttackName();
	
		
		if ( thePlayer.HasBuff(EET_Mutagen04) && action.DealsAnyDamage() && thePlayer.IsHeavyAttack(attackName) && thePlayer.GetStat(BCS_Stamina) > 0)
		{
			mutagen = thePlayer.GetBuff(EET_Mutagen04);
			theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'staminaCostPerc', min, max);
			stamina = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
			stamina *= thePlayer.GetStat(BCS_Stamina);
			theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'healthReductionPerc', min, max);
			health = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
			if (UsesVitality())
			{
				health *= GetStat(BCS_Vitality);
				DrainVitality(health);					
				thePlayer.DrainStamina(ESAT_FixedValue, stamina, 0.5f);
			}
			else if (UsesEssence())
			{
				health *= GetStat(BCS_Essence);
				DrainEssence(health);					
				thePlayer.DrainStamina(ESAT_FixedValue, stamina, 0.5f);
			}
			
			if(health > 0)
				action.SetDealtDamage();
		}
	}
	
	
	if( !IsAlive() )
	{
		
		
		
		
		
		
		OnDeath( action );
	}
	
	
	SignalGameplayDamageEvent('DamageTaken', action );

}
*/

@wrapMethod( CActor ) function OnTakeDamage( action : W3DamageAction )
{
	if(ACS_Enabled())
	{
		ACS_OnTakeDamage( action );
	}

	wrappedMethod(action);
}

@wrapMethod( CActor) function ReactToReflectedAttack( target : CGameplayEntity)
{
	var hp, dmg : float;
	var action : W3DamageAction;

	if(false) 
	{
		wrappedMethod(target);
	}
	
	action = new W3DamageAction in this;
	action.Initialize(target,this,NULL,'',EHRT_Reflect,CPS_AttackPower,true,false,false,false);
	action.SetHitAnimationPlayType(EAHA_ForceYes);
	action.SetCannotReturnDamage( true );
	
	if (ACS_Enabled() && this == thePlayer) { action.SetHitAnimationPlayType(EAHA_ForceNo); action.ClearDamage(); action.ClearEffects(); action.SuppressHitSounds(); } //EternalHunt
	
	if( ((CActor) target).HasTag( 'scolopendromorph' ) )
	{
		((CActor) target).PlayEffect('heavy_hit_back');
	}
	else
	{
		((CActor) target).PlayEffectOnHeldWeapon('light_block');
	}
	
	theGame.damageMgr.ProcessAction( action );		
	delete action;	
}

@wrapMethod( CActor ) function FindAttackTargets(preAttackData : CPreAttackEventData) : array<CGameplayEntity>
{
	var targets : array<CGameplayEntity>;
	var i : int;
	var attitude : bool;
	var canLog : bool;

	if(false) 
	{
		wrappedMethod(preAttackData);
	}
	
	canLog = theGame.CanLog();
	
	if(preAttackData.rangeName == '')
	{
		if ( canLog )
		{
			LogAssert(false, "CActor.FindAttackTargets: attack <<" + preAttackData.attackName + ">> of <<" + this + ">> has no range defined!!! Skipping hit!!!");
			LogDMHits("CActor.FindAttackTargets: attack <<" + preAttackData.attackName + ">> of <<" + this + ">> has no range defined!!! Skipping hit!!!");
		}
		return targets;
	}
	else
	{
		GatherEntitiesInAttackRange(targets, preAttackData.rangeName);			
	}
	
	if ( ACS_Enabled() ) { if ( this == thePlayer ) { targets.Clear(); targets = ACS_Custom_Attack_Range( preAttackData ); } }//EternalHunt
	for(i=targets.Size()-1; i>=0; i-=1)
	{
		if(!targets[i] || targets[i] == this)
		{
			
			targets.EraseFast(i);
		}
		else if( (W3SignEntity)targets[i] || (CProjectileTrajectory)targets[i] || (CDamageAreaEntity)targets[i] || (W3ToxicCloud)targets[i])
		{
			
			targets.EraseFast(i);
		}	
		else if(!targets[i].IsAlive())
		{
			
			targets.EraseFast(i);
		}
		else if( targets[i].HasTag( 'isHiddenUnderground' ) )
		{
			
			targets.EraseFast(i);
		}
		else
		{
			
			attitude = IsRequiredAttitudeBetween(this, targets[i], preAttackData.Damage_Hostile, preAttackData.Damage_Neutral, preAttackData.Damage_Friendly || ((CActor)targets[i]).HasBuff(EET_AxiiGuardMe) );
			if(!attitude)
			{
				if ( canLog )
				{
					LogDMHits("Attacker <<" + this + ">> is skipping target << " + targets[i] + ">> due to failed attitude check");
				}
				targets.EraseFast(i);
			}
		}
	}
	
	
	
						
	return targets;
}
	
@wrapMethod( CActor ) function OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
{	
	var parriedBy : array<CActor>;
	var weaponId : SItemUniqueId;
	var player : CR4Player = thePlayer;
	var parried, countered : bool;

	if(false) 
	{
		wrappedMethod(animEventName, animEventType, data, animInfo );
	}

	if ( ACS_Enabled() && this == thePlayer ) { ACS_Pre_Attack( animEventName, animEventType, data, animInfo ); } //EternalHunt
	if(animEventType == AET_DurationStart)
	{
		ignoreAttack = false;
		SetAttackData(data);
		weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
		if ( this != thePlayer )
			BlinkWeapon(weaponId);
		
		SetCurrentAttackData(data, animInfo );
		if ( data.rangeName == 'useCollisionFromItem' )
		{
			lastAttackRangeName = data.rangeName;
		}
	}
	
	else if(animEventType == AET_DurationEnd)
	{
		attackEventInProgress = false;
		
		
		if ( ignoreAttack )
		{
			ignoreAttack = false;
			return true;
		}
		
		
		if ( this == thePlayer && ( GetEventEndsAtTimeFromEventAnimInfo(animInfo) - GetLocalAnimTimeFromEventAnimInfo(animInfo) > 0.06 ))
			return true;
		
		weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
		
		if(!GetInventory().IsIdValid(weaponId) || data.attackName == '')
		{
			LogAttackEvents("No valid attack data set - skipping hit!");
			LogAssert(false, "No valid attack data set - skipping hit!");
			return false;
		}
			
		hitTargets = FindAttackTargets(data);
		parriedBy = TestParryAndCounter(data, weaponId, parried, countered);
		
		if( data.attackName == 'attack_speed_based' && this == thePlayer )
			return false;
		
		lastAttackRangeName = data.rangeName;
		DoAttack(data, weaponId, parried, countered, parriedBy, GetAnimNameFromEventAnimInfo( animInfo ), GetLocalAnimTimeFromEventAnimInfo( animInfo ));
	}
}

@wrapMethod( CActor ) function ApplyFallingDamage( heightDiff : float, optional reducing : bool ) : float
{
	var forcedDeath		: bool;
	var action			: W3DamageAction;
	var dmgPerc			: float;
	var damageValue		: float;		
	var deathDistance	: float;
	var damageDistance	: float;
	var fallDamageCap 	: float; 
	
	var totalDamage		: float;

	if(false) 
	{
		wrappedMethod(heightDiff, reducing);
	}
	
	forcedDeath			= !thePlayer.IsAlive();
	
	
	if( reducing )
	{
		deathDistance	= deathDistanceReducing;
		damageDistance	= damageDistanceReducing;
	}
	else
	{
		deathDistance	= deathDistNotReducing;
		damageDistance	= damageDistanceNotReducing;
	}
	
	
	if(IsMonster())
	{
		deathDistance = deathDistanceReducing;
	}
	
	
	
	if( heightDiff > deathDistance || forcedDeath )
	{
		dmgPerc	= 1.0f;	
		PlayEffect( 'heavy_hit' );
		PlayEffect( 'hit_screen' );	
		
		
		totalDamage	= GetMaxHealth();
	}
	
	
	else if( heightDiff < damageDistance )
	{
		return 0.0f;		
	}
	
	
	else
	{
		
		
		if ( GetCharacterStats().HasAbilityWithTag('Boss') || (W3MonsterHuntNPC)this )
		{
			fallDamageCap = 0.23f;
		}
		else
		{
			fallDamageCap = 0.85f;
		}
		
		dmgPerc	= MapF( heightDiff, damageDistance, deathDistance, 0.0f, fallDamageCap );
		
		
		
		if( dmgPerc < 1.0f && dmgPerc >= GetHealthPercents() - fallDamageMinHealthPerc )
		{
			totalDamage	= MaxF( 0.0f, GetHealthPercents() - fallDamageMinHealthPerc ) * GetMaxHealth();
		}
		else
		{			
			totalDamage	= dmgPerc * GetMaxHealth();
		}
	}				
	
	if (ACS_Enabled() && this == thePlayer) { totalDamage = ACS_Settings_Main_Float('EHmodDamageSettings','EHmodPlayerFallDamage', 0.2) * thePlayer.GetMaxHealth(); dmgPerc = 0;} //EternalHunt
	action = new W3DamageAction in this;
	action.Initialize(NULL, this, NULL, "FallingDamage", EHRT_None, CPS_Undefined, false, false, false, true);
	action.SetCanPlayHitParticle(false);
	damageValue	= totalDamage;
	action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, damageValue );
	
	theGame.damageMgr.ProcessAction( action );
	
	delete action;
	
	return dmgPerc;
}

@wrapMethod( CActor ) function OnProcessActionPost(action : W3DamageAction)
{
	var actorVictim : CActor;
	var bloodTrailParam : CBloodTrailEffect;
	var attackAction : W3Action_Attack;

	if(false) 
	{
		wrappedMethod(action);
	}
	
	actorVictim = (CActor)action.victim;
	attackAction = (W3Action_Attack)action;
	
	if ( ACS_Enabled() && attackAction && attackAction.IsActionMelee()) { GetACSWatcher().ACS_On_Hit_Effects(action); } //EternalHunt
	if( attackAction && action.DealsAnyDamage() && actorVictim)
	{
		bloodTrailParam = (CBloodTrailEffect)actorVictim.GetGameplayEntityParam( 'CBloodTrailEffect' );
		if ( bloodTrailParam )
		{
			GetInventory().PlayItemEffect( attackAction.GetWeaponId(), bloodTrailParam.GetEffectName() );
		}
	}	
}

///////////////////////////////////////////////////////////////////////////////////


@wrapMethod(CExplorationStateJump) function StateWantsToEnter() : bool
{
	var potentialTarget	: Vector;
	var angle			: float;
	var direction		: Vector;
	
	if(false) 
	{
		wrappedMethod();
	}
	
	if(!theInput.LastUsedPCInput() && thePlayer.GetInputHandler().GetIsAltSignCasting() && theInput.IsActionPressed('CastSign'))
	{
		return false;
	}
	
	
	
	
	
	if( m_CooldownCurF > 0.0f )
	{
		return false;
	}	
	
	
	if(	!m_ExplorationO.m_InputO.IsJumpJustPressed() )
	{
		return false;
	}
	
	
	if( thePlayer.IsInCombatAction() )
	{
		return false;
	}
	
	if( thePlayer.IsInShallowWater() )
	{
		//return false; //EternalHunt
	}
	
	
	if( m_InteractionLastLockingF > 0.0f )
	{
		if( !m_ExplorationO.m_InputO.IsJumpJustReleased() )
		{
			return false;
		}
	}
	
	
	if( !m_AllowJumpInSlopesB )
	{
		direction	= m_ExplorationO.m_MoverO.GetSlideDir();
		if(  m_ExplorationO.m_InputO.IsModuleConsiderable() )
		{
			if( VecDot( VecNormalize( direction ), m_ExplorationO.m_InputO.GetMovementOnPlaneNormalizedV() ) < -0.2f )
			{
				angle		= m_ExplorationO.m_MoverO.GetRealSlideAngle();
				angle		= m_ExplorationO.m_MoverO.ConvertAngleDegreeToSlidECoef( angle );
				if( angle >= m_ExplorationO.m_MoverO.GetSlidingLimitMinCur() )
				{
					return false;
				}
			}
		}
	}
	
	return true;
}

@wrapMethod(CExplorationStateJump) function StateEnterSpecific( prevStateName : name )	
{
	var launchVelocity : Vector; 
	var terrainNormal : Vector; 
	var launchTerrainStrength : float; 

	if(false) 
	{
		wrappedMethod(prevStateName);
	}

	if( prevStateName == 'Idle' ) 
	{
		m_ExplorationO.m_MoverO.SetVelocity(m_ExplorationO.m_MoverO.GetMovementVelocity() / 2.0f);
		m_ExplorationO.m_MoverO.SetVerticalSpeed(0.0f);
	}
	
	GetProperJumpTypeParameters( prevStateName ); //EternalHunt
		
	SetSpeedOverrideCheck();
	
	SaveProperJumpParameters();
	
	SetBehaviorParameters();
	
	GetJumpInitialOrientation();
	
	//SetInitialOrientation(); //EternalHunt
	
	AddConservingVelocityToTheParams();
	
	AddActionsToBlock();
	BlockActions();
	
	thePlayer.OnRangedForceHolster( true, true );
	
	thePlayer.SetBehaviorVariable( 'inJumpState', 1.f );
	
	BlockStamina( prevStateName );
	if (m_JumpParmsS.m_JumpTypeE == EJT_IdleToWalk || m_JumpParmsS.m_JumpTypeE == EJT_Run || m_JumpParmsS.m_JumpTypeE == EJT_Sprint || m_JumpParmsS.m_JumpTypeE == EJT_Idle) {terrainNormal = m_ExplorationO.m_OwnerMAC.GetTerrainNormal(false);launchTerrainStrength = 5.0 * (1.0f - MapF(m_ExplorationO.m_MoverO.GetMovementSpeedF(), 5.0f, 10.0f, 0.0f, 1.0f));if (VecLength(terrainNormal) > 0.8f) {launchVelocity = Vector(0.0f, 0.0f, -launchTerrainStrength);launchVelocity += terrainNormal * launchTerrainStrength;launchVelocity.X *= 0.5f;launchVelocity.Y *= 0.5f;m_ExplorationO.m_MoverO.AddVelocity(launchVelocity);}} // Eternal Hunt
	
	if( prevStateName != 'StartFalling' )
	{
		m_ExplorationO.m_SharedDataO.ResetHeightFallen();
	}

	if( prevStateName == 'Climb' ) {m_ExplorationO.m_MoverO.SetVelocity(Vector(0.0f, 0.0f, -1.0f));} //EternalHunt
	
	ChangeTo( JSS_TakingOff );
	
	m_CameraStartB											= true;
	m_LandPredictedB										= false;
	m_JumpOriginalPositionV									= m_ExplorationO.m_OwnerE.GetWorldPosition();
	m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF		= 20.0f;
	m_ExplorationO.m_SharedDataO.m_JumpIsTooSoonToLandB		= true;
	m_ExplorationO.m_SharedDataO.m_ShouldFlipFootOnLandB	= m_JumpParmsS.m_FlipFeetOnLandB;
	m_ExplorationO.m_SharedDataO.m_DontRecalcFootOnLandB	= m_JumpParmsS.m_DontRecalcFootOnLand;
	
	
	if( m_JumpParmsS.m_JumpTypeE == EJT_Vault && m_ExplorationO.m_SharedDataO.m_ClimbStateTypeE == ECRT_Running )
	{
		m_ExplorationO.m_SharedDataO.m_DontRecalcFootOnLandB	= true;
	}
	
	m_HitCeilingB											= false;
	cameraFallIsSet											= false;
	
	m_ExplorationO.m_MoverO.SetManualMovement( true );
	m_ExplorationO.m_OwnerMAC.SetGravity( false ); //EternalHunt
	
	
	thePlayer.AbortSign();
}

@addField(CExplorationStateJump)
var ACS_resetVelocity : bool;

@addMethod(CExplorationStateJump) function ACS_TickJump(dt : float) 
{
	var velocity : Vector;
	var maxSpeed : float;

	if (ACS_resetVelocity && m_ExplorationO.GetStateTimeF() > 1.0f) 
	{
		velocity = m_ExplorationO.m_MoverO.GetDisplacementLastFrame() / dt;
	} 
	else 
	{
		velocity = m_ExplorationO.m_MoverO.GetMovementVelocity();
	}
	
	ACS_resetVelocity = false;
	
	if (m_SubstateE == JSS_TakingOff || (m_SubstateE == JSS_Flight && m_ExplorationO.GetStateTimeF() < 0.5f)) 
	{

	}
	else
	{
		velocity += Vector(0.0f, 0.0f, -15.0f) * dt;
	}
	
	maxSpeed = 50.0f;
	
	if (VecLength(velocity) > maxSpeed) 
	{
		velocity = VecReduceNotExceedingV(velocity, VecLengthSquared(velocity) * 0.006f * dt, maxSpeed);
	}
	
	m_ExplorationO.m_MoverO.SetVelocity(velocity);
	m_ExplorationO.m_MoverO.SetVerticalSpeed(0.0f);
	m_ExplorationO.m_MoverO.Translate(velocity * dt);
	m_ExplorationO.m_MoverO.UpdateOrientToInput( m_JumpParmsS.m_OrientationSpeedF, dt );
}

@wrapMethod(CExplorationStateJump) function StateUpdateSpecific( _Dt : float )
{
	var l_DispF			: Vector;
	var l_VerticalDispF	: float;
	
	if(false) 
	{
		wrappedMethod(_Dt);
	}
	
	l_VerticalDispF	= 0.0f;
	ACS_TickJump(_Dt); //EternalHunt
	switch( m_SubstateE )
	{
		case JSS_TakingOff :
			if ( m_JumpParmsS.m_TakeOffTimeF >= 0.0f && m_ExplorationO.GetStateTimeF() >= m_JumpParmsS.m_TakeOffTimeF )
			{
				ChangeTo( JSS_Flight );
			}
			
			if( m_ExplorationO.GetStateTimeF() >= m_JumpParmsS.m_StartOrientTimeF && m_ExplorationO.m_InputO.IsModuleConsiderable() )
			{
				m_ExplorationO.m_MoverO.UpdateOrientToInput( m_JumpParmsS.m_OrientationSpeedF, _Dt );
			}
			if( m_JumpParmsS.m_HorImpulseAtStartB )
			{
				Update2DLogicMovement( _Dt );
			}
			break;
		case JSS_Flight :
			if( CheckLandPrediction() )
			{
				ChangeTo( JSS_PredictingLand );
			}				
			Update2DLogicMovement( _Dt );
			break;
		case JSS_Inertial:	
			if( CheckLandPrediction() )
			{
				ChangeTo( JSS_PredictingLand );
			}
			Update2DLogicMovement( _Dt );
			l_VerticalDispF	= UpdateVerticalMovement( _Dt );
			break;
		case JSS_PredictingLand :
			m_LandPredicedCoefF	=	MinF( m_LandPredicedCoefF + m_LandPredicedBlendF * _Dt, 1.0f );
			m_ExplorationO.m_OwnerE.SetBehaviorVariable( m_BehEventPredictingS, m_LandPredicedCoefF );	
			Update2DLogicMovement( _Dt );
			l_VerticalDispF	= UpdateVerticalMovement( _Dt );
			break;
	}	

	
	if( m_JumpParmsS.m_JumpTypeE == EJT_ToWater )
	{
		
		
		m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF	= MaxF( -60.0f, m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF - _Dt * 100.0f );
		m_ExplorationO.m_OwnerE.SetBehaviorVariable( 'Slide_Inclination', m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF );
		thePlayer.OnMeleeForceHolster(true);
	}
	
	
	if( m_ExplorationO.m_SharedDataO.m_JumpIsTooSoonToLandB && m_ExplorationO.GetStateTimeF() >= m_JumpParmsS.m_TimeToPrepareForLandF )
	{
		m_ExplorationO.m_SharedDataO.m_JumpIsTooSoonToLandB	= false;
	}
	
	m_ExplorationO.m_SharedDataO.UpdateFallHeight();
	
	
	UpdateCameraChange();
}

@wrapMethod(CExplorationStateJump) function StateExitSpecific( nextStateName : name )
{
	if(false) 
	{
		wrappedMethod(nextStateName);
	}

	thePlayer.SetBIsCombatActionAllowed( true );
	
	thePlayer.SetBehaviorVariable( 'inJumpState', 0.f );
	
	
	
	if( nextStateName == m_ExplorationO.GetDefaultStateName() )
	{
		m_ExplorationO.SendAnimEvent( 'AnimEndAUX' );
	}
	
	
	if( nextStateName != 'Land' && nextStateName != 'AirCollision' && nextStateName != 'Slide' && nextStateName != 'Idle'  && nextStateName != 'Interaction' && nextStateName != 'Climb'  && nextStateName != 'Swim' ) 
	{
		m_ExplorationO.SendAnimEvent( 'Idle' );
	}
	
	
	if( nextStateName != 'AirCollision' && nextStateName != 'Climb' && nextStateName != 'Land' ) 
	{
		m_ExplorationO.m_OwnerMAC.SetEnabledFeetIK( true, 0.05f );
	}
	
	m_ExplorationO.m_MoverO.SetManualMovement( false );
	m_ExplorationO.m_OwnerMAC.SetGravity( true ); //Eternal Hunt
	
	m_CooldownCurF		= m_CooldownTotalF;
	
	m_ExplorationO.m_SharedDataO.SetFallFromCritical( false );
	
	
	LogExploration( GetStateName() + ": Jumped distance: " + VecDistance( m_ExplorationO.m_OwnerE.GetWorldPosition(), m_JumpOriginalPositionV ) + " Height: " + ( m_ExplorationO.m_SharedDataO.GetFallingMaxHeightReached() ) );
}

@wrapMethod(CExplorationStateJump) function GetProperJumpTypeParameters( prevStateName : name )
{
	var	l_JumpTypeE	: EJumpType;
	
	if(false) 
	{
		wrappedMethod(prevStateName);
	}
	
	l_JumpTypeE	= GetJumpTypeThatShouldPlay( prevStateName );
	
	
	
	
	SetJumpParametersBasedOnType( l_JumpTypeE );
	ACS_Jump_Extend_Init( l_JumpTypeE ); //EternalHunt
	
	if( m_UseGenericJumpB )
	{
		if( m_JumpParmsS.m_JumpTypeE	== EJT_Idle || m_JumpParmsS.m_JumpTypeE == EJT_Walk ||  m_JumpParmsS.m_JumpTypeE == EJT_WalkHigh || m_JumpParmsS.m_JumpTypeE == EJT_Run || m_JumpParmsS.m_JumpTypeE == EJT_Sprint )
		{
			l_JumpTypeE					= m_JumpParmsS.m_JumpTypeE;
			m_JumpParmsS				= m_JumpParmsGenericS;
			m_JumpParmsS.m_HorImpulseF	= VecLength( m_ExplorationO.m_OwnerMAC.GetVelocity() );
			m_JumpParmsS.m_JumpTypeE	= l_JumpTypeE;
		}
	}
}

@wrapMethod(CExplorationStateJump) function SetJumpParametersBasedOnType( type : EJumpType )
{
	if(false) 
	{
		wrappedMethod(type);
	}

	switch( type )
	{
		case EJT_Idle:
			m_JumpParmsS	= m_JumpParmsIdleS;
			break;
		case EJT_IdleToWalk:
			m_JumpParmsS	= m_JumpParmsIdleToWalkS;
			break;
		case EJT_Walk :
			m_JumpParmsS	= m_JumpParmsWalkS;
			break;
		case EJT_WalkHigh :
			m_JumpParmsS	= m_JumpParmsWalkHighS;
			break;
		case EJT_Run :
			m_JumpParmsS	= m_JumpParmsRunS;
			break;
		case EJT_Sprint :
			m_JumpParmsS	= m_JumpParmsSprintS;
			break;
		case EJT_Fall :
			m_JumpParmsS	= m_JumpParmsFallS;
			break;
		case EJT_Slide :
			if (VecLength(m_ExplorationO.m_MoverO.GetMovementVelocity()) > 5.0f) {m_JumpParmsS = m_JumpParmsRunS;} else {m_JumpParmsS = m_JumpParmsIdleToWalkS;} //EternalHunt
			break;
		case EJT_Hit :
			m_JumpParmsS	= m_JumpParmsHitS;
			break;
		case EJT_Vault :
			m_JumpParmsS	= m_JumpParmsVaultS;
			break;
		case EJT_Skate :
			m_JumpParmsS	= m_JumpParmsSkateIdleS;
			break;
		case EJT_ToWater :
			m_JumpParmsS	= m_JumpParmsToWaterS;
			break;
		case EJT_KnockBack :
			m_JumpParmsS	= m_JumpParmsKnockBackS;
			break;
		case EJT_KnockBackFall:
			m_JumpParmsS	= m_JumpParmsKnockBackFallS;
			break;
			
		default:
			m_JumpParmsS	= m_JumpParmsWalkS;
			LogExplorationError( "Trying to get jump params for a missing jump type" );
			break;
	}
}

@wrapMethod(CExplorationStateJump) function AddConservingVelocityToTheParams()
{
	var conserving		: float;
	var velocity		: Vector;
	var jumpDirection	: Vector;
	
	if(false) 
	{
		wrappedMethod();
	}
	
	if( !m_JumpParmsS.m_UsePhysicJumpB )
	{
		return;
	}
	
	jumpDirection	= VecFromHeading( m_OrientationInitialF );
	
	
	
	
	velocity		= m_ExplorationO.m_MoverO.GetMovementVelocity();
	
	
	
	if( m_CanSetVelocityB && m_JumpParmsS.m_HorImpulseAtStartB )
	{
		LogExploration("Jump Conserve: Impulse at start: " + m_JumpParmsS.m_HorImpulseF );
		//m_ExplorationO.m_MoverO.SetVelocity( jumpDirection * m_JumpParmsS.m_HorImpulseF ); //EternalHunt
	}
	
	if( VecLengthSquared( velocity ) < m_SpeedSqrMinToConserveF )
	{
		LogExploration("Jump Conserve: No Conserved Speed, going too slow" );
		return;
	}
	
	
	conserving		= VecDot( velocity, jumpDirection );
	if( m_JumpParmsS.m_ConserveCoefsB )
	{
		conserving		*= m_ConserveHorizontalCoefF;
		conserving		= MinF( conserving, m_ConserveHorizontalMaxF );
		if( m_JumpParmsS.m_ConserveAddB )
		{
			conserving	= m_JumpParmsS.m_HorImpulseF + conserving;
		}
		else
		{
			conserving	=  ClampF( conserving, -m_JumpParmsS.m_HorImpulseF, m_JumpParmsS.m_HorImpulseF );
		}
		
		m_JumpParmsS.m_HorImpulseF	=  conserving;
		LogExploration("Jump Conserve: Conserved Horizontal speed: " + conserving );
	}
	
	
	if( m_JumpParmsS.m_ConserveCoefsB )
	{
		conserving		= VecDot( velocity, Vector( 0.0f, 0.0f, 1.0f ) );
		if( velocity.Z >= 0.0f )
		{
			conserving	*= m_ConserveVertUpCoefF;
			conserving	= MinF( conserving, m_ConserveVertUpMaxF );
		}
		else
		{
			conserving	*= m_ConserveVertDownCoefF;
			conserving	= MaxF( conserving, -m_ConserveVertDownMaxF );
		}		
		if( m_JumpParmsS.m_ConserveAddB )
		{
			conserving	= m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF + conserving;
		}
		else
		{
			if( velocity.Z >= 0.0f )
			{
				conserving	=  MaxF( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF, conserving );
			}
			else
			{
				conserving	=  MaxF( 0.0f, m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF + conserving );
			}
		}
		m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF		=  conserving;
		LogExploration("Jump Conserve: Conserved Vertical speed: " + conserving );
	}
}

@wrapMethod(CExplorationStateJump) function ChangeToFlight()
{
	var succeeded	: bool;
	var direction	: Vector;
	
	if(false) 
	{
		wrappedMethod();
	}
	
	m_ExplorationO.m_MoverO.SetPlaneMovementParams( m_JumpParmsS.m_HorMovementS );
	direction	= VecFromHeading( m_OrientationInitialF );
	
	
	if( m_CanSetVelocityB && !m_JumpParmsS.m_HorImpulseAtStartB )
	{
		//m_ExplorationO.m_MoverO.SetVelocity( direction * m_JumpParmsS.m_HorImpulseF ); //EternalHunt
	}
	
	
	m_ExplorationO.m_OwnerMAC.SetEnabledFeetIK( false );
	
	
	if( m_JumpParmsS.m_UsePhysicJumpB && m_JumpParmsS.m_JumpTypeE != EJT_Sprint )
	{		
		ChangeTo( JSS_Inertial );
		
	}
	//m_ExplorationO.m_MoverO.SetVerticalSpeed( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF ); //EternalHunt
}

@wrapMethod(CExplorationStateJump) function ChangeToInertial()
{
	var velocity 		: Vector;
	var vertVelocity	: float;
	
	if(false) 
	{
		wrappedMethod();
	}
	
	m_ExplorationO.m_MoverO.SetPlaneMovementParams( m_JumpParmsFallS.m_HorMovementS );
	
	
	
	
	m_ExplorationO.m_MoverO.SetVerticalMovementParams( m_JumpParmsFallS.m_VerticalMovementS ); 
	
	
	if( !m_JumpParmsS.m_RecalcSpeedOnInertialB )
	{
		return;
	}
	
	velocity		= m_ExplorationO.m_OwnerMAC.GetVelocity();
	vertVelocity	= velocity.Z;
	velocity.Z		= 0.0f;
	//m_ExplorationO.m_MoverO.SetVelocity( velocity ); //EternalHunt
	if( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF != 0.0f )
	{		
		//m_ExplorationO.m_MoverO.SetVerticalSpeed( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF ); //EternalHunt
	}
	else
	{
		//m_ExplorationO.m_MoverO.SetVerticalSpeed( vertVelocity );	//EternalHunt
	}
}

@wrapMethod(CExplorationStateJump) function UpdateCameraIfNeeded( out moveData : SCameraMovementData, dt : float ) : bool
{
	if(false) 
	{
		wrappedMethod(moveData, dt);
	}

	if(m_JumpParmsS.m_JumpTypeE == EJT_Vault)
	{
		return true;
	}
	
	if ( 
	ACS_Enabled() 
	&& (ACS_Settings_Main_Bool('EHmodJumpSettings','EHmodJumpExtend', false) ) || ACS_Armor_Equipped_Check())
	{
		return ACS_UpdateJumpCamera(moveData,dt);
	}
	else
	{
		return true;
	}
}

@wrapMethod(CExplorationStateJump) function ReactToHitCeiling() : bool
{
	var velocity : Vector; //EternalHunt

	if(false) 
	{
		wrappedMethod();
	}

	if( m_ReactToHitCeilingB && !m_HitCeilingB )
	{
		m_ExplorationO.m_OwnerE.RaiseEvent( m_BehEventCeilingHit );
		m_HitCeilingB	= true;
		velocity = m_ExplorationO.m_MoverO.GetMovementVelocity();velocity.Z = MinF(0.0f, velocity.Z);m_ExplorationO.m_MoverO.SetVelocity(velocity); //EternalHunt
	}
	
	return true;
}

@wrapMethod(CExplorationStateJump) function ReactToHitGround() : bool
{
	var direction	: Vector;
	var dot			: float;
	var time		: float;
	var velocity    : Vector;
	var terrainNormal : Vector; //EternalHunt
	
	if(false) 
	{
		wrappedMethod();
	}
	
	
	if( m_ExplorationO.GetStateTimeF() <= 0.0f )
	{
		return true;
	}
	
	if( m_SubstateE == JSS_TakingOff )
	{
		return true; 
	}
	
	if( m_JumpParmsS.m_JumpTypeE != EJT_Fall )
	{
		time	= m_ExplorationO.GetStateTimeF();
		if( time < m_JumpParmsS.m_TakeOffTimeF )
		{
			return true;
		}
		if( time < 0.1f ) 
		{	
			return true;
		}
	}		
	
	
	velocity = m_ExplorationO.m_MoverO.GetMovementVelocity();
	
	direction = velocity;terrainNormal = m_ExplorationO.m_OwnerMAC.GetTerrainNormal( false );
	
	dot	= VecDot( direction, terrainNormal); //EternalHunt
	
	if( m_ExplorationO.m_MoverO.GetMovementVerticalSpeedF() == 0.0f )
	{
		direction	= m_ExplorationO.m_OwnerMAC.GetVelocityBasedOnRequestedMovement();
		dot			= VecDot( direction, m_ExplorationO.m_OwnerMAC.GetTerrainNormal( false ) );
		
		if( dot >= -0.0001f )
		{
			LogExploration( GetStateName() + ": HitGround, But done nothing cause GetVelocityBasedOnRequestedMovement is moving away from the terrain normal" );
			return true;
		}
	}
	else
	{
		direction	= m_ExplorationO.m_MoverO.GetMovementVelocity();
		
		dot			= VecDot( direction, m_ExplorationO.m_OwnerMAC.GetTerrainNormal( false ) );
		
		if( dot > 0.0f )
		{
			LogExploration( GetStateName() + ": HitGround, But done nothing cause GetMovementVelocity().Z is > 0.0f" );
			return true;
		}
	}
	
	if( m_ExplorationO.StateWantsAndCanEnter( 'Slide' ) )
	{
		SetReadyToChangeTo( 'Slide' );
		return true;
	}
	if( m_JumpParmsS.m_JumpTypeE == EJT_Skate )
	{
		SetReadyToChangeTo( 'SkateLand' );
		return true;
	}
	
	if( m_SubstateE >= JSS_Flight )
	{
		
		SetReadyToChangeTo( 'Land' );
		return true;
	}
	
	
	LogExploration( GetStateName() + ": HitGround, But did nothing with it cause the jump state is not ready to land still" );
	return true;
}

@addField(CExplorationStateSlide)
protected var ACS_ignoreFirstRelease : bool;

@addField(CExplorationStateSlide)
private var ACS_firstFrameImpulse : Vector;

@addField(CExplorationStateSlide)
private var ACS_previousDt : float;

@addField(CExplorationStateSlide)
private var ACS_ignoringOneFrameOfZeroDisplacement : bool;

@addField(CExplorationStateSlide)
private var ACS_isFirstSlideEverywhereFrame : bool;

@addField(CExplorationStateSlide)
private var ACS_lastSlideExitTime : float;

@addField(CExplorationStateSlide)
private var ACS_lastSlideRightFootForward : bool;

@addField(CExplorationStateSlide)
private var ACS_slideFrictionMultiplier : float;

@addField(CExplorationStateSlide)
private var ACS_airTime : float;

@addField(CExplorationStateSlide)
private var ACS_wantLeaveToJump : bool;

@addField(CExplorationStateSlide)
private var ACS_kneeBend : float;

@addField(CExplorationStateSlide)
private var ACS_slowEnoughToExit : bool;

@addField(CExplorationStateSlide)
private var ACS_startedManually : bool;

@addField(CExplorationStateSlide)
private var ACS_flameFxLeft : CEntity;

@addField(CExplorationStateSlide)
private var ACS_flameFxRight : CEntity;

@addField(CExplorationStateSlide)
private var ACS_boneIndexLeftFoot : int;

@addField(CExplorationStateSlide)
private var ACS_boneIndexRightFoot : int;

@wrapMethod(CExplorationStateSlide) function StateWantsToEnter() : bool
{
	if(false) 
	{
		wrappedMethod();
	}

	if( ACS_IsSlideEverywherePressed() && (m_ExplorationO.GetStateCur() == 'Jump' || m_ExplorationO.GetStateCur() == 'Land') ){return true;} //EternalHunt	

	if( !WantsToEnterBasic() )
	{
		return false;
	}
	
	
	if( useWideTerrainCheckToEnter )
	{
		if( !WantsToEnterWide() )
		{
			return false;
		}
	}
	
	return true;		
}

@wrapMethod(CExplorationStateSlide) function StateEnterSpecific( prevStateName : name )	
{
	var velocity			: Vector;
	var slideDir			: Vector;
	var slideNormal			: Vector;
	var slidingDirDot		: float;
	var slidingForward		: bool;
	var isRightFootForward	: bool;
	
	if(false) 
	{
		wrappedMethod(prevStateName);
	}

	m_DeadB		= false;
	
	
	startedFromJump	= prevStateName == 'Jump' && m_ExplorationO.GetStateTimeF() >= m_ExplorationO.m_SharedDataO.m_SkipLandAnimTimeMaxF;
	startedFromRoll	= prevStateName	== 'Roll';
	
	
	if( startedFromJump || prevStateName == 'WallSlide' )
	{
		CheckLandingDamage();
	}
	
	
	landCoolingDown	= prevStateName	== 'Land' || prevStateName	== 'Jump';
	
	
	
	m_ExplorationO.m_MoverO.SetSlidingParams( movementParams );
	m_ExplorationO.m_MoverO.SetSlideSpeedMode( false );	
	ACS_slideFrictionMultiplier = 1.0f; //EternalHunt
	SetTerrainParameters(); 		
	
	m_ExplorationO.m_OwnerMAC.SetSliding( usePhysics );
	m_ExplorationO.m_OwnerMAC.SetSlidingSpeed( slidingPhysicsSpeed );
	
	
	m_ExplorationO.m_MoverO.GetSlideDirAndNormal( slideDir, slideNormal );
	velocity		= m_ExplorationO.m_MoverO.GetMovementVelocity();		
	velocity		-= slideNormal * MinF(0.0f, VecDot( slideNormal, velocity )); //EternalHunt
	velocity		+= slideDir * initialImpulse;

	//m_ExplorationO.m_MoverO.SetVelocity( velocity ); //EternalHunt

	if ((prevStateName == 'Jump' || prevStateName == 'Land') && ACS_IsSlideEverywherePressed())
	{
		ACS_ignoreFirstRelease = true;

		ACS_startedManually = true;
		ACS_firstFrameImpulse = 2.5f * VecFromHeading(m_ExplorationO.m_OwnerE.GetHeading());
	}
	else
	{
		ACS_ignoreFirstRelease = false;
		ACS_startedManually = false;
		ACS_firstFrameImpulse = velocity;
	}

	ACS_slowEnoughToExit = false;
	ACS_wantLeaveToJump = false;
	m_ExplorationO.m_MoverO.SetVerticalSpeed(0.0f);
	ACS_previousDt = 1.0f;
	ACS_isFirstSlideEverywhereFrame = true;
	ACS_airTime = 0.0f;
	ACS_kneeBend = 0.0f;
	ACS_boneIndexLeftFoot = m_ExplorationO.m_OwnerE.GetBoneIndex( 'l_foot' );
	ACS_boneIndexRightFoot = m_ExplorationO.m_OwnerE.GetBoneIndex( 'r_foot' ); //EternalHunt
	
	
	slideDirectionDamped	= slideDir;
	
	
	m_ExplorationO.m_SharedDataO.m_JumpDirectionForcedV	= slideDir;
	
	
	inclination				=  m_ExplorationO.m_MoverO.GetRealSlideAngle( ); 
	inclinationEnterTimeCur	= inclinationEnterTimeMax;
	turnInclinationCur		= 0.0f;
	
	
	slidingDirDot	= VecDot( slideDir, m_ExplorationO.m_OwnerE.GetWorldForward() );
	slidingForward	= slidingDirDot >= 0.0f;
	m_ExplorationO.SetBehaviorParamBool( behForwardVar, slidingForward );
	
	
	if( slidingForward )
	{
		isRightFootForward	= !m_ExplorationO.m_MoverO.IsRightFootForwardTowardsDir( slideDir );
	}
	
	
	else
	{
		isRightFootForward	= VecDot( slideDir, m_ExplorationO.m_OwnerE.GetWorldRight() ) < 0.0f;
	}
	if (theGame.GetEngineTimeAsSeconds() < ACS_lastSlideExitTime + 1.0f ) {isRightFootForward = !ACS_lastSlideRightFootForward;} //EternalHunt
	m_ExplorationO.SetBehaviorParamBool( behRightFootForwardVar, isRightFootForward );
	ACS_lastSlideRightFootForward = isRightFootForward; //EternalHunt
	
	BlockActions();
	
	
	m_ExplorationO.m_OwnerMAC.SetEnabledFeetIK( false ); 
	
	
	
	
	if( particlesEnabled )
	{
		thePlayer.PlayEffectOnBone( particlesName, boneLeftFoot );
		thePlayer.PlayEffectOnBone( particlesName, boneRightFoot );
		timeToRespawnParticlesCur	= timeToRespawnParticlesMax;
	}
	
	
	toFallCameraLevel	= 0;
	cameraShakeState = SCSS_None;
	
	
	if( startedFromJump || startedFromRoll )
	{
		subState			= SSS_HardSliding;
		lockedOnHardSliding	= true;
	}
	else
	{
		subState			= SSS_Entering;
		lockedOnHardSliding	= false;
	}
	exitingTimeCur		= 0.0f;		
	
	m_ExplorationO.m_OwnerMAC.SetAnimatedMovement( true );m_ExplorationO.m_OwnerMAC.SetUseExtractedMotion(false);m_ExplorationO.m_OwnerMAC.SetGravity( false ); //EternalHunt
	thePlayer.AbortSign();	
}

@wrapMethod(CExplorationStateSlide) function StateChangePrecheck()	: name
{
	if(false) 
	{
		wrappedMethod();
	}

	if( m_DeadB )
	{
		return GetStateName();
	}
	
	
	if( !ACS_ignoreFirstRelease && jumpAllowed && m_ExplorationO.GetStateTimeF() >= jumpCoolDownTime ) //EternalHunt
	{
		
		if( !thePlayer.IsCombatMusicEnabled() )
		{
			if( m_ExplorationO.StateWantsAndCanEnter( 'Jump' ) )
			{
				return 'Jump';
			}
			else if( m_ExplorationO.StateWantsAndCanEnter( 'Climb' ) )
			{
				return 'Climb';
			}
		}
	}
	
	
	if( subState >= SSS_Exited )
	{
		return 'Idle';
	}
	if (!ACS_SlideEverywhereCancel() && !ACS_slowEnoughToExit) {return GetStateName();} //EternalHunt
	
	if( !lockedOnHardSliding && m_ExplorationO.GetStateTimeF() > exitingTimeMinSoft )
	{		
		if( StateWantsToExit() )
		{
			return 'Idle';
		}
	}
	
	return super.StateChangePrecheck();
}

@addMethod(CExplorationStateSlide) function ACS_SlideEverywhereCancel(): bool 
{
	if (ACS_SlideEverywhereCancelCommand() || (!ACS_startedManually && m_ExplorationO.GetStateTimeF() < 1.0f))
	{
		return true;
	}

	return false;
}

@addMethod(CExplorationStateSlide) function ACS_RemoveFlameFx()
{
	ACSGetCEntity('ACS_Slide_Particle_Left').Destroy();
	ACSGetCEntity('ACS_Slide_Particle_Right').Destroy();

	ACS_flameFxRight = NULL;

	ACS_flameFxLeft = NULL;
}

@addMethod(CExplorationStateSlide) function ACS_UpdateFlameFx(rot: EulerAngles) 
{
	var rangeFxTemplate : CEntityTemplate;
	var leftPos : Vector;
	var rightPos : Vector;
	var leftRot : EulerAngles;
	var rightRot : EulerAngles;
	var time : float;
	
	time = m_ExplorationO.GetStateTimeF();
	
	if (ACS_SlideEverywhereCancel() || subState >= SSS_Exiting) 
	{
		ACS_RemoveFlameFx();
	} 
	else 
	{
		m_ExplorationO.m_OwnerE.GetBoneWorldPositionAndRotationByIndex(ACS_boneIndexLeftFoot, leftPos, leftRot);
		m_ExplorationO.m_OwnerE.GetBoneWorldPositionAndRotationByIndex(ACS_boneIndexRightFoot, rightPos, rightRot);
		leftRot = VecToRotation(m_ExplorationO.m_OwnerE.GetWorldForward());
		rightRot = VecToRotation(m_ExplorationO.m_OwnerE.GetWorldForward());

		leftRot.Yaw -= 90; rightRot.Yaw -= 90;
		
		if(!ACS_flameFxLeft)
		{
			ACSGetCEntity('ACS_Slide_Particle_Left').Destroy();
			ACSGetCEntity('ACS_Slide_Particle_Right').Destroy();
			
			rangeFxTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\slide_particles.w2ent", true);
			
			ACS_flameFxLeft = theGame.CreateEntity(rangeFxTemplate, leftPos, leftRot);
			
			ACS_flameFxLeft.AddTag('ACS_Slide_Particle_Left');

			ACS_flameFxLeft.PlayEffectSingle('burn');
			
			ACS_flameFxLeft.PlayEffectSingle('burn_2');
			
			ACS_flameFxLeft.PlayEffectSingle('igni_reaction_djinn');
			
			ACS_flameFxRight = theGame.CreateEntity(rangeFxTemplate, rightPos, rightRot);
			
			ACS_flameFxRight.AddTag('ACS_Slide_Particle_Right');
			
			ACS_flameFxRight.PlayEffectSingle('burn');
			
			ACS_flameFxRight.PlayEffectSingle('burn_2');
			
			ACS_flameFxRight.PlayEffectSingle('igni_reaction_djinn');
		}
		else
		{
			ACS_flameFxLeft.TeleportWithRotation(leftPos, leftRot);
			ACS_flameFxRight.TeleportWithRotation(rightPos, rightRot);
		}
	}
}

@addMethod(CExplorationStateSlide) function ACS_StateUpdateSlideEverywhere( _Dt : float, out _TurnF : float, out _AccelF : float, stoppingFriction : bool )
{
	var velocity : Vector;
	var inputVector : Vector;
	var turnAmount : float;
	var terrainNormal : Vector;
	var terrainFactor : float;
	var steerAngleDiff : float;
	var velocity2D : Vector;
	var expectedVelocity : Vector;
	var steerMax : float;
	var inputDotVel : float;
	var inputStrength : float;
	var maxSpeed : float;
	var grounded : bool;
	var firstFrameVelocity : Vector;
	var displacementLastFrame : Vector;
	var expectedDisplacement : Vector;
	var collisionZ : float;
	var kneeAbsorb : float;
	var totalFriction : float = 0.0f;

	grounded = m_ExplorationO.m_OwnerMAC.IsOnGround();

	if (grounded) 
	{
		terrainNormal = VecNormalize(m_ExplorationO.m_OwnerMAC.GetTerrainNormal( false ));
	} 
	else 
	{
		terrainNormal = Vector(0.0f, 0.0f, 1.0f);
	}
	
	if (grounded) 
	{
		ACS_airTime = 0.0f;
	} 
	else 
	{
		ACS_airTime += _Dt;
	}

	displacementLastFrame = m_ExplorationO.m_MoverO.GetDisplacementLastFrame();
	
	expectedVelocity = m_ExplorationO.m_MoverO.GetMovementVelocity();

	expectedDisplacement = expectedVelocity * _Dt;
	
	if (ACS_ignoringOneFrameOfZeroDisplacement) 
	{
		ACS_ignoringOneFrameOfZeroDisplacement = false;
	} 
	else if (VecLengthSquared(displacementLastFrame) == 0.0f) 
	{
		displacementLastFrame = expectedDisplacement;ACS_ignoringOneFrameOfZeroDisplacement = true;
	}
	
	if (!ACS_isFirstSlideEverywhereFrame) 
	{
		collisionZ = displacementLastFrame.Z - expectedDisplacement.Z;

		kneeAbsorb = ClampF(collisionZ, -0.05f - ACS_kneeBend, 0.1f - ACS_kneeBend);

		displacementLastFrame.Z -= kneeAbsorb;ACS_kneeBend += kneeAbsorb;

		ACS_kneeBend += ClampF(-ACS_kneeBend, -0.1f * _Dt, 0.1f * _Dt);
	}
	
	ACS_UpdateFlameFx(m_ExplorationO.m_OwnerE.GetWorldRotation());

	if (_Dt > ACS_previousDt * 2.0f) 
	{
		expectedDisplacement.Z -= kneeAbsorb;velocity = expectedDisplacement / _Dt;
	} 
	else 
	{
		velocity = displacementLastFrame / _Dt;
	}
	
	ACS_previousDt = _Dt;
	
	if (ACS_isFirstSlideEverywhereFrame) 
	{
		if (startedFromRoll) 
		{
			if (VecLength(velocity) > 1.0f) 
			{
				velocity = VecNormalize(velocity) * 1.0f;
			}
		}
		
		firstFrameVelocity = velocity + ACS_firstFrameImpulse;
		
		velocity = VecNormalize(firstFrameVelocity) * MinF(VecLength(firstFrameVelocity), MaxF(5.0f, VecLength(velocity)));
	} 
	else if (VecLengthSquared(velocity) > VecLengthSquared(expectedVelocity)) 
	{
		velocity = VecNormalize(velocity) * VecLength(expectedVelocity);
	} 
	else 
	{
		velocity = VecInterpolate(velocity, expectedVelocity, 0.2f);
	}
	
	ACS_isFirstSlideEverywhereFrame = false;
	inputVector = m_ExplorationO.m_InputO.GetMovementOnPlaneV();
	inputVector.W = 0.0f;
	inputStrength = MinF(VecLength(inputVector), 1.0f);
	
	if (grounded) 
	{
		velocity += VecNormalize(inputVector - terrainNormal * VecDot(terrainNormal, inputVector)) * VecLength(inputVector) * 5.0f * _Dt;
	}

	velocity2D = Vector(velocity.X, velocity.Y);

	if (VecLength(velocity2D) > 1.0f && inputStrength > 0.1f) 
	{
		inputDotVel = VecDot(VecNormalize(velocity2D), VecNormalize(inputVector));
		
		if (inputDotVel > -0.66f) 
		{
			steerMax = 90.0f * MinF(10.0f, VecLength(velocity2D)) / 10.0f * inputStrength;
			
			steerAngleDiff = AngleDistance(VecHeading(inputVector), VecHeading(velocity2D));
			
			steerAngleDiff = ClampF(steerAngleDiff, -steerMax * _Dt, steerMax * _Dt);
			
			velocity += VecRotByAngleXY(velocity2D, -steerAngleDiff) - velocity2D;
		}
		
		if (inputDotVel < -0.33f) 
		{
			velocity += velocity * inputDotVel * inputStrength * 0.5f * MapF(m_ExplorationO.GetStateTimeF(), 0.0f, 5.0f, 0.0f, 1.0f) * _Dt;
		}
	}
	
	velocity += Vector(0.0f, 0.0f, -16.0f) * _Dt;
	
	if (grounded) 
	{
		terrainFactor = VecDot(velocity, terrainNormal);velocity -= terrainNormal * MinF(0.0f, terrainFactor);
		
		totalFriction += terrainNormal.Z * 2.0f * ACS_slideFrictionMultiplier;
	} 
	else 
	{
		totalFriction += 2.0f;
	}

	if (stoppingFriction) 
	{
		totalFriction += 5.0f;
	}
	
	velocity = VecReduceTowardsZero(velocity, totalFriction * _Dt);
	
	velocity = VecReduceTowardsZero(velocity, VecLength(velocity) * 0.02f * _Dt);
	
	maxSpeed = 30.0f;

	if (VecLength(velocity) > maxSpeed) 
	{
		velocity = VecReduceNotExceedingV(velocity, VecLengthSquared(velocity) * 0.015f * _Dt, maxSpeed);
	}
	
	ACS_slowEnoughToExit = VecLength(velocity) < 1.0f;
	
	if (VecLength2D(velocity) > 0.01f) 
	{
		turnAmount = AngleDistance( VecHeading(velocity), m_ExplorationO.m_OwnerE.GetHeading() );
	} 
	else 
	{
		turnAmount = 0.0f;
	}
	
	turnAmount = ClampF(turnAmount, -180.0f * _Dt, 180.0f * _Dt);

	m_ExplorationO.m_MoverO.SetVelocity(velocity);
	
	m_ExplorationO.m_MoverO.SetVerticalSpeed(0.0f);
	m_ExplorationO.m_MoverO.Translate(velocity * _Dt);
	m_ExplorationO.m_MoverO.AddYaw(turnAmount);

	if (ACS_ignoreFirstRelease) 
	{
		if (theInput.IsActionJustReleased( ACS_SlideEverywhereCommand() )) 
		{
			ACS_ignoreFirstRelease = false;
		}
	} 
	else 
	{
		if (theInput.IsActionJustPressed( ACS_SlideEverywhereCommand() )) 
		{
			ACS_wantLeaveToJump = true;
			SetReadyToChangeTo( 'Jump' );
			m_ExplorationO.m_SharedDataO.m_CanFallSetVelocityB	= false;
		}
	}
	
	_AccelF = VecLength(expectedVelocity) - VecLength(velocity);

	_TurnF = ClampF(turnAmount / _Dt / 10.0f, -1.0f, 1.0f);
}

@wrapMethod(CExplorationStateSlide) function StateUpdateSpecific( _Dt : float )
{
	var slideDirection		: Vector;
	var slideNormal			: Vector;
	var slideCoef			: float;
	var targetYaw			: float;
	var finalOrientingSpeed	: float;
	var newInclination		: float;
	var turn				: float;
	var accel				: float;
	
	if(false) 
	{
		wrappedMethod(_Dt);
	}
	
	if( m_DeadB )
	{
		return;
	}
	
	
	SubstateChangePrecheck( _Dt );
	
	
	slideCoef		= m_ExplorationO.m_MoverO.GetSlideCoef( true );		
	m_ExplorationO.m_MoverO.GetSlideDirAndNormal( slideDirection, slideNormal );
	
	
	
	
	
	UpdateForcedDirection( slideDirection );		
	
	
	finalOrientingSpeed	= ComputeOrientingSpeed( slideCoef );
	if( slideCoef > 0.0f )
	{			
		targetYaw	= VecHeading( slideDirection );
		
		
	}
	else
	{
		if( m_ExplorationO.m_MoverO.GetMovementSpeedF() > 1.0f )
		{
			targetYaw		= m_ExplorationO.m_MoverO.GetMovementSpeedHeadingF(); 
			
			
		}
		else
		{
			targetYaw		= m_ExplorationO.m_OwnerE.GetHeading();
		}
	}	
	
	stoppingFriction = true; //EternalHunt
	if( !usePhysics && subState	!= SSS_Exited )
	{
		
		stoppingFriction	= subState == SSS_Exiting || (!WantsToEnterBasic( true ) && (ACS_SlideEverywhereCancel() || ACS_slowEnoughToExit)); //EternalHunt
		
		//m_ExplorationO.m_MoverO.UpdateSlidingInertialMovementWithInput( _Dt, turn, accel, stoppingFriction, targetYaw, finalOrientingSpeed ); //EternalHunt
	}
	ACS_StateUpdateSlideEverywhere(_Dt, turn, accel, stoppingFriction); //EternalHunt
	
	UpdateAngleToRotateToAdaptToSlope( slideDirection, _Dt );
	
	
	m_ExplorationO.m_MoverO.SetSlideSpeedMode( m_ExplorationO.GetStateTimeF() > toConsiderFallTimeTotal );	
	
	
	if( slideKills )
	{
		UpdateFallCoef( _Dt );
	}
	
	
	if( particlesEnabled && timeToRespawnParticlesMax > 0.0f )
	{
		timeToRespawnParticlesCur	-= _Dt;		
		if( timeToRespawnParticlesCur <= 0.0f )
		{
			
			thePlayer.PlayEffectOnBone( particlesName, boneLeftFoot );
			thePlayer.PlayEffectOnBone( particlesName, boneRightFoot );
			timeToRespawnParticlesCur	= timeToRespawnParticlesMax;
		}
	}
	
	
	turn				*= turnInclinationMax;
	turnInclinationCur	= BlendF( turnInclinationCur, turn, turnInclinationBlend * _Dt );
	m_ExplorationO.m_OwnerE.SetBehaviorVariable( behTurnVar, turnInclinationCur );
	m_ExplorationO.m_OwnerE.SetBehaviorVariable( behAccelVar, accel );		
}

@wrapMethod(CExplorationStateSlide) function StateExitSpecific( nextStateName : name )
{
	if(false) 
	{
		wrappedMethod(nextStateName);
	}

	ACS_lastSlideExitTime = theGame.GetEngineTimeAsSeconds();m_ExplorationO.m_MoverO.SetManualMovement( false );m_ExplorationO.m_OwnerMAC.SetGravity( true );m_ExplorationO.m_OwnerMAC.SetUseExtractedMotion(true);ACS_RemoveFlameFx(); //EternalHunt
	theGame.GetGamerProfile().SetStat(ES_SlideTime, FloorF(m_ExplorationO.GetStateTimeF()) );

	m_ExplorationO.m_OwnerMAC.SetSliding( false );
	
	if( nextStateName == 'Idle' )
	{
		
		LogExploration("Left slide to Idle" );
		if( exitingTimeCur < exitingTimeTotal )
		{
			m_ExplorationO.SendAnimEvent( behSlideEndRun );
		}
		else
		{
			m_ExplorationO.SendAnimEvent( behSlideEndIdle );
		}
	}
	else if( nextStateName == 'CombatExploration' )
	{
		LogExploration("Left slide to Combat" );
		if( exitingTimeCur < exitingTimeTotal )
		{
			m_ExplorationO.SendAnimEvent( behSlideEndRun );
		}
		else
		{
			m_ExplorationO.SendAnimEvent( behSlideEndIdle );
		}
	}
	
	thePlayer.SetBIsCombatActionAllowed( true );
	
	
	if( m_ExplorationO.m_MoverO.GetMovementSpeedF() > 5.0f )
	{
		thePlayer.SetIsSprinting( true );
		m_ExplorationO.m_OwnerMAC.SetGameplayRelativeMoveSpeed( 2.0f );
	}
	
	
	cooldownCur = cooldownMax;
	
	
	subState	= SSS_Entering;
	
	
	
	
	
	if( particlesEnabled )
	{
		thePlayer.StopEffect( particlesName );
		
	}
	
	
	StopCameraAnim();
	
	
	if( nextStateName == 'StartFalling' )
	{
		PrepareFallFromSlide();
	}
	
	
	if( nextStateName != 'StartFalling' )
	{
		thePlayer.GoToCombatIfWanted();
	}
}

@wrapMethod(CExplorationStateSlide) function WantsToEnterBasic( optional checkingForExit : bool ) : bool
{
	var dot				: float;
	var coef			: float;
	var result			: bool;
	var terrainNormal   : Vector;
	var coefExtra : float;

	if(false) 
	{
		wrappedMethod(checkingForExit);
	}
	
	if (checkingForExit && ACS_airTime > 0.0f && ACS_airTime < 0.5f) {return true;} //EternalHunt
	if( useSmothedCoefOnIdle && ( m_ExplorationO.GetStateCur() == 'Idle' || m_ExplorationO.GetStateCur() == 'CombatExploration' ) )
	{
		if( !m_ExplorationO.m_OwnerMAC.IsSliding() )
		{ 
			return false;
		}
	}
	
	
	SetTerrainParameters();
	
	terrainNormal = m_ExplorationO.m_OwnerMAC.GetTerrainNormal(false);if (checkingForExit) {coefExtra = coefExtraToStop;}coef = MapF(AcosF(terrainNormal.Z) * 2.0f / Pi() + coefExtra, m_ExplorationO.m_MoverO.GetSlidingLimitMinCur(), m_ExplorationO.m_MoverO.GetSlidingLimitMax(), 0.0f, 1.0f);
	/*
	if( checkingForExit )
	{
		coef = m_ExplorationO.m_MoverO.GetSlideCoef( true, coefExtraToStop );
	}
	else
	{
		coef = m_ExplorationO.m_MoverO.GetSlideCoef( true );
	}
	*///EternalHunt
	
	
	if( coef <= 0.0f )
	{
		return false;
	}
	
	
	
	
	if( coef < coefToStartBackward )
	{
		if( m_ExplorationO.GetStateCur() == 'Land' )
		{
			return false;
		}
	}		
	
	
	dot = m_ExplorationO.m_InputO.GetInputDirOnSlopeDot();
	if( slideCoefRelatedToInput )
	{
		if( dot <= -dotToStartForward )
		{
			result	=  coef >= coefToStartBackward;
		}
		else if( dot >= dotToStartForward )
		{
			result	= coef >= coefToStartForward;
		}
		else
		{
			result	= coef >= coefToStartCenter;
		}
	}
	else
	{		
		if( dot >= dotToStartForward )
		{
			result	= coef >= coefToStartForward;
		}
		else
		{
			result	=  coef >= coefToStartBackward;
		}
	}
	
	if( !result )
	{
		return false;
	}
	
	return true;
}

@wrapMethod(CExplorationStateSlide) function StateWantsToExit() : bool
{
	if(false) 
	{
		wrappedMethod();
	}

	if(!ACS_SlideEverywhereCancel() && !ACS_slowEnoughToExit){return false;} //EternalHunt
	if( requireSpeedToExit )
	{
		if( !SpeedAllowsExit() )
		{
			return false;
		}
	}
	
	
	if( WantsToEnterBasic( true ) )
	{
		return false;
	}
	
	return true;
}

@wrapMethod(CExplorationStateSlide) function ReactToLoseGround() : bool
{
	if(false) 
	{
		wrappedMethod();
	}

	if( subState > SSS_Entering && ACS_SlideEverywhereCancel() && !ACS_wantLeaveToJump && ACS_airTime > 0.5f) //EternalHunt
	{
		SetReadyToChangeTo( 'StartFalling' );
	}
	
	return true;
}

//////////////////////////////////////

@wrapMethod(CBehTreeTaskDeathIdle) function Main() : EBTNodeStatus
{
	var owner : CNewNPC;

	if(false) 
	{
		wrappedMethod();
	}

	owner = GetNPC();

	while ( true )
	{
		if ( IsNameValid( setAppearanceTo ) && GetLocalTime() > timeStamp + changeAppearanceAfter )
		{
			owner.SetAppearance( setAppearanceTo );
			setAppearanceTo = '';
		}
		if ( disableRagdollAfter > 0 && GetLocalTime() > timeStamp + disableRagdollAfter  )
		{
			owner.GetRootAnimatedComponent().SetEnabled( false );
			disableRagdollAfter = 0;
		}
		if ( disableCollision && GetLocalTime() > timeStamp + disableCollisionDelay )
		{
			owner.EnableCharacterCollisions( false );
			ACS_SpawnDeathCollision(owner,owner.GetWorldPosition()); //EternalHunt
			disableCollision = false;
		}
		
		SleepOneFrame();
	}
	return BTNS_Active;
}

//////////////////////////////////////

@wrapMethod(CBehTreeTaskDeathAnimDecorator) function Main() : EBTNodeStatus
{
	var owner 						: CNewNPC;
	var timeStamp 					: float;
	var activateDisableCollision	: bool;

	if(false) 
	{
		wrappedMethod();
	}

	owner = GetNPC();

	timeStamp = GetLocalTime();
	
	while( finisherEnabled )
	{
		if( syncInstance )
		{
			if( syncInstance.HasEnded() )
			{
				return BTNS_Completed;
			}
		}
		else if ( timeStamp + 1.f <= GetLocalTime() ) 
		{
			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_FinisherInput) );
			thePlayer.OnBlockAllCombatTickets( false );
			Complete(true);
		}
		
		SleepOneFrame();
	}
	
	while ( !enabledRagdoll )
	{
		if ( disableCollisionOnAnim && !activateDisableCollision && timeStamp + disableCollisionOnAnimDelay <= GetLocalTime() )
		{
			activateDisableCollision = true;
			owner.EnableCharacterCollisions( false );
			ACS_SpawnDeathCollision(((CNewNPC)(owner)),owner.GetWorldPosition()); //EternalHunt
			owner.CanPush( false );
		}
		
		SleepOneFrame();
	}
	if ( enabledRagdoll )
	{
		if ( disableCollisionOnAnim && !activateDisableCollision )
		{
			owner.EnableCharacterCollisions( false );
			ACS_SpawnDeathCollision(((CNewNPC)(owner)),owner.GetWorldPosition()); //EternalHunt
			owner.CanPush( false );
		}
		Sleep( completeTimer );
		ACS_RagdollOrNot(owner); //EternalHunt
		owner.RaiseForceEvent( 'DeathEndAUX' );
		
		return BTNS_Completed;
	}
	return BTNS_Active;
}

@wrapMethod(CBehTreeTaskDeathAnimDecorator) function OnAnimEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo ) : bool
{
	var owner 			: CNewNPC;

	if(false) 
	{
		wrappedMethod(animEventName, animEventType, animInfo);
	}

	owner = GetNPC();

	if ( animEventName == 'SetRagdoll' )
	{			
		if ( ( ( CMovingPhysicalAgentComponent ) owner.GetMovingAgentComponent() ).HasRagdoll() )
		{
			ACS_RagdollOrNot(owner); //EternalHunt
			enabledRagdoll = true;
		}
	}
	else if ( animEventName == 'Detach')
	{
		owner.BreakAttachment();
		return true;
	}
	else if ( animEventName == 'RotateEventStart')
	{
		owner.SetRotationAdjustmentRotateTo( GetCombatTarget() );
		return true;
	}
	else if ( animEventName == 'RotateAwayEventStart')
	{
		owner.SetRotationAdjustmentRotateTo( GetCombatTarget(), 180.0 );
		return true;
	}
	return false;
}

//////////////////////////////////////

@wrapMethod(MountHorse) function ProcessMountHorse()
{
	var riderData 				: CAIStorageRiderData;
	var distance				: float;
	var contextSwitchOffset		: float;
	var mountStartTimestamp		: float;
	var ACS_MOUNT_TIMEOUT 		: float;
	
	if(false) 
	{
		wrappedMethod();
	}

	if (ACS_New_Replacers_Female_Active() || thePlayer.IsCiri())
	{
		ACS_MOUNT_TIMEOUT = 5.0f;
	}
	else
	{
		ACS_MOUNT_TIMEOUT = 0.5f;
	}
	
	parent.SetCleanupFunction( 'MountCleanup' );
	
	mountAnimStarted = false;
	
	if ( mountType == MT_instant )
	{
		
		
		parent.OnHitGround();
	}
	
	riderData = thePlayer.GetRiderData();
	
	horseComp.Unpair(); 
	
	horseComp.PairWithRider( riderData.sharedParams );	
	riderData.sharedParams.rider 		= thePlayer;
	riderData.sharedParams.vehicleSlot  = vehicleSlot;
	
	parent.SignalGameplayEventParamInt( 'RidingManagerMountHorse', mountType );
	
	
	SleepOneFrame();
	
	mountStartTimestamp = theGame.GetEngineTimeAsSeconds();
	while( true )
	{
		if ( riderData.GetRidingManagerCurrentTask() == RMT_None && riderData.sharedParams.mountStatus == VMS_mounted )
		{
			break;
		}
		if ( mountAnimStarted )
		{
		
		}
		else if ( riderData.ridingManagerMountError == true || mountStartTimestamp + ACS_MOUNT_TIMEOUT < theGame.GetEngineTimeAsSeconds() )
		{
			OnMountingFailed();
			parent.PopState();
			break;
		}
		SleepOneFrame();
	}
	
	parent.ClearCleanupFunction();
	horseComp.IssueCommandToUseVehicle( );
}

//////////////////////////////////////

@wrapMethod( CExplorationMovementCorrector ) function UpdateTurnAdjustment( _Dt : float )
{
	var	adjustTime		: float;
	var playerActionEventListeners : array<CGameplayEntity>;
	var vel : float;
	var player : CR4Player;

	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0
	|| thePlayer.HasTag('ACS_Is_Sneaking')
	|| thePlayer.HasTag('ACS_Animal_Attract')
	)
	{
		wrappedMethod( _Dt );

		return;
	}
	
	if ( !theGame.IsUberMovementEnabled() || disallowRotWhenGoingToSleep )
		turnAdjustBlocked = true;
	else if ( AbsF( AngleDistance( thePlayer.rawPlayerHeading, thePlayer.GetHeading() ) ) >= 144.f )
		turnAdjustBlocked = true;
	else if ( thePlayer.IsInCombatAction() )
		turnAdjustBlocked = true;
	else if ( m_ExplorationO.GetStateCur() == 'Jump' )
		turnAdjustBlocked = true;
	
	
	else if ( VecLength( m_ExplorationO.m_OwnerMAC.GetVelocity() ) <= 0.f )
		turnAdjustBlocked = true;
	
		
	if( turnAdjustmentTimeCur > 0.0f && thePlayer.IsAlive() )
	{
		m_ExplorationO.m_MoverO.UpdateOrientToInput( 9.0f, _Dt );
		turnAdjustmentTimeCur	-= _Dt;
	}
	else
	{		
		if( !turnAdjustBlocked )
		{
			adjustTime	= m_ExplorationO.GetTurnAdjustmentTime();
			if( adjustTime > 0.0f )
			{
				m_ExplorationO.m_MoverO.UpdateOrientToInput( 7.5f, _Dt );
			}
			else if ( thePlayer.GetPlayerCombatStance() == PCS_Normal )
			{
				player = thePlayer;
				
				if ( player.rangedWeapon && player.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait' )
					m_ExplorationO.m_MoverO.UpdateOrientToInput( 7.5f, _Dt );
			}
		}
	}
}

//////////////////////////////////////

@addField(CExplorationMover)
var ACS_m_AmountOrientHeadingThisFrameF : float;

@wrapMethod( CExplorationMover ) function ApplyMovement( _Dt : float )
{
	var movAdj : CMovementAdjustor;

	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0
	|| thePlayer.HasTag('ACS_Is_Sneaking')
	|| thePlayer.HasTag('ACS_Animal_Attract')
	)
	{
		wrappedMethod( _Dt );

		return;
	}

	AddYaw( m_ExplorationO.m_InputO.GetHeadingDiffFromPlayerF() * MinF( 1.0f, ACS_m_AmountOrientHeadingThisFrameF * _Dt ) );
	ACS_m_AmountOrientHeadingThisFrameF = 0.0f;
	
	if( _Dt <= 0.0f )
	{
		return;
	}

	
	movAdj = m_ExplorationO.m_OwnerMAC.GetMovementAdjustor();
	movAdj.AddOneFrameTranslationVelocity( m_DisplacementV / _Dt );
	m_RotationDeltaEA.Yaw	= m_RotationDeltaEA.Yaw / _Dt;
	m_RotationDeltaEA.Pitch	= m_RotationDeltaEA.Pitch / _Dt;
	m_RotationDeltaEA.Roll	= m_RotationDeltaEA.Roll / _Dt;
	movAdj.AddOneFrameRotationVelocity( m_RotationDeltaEA );
	
	
	if( m_BankingNeedsUpdatingB )
	{
		UpdateBanking( _Dt );
	}
}

@wrapMethod( CExplorationMover ) function UpdateOrientToInput( _Speed, _Dt : float ) : bool
{
	var inputHeading	: float;
	var turnDelta		: float;

	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0
	|| thePlayer.HasTag('ACS_Is_Sneaking')
	|| thePlayer.HasTag('ACS_Animal_Attract')
	)
	{
		wrappedMethod( _Speed, _Dt );

		return false;
	}
	
	if( m_ExplorationO.m_InputO.IsModuleConsiderable() )
	{
		ACS_m_AmountOrientHeadingThisFrameF += _Speed * 2.0f;
	}
	
	return false;
}

@wrapMethod( CExplorationMover ) function AddYaw( _DeltaYawF : float )
{	
	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0
	|| thePlayer.HasTag('ACS_Is_Sneaking')
	|| thePlayer.HasTag('ACS_Animal_Attract')
	)
	{
		wrappedMethod( _DeltaYawF );

		return;
	}

	Rotate( EulerAngles( 0.0f, _DeltaYawF, 0.0f ) );
}

//////////////////////////////////////

@wrapMethod( W3PlayerWitcher ) function OnProcessCastingOrientation( isContinueCasting : bool )
{
	var customOrientationTarget 	: EOrientationTarget;
	var checkHeading 				: float;
	var rotHeading 					: float;
	var playerToHeadingDist 		: float;
	var slideTargetActor			: CActor;
	var newLockTarget				: CActor;
	var enableNoTargetOrientation	: bool;
	var currTime 					: float;

	if (false)
	{
		wrappedMethod( isContinueCasting );
	}

	enableNoTargetOrientation = true;
	if ( GetDisplayTarget() && this.IsDisplayTargetTargetable() )
	{
		enableNoTargetOrientation = false;
		if ( theInput.GetActionValue( 'CastSignHold' ) > 0 || this.IsCurrentSignChanneled() )
		{
			if ( IsPCModeEnabled() )
			{
				if ( EngineTimeToFloat( theGame.GetEngineTime() ) >  pcModeChanneledSignTimeStamp + 1.f )
					enableNoTargetOrientation = true;
			}
			else
			{
				if ( GetCurrentlyCastSign() == ST_Igni || GetCurrentlyCastSign() == ST_Axii )
				{
					slideTargetActor = (CActor)GetDisplayTarget();
					if ( slideTargetActor 
						&& ( !slideTargetActor.GetGameplayVisibility() || !CanBeTargetedIfSwimming( slideTargetActor ) || !slideTargetActor.IsAlive() ) )
					{
						SetSlideTarget( NULL );
						if ( ProcessLockTarget() )
							slideTargetActor = (CActor)slideTarget;
					}				
					
					if ( !slideTargetActor )
					{
						LockToTarget( false );
						enableNoTargetOrientation = true;
					}
					else if ( IsThreat( slideTargetActor ) || GetCurrentlyCastSign() == ST_Axii )
						LockToTarget( true );
					else
					{
						LockToTarget( false );
						enableNoTargetOrientation = true;
					}
				}
			}
		}

		if ( !enableNoTargetOrientation )
		{			
			customOrientationTarget = OT_Actor;
		}
	}
	
	if ( enableNoTargetOrientation )
	{
		if ( GetPlayerCombatStance() == PCS_AlertNear && theInput.GetActionValue( 'CastSignHold' ) > 0 )
		{
			if ( GetDisplayTarget() && !slideTargetActor )
			{
				currTime = EngineTimeToFloat( theGame.GetEngineTime() );
				if ( currTime > findActorTargetTimeStamp + 1.5f )
				{
					findActorTargetTimeStamp = currTime;
					
					newLockTarget = GetScreenSpaceLockTarget( GetDisplayTarget(), 180.f, 1.f, 0.f, true );
					
					if ( newLockTarget && IsThreat( newLockTarget ) && IsCombatMusicEnabled() )
					{
						SetTarget( newLockTarget, true );
						SetMoveTargetChangeAllowed( true );
						SetMoveTarget( newLockTarget );
						SetMoveTargetChangeAllowed( false );
						SetSlideTarget( newLockTarget );							
					}	
				}
			}
			else
				ProcessLockTarget();
		}
		
		if ( wasBRAxisPushed )
			customOrientationTarget = OT_CameraOffset;
		else
		{
			if ( !lastAxisInputIsMovement || theInput.LastUsedPCInput() )
				customOrientationTarget = OT_CameraOffset;
			else if ( theInput.GetActionValue( 'CastSignHold' ) > 0 )
			{
				if ( GetOrientationTarget() == OT_CameraOffset )
					customOrientationTarget = OT_CameraOffset;
				else if ( GetPlayerCombatStance() == PCS_AlertNear || GetPlayerCombatStance() == PCS_Guarded ) 
					customOrientationTarget = OT_CameraOffset;
				else
					customOrientationTarget = OT_Player;	
			}
			else
				customOrientationTarget = OT_CustomHeading;
		}			
	}		
	
	if ( GetCurrentlyCastSign() == ST_Quen )
	{
		if ( theInput.LastUsedPCInput() )
		{
			customOrientationTarget = OT_Camera;
		}
		else if ( IsCurrentSignChanneled() )
		{
			if ( bLAxisReleased )
				customOrientationTarget = OT_Player;
			else
				customOrientationTarget = OT_Camera;
		}
		else 
			customOrientationTarget = OT_Player;
	}	
	
	if ( GetCurrentlyCastSign() == ST_Axii && IsCurrentSignChanneled() )
	{	
		if ( slideTarget && (CActor)slideTarget )
		{
			checkHeading = VecHeading( slideTarget.GetWorldPosition() - this.GetWorldPosition() );
			rotHeading = checkHeading;
			playerToHeadingDist = AngleDistance( GetHeading(), checkHeading );
			
			if ( playerToHeadingDist > 45 )
				SetCustomRotation( 'ChanneledSignAxii', rotHeading, 0.0, 0.5, false );
			else if ( playerToHeadingDist < -45 )
				SetCustomRotation( 'ChanneledSignAxii', rotHeading, 0.0, 0.5, false );					
		}
		else
		{
			checkHeading = VecHeading( theCamera.GetCameraDirection() );
			rotHeading = GetHeading();
			playerToHeadingDist = AngleDistance( GetHeading(), checkHeading );
			
			if ( playerToHeadingDist > 45 )
				SetCustomRotation( 'ChanneledSignAxii', rotHeading - 22.5, 0.0, 0.5, false );
			else if ( playerToHeadingDist < -45 )
				SetCustomRotation( 'ChanneledSignAxii', rotHeading + 22.5, 0.0, 0.5, false );				
		}
	}		
		
	if ( IsActorLockedToTarget() )
		customOrientationTarget = OT_Actor;
	
	if (ACS_Settings_Main_Bool('EHmodTargetSettings','EHmodCastSignTowardsCameraCheck', false))
		customOrientationTarget = OT_CameraOffset;

	AddCustomOrientationTarget( customOrientationTarget, 'Signs' );
	
	if ( customOrientationTarget == OT_CustomHeading )
		SetOrientationTargetCustomHeading( GetCombatActionHeading(), 'Signs' );
}

@wrapMethod( CR4Player ) function FindTarget( optional actionCheck : bool, optional action : EBufferActionType, optional actionInput : bool ) : CActor
{	
	if (false)
	{
		wrappedMethod( actionCheck, action, actionInput );
	}

	if ( IsCombatMusicEnabled() && !IsInCombat() && reachableEnemyWasTooFar )
	{
		playerMode.UpdateCombatMode();
	}

	PrepareTargetingIn( actionCheck, action, actionInput );
	
	if ( IsInCombat() )
	{
		ACS_FindTargetSimple();
	}
	else if ( useNativeTargeting )
	{
		targeting.BeginFindTarget( targetingIn );
		targeting.FindTarget();
		targeting.EndFindTarget( targetingOut );
	}
	else
	{
		UpdateVisibleActors();
		MakeFindTargetPrecalcs();
		ResetTargetingOut();
		FindTarget_Scripted();
	}

	if ( targetingOut.result )
	{
		if ( targetingOut.confirmNewTarget )
		{
			ConfirmNewTarget( targetingOut.target );
		}
		return targetingOut.target;
	}
	return NULL;
}

@addMethod(CR4Player) function ACS_FindTargetSimple()
{
	var i						: int;
	var currentTarget			: CActor;
	var targets					: array< CActor >;
	var potentialFriendlyTargets: array< CActor >;
	var playerPosition			: Vector;
	var targetingInfo			: STargetingInfo;
	var bestRank				: float;
	var rank					: float;
	var curTargetRank			: float;
	var newTarget				: CActor;
	var inverseDist				: float;
	var cameraAngleDiff			: float;
	var movementAngleDiff		: float;
	var facingAngleDiff			: float;
	var targetHeadingVector		: Vector;
	var cameraWeight			: float;
	var movementWeight			: float;
	var facingWeight			: float;
	var distanceWeight			: float;
	var attackHysModifier		: float;
	var targetHysteresis		: float;
	var precull					: int;

	ResetTargetingOut();
		
	cameraWeight = ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetCameraWeight', 1.0);
	movementWeight = ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetMovementWeight', 0.75);
	facingWeight = ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetFacingWeight', 0.25);
	distanceWeight = ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetDistanceWeight', 1.0);
	targetHysteresis = ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetHysteresis', 1.05);
	targetingInfo.inFrameCheck = ACS_Settings_Main_Bool('EHmodTargetSettings','EHmodTargetInFrameCheck', true);
	
	attackHysModifier = 1.5f;
	
	currentTarget = GetTarget();
	playerPosition = this.GetWorldPosition();
	
	targetingInfo.source = this;
	targetingInfo.canBeTargetedCheck = true;
	targetingInfo.invisibleCheck = true;
	targetingInfo.distCheck = true;
	targetingInfo.coneCheck = false;
	targetingInfo.rsHeadingCheck = false;
	targetingInfo.navMeshCheck = false;
	targetingInfo.knockDownCheck = false;
	targetingInfo.frameScaleX = softLockFrameSize;
	targetingInfo.frameScaleY = softLockFrameSize;
	
	targetingInfo.coneDist = ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetDistanceMax', 50);
	
	if ( currentTarget && IsHardLockEnabled() && currentTarget.IsAlive() && !currentTarget.IsKnockedUnconscious() )
	{
		if ( VecDistanceSquared( playerPosition, currentTarget.GetWorldPosition() ) > ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetDistanceMax', 50) * ACS_Settings_Main_Float('EHmodTargetSettings','EHmodTargetDistanceMax', 50) )
		{
			HardLockToTarget( false );
		}
		else
		{
			targetingOut.target = currentTarget;
			targetingOut.result = true;
			return;
		}
	}
	
	if ( 
	( thePlayer.HasBuff( EET_Confusion ) 
	|| thePlayer.HasBuff( EET_Hypnotized ) 
	|| thePlayer.HasBuff( EET_Blindness ) 
	|| thePlayer.HasBuff( EET_WraithBlindness ) ) 
	|| !bCanFindTarget 
	)
		return;
	
	if ( this.playerAiming.GetCurrentStateName() == 'Aiming' )
	{
		newTarget = this.playerAiming.GetAimedTarget();
		
		if ( newTarget )
		{
			targetingOut.target = newTarget;
			targetingOut.result = true;
			targetingOut.confirmNewTarget = true;
			return;
		}
	}

	GetVisibleEnemies( targets );
	
	for ( i = 0; i < finishableEnemiesList.Size(); i += 1 )
	{
		if ( !targets.Contains( finishableEnemiesList[i] ) )
		{
			targets.PushBack( finishableEnemiesList[i] );
		}
	}
	
	precull = targets.Size();
	
	for ( i = targets.Size() - 1; i >= 0; i -= 1 )
	{
		targetingInfo.targetEntity = targets[i];
		
		if ( IsSwimming() && !CanBeTargetedIfSwimming( targets[i], false ) )
			targets.EraseFast( i );
		else if ( !IsThreat( targets[i], false ) )
		{
			potentialFriendlyTargets.PushBack( targets[i] );
			targets.EraseFast( i );
		}
		else if ( !IsEntityTargetable( targetingInfo, false ) )
			targets.EraseFast( i );
	}
	
	bestRank = 0.0f;
	curTargetRank = -100.0f;
	newTarget = currentTarget;
	
	if ( targets.Size() > 0 )
	{
		if ( !IsThreat( currentTarget, false ) )
		{
			currentTarget = NULL;
		}
		for ( i = 0; i < targets.Size(); i += 1 )
		{
			inverseDist = 1 - ClampF( Distance2DBetweenCapsules( this, targets[i] ) / targetingInfo.coneDist, 0, 1 );
		
			rank = inverseDist * distanceWeight;
		
			targetHeadingVector = VecNormalize(targets[i].GetWorldPosition() - playerPosition);
			
			cameraAngleDiff = AbsF( Rad2Deg( AcosF( VecDot2D( VecFromHeading(theGame.GetGameCamera().GetHeading()), targetHeadingVector ) ) ) );
			facingAngleDiff = AbsF( Rad2Deg( AcosF( VecDot2D( GetHeadingVector(), targetHeadingVector ) ) ) );
			
			rank += ((180.0f - cameraAngleDiff) / 180.0f) * cameraWeight;
			rank += ((180.0f - facingAngleDiff) / 180.0f) * facingWeight;
			
			if ( lastAxisInputIsMovement )
			{
				movementAngleDiff = AbsF( Rad2Deg( AcosF( VecDot2D( VecFromHeading(cachedRawPlayerHeading), targetHeadingVector ) ) ) );
				rank += ((180.0f - movementAngleDiff) / 180.0f) * movementWeight;
			}
			
			if ( targets[i] == currentTarget )
			{
				if ( IsInCombatAction_Attack() )
					targetHysteresis *= attackHysModifier;
				rank *= targetHysteresis;
				curTargetRank = rank;
			}
				
			if ( rank > bestRank )
			{
				newTarget = targets[i];
				bestRank = rank;
			}
		}

		if ( newTarget )
		{
			targetingOut.result = true;
			targetingOut.target = newTarget;
			
			if ( !currentTarget || (currentTarget && newTarget != currentTarget) )
			{
				targetingOut.confirmNewTarget = true;
			}
		}
	}
	else
	{
		targetingOut.target = NULL;
		
		if ( potentialFriendlyTargets.Size() > 0 && GetEquippedSign() == ST_Axii )
		{
			for ( i = potentialFriendlyTargets.Size() - 1; i >= 0; i -= 1 )
			{
				if ( potentialFriendlyTargets[i].HasTag( theGame.params.TAG_AXIIABLE_LOWER_CASE ) || potentialFriendlyTargets[i].HasTag( theGame.params.TAG_AXIIABLE ) )
					targetingOut.target = potentialFriendlyTargets[i];
			}
		}
		
		targetingOut.result = true;
		targetingOut.confirmNewTarget = true;
	}
}

@wrapMethod( CR4Player ) function LockToTarget( flag : bool )
{
	if (false)
	{
		wrappedMethod( flag );
	}

	if ( IsHardLockEnabled() && !flag )
		return;
		
	if (ACS_Settings_Main_Bool('EHmodTargetSettings','EHmodDisableCameraLock', true))
	{
		if (IsCameraLockedToTarget())
			LockCameraToTarget( false );
	}
	else
	{
		LockCameraToTarget( flag );
	}

	LockActorToTarget( flag );
}

//////////////////////////////////////

@wrapMethod(CR4Player) function CanSprint( speed : float ) : bool
{
	if(false) 
	{
		wrappedMethod(speed);
	}
	
	if( speed <= 0.8f )
	{
		return false;
	}
	
	if ( thePlayer.GetIsSprintToggled() )
	{
	}
	
	else if(GetLeftStickSprint() && theInput.LastUsedGamepad())
	{		
		if(GetIsSprintToggled() && GetIsSprinting())
		{
		}
		else if(!GetIsSprintToggled())
			return false;
	}
	
	else if ( !sprintActionPressed )
	{
		return false;
	}
	else if( !theInput.IsActionPressed('Sprint') || ( theInput.LastUsedGamepad() && IsInsideInteraction() && GetHowLongSprintButtonWasPressed() < 0.12 ) )
	{
		return false;
	}
	
	if ( thePlayer.HasBuff( EET_OverEncumbered ) )
	{
		return false;
	}
	
	if ( !IsSwimming() )
	{
		if ( ShouldUseStaminaWhileSprinting() && !GetIsSprinting() && !IsInCombat() && GetStat(BCS_Stamina) <= 0 )
		{
			return false;
		}

		if( ( !IsCombatMusicEnabled() || IsInFistFightMiniGame() ) && ( !IsActionAllowed(EIAB_RunAndSprint) || !IsActionAllowed(EIAB_Sprint) )  )
		{
			return false;
		}

		if( IsInCombatAction() )
		{
			return false;
		}

		if( IsInAir() )
		{
			return false;
		}
	}
	
	return true;
}

@wrapMethod(Swimming) function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
	if(false) 
	{
		wrappedMethod(moveData, dt);
	}

	if( super.OnGameCameraTick( moveData, dt ) )
	{
		return true;
	}

	return false;
}

@wrapMethod(Swimming) function OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
{
	var cameraRotation : EulerAngles;
	var cameraPosition : Vector;
	var waterLevel : float;
	var diff : float;
	var divePitch : float;
	var angleDistBetweenPlayerAndCamera : float;
	var playerToTargetVector : Vector;
	var playerToTargetAngles : EulerAngles;
	var playerToTargetPitch : float;

	if(false) 
	{
		wrappedMethod(moveData, dt);
	}
	
	
	lerpAmount += dt/2;
	lerpAmount = ClampF(lerpAmount,0,1);
	
	
	cameraPosition = theCamera.GetCameraPosition();
	waterLevel = theGame.GetWorld().GetWaterLevel(cameraPosition, true);
	diff = cameraPosition.Z - waterLevel;
	
	
	UpdateDivingPitch();
	
	if ( cameraIsUnderwater && diff >= 0 )
	{
		parent.PlayEffect('water_effect_surfacing');
		cameraIsUnderwater = false;
		theSound.SoundEvent("fx_underwater_off");
	}
	else if ( !cameraIsUnderwater && diff < 0 )
	{
		cameraIsUnderwater = true;
		theSound.SoundEvent("fx_underwater_on");
	}
	
	
	{
		cameraRotation = theCamera.GetCameraRotation();
		cameraPitch = AngleNormalize180(cameraRotation.Pitch);
		
		angleDistBetweenPlayerAndCamera = AbsF(AngleDistance(parent.GetHeading(),VecHeading(theCamera.GetCameraDirection())));
		
		if ( ( cameraPitch < 0 && !OnAllowedDiveDown() ) || angleDistBetweenPlayerAndCamera > 135 )
			parent.SetBehaviorVariable( 'cameraPitch', 0.f);
		else
			parent.SetBehaviorVariable( 'cameraPitch', cameraPitch);
	}
	
	
	
	
	
	if ( parent.IsCameraLockedToTarget() )
	{
		playerToTargetVector = parent.GetDisplayTarget().GetWorldPosition() - parent.GetWorldPosition();
		
		moveData.pivotRotationController.SetDesiredHeading( VecHeading( playerToTargetVector ), 0.5f );
		
		playerToTargetAngles = VecToRotation( playerToTargetVector );
		playerToTargetPitch = playerToTargetAngles.Pitch + 10;
		moveData.pivotRotationController.SetDesiredPitch( playerToTargetPitch * -1, 0.5f );
	}
	else if ( moveData.pivotRotationController.controllerName == 'Diving' )
	{
		divePitch = parent.GetBehaviorVariable('divePitch');
		
		if ( divePitch <= -1.f )
		{
			moveData.pivotRotationController.SetDesiredPitch(-89.f);
			moveData.pivotRotationController.minPitch = -80.f;
			moveData.pivotRotationController.maxPitch = -60.f;
		}
		else if ( divePitch >= 1.f )
		{ 
			moveData.pivotRotationController.SetDesiredPitch(89.f);
			moveData.pivotRotationController.maxPitch = 80.f;
			moveData.pivotRotationController.minPitch = 60.f;
		}
		else
		{
			if ( !thePlayer.GetIsSprinting() )
				moveData.pivotRotationController.SetDesiredPitch(0.0);
				
			if ( isCiri )
			{
				moveData.pivotRotationController.minPitch = -45.f;
				moveData.pivotRotationController.maxPitch = 45.f;
			}
			else
			{
				moveData.pivotRotationController.minPitch = -70.f;
				moveData.pivotRotationController.maxPitch = 70.f;
			}
		}
		
		
	}
	else if ( divingEnd )
	{
		
		moveData.pivotRotationController.SetDesiredPitch(-10.0, 3.f);
		theGame.GetGameCamera().ForceManualControlHorTimeout();
	}
	else if ( moveData.pivotRotationController.controllerName == 'Swimming' )
	{
		moveData.pivotRotationController.SetDesiredPitch(-10.0);
	}
	
	if ( moveData.pivotPositionController.controllerName == 'Diving' )
	{
		if ( parent.rawPlayerSpeed == 0 )
		{
			moveData.pivotPositionController.offsetZ = 1.75f;
		}
		else
		{
			moveData.pivotPositionController.offsetZ = 1.15f;
		}
	}
	
	else if ( moveData.pivotDistanceController.controllerName == 'Diving' )
	{
		if ( cameraPitch < 0 && diff >= -0.25 )
		{
			moveData.pivotDistanceController.SetDesiredDistance(0);
		}
		else if ( parent.rawPlayerSpeed == 0 )
		{
			moveData.pivotDistanceController.SetDesiredDistance(2.25);
		}
		else
		{
			moveData.pivotDistanceController.SetDesiredDistance(2.75);
		}
	}
	
	super.OnGameCameraPostTick( moveData, dt );
}
	

@wrapMethod(CR4Player) function GetCameraPadding() : float
{
	if(false) 
	{
		wrappedMethod();
	}

	return 0.02f; 
}

@wrapMethod(W3PlayerAbilityManager) function OnVitalityChanged()
{
	wrappedMethod();

	if (!thePlayer.HasTag('ACS_Vitality_Changed'))
	{
		thePlayer.AddTag('ACS_Vitality_Changed');
	}

	GetACSWatcher().RemoveTimer('Vitality_Changed_Reset');
	GetACSWatcher().AddTimer('Vitality_Changed_Reset', ACS_Settings_Main_Float('EHmodHudSettings','EHmodHudElementsDespawnDelay', 3), false);
}

@wrapMethod(W3PlayerAbilityManager) function OnToxicityChanged()
{
	wrappedMethod();

	if (!thePlayer.HasTag('ACS_Toxicity_Changed'))
	{
		thePlayer.AddTag('ACS_Toxicity_Changed');
	}

	GetACSWatcher().RemoveTimer('Toxicity_Changed_Reset');
	GetACSWatcher().AddTimer('Toxicity_Changed_Reset', ACS_Settings_Main_Float('EHmodHudSettings','EHmodHudElementsDespawnDelay', 3), false);
}

/*
@wrapMethod(W3PlayerAbilityManager) function OnFocusChanged()
{
	wrappedMethod();

	if (thePlayer.IsInCombat()
	|| thePlayer.IsThreatened())
	{
		if (!thePlayer.HasTag('ACS_Focus_Changed'))
		{
			thePlayer.AddTag('ACS_Focus_Changed');
		}

		GetACSWatcher().RemoveTimer('Focus_Changed_Reset');
		GetACSWatcher().AddTimer('Focus_Changed_Reset', ACS_Settings_Main_Float('EHmodHudSettings','EHmodHudElementsDespawnDelay', 3), false);
	}
	else
	{
		GetACSWatcher().RemoveTimer('Focus_Changed_Reset');
		GetACSWatcher().AddTimer('Focus_Changed_Reset', ACS_Settings_Main_Float('EHmodHudSettings','EHmodHudElementsDespawnDelay', 3), false);
	}
}
*/

@wrapMethod( CBehTreeCombatTargetSelectionTask ) function EvaluatePotentialTarget( target : CActor) : float
{	
	var owner : CNewNPC = GetNPC();
	var sum : float;
	var npcTarget : CNewNPC;
	var dist : float;

	if (false)
	{
		wrappedMethod(target);
	}
	
	npcTarget = (CNewNPC)target;
	
	if ( !owner.IsDangerous( target ) )
	{
		return 0;
	}
	
	if ( npcTarget && owner.GetAttitude( thePlayer ) != npcTarget.GetAttitude( thePlayer ) )
	{
		sum = sum + 10.0;
	}
	
	if( target == GetCombatTarget() && target.IsAlive() )
	{
		sum = sum + 50.0;
	}
	
	if( target == owner.lastAttacker )
	{
		sum = sum + 100.0;
	}	
	
	dist = VecDistance2D( owner.GetWorldPosition(), target.GetWorldPosition() );
	sum = sum + 1000.0 * (1.0 - (dist / maxTargetDistance));
	
	return sum;		
}
	

@wrapMethod( CBehTreeCombatTargetSelectionTask ) function FindTarget() : bool
{
	var score : float;
	var maxScore : float;
	var bestTarget : CActor;
	var newTarget : CActor;
	var index : int;
	var owner : CNewNPC = GetNPC();

	if (false)
	{
		wrappedMethod();
	}

	maxScore = 0;
	index = 0;
	newTarget = owner.GetNoticedObject( index );
	while( newTarget )
	{		
		if(newTarget.IsAlive())
		{
			score = EvaluatePotentialTarget( newTarget );
		
			if( score > maxScore )
			{
				maxScore = score;
				bestTarget = newTarget;
			}
		}
	
		index = index + 1;
		newTarget = owner.GetNoticedObject( index );
	}
	
	owner.lastAttacker = NULL;
	
	if( bestTarget != GetCombatTarget() )
	{
		nextTarget = bestTarget;
		
		return true;
	}
	
	return false;
}


@wrapMethod( CR4Player ) function IsInShallowWater() : bool
{
	if (false)
	{
		wrappedMethod();
	}

	return false;
}

@wrapMethod( CR4Player ) function OnEnterShallowWater()
{
	if (false)
	{
		wrappedMethod();
	}
	
	if ( isInShallowWater )
		return false;
	
	isInShallowWater = true;
	
	SetBehaviorVariable( 'shallowWater',1.0);
}

@wrapMethod( CR4Game ) function OnGiveReward( target : CEntity, rewardName : name, rewrd : SReward )
{
	var i 						: int;
	var itemCount				: int;
	var gameplayEntity 			: CGameplayEntity;
	var inv		 				: CInventoryComponent;
	var goldMultiplier			: float;
	var itemMultiplier			: float;
	var itemsCount				: int;
	var ids						: array<SItemUniqueId>;
	var itemCategory 			: name;
	var lvlDiff					: int;
	var moneyWon				: int;
	var expModifier				: float;
	var difficultyMode			: EDifficultyMode;
	var rewardNameS				: string;
	var ep1Content				: bool;
	var rewardMultData			: SRewardMultiplier;

	if (false)
	{
		wrappedMethod(target, rewardName, rewrd);
	}
	
	if ( target == thePlayer )
	{
		
		if ( rewrd.experience > 0 && GetWitcherPlayer())
		{
			expModifier = 1.0;

			GetWitcherPlayer().AddPoints( EExperiencePoint, RoundF( rewrd.experience * expGlobalMod_quests * expModifier), true);
		}
		
		if ( rewrd.achievement > 0 )
		{
			theGame.GetGamerProfile().AddAchievement( rewrd.achievement );
		}
	}
	
	gameplayEntity = (CGameplayEntity)target;
	if ( gameplayEntity )
	{
		inv = gameplayEntity.GetInventory();
		if ( inv )
		{
			rewardMultData = thePlayer.GetRewardMultiplierData( rewardName );
			
			if( rewardMultData.isItemMultiplier )
			{
				goldMultiplier = 1.0;
				itemMultiplier = rewardMultData.rewardMultiplier;
			}
			else
			{
				goldMultiplier = rewardMultData.rewardMultiplier;
				itemMultiplier = 1.0;
			}
			
			
			if ( rewrd.gold > 0 )
			{
				inv.AddMoney( (int)(rewrd.gold * goldMultiplier) );
				thePlayer.RemoveRewardMultiplier(rewardName);		
				if( target == thePlayer )
				{
					moneyWon = (int)(rewrd.gold * goldMultiplier);
					
					if ( moneyWon > 0 )
						thePlayer.DisplayItemRewardNotification('Crowns', moneyWon );
				}
			}
			
			
			
			for ( i = 0; i < rewrd.items.Size(); i += 1 )
			{
				itemsCount = RoundF( rewrd.items[ i ].amount * itemMultiplier );
				
				if( itemsCount > 0 )
				{
					ids = inv.AddAnItem( rewrd.items[ i ].item, itemsCount );
					
					for ( itemCount = 0; itemCount < ids.Size(); itemCount += 1 )
					{
						
						if ( inv.ItemHasTag( ids[i], 'Autogen' ) && GetWitcherPlayer().GetLevel() - 1 > 1 )
						{ 
							inv.GenerateItemLevel( ids[i], true );
						}
					}
					
					itemCategory = inv.GetItemCategory( ids[0] );
					if ( itemCategory == 'alchemy_recipe' ||  itemCategory == 'crafting_schematic' )
					{
						inv.ReadSchematicsAndRecipes( ids[0] );
					}						
					
					if(target == thePlayer)
					{
						
						if( !inv.ItemHasTag( ids[0], 'GwintCard') )
						{
							thePlayer.DisplayItemRewardNotification(rewrd.items[ i ].item, RoundF( rewrd.items[ i ].amount * itemMultiplier ) );
						}
					}
				}
			}
		}
	}
}

@wrapMethod( W3SettlementTrigger ) function OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
{
	var veh : CNewNPC;

	if (false)
	{
		wrappedMethod(area, activator);
	}

	if( activator.GetEntity() != thePlayer )
	{
		return false;
	}
	
	thePlayer.EnterSettlement( true );
	
	if(IsNameValid(settlementName))
	{
		theGame.UpdateRichPresence(settlementName);
	}
	else if(IsNameValid(hubNameOverride))
	{
		theGame.UpdateRichPresence(hubNameOverride);
	}

	if ( bDisplaySettlementInfo )
	{
		DisplayAreaInfo();
	}

	ActivateJournalEntry();
}

@wrapMethod( W3PlayerWitcher ) function OnSpawned( spawnData : SEntitySpawnData )
{
	wrappedMethod(spawnData);

	if( spawnData.restored )
	{
		AddTimer('ACS_DelayedLevelUpEquipped', 0.1, false);
	}
}

@wrapMethod( W3ReplacerCiri ) function OnSpawned( spawnData : SEntitySpawnData )
{
	var hud 															: CR4ScriptedHud;
	var moduleMinimap, moduleQuest 										: CR4HudModuleBase;

	wrappedMethod(spawnData);

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'Minimap2Module', "true");

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'QuestsModule', "true");

	hud = (CR4ScriptedHud)theGame.GetHud();

	moduleMinimap = (CR4HudModuleBase)hud.GetHudModule("Minimap2Module");

	moduleMinimap.SetEnabled(true);

	moduleQuest = (CR4HudModuleBase)hud.GetHudModule("QuestsModule");

	moduleQuest.SetEnabled(true);

	hud.UpdateHUD();

	thePlayer.inv.AddAnItem('Wolfsbane', 12);

	thePlayer.inv.AddAnItem('Fools parsley leaves', 12);
}

@addMethod( W3PlayerWitcher ) timer function ACS_DelayedLevelUpEquipped( dt : float, id : int )
{
	ACS_LevelUpEquipped();
}

@wrapMethod( W3PlayerWitcher ) function EquipItemInGivenSlot(item : SItemUniqueId, slot : EEquipmentSlots, ignoreMounting : bool, optional toHand : bool) : bool
{
	wrappedMethod(item, slot, ignoreMounting, toHand);

	ACS_LevelUpEquipped();

	if(slot == EES_SilverSword || slot == EES_SteelSword)
	{
		if ( FactsQuerySum("ACS_Dummy_Swords_Enabled") > 0 )
		{
			FactsRemove("ACS_Dummy_Swords_Enabled");
		}

		if (ACSGetCEntity('ACS_SwordOnHip_Dummy_Attachment'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Dummy_Attachment').Destroy();
		}

		if (ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').Destroy();
		}
		
		if (ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').Destroy();
		}

		if (ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').Destroy();
		}
		
		if (ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').Destroy();
		}

		if ( FactsQuerySum("ACS_Dummy_Swords_Enabled") > 0 )
		{
			FactsRemove("ACS_Dummy_Swords_Enabled");
		}
	}

	return true;
}

@wrapMethod( W3PlayerWitcher ) function UnequipItemFromSlot(slot : EEquipmentSlots, optional reequipped : bool) : bool
{
	wrappedMethod(slot, reequipped);

	if(slot == EES_SilverSword || slot == EES_SteelSword)
	{
		if ( FactsQuerySum("ACS_Dummy_Swords_Enabled") > 0 )
		{
			FactsRemove("ACS_Dummy_Swords_Enabled");
		}

		if (ACSGetCEntity('ACS_SwordOnHip_Dummy_Attachment'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Dummy_Attachment').Destroy();
		}

		if (ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Steel_Sword_Dummy').Destroy();
		}
		
		if (ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Steel_Scabbard_Dummy').Destroy();
		}

		if (ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Silver_Sword_Dummy').Destroy();
		}
		
		if (ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy'))
		{
			ACSGetCEntity('ACS_SwordOnHip_Silver_Scabbard_Dummy').Destroy();
		}

		if ( FactsQuerySum("ACS_Dummy_Swords_Enabled") > 0 )
		{
			FactsRemove("ACS_Dummy_Swords_Enabled");
		}
	}

	return true;
}

@wrapMethod( W3PlayerWitcher ) function OnLevelGained(currentLevel : int, show : bool)
{
	ACS_LevelUpEquipped();

	wrappedMethod(currentLevel, show);
}

function ACS_LevelUpEquipped()
{
	var inventory : CInventoryComponent;
	var item : SItemUniqueId;
	var playerLevel, itemLevel, levelDiff, i, k : int;
	var slots : array<EEquipmentSlots>;
	
	if( !GetWitcherPlayer() )
	{
		return;
	}

	if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodDisableItemAutoscale', false))
	{
		return;
	}
	
	inventory = GetWitcherPlayer().inv;
	playerLevel = GetWitcherPlayer().GetLevel();
	
	slots.PushBack(EES_SteelSword);
	slots.PushBack(EES_SilverSword);
	slots.PushBack(EES_Armor);
	slots.PushBack(EES_Gloves);
	slots.PushBack(EES_Pants);
	slots.PushBack(EES_Boots);
	
	for( k = 0; k < slots.Size(); k += 1 )
	{
		if( inventory.GetItemEquippedOnSlot(slots[k], item) )
		{
			itemLevel = inventory.GetItemLevel(item);
			levelDiff = playerLevel - itemLevel;
			for( i = 0; i < levelDiff; i += 1 )
			{
				ACS_LevelUpItem(item, inventory);
			}
		}
	}
}

function ACS_LevelUpItem(item : SItemUniqueId, inventory : CInventoryComponent)
{
	var dmgBoost : float;

	if( inventory.ItemHasTag( item, 'PlayerSteelWeapon' ) || inventory.GetItemCategory( item ) == 'steelsword' )
	{
		inventory.AddItemCraftedAbility(item, 'autogen_fixed_steel_dmg', true );		
	}
	else if( inventory.ItemHasTag( item, 'PlayerSilverWeapon' ) || inventory.GetItemCategory( item ) == 'silversword' )
	{
		inventory.AddItemCraftedAbility(item, 'autogen_fixed_silver_dmg', true );		
	}
	else if( inventory.GetItemCategory( item ) == 'armor' )
	{
		inventory.AddItemCraftedAbility(item, 'autogen_fixed_armor_armor', true );		
	}
	else if( inventory.GetItemCategory( item ) == 'boots' || inventory.GetItemCategory( item ) == 'pants' )
	{
		inventory.AddItemCraftedAbility(item, 'autogen_fixed_pants_armor', true ); 
	}
	else if( inventory.GetItemCategory( item ) == 'gloves' )
	{
		inventory.AddItemCraftedAbility(item, 'autogen_fixed_gloves_armor', true );
	}
}

@wrapMethod( CR4Player ) function HasRequiredLevelToEquipItem(item : SItemUniqueId) : bool
{
	if (false)
	{
		wrappedMethod(item);
	}
	
	return true;
}

@wrapMethod( W3GuiBaseInventoryComponent ) function SetInventoryFlashObjectForItem( item : SItemUniqueId, out flashObject : CScriptedFlashObject) : void
{
	var uiData : SInventoryItemUIData;
	var slotType : EEquipmentSlots;
	var curr, max : float;
	var gridSize : int;
	var equipped : int;
	var isQuest	 : bool;
	var canDrop	 : bool;
	var maxAmmo  : int;
	var charges  : string;
	var cantEquip : bool;
	var weight : float;
	var durability : float;
	var price : int;
	var colorName:name;
	var i : int;
	var highlightedItemsCount : int;
	var itemName : name;
	var quantity : int;
	var bRead : bool;
	var tmp: bool;
	var chargesCount:int;

	if (false)
	{
		wrappedMethod(item, flashObject);
	}
	
	uiData = _inv.GetInventoryItemUIData( item );
	slotType = GetItemEquippedSlot( item );
	equipped = GetCurrentSlotForItem( item );
	isQuest = _inv.ItemHasTag(item,'Quest');
	canDrop = !isQuest && !_inv.ItemHasTag(item, 'NoDrop');
		
	if( slotType == EES_Quickslot2 && !_inv.IsItemMask( item ) ) 
	{
		slotType = EES_Quickslot1;
	}
	
	if( slotType == EES_Petard2 ) 
	{
		slotType = EES_Petard1;
	}
	
	if( _inv.ItemHasTag(item, 'NoEquip') )
		slotType = EES_InvalidSlot;
	
	flashObject.SetMemberFlashInt( "id", ItemToFlashUInt(item) );
	
	if (!_inv.IsItemOil(item))
	{
		if(_inv.IsItemSingletonItem(item))
		{
			if( thePlayer.inv.SingletonItemGetMaxAmmo(item) > 0 )
			{
				chargesCount = thePlayer.inv.SingletonItemGetAmmo(item);
				
				if( chargesCount <= 0 )
				{
					charges = "<font color=\"#CC0000\">" +  chargesCount + " " +"</font>";
				}
				else
				{
					charges = "<font color=\"#DEDEDE\">" +  chargesCount +  " " +"</font>";
				}
			}
			else
			{
				charges = "";
			}
			
			flashObject.SetMemberFlashString( "charges",  charges);
			flashObject.SetMemberFlashInt( "quantity", quantity);
		}
		else
		{
			quantity = _inv.GetItemQuantity(item);
			flashObject.SetMemberFlashInt( "quantity", quantity);
		}
	}
	
	itemName = _inv.GetItemName(item); 
	
	highlightedItemsCount = highlightedItems.Size();
	if (highlightedItemsCount > 0)
	{
		itemName = _inv.GetItemName(item);
		
		for (i = 0; i < highlightedItemsCount; i += 1)
		{
			if (highlightedItems[i] == itemName)
			{
				flashObject.SetMemberFlashBool( "highlighted", true );
			}
		}
	}		
	
	if( _inv.ItemHasTag( item, 'ReadableItem' ) && !isItemSchematic( item ) )
	{
		bRead = _inv.IsBookRead(item);
		
		flashObject.SetMemberFlashBool( "isReaded", bRead );
	}
	
	durability = _inv.GetItemDurability(item) / _inv.GetItemMaxDurability(item);
	weight = _inv.GetItemEncumbrance( item );
	price = _inv.GetItemQuantity(item) * _inv.GetItemPrice(item);
	flashObject.SetMemberFlashNumber("durability", durability); 
	flashObject.SetMemberFlashNumber("weight", weight); 
	flashObject.SetMemberFlashInt( "price", price); 
	flashObject.SetMemberFlashString( "iconPath",  _inv.GetItemIconPathByUniqueID(item) );
	if (GridPositionEnabled())
	{
		flashObject.SetMemberFlashInt( "gridPosition", uiData.gridPosition );
	}
	else
	{
		flashObject.SetMemberFlashInt( "gridPosition", -1 );
	}
	gridSize =  Clamp( uiData.gridSize, 1, 2 ); 
	
	if( _inv.IsItemColored( item ) )
	{
		colorName = _inv.GetItemColor( item );
		flashObject.SetMemberFlashString( "itemColor", NameToString( colorName ) );
	}
	
	flashObject.SetMemberFlashInt( "gridSize", gridSize );
	flashObject.SetMemberFlashInt( "slotType", slotType );
	flashObject.SetMemberFlashBool( "isNew", uiData.isNew );
	
	if( autoCleanNewMark && uiData.isNew )
	{
		uiData.isNew = false;
		_inv.SetInventoryItemUIData( item, uiData );
	}
	
	flashObject.SetMemberFlashBool( "isOilApplied", _inv.ItemHasAnyActiveOilApplied(item) && !_inv.IsItemOil( item ) );
	flashObject.SetMemberFlashInt( "equipped", equipped );
	
	flashObject.SetMemberFlashInt( "quality", _inv.GetItemQuality( item ) );
	flashObject.SetMemberFlashInt( "socketsCount", _inv.GetItemEnhancementSlotsCount( item ) );
	flashObject.SetMemberFlashInt( "socketsUsedCount", _inv.GetItemEnhancementCount( item ) );
	flashObject.SetMemberFlashInt( "groupId", -1);
	
	
	flashObject.SetMemberFlashBool( "isSilverOil", _inv.ItemHasTag(item, 'SilverOil') );
	flashObject.SetMemberFlashBool( "isSteelOil", _inv.ItemHasTag(item, 'SteelOil') );
	flashObject.SetMemberFlashBool( "isArmorUpgrade", _inv.ItemHasTag(item, 'ArmorUpgrade') );
	flashObject.SetMemberFlashBool( "isWeaponUpgrade",  _inv.ItemHasTag(item, 'WeaponUpgrade') );
	flashObject.SetMemberFlashBool( "isArmorRepairKit", _inv.ItemHasTag(item, 'ArmorReapairKit') );
	flashObject.SetMemberFlashBool( "isWeaponRepairKit", _inv.ItemHasTag(item, 'WeaponReapairKit') );
	flashObject.SetMemberFlashBool( "isDye", _inv.IsItemDye( item ) );
	flashObject.SetMemberFlashBool( "isMask", _inv.IsItemMask( item ) ); 
	
	
	flashObject.SetMemberFlashBool( "canBeDyed", !_inv.ItemHasTag(item, 'noDye') );
	
	flashObject.SetMemberFlashBool( "showExtendedTooltip", true );
	
	tmp = _inv.IsItemEnchanted(item);
	flashObject.SetMemberFlashBool( "enchanted", tmp);
	
	if( _inv.HasItemDurability(item) )
	{
		
		curr = RoundMath( _inv.GetItemDurability(item) / _inv.GetItemMaxDurability(item) * 100);
		
		
		flashObject.SetMemberFlashNumber( "durability", curr );
		
		if( curr <= ITEM_NEED_REPAIR_DISPLAY_VALUE )
		{
			flashObject.SetMemberFlashBool( "needRepair", true );
		}
		else
		{
			flashObject.SetMemberFlashBool( "needRepair", false );				
		}
	}
	else
	{
		flashObject.SetMemberFlashBool( "needRepair", false );
		flashObject.SetMemberFlashNumber( "durability", 1);
	}
	
	if( thePlayer.IsInCombatAction() && IsUnequipSwordIsAlllowed(item))
	{
		flashObject.SetMemberFlashInt( "actionType", IAT_None );	
	}
	else
	{
		flashObject.SetMemberFlashInt( "actionType", GetItemActionType( item ) );
	}

	flashObject.SetMemberFlashBool( "cantEquip", cantEquip );
	
	flashObject.SetMemberFlashString( "category", _inv.GetItemCategory(item) );
}

@wrapMethod( CR4RecapMoviesMenu ) function SetupMoviesData() 
{
	var movieData : SMovieData;

	if (false)
	{
		wrappedMethod();
	}
	
	m_MovieData.Clear();
	
	movieData.movieName = "";
	
	movieData.isSkipable = !theGame.ShouldForceInstallVideo();
	
	movieData.showLogo = false;
	m_MovieData.PushBack(movieData);	
}

@wrapMethod( CR4StartupMoviesMenu ) function SetupMoviesData() 
{
	var movieData : SMovieData;

	if (false)
	{
		wrappedMethod();
	}

	m_MovieData.Clear();
	
	if( theGame.GetPlatform() == Platform_PC ) 
	{
		movieData.movieName = "";
		movieData.isSkipable = true;
		movieData.showLogo = false;
		m_MovieData.PushBack(movieData);
	}
}

@wrapMethod( CR4Player ) function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
	var targetRotation	: EulerAngles;
	var dist : float;

	if (false)
	{
		wrappedMethod(moveData, dt);
	}

	if( thePlayer.IsInCombat() )
	{
		dist = VecDistance2D( thePlayer.GetWorldPosition(), thePlayer.GetTarget().GetWorldPosition() );
		thePlayer.GetVisualDebug().AddText( 'dbg', dist, thePlayer.GetWorldPosition() + Vector( 0.f,0.f,2.f ), true, , Color( 0, 255, 0 ) );
	}
	
	if ( isStartingFistFightMinigame )
	{
		moveData.pivotRotationValue = fistFightTeleportNode.GetWorldRotation();
		isStartingFistFightMinigame = false;
	}
	
	if( substateManager.UpdateCameraIfNeeded( moveData, dt ) )
	{
		return true;
	}

	if( customCameraStack.Size() > 0 )
	{
	
	}

	if ( theGame.IsFocusModeActive() && theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'EnableAlternateExplorationCamera') == "1" )
	{
		SetExplCamera(false);

		moveData.pivotPositionController.SetDesiredPosition( thePlayer.GetWorldPosition() , 15.f );
		moveData.pivotDistanceController.SetDesiredDistance( 1.5f );
		moveData.pivotPositionController.offsetZ = 1.15f;

		if ( playerMoveType == PMT_Run || playerMoveType == PMT_Sprint )
		{
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.85f, 1.f, 0.35f ), 0.8f, dt );
		}
		else if ( ( playerMoveType == PMT_Walk ) || ( playerMoveType == PMT_Idle ) )
		{
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.75f, -0.4f, 0.35f ), 0.2f, dt );
		}
		else
		{
			return false;
		}

		return true;
	}

	if ( !theGame.IsFocusModeActive() && theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'EnableAlternateExplorationCamera') == "1" )
	{
		SetExplCamera(true);
	} 
	
	return false;
}

@wrapMethod( Swimming ) function OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
{
	if (false)
	{
		wrappedMethod(moveData, dt);
	}

	if( super.OnGameCameraTick( moveData, dt ) )
	{
		return true;
	}

	return false;
}

@wrapMethod( CPlayer ) function PlayerTick( deltaTime : float , id : int) 
{
	deltaTime = theTimer.timeDeltaUnscaled;

	OnPlayerTickTimer( deltaTime );

	if (false)
	{
		wrappedMethod(deltaTime, id);
	}

    if (!inputHandler.ACS_IsSprintingActionAllowed(EIAB_RunAndSprint)) 
	{
        movementLockType = PMLT_NoRun;
    } 
	else if (!inputHandler.ACS_IsSprintingActionAllowed( EIAB_Sprint)) 
	{
        movementLockType = PMLT_NoSprint;
    } 
	else 
	{
        movementLockType = PMLT_Free;
    }
}

@wrapMethod( CPlayerInput ) function IsActionAllowed(action : EInputActionBlock) : bool 
{
	var actionAllowed : bool;

	if (false)
	{
		wrappedMethod(action);
	}

    if (ACS_ActionLock_ShouldIgnore(action, actionLocks[action]))
	{
		return true;
	}
	
    actionAllowed = (actionLocks[action].Size() == 0);
		
	return actionAllowed;
}

@addMethod( CPlayerInput ) function ACS_IsSprintingActionAllowed(action: EInputActionBlock): bool 
{ 
    return actionLocks[action].Size() == 0;
}

function ACS_ActionLock_ShouldIgnore(action: EInputActionBlock, locks: array<SInputActionLock>): bool 
{
    var i: int;

    if (action != EIAB_Sprint && action != EIAB_RunAndSprint) 
	{
		return false;
	}

    for (i = 0; i < locks.Size(); i += 1) 
	{
        if (!locks[i].isFromQuest && !locks[i].isFromPlace) 
		{
			return false;
		}
		
        if (action == EIAB_RunAndSprint && locks[i].sourceName == 'q705_prison') 
		{
			return false;
		}
		
        if (action == EIAB_RunAndSprint && locks[i].sourceName == 'q704_fight_for_life') 
		{
			return false;
		}
    }

    return true;
}

@replaceMethod function ShowUsableItemLQuest()
{ 
	if (thePlayer.inv.GetItemName(thePlayer.GetSelectedItemId()) == 'Torch') 
	{
		return;
	}

	thePlayer.OnUseSelectedItem();
}

@replaceMethod function EquipItemQuest( targetTag : name, itemName : name, itemCategory : name, itemTag : name, optional unequip : bool, optional toHand : bool )
{
	var actors : array<CActor>;
	var target : CActor;
	var inv : CInventoryComponent;
	var ids : array<SItemUniqueId>;
	var a, i,idx : int;
	var playerWitcher : W3PlayerWitcher; 

	if (targetTag == 'PLAYER' && itemName == 'Torch') 
	{
		return;
	}
	
	if(targetTag == 'PLAYER')
	{
		actors.PushBack(thePlayer);
	}
	else
	{
		theGame.GetActorsByTag(targetTag, actors);
		if(actors.Size() <= 0)
		{
			LogQuest("EquipItemQuest: cannot find actor with tag <<" + targetTag + ">>");
			return;
		}
	}
	
	for(a=0; a<actors.Size(); a+=1)
	{
		target = actors[a];

		inv = target.GetInventory();		
		if( inv )
		{
			
			if(IsNameValid(itemName))
			{
				ids = inv.GetItemsIds(itemName);
			}
			else if(IsNameValid(itemCategory))
			{
				ids = inv.GetItemsByCategory(itemCategory);
			}
			else if(IsNameValid(itemTag))
			{
				ids = inv.GetItemsByTag(itemTag);
			}
			
			if(ids.Size() <= 0)			
			{
				LogQuest("EquipItemQuest: cannot (un)equip item <<" + itemName + ">> on <<" + target + ">>, target does not have this item");
				return;
			}			
			for(i=0; i<ids.Size(); i+=1)
			{
				if(inv.GetItemName(ids[i]) == itemName)
				{
					idx = i;
					break;
				}
			}
		
			
			if(unequip)
			{
				target.UnequipItem(ids[idx]);
			}
			else
			{
				playerWitcher = (W3PlayerWitcher)target;
				
				if( toHand && !inv.IsItemHeld(ids[idx]) )
				{
					if ( playerWitcher )
					{
						if (!playerWitcher.IsItemEquippedByName ( itemName))
						{
							target.EquipItem(ids[idx], EES_InvalidSlot, true);
						}
					}
					else
					{
						target.EquipItem(ids[idx], EES_InvalidSlot, true);
					}
				}
				else if ( !toHand && !inv.IsItemMounted( ids[idx] ) )
				{
					if ( playerWitcher )
					{
						if (!playerWitcher.IsItemEquippedByName ( itemName))
						{
							target.EquipItem( ids[idx] );
						}
					}
					else
					{					
						target.EquipItem( ids[idx] );
					}
				}
			}			
		}
		else
		{
			LogQuest("EquipItemQuest: target actor <<" + target + ">> has no inventory component, cannot equip/unequip items");
		}
	}
}

@wrapMethod( CBehTreeTaskCSEffect ) function KillNPCIfNeeded( owner : CNewNPC, mac : CMovingPhysicalAgentComponent ) : bool
{
	var newPosition : Vector;
	
	if (false)
	{
		wrappedMethod(owner, mac);
	}

	if ( !theGame.GetWorld().NavigationFindSafeSpot(mac.GetAgentPosition(), owner.GetRadius(), ClampF(owner.GetRadius()*pullToNavRadiusMult, 0, 2.5f), newPosition) && !CanSwimOrFly( owner, mac ))
	{
		if ( fallingDamage > 0 || maxFallingHeightDiff >= 1.3f )
		{
			owner.Kill( 'FallingDamage' );
		}
		else
		{
			if (ACS_TeleportToSafeSpotIfInWater(owner, mac)) 
			{
				return false;
			}

			owner.Kill( 'Cannot navigate' );
		}
		
		owner.SetKinematic( false );
		return true;
	}
	
	return false;
}

@addMethod( CBehTreeTaskCSEffect ) function ACS_TeleportToSafeSpotIfInWater(owner: CNewNPC, mac : CMovingPhysicalAgentComponent): bool 
{
	var i: int;
	var ok: bool;
	var newPosition: Vector;

	for (i = 1; i <= 30; i += 1) 
	{
		if (theGame.GetWorld().NavigationFindSafeSpot(mac.GetAgentPosition(), owner.GetRadius(), i, newPosition)) 
		{
			owner.Teleport(newPosition);
			return true;
		}
	}

	return false;
}

@addField(CPlayer)
var acs_yrden_ents: array<W3YrdenEntity>;

@addMethod(CPlayer) function ACS_YrdenEntsEnd(y: W3YrdenEntity) 
{ 
    var i: int; 
    for (i = acs_yrden_ents.Size()-1; i >= 0; i -= 1) 
	{ 
        if (acs_yrden_ents[i] == y) 
		{ 
            acs_yrden_ents.EraseFast(i);
            break;
        } 
    } 
} 

@addMethod( CPlayer ) function ACS_CreateYrdenTrap(y: W3YrdenEntity) 
{
    var i: int; 
    for (i = acs_yrden_ents.Size()-1; i >= 0; i -= 1) 
	{ 
        if (!acs_yrden_ents[i]) 
		{ 
            acs_yrden_ents.EraseFast(i);
        } 
    }
    acs_yrden_ents.PushBack(y);
}

@wrapMethod( W3Effect_Slowdown ) function OnEffectAdded(optional customParams : W3BuffCustomParams)
{
	var dm : CDefinitionsManagerAccessor;
	var min, max : SAbilityAttributeValue;
	var prc, pts : float;

	if (false)
	{
		wrappedMethod(customParams);
	}
	
	super.OnEffectAdded(customParams);
	
	dm = theGame.GetDefinitionsManager();
	
	dm.GetAbilityAttributeValue(abilityName, 'decay_per_sec', min, max);
	decayPerSec = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
	
	dm.GetAbilityAttributeValue(abilityName, 'decay_delay', min, max);
	decayDelay = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
	
	
	slowdown = CalculateAttributeValue(effectValue);
	target.GetResistValue(CDS_ShockRes, pts, prc);
	
	slowdownCauserId = target.SetAnimationSpeedMultiplier( 1 - slowdown );
	delayTimer = 0;
}


@addField(W3YrdenEntity)
var acs_yrden_range: float;

@wrapMethod( W3YrdenEntity ) function Place(trapPos : Vector)
{
	var trapPosTest, trapPosResult, collisionNormal, scale : Vector;
	var rot : EulerAngles;
	var witcher : W3PlayerWitcher;
	var trigger : CComponent;
	var min, max : SAbilityAttributeValue;

	if (false)
	{
		wrappedMethod(trapPos);
	}
	
	witcher = GetWitcherPlayer();
	witcher.yrdenEntities.PushBack(this);
	
	DisablePreviousYrdens();
	
	if( GetWitcherPlayer().IsSetBonusActive( EISB_Gryphon_2 ) )
	{
		theGame.GetDefinitionsManager().GetAbilityAttributeValue( 'GryphonSetBonusYrdenEffect', 'trigger_scale', min, max );
		
		trigger = GetComponent( "Slowdown" );
		scale = trigger.GetLocalScale() * min.valueAdditive;			
		
		trigger.SetScale( scale * 1.64286 );
	}
	else
	{
		trigger = GetComponent( "Slowdown" );
		scale = trigger.GetLocalScale();	

		trigger.SetScale( scale * 2 );
	}
	
	
	Detach();
	
	
	SleepOneFrame();
	
	
	trapPosTest = trapPos;
	trapPosTest.Z -= 0.5;		
	rot = GetWorldRotation();
	rot.Pitch = 0;
	rot.Roll = 0;
	
	if(theGame.GetWorld().StaticTrace(trapPos, trapPosTest, trapPosResult, collisionNormal))
	{
		trapPosResult.Z += 0.1;	
		TeleportWithRotation ( trapPosResult, rot );
	}
	else
	{
		TeleportWithRotation ( trapPos, rot );
	}
	
	
	SleepOneFrame();
	
	AddTimer('TimedCanceled', trapDuration, , , , true);

	ACS_CreateYrdenGrassDisplacement(trapPos, trapDuration);
	
	if(!notFromPlayerCast)
		owner.GetActor().OnSignCastPerformed(ST_Yrden, fireMode);
}

@addField( W3YrdenEntity )
var acs_latestRegular : bool;

@addMethod( W3YrdenEntity ) function ACS_MoveTrap()
{
	var i, size, numRunes : int;
	var witcher : W3PlayerWitcher;
	var worldRot : EulerAngles;
	var polarAngle, yrdenRange, unitAngle : float;
	var trapPos, trapPosTest, trapPosResult, collisionNormal, runePositionLocal, runePositionGlobal : Vector;
	var entity : CEntity;
	var isSetBonus2Active : bool;
	var worldPos : Vector;
	var min, max : SAbilityAttributeValue;
	var rot : EulerAngles;
	var YrdenBaseRange, YrdenGriffinRange : int;
	
	witcher = GetWitcherPlayer();
	numRunes = witcher.yrdenEntities.Size();

	if(IsAlternateCast() || this.acs_latestRegular == true)
	{
		trapPos = owner.GetActor().GetWorldPosition();
		trapPosTest = owner.GetActor().GetWorldPosition();
		trapPosTest.Z -= 0.5;		
		rot = GetWorldRotation();
		rot.Pitch = 0;
		rot.Roll = 0;
		
		if(theGame.GetWorld().StaticTrace(trapPos, trapPosTest, trapPosResult, collisionNormal))
		{
			trapPosResult.Z += 0.1;	
			TeleportWithRotation ( trapPosResult, rot );
		}
		else
		{
			TeleportWithRotation ( trapPos, rot );
		}
		
		if( IsAlternateCast() == false )
		{
			isSetBonus2Active = witcher.IsSetBonusActive( EISB_Gryphon_2 );
			worldPos = this.GetWorldPosition();
			worldRot = this.GetWorldRotation();
			yrdenRange = this.baseModeRange;
			size = this.runeTemplates.Size();
			unitAngle = 2 * Pi() / size;
			
			if( isSetBonus2Active )
			{
				theGame.GetDefinitionsManager().GetAbilityAttributeValue( 'GryphonSetBonusYrdenEffect', 'trigger_scale', min, max );
				yrdenRange *= min.valueAdditive;
				yrdenRange = yrdenRange * 1.64286;
			}
			else
			{
				yrdenRange = yrdenRange * 2;
			}
			
			for ( i = 0 ; i < size ; i+=1 )
			{		
				polarAngle = unitAngle * i;
				
				runePositionLocal.X = yrdenRange * CosF( polarAngle );
				runePositionLocal.Y = yrdenRange * SinF( polarAngle );
				runePositionLocal.Z = 0.f;
				
				runePositionGlobal = worldPos + runePositionLocal;			
				runePositionGlobal = TraceFloor( runePositionGlobal );
				runePositionGlobal.Z += 0.05f;
				
				this.fxEntities[i].TeleportWithRotation (runePositionGlobal, worldRot);
			}
		}
	}
}

@wrapMethod( YrdenShock ) function ActivateShock()
{
	var i, size, wait : int;
	var target : CActor;
	var hitEntity : CEntity;
	var shot, validTargetsUpdated : bool;
	var YrdenMove_Logic : int;
	
	if (false)
	{
		wrappedMethod();
	}
		
	parent.Place(parent.GetWorldPosition());
	
	parent.PlayEffect( parent.effects[parent.fireMode].placeEffect );
	parent.PlayEffect( parent.effects[parent.fireMode].castEffect );
	
	SleepOneFrame();
	
	while( parent.validTargetsInArea.Size() == 0 )
	{
		parent.ACS_MoveTrap();
		SleepOneFrame();
	}
	
	while( parent.charges > 0 )
	{
		hitEntity = NULL;
		shot = false;
		size = parent.validTargetsInArea.Size();
		if ( size > 0 )
		{
			do
			{
				target = parent.validTargetsInArea[RandRange(size)];
				if(target.GetHealth() <= 0.f || target.IsInAgony() )
				{
					parent.validTargetsInArea.Remove(target);
					size -= 1;
					target = NULL;
				}
			}while(size > 0 && !target)
			
			if(target && target.GetGameplayVisibility())
			{
				shot = true;
				hitEntity = ShootTarget(target, true, 0.2f, false);
			}
		}
		
		if(hitEntity)
		{
			wait = 1;
			while (wait < 100)
			{
				wait += 1;

				if ( YrdenMove_Logic == 2 )
					parent.ACS_MoveTrap();
				
				Sleep(0.02f);
			}
		}
		else if(shot)
		{
			SleepOneFrame();
		}
		else
		{
			validTargetsUpdated = false;
			
			
			if( parent.validTargetsInArea.Size() == 0 )
			{				
				for( i=0; i<parent.allActorsInArea.Size(); i+=1 )
				{
					if( parent.IsValidTarget( parent.allActorsInArea[i] ) )
					{
						parent.validTargetsInArea.PushBack( parent.allActorsInArea[i] );
						validTargetsUpdated = true;
					}
				}
			}
			
			
			if( !validTargetsUpdated )
			{
				SleepOneFrame();
				
				if ( YrdenMove_Logic == 2 )
					parent.ACS_MoveTrap();
			}
		}
	}
	
	parent.GotoState( 'Discharged' );
}


latent function ACS_CreateYrdenGrassDisplacement(pos: Vector, dur: float)
{
	var ent 		: CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
	"dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent"
	, true ), ACSFixZAxis( pos ), thePlayer.GetWorldRotation() );

	ent.DestroyAfter(dur);
}

@wrapMethod( W3YrdenEntity ) function TimedCanceled( delta : float , id : int)
{
	var i : int;
	var areas : array<CComponent>;

	if (false)
	{
		wrappedMethod(delta, id);
	}
	
	isPlayerInside = false;

	thePlayer.ACS_YrdenEntsEnd(this);
	
	super.CleanUp();
	StopAllEffects();
	
	
	areas = GetComponentsByClassName('CTriggerAreaComponent');
	for(i=0; i<areas.Size(); i+=1)
		areas[i].SetEnabled(false);
	
	for(i=0; i<validTargetsInArea.Size(); i+=1)
	{
		validTargetsInArea[i].BlockAbility('Flying', false);
	}
	
	for( i=0; i<fxEntities.Size(); i+=1 )
	{
		fxEntities[i].StopAllEffects();
		fxEntities[i].DestroyAfter( 5.f );
	}
	
	UpdateGryphonSetBonusYrdenBuff();
	ClearActorsInArea();
	DestroyAfter(3);
}

@wrapMethod( YrdenSlowdown ) function CreateTrap()
{
	var i, size : int;
	var worldPos : Vector;
	var isSetBonus2Active : bool;
	var worldRot : EulerAngles;
	var polarAngle, yrdenRange, unitAngle : float;
	var runePositionLocal, runePositionGlobal : Vector;
	var entity : CEntity;
	var min, max : SAbilityAttributeValue;

	if (false)
	{
		wrappedMethod();
	}

	isSetBonus2Active = GetWitcherPlayer().IsSetBonusActive( EISB_Gryphon_2 );
	worldPos = virtual_parent.GetWorldPosition();
	worldRot = virtual_parent.GetWorldRotation();
	yrdenRange = virtual_parent.baseModeRange;
	size = virtual_parent.runeTemplates.Size();
	unitAngle = 2 * Pi() / size;
	
	if( isSetBonus2Active )
	{
		virtual_parent.PlayEffect( 'ability_gryphon_set' );
		theGame.GetDefinitionsManager().GetAbilityAttributeValue( 'GryphonSetBonusYrdenEffect', 'trigger_scale', min, max );
		yrdenRange *= min.valueAdditive;
		yrdenRange = yrdenRange * 1.64286;
	}
	else
	{
		yrdenRange = yrdenRange * 2;
	}
	
	for( i=0; i<size; i+=1 )
	{
		polarAngle = unitAngle * i;
		
		runePositionLocal.X = yrdenRange * CosF( polarAngle );
		runePositionLocal.Y = yrdenRange * SinF( polarAngle );
		runePositionLocal.Z = 0.f;
		
		runePositionGlobal = worldPos + runePositionLocal;			
		runePositionGlobal = TraceFloor( runePositionGlobal );
		runePositionGlobal.Z += 0.05f;		
		
		entity = theGame.CreateEntity( virtual_parent.runeTemplates[i], runePositionGlobal, worldRot );
		virtual_parent.fxEntities.PushBack( entity );
	}

	parent.acs_yrden_range = yrdenRange; 
	
	thePlayer.ACS_CreateYrdenTrap(parent);
}

@wrapMethod( CBTTaskTeleport ) function IsAvailable() : bool
{
	if (!GetNPC().HasAbility('mon_wraith')) 
	{
		return true;
	}

    if (GetNPC().HasBuff(EET_SilverDust)) 
	{
		return false;
	}
	
    if (ACS_NPCInYrden(GetNPC().GetWorldPosition())) 
	{
		return false;
	}

	return wrappedMethod();
}

@wrapMethod( CBTTaskTeleport ) function Main() : EBTNodeStatus
{
	var npc 				: CNewNPC = GetNPC();
	var target 				: CActor = GetCombatTarget();
	var res 				: bool;
	var ticketR 			: SMovementAdjustmentRequestTicket;
	var movementAdjustor	: CMovementAdjustor;
	var heading 			: float;

	if (false)
	{
		wrappedMethod();
	}
	
	if ( IsNameValid( activationEventName ) )
	{
		while ( !activated )
		{
			SleepOneFrame();
		}
	}
	
	if ( !performPosCheckOnTeleportEventName )
	{
		
		
		res = PosChecks( newPosition );
		
		if ( !res )
		{
			return BTNS_Failed;
		}
	}
	
	npc.SetIsTeleporting( true );
	if ( setInvulnerable )
		npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
	npc.AddBuffImmunity_AllNegative( 'teleport', true );
	
	npc.SetCanPlayHitAnim( shouldPlayHitAnim );
	
	appearFXPlayed = false;
	rotated = false;
	
	appearRaiseEventLaunched = false;
	disappearRaiseEventLaunched = false;
	
	if ( raiseEventImmediately && IsNameValid( raiseEventName ) )
	{
		if ( !npc.RaiseEvent( raiseEventName ) )
		{
			return BTNS_Failed;
		}
	}
	
	if ( delayActivation == 0 )
	{
		
		
		if ( IsNameValid( raiseEventName ) && !raiseEventImmediately )
		{
			if ( !npc.RaiseEvent( raiseEventName ) )
			{
				return BTNS_Failed;
			}
		}
		disappearRaiseEventLaunched = true;
		if ( IsNameValid( setBehVarNameOnRaiseEvent ) )
			npc.SetBehaviorVariable( setBehVarNameOnRaiseEvent, setBehVarValueOnRaiseDisappearEvent, true );
		
		if( IsNameValid( disappearfxName ))
		{
			
			npc.PlayEffect( disappearfxName );
			npc.SignalGameplayEvent( 'teleportDisappearFx' );
		}
	}
	
	
	res = false;
	isTeleporting = true;
	
	if ( disableGameplayVisibility )
	{
		npc.SetGameplayVisibility( false );
	}
	
	if ( delayActivation > 0 )
	{
		Sleep( delayActivation );
		
		if ( IsNameValid( raiseEventName ) && !raiseEventImmediately )
		{
			if ( !npc.RaiseEvent( raiseEventName ) )
			{
				return BTNS_Failed;
			}
		}
		disappearRaiseEventLaunched = true;
		if ( IsNameValid( setBehVarNameOnRaiseEvent ) )
			npc.SetBehaviorVariable( setBehVarNameOnRaiseEvent, setBehVarValueOnRaiseDisappearEvent, true );
		
		if( IsNameValid( disappearfxName ))
		{
			
			npc.PlayEffect( disappearfxName );
			npc.SignalGameplayEvent( 'teleportDisappearFx' );
			
			Sleep( 0.1f );
		}
	}
	
	if ( teleportEventName )
	{
		while ( !vanish )
		{
			SleepOneFrame();
		}
		
		if ( performPosCheckOnTeleportEventName )
		{
			res = PosChecks( newPosition );
			
			if ( !res )
			{
				return BTNS_Failed;
			}
		}
		
		if ( forceInvisible )
		{
			npc.SetVisibility( false );
		}
	}
	
	if ( delayReappearance > 0 )
	{
		if ( forceInvisible && !IsNameValid(teleportEventName) )
		{
			npc.SetVisibility( false );
		}
		
		npc.EnableCharacterCollisions( false );
		Sleep( delayReappearance );
		
		if ( performLastMomentPosCheck )
		{
			res = PosChecks( newPosition );
			
			if ( !res )
			{
				return BTNS_Failed;
			}
		}

		if (npc.HasAbility('mon_wraith')) 
		{
			ACS_NPCProcessTeleportPosition(newPosition);
		}
		
		SafeTeleport( newPosition );
		
		if( IsNameValid( appearRaiseEventName ) )
		{
			if ( !npc.RaiseEvent( appearRaiseEventName ) )
			{
				return BTNS_Failed;
			}
			appearRaiseEventLaunched = true;
			if ( IsNameValid( setBehVarNameOnRaiseEvent ) )
				npc.SetBehaviorVariable( setBehVarNameOnRaiseEvent, setBehVarValueOnRaiseAppearEvent, true );
		}
	}
	else
	{
		if ( performLastMomentPosCheck )
		{
			res = PosChecks( newPosition );
			
			if ( !res )
			{
				return BTNS_Failed;
			}
		}

		if (npc.HasAbility('mon_wraith')) 
		{
			ACS_NPCProcessTeleportPosition(newPosition); 
		}

		SafeTeleport( newPosition );
	}
	
	if( IsNameValid( appearFXName ))
	{
		appearFXPlayed = true;
		if ( stopEffectAppearFXName )
		{
			npc.StopEffect( appearFXName );
		}
		else
		{
			npc.PlayEffect( appearFXName );
		}
	}
	
	if( IsNameValid( additionalAppearFXName ))
	{
		appearFXPlayed = true;
		npc.PlayEffect( additionalAppearFXName );
	}
	
	if ( disableInvisibilityAfterReappearance )
	{
		if ( forceInvisible )
		{
			npc.SetVisibility( true );
		}
	}
	
	if ( enableCollisionAfterReappearance )
	{
		npc.EnableCharacterCollisions( true );
	}
	
	if ( disableImmortalityAfterReappearance )
	{
		if ( setInvulnerable )
			npc.SetImmortalityMode( AIM_None, AIC_Combat );
		npc.RemoveBuffImmunity_AllNegative( 'teleport' );
	}
	
	if ( slideInsteadOfTeleport && rotateToTarget )
	{
		Sleep( 0.6667 * delayReappearance );
		movementAdjustor = GetNPC().GetMovingAgentComponent().GetMovementAdjustor();
		movementAdjustor.CancelByName( 'TeleportRotate' );
		ticketR = movementAdjustor.CreateNewRequest( 'TeleportRotate' );
		
		heading = VecHeading( GetCombatTarget().GetWorldPosition() - newPosition );
		movementAdjustor.AdjustmentDuration( ticketR, 0.3333 * delayReappearance );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticketR, 9999 );
		movementAdjustor.RotateTo( ticketR, heading );
		rotated = true;
	}
	
	if( IsNameValid( appearRaiseEventName ) )
	{
		npc.WaitForBehaviorNodeDeactivation( appearRaiseEventName, 4.f );
	}
	
	nextTeleTime = GetLocalTime() + cooldown;
	alreadyTeleported = true;
	SleepOneFrame();
	
	return BTNS_Completed;
}

function ACS_NPCInYrden(pos: Vector): bool 
{
	var i: int;
	var dist: float;
	var ypos: Vector;
	var ys: array<W3YrdenEntity>;
	var y: W3YrdenEntity;

	ys = thePlayer.acs_yrden_ents;
	
	for (i = 0; i < ys.Size(); i += 1) 
	{
		y = ys[i];

		if (!y) 
		continue;

		ypos = y.GetWorldPosition();

		dist = VecDistance(ypos, pos);

		if (dist <= y.acs_yrden_range) 
		{
			return true;
		}
	}
	
	return false;
}

function ACS_NPCTeleportPosDir2D(a: Vector, b: Vector): Vector 
{
	a.Z = 0.0;
	b.Z = 0.0;
	return VecNormalize2D(b - a);
}

function ACS_NPCProcessTeleportPosition(out pos: Vector) 
{
	var ys: array<W3YrdenEntity>;
	var y: W3YrdenEntity;
	var dir: Vector;
	var chosenDir: bool;
	var ypos: Vector;
	var dist: float;
	var radius: float;
	var i: int;

	ys = thePlayer.acs_yrden_ents;

	if (ys.Size() == 0) 
	{
		return;
	}
	
	for (i = 0; i < ys.Size(); i += 1) 
	{
		y = ys[i];

		if (!y) 
		continue;

		ypos = y.GetWorldPosition();

		dist = VecDistance(ypos, pos);

		radius = y.acs_yrden_range + 1.0;
		
		if (dist <= radius) 
		{
			if (!chosenDir) 
			{
				dir = ACS_NPCTeleportPosDir2D(ypos, pos);

				chosenDir = true;
			}

			pos = ypos + dir * radius;
		}
	}

	for (i = 0; i < ys.Size(); i += 1) 
	{
		y = ys[i];

		if (!y) continue;

		ypos = y.GetWorldPosition();

		dist = VecDistance(ypos, pos);

		radius = y.acs_yrden_range + 1.0;
		
		if (dist <= radius) 
		{
			if (!chosenDir) 
			{
				dir = ACS_NPCTeleportPosDir2D(ypos, pos);

				chosenDir = true;
			}

			pos = ypos + dir * radius;
		}
	}
}

@addMethod( CBTTaskTornadoAttack ) function IsAvailable() : bool 
{ 
	if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

	return super.IsAvailable();
}

@wrapMethod( CBTTaskTornadoAttack ) function Main() : EBTNodeStatus
{
	var npc						: CNewNPC = GetNPC();
	var targetNode 				: CNode;
	var targetPos 				: Vector;
	var params 					: SCustomEffectParams;
	var action 					: W3DamageAction;
	var movementAdjustor 		: CMovementAdjustor;
	var ticket 					: SMovementAdjustmentRequestTicket;
	var attributeName 			: name;
	var victims 				: array<CGameplayEntity>;
	var actorVictims 			: CActor;
	var damage 					: float;
	var lastShakeTime 			: float;
	var lastDebuffTime 			: float;
	var lastDamageTime 			: float;
	var timeStamp 				: float;
	var lastVictimsTestTime 	: float;
	var distToTarget 			: float;
	var camShakeStrength		: float;
	var res 					: bool;
	var i 						: int;

	if (false)
	{
		wrappedMethod();
	}
	
	attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_LIGHT, theGame.params.DAMAGE_NAME_PHYSICAL);
	damage = CalculateAttributeValue( npc.GetAttributeValue( attributeName ) );
	if ( damage <= 0 )
	{
		damage = CalculateAttributeValue( npc.GetAttributeValue( 'light_attack_damage_vitality' ) );
	}
	
	damage *= damageMultiplier;
	action = new W3DamageAction in this;
	timeStamp = GetLocalTime();
	
	npc.SetBehaviorVariable( setBehVarOnDeactivation, 0 );
	res = false;
	
	if ( IsNameValid( activateOnAnimEvent ) )
	{
		while( !m_activated )
		{
			if ( timeStamp + castingLoopTime < GetLocalTime() && !res )
			{
				npc.SetBehaviorVariable( setBehVarOnDeactivation, setBehVarValueOnDeactivation );
				res = true;
			}
			SleepOneFrame();
		}
	}
	else
	{
		m_activated = true;
	}
	
	while( m_activated )
	{
		if (GetNPC().ACS_IsInDimeritiumCloud()) 
		{
			OnDeactivate();
			return BTNS_Failed;
		}

		SleepOneFrame();
		
		if ( lastShakeTime + cameraShakeInterval < GetLocalTime() )
		{
			lastShakeTime = GetLocalTime();
			targetPos = GetCombatTarget().GetWorldPosition();
			distToTarget = VecDistance2D( targetPos, npc.GetWorldPosition() );
			camShakeStrength = ClampF( 1 - ( distToTarget / cameraShakeRange ), 0, 1 ) * ((  maxCameraShakeStrength - minCameraShakeStrength ) + minCameraShakeStrength );
			GCameraShake(camShakeStrength, true, npc.GetWorldPosition(), 30.0f);
		}
		
		if ( lastVictimsTestTime + victimTestInterval < GetLocalTime() )
		{
			lastVictimsTestTime = GetLocalTime();
			victims.Clear();
			FindGameplayEntitiesInRange( victims, npc, affectEnemiesInRangeMax, 99, , FLAG_OnlyAliveActors );
		}
		
		if ( ( debuffTypeInRangeMin != EET_Undefined || debuffTypeInRangeMax != EET_Undefined ) && lastDebuffTime + debuffInterval < GetLocalTime() )
		{
			lastDebuffTime = GetLocalTime();
			
			if ( victims.Size() > 0 )
			{
				for ( i = 0 ; i < victims.Size() ; i += 1 )
				{
					actorVictims = (CActor)victims[i];
					if ( actorVictims != npc )
					{
						if ( VecDistance( actorVictims.GetWorldPosition(), npc.GetWorldPosition() ) <= affectEnemiesInRangeMin )
						{
							if ( !actorVictims.HasBuff( debuffTypeInRangeMin ) )
							{
								params.effectType = debuffTypeInRangeMin;
								if ( debuffDurationInRangeMin > 0 )
									params.duration = debuffDurationInRangeMin;
								
								if ( IsNameValid( rotateToNodeByTagOnDebuffMin ) )
								{
									movementAdjustor = actorVictims.GetMovingAgentComponent().GetMovementAdjustor();
									ticket = movementAdjustor.CreateNewRequest( 'Tornado' );
									targetNode = theGame.GetNodeByTag( rotateToNodeByTagOnDebuffMin );
									movementAdjustor.RotateTowards( ticket, targetNode, 45 );
								}
							}
						}
						else
						{
							if ( !((W3PlayerWitcher)actorVictims).IsQuenActive( true ) && !((W3PlayerWitcher)actorVictims).IsQuenActive( false ) )
							{
								params.effectType = debuffTypeInRangeMax;
								if ( debuffDurationInRangeMax > 0 )
									params.duration = debuffDurationInRangeMax;
							}
						}
						params.creator = npc;
						params.sourceName = npc.GetName();
						
						actorVictims.AddEffectCustom(params);
					}
				}
			}
		}
		
		if ( lastDamageTime + damageInterval < GetLocalTime() )
		{
			lastDamageTime = GetLocalTime();
			if ( victims.Size() > 0 )
			{
				for ( i = 0 ; i < victims.Size() ; i += 1 )
				{
					actorVictims = (CActor)victims[i];
					
					if ( victims[i] != npc && !actorVictims.IsCurrentlyDodging() )
					{
						action.Initialize( npc, actorVictims, this, npc.GetName(), EHRT_None, CPS_Undefined, false, true, false, false );
						action.SetHitAnimationPlayType(EAHA_ForceNo);
						action.attacker = npc;
						action.SetSuppressHitSounds(true);
						action.SetHitEffect( '' );
						action.SetIgnoreArmor(true);
						action.AddDamage(theGame.params.DAMAGE_NAME_PHYSICAL, damage );
						action.SetIsDoTDamage( damageInterval );
						theGame.damageMgr.ProcessAction( action );
						
						npc.SignalGameplayEventParamObject( 'DamageInstigated', action );
						
						if ( ((W3PlayerWitcher)actorVictims).IsQuenActive( false ) )
							((W3PlayerWitcher)actorVictims).FinishQuen( false );
					}
				}
			}
		}
		
		if ( timeStamp + castingLoopTime < GetLocalTime() && !res )
		{
			npc.SetBehaviorVariable( setBehVarOnDeactivation, setBehVarValueOnDeactivation );
			res = true;
		}
	}
	
	delete action;
	return BTNS_Active;
}

@addMethod(CBTTaskMagicAttack) function IsAvailable() : bool 
{ 
    if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return super.IsAvailable();
}

@wrapMethod(CBTTaskMagicMeleeAttack) function IsAvailable(): bool 
{
    if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return wrappedMethod();
}

@addMethod(CBTTaskMagicRangeAttack) function IsAvailable() : bool 
{ 
    if (GetNPC().ACS_IsInDimeritiumCloud())
	{
		return false;
	}

    return super.IsAvailable();
}

@wrapMethod(CBTTaskMagicFXAttack) function IsAvailable(): bool 
{
    if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return wrappedMethod();
}

@addMethod(CBTTaskMagicBomb) function IsAvailable() : bool 
{ 
    if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return super.IsAvailable();
}

@wrapMethod(CBTTaskProjectileAttack) function IsAvailable(): bool 
{
    if (GetNPC().HasAbility('SkillSorceress') && GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return wrappedMethod();
}

@addMethod(CBTTaskGroundTrapAttack) function IsAvailable(): bool 
{ 
    if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return super.IsAvailable();
}

@wrapMethod(CBTTaskAttack) function IsAvailable(): bool 
{
    if (ACS_ShouldBlockAttackTaskByDimeritium(attackType, GetNPC())) 
	{
		return false;
	}

    return wrappedMethod();
}

@addMethod(CBTTaskMagicCoilAttack) function IsAvailable() : bool 
{ 
    if (GetNPC().ACS_IsInDimeritiumCloud()) 
	{
		return false;
	}

    return super.IsAvailable();
}

@wrapMethod(W3Dimeritium) function ProcessMechanicalEffect(targets: array<CGameplayEntity>, isImpact: bool, optional dt: float) 
{
    var i: int;

    wrappedMethod(targets, isImpact, dt);

    for(i=0; i<targets.Size(); i+=1) 
	{
        ((CActor) targets[i]).ACS_SetInDimeritiumCloud();
    }
}

@addField(CActor)
var acs_dimeritiumTime: float;

@addField(CActor)
var acs_actionblockedbydimeritium: bool;

@addMethod(CActor) function ACS_SetInDimeritiumCloud() 
{ 
    acs_dimeritiumTime = theGame.GetEngineTimeAsSeconds(); 

    RemoveTimer('ACS_DimeritiumEnd'); 

    AddTimer('ACS_DimeritiumEnd', 0.3, false); 

    if (HasAbility('ablTeleport') && !acs_actionblockedbydimeritium) 
	{ 
        BlockAbility('ablTeleport', true); 
    } 
}

@addMethod( CActor ) function ACS_IsInDimeritiumCloud(): bool 
{ 
    return theGame.GetEngineTimeAsSeconds() - acs_dimeritiumTime < 0.2;
}

@addMethod(CActor) timer function ACS_DimeritiumEnd( deltaTime : float , id : int) 
{ 
    if (acs_actionblockedbydimeritium) 
	{ 
        BlockAbility('ablTeleport', false); 

        acs_actionblockedbydimeritium = false;
    } 
}

function ACS_ShouldBlockAttackTaskByDimeritium(attackType: EAttackType, npc: CNewNPC): bool 
{
    if (npc.ACS_IsInDimeritiumCloud()) 
	{
        if (npc.HasAbility('HaklandMage') || npc.HasAbility('ablMagic') || npc.HasTag('q206_arits')) 
		{
            switch (attackType) 
			{
                case EAT_Attack17:
                case EAT_Attack18:
                    return true;
            }
        } 
		else if (npc.HasAbility('SkillSorceress')) 
		{
            switch (attackType) 
			{
                case EAT_Attack20:
                case EAT_Attack11: 
                    return true;
            }
        }
    }

    return false;
}

@wrapMethod(W3EffectManager) function RemoveAllNonAutoEffects( optional removeOils : bool, optional skipPerk14 : bool )
{
	var autoEffects : array<name>;
	var i : int;
	var type : EEffectType;
	var tmpName : name;
	var autos : array<EEffectType>;

	if (false)
	{
		wrappedMethod(removeOils, skipPerk14);
	}		
	
	owner.GetAutoEffects(autoEffects);
	for(i=0; i<autoEffects.Size(); i+=1)		
	{
		EffectNameToType(autoEffects[i], type, tmpName);
		autos.PushBack(type);
	}
	
	
	if(!autos.Contains(EET_AutoVitalityRegen))
		autos.PushBack(EET_AutoVitalityRegen);
	if(!autos.Contains(EET_AutoStaminaRegen))
		autos.PushBack(EET_AutoStaminaRegen);
	if(!autos.Contains(EET_AutoEssenceRegen))
		autos.PushBack(EET_AutoEssenceRegen);
	if(!autos.Contains(EET_AutoMoraleRegen))
		autos.PushBack(EET_AutoMoraleRegen);
	
	
	for(i=effects.Size()-1; i>=0; i-=1)
	{
		type = effects[i].GetEffectType();
		if(!autos.Contains(type) && effects[i].IsNegative())
		{
			if( removeOils || ! ( (W3Effect_Oil)effects[i] ) )
			{
				
				if( skipPerk14 && (W3PlayerWitcher)owner && GetWitcherPlayer().CanUseSkill( S_Perk_14 ) && (W3Effect_Shrine) effects[i] )
				{
					continue;
				}
				
				RemoveEffectOnIndex( i, true );
			}
		}
	}
}

/*
@wrapMethod(CR4MapMenu) function UpdateUserMapPins( out flashArray : CScriptedFlashArray, indexToUpdate : int ) : void
{
	var manager 			: CCommonMapManager;
	var i, pinCount			: int;

	if (false)
	{
		wrappedMethod(flashArray, indexToUpdate);
	}

	if ( indexToUpdate > -1 )
	{
		UpdateUserMapPin( indexToUpdate, flashArray );
	}
	else
	{
		manager = theGame.GetCommonMapManager();
		pinCount = manager.GetUserMapPinCount();
		for ( i = 0; i < pinCount; i += 1 )
		{
			UpdateUserMapPin( i, flashArray );
		}

		ACS_addCustomPin(flashArray);
	}
}

@addMethod(CR4MapMenu) function ACS_addCustomPin( out flashArray : CScriptedFlashArray)
{
	var mhc_flashObject		: CScriptedFlashObject;	
	var current_area 		: int;
	var huntStatus			: ACSHuntStatus;
	var huntArea			: ACSHuntArea;
	var i 					: int;
	var centers				: array<Vector>;
	var position			: Vector;
	
	current_area = theGame.GetCommonMapManager().GetCurrentArea();
	
	if(( current_area == AN_Skellige_ArdSkellig ) && (m_shownArea == AN_Skellige_ArdSkellig))
	{
		huntArea = ACSHA_skellige;
		huntStatus = GetACSWatcher().getMonsterHunt()._getCurrentHuntStatus(huntArea);
	}
	else if((current_area == AN_NMLandNovigrad )&& (m_shownArea == AN_NMLandNovigrad) )
	{
		huntArea = ACSHA_novigrad;
		huntStatus = GetACSWatcher().getMonsterHunt()._getCurrentHuntStatus(huntArea);	
	}
	else if((current_area == (EAreaName)AN_Dlc_Bob )&& (m_shownArea == (EAreaName)AN_Dlc_Bob) )
	{
		huntArea = ACSHA_toussaint;
		huntStatus = GetACSWatcher().getMonsterHunt()._getCurrentHuntStatus(huntArea);	
	}
	
	if( huntStatus == ACSHS_noticeTaken || huntStatus == ACSHS_targetSpawned  )
	{
		position = GetACSWatcher().getMonsterHunt()._getCurrentCenter(huntArea);

		mhc_flashObject = GetMenuFlashValueStorage().CreateTempFlashObject("red.game.witcher3.data.StaticMapPinData");		
		mhc_flashObject.SetMemberFlashUInt(   "id",       NameToFlashUInt( 'User' ) );
		mhc_flashObject.SetMemberFlashNumber( "posX",     position.X );
		mhc_flashObject.SetMemberFlashNumber( "posY",     position.Y );
		mhc_flashObject.SetMemberFlashString( "description",GetLocStringByKeyExt("modACSMonsterHuntChallenge_pinDesc"));
		mhc_flashObject.SetMemberFlashString( "label", 	GetLocStringByKeyExt("modACSMonsterHuntChallenge_pinLabel"));
		mhc_flashObject.SetMemberFlashString( "type",     "MonsterQuest" );
		mhc_flashObject.SetMemberFlashNumber( "radius",	RoundF(position.Z));
		mhc_flashObject.SetMemberFlashBool(   "isQuest",	false );
		mhc_flashObject.SetMemberFlashBool(   "isPlayer",	false );
		mhc_flashObject.SetMemberFlashNumber( "rotation",	0 );
		flashArray.PushBackFlashObject(mhc_flashObject);
	
	}
}

@wrapMethod(CR4NoticeBoardMenu) function OnTakeQuest( tag : string )
{	
	wrappedMethod(tag);

	if( StrContains(tag,"modEHNotice") )
	{
		GetACSWatcher().getMonsterHunt().noticeTaken();
	}
	else
	{
		if( board.AcceptNewQuest(tag) )
		{
			OnCloseMenu();
		}
	}
}

@wrapMethod(CNewNPC) function OnDeath( damageAction : W3DamageAction  )
{
	wrappedMethod(damageAction);

	if( damageAction.attacker == thePlayer && HasTag('acs_monster_hunt') )
	{
		GetACSWatcher().getMonsterHunt().npcKilled(this) ;
	}
}
*/

@wrapMethod(AardConeCast) function OnThrowing()
{
	var ent                  				: CEntity;
	var rot                        			: EulerAngles;
    var pos									: Vector;
	var player								: CR4Player;

	player = caster.GetPlayer();

	wrappedMethod();

	if( super.OnThrowing() && player )
	{
		ACSGetCEntity('ACS_Sign_Physics_Ent').Destroy();

		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z += 0.5;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\aard_cone_fix.w2ent"

		, true ), pos, rot );

		//ent.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.AddTag('ACS_Sign_Physics_Ent');

		ent.DestroyAfter(3);
	}
}

@wrapMethod(AardCircleCast) function OnThrowing()
{
	var template 							: CEntityTemplate;
	var ent, ent_1, ent_2                  	: CEntity;
	var rot                        			: EulerAngles;
    var pos									: Vector;
	var player								: CR4Player;

	player = caster.GetPlayer();

	wrappedMethod();

	if( super.OnThrowing() && player )
	{
		ACSGetCEntity('ACS_Sign_Physics_Ent').Destroy();

		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z += 0.5;

		template = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\pc_aard.w2ent", true);


		ent = theGame.CreateEntity( template, pos, rot );

		//ent.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		//ent.PlayEffectSingle('blast_lv1');
		//ent.PlayEffectSingle('blast_lv2');
		ent.PlayEffectSingle('blast_lv3');
		//ent.PlayEffectSingle('blast_lv3_damage');
		//ent.PlayEffectSingle('blast_lv3_power');

		ent.AddTag('ACS_Sign_Physics_Ent');

		ent.DestroyAfter(3);
	}
}

@wrapMethod(IgniCast) function OnThrowing()
{
	var ent                  				: CEntity;
	var rot                        			: EulerAngles;
    var pos									: Vector;
	var player								: CR4Player;
	var template 							: CEntityTemplate;
	var ent_1, ent_2            			: CEntity;
	

	player = caster.GetPlayer();

	wrappedMethod();

	if( super.OnThrowing() && player )
	{
		ACSGetCEntity('ACS_Sign_Physics_Ent').Destroy();
		
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z += 0.5;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\aard_cone_fix.w2ent"

		, true ), pos, rot );

		ent.PlayEffectSingle('cone_old');

		ent.AddTag('ACS_Sign_Physics_Ent');

		ent.DestroyAfter(3);

		if (FactsQuerySum("ACS_Igni_Wide") > 0)
		{
			template = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\pc_igni_mq1060.w2ent", true);

			ent_1 = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

			ent_1.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,30,0) );

			ent_2 = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

			ent_2.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,150,0) );

			ent_1.PlayEffectSingle('cone_1');
			ent_1.PlayEffectSingle('cone_power_2');

			ent_1.StopEffect('cone_1');
			ent_1.StopEffect('cone_power_2');

			ent_2.PlayEffectSingle('cone_1');
			ent_2.PlayEffectSingle('cone_power_2');

			ent_2.StopEffect('cone_1');
			ent_2.StopEffect('cone_power_2');

			ent_1.DestroyAfter(3);

			ent_2.DestroyAfter(3);
		}
	}
}

@wrapMethod(W3AxiiEntity) function ProcessThrow()
{
	var i 																					: int;	
	var markerNPC_1 																		: CEntity;
	var markerTemplate 																		: CEntityTemplate;

	wrappedMethod();
	
	for(i=0; i<targets.Size(); i+=1)
	{
		targets[i].AddTag('ACS_Wraith_Finisher_Marked');

		markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\wraith_finisher_mark.w2ent", true );
	
		markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targets[i].GetWorldPosition() );

		markerNPC_1.CreateAttachment( targets[i], 'blood_point' );

		ACS_Tutorial_Display_Check('ACS_Phantom_Finisher_Tutorial_Shown');
	}		
}

/////////////////////////////// NPC START

@wrapMethod( CNewNPC ) function OnSpawned( spawnData : SEntitySpawnData )
{
	wrappedMethod(spawnData);
	
	if (!HasAbility('IsNotScaredOfMonsters'))
	{
		AddAbility('IsNotScaredOfMonsters');
	}

	if (
	GetNPCType() == ENGT_Commoner
	|| IsAnimal()
	)
	{
		SetIsUsingTooltip(false);
	}

	AddTimer('ACS_Animal_Controller', 0.5, true);

	AddTimer('ACS_Human_Charge_Attack_Interrupt', 0.5, true);

	AddTimer('ACS_Werewolf_Spawn_Adds', 0.5, true);

	AddTimer('ACS_Vendigo_Spawn_Adds', 0.5, true);

	AddTimer('ACS_NPC_Idle_Action', 0.75f, false);

	AddTimer('ACS_DelayedWolfAttitudeSet', 0.1, false);

	AddTimer('ACS_Crawl_Controller_Delay_Spawn', 0.1, false);

	AddTimer('ACS_Ice_Breath_Controller_Delay_Spawn', 0.1, false);

	//AddTimer('ACS_Death_Effects', 0.1, true);
}


@addMethod( CNewNPC ) timer function ACS_Werewolf_Spawn_Adds( dt : float, id : int )
{
	var actors, victims																												: array<CActor>;
	var i, count, j 																												: int;
	var npc 																														: CNewNPC;
	var actor, actortarget 																											: CActor;
	var spawnPos, playerPos, newPlayerPos																							: Vector;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var targetDistance																												: float;
	var ent_1, ent_2, ent_3, vfxEnt_1, vfxEnt_2, skull_ent_1, skull_ent_2, skull_ent_3												: CEntity;
	var rot, attach_rot                        						 																: EulerAngles;
   	var pos, attach_vec																												: Vector;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var playerRot, adjustedRot																										: EulerAngles;
	var temp, ent_1_temp, ent_2_temp																								: CEntityTemplate;
	var randAngle, randRange																										: float;
	var animatedComponentA																											: CAnimatedComponent;
	
	if (!this.IsAlive()
	|| (!this.HasAbility('mon_werewolf_lesser') && !this.HasAbility('mon_werewolf') && !this.HasAbility('mon_lycanthrope'))
	)
	{
		RemoveTimer('ACS_Werewolf_Spawn_Adds');

		return;
	}

	if(
	(
	(this.HasAbility('mon_werewolf_lesser')
	|| this.HasAbility('mon_werewolf')
	|| this.HasAbility('mon_lycanthrope')
	)
	&& this.GetCurrentHealth() <= this.GetMaxHealth() * 0.5
	&& this.IsAlive()
	&& !this.HasTag('ACS_Shades_Kara_Shadow_Werewolf')
	)
	)
	{
		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		if (targetDistance > 2.5 * 2.5 && targetDistance <= 20 * 20)
		{
			if ( !theSound.SoundIsBankLoaded("animals_wolf.bnk") )
			{
				theSound.SoundLoadBank( "animals_wolf.bnk", false );
			}

			if ( !theSound.SoundIsBankLoaded("monster_wild_dog.bnk") )
			{
				theSound.SoundLoadBank( "monster_wild_dog.bnk", false );
			}

			if (!this.HasTag('ACS_Werewolf_Has_Summoned_Adds'))
			{
				this.AddTag('ACS_Werewolf_Has_Summoned_Adds');





				vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
				"dlc\bob\data\fx\gameplay\mutation\mutation_7\mutation_7.w2ent"
				, true ), this.GetWorldPosition(), this.GetWorldRotation() );

				vfxEnt_1.CreateAttachment( this, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

				vfxEnt_1.PlayEffectSingle('sonar_mesh');

				vfxEnt_1.PlayEffectSingle('sonar');

				vfxEnt_1.PlayEffectSingle('fx_sonar');

				vfxEnt_1.DestroyAfter(2);



				vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
					"dlc\dlc_acs\data\fx\acs_sonar.w2ent"
					, true ), this.GetWorldPosition(), this.GetWorldRotation() );

				vfxEnt_2.CreateAttachment( this, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );


				vfxEnt_2.PlayEffectSingle('sonar_mesh');

				vfxEnt_2.PlayEffectSingle('sonar');

				vfxEnt_2.PlayEffectSingle('fx_sonar');

				vfxEnt_2.DestroyAfter(2);




				movementAdjustor = ((CActor)this).GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Werewolf_Smmmon_Rotate');
				movementAdjustor.CancelByName( 'ACS_Werewolf_Smmmon_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Werewolf_Smmmon_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.5 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

				movementAdjustor.RotateTowards(ticket, ((CActor)(this.GetTarget())));

				((CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' )).RaiseBehaviorForceEvent('Howl');

				if ( this.IsInInterior() )
				{
					((CActor)this).SetCanPlayHitAnim(false); 

					this.AddBuffImmunity(EET_Stagger, 'acs_werewolf_howl_interior', true);

					this.AddBuffImmunity(EET_LongStagger, 'acs_werewolf_howl_interior', true);

					this.AddBuffImmunity(EET_Knockdown , 'acs_werewolf_howl_interior', true);

					this.AddBuffImmunity(EET_HeavyKnockdown , 'acs_werewolf_howl_interior', true);
				}
				else
				{
					this.SoundEvent("animals_wolf_howl");

					this.SoundEvent("monster_wild_dog_howl");

					temp = (CEntityTemplate)LoadResource( 

					"characters\npc_entities\monsters\wolf_lvl1__summon.w2ent"
						
					, true );

					playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * -10;

					if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newPlayerPos ) )
					{
						theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.5f, 10 , newPlayerPos );
						playerPos = newPlayerPos;
					}

					playerRot = thePlayer.GetWorldRotation();

					adjustedRot = EulerAngles(0,0,0);

					adjustedRot.Yaw = playerRot.Yaw;

					ent_1 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

					((CNewNPC)ent_1).SetAttitude(this, AIA_Friendly);

					((CNewNPC)ent_1).SetLevel(this.GetLevel() - 3);

					((CNewNPC)ent_1).SetAttitude(((CActor)(this.GetTarget())), AIA_Hostile);

					ent_2 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

					((CNewNPC)ent_2).SetAttitude(this, AIA_Friendly);

					((CNewNPC)ent_2).SetLevel( this.GetLevel() - 3 );

					((CNewNPC)ent_2).SetAttitude(((CActor)(this.GetTarget())), AIA_Hostile);

					ent_3 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

					((CNewNPC)ent_3).SetAttitude(this, AIA_Friendly);

					((CNewNPC)ent_3).SetLevel(this.GetLevel() - 3);

					((CNewNPC)ent_3).SetAttitude(((CActor)(this.GetTarget())), AIA_Hostile);

					RemoveTimer('ACS_Werewolf_Spawn_Adds');
				}
			}
		}
	}
}

@addMethod( CNewNPC ) timer function ACS_Vendigo_Spawn_Adds( dt : float, id : int )
{
	var actors, victims																												: array<CActor>;
	var i, count, j 																												: int;
	var npc 																														: CNewNPC;
	var actor, actortarget 																											: CActor;
	var spawnPos, playerPos, newPlayerPos																							: Vector;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var targetDistance																												: float;
	var ent_1, ent_2, ent_3, vfxEnt_1, vfxEnt_2, skull_ent_1, skull_ent_2, skull_ent_3												: CEntity;
	var rot, attach_rot                        						 																: EulerAngles;
   	var pos, attach_vec																												: Vector;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var playerRot, adjustedRot																										: EulerAngles;
	var temp, ent_1_temp, ent_2_temp																								: CEntityTemplate;
	var randAngle, randRange																										: float;
	var animatedComponentA																											: CAnimatedComponent;
	
	if (!this.IsAlive() || !this.HasTag('ACS_Vendigo'))
	{
		RemoveTimer('ACS_Vendigo_Spawn_Adds');

		return;
	}

	 if (
	(
	this.GetCurrentHealth() <= this.GetMaxHealth() * 0.5
	&& this.IsAlive()
	)
	)			
	{
		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), thePlayer.GetWorldPosition() ) ;

		if (targetDistance > 2.5 * 2.5 && targetDistance <= 20 * 20)
		{
			if ( !theSound.SoundIsBankLoaded("animals_deer.bnk") )
			{
				theSound.SoundLoadBank( "animals_deer.bnk", false );
			}

			if (!this.HasTag('ACS_Vendigo_Has_Summoned_Adds'))
			{
				this.AddTag('ACS_Vendigo_Has_Summoned_Adds');


				this.PlayEffect('sonar');
				this.PlayEffect('pre_sonar');
				this.PlayEffect('sonar_ready');
				this.PlayEffect('scream_01');
				this.PlayEffect('scream_02');

				this.StopEffect('sonar');
				this.StopEffect('pre_sonar');
				this.StopEffect('sonar_ready');
				this.StopEffect('scream_01');
				this.StopEffect('scream_02');


				vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
				"dlc\bob\data\fx\gameplay\mutation\mutation_7\mutation_7.w2ent"
				, true ), this.GetWorldPosition(), this.GetWorldRotation() );

				vfxEnt_1.CreateAttachment( this, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

				vfxEnt_1.PlayEffectSingle('sonar_mesh');

				vfxEnt_1.PlayEffectSingle('sonar');

				vfxEnt_1.PlayEffectSingle('fx_sonar');

				vfxEnt_1.DestroyAfter(2);



				vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
					"dlc\dlc_acs\data\fx\acs_sonar.w2ent"
					, true ), this.GetWorldPosition(), this.GetWorldRotation() );

				vfxEnt_2.CreateAttachment( this, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );


				vfxEnt_2.PlayEffectSingle('sonar_mesh');

				vfxEnt_2.PlayEffectSingle('sonar');

				vfxEnt_2.PlayEffectSingle('fx_sonar');

				vfxEnt_2.DestroyAfter(2);




				movementAdjustor = ((CActor)this).GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Vendigo_Smmmon_Rotate');
				movementAdjustor.CancelByName( 'ACS_Vendigo_Smmmon_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Vendigo_Smmmon_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.5 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

				movementAdjustor.RotateTowards(ticket, ((CActor)(this.GetTarget())));

				((CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' )).RaiseBehaviorForceEvent('Howl');

				if ( this.IsInInterior() )
				{
					((CActor)this).SetCanPlayHitAnim(false); 

					this.AddBuffImmunity(EET_Stagger, 'acs_vendigo_howl_interior', true);

					this.AddBuffImmunity(EET_LongStagger, 'acs_vendigo_howl_interior', true);

					this.AddBuffImmunity(EET_Knockdown , 'acs_vendigo_howl_interior', true);

					this.AddBuffImmunity(EET_HeavyKnockdown , 'acs_vendigo_howl_interior', true);
				}
				else
				{
					this.SoundEvent("animals_deer_die");
					this.SoundEvent("animals_deer_die");
					this.SoundEvent("animals_deer_die");
					this.SoundEvent("animals_deer_die");
					this.SoundEvent("animals_deer_die");
					this.SoundEvent("animals_deer_die");

					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");

					ent_1_temp = (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\monsters\vendigo_spawn_melee.w2ent"
						
					, true );

					ent_2_temp = (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\monsters\vendigo_spawn_melee_spear.w2ent"
						
					, true );

					playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * -10;

					if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newPlayerPos ) )
					{
						theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.5f, 10 , newPlayerPos );
						playerPos = newPlayerPos;
					}

					playerRot = thePlayer.GetWorldRotation();

					adjustedRot = EulerAngles(0,0,0);

					adjustedRot.Yaw = playerRot.Yaw;

					ent_1 = theGame.CreateEntity( ent_1_temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

					((CNewNPC)ent_1).SetAttitude(this, AIA_Friendly);

					((CNewNPC)ent_1).SetLevel(this.GetLevel() - 3);

					((CNewNPC)ent_1).SetAttitude(((CActor)(this.GetTarget())), AIA_Hostile);


					((CActor)ent_1).AddBuffImmunity(EET_Confusion , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_1).AddBuffImmunity(EET_Swarm , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_1).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_1).AddBuffImmunity(EET_Blindness , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_1).AddBuffImmunity(EET_Paralyzed , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_1).AddTag('IsBoss');

					((CActor)ent_1).AddAbility('Boss');

					((CActor)ent_1).AddAbility('InstantKillImmune');

					((CActor)ent_1).AddAbility('DisableFinishers');

					((CActor)ent_1).AddAbility('MonsterMHBoss');

					((CActor)ent_1).AddAbility('BounceBoltsWildhunt');

					ent_1.AddTag('ACS_Vendigo_Spawn');




					ent_2 = theGame.CreateEntity( ent_2_temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

					((CNewNPC)ent_2).SetAttitude(this, AIA_Friendly);

					((CNewNPC)ent_2).SetLevel( this.GetLevel() - 3 );

					((CNewNPC)ent_2).SetAttitude(((CActor)(this.GetTarget())), AIA_Hostile);


					((CActor)ent_2).AddBuffImmunity(EET_Confusion , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_2).AddBuffImmunity(EET_Swarm , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_2).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_2).AddBuffImmunity(EET_Blindness , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_2).AddBuffImmunity(EET_Paralyzed , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_2).AddTag('IsBoss');

					((CActor)ent_2).AddAbility('Boss');

					((CActor)ent_2).AddAbility('InstantKillImmune');

					((CActor)ent_2).AddAbility('DisableFinishers');

					((CActor)ent_2).AddAbility('MonsterMHBoss');

					((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

					ent_2.AddTag('ACS_Vendigo_Spawn');


					if (RandF() < 0.5)
					{
						ent_3 = theGame.CreateEntity( ent_1_temp, ACSPlayerFixZAxis(playerPos), adjustedRot );
					}
					else
					{
						ent_3 = theGame.CreateEntity( ent_2_temp, ACSPlayerFixZAxis(playerPos), adjustedRot );
					}
					
					((CNewNPC)ent_3).SetAttitude(this, AIA_Friendly);

					((CNewNPC)ent_3).SetLevel(this.GetLevel() - 3);

					((CNewNPC)ent_3).SetAttitude(((CActor)(this.GetTarget())), AIA_Hostile);


					((CActor)ent_3).AddBuffImmunity(EET_Confusion , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_3).AddBuffImmunity(EET_Swarm , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_3).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_3).AddBuffImmunity(EET_Blindness , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_3).AddBuffImmunity(EET_Paralyzed , 'ACS_Vendigo_Spawn_Buff', true);

					((CActor)ent_3).AddTag('IsBoss');

					((CActor)ent_3).AddAbility('Boss');

					((CActor)ent_3).AddAbility('InstantKillImmune');

					((CActor)ent_3).AddAbility('DisableFinishers');

					((CActor)ent_3).AddAbility('MonsterMHBoss');

					((CActor)ent_3).AddAbility('BounceBoltsWildhunt');

					ent_3.AddTag('ACS_Vendigo_Spawn');



					if (!((CNewNPC)ent_1).HasAbility('IsNotScaredOfMonsters'))
					{
						((CNewNPC)ent_1).AddAbility('IsNotScaredOfMonsters');
					}

					if (!((CNewNPC)ent_2).HasAbility('IsNotScaredOfMonsters'))
					{
						((CNewNPC)ent_2).AddAbility('IsNotScaredOfMonsters');
					}

					if (!((CNewNPC)ent_3).HasAbility('IsNotScaredOfMonsters'))
					{
						((CNewNPC)ent_3).AddAbility('IsNotScaredOfMonsters');
					}

					ent_1.PlayEffect('axii_hipnotize');
					ent_1.PlayEffect('axii_confusion');
					ent_1.PlayEffect('axii_guardian');
					ent_1.PlayEffect('axii_slowdown');
					ent_1.PlayEffect('demonic_possession');
					//ent_1.PlayEffect('ice');

					ent_2.PlayEffect('axii_hipnotize');
					ent_2.PlayEffect('axii_confusion');
					ent_2.PlayEffect('axii_guardian');
					ent_2.PlayEffect('axii_slowdown');
					ent_2.PlayEffect('demonic_possession');
					//ent_2.PlayEffect('ice');

					ent_3.PlayEffect('axii_hipnotize');
					ent_3.PlayEffect('axii_confusion');
					ent_3.PlayEffect('axii_guardian');
					ent_3.PlayEffect('axii_slowdown');
					ent_3.PlayEffect('demonic_possession');
					//ent_3.PlayEffect('ice');

					skull_ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\models\vendigo\vendigo_spawn_skull.w2ent"

					, true ), playerPos, adjustedRot );

					skull_ent_1.CreateAttachment( ent_1, 'head', Vector( 0, 0.15, 0.4 ), EulerAngles(-45,180,0) );

					skull_ent_1.AddTag('ACS_Vendigo_Spawn_Skull');


					skull_ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\models\vendigo\vendigo_spawn_skull.w2ent"

					, true ), playerPos, adjustedRot );

					skull_ent_2.CreateAttachment( ent_2, 'head', Vector( 0, 0.15, 0.4 ), EulerAngles(-45,180,0) );

					skull_ent_2.AddTag('ACS_Vendigo_Spawn_Skull');


					skull_ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\models\vendigo\vendigo_spawn_skull.w2ent"

					, true ), playerPos, adjustedRot );

					skull_ent_3.CreateAttachment( ent_3, 'head', Vector( 0, 0.15, 0.4 ), EulerAngles(-45,180,0) );

					skull_ent_3.AddTag('ACS_Vendigo_Spawn_Skull');

					RemoveTimer('ACS_Werewolf_Spawn_Adds');
				}
			}
		}
	}
}

/*
@addMethod( CNewNPC ) timer function ACS_Death_Effects( dt : float, id : int )
{
	var droppeditemID, droppeditemIDVampireMonsterRing											: SItemUniqueId;
	var animatedComponentA																		: CAnimatedComponent;
	var actors, actors2 																		: array<CActor>;
	var i, j																					: int;
	var actor, actor2																			: CActor;
	var npc, npc_1																				: CNewNPC;
	var movementAdjustor, movementAdjustorNPC, movementAdjustorBigWraith						: CMovementAdjustor;
	var ticket, ticketNPC, ticket_1																: SMovementAdjustmentRequestTicket;
	var targetDistance, targetDistance_1														: float;
	var dmg																						: W3DamageAction;

	if (this.IsAlive())
	{
		return;
	}

	if(
	this.HasTag('ACS_Blade_Of_The_Unseen')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_unseen_blade_despawn'))
			{
				ACSGetCEntity('ACS_Blade_Of_The_Unseen_L_Blade').Destroy();

				ACSGetCEntity('ACS_Unseen_Blade_L_Anchor').Destroy();

				ACSGetCEntity('ACS_Blade_Of_The_Unseen_R_Blade').Destroy();

				ACSGetCEntity('ACS_Unseen_Blade_R_Anchor').Destroy();

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				RemoveTimer('unseen_blade_spawn_delay');

				RemoveTimer('unseen_blade_hunt_delay');

				this.SetVisibility(false);

				this.StopAllEffects();

				this.DestroyAfter(1);

				if (GetACSStorage().acs_Unseen_Blade_Death_Count() == 0)
				{
					GetWitcherPlayer().DisplayHudMessage( "<b>You are ... worthy. Pray that we do not meet again.</b>" );
				}
				else if (GetACSStorage().acs_Unseen_Blade_Death_Count() == 1)
				{
					GetWitcherPlayer().DisplayHudMessage( "<b>You are warned. Next time I shall not be so kind.</b>" );
				}
				else if (GetACSStorage().acs_Unseen_Blade_Death_Count() == 2)
				{
					GetWitcherPlayer().DisplayHudMessage( "<b>WITCHER. ONLY YOUR DEATH SHALL APPEASE ME NOW.</b>" );

					GetACSWatcher().AddTimer('Unseen_Monster_Summon', 5, false);
				}

				GetACSStorage().acs_Unseen_Blade_Death_Count_Increment();

				

				this.AddTag('acs_unseen_blade_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('novigrad_underground_vampire')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('novigrad_underground_vampire_despawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>Fuck you and fuck this shit. I'm out.</b>" );

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				this.GetInventory().AddAnItem( 'acs_quen_monster_item', 1 );

				droppeditemID = this.GetInventory().GetItemId('acs_quen_monster_item');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				this.SetVisibility(false);

				this.StopAllEffects();

				

				this.AddTag('novigrad_underground_vampire_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('hubert_rejk_vampire')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('hubert_rejk_vampire_despawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>I hope we meet again. May the Eternal Fire guide and protect you.</b>" );

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				this.SetVisibility(false);

				this.StopAllEffects();

				this.GetInventory().AddAnItem( 'acs_aard_pull_item' , 1 );

				droppeditemID = this.GetInventory().GetItemId('acs_aard_pull_item');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				

				this.AddTag('hubert_rejk_vampire_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('acs_orianna_vampire')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_orianna_despawn'))
			{
				this.StopAllEffects();

				GetACSWatcher().RemoveTimer('OriannaDeathDelay');

				GetACSWatcher().AddTimer('OriannaDeathDelay', 7, false);

				if ( FactsQuerySum("ACS_Orianna_Killed") <= 0 )
				{
					FactsAdd("ACS_Orianna_Killed", 1, -1);
				}

				

				this.AddTag('acs_orianna_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fire_Bear')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fire_bear_despawn'))
			{
				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Armor_Omega' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Armor_Omega');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Armor_Omega' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Armor_Omega');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				GetACSWatcher().RemoveTimer('DropBearMeteorStart');

				GetACSWatcher().RemoveTimer('DropBearMeteorAscend');

				GetACSWatcher().RemoveTimer('DropBearMeteor');

				GetACSWatcher().RemoveTimer('DropBearSummon');

				GetWitcherPlayer().DisplayHudMessage( "<b>AVATAR OF THE CHAOS FLAME VANQUISHED</b>" );

				ACSGetCEntity('ACS_Fire_Sky_Ent').Destroy();

				ACS_FireBearDespawnEffect();

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'bear_death_burning', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0));

				animatedComponentA.FreezePoseFadeIn(6.25);

				//this.SetVisibility(false);

				this.StopEffect('flames');
				this.StopEffect('critical_burning');

				//this.DestroyAfter(1);

				

				this.AddTag('acs_fire_bear_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fire_Bear_Altar_Entity')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fire_bear_spawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>AVATAR OF THE CHAOS FLAME SUMMONED</b>" );

				ACS_FireBearSpawnEffect();

				ACS_dropbearbossfight();

				this.DestroyAfter(1);

				ACSGetCEntity('ACS_Fire_Bear_Altar').DestroyAfter(1);

				

				this.AddTag('acs_fire_bear_spawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_She_Who_Knows')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_she_who_knows_despawn'))
			{
				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Gloves' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Gloves');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Gloves' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Gloves');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				GetACSWatcher().RemoveTimer('SheWhoKnowsHide');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley1');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley2');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley3');

				GetACSWatcher().RemoveTimer('SheWhoKnowsTeleport');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingle');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingleStop');

				GetWitcherPlayer().DisplayHudMessage( "<b>PESTILENCE VANQUISHED</b>" );

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'death_burning', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				this.PlayEffectSingle('fire_hit');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');

				this.DestroyAfter(6);

				

				this.AddTag('acs_she_who_knows_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Knightmare_Eternum')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_knightmare_despawn'))
			{
				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Boots' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Boots');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Boots' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Boots');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				GetACSWatcher().RemoveTimer('KnightmareEternumShout');

				GetACSWatcher().RemoveTimer('KnightmareEternumIgni');

				this.StopAllEffects();

				this.SetVisibility(false);

				ACSGetCEntity('ACS_knightmare_sword_trail').Destroy();

				ACSGetCEntity('ACS_knightmare_quen_hit').Destroy();

				ACSGetCEntity('ACS_knightmare_quen').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_4').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_3').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_2').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_1').Destroy();

				this.DestroyAfter(5);

				

				this.AddTag('acs_knightmare_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Forest_God')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_forest_god_despawn'))
			{
				this.GetInventory().AddAnItem( 'ACS_Steel_Aerondight' , 1 );

				droppeditemID = this.GetInventory().GetItemId('ACS_Steel_Aerondight');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				this.StopAllEffects();

				this.PlayEffectSingle('hym_despawn');

				this.PlayEffectSingle('hym_summon');

				this.SetVisibility(false);

				this.DestroyAfter(5);

				

				this.AddTag('acs_forest_god_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Vampire_Monster_Boss_Bar')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_vampire_monster_despawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>NIGHTMARE REPELLED</b>" );

				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Pants' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Pants');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Pants' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Pants');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				this.GetInventory().AddAnItem( 'acs_vampire_ring' , 1 );

				droppeditemIDVampireMonsterRing = this.GetInventory().GetItemId('acs_vampire_ring');

				this.GetInventory().DropItemInBag(droppeditemIDVampireMonsterRing, 1);

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				ACSGetCActor('ACS_Vampire_Monster').DestroyAfter(0.5);

				this.DestroyAfter(0.5);

				

				this.AddTag('acs_vampire_monster_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Vampire_Monster')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_vampire_monster_not_alive_state'))
			{
				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				this.SetVisibility(false);

				GetACSWatcher().AddTimer('Vampire_Monster_Respwan_Reveal', 10, false);

				

				this.AddTag('acs_vampire_monster_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Big_Lizard')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_big_lizard_not_alive_state'))
			{
				this.StopAllEffects();

				this.PlayEffectSingle('fire_hit');

				

				this.AddTag('acs_big_lizard_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Rat_Mage')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_rat_mage_not_alive_state'))
			{
				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_longsword_death_front_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				this.PlayEffectSingle('ethereal_debuff');

				this.DestroyAfter(1.5);

				

				this.AddTag('acs_rat_mage_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Eredin')
	)
	{
		if (!this.IsAlive())
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

			if (this.HasTag('acs_eredin_not_alive_state_play_loop_anim'))
			{
				animatedComponentA.PlaySlotAnimationAsync ( 'swordground_ready_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.1f, 0.1f));
			}

			if(!this.HasTag('acs_eredin_not_alive_state'))
			{
				GetACSWatcher().RemoveTimer('ACS_Eredin_Kill_Timer');

				movementAdjustorNPC = this.GetMovingAgentComponent().GetMovementAdjustor();

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Eredin_Death_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Eredin_Death_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Eredin_Death_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.125 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );
				movementAdjustorNPC.AdjustLocationVertically( ticketNPC, true );
				movementAdjustorNPC.ScaleAnimationLocationVertically( ticketNPC, true );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				movementAdjustorNPC.SlideTo( ticketNPC, ACSPlayerFixZAxis(this.GetWorldPosition() + this.GetWorldForward() * -3) );

				animatedComponentA.PlaySlotAnimationAsync ( 'blink_start_back_ready', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				GetACSWatcher().AddTimer('EredinDeathPortalDelay', 0.75, false);

				GetACSWatcher().AddTimer('EredinDeathEffectDelay', 4.75, false);

				this.DestroyAfter(5.25);

				

				this.AddTag('acs_eredin_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Canaris')
	)
	{
		if (!this.IsAlive())
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

			if(!this.HasTag('acs_canaris_not_alive_state'))
			{
				this.GetInventory().RemoveAllItems();

				ACSGetCEntity('ACS_Canaris_Melee_Effect').PlayEffectSingle('explode');

				ACSGetCEntity('ACS_Canaris_Melee_Effect').DestroyAfter(0.5);

				animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_2hhammer_death_front_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				this.AddTag('acs_canaris_not_alive_state');

				animatedComponentA.FreezePoseFadeIn(5);

				GetACSWatcher().AddTimer('CanarisDeathEffectDelay', 1.5, false);

				this.DestroyAfter(2);

				//CreateCanarisLoot();

				this.GetInventory().AddAnItem( 'ACS_Ice_Staff' , 1 );

				droppeditemID = this.GetInventory().GetItemId('ACS_Ice_Staff');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				

				this.AddTag('acs_canaris_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Night_Stalker')
	)
	{
		if (!this.IsAlive())
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

			if(!this.HasTag('acs_night_stalker_not_alive_state'))
			{
				GetACSWatcher().RemoveTimer('NightStalkerCamo');

				GetACSWatcher().RemoveTimer('NightStalkerVisibility');

				GetACSWatcher().RemoveTimer('ACS_NightStalker_Kill_Timer');

				this.DestroyEffect('disappear');

				this.DestroyEffect('predator_mode');

				this.DestroyEffect('glow');

				this.PlayEffectSingle('glow');

				this.EnableCharacterCollisions(false);
				//this.EnableCollisions(false);

				movementAdjustorNPC = this.GetMovingAgentComponent().GetMovementAdjustor();

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Night_Stalker_Death_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Night_Stalker_Death_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Night_Stalker_Death_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );
				movementAdjustorNPC.AdjustLocationVertically( ticketNPC, true );
				movementAdjustorNPC.ScaleAnimationLocationVertically( ticketNPC, true );

				movementAdjustorNPC.RotateTowards( ticketNPC, thePlayer, RandRangeF(225,135) );

				animatedComponentA.PlaySlotAnimationAsync ( 'monster_katakan_q704_jumping_across_roof', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				GetACSWatcher().RemoveTimer('NightStalkerDeathCamo');
				GetACSWatcher().AddTimer('NightStalkerDeathCamo', 1.4, false);

				GetACSWatcher().RemoveTimer('NightStalkerDeathTeleport');
				GetACSWatcher().AddTimer('NightStalkerDeathTeleport', 1.55, false);

				this.DestroyAfter(1.75);

				

				this.AddTag('acs_night_stalker_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Night_Stalker')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fire_gargoyle_despawn'))
			{
				GetACSWatcher().RemoveTimer('FireGargoyleFireballDelay');

				GetACSWatcher().RemoveTimer('FireGargoyleJumpInDelay');

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				if(RandF() < 0.5)
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}

				animatedComponentA.FreezePoseFadeIn(3);

				this.PlayEffectSingle('fire_hit');

				//this.DestroyAfter(6);

				

				this.AddTag('acs_fire_gargoyle_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fluffy')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fluffy_despawn'))
			{
				GetACSFluffyKillAdds();

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'wolf_burning_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animatedComponentA.FreezePoseFadeIn(2);

				this.DestroyAfter(4);

				

				this.AddTag('acs_fluffy_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fog_Assassin')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fog_assassin_despawn'))
			{
				GetACSFogAssassinKillAdds();

				ACSGetCEntityDestroyAll('ACS_Fog_Assassin_Fog_Entity');

				

				this.AddTag('acs_fog_assassin_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Melusine')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_melusine_despawn'))
			{
				ACSGetCActor('ACS_Melusine_Cloud').Destroy();

				ACSGetCActor('ACS_Melusine_Bossbar').Destroy();

				

				this.AddTag('acs_melusine_despawn');

				
			}
		}
	}
}
*/

@wrapMethod( CNewNPC ) function OnDeath( damageAction : W3DamageAction  )
{
	var droppeditemID, droppeditemIDVampireMonsterRing											: SItemUniqueId;
	var animatedComponentA																		: CAnimatedComponent;
	var actors, actors2 																		: array<CActor>;
	var i, j																					: int;
	var actor, actor2																			: CActor;
	var npc, npc_1																				: CNewNPC;
	var movementAdjustor, movementAdjustorNPC, movementAdjustorBigWraith						: CMovementAdjustor;
	var ticket, ticketNPC, ticket_1																: SMovementAdjustmentRequestTicket;
	var targetDistance, targetDistance_1														: float;
	var dmg																						: W3DamageAction;
	var anim_names																				: array< name >;
	var l_comp 																					: array< CComponent >;
	var size 																					: int;
	
	wrappedMethod(damageAction);

	((CActor)this).FreezeCloth(true);

	RemoveTimers();

	ACS_Record_Kill(damageAction);

	ACS_Ghoul_Base_On_Take_Damage(damageAction);

	ACS_Siren_Base_On_Take_Damage(damageAction);

	ACS_Bruxa_On_Take_Damage(damageAction);

	ACS_Cursed_Werewolf_On_Take_Damage(damageAction);

	ACS_Red_Blood_Death_On_Take_Damage(damageAction);

	if(
	this.HasTag('ACS_Blade_Of_The_Unseen')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_unseen_blade_despawn'))
			{
				ACSGetCEntity('ACS_Blade_Of_The_Unseen_L_Blade').Destroy();

				ACSGetCEntity('ACS_Unseen_Blade_L_Anchor').Destroy();

				ACSGetCEntity('ACS_Blade_Of_The_Unseen_R_Blade').Destroy();

				ACSGetCEntity('ACS_Unseen_Blade_R_Anchor').Destroy();

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				RemoveTimer('unseen_blade_spawn_delay');

				RemoveTimer('unseen_blade_hunt_delay');

				this.SetVisibility(false);

				this.StopAllEffects();

				this.DestroyAfter(1);

				if (GetACSStorage().acs_Unseen_Blade_Death_Count() == 0)
				{
					GetWitcherPlayer().DisplayHudMessage( "<b>You are ... worthy. Pray that we do not meet again.</b>" );
				}
				else if (GetACSStorage().acs_Unseen_Blade_Death_Count() == 1)
				{
					GetWitcherPlayer().DisplayHudMessage( "<b>You are warned. Next time I shall not be so kind.</b>" );
				}
				else if (GetACSStorage().acs_Unseen_Blade_Death_Count() == 2)
				{
					GetWitcherPlayer().DisplayHudMessage( "<b>WITCHER. ONLY YOUR DEATH SHALL APPEASE ME NOW.</b>" );

					GetACSWatcher().AddTimer('Unseen_Monster_Summon', 5, false);
				}

				GetACSStorage().acs_Unseen_Blade_Death_Count_Increment();

				

				this.AddTag('acs_unseen_blade_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('novigrad_underground_vampire')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('novigrad_underground_vampire_despawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>Fuck you and fuck this shit. I'm out.</b>" );

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				this.GetInventory().AddAnItem( 'acs_quen_monster_item', 1 );

				droppeditemID = this.GetInventory().GetItemId('acs_quen_monster_item');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				this.SetVisibility(false);

				this.StopAllEffects();

				

				this.AddTag('novigrad_underground_vampire_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('hubert_rejk_vampire')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('hubert_rejk_vampire_despawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>I hope we meet again. May the Eternal Fire guide and protect you.</b>" );

				ACS_VampireBatsSpawnEffect(this.GetWorldPosition());

				this.SetVisibility(false);

				this.StopAllEffects();

				this.GetInventory().AddAnItem( 'acs_aard_pull_item' , 1 );

				droppeditemID = this.GetInventory().GetItemId('acs_aard_pull_item');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				

				this.AddTag('hubert_rejk_vampire_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('acs_orianna_vampire')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_orianna_despawn'))
			{
				this.StopAllEffects();

				GetACSWatcher().RemoveTimer('OriannaDeathDelay');

				GetACSWatcher().AddTimer('OriannaDeathDelay', 7, false);

				if ( FactsQuerySum("ACS_Orianna_Killed") <= 0 )
				{
					FactsAdd("ACS_Orianna_Killed", 1, -1);
				}

				

				this.AddTag('acs_orianna_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fire_Bear')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fire_bear_despawn'))
			{
				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Armor_Omega' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Armor_Omega');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Armor_Omega' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Armor_Omega');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				GetACSWatcher().RemoveTimer('DropBearMeteorStart');

				GetACSWatcher().RemoveTimer('DropBearMeteorAscend');

				GetACSWatcher().RemoveTimer('DropBearMeteor');

				GetACSWatcher().RemoveTimer('DropBearSummon');

				GetWitcherPlayer().DisplayHudMessage( "<b>AVATAR OF THE CHAOS FLAME VANQUISHED</b>" );

				ACSGetCEntity('ACS_Fire_Sky_Ent').Destroy();

				ACS_FireBearDespawnEffect();

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'bear_death_burning', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0));

				animatedComponentA.FreezePoseFadeIn(6.25);

				//this.SetVisibility(false);

				this.StopEffect('flames');
				this.StopEffect('critical_burning');

				//this.DestroyAfter(1);

				

				this.AddTag('acs_fire_bear_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fire_Bear_Altar_Entity')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fire_bear_spawn'))
			{
				GetWitcherPlayer().DisplayHudMessage( "<b>AVATAR OF THE CHAOS FLAME SUMMONED</b>" );

				ACS_FireBearSpawnEffect();

				ACS_dropbearbossfight();

				this.DestroyAfter(1);

				ACSGetCEntity('ACS_Fire_Bear_Altar').DestroyAfter(1);

				

				this.AddTag('acs_fire_bear_spawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_She_Who_Knows')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_she_who_knows_despawn'))
			{
				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Gloves' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Gloves');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Gloves' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Gloves');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				GetACSWatcher().RemoveTimer('SheWhoKnowsHide');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley1');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley2');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley3');

				GetACSWatcher().RemoveTimer('SheWhoKnowsTeleport');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingle');

				GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingleStop');

				GetWitcherPlayer().DisplayHudMessage( "<b>PESTILENCE VANQUISHED</b>" );

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'death_burning', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				this.PlayEffectSingle('fire_hit');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');
				this.PlayEffectSingle('critical_burning');

				this.DestroyAfter(6);

				

				this.AddTag('acs_she_who_knows_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Knightmare_Eternum')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_knightmare_despawn'))
			{
				if( FactsQuerySum("NewGamePlus") > 0 )
				{
					this.GetInventory().AddAnItem( 'NGP_ACS_Boots' , 1 );

					droppeditemID = this.GetInventory().GetItemId('NGP_ACS_Boots');
				}
				else
				{
					this.GetInventory().AddAnItem( 'ACS_Boots' , 1 );

					droppeditemID = this.GetInventory().GetItemId('ACS_Boots');
				}

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				GetACSWatcher().RemoveTimer('KnightmareEternumShout');

				GetACSWatcher().RemoveTimer('KnightmareEternumIgni');

				this.StopAllEffects();

				this.SetVisibility(false);

				ACSGetCEntity('ACS_knightmare_sword_trail').Destroy();

				ACSGetCEntity('ACS_knightmare_quen_hit').Destroy();

				ACSGetCEntity('ACS_knightmare_quen').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_4').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_3').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_2').Destroy();

				ACSGetCEntity('ACS_knightmare_chest_blade_1').Destroy();

				this.DestroyAfter(5);

				

				this.AddTag('acs_knightmare_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Forest_God')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_forest_god_despawn'))
			{
				this.GetInventory().AddAnItem( 'ACS_Steel_Aerondight' , 1 );

				droppeditemID = this.GetInventory().GetItemId('ACS_Steel_Aerondight');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				this.StopAllEffects();

				this.PlayEffectSingle('hym_despawn');

				this.PlayEffectSingle('hym_summon');

				this.SetVisibility(false);

				this.DestroyAfter(5);

				

				this.AddTag('acs_forest_god_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Big_Lizard')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_big_lizard_not_alive_state'))
			{
				this.StopAllEffects();

				this.PlayEffectSingle('fire_hit');

				

				this.AddTag('acs_big_lizard_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Rat_Mage')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_rat_mage_not_alive_state'))
			{
				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_longsword_death_front_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				this.PlayEffectSingle('ethereal_debuff');

				this.DestroyAfter(1.5);

				

				this.AddTag('acs_rat_mage_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Eredin')
	)
	{
		if (!this.IsAlive())
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

			if (this.HasTag('acs_eredin_not_alive_state_play_loop_anim'))
			{
				animatedComponentA.PlaySlotAnimationAsync ( 'swordground_ready_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.1f, 0.1f));
			}

			if(!this.HasTag('acs_eredin_not_alive_state'))
			{
				GetACSWatcher().RemoveTimer('ACS_Eredin_Kill_Timer');

				movementAdjustorNPC = this.GetMovingAgentComponent().GetMovementAdjustor();

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Eredin_Death_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Eredin_Death_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Eredin_Death_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.125 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );
				movementAdjustorNPC.AdjustLocationVertically( ticketNPC, true );
				movementAdjustorNPC.ScaleAnimationLocationVertically( ticketNPC, true );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				movementAdjustorNPC.SlideTo( ticketNPC, ACSPlayerFixZAxis(this.GetWorldPosition() + this.GetWorldForward() * -3) );

				animatedComponentA.PlaySlotAnimationAsync ( 'blink_start_back_ready', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				GetACSWatcher().AddTimer('EredinDeathPortalDelay', 0.75, false);

				GetACSWatcher().AddTimer('EredinDeathEffectDelay', 4.75, false);

				this.DestroyAfter(5.25);

				

				this.AddTag('acs_eredin_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Canaris')
	)
	{
		if (!this.IsAlive())
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

			if(!this.HasTag('acs_canaris_not_alive_state'))
			{
				this.GetInventory().RemoveAllItems();

				ACSGetCEntity('ACS_Canaris_Melee_Effect').PlayEffectSingle('explode');

				ACSGetCEntity('ACS_Canaris_Melee_Effect').DestroyAfter(0.5);

				animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_2hhammer_death_front_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				this.AddTag('acs_canaris_not_alive_state');

				animatedComponentA.FreezePoseFadeIn(5);

				GetACSWatcher().AddTimer('CanarisDeathEffectDelay', 1.5, false);

				this.DestroyAfter(2);

				//CreateCanarisLoot();

				this.GetInventory().AddAnItem( 'ACS_Ice_Staff' , 1 );

				droppeditemID = this.GetInventory().GetItemId('ACS_Ice_Staff');

				this.GetInventory().DropItemInBag(droppeditemID, 1);

				

				this.AddTag('acs_canaris_not_alive_state');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fire_Gargoyle')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fire_gargoyle_despawn'))
			{
				GetACSWatcher().RemoveTimer('FireGargoyleFireballDelay');

				GetACSWatcher().RemoveTimer('FireGargoyleJumpInDelay');

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				if(RandF() < 0.5)
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}

				animatedComponentA.FreezePoseFadeIn(3);

				this.PlayEffectSingle('fire_hit');

				//this.DestroyAfter(6);

				

				this.AddTag('acs_fire_gargoyle_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fluffy')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fluffy_despawn'))
			{
				GetACSFluffyKillAdds();

				animatedComponentA = (CAnimatedComponent)((CNewNPC)this).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'wolf_burning_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animatedComponentA.FreezePoseFadeIn(2);

				this.DestroyAfter(4);

				

				this.AddTag('acs_fluffy_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Fog_Assassin')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_fog_assassin_despawn'))
			{
				GetACSFogAssassinKillAdds();

				ACSGetCEntityDestroyAll('ACS_Fog_Assassin_Fog_Entity');

				

				this.AddTag('acs_fog_assassin_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Melusine')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_melusine_despawn'))
			{
				ACSGetCActor('ACS_Melusine_Cloud').Destroy();

				ACSGetCActor('ACS_Melusine_Bossbar').Destroy();

				

				this.AddTag('acs_melusine_despawn');

				
			}
		}
	}
	else if(
	this.HasTag('ACS_Knocker')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('acs_knocker_despawn'))
			{
				ACS_Ghoul_Explode(this, this.GetWorldPosition());

				((CAnimatedComponent)this.GetComponentByClassName('CAnimatedComponent')).FreezePoseFadeIn(4.5);

				this.DestroyAfter(10);

				this.AddTag('acs_knocker_despawn');
			}
		}
	}
	else if(
	this.HasTag('ACS_Chironex')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Chironex_Death'))
			{
				ACS_Ghoul_Explode(this, this.GetWorldPosition());

				DestroyEffect('demonic_cast');

				DestroyEffect('ghost');

				DestroyEffect('demon_horse');

				PlayEffectSingle('disappear');

				SetVisibility(false);
				
				//npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

				DestroyAfter(2);

				SetInteractionPriority( IP_Prio_0 );

				EnableCollisions(false);

				ACS_Chironex_Corpse_Spawn(this, this.GetWorldPosition());

				this.AddTag('ACS_Chironex_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_WeaponizedRabbit')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Weaponized_Rabbit_Death'))
			{
				this.Teleport(this.GetWorldPosition() + Vector(0,0,-200));

				this.DestroyAfter(2);

				ACS_Weaponized_Rabbit_Corpse_Spawn(this, this.GetWorldPosition());

				this.AddTag('ACS_Weaponized_Rabbit_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Lynx_Witcher')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Lynx_Witcher_End_Stage'))
			{
				this.DestroyAfter(5);

				this.AddTag('ACS_Lynx_Witcher_End_Stage');
			}
		}
	}
	else if(
	this.HasTag('ACS_Elderblood_Assassin')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Elderblood_Assassin_End_Stage'))
			{
				StopEffect('fury');

				StopEffect('fury_403');

				StopEffect('teleport_glow');

				PlayEffect('fury');

				PlayEffect('fury_403');

				PlayEffect('teleport_glow');

				DestroyAfter(1);

				this.AddTag('ACS_Elderblood_Assassin_End_Stage');
			}
		}
	}
	else if(
	this.HasTag('ACS_Elderblood_Assassin_Clone')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Elderblood_Assassin_Clone_End_Stage'))
			{
				StopEffect('fury');

				StopEffect('fury_403');

				StopEffect('teleport_glow');

				PlayEffect('fury');

				PlayEffect('fury_403');

				PlayEffect('teleport_glow');

				DestroyAfter(1);

				this.AddTag('ACS_Elderblood_Assassin_Clone_End_Stage');
			}
		}
	}
	else if(
	(HasAbility('mon_wolf_base')
	&& !HasAbility('mon_wolf_summon_were')
	&& !HasAbility('mon_evil_dog')
	&& GetNPCType() != ENGT_Quest
	&& !IsInInterior()
	&& !HasTag('ACS_Shadow_Wolf')
	&& ACSGetCActor('ACS_Fluffy') 
	&& ACSGetCActor('ACS_Fluffy').IsAlive())
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Wolf_End_Stage'))
			{
				if (RandF() < 0.5)
				{
					ACS_ShadowWolfSpawn(this, this.GetWorldPosition());
				}

				this.AddTag('ACS_Wolf_End_Stage');
			}
		}
	}
	else if(
	this.HasTag('ACS_Shadow_Wolf')
	|| this.HasTag('ACS_Fluffy_Shadow_Wolf')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_ShadowWolf_End_Stage'))
			{
				PlayEffectSingle('appear');
				StopEffect('appear');

				StopAllEffects();

				SetVisibility(false);

				this.AddTag('ACS_ShadowWolf_End_Stage');
			}
		}
	}
	else if(
	this.HasTag('ACS_Forest_God_Shadows')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Forest_God_Shadow_Death'))
			{
				StopAllEffects();

				SetVisibility(false);

				GetWitcherPlayer().DisplayHudMessage( "<b>SHADOW DEFEATED</b>" );

				this.AddTag('ACS_Forest_God_Shadow_Death');
			}
		}
	}
	else if(
	StrContains( this.GetReadableName(), "mh210_lamia" )
	&& this.HasAbility('mon_lamia_stronger') 
	&& this.HasAbility('qmh210_lamia') 
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Melusine_Original_Death'))
			{
				if (RandF() < ACS_Settings_Main_Float('EHmodAdditionalWorldEncountersSettings','EHmodMelusineEnabled',1))
				{
					if (GetWeatherConditionName() != 'WT_Rain_Storm')
					{
						RequestWeatherChangeTo('WT_Rain_Storm', 5.0, false);
					}

					GetACSWatcher().Lightning_Strike_No_Condition();

					GetACSWatcher().RemoveTimer('MelusineSpawnDelay');
					GetACSWatcher().AddTimer('MelusineSpawnDelay', RandRangeF(10,5), false);
				}

				this.AddTag('ACS_Melusine_Original_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Melusine')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Melusine_Death'))
			{
				ACSGetCActor('ACS_Melusine_Cloud').Destroy();

				ACSGetCActor('ACS_Melusine_Bossbar').Destroy();

				GetACSWatcher().Lightning_Strike_No_Condition_Mult();

				if (GetWeatherConditionName() != 'WT_Clear')
				{
					RequestWeatherChangeTo('WT_Clear', 1.0, false);
				}

				this.AddTag('ACS_Melusine_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Cultist_Boss')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Cultist_Boss_Death'))
			{
				ACS_Cultist_Boss_Siren_Spawn();

				if (!thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_1', 1);
				}
				else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_2', 1);
				}
				else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_3', 1);
				}
				else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_4', 1);
				}
				else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_5', 1);
				}
				else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_6', 1);
				}
				else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_4')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_5')
				&& thePlayer.inv.HasItem('lore_acs_fucusya_6')
				&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
				)
				{
					thePlayer.inv.AddAnItem('lore_acs_fucusya_7', 1);
				}

				this.AddTag('ACS_Cultist_Boss_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Cultist')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Cultist_Singer_Death'))
			{
				ACS_Cultist_Siren_Spawn();

				this.AddTag('ACS_Cultist_Singer_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Cultist_Singer')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Cultist_Death'))
			{
				animatedComponentA = (CAnimatedComponent)this.GetComponentByClassName( 'CAnimatedComponent' );

				anim_names.Clear();

				anim_names.PushBack('woman_sorceress_death_front_01');
				anim_names.PushBack('woman_sorceress_death_front_02');

				animatedComponentA.PlaySlotAnimationAsync ( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animatedComponentA.FreezePoseFadeIn(2);

				this.AddTag('ACS_Cultist_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Pirate_Zombie')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Pirate_Zombie_Despawn'))
			{
				PlayEffectSingle('ethereal_buff');
				PlayEffectSingle('ethereal_debuff');

				SetVisibility(false);

				ACSGetCEntity('ACS_Pirate_Zombie_Trail').Destroy();

				ACSGetCEntity('ACS_Pirate_Zombie_Chest_Bone_1').Destroy();

				ACSGetCEntity('ACS_Pirate_Zombie_Chest_Bone_2').Destroy();

				ACSGetCEntity('ACS_Pirate_Zombie_Chest_Bone_3').Destroy();

				ACSGetCEntity('ACS_Pirate_Zombie_Chest_Bone_4').Destroy();

				this.AddTag('ACS_Pirate_Zombie_Despawn');
			}
		}
	}
	else if(
	this.HasTag('ACS_Incubus')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Incubus_Despawn'))
			{
				StopAllEffects();

				PlayEffect('teleport_in');

				PlayEffect('teleport_out');

				DestroyAfter(5);

				this.AddTag('ACS_Incubus_Despawn');
			}
		}
	}
	else if(
	this.HasTag('ACS_Mage')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Mage_Despawn'))
			{
				StopAllEffects();

				PlayEffect('teleport_in');

				PlayEffect('teleport_out');

				DestroyAfter(10);

				this.AddTag('ACS_Mage_Despawn');
			}
		}
	}
	else if(
	this.HasTag('ACS_Shades_Rogue')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Shades_Rogue_Despawn'))
			{
				GetInventory().RemoveAllItems();

				this.AddTag('ACS_Shades_Rogue_Despawn');
			}
		}
	}
	else if(
	this.HasTag('ACS_Draug')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Draug_Death'))
			{
				animatedComponentA = (CAnimatedComponent)this.GetComponentByClassName( 'CAnimatedComponent' );

				GetACSWatcher().RemoveTimer('ACS_Draug_Anchor_Respawn');

				ACSGetCEntity('ACS_Draug_Fake_Anchor').BreakAttachment();

				ACSGetCEntity('ACS_Draug_Fake_Anchor').Teleport(ACSGetCActor('ACS_Draug').GetWorldPosition() + Vector(0,0,-200));

				ACSGetCEntity('ACS_Draug_Fake_Anchor').DestroyAfter(0.001);

				l_comp = ((CActor)ACSGetCActor('ACS_Draug')).GetComponentsByClassName( 'CMorphedMeshManagerComponent' );
				size = l_comp.Size();

				for ( j=0; j<size; j+= 1 )
				{
					((CMorphedMeshManagerComponent)l_comp[ j ]).SetMorphBlend( 0, 0.001 );
				}

				animatedComponentA.PlaySlotAnimationAsync ( 'giant_death_from_lightning_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animatedComponentA.FreezePoseFadeIn(25);

				this.AddTag('ACS_Draug_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Draugir')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Draugir_Death'))
			{
				StopAllEffects();

				//((CNewNPC)npc).SetVisibility(false);

				PlayEffectSingle('explode');

				PlayEffectSingle('fire_hit');

				PlayEffectSingle('fire_blowing');

				PlayEffectSingle('fire_blowing_2');

				StopAllEffects();

				this.AddTag('ACS_Draugir_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_MegaWraith')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Megawraith_Death'))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').Destroy();

				ACSGetCEntity('ACS_MegaWraith_L_Weapon').Destroy();

				StopEffect('demonic_possession');

				DestroyEffect('critical_burning_green_ex');

				DestroyEffect('critical_burning_green_ex_r');

				this.AddTag('ACS_Megawraith_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Fire_Gryphon')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Fire_Gryphon_Death'))
			{

				this.AddTag('ACS_Fire_Gryphon_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Big_Hym')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Big_Hym_Death'))
			{
				StopAllEffects();

				PlayEffect('avatar_death_swollen');

				SetVisibility(false);

				GetACSWatcher().MiniHymSizeSpeedReset();

				this.AddTag('ACS_Big_Hym_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Guardian_Blood_Hym_Small')
	|| this.HasTag('ACS_Guardian_Blood_Hym_Large')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Guardian_Hym_Death'))
			{
				ACS_Guardian_Hym_Death_Spawn_Ability(this.GetWorldPosition());

				DestroyAfter(0.5);

				this.AddTag('ACS_Guardian_Hym_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Viy_Of_Maribor')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Viy_Death'))
			{
				StopAllEffects();

				this.AddTag('ACS_Viy_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Giant_Troll')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Giant_Troll_Death'))
			{
				animatedComponentA = (CAnimatedComponent)this.GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.PlaySlotAnimationAsync ( 'monster_cave_troll_death_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animatedComponentA.FreezePoseFadeIn(3);

				this.AddTag('ACS_Giant_Troll_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Dark_Knight')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Dark_Knight_Death'))
			{
				DestroyEffect('ghost');
				DestroyEffect('him_smoke_red');
				DestroyEffect('shadow_form');
				DestroyEffect('smoke_effect_1');
				DestroyEffect('smoke_effect_2');

				PlayEffect('death_vision');

				SetVisibility(false);

				this.AddTag('ACS_Dark_Knight_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Dark_Knight_Calidus')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Dark_Knight_Calidus_Death'))
			{
				DestroyEffect('lugos_vision_burning_mat');
				DestroyEffect('burning_body');
				DestroyEffect('him_smoke_red');
				DestroyEffect('shadow_form');
				DestroyEffect('lugos_vision_burning');
				DestroyEffect('smoke_effect_1');
				DestroyEffect('smoke_effect_2');

				PlayEffect('death_vision');

				SetVisibility(false);

				this.AddTag('ACS_Dark_Knight_Calidus_Death');
			}
		}
	}
	else if(
	this.HasTag('ACS_Dwarf')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Dwarf_End_Stage'))
			{
				DisableAgony();

				SetKinematic(false);

				DropItemFromSlot( 'l_weapon', true );
				DropItemFromSlot( 'r_weapon', true );

				AddTimer( 'DelayedDismemberTimer', 0.05f, false );

				this.AddTag('ACS_Dwarf_End_Stage');
			}
		}
	}
	else if(
	this.HasTag('ACS_Vendigo')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Vendigo_End_Stage'))
			{
				StopAllEffects();

				SoundEvent("animals_deer_die");
				SoundEvent("animals_deer_die");
				SoundEvent("animals_deer_die");
				SoundEvent("animals_deer_die");
				SoundEvent("animals_deer_die");
				SoundEvent("animals_deer_die");

				thePlayer.SoundEvent("animals_deer_die");
				thePlayer.SoundEvent("animals_deer_die");
				thePlayer.SoundEvent("animals_deer_die");
				thePlayer.SoundEvent("animals_deer_die");
				thePlayer.SoundEvent("animals_deer_die");
				thePlayer.SoundEvent("animals_deer_die");

				ACS_Vendigo_Release_Thralls();

				this.AddTag('ACS_Vendigo_End_Stage');
			}
		}
	}
	else if(
	this.HasTag('ACS_Swarm_Mother')
	)
	{
		if (!this.IsAlive())
		{
			if(!this.HasTag('ACS_Swarm_Mother_End_Stage'))
			{
				ACSGetCEntityDestroyAll('ACS_Swarm_Mother_Hive');

				this.AddTag('ACS_Swarm_Mother_End_Stage');
			}
		}
	}

	if( isHorse )
	{
		GetHorseComponent().OnKillHorse();
	}
}

@addMethod( CNewNPC ) timer function ACS_NPC_Idle_Action( dt : float, id : int )
{
	var actors, actors2, actorsCultists															: array<CActor>;
	var i, j																					: int;
	var actor, actor2																			: CActor;
	var npc, npc_1																				: CNewNPC;
	var movementAdjustor, movementAdjustorNPC, movementAdjustorBigWraith						: CMovementAdjustor;
	var ticket, ticketNPC, ticket_1																: SMovementAdjustmentRequestTicket;
	var animatedComponentA, animcomp															: CAnimatedComponent;
	var targetDistance, targetDistance_1														: float;
	var dmg																						: W3DamageAction;
	var anim_names																				: array< name >;
	var l_aiTree																				: CAIExecuteAttackAction;

	if (!this.IsAlive())
	{
		RemoveTimer('ACS_NPC_Idle_Action');

		return;
	}

	if(
	this.HasTag('ACS_Svalblod')
	)
	{
		actors2.Clear();

		actors2 = this.GetNPCsAndPlayersInRange( 10, 5, , FLAG_OnlyAliveActors );
		
		if( actors2.Size() > 0 )
		{
			for( j = 0; j < actors2.Size(); j += 1 )
			{
				npc = (CNewNPC)actors2[j];

				actor = actors2[j];

				if (npc.HasTag('ACS_Svalblod_Bossbar'))
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Friendly
					)
					{
						this.SetAttitude(npc, AIA_Friendly);
					}
				}
				else
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Hostile
					)
					{
						this.SetAttitude(npc, AIA_Hostile);
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Svalblod_Bear')
	)
	{
		if (
		GetAttitudeBetween( this, thePlayer ) != AIA_Hostile
		)
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		actors2.Clear();

		actors2 = this.GetNPCsAndPlayersInRange( 10, 5, , FLAG_OnlyAliveActors );
		
		if( actors2.Size() > 0 )
		{
			for( j = 0; j < actors2.Size(); j += 1 )
			{
				npc = (CNewNPC)actors2[j];

				actor = actors2[j];

				if (npc.HasTag('ACS_Svalblod_Bossbar'))
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Friendly
					)
					{
						this.SetAttitude(npc, AIA_Friendly);
					}
				}
				else
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Hostile
					)
					{
						this.SetAttitude(npc, AIA_Hostile);
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Cultist_Boss')
	)
	{
		if (
		GetAttitudeBetween( this, thePlayer ) != AIA_Hostile
		)
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		actors2.Clear();

		actors2 = this.GetNPCsAndPlayersInRange( 10, 5, , FLAG_OnlyAliveActors );
		
		if( actors2.Size() > 0 )
		{
			for( j = 0; j < actors2.Size(); j += 1 )
			{
				npc = (CNewNPC)actors2[j];

				actor = actors2[j];

				if (npc.HasTag('ACS_Cultist_Singer')
				|| npc.HasTag('ACS_Cultist')
				|| npc.HasTag('ACS_Cultist_Boss')
				|| npc.HasTag('ACS_Siren')
				|| npc.HasTag('ACS_Siren_Miniboss')
				|| npc.IsAnimal()
				)
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Friendly
					)
					{
						this.SetAttitude(npc, AIA_Friendly);
					}
				}
				else
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Hostile
					)
					{
						this.SetAttitude(npc, AIA_Hostile);
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Cultist_Singer')
	)
	{
		if (
		GetAttitudeBetween( this, thePlayer ) != AIA_Hostile
		)
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		if (ACS_cultist_singer_can_sing())
		{
			ACS_refresh_cultist_singer_song_cooldown();

			if (this.IsAlive())
			{
				animcomp = (CAnimatedComponent)this.GetComponentByClassName('CAnimatedComponent');

				anim_names.Clear();

				anim_names.PushBack('woman_work_stand_praying_loop_01');
				anim_names.PushBack('woman_work_stand_praying_loop_02');
				anim_names.PushBack('woman_work_stand_praying_loop_03');

				animcomp.PlaySlotAnimationAsync ( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				this.SoundEvent("qu_sk_210_siren_singing");

				this.SoundEvent("qu_sk_210_siren_singing_alt");

				actorsCultists.Clear();

				actorsCultists = this.GetNPCsAndPlayersInRange( 15, 15, , FLAG_ExcludePlayer );

				if( actorsCultists.Size() > 0 )
				{
					for( j = 0; j < actorsCultists.Size(); j += 1 )
					{
						if (actorsCultists[j].HasTag('ACS_Cultist')
						|| actorsCultists[j].HasTag('ACS_Cultist_Boss')
						)
						{
							actorsCultists[j].GainStat(BCS_Essence, actorsCultists[j].GetStatMax(BCS_Essence) * 0.05 );

							actorsCultists[j].GainStat( BCS_Morale, actorsCultists[j].GetStatMax( BCS_Morale ) );  

							actorsCultists[j].GainStat( BCS_Focus, actorsCultists[j].GetStatMax( BCS_Focus ) );  
								
							actorsCultists[j].GainStat( BCS_Stamina, actorsCultists[j].GetStatMax( BCS_Stamina ) );
						}
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Pirate_Zombie')
	)
	{
		if (this.IsEffectActive('special_attack_fx'))
		{
			this.StopEffect('special_attack_fx');
		}

		if (this.IsEffectActive('special_attack_only_black_fx'))
		{
			this.StopEffect('special_attack_only_black_fx');
		}
	}
	else if(
	this.HasTag('ACS_Melusine_Cloud')
	)
	{
		if (ACS_melusine_ability_switch())
		{
			ACS_refresh_melusine_ability_switch_cooldown();

			if (this.HasAbility('DjinnRage'))
			{
				this.AddAbility('DjinnWeak');

				this.RemoveAbility('DjinnRage');
			}
			else if (this.HasAbility('DjinnWeak'))
			{
				this.AddAbility('DjinnRage');

				this.RemoveAbility('DjinnWeak');
			}
		}

		if (ACS_melusine_cloud_can_attack())
		{
			ACS_refresh_melusine_cloud_attack_cooldown();

			if (this.HasAbility('DjinnRage'))
			{ 
				ACS_MelusineCloudTesla();
			}
			else if (this.HasAbility('DjinnWeak'))
			{
				l_aiTree = new CAIExecuteAttackAction in this;

				l_aiTree.OnCreated();

				l_aiTree.attackParameter = EAT_Attack1;
				
				this.ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);
			}
		}
	}
	else if(
	this.HasTag('ACS_MegaWraith')
	)
	{
		if (this.IsEffectActive('appear', false))
		{
			if (!this.IsEffectActive('demonic_possession', false))
			{
				this.PlayEffectSingle('demonic_possession');
			}

			if (!this.IsEffectActive('critical_burning_green_ex', false))
			{
				this.PlayEffectSingle('critical_burning_green_ex');
			}

			if (!this.IsEffectActive('critical_burning_green_ex_r', false))
			{
				this.PlayEffectSingle('critical_burning_green_ex_r');
			}

			if (!this.IsEffectActive('candle', false))
			{
				this.PlayEffectSingle('candle');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword1_fire_trail_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword_quen', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword_quen');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword1_fire_trail_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword_quen', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword_quen');
			}

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').CreateAttachment(this, 'attach_slot_l', Vector(0.1,-0.025,0), EulerAngles(180,0,0));

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').CreateAttachment(this, 'attach_slot_r', Vector(0.1,0.025,0), EulerAngles(0,0,0));

			return;
		}

		if (!this.IsEffectActive('disappear', false))
		{
			if (!this.IsEffectActive('demonic_possession', false))
			{
				this.PlayEffectSingle('demonic_possession');
			}

			if (!this.IsEffectActive('critical_burning_green_ex', false))
			{
				this.PlayEffectSingle('critical_burning_green_ex');
			}

			if (!this.IsEffectActive('critical_burning_green_ex_r', false))
			{
				this.PlayEffectSingle('critical_burning_green_ex_r');
			}

			if (!this.IsEffectActive('candle', false))
			{
				this.PlayEffectSingle('candle');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword1_fire_trail_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword_quen', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword_quen');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword1_fire_trail_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword_quen', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword_quen');
			}

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').CreateAttachment(this, 'attach_slot_l', Vector(0.1,-0.025,0), EulerAngles(180,0,0));

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').CreateAttachment(this, 'attach_slot_r', Vector(0.1,0.025,0), EulerAngles(0,0,0));
		}
		else
		{
			this.DestroyEffect('demonic_possession');

			this.DestroyEffect('critical_burning_green_ex');

			this.DestroyEffect('critical_burning_green_ex_r');

			this.DestroyEffect('candle');

			

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('igni_power_green');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('quen_power');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('runeword1_fire_trail_green');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('runeword_quen');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('runeword_igni_green');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('light_trail_extended_fx');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('wraith_trail');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').DestroyEffect('special_trail_fx');



			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('igni_power_green');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('quen_power');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('runeword1_fire_trail_green');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('runeword_quen');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('runeword_igni_green');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('light_trail_extended_fx');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('wraith_trail');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').DestroyEffect('special_trail_fx');




			ACSGetCEntity('ACS_MegaWraith_L_Weapon').BreakAttachment();

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').Teleport(this.GetWorldPosition() + Vector(0,0,-200));

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').BreakAttachment();

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').Teleport(this.GetWorldPosition() + Vector(0,0,-200));
		}

		if ( ((CActor)(this.GetTarget())) )
		{
			targetDistance = VecDistanceSquared2D( ((CActor)(this.GetTarget())).GetWorldPosition(), this.GetWorldPosition() ) ;

			movementAdjustorBigWraith = this.GetMovingAgentComponent().GetMovementAdjustor();

			ticket_1 = movementAdjustorBigWraith.GetRequest( 'ACS_MegaWraith_Rotate');
			movementAdjustorBigWraith.CancelByName( 'ACS_MegaWraith_Rotate' );
			movementAdjustorBigWraith.CancelAll();

			ticket_1 = movementAdjustorBigWraith.CreateNewRequest( 'ACS_MegaWraith_Rotate' );
			movementAdjustorBigWraith.AdjustmentDuration( ticket_1, 1 );

			movementAdjustorBigWraith.MaxRotationAdjustmentSpeed( ticket_1, 50000000 );

			if (targetDistance <= 4*4)
			{
				movementAdjustorBigWraith.RotateTowards(ticket_1, ((CActor)(this.GetTarget())));
			}
			else
			{
				movementAdjustorBigWraith.CancelByName( 'ACS_MegaWraith_Rotate' );
			}
		}

		if (
		GetAttitudeBetween( this, thePlayer ) != AIA_Hostile
		)
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		actors2.Clear();

		actors2 = this.GetNPCsAndPlayersInRange( 10, 5, , FLAG_OnlyAliveActors );
		
		if( actors2.Size() > 0 )
		{
			for( j = 0; j < actors2.Size(); j += 1 )
			{
				npc_1 = (CNewNPC)actors2[j];

				actor2 = actors2[j];

				if (npc_1.IsAnimal()
				|| npc_1.HasTag('ACS_MegaWraith_Minion')
				)
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Friendly
					)
					{
						this.SetAttitude(npc, AIA_Friendly);
					}
				}
				else
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Hostile
					)
					{
						this.SetAttitude(npc, AIA_Hostile);
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Necrofiend')
	)
	{
		if (this.IsAlive())
		{
			this.StopEffect('spike');
			this.PlayEffect('spike');

			this.StopEffect('spikes_explode_after');
			this.PlayEffect('spikes_explode_after');
		}
		else
		{
			return;
		}

		if (
		GetAttitudeBetween( this, thePlayer ) != AIA_Hostile
		)
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		actors2.Clear();

		actors2 = this.GetNPCsAndPlayersInRange( 10, 5, , FLAG_OnlyAliveActors );
		
		if( actors2.Size() > 0 )
		{
			for( j = 0; j < actors2.Size(); j += 1 )
			{
				npc = (CNewNPC)actors2[j];

				actor = actors2[j];

				if (npc.HasTag('ACS_Necrofiend')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_4')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_3')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_2')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_1')
				|| npc.HasTag('ACS_Necrofiend_Adds')
				)
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Friendly
					)
					{
						this.SetAttitude(npc, AIA_Friendly);
					}
				}
				else
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Hostile
					)
					{
						this.SetAttitude(npc, AIA_Hostile);
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Shades_Hunter')
	)
	{
		if (ACS_ShadesItemEquippedCheck())
		{
			((CNewNPC)this).SetAttitude(thePlayer, AIA_Hostile);
		}
		else
		{
			targetDistance = VecDistanceSquared2D( ((CNewNPC)this).GetWorldPosition(), thePlayer.GetWorldPosition() ) ;

			if (targetDistance <= 4 * 4)
			{
				((CNewNPC)this).SetAttitude(thePlayer, AIA_Hostile);
			}
		}
	}
	else if(
	this.HasTag('ACS_Nekurat')
	)
	{
		((CNewNPC)this).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = this.GetNPCsAndPlayersInRange( 10, 5, , FLAG_OnlyAliveActors );
		
		if( actors2.Size() > 0 )
		{
			for( j = 0; j < actors2.Size(); j += 1 )
			{
				npc = (CNewNPC)actors2[j];

				actor = actors2[j];

				if (npc.HasTag('ACS_Nekurat') 
				|| npc.HasTag('ACS_Blade_Of_The_Unseen')
				|| npc.HasAbility('mon_vampiress_base')
				)
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Friendly
					)
					{
						this.SetAttitude(npc, AIA_Friendly);
					}
				}
				else
				{
					if (
					GetAttitudeBetween( this, npc ) != AIA_Hostile
					)
					{
						this.SetAttitude(npc, AIA_Hostile);
					}
				}
			}
		}
	}
	else if(
	this.HasTag('ACS_Cloak_Vamp')
	)
	{
		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		if (
			this.IsInCombat()
		)
		{
			if (!this.HasTag('ACS_Cloak_Vamp_In_Combat'))
			{
				this.AddTag('ACS_Cloak_Vamp_In_Combat');
			}
		}

		if (!this.HasTag('ACS_Cloak_Vamp_In_Combat'))
		{
			((CActor)this).GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - this.GetWorldPosition()));

			if (targetDistance <= 15 * 15)
			{
				((CActor)this).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1);
			}
		}
	}
	else if(
	this.HasTag('ACS_Lynx_Witcher')
	)
	{
		if (!this.IsAlive())
		{
			RemoveTimer('ACS_Lynx_Witcher_Combat_Check');

			return;
		}

		targetDistance = VecDistanceSquared2D( ((CActor)this).GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		animatedComponentA = (CAnimatedComponent)(((CActor)this)).GetComponentByClassName( 'CAnimatedComponent' );	

		((CActor)this).SetAttitude(thePlayer, AIA_Hostile);

		if (!this.IsInCombat())
		{
			animatedComponentA.PlaySlotAnimationAsync ( 'meditation_idle01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}

		if (targetDistance <= 10 * 10 && GetWitcherPlayer().IsOnGround())
		{
			if (!this.HasTag('ACS_Lynx_Witcher_Combat'))
			{
				dmg = new W3DamageAction in theGame.damageMgr;
					
				dmg.Initialize(GetWitcherPlayer(), ((CActor)this), NULL, GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);

				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	

				animatedComponentA.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				this.PlayEffectSingle('shadowdash');
				this.StopEffect('shadowdash');

				this.SoundEvent("bomb_dragons_dream_explo");

				ACS_LynxWitcherSmokeScreen(this, this.GetWorldPosition());

				this.AddTag('ACS_Lynx_Witcher_Combat');
			}
		}

		if (this.HasTag('ACS_Lynx_Witcher_Stealth'))
		{
			((CActor)this).SetTatgetableByPlayer(false);
		}
		else
		{
			((CActor)this).SetTatgetableByPlayer(true);
		}
	}
	else if (this.HasTag('ACS_Knightmare_Eternum'))
	{
		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), this.GetWorldPosition() );

		if ( targetDistance <= 10 * 10 )
		{
			if 
			(
				!this.HasAbility('EtherealActive') 
			)
			{
				this.SoundEvent("qu_209_two_sirens_sing_loop_stop");
				this.SoundEvent("magic_olgierd_ethereal_wake");

				this.PlayEffectSingle('demonic_possession');

				this.PlayEffectSingle('ethereal_buff');
				this.StopEffect('ethereal_buff');

				if (GetWeatherConditionName() != 'WT_Rain_Storm')
				{
					RequestWeatherChangeTo('WT_Rain_Storm', 1.0, false);
				}

				this.AddAbility('EtherealActive');
			}
		}
	}
	else if(
	this.HasTag('ACS_Nekker_Guardian')
	)
	{
		if (
		GetAttitudeBetween( this, thePlayer ) != AIA_Hostile
		)
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		if( targetDistance > 30 * 30 ) 
		{
			if (!this.IsInCombat())
			{
				this.Destroy();
			}
		}
	}
	else if(
	this.HasTag('ACS_Summoned_Construct_1')
	|| this.HasTag('ACS_Summoned_Construct_2')
	)
	{
		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		movementAdjustorNPC = this.GetMovingAgentComponent().GetMovementAdjustor();

		thePlayer.SetAttitude(this, AIA_Friendly);

		this.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Summoned_Construct_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Summoned_Construct_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Summoned_Construct_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		if (!this.IsInCombat())
		{
			if (targetDistance <= 2 * 2)
			{
				this.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0);
			}
			else if (targetDistance > 2 * 2 && targetDistance <= 15 * 15)
			{
				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				this.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(2);
			}
			else if (targetDistance > 15 * 15 && GetWitcherPlayer().IsOnGround())
			{
				if (!this.IsEffectActive('shadowdash_body_blood', false))
				{
					this.PlayEffectSingle('shadowdash_body_blood');
				}

				if (!this.HasTag('ACS_Summoned_Construct_Teleport_Start'))
				{
					this.PlayEffectSingle('shadowdash');
					this.StopEffect('shadowdash');

					GetACSWatcher().RemoveTimer('SummonedConstruct1TeleportDelay');
					GetACSWatcher().AddTimer('SummonedConstruct1TeleportDelay', 0.5, false);

					this.AddTag('ACS_Summoned_Construct_Teleport_Start');
				}
			} 
		}

		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 25, 20, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

		if( actors.Size() > 0 )
		{
			this.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0);

			if (!this.IsEffectActive('claws_trail', false))
			{
				this.PlayEffectSingle('claws_trail');
			}

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];
				
				if (GetAttitudeBetween( thePlayer, npc ) != AIA_Friendly
				)
				{
					this.SetAttitude(npc, AIA_Hostile);
				}
			}
		}
		
		if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
		{
			if (targetDistance > 35 * 35 && GetWitcherPlayer().IsOnGround())
			{
				if (!this.IsEffectActive('shadowdash_body_blood', false))
				{
					this.PlayEffectSingle('shadowdash_body_blood');
				}

				if (!this.HasTag('ACS_Summoned_Construct_Teleport_Start'))
				{
					this.PlayEffectSingle('shadowdash');
					this.StopEffect('shadowdash');

					if(
					this.HasTag('ACS_Summoned_Construct_1')
					)
					{
						GetACSWatcher().RemoveTimer('SummonedConstruct1TeleportDelay');
						GetACSWatcher().AddTimer('SummonedConstruct1TeleportDelay', 0.5, false);
					}
					else if(
					this.HasTag('ACS_Summoned_Construct_2')
					)
					{
						GetACSWatcher().RemoveTimer('SummonedConstruct2TeleportDelay');
						GetACSWatcher().AddTimer('SummonedConstruct2TeleportDelay', 0.5, false);
					}

					this.AddTag('ACS_Summoned_Construct_Teleport_Start');
				}
			}
		}
	}
	else
	{
		RemoveTimer('ACS_NPC_Idle_Action');
	}
}

@addMethod( CNewNPC ) timer function ACS_Human_Charge_Attack_Interrupt( dt : float, id : int )
{
	if (!this.IsAlive())
	{
		RemoveTimer('ACS_Human_Charge_Attack_Interrupt');

		return;
	}

	if(
	!this.IsHuman()
	|| this.GetAttitude( thePlayer ) != AIA_Hostile
	)
	{
		return;
	}

	if(
	this.IsHuman()
	)
	{
		if (this.HasTag('ACS_Swapped_To_Shield')
		|| this.HasTag('ACS_Swapped_To_Vampire')
		|| this.HasTag('ACS_Swapped_To_1h_Sword')
		|| this.HasTag('ACS_Swapped_To_2h_Sword')
		|| this.HasTag('ACS_Swapped_To_Witcher')
		|| this.HasTag('ACS_Final_Fear_Stack')
		)
		{
			this.SignalGameplayEvent( 'InterruptChargeAttack' );
		}
		else 
		{
			if( RandF() < 0.25 )
			{
				this.SignalGameplayEvent( 'InterruptChargeAttack' );
			}
		}
	}
}

@addMethod( CNewNPC ) timer function ACS_Ice_Breath_Controller_Delay_Spawn( dt : float, id : int )
{
	var ents  									: array<CGameplayEntity>;
	var temp									: CEntityTemplate;
	var controller								: CEntity;
	var voiceTagName 							: name;
	var voiceTagStr								: string;
	var appearanceName 							: name;
	var appearanceStr							: string;
	var bonePosition							: Vector;
	var boneRotation							: EulerAngles;

	if (!this.IsAlive())
	{
		RemoveTimer('ACS_Ice_Breath_Controller_Delay_Spawn');

		return;
	}

	if(
	this.IsHuman()
	|| this.IsMan()
	|| this.IsWoman()
	|| StrFindFirst(voiceTagStr, "BOY") >= 0
	|| StrFindFirst(voiceTagStr, "GIRL") >= 0
	|| StrFindFirst(appearanceStr, "BOY") >= 0
	|| StrFindFirst(appearanceStr, "GIRL") >= 0
	)
	{
		if 
		( 
		this.HasTag('ACS_Ice_Breathe_Controller_Added') 
		)
		{
			RemoveTimer('ACS_Ice_Breath_Controller_Delay_Spawn');
			return;
		}

		if (!this.HasTag('ACS_Ice_Breathe_Controller_Added'))
		{
			temp = (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\acs_ice_breathe.w2ent"
			
			, true );

			if(
			this.IsWoman()
			)
			{
				this.GetBoneWorldPositionAndRotationByIndex( this.GetBoneIndex( 'hroll' ), bonePosition, boneRotation );
				controller = (CEntity)theGame.CreateEntity( temp, this.GetWorldPosition() + Vector( 0, 0, -10 ) );
				controller.CreateAttachmentAtBoneWS( this, 'hroll', bonePosition, boneRotation );
			}
			else
			{
				this.GetBoneWorldPositionAndRotationByIndex( this.GetBoneIndex( 'head' ), bonePosition, boneRotation );
				controller = (CEntity)theGame.CreateEntity( temp, this.GetWorldPosition() + Vector( 0, 0, -10 ) );
				controller.CreateAttachmentAtBoneWS( this, 'head', bonePosition, boneRotation );
			}

			controller.AddTag('ACS_Ice_Breathe_Controller');

			this.AddTag('ACS_Ice_Breathe_Controller_Added');
		}
	}
}

@addMethod( CNewNPC ) timer function ACS_Crawl_Controller_Delay_Spawn( dt : float, id : int )
{
	var crawl_temp								: CEntityTemplate;
	var crawl_controller						: CEntity;

	if (!this.IsAlive())
	{
		RemoveTimer('ACS_Crawl_Controller_Delay_Spawn');

		return;
	}

	if(
	this.IsHuman()
	&& !this.HasTag('ACS_Rat_Mage')
	&& !this.HasTag('ACS_Dwarf')
	)
	{
		if (!this.HasTag('ACS_Crawl_Controller_Attached'))
		{
			crawl_temp = (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\other\human_death_crawl_controller.w2ent"
			
			, true );

			crawl_controller = (CEntity)theGame.CreateEntity( crawl_temp, this.GetWorldPosition() + Vector( 0, 0, -20 ) );

			crawl_controller.CreateAttachment( this, 'blood_point', Vector(0,0,0), EulerAngles(0,0,0) );

			this.AddTag('ACS_Crawl_Controller_Attached');
		}
	}
}

@addMethod( CNewNPC ) timer function ACS_DelayedWolfAttitudeSet( dt : float, id : int )
{
	
	if (!this.IsAlive() || thePlayer.IsCiri())
	{
		if (thePlayer.IsCiri() && this.HasAbility('mon_wolf_base'))
		{
			this.SetAttitude(thePlayer, AIA_Hostile);
		}

		RemoveTimer('ACS_DelayedWolfAttitudeSet');

		return;
	}

	if (this.HasAbility('mon_wolf_base')
	&& !this.HasAbility('mon_wolf_summon_were')
	&& !this.HasAbility('mon_evil_dog')
	&& !this.HasTag('ACS_Shadow_Wolf')
	&& !this.HasTag('ACS_MonsterHunt_Woodland_Spirit_Wolf')
	&& !this.UsesEssence()
	&& !this.IsInInterior()
	&& this.GetNPCType() != ENGT_Quest
	)
	{
		this.SetAttitude(thePlayer, AIA_Neutral);

		this.SetAttitude(thePlayer.GetHorseWithInventory(), AIA_Neutral);
	}
}

@addField(CNewNPC)
private saved var acs_animalActionID 		: int;

@addField(CNewNPC)
private saved var acs_animal_l_aiTree		: CAIFollowSideBySideAction;

@addMethod( CNewNPC ) timer function ACS_Animal_Controller( dt : float, id : int )
{
	var targetDistance									: float;

	if (!this.IsAlive() || !this.IsAnimal())
	{
		RemoveTimer('ACS_Animal_Controller');

		return;
	}

	if (!thePlayer.HasTag('ACS_Animal_Attract'))
	{
		if ( this.HasTag('ACS_Animal_Enthralled') )
		{
			this.CancelAIBehavior(acs_animalActionID);
			delete acs_animal_l_aiTree;

			this.RemoveTag('ACS_Animal_Enthralled');
		}

		return;
	}

	if (this.IsAnimal() && thePlayer.HasTag('ACS_Animal_Attract'))
	{
		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), this.GetWorldPosition() );

		if(targetDistance <= 20*20
		)
		{
			if ( !this.HasTag('ACS_Animal_Enthralled') )
			{
				acs_animal_l_aiTree = new CAIFollowSideBySideAction in this;
				acs_animal_l_aiTree.OnCreated();
				acs_animal_l_aiTree.params.targetTag = 'PLAYER';
				acs_animal_l_aiTree.params.moveSpeed = 6;
				acs_animal_l_aiTree.params.teleportToCatchup = true;

				acs_animalActionID = this.ForceAIBehavior(acs_animal_l_aiTree, BTAP_Emergency);

				this.AddTag('ACS_Animal_Enthralled');
			}
		}
		else if(targetDistance > 20*20 )
		{
			if ( this.HasTag('ACS_Animal_Enthralled') )
			{
				this.CancelAIBehavior(acs_animalActionID);
				delete acs_animal_l_aiTree;

				this.RemoveTag('ACS_Animal_Enthralled');
			}
		}
	}
}

/*
@addField(Exploration)
private var acs_last_panic_drain_time : float;

@addField(Exploration)
private var acs_swimProgress 		: float;

@addField(Exploration)
private var acs_swim_multiplier : float;

@addField(Exploration)
private var acs_horsePos : Vector;

@addField(Exploration)
private var acs_horseRot, acs_playerRot : EulerAngles;

@addMethod(Exploration) function ACS_Can_Add_Panic_Underwater(): bool 
{
	return theGame.GetEngineTimeAsSeconds() - acs_last_panic_drain_time > 0.1;
}

@addMethod(Exploration) function ACS_Refresh_Add_Panic_Underwater_Cooldown() 
{
	acs_last_panic_drain_time = theGame.GetEngineTimeAsSeconds();
}

@wrapMethod(Exploration) function UpdateLogic( dt : float )
{
	var actorParent : CActor;
	var player : W3PlayerWitcher;
	var slidingDisablesControll : bool;
	var waterDepth, z : float;
	var lookatPos : Vector;

	if(false) 
	{
		wrappedMethod(dt);
	}
	
	if(!thePlayer.GetIsHorseRacing())
		parentActor.SetBehaviorVariable( 'isRearingEnabled', 1.0 );
	else
		parentActor.SetBehaviorVariable( 'isRearingEnabled', 0.0 );

	waterDepth = GetSubmergeDepth();
	parentActor.SetBehaviorVariable( 'submergeDepth', ClampF( waterDepth, -5.0, 5.0 ) );

	if(waterDepth < -0.6f)
	{
		lookatPos = parentActor.GetWorldPosition() + VecConeRand(parentActor.GetHeading(), 0, 5,5) + Vector(0,0,2);
		
		parentActor.SetBehaviorVectorVariable( 'lookAtTarget', lookatPos );
		parentActor.SetBehaviorVariable( 'headWaterDepth', ClampF(-waterDepth/1.5, 0, 1) );
		parentActor.SetBehaviorVariable( 'lookatOn', 1.0f );
	}
	else
	{
		parentActor.SetBehaviorVariable( 'headWaterDepth', 0.f );
	}

	acs_horsePos = parentActor.GetWorldPosition();

	acs_horseRot = parentActor.GetWorldRotation();

	if (
	waterDepth < -1
	&& acs_horsePos.Z < theGame.GetWorld().GetWaterLevel(acs_horsePos, true)
	)
	{
		ResetSoundParameters();

		if (!parentActor.HasTag('ACS_Horse_Is_Swimming'))
		{
			//Jump();

			parentActor.AddTag('ACS_Horse_Is_Swimming');
		}

		(parentActor.GetMovingAgentComponent()).SetEnabledFeetIK(false,0.01);

		(parentActor.GetMovingAgentComponent()).SetEnabledSlidingOnSlopeIK(false);

		if (theInput.GetActionValue('HorseJump') > 0)
		{
			parentActor.EnableCollisions(true);

			if( waterDepth < -2.f && ACS_Can_Add_Panic_Underwater())
			{
				ACS_Refresh_Add_Panic_Underwater_Cooldown();

				parentActor.AddPanic(1);

				if (parentActor.GetStat( BCS_Panic ) <= 0)
				{
					OnHideHorse();
				}
			}

			acs_horsePos.Z -= 0.5;
		}
		else
		{
			parentActor.EnableCollisions(false);

			if (
			waterDepth < -1.65f
			)
			{
				acs_horsePos.Z += 0.5;
			}
			else
			{
				acs_horsePos.Z -= 0.5;
			}
		}

		parent.InternalSetSpeedMultiplier( 0.5f );

		if(theInput.GetActionValue('Gallop') > 0)
		{
			acs_swim_multiplier = 15.75;
			parent.InternalSetSpeed( GALLOP_SPEED );
		}
		else
		{
			if(theInput.GetActionValue('Canter') > 0)
			{
				acs_swim_multiplier = 10.25;
				parent.InternalSetSpeed( CANTER_SPEED );
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') > 0 
				|| theInput.GetActionValue('GI_AxisLeftX') > 0
				)
				{
					acs_swim_multiplier = 5.125;
					parent.InternalSetSpeed( TROT_SPEED );
				}
				else
				{
					acs_swimProgress -= acs_swimProgress;

					acs_swim_multiplier = 5.125;

					parent.InternalSetSpeed( WALK_SPEED );
				}
			}
		}

		acs_horsePos += 0.5*VecConeRand(theCamera.GetCameraHeading(), 0.001,theInput.GetActionValue('GI_AxisLeftY') * acs_swim_multiplier, theInput.GetActionValue('GI_AxisLeftY') * acs_swim_multiplier);	

		acs_horsePos -= 0.5*VecConeRand(theCamera.GetCameraHeading()+90, 5, theInput.GetActionValue('GI_AxisLeftX') * acs_swim_multiplier/2 , theInput.GetActionValue('GI_AxisLeftX') * acs_swim_multiplier/2 );

		theGame.GetWorld().NavigationComputeZ( acs_horsePos, acs_horsePos.Z - 128, acs_horsePos.Z + 128, z );

		if(z > acs_horsePos.Z)
		{
			acs_horsePos.Z = z;
		}

		acs_playerRot = theCamera.GetCameraRotation();

		acs_horseRot.Yaw = AngleApproach( acs_playerRot.Yaw, acs_horseRot.Yaw, 1.5 );

		if (theInput.GetActionValue('GI_AxisLeftY') > 0 
		|| theInput.GetActionValue('GI_AxisLeftX') > 0
		|| theInput.GetActionValue('Gallop') > 0
		|| theInput.GetActionValue('Canter') > 0
		)
		{
			parentActor.TeleportWithRotation(LerpV(parentActor.GetWorldPosition(), acs_horsePos, acs_swimProgress), acs_horseRot);
			
		}
		else
		{
			parentActor.Teleport(LerpV(parentActor.GetWorldPosition(), acs_horsePos, acs_swimProgress));
		}

		if (acs_swimProgress >= 0.01)
		{
			acs_swimProgress = 0.01;
		}
		else
		{
			acs_swimProgress += 0.00005;
		}
	}
	else
	{
		if (parentActor.HasTag('ACS_Horse_Is_Swimming'))
		{
			acs_swimProgress -= acs_swimProgress;

			Jump();

			theGame.GetWorld().NavigationComputeZ( acs_horsePos, acs_horsePos.Z - 128, acs_horsePos.Z + 128, z );

			if(z > acs_horsePos.Z)
			{
				acs_horsePos.Z = z;
			}

			parentActor.Teleport(LerpV(parentActor.GetWorldPosition(), acs_horsePos, 0.01f));

			parentActor.EnableCollisions(true);

			(parentActor.GetMovingAgentComponent()).SetEnabledFeetIK(true,4);

			(parentActor.GetMovingAgentComponent()).SetEnabledSlidingOnSlopeIK(true);

			parentActor.RemoveTag('ACS_Horse_Is_Swimming');
		}
	}

	if( roadFollowBlock > 0.0 )
	{
		roadFollowBlock -= dt;
		if( roadFollowBlock < 0.0 )
			roadFollowBlock = 0.0;
	}
	
	useSimpleStaminaManagement = parent.ShouldUseSimpleStaminaManagement();
	
	if( thePlayer.GetIsMovable() && IsHorseControllable() && !dismountRequest && !slidingDisablesControll )
	{
		rl = theInput.GetActionValue( 'GI_AxisLeftX' );
		fb = theInput.GetActionValue( 'GI_AxisLeftY' );
	}
	else
	{
		rl = 0.0;
		fb = 0.0;
	}
	
	isReversing	= false;
	if(currSpeed == MIN_SPEED && fb < 0.f && parent.lastRider == thePlayer )
	{
		isReversing	= true;
	}	
	
	SetTimeoutForCurrentSpeed();
	MaintainCameraVariables( dt );
	
	
	if( ( !useSimpleStaminaManagement && destSpeed > GALLOP_SPEED ) || ( !IsSpeedLocked() && destSpeed > MIN_SPEED && !rl && !fb ) || ( !IsSpeedLocked() && destSpeed > TROT_SPEED ) )
	{
		if( maintainSpeedTimer > speedTimeoutValue )
		{
			destSpeed = MaxF( MIN_SPEED, destSpeed - 1.f );
			maintainSpeedTimer = 0.0;
		}
		else
		{
			maintainSpeedTimer += dt;
		}
	}
	
	actorParent = (CActor)parent.GetEntity();
	
	if ( useSimpleStaminaManagement && currSpeed > GALLOP_SPEED && !isFollowingRoad )
	{
		
		if(thePlayer.GetIsHorseRacing())
			actorParent.DrainStamina( ESAT_FixedValue, 3.33f*dt, 1.f, '', 0.f, 1.f );
		else
			actorParent.DrainStamina( ESAT_FixedValue, 3.33f*dt, 1.f, '', 0.f, 0.45f );
		
		if ( actorParent.GetStat( BCS_Stamina ) <= 0.f )
		{
			staminaBreak = true;
			staminaCooldownTimer = 0.f;
			theGame.VibrateControllerVeryLight();	
		}
	}
	
	destSpeed = MinF( destSpeed, speedRestriction );
	
	if( currSpeed > destSpeed && currSpeed < GALLOP_SPEED )
		PlayVoicesetSlowerHorse();
	
	ProcessControlInput( rl, fb, dt, parent.IsControllableInLocalSpace() || parent.riderSharedParams.mountStatus == VMS_mountInProgress );
	
	if( requestJump )
	{
		if( PerformObstructionJumpTest() && PerformWaterJumpTest() && PerformFallJumpTest() )
		{
			Jump();
		}
		else
		{
			if( !isRefusingToGo && parent.isInIdle && CanPlayCollisionAnim() && !isReversing ) 
			{
				parent.GenerateEvent( 'WallCollision' );
				collisionAnimTimestamp = theGame.GetEngineTimeAsSeconds();
			}
			requestJump = false;
		}
	}
	
	if( staminaBreak )
	{
		if ( staminaCooldownTimer > staminaCooldown )
		{
			staminaBreak = false;
		}
		
		staminaCooldownTimer += dt;
		
		
		if(!isReversing)
			currSpeed = MinF( GALLOP_SPEED, currSpeed );			
		
		
		destSpeed = currSpeed;
	}
	

	if ( currSpeed != destSpeed )
	{
		
		if(!isReversing)
			currSpeed = destSpeed;
		
		
		if ( currSpeed == MIN_SPEED && !parent.isInIdle )
			isSlowlyStopping = true;
		else
			isSlowlyStopping = false;
	}
	
	if (!parentActor.HasTag('ACS_Horse_Is_Swimming'))
	{
		parent.InternalSetSpeedMultiplier( 1.f );
		parent.InternalSetSpeed( currSpeed );
	}
	
	
	if(parent.lastRider == thePlayer)
	{
		parent.SetDistanceBasedSpeed( VecDistance(cachedPos,parent.GetWorldPosition()) );	
		cachedPos = parent.GetWorldPosition();
	
		if(isReversing)
			parentActor.SetBehaviorVariable( 'reverse', 1.0f );	
		else
			parentActor.SetBehaviorVariable( 'reverse', 0.0f );	
	}
	
	CalculateSoundParameters( dt );
	thePlayer.SoundParameter( "horse_speed", currSpeedSound, 'head' ); 
	actorParent.SoundParameter( "horse_stamina", actorParent.GetStatPercents( BCS_Stamina ) * 100 ); 
}

@wrapMethod(Exploration) function CanPlayVoiceset( _currentTime : float ) : bool
{
	var waterDepth, z : float;

	waterDepth = GetSubmergeDepth();

	if (
	waterDepth < -2
	)
	{
		return false;
	}

	return wrappedMethod(_currentTime);
}

@wrapMethod(Exploration) function OnLeaveState( nextStateName : name )
{
	var lookatPos : Vector;
	var waterDepth, z : float;

	if(false) 
	{
		wrappedMethod(nextStateName);
	}

	CleanUpJump();
	ResetForceStop();
	Restore();
	UnregisterInput();

	waterDepth = GetSubmergeDepth();

	if (
	waterDepth < -1
	)
	{
		lookatPos = parentActor.GetWorldPosition() + VecConeRand(parentActor.GetHeading(), 0, 5,5) + Vector(0,0,2);
		
		parentActor.SetBehaviorVectorVariable( 'lookAtTarget', lookatPos );
		parentActor.SetBehaviorVariable( 'headWaterDepth', ClampF(-waterDepth/1.5, 0, 1) );
		parentActor.SetBehaviorVariable( 'lookatOn', 1.0f );

		parent.InternalSetSpeed( WALK_SPEED );
	}
	else
	{
		mac.SetEnabledFeetIK(true);
	}

	super.OnLeaveState( nextStateName );
}
*/

@addMethod(CR4HudModuleBase) function ACS_GetResolutionWidth() : float
{
	return curResolutionWidth;
}

@addMethod(CR4HudModuleBase) function ACS_GetResolutionHeight() : float
{
	return curResolutionHeight;
}

/*
@wrapMethod(CR4HudModuleMinimap2) function DoFading( fadeOut : bool,  immediately : bool )
{
	if(false)
	{
		wrappedMethod(fadeOut, immediately);
	}

	return;
}

@wrapMethod(CR4HudModuleMinimap2) function FadeMinimapOut(dt : float)
{		
	if(false)
	{
		wrappedMethod(dt);
	}

	return;
}

@wrapMethod(CR4HudModuleQuests) function FadeObjectiveOut(dt : float)
{		
	if(false)
	{
		wrappedMethod(dt);
	}

	return;
}

@wrapMethod(CR4HudModuleMinimap2) function DoFading( fadeOut : bool,  immediately : bool )
{
	if(false)
	{
		wrappedMethod(fadeOut, immediately);
	}

	return;
}
*/

@addMethod(CR4Player) function ACS_ProcessWeaponCollision()
{
	var l_stateName			: name;
	var l_weaponPosition	: Vector;
	var l_weaponTipPos		: Vector;
	var l_collidingPosition	: Vector;
	var l_offset			: Vector;
	var l_normal			: Vector;
	var l_slotMatrix		: Matrix;
	var l_distance			: float;
	var l_materialName		: name;
	var l_hitComponent		: CComponent;
	var l_destructibleCmp	: CDestructionSystemComponent;
	var barrel 				: COilBarrelEntity;

	if( 
	theGame.IsDialogOrCutscenePlaying() 
	|| !thePlayer.IsAlive()
	|| thePlayer.IsInCutsceneIntro()
	|| theGame.HasBlackscreenRequested()
	|| theGame.IsCurrentlyPlayingNonGameplayScene()
	|| theGame.GetGuiManager().IsAnyMenu()
	|| theGame.GetTutorialSystem().HasActiveTutorial()
	)
	{
		return;
	}

	l_stateName = GetCurrentStateName();
	
	
	CalcEntitySlotMatrix('r_weapon', l_slotMatrix);
	
	l_weaponPosition 	= MatrixGetTranslation( l_slotMatrix );
	
	
	switch( l_stateName )
	{
		case 'CombatFists':
			l_offset 	= MatrixGetAxisX( l_slotMatrix );
			l_offset 	= VecNormalize( l_offset ) * 0.25f;
		break;
		
		default:
			l_offset 	= MatrixGetAxisZ( l_slotMatrix );

			if ( thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
			)
			{
				l_offset 	= VecNormalize( l_offset ) * 2.f;
			}
			else if ( thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
			|| thePlayer.HasTag('acs_yrden_sword_equipped')
			|| thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
			|| thePlayer.HasTag('acs_aard_secondary_sword_equipped')
			)
			{
				l_offset 	= VecNormalize( l_offset ) * 2.5f;
			}
			else
			{
				l_offset 	= VecNormalize( l_offset ) * 1.f;
			}
			
		break;
	}
	
	l_weaponTipPos			= l_weaponPosition + l_offset;
	
	
	m_LastWeaponTipPos		= l_weaponTipPos;			
	
	if ( !theGame.GetWorld().StaticTraceWithAdditionalInfo( l_weaponPosition, l_weaponTipPos, l_collidingPosition, l_normal, l_materialName, l_hitComponent, m_WeaponFXCollisionGroupNames ) )
	{
		
		if( l_stateName == 'CombatFists' )
		{
			CalcEntitySlotMatrix('l_weapon', l_slotMatrix);
			l_weaponPosition 	= MatrixGetTranslation( l_slotMatrix );
			l_offset 			= MatrixGetAxisX( l_slotMatrix );
			l_offset 			= VecNormalize( l_offset ) * 0.25f;
			l_weaponTipPos		= l_weaponPosition + l_offset;
			if( !theGame.GetWorld().StaticTrace( l_weaponPosition, l_weaponTipPos, l_collidingPosition, l_normal, m_WeaponFXCollisionGroupNames ) )
			{
				return;
			}
		}
		else
		{
			return;
		}
	}
	
	if( !m_CollisionEffect )
	{
		m_CollisionEffect = theGame.CreateEntity( m_CollisionFxTemplate, l_collidingPosition, EulerAngles(0,0,0) );
	}
	
	m_CollisionEffect.Teleport( l_collidingPosition );
	
	
	switch( l_stateName )
	{
		case 'CombatFists':
			m_CollisionEffect.PlayEffect('fist');
		break;
		default:				
			
			if( m_RefreshWeaponFXType )
			{
				m_PlayWoodenFX 			= IsSwordWooden();
				m_RefreshWeaponFXType 	= false;
			}
		
			if( m_PlayWoodenFX )
			{
				m_CollisionEffect.PlayEffect('wood');
			}
			else
			{
				switch( l_materialName )
				{
					case 'wood_hollow':
					case 'wood_debris':
					case 'wood_solid':
						m_CollisionEffect.PlayEffect('wood');
					break;
					case 'dirt_hard':
					case 'dirt_soil':
					case 'hay':
						m_CollisionEffect.PlayEffect('fist');
					break;
					case 'stone_debris':
					case 'stone_solid':
					case 'clay_tile':
					case 'gravel_large':
					case 'gravel_small':
					case 'metal':
					case 'custom_sword':
						m_CollisionEffect.PlayEffect('sparks');
					break;
					case 'flesh':
						m_CollisionEffect.PlayEffect('blood');
					break;
					default:
						m_CollisionEffect.PlayEffect('wood');
					break;
				}
				
			}
		break;
	}
	
	
	if(l_hitComponent)
	{
		barrel = (COilBarrelEntity)l_hitComponent.GetEntity();
		if(barrel)
		{
			barrel.OnFireHit(NULL);	
			return;
		}
	}
	
	
	l_destructibleCmp = (CDestructionSystemComponent) l_hitComponent;
	if( l_destructibleCmp && l_stateName != 'CombatFists' )
	{
		l_destructibleCmp.ApplyFracture();
	}
	
	
	
}

@wrapMethod( CR4Player ) function DisplayActionDisallowedHudMessage(action : EInputActionBlock, optional isCombatLock : bool, optional isPlaceLock : bool, optional isTimeLock : bool, optional isDangerous : bool)
{
	if(action == EIAB_Jump)
	{
		return;
	}

	wrappedMethod(action, isCombatLock, isPlaceLock, isTimeLock, isDangerous);	
}

@wrapMethod( MountHorse ) function OnMountAnimStarted()
{
	wrappedMethod();	

	if ( thePlayer.IsSprintActionPressed() || thePlayer.GetIsSprintToggled() )
	{
		((CNewNPC)horseComp.GetEntity()).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(3); 
	}
	else
	{
		if (theInput.GetActionValue('GI_AxisLeftY') != 0 
		|| theInput.GetActionValue('GI_AxisLeftX') != 0 )
		{
			((CNewNPC)horseComp.GetEntity()).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(2); 
		}
		else
		{
			((CNewNPC)horseComp.GetEntity()).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1); 
		}
	}
}

@wrapMethod( MountHorse ) function OnHorseRidingOn()
{
	wrappedMethod();	

	thePlayer.SetAnimationSpeedMultiplier(1);

	if ( thePlayer.IsSprintActionPressed() || thePlayer.GetIsSprintToggled() )
	{
		((CNewNPC)horseComp.GetEntity()).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(4); 
	}
	else
	{
		if (theInput.GetActionValue('GI_AxisLeftY') != 0 
		|| theInput.GetActionValue('GI_AxisLeftX') != 0 )
		{
			((CNewNPC)horseComp.GetEntity()).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(3); 
		}
		else
		{
			((CNewNPC)horseComp.GetEntity()).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(2); 
		}
	}
}

@wrapMethod( CBTTaskStopYrden ) function FindAndStopNearYrdenEntities()
{	
	var i			: int;
	var l_entities 	: array<CGameplayEntity>;
	var l_yrden		: W3YrdenEntity;
	var min, max 	: SAbilityAttributeValue;
	
	if(false)
	{
		wrappedMethod();
	}
	
	npc.RemoveAllBuffsOfType( EET_Burning );
	npc.RemoveAllBuffsOfType( EET_Frozen );
	npc.RemoveAllBuffsOfType( EET_Bleeding );
	npc.RemoveAllBuffsOfType( EET_SlowdownFrost );
	npc.RemoveAllBuffsOfType( EET_Slowdown );
	
	
	npc.RemoveAllBuffsOfType( EET_Bleeding1 );
	npc.RemoveAllBuffsOfType( EET_Bleeding2 );
	npc.RemoveAllBuffsOfType( EET_Bleeding3 );
	
	
	l_entities.Clear();
	
	if( useYrdenRadiusAsRange )
	{
		range = CalculateAttributeValue( GetWitcherPlayer().GetSkillAttributeValue(S_Magic_3, 'range', false, true) );

		range += GetNPC().GetRadius();
		
		if( GetWitcherPlayer().IsSetBonusActive( EISB_Gryphon_2 ) )
		{
			theGame.GetDefinitionsManager().GetAbilityAttributeValue( 'GryphonSetBonusYrdenEffect', 'trigger_scale', min, max );
			range *=  min.valueAdditive;
			range = range * 1.64286;
		}
		else
		{
			range = range * 2;
		}
	}
	
	FindGameplayEntitiesInSphere( l_entities, npc.GetWorldPosition(), range, maxResults );
	
	for( i = 0; i < l_entities.Size(); i += 1 )
	{
		l_yrden = (W3YrdenEntity) l_entities[i];
		if( l_yrden )
		{
			StopYrden( l_yrden );
		}
	}
}
	

@wrapMethod( CBTTaskIsInYrden ) function IsInYrden() : bool
{	
	var i : int;
	var entities : array<CGameplayEntity>;
	var yrden : W3YrdenEntity;
	var range : float;
	var min, max : SAbilityAttributeValue;

	if(false)
	{
		wrappedMethod();
	}
	
	range = CalculateAttributeValue( GetWitcherPlayer().GetSkillAttributeValue(S_Magic_3, 'range', false, true) );

	range += GetNPC().GetRadius();
		
	if( GetWitcherPlayer().IsSetBonusActive( EISB_Gryphon_2 ) )
	{
		theGame.GetDefinitionsManager().GetAbilityAttributeValue( 'GryphonSetBonusYrdenEffect', 'trigger_scale', min, max );
		range *=  min.valueAdditive;
		range = range * 1.64286;
	}
	else
	{
		range = range * 2;
	}
			
	entities.Clear();	
	FindGameplayEntitiesInSphere( entities, GetNPC().GetWorldPosition(), range, 99 ); 
	
	for( i = 0; i < entities.Size(); i += 1 )
	{
		yrden = (W3YrdenEntity)entities[i];
		
		if( yrden )
		{
			return true;
		}
	}
	
	return false;
}

@wrapMethod( CGameplayLightComponent ) function OnInteraction( actionName : string, activator : CEntity )
{
	if(false)
	{
		wrappedMethod(actionName, activator);
	}

	if ( activator == thePlayer )
	{
		if( thePlayer.tiedWalk )
		{
			return false;
		}
		
		if( !thePlayer.CanPerformPlayerAction(isEnabledInCombat) )
		{
			return false;
		}
		
		thePlayer.AddAnimEventChildCallback(this,'SetLight','OnAnimEvent_SetLight');
		thePlayer.AddAnimEventChildCallback(this,'UnlockInteraction','OnAnimEvent_UnlockInteraction');
	}
	
	
	if(!IsLightOn())
	{
		if (ACS_New_Replacers_Female_Active())
		{
			thePlayer.PlayerStartAction( PEA_IgniLight );

			BlockPlayerLightInteraction();
		}
		else
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
			GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

			if (thePlayer.HasTag('ACS_IsSwordWalking') && GetACSWatcher().AnimProgressCheck()){thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RemoveTag('ACS_IsSwordWalking');}
			thePlayer.RaiseEvent('ACS_IgniLight');
		}
	}
	else
	{
		if (ACS_New_Replacers_Female_Active())
		{
			thePlayer.PlayerStartAction( PEA_AardLight );

			BlockPlayerLightInteraction();
		}
		else
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
			GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

			if (thePlayer.HasTag('ACS_IsSwordWalking') && GetACSWatcher().AnimProgressCheck()){thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RemoveTag('ACS_IsSwordWalking');}
			thePlayer.RaiseEvent('ACS_AardLight');
		}	
	}
	if ( thePlayer.IsHoldingItemInLHand() )
	{
		thePlayer.OnUseSelectedItem( true );
		restoreItemLAtEnd = true;
	}
}

@wrapMethod( CSignReactiveEntity ) function OnInteraction( actionName : string, activator : CEntity )
{
	if(false)
	{
		wrappedMethod(actionName, activator);
	}

	if ( activator == thePlayer && actionName == "Ignite" )
	{
		if(!thePlayer.CanPerformPlayerAction())
			return false;
		
		if(!isDestroyed)
		{
			if (ACS_New_Replacers_Female_Active())
			{
				thePlayer.PlayerStartAction( PEA_IgniLight );
			}
			else
			{
				GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
				GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
				GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
				GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

				if (thePlayer.HasTag('ACS_IsSwordWalking') && GetACSWatcher().AnimProgressCheck()){thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RemoveTag('ACS_IsSwordWalking');}
				thePlayer.RaiseEvent('ACS_IgniLight');
			}

			HitByFire();
		}		
	}
	else
	{
		super.OnInteraction(actionName,activator);
	}
}

@wrapMethod( W3SignProjectile ) function ProcessAttackRange()
{
	var i, size  	: int;
	var entities 	: array< CGameplayEntity >;
	var e		 	: CGameplayEntity;
	var pos, entPos	: Vector;

	if(false)
	{
		wrappedMethod();
	}

	if ( !attackRange )
	{
		return;
	}

	attackRange.GatherEntities( signEntity, entities );
	entities.Remove( owner.GetActor() );
	size = entities.Size();
	pos = GetWorldPosition();
	for( i = 0; i < size; i += 1 )
	{
		e = entities[i];
		
		if(hitEntities.Contains(e))			
			continue;
	
		
		if( (W3SignProjectile)e || (W3IgniEntity)e )
			continue;
		
		
		if( (W3AardProjectile)this && (W3Boat)e )
			continue;

		if ( (CNewNPC)e )
		{
			if(!StrContains( ((CNewNPC)e).GetReadableName(), "community_npc" ))
			{
				continue;
			}
		}
		
		entPos = e.GetWorldPosition();
		ProcessCollision( e, entPos, entPos - pos );
	}	
}

@wrapMethod( CR4Player ) function ShouldPerformFriendlyAction( actor : CActor, inputHeading, attackAngle, clearanceMin, clearanceMax : float ) : bool
{
	if(false)
	{
		wrappedMethod(actor, inputHeading, attackAngle, clearanceMin, clearanceMax);
	}

	return false;
}

@wrapMethod( W3HorseComponent ) function OnKillHorse()
{
	if(false)
	{
		wrappedMethod();
	}

	if( user )
	{
		killHorse = true;

		if( user == thePlayer )
		{
			IssueCommandToDismount( DT_instant );
		}
		else
		{
			user.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
		}
		
		killHorse = true;
	}
	else
	{
		KillHorse();
	}
}

@wrapMethod( RangedWeapon ) function InputLockFailsafe( time : float , id : int)
{	
	var item : SItemUniqueId;

	if(false)
	{
		wrappedMethod(time, id);
	}

	if ( !ownerPlayer.IsUsingVehicle() )
	{
		if ( this.GetCurrentStateName() == 'State_WeaponAim' 
			|| this.GetCurrentStateName() == 'State_WeaponShoot'
			|| this.GetCurrentStateName() == 'State_WeaponReload' )
		{
			item = this.ownerPlayer.inv.GetItemFromSlot( 'l_weapon' );
			
			if ( !( this.ownerPlayer.inv.IsIdValid( item ) && this.ownerPlayer.inv.IsItemCrossbow( item ) ) )  
				this.OnForceHolster( false, true );
		}
		
		if ( this.GetCurrentStateName() != 'State_WeaponWait' )
		{
			if ( !ownerPlayer.GetBIsCombatActionAllowed() 
				&& ownerPlayer.GetBehaviorVariable( 'combatActionType' ) == (int)CAT_Attack
				&& ownerPlayer.GetBehaviorVariable( 'fullBodyAnimWeight' ) == 1.f )
				OnForceHolster( true, true );
			
			if ( ownerPlayer.IsInShallowWater() && !ownerPlayer.IsSwimming() )
				OnForceHolster( true, false );
				
			if ( ownerPlayer.GetPlayerCombatStance() == PCS_Normal || ownerPlayer.GetPlayerCombatStance() == PCS_AlertFar )
			{
				if ( ( this.IsShootingComplete() ) 
					&& wasBLAxisReleased 
					&& !ownerPlayer.bLAxisReleased )
					OnForceHolster( true, false );
			}
		}
		
		if ( !isAimingWeapon && !isShootingWeapon && !this.ownerPlayer.lastAxisInputIsMovement )
		{
			if ( ( IsShootingComplete() && this.GetCurrentStateName() == 'State_WeaponShoot' )
				|| this.GetCurrentStateName() == 'State_WeaponAim' )
				SetOwnerOrientation();
		}		
	}
	
	wasBLAxisReleased = ownerPlayer.bLAxisReleased;
}	

@wrapMethod( RangedWeapon ) function ProcessCanAttackWhenNotInCombat()
{        
	if(false)
	{
		wrappedMethod();
	}

	return;
}

@wrapMethod( RangedWeapon ) function CanAttackWhenNotInCombat() : bool
{
	var shootTarget : CActor;
	var weaponToThrowPosDist	: float;

	if(false)
	{
		wrappedMethod();
	}
	
	weaponToThrowPosDist = VecDistance( ownerPlayer.playerAiming.GetThrowPosition(), ownerPlayer.playerAiming.GetThrowStartPosition() );
	
	if ( ownerPlayer.GetDisplayTarget() && ownerPlayer.IsDisplayTargetTargetable() )
		shootTarget = (CActor)( ownerPlayer.GetDisplayTarget() );
	else
		shootTarget = (CActor)( ownerPlayer.slideTarget );
		
	if ( this.isDeployedEntAiming ) 
	{
		if ( ownerPlayer.playerAiming.GetSweptFriendly() || weaponToThrowPosDist < 1.f )	
			return false;
		else	
			return true;
	}
	else
	{
		return true;
	}
}

@wrapMethod( State_WeaponShoot ) function OnEnterState( prevStateName : name )
{
	var target : CActor;

	if(false)
	{
		wrappedMethod(prevStateName);
	}
	
	target = parent.ownerPlayer.GetTarget();
	parent.ownerPlayer.RaiseEvent( 'DivingForceStop' ); 
	
	parent.shootingIsComplete = false;
	cachedCombatActionTarget = NULL;
	
	if( target )
	{
		if( (( CNewNPC )( target )).IsShielded( thePlayer ) )
			(( CNewNPC )( target )).OnIncomingProjectile( true );
	}

	parent.ProcessCanAttackWhenNotInCombat();
}

@wrapMethod( State_WeaponShoot ) function OnRangedWeaponPress()
{
	if(false)
	{
		wrappedMethod();
	}

	if ( parent.shootingIsComplete )
	{
		parent.shootingIsComplete = false;
		
		if (  !parent.ownerPlayer.IsUsingVehicle() )
			parent.ownerPlayer.SetSlideTarget( parent.ownerPlayer.GetCombatActionTarget( EBAT_ItemUse ) );
		else
			((CR4PlayerStateUseGenericVehicle)parent.ownerPlayer.GetState( 'UseGenericVehicle' )).FindTarget();
	}
	else if ( !cachedCombatActionTarget )
	{
		cachedCombatActionTarget = parent.ownerPlayer.GetCombatActionTarget( EBAT_ItemUse );
	}

	virtual_parent.OnRangedWeaponPress();
}

@wrapMethod( CThrowable ) function CanCollideWithVictim( actor : CActor ) : bool
{
	var ownerPlayer : CPlayer;

	if(false)
	{
		wrappedMethod(actor);
	}
	
	if ( !actor )
		return true;

	if ( actor == thePlayer.GetUsedVehicle() )
		return false;

	if ( !actor.IsAlive() )
		return true;
		
	if ( actor.IsKnockedUnconscious() )
		return false;
		
	ownerPlayer = (CPlayer)GetOwner();
	if ( ownerPlayer && ownerPlayer.GetAttitude( actor ) == AIA_Friendly )
		return true;
		
	return true;
}

@wrapMethod( W3Petard ) function ProcessMechanicalEffect(targets : array<CGameplayEntity>, isImpact : bool, optional dt : float)
{			
	var i, index, j, k : int;
	var action : W3DamageAction;
	var none : SAbilityAttributeValue;
	var atts : array<name>;
	var newDamage : SRawDamage;
	var params : SPetardParams;
	var attackerTags, allVictimsTags, targetTags : array<name>;
	var dm : CDefinitionsManagerAccessor;
	var actorTarget : CActor;
	var surface	: CGameplayFXSurfacePost;		
	var successfullBlock, canUsePerk20 : bool;
	var hitType : EHitReactionType;
	var npc : CNewNPC;
	var DoTBuff : W3BuffDoTParams;

	if(false)
	{
		wrappedMethod(targets, isImpact, dt);
	}
	
	
	for(i=targets.Size()-1; i>=0; i-=1)
	{
		
		if( (CActionPoint)targets[i] || (W3Petard)targets[i] )
		{
			targets.Erase(i);
			continue;
		}
	}

	if(isImpact)
		params = impactParams;
	else
		params = loopParams;
		
	
	if(params.surfaceFX.fxType >= 0 && !isInWater)
	{
		surface = theGame.GetSurfacePostFX();
		surface.AddSurfacePostFXGroup(GetWorldPosition(), params.surfaceFX.fxFadeInTime, params.surfaceFX.fxLastingTime, params.surfaceFX.fxFadeOutTime, params.surfaceFX.fxRadius, params.surfaceFX.fxType);
	}	
	
	if(targets.Size() == 0)
		return;				
		
	if(isImpact)
	{
		if( !ignoreBombSkills && (W3PlayerWitcher)GetOwner() && GetWitcherPlayer().CanUseSkill(S_Alchemy_s10) && !HasTag('Snowball'))
		{
			theGame.GetDefinitionsManager().GetAbilityAttributes(SkillEnumToName(S_Alchemy_s10), atts);
			
			for(j=0; j<atts.Size(); j+=1)
			{
				if(IsDamageTypeNameValid(atts[j]))
				{
					index = -1;
					for(i=0; i<params.damages.Size(); i+=1)
					{
						if(params.damages[i].dmgType == atts[j])
						{
							index = i;
							break;
						}
					}
					
					
					if(index != -1)
					{
						params.damages[index].dmgVal += CalculateAttributeValue(thePlayer.GetSkillAttributeValue(S_Alchemy_s10, atts[j], false, true)) * thePlayer.GetSkillLevel(S_Alchemy_s10);
					}
					else
					{
						newDamage.dmgType = atts[j];
						newDamage.dmgVal = CalculateAttributeValue(thePlayer.GetSkillAttributeValue(S_Alchemy_s10, atts[j], false, true)) * thePlayer.GetSkillLevel(S_Alchemy_s10);
						params.damages.PushBack(newDamage);
					}
				}
			}
		}
	}
	
	dm = theGame.GetDefinitionsManager();
				
	
	if(isImpact)
		hitType = hitReactionType;
	else
		hitType = EHRT_None;
	
	
	DoTBuff = new W3BuffDoTParams in this;
	DoTBuff.isFromBomb = true;
	
	if( (W3PlayerWitcher)GetOwner() && GetWitcherPlayer().CanUseSkill( S_Perk_20 ) )
	{
		DoTBuff.isPerk20Active = true;
		canUsePerk20 = true;				
	}
	
	
	
	
	for(i=0; i<targets.Size(); i+=1)
	{	
		
		targetTags = targets[i].GetTags();
		ArrayOfNamesAppendUnique(allVictimsTags, targetTags);
		
		
		actorTarget = (CActor)targets[i];
		if(!actorTarget)
		{
			if( isImpact )
			{
				if( hasImpactFireDamage )
				{
					targets[i].OnFireHit(this);
				}
				if( hasImpactFrostDamage )
				{
					targets[i].OnFireHit(this);
				}
			}
			else
			{
				if( hasLoopFireDamage )
				{
					targets[i].OnFireHit(this);
				}
				if( hasLoopFrostDamage )
				{
					targets[i].OnFireHit(this);
				}
			}
			
			
			if(isFromAimThrow && wasInTutorialTrigger && ShouldProcessTutorial('TutorialThrowHold'))
			{
				for(j=0; j<targetTags.Size(); j+=1)
				{
					FactsAdd("aimthrowed_" + targetTags[j]);
				}
			}
				
			continue;
		}
		
		
		if( actorTarget && !actorTarget.IsAlive() )
		{
			continue;
		}
		
		
		action = new W3DamageAction in theGame.damageMgr;
		action.Initialize(GetOwner(), actorTarget, this, 'petard', hitType, CPS_Undefined, false, true, false, false);
		action.SetHitAnimationPlayType(params.playHitAnimMode);
		action.SetIgnoreArmor(params.ignoresArmor);
		action.SetProcessBuffsIfNoDamage(true);
		action.SetIsDoTDamage(dt);
		
		for(j=0; j<params.damages.Size(); j+=1)
		{
			if(dt > 0)
				action.AddDamage(params.damages[j].dmgType, params.damages[j].dmgVal * dt);
			else
				action.AddDamage(params.damages[j].dmgType, params.damages[j].dmgVal);
		}

		for(j=0; j<params.buffs.Size(); j+=1)
		{
			
			
			
			params.buffs[j].effectCustomParam = DoTBuff;
			
			
			action.AddEffectInfo(params.buffs[j].effectType, params.buffs[j].effectDuration, params.buffs[j].effectCustomValue, params.buffs[j].effectAbilityName, params.buffs[j].effectCustomParam, params.buffs[j].applyChance);
		}
		
		theGame.damageMgr.ProcessAction(action);
		
		delete action;
					
		
		successfullBlock = false;
		for(j=0; j<params.disabledAbilities.Size(); j+=1)
			if(dm.IsAbilityDefined(params.disabledAbilities[j].abilityName))
				successfullBlock = BlockTargetsAbility(actorTarget, params.disabledAbilities[j].abilityName, params.disabledAbilities[j].timeWhenEnabledd) || successfullBlock;					
		
		
		for(k=0; k<params.fxPlayedOnHit.Size(); k+=1)
			actorTarget.PlayEffectSingle(params.fxPlayedOnHit[k]);
		
		
		if(successfullBlock)
		{
			
			for(k=0; k<params.fxPlayedWhenAbilityDisabled.Size(); k+=1)						
				actorTarget.PlayEffectSingle(params.fxPlayedWhenAbilityDisabled[k]);
				
			for(k=0; k<params.fxStoppedWhenAbilityDisabled.Size(); k+=1)						
				actorTarget.StopEffect(params.fxStoppedWhenAbilityDisabled[k]);
		}
			
		
		npc = (CNewNPC)actorTarget;
		if(npc && npc.GetNPCType() == ENGT_Guard && !npc.IsInCombat() )
		{
			npc.SignalGameplayEventParamObject('BeingHitAction', GetOwner());
			theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( npc, 'BeingHitAction', 8.0, 1.0f, 999.0f, 1, false); 
		}
	}

	
	if(allVictimsTags.Size() > 0)
	{
		attackerTags = GetOwner().GetTags();
		
		AddHitFacts( allVictimsTags, attackerTags, "_weapon_hit" );
		AddHitFacts( allVictimsTags, attackerTags, "_bomb_hit" );
		AddHitFacts( allVictimsTags, attackerTags, "_bomb_hit_type_" + PrintFactFriendlyPetardName() );
	}		
}

@wrapMethod( CActor ) function IsTargetableByPlayer() : bool
{       
	if(false)
	{
		wrappedMethod();
	}
  
	return isTargatebleByPlayer;
}

@wrapMethod( CR4Player ) function AbortSign()
{
	wrappedMethod();

	ACSGetCEntity('ACS_Sign_Icon_Anchor').Destroy();
	ACSGetCEntity('ACS_Sign_Icon').Destroy();
}

@wrapMethod(W3Effect_Oil) function OnEffectAddedPost()
{
	wrappedMethod();

	if( GetWitcherPlayer().IsItemEquipped( sword )
	&& ACS_can_apply_oil()
	)
	{
		ACS_refresh_apply_oil_cooldown();

		GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
		GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
		GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
		GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 

		thePlayer.RaiseEvent('ACS_SwordBuff');
	}
}

@wrapMethod(CR4HudModuleRadialMenu) function ShowRadialMenu()
{
	wrappedMethod();
	
	theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_RadialMenu) );
	theGame.SetTimeScale( 0.5, theGame.GetTimescaleSource(ETS_RadialMenu), theGame.GetTimescalePriority(ETS_RadialMenu), false, true);
}

@wrapMethod( CR4StartupMoviesMenu ) function OnConfigUI()
{
	if(false)
	{
		wrappedMethod();
	}

	CloseMenu();
}

@wrapMethod( CR4RecapMoviesMenu ) function OnConfigUI()
{
	if(false)
	{
		wrappedMethod();
	}

	CloseMenu();
}

@wrapMethod( CR4Player ) function DelayedSheathSword( dt: float, id : int )
{
	if(false)
	{
		wrappedMethod( dt, id );
	}

	RemoveTimer('DelayedSheathSword');
}

@wrapMethod( W3Effect_OverEncumbered ) function OnEffectAdded(optional customParams : W3BuffCustomParams)
{		
	if(false)
	{
		wrappedMethod( customParams );
	}

	super.OnEffectAdded(customParams);
	
	if(!isOnPlayer)
	{
		LogAssert(false, "W3Effect_OverEncumbered.OnEffectAdded: adding effect <<" + effectType + ">> on non-player actor - aborting!");
		timeLeft = 0;
		return false;
	}

	if(!ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodEncumberedEnabled', false))
	{
		timeLeft = 0;

		super.OnEffectRemoved();

		return false;
	}
	
	((CR4Player)target).BlockAction( EIAB_RunAndSprint, 'OverEncumbered', true );

	//((CR4Player)target).SetAnimationSpeedMultiplier(0.5);
}

@wrapMethod( W3Effect_OverEncumbered ) function OnEffectRemoved()
{
	if(false)
	{
		wrappedMethod();
	}

	super.OnEffectRemoved();
	
	//((CR4Player)target).SetAnimationSpeedMultiplier(1);

	((CR4Player)target).UnblockAction( EIAB_RunAndSprint, 'OverEncumbered');
}

@wrapMethod( W3Effect_OverEncumbered ) function OnUpdate(dt : float)
{
	if(false)
	{
		wrappedMethod( dt );
	}

	super.OnUpdate(dt);
	
	if(!ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodEncumberedEnabled', false))
	{
		timeLeft = 0;

		super.OnEffectRemoved();
	}
	else
	{
		//((CR4Player)target).SetAnimationSpeedMultiplier(0.5);
	}
}

@wrapMethod( CPlayer ) function EnableSprintingCamera( flag : bool )
{
	var camera 	: CCustomCamera;
	var animation : SCameraAnimationDefinition;
	var vel : float;

	if(false)
	{
		wrappedMethod( flag );
	}

	if( !theGame.IsUberMovementEnabled() && !useSprintingCameraAnim )
	{
		return;
	}

	if ( IsSwimming() || OnCheckDiving() || FactsQuerySum("ACS_Disable_Sprinting_Camera") > 0 )
		flag = false;
	
	camera = theGame.GetGameCamera();
	if ( flag )
	{
		vel = VecLength( this.GetMovingAgentComponent().GetVelocity() );
	}
	else
	{	
		sprintingCamera = false;
		camera.StopAnimation('camera_shake_loop_lvl1_1');
	}
}

@wrapMethod( CPlayer ) function EnableRunCamera( flag : bool )
{
	var camera 	: CCustomCamera = theGame.GetGameCamera();
	var animation : SCameraAnimationDefinition;
	var vel : float;

	if(false)
	{
		wrappedMethod( flag );
	}

	if ( IsSwimming() || OnCheckDiving() || FactsQuerySum("ACS_Disable_Sprinting_Camera") > 0 )
		flag = false;
	
	if ( flag )
	{

	}
	else
	{
		camera.StopAnimation('camera_shake_loop_lvl1_5');
	}
	
	runningCamera = flag;
}

@wrapMethod( CFocusModeController ) function OnGameStarted()
{
	if(false)
	{
		wrappedMethod();
	}

	Init();
	SetFadeParameters( 10.0, 30.0f, 16.0f, 0.5f );
}

@wrapMethod( CFocusModeController ) function ActivateInternal()
{
	var hud : CR4ScriptedHud;
	var minimapModule : CR4HudModuleMinimap2;
	var objectiveModule : CR4HudModuleQuests;
	
	if(false)
	{
		wrappedMethod();
	}

	if ( IsActive() || !CanUseFocusMode() )
	{
		return;
	}

	if(thePlayer.IsCiri())
	{
		hud = (CR4ScriptedHud)theGame.GetHud();
		if(hud)
		{
			minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");
			objectiveModule = (CR4HudModuleQuests)hud.GetHudModule("QuestsModule");
			
			if(minimapModule)
			{
				minimapModule.SetIsInFocus(true);
			}
			
			if(objectiveModule)
			{
				objectiveModule.SetIsInFocus(true);
			}
		}
		return;
	}
	
	SetActive( true );
	EnableVisuals( true );

	theTelemetry.LogWithName( TE_HERO_FOCUS_ON );

	
	if ( theGame.GetEngineTimeAsSeconds() - activationSoundTimer > activationSoundInterval )
	{
		activationSoundTimer = theGame.GetEngineTimeAsSeconds();
	}
	
	
	if( GetWitcherPlayer().IsInDarkPlace() && GetWitcherPlayer().IsMutationActive( EPMT_Mutation12 ) && !thePlayer.HasBuff( EET_Mutation12Cat ) )
	{
		thePlayer.AddEffectDefault( EET_Mutation12Cat, thePlayer, "Mutation12 Senses", false );
	}
	
	
	hud = (CR4ScriptedHud)theGame.GetHud();
	if(hud)
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");
		objectiveModule = (CR4HudModuleQuests)hud.GetHudModule("QuestsModule");
		
		if(minimapModule)
		{
			minimapModule.SetIsInFocus(true);
		}
		
		if(objectiveModule)
		{
			objectiveModule.SetIsInFocus(true);
		}
	}
	
}

@wrapMethod( CFocusModeController ) function Activate()
{
	if(false)
	{
		wrappedMethod();
	}

	lastDarkPlaceCheck = DARK_PLACE_CHECK_INTERVAL;

	SetFadeParameters( 10.0, 30.0f, 16.0f, 0.5f );
	if ( !ActivateFastFocus( true ) )
	{
		ActivateInternal();
	}
}

@wrapMethod( CFocusModeController ) function Deactivate()
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleInteractions;
	var minimapModule : CR4HudModuleMinimap2;
	var objectiveModule : CR4HudModuleQuests;

	if(false)
	{
		wrappedMethod();
	}

	SetFadeParameters( 10.0, 30.0f, 16.0f, 0.5f ); 
	

	ActivateFastFocus( false );

	if(thePlayer.IsCiri())
	{
		hud = ( CR4ScriptedHud )theGame.GetHud();
		if(hud)
		{
			minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");
			objectiveModule = (CR4HudModuleQuests)hud.GetHudModule("QuestsModule");
			
			if(minimapModule)
			{
				minimapModule.SetIsInFocus(false);
			}
			
			if(objectiveModule)
			{
				objectiveModule.SetIsInFocus(false);
			}
		}
	}

	if ( !IsActive() )
	{
		return;
	}
	SetActive( false );
	EnableVisuals( false );
	EnableExtendedVisuals( false, effectFadeTime );
	
	if( isUnderwaterFocus )
	{
		isUnderwaterFocus = false;
		if( isInCombat )
		{
			theSound.LeaveGameState( ESGS_FocusUnderwaterCombat );
		}
		else
		{
			theSound.LeaveGameState( ESGS_FocusUnderwater );
		}
	}
	else
	{
		if( isNight )
		{
			theSound.LeaveGameState( ESGS_FocusNight );
		}
		else
		{
			theSound.LeaveGameState( ESGS_Focus );
		}
	}
	
	isInCombat = false;
	isUnderwaterFocus = false;
	isNight = false;

	thePlayer.UnblockAction( EIAB_Jump, 'focus' );
	theTelemetry.LogWithName( TE_HERO_FOCUS_OFF );
	
	
	if ( theGame.GetEngineTimeAsSeconds() - activationSoundTimer > activationSoundInterval )
	{
		activationSoundTimer = theGame.GetEngineTimeAsSeconds();
	}		
	
	hud = ( CR4ScriptedHud )theGame.GetHud();
	if ( hud )
	{
		module = (CR4HudModuleInteractions)hud.GetHudModule( "InteractionsModule" );
		if ( module )
		{
			module.RemoveAllFocusInteractionIcons();
		}
	}
	
	
	thePlayer.RemoveBuff( EET_Mutation12Cat );
	
	
	if(hud)
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");
		objectiveModule = (CR4HudModuleQuests)hud.GetHudModule("QuestsModule");
		
		if(minimapModule)
		{
			minimapModule.SetIsInFocus(false);
		}
		
		if(objectiveModule)
		{
			objectiveModule.SetIsInFocus(false);
		}
	}
	
}

@wrapMethod( CFocusModeController ) function OnTick( timeDelta : float )
{	
	var desiredAudioState : ESoundGameState;
	var focusModeIntensity : float;
	
	if(false)
	{
		wrappedMethod(timeDelta);
	}

	if ( fastFocusTimer > 0.0f )
	{
		fastFocusTimer -= timeDelta;
		if ( fastFocusTimer < 0.0f )
		{
			fastFocusTimer = 0.0f;
			if ( activateAfterFastFocus )
			{
				activateAfterFastFocus = false;
				ActivateInternal();
			}
		}
	}
	
	if( IsActive() )
	{
		if( CanUseFocusMode() )
		{
			isInCombat = false;
			isUnderwaterFocus = thePlayer.OnIsCameraUnderwater();
			if( isUnderwaterFocus )
			{
				isInCombat = thePlayer.ShouldEnableCombatMusic();
				if( isInCombat )
				{
					desiredAudioState = ESGS_FocusUnderwaterCombat;
				}
				else
				{
					desiredAudioState = ESGS_FocusUnderwater;
				}
			}
			else
			{
				isNight = theGame.envMgr.IsNight();
				if( isNight )
				{
					desiredAudioState = ESGS_FocusNight;
				}
				else
				{
					desiredAudioState = ESGS_Focus;
				}
			}
			
			if( GetWitcherPlayer().IsMutationActive( EPMT_Mutation12 ) )
			{
				lastDarkPlaceCheck -= timeDelta;
				if( lastDarkPlaceCheck <= 0.f )
				{
					lastDarkPlaceCheck = DARK_PLACE_CHECK_INTERVAL;
				
					if( GetWitcherPlayer().IsInDarkPlace() && !thePlayer.HasBuff( EET_Mutation12Cat ) )
					{
						thePlayer.AddEffectDefault( EET_Mutation12Cat, thePlayer, "Mutation12 Senses", false );
					}
					else if( !GetWitcherPlayer().IsInDarkPlace() && thePlayer.HasBuff( EET_Mutation12Cat ) )
					{
						thePlayer.RemoveBuff( EET_Mutation12Cat );
					}
				}
			}
		}
		else
		{
			Deactivate();
		}
	}
	
	focusModeIntensity = GetIntensity();
	UpdateMedallion( focusModeIntensity );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

@addField(CBoatComponent)
private var ACS_deltaDamper : DeltaDamper;

@wrapMethod( CBoatComponent ) function OnTick( dt : float )	
{
	var currentFrontPosZ : float;
	var currentFrontVelZ : float;
	var currentFrontAccZ : float;
	
	var currentRightPosZ : float;
	var currentRightVelZ : float;
	var currentRightAccZ : float;

	var currentMastPosZ : float;
	var currentMastVelZ : float;
	
	var sailingMaxSpeed : float;
	var currentSpeed : float;
	var isMoving : bool;
	var tilt : float;
	var turnFactor : float;
	var currentGear: int;
	
	var fDiff,bDiff,rDiff,lDiff: float;

	if(false)
	{
		wrappedMethod(dt);
	}
	
	if ( dt <= 0.f )
	{
		LogBoat( "!!!!!!!!!!!!! dt <= 0.f !!!!!!!!!!!!!" );
		return false;
	}
	
	if( !boatEntity )
	{
		LogBoatFatal( "Entity not set in CBoatComponent::OnTick event." );
		return false;
	}
	
	
	fr = GetBuoyancyPointStatus_Front();
	ba = GetBuoyancyPointStatus_Back();
	ri = GetBuoyancyPointStatus_Right();
	le = GetBuoyancyPointStatus_Left();
	
	fDiff = fr.Z - fr.W;
	bDiff = ba.Z - ba.W;
	rDiff = ri.Z - ri.W;
	lDiff = le.Z - le.W;
	
	
	tilt = le.Z - ri.Z;
	sailDir = tilt*dt;
	sailTilt = tilt;
	
	
	boatEntity.CalcEntitySlotMatrix( 'front_splash', frontSlotTransform );
	currentFrontPosZ = (frontSlotTransform.W).Z;
	currentFrontVelZ = currentFrontPosZ - prevFrontPosZ;
	currentFrontAccZ = currentFrontVelZ - prevFrontVelZ;
	
	
	boatEntity.CalcEntitySlotMatrix( 'mast_trail', mastSlotTransform );
	currentMastPosZ = (mastSlotTransform.W).Z;
	if( tilt > 0.f )
	{
		currentMastVelZ = currentMastPosZ - ri.W;
	}
	else
	{
		currentMastVelZ = currentMastPosZ - le.W;
	}
	
	isMoving = ( GetLinearVelocityXY() > IDLE_SPEED_THRESHOLD );
	sailingMaxSpeed = GetMaxSpeed();
	
	if( isMoving )
	{
		
		boatEntity.StopEffectIfActive( 'idle_splash' );
		
		
		
		currentSpeed = GetLinearVelocityXY() / sailingMaxSpeed;

		if ( user && !passenger && GetCurrentStateName() != 'RealSailing' && ACS_IsPlayerInput() && (GetCurrentGear() > 0 ))
		{
			if ( !ACS_CheckForCollision() )
			{
				ACS_ModifyBoatSpeed(dt);
			}
		}

		if( IsInWater(ri) && rDiff < TILT_PARTICLE_THRESHOLD )
		{
			boatEntity.PlayEffectSingle( 'right_splash_stronger' );
		}
		else
		{
			boatEntity.StopEffectIfActive( 'right_splash_stronger' );
		}
		
		
		if( IsInWater(le) && lDiff < TILT_PARTICLE_THRESHOLD )
		{
			boatEntity.PlayEffectSingle( 'left_splash_stronger' );
		}
		else
		{
			boatEntity.StopEffectIfActive( 'left_splash_stronger' );
		}
		
		
		if( currentMastVelZ < MAST_PARTICLE_THRESHOLD )
		{
			boatEntity.PlayEffectSingle( 'mast_trail' );
			
			if( !boatEntity.SoundIsActiveName( 'boat_mast_trail_loop' ) && !boatMastTrailLoopStarted)
			{
				boatEntity.SoundEvent( 'boat_mast_trail_loop', 'mast_trail', true );
				boatMastTrailLoopStarted = true;
			}
		}
		else
		{
			boatEntity.StopEffectIfActive( 'mast_trail' );
			if( boatEntity.SoundIsActiveName( 'boat_mast_trail_loop' ) && boatMastTrailLoopStarted )
			{
				if( !boatEntity.SoundIsActiveName( 'boat_mast_trail_loop_stop' ) )
				{
					boatEntity.SoundEvent( 'boat_mast_trail_loop_stop' , 'mast_trail', true );
					boatMastTrailLoopStarted = false;
				}
			}
		}
		
		
		if( IsDiving( currentFrontVelZ, prevFrontWaterPosZ, fDiff ) )
		{
			boatEntity.SoundEvent( "boat_stress" );
			if ( !boatEntity.IsEffectActive('front_splash') )
			{
				boatEntity.SoundEvent( "boat_water_splash_soft" );
				boatEntity.PlayEffect( 'front_splash' );
			}
		}
	}
	else
	{
		if ( !ACS_IsPlayerInput() )
		{
			ACS_deltaDamper.Reset();
		}

		if( IsInWater(le) && IsInWater(ri) && IsInWater(fr) && IsInWater(ba) && !boatEntity.IsEffectActive('idle_splash') )
		{
			boatEntity.PlayEffect( 'idle_splash' );
		}
		
		SwitchEffectsByGear( 0 );
		
		
		boatEntity.StopEffectIfActive( 'front_splash' );
		boatEntity.StopEffectIfActive( 'mast_trail' );
		boatEntity.StopEffectIfActive( 'right_splash_stronger' );
		boatEntity.StopEffectIfActive( 'left_splash_stronger' );
		
		
		boatEntity.StopEffectIfActive( 'fake_wind_right' );
		boatEntity.StopEffectIfActive( 'fake_wind_left' );
		boatEntity.StopEffectIfActive( 'fake_wind_back' );
		currentSpeed = 0.f;
	}
	
	
	currentGear = GetCurrentGear();
	
	
	if( passenger )
		UpdatePassengerSailAnimByGear( currentGear );
	
	if( IsInWater(le) && IsInWater(ri) && IsInWater(fr) && IsInWater(ba) && currentGear != previousGear )
	{
		SwitchEffectsByGear( currentGear );
	}
	
	
	UpdateMastPositionAndRotation( currentGear, tilt, isMoving );
	
	
	UpdateSoundParams( currentSpeed );
	
	
	
	previousGear = currentGear;
	
	
	prevFrontWaterPosZ = fr.W;
	
	
	prevFrontPosZ += currentFrontVelZ;
	prevFrontVelZ = currentFrontVelZ;
	
	
	prevMastPosZ += currentMastVelZ;
	prevMastVelZ = currentMastVelZ;
	
	
	prevRightPosZ += currentRightVelZ;
	prevRightVelZ = currentRightVelZ;
	
	
	if( thePlayer.IsOnBoat() && !thePlayer.IsUsingVehicle() )
	{
		if( GetWeatherConditionName() == 'WT_Rain_Storm' )
		{
			if( thePlayer.GetBehaviorVariable( 'bRainStormIdleAnim' ) != 1.0 )
			{
				thePlayer.SetBehaviorVariable( 'bRainStormIdleAnim', 1.0 );
			}
		}
		else
		{
			if( thePlayer.GetBehaviorVariable( 'bRainStormIdleAnim' ) != 0.0 )
			{
				thePlayer.SetBehaviorVariable( 'bRainStormIdleAnim', 0.0 );
			}
		}
	}
}

@addMethod(CBoatComponent) function ACS_ModifyBoatSpeed(deltaTime : float)
{
	var linVelocity, headingVec, boatHeadingVec, inputVec : Vector;
	var currentSpeed, min, max, heading, maxBoatSpeed, stickInputX, stickInputY : float;
	var accelerate : SInputAction;
	
	if ( !ACS_deltaDamper )
	{
		ACS_deltaDamper = new DeltaDamper in this;
		ACS_deltaDamper.SetDamp( 0.3f );
	}

	accelerate = theInput.GetAction( 'GI_Accelerate' );
	stickInputX = theInput.GetActionValue( 'GI_AxisLeftX' );
	stickInputY = theInput.GetActionValue( 'GI_AxisLeftY' );
	
	if( (stickInputX || stickInputY ) || (accelerate.value != 0) )
	{
		inputVec = ACS_GetInputVectorInCamSpace( stickInputX, stickInputY );
		boatHeadingVec = this.GetHeadingVector();		
		headingVec = VecNormalize2D( inputVec * 0.05 + boatHeadingVec * 1.0 );
		if (GetCurrentGear() < 0) headingVec = - headingVec;
		heading = VecHeading(headingVec);
		
		switch( GetCurrentGear() )
		{
			case -1:
				return;
			case 1:
				return;
			case 2:
				maxBoatSpeed = 16.0f;
				break;
			case 3:
				maxBoatSpeed = 30.0f;
				break;
		}

		currentSpeed = ACS_deltaDamper.UpdateAndGet( deltaTime, maxBoatSpeed );
		min = currentSpeed - RandRangeF( (0.1f * ACS_deltaDamper.GetValue()),0.f );
		max = currentSpeed + RandRangeF( (0.1f * ACS_deltaDamper.GetValue()),0.f );
		linVelocity = VecConeRand(heading, 10.0f, min, max);
		((CBoatBodyComponent)boatEntity.GetComponentByClassName( 'CBoatBodyComponent' )).SetPhysicalObjectLinearVelocity( linVelocity );
	}
}

@addMethod(CBoatComponent) function ACS_GetInputVectorInCamSpace( stickInputX : float, stickInputY : float ) : Vector
{
	var inputVec : Vector;
	var inputHeading : float;
	
	inputVec.X = stickInputX;
	inputVec.Y = stickInputY;
	inputVec = VecNormalize2D(inputVec);
	inputHeading = AngleDistance( theCamera.GetCameraHeading(), -VecHeading( inputVec ) ); 
	inputVec = VecFromHeading( inputHeading );
	
	return inputVec;
}

@addMethod(CBoatComponent) function ACS_CheckForCollision() : bool
{
	var startPos : Vector;
	var heading : Vector;
	var endPos, outPos, normal : Vector;
	var ret : bool;
	var CheckCollisionGroups : array<name>;
	var anticipationDist, heightOffset, radius : float;

	anticipationDist = 25;
	heightOffset = 0.3;
	radius = 0.45;
	
	CheckCollisionGroups.PushBack( 'Static' );		
	CheckCollisionGroups.PushBack( 'Terrain' );
	CheckCollisionGroups.PushBack( 'BoatDocking' );
	
	startPos = this.GetWorldPosition();
	heading = this.GetHeadingVector();
	
	endPos = startPos + heading * anticipationDist;
	startPos.Z += heightOffset;
	endPos.Z += heightOffset;
	
	if( theGame.GetWorld().SweepTest( startPos, endPos, radius, outPos, normal, CheckCollisionGroups ) ) 
		return true;
	else
		return false;
}

@addMethod(CBoatComponent) function ACS_IsPlayerInput() : bool
{	
	if ( ( AbsF(theInput.GetActionValue( 'GI_AxisLeftX' )) + 
	AbsF(theInput.GetActionValue( 'GI_AxisLeftY' )) +
	AbsF(theInput.GetActionValue( 'GI_Accelerate' )) + 
	AbsF(theInput.GetActionValue( 'GI_Decelerate' )) ) > 0 )
	{
		return true;
	}

	return false;
}

@wrapMethod( CInventoryComponent ) function ReduceItemDurability(itemId : SItemUniqueId, optional forced : bool) : bool
{
	var dur, value, durabilityDiff, itemToughness, indestructible : float;
	var chance : int;

	if(false)
	{
		wrappedMethod(itemId, forced);
	}

	if(!IsIdValid(itemId) || !HasItemDurability(itemId) || ItemHasAbility(itemId, 'MA_Indestructible'))
	{
		return false;
	}
	
	
	if(IsItemWeapon(itemId))
	{	
		chance = theGame.params.DURABILITY_WEAPON_LOSE_CHANCE;
		value = theGame.params.GetWeaponDurabilityLoseValue();
	}
	else if(IsItemAnyArmor(itemId))
	{
		chance = theGame.params.DURABILITY_ARMOR_LOSE_CHANCE;			
		value = theGame.params.DURABILITY_ARMOR_LOSE_VALUE;
	}
	
	dur = GetItemDurability(itemId);
	
	if ( dur == 0 )
	{
		if( IsItemWeapon( itemId ) && !((W3ReplacerCiri)thePlayer) )
		{ 
			GetWitcherPlayer().SoundEvent("cmb_play_parry");
			GetWitcherPlayer().SoundEvent("cmb_deflect_arrow");

			DropItem(itemId, false ); 
			
			if( IsItemSilverSwordUsableByPlayer( itemId ) ) 
			{ 
				GetACSWatcher().RemoveTimer('remove_silversword_from_inv'); 
				GetACSWatcher().AddTimer('remove_silversword_from_inv', 0.1, false ); 
			} 
			else
			{
				GetACSWatcher().RemoveTimer('remove_steelsword_from_inv'); 
				GetACSWatcher().AddTimer('remove_steelsword_from_inv', 0.1, false ); 
			}

			if ( thePlayer.IsGuarded() ) 
			{ 
				thePlayer.SetGuarded(false);
				thePlayer.OnGuardedReleased(); 
			}
		}    

		return false;
	}

	
	if ( forced || RandRange( 100 ) < chance )
	{
		itemToughness = CalculateAttributeValue( GetItemAttributeValue( itemId, 'toughness' ) );
		indestructible = CalculateAttributeValue( GetItemAttributeValue( itemId, 'indestructible' ) );

		value = value * ( 1 - indestructible );

		if ( itemToughness > 0.0f && itemToughness <= 1.0f )
		{
			durabilityDiff = ( dur - value ) * itemToughness;
			
			SetItemDurabilityScript( itemId, MaxF(durabilityDiff, 0 ) );
		}
		else
		{
			SetItemDurabilityScript( itemId, MaxF( dur - value, 0 ) );
		}
	}

	return true;
}
