/*
@addField(CR4HudModuleMinimap2)
var acs_clock_init_x: float;

@addField(CR4HudModuleMinimap2)
const var ACS_MINIMAP_X:int; 
default ACS_MINIMAP_X = 700;

@addField(CR4HudModuleMinimap2)
const var ACS_CLOCK_X:int; 
default ACS_CLOCK_X = -120;
*/

/*
@wrapMethod( CR4HudModuleMinimap2 ) function OnConfigUI()
{
	var manager : CCommonMapManager;
	var flashModule : CScriptedFlashSprite;
	var hud : CR4ScriptedHud;
	var inGameConfigWrapper : CInGameConfigWrapper;

	if(false) 
	{
		wrappedMethod();
	}

	m_flashValueStorage = GetModuleFlashValueStorage();
	m_anchorName = "mcAnchorMiniMap"; 
	acs_clock_init_x = GetModuleFlash().GetChildFlashSprite("mcWorldCondition").GetX(); // EternalHunt
	super.OnConfigUI();

	flashModule = GetModuleFlash();

	m_fxSetMapSettingsSFF				= flashModule.GetMemberFlashFunction( "SetMapSettings" );
	m_fxSetTextureExtensionsSFF			= flashModule.GetMemberFlashFunction( "SetTextureExtensions" );
	m_fxSetZoomSFF						= flashModule.GetMemberFlashFunction( "SetZoom" );
	m_fxSetPlayerRotationSFF			= flashModule.GetMemberFlashFunction( "SetPlayerRotation" );
	m_fxSetPlayerPositionSFF			= flashModule.GetMemberFlashFunction( "SetPlayerPosition" );
	m_fxSetPlayerPositionAndRotationSFF	= flashModule.GetMemberFlashFunction( "SetPlayerPositionAndRotation" );
	m_fxNotifyPlayerEnteredInteriorSFF	= flashModule.GetMemberFlashFunction( "NotifyPlayerEnteredInterior" );
	m_fxNotifyPlayerExitedInteriorSFF	= flashModule.GetMemberFlashFunction( "NotifyPlayerExitedInterior" );
	m_fxDoFadingSFF						= flashModule.GetMemberFlashFunction( "DoFading" );
	m_fxEnableRotationSFF				= flashModule.GetMemberFlashFunction( "EnableRotation" );
	m_fxEnableMask						= flashModule.GetMemberFlashFunction( "EnableMask" );
	m_fxEnableDebug						= flashModule.GetMemberFlashFunction( "EnableDebug" );
	m_fxEnableBorders					= flashModule.GetMemberFlashFunction( "EnableBorders" );
	
	b24HRFormat = GetCurrentTextLocCode() != "EN";

	LoadMinimapSettings();
	
	m_zoomValue = MINIMAP_EXTERIOR_ZOOM;
	SetZoom( m_zoomValue, true );

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		EnableRotation( hud.IsEnabledMinimapRotation() );
	}

	m_fadedOut = true;
	DoFading( !m_fadedOut, true );

	
	
	SetTickInterval( 1 );
	
	if (hud)
	{
		
		
		hud.UpdateHudConfig('Minimap2Module', true);		
	}
	
	manager = theGame.GetCommonMapManager();
	if ( manager )
	{
		manager.InitializeMinimapManager( this );
		manager.SetHintWaypointParameters(
			HINT_WAYPOINTS_MAX_REMOVAL_DISTANCE
			, HINT_WAYPOINTS_MIN_PLACING_DISTANCE
			, HINT_WAYPOINTS_REFRESH_INTERVAL
			, HINT_WAYPOINTS_PATHFIND_TOLERANCE
			, HINT_WAYPOINTS_MAX_COUNT );
	}
	
	
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	minimapDuringFocusCombat = false; // EternalHunt
	
}

@wrapMethod( CR4HudModuleMinimap2 ) function UpdateWeatherDisplay()
{
	var currentWeather : name = 'Clear';
	var currentDayTimeName : name;
	var curGameTime : GameTime;
	var curGameHour: int;
	var curGameMin: int;
	var dayPart : EDayPart;

	if(false) 
	{
		wrappedMethod();
	}

	currentDayTimeName = m_dayTimeName;
		
	curGameTime = GameTimeCreate();
	curGameHour = GameTimeHours( curGameTime );	
	curGameMin = GameTimeMinutes( curGameTime );			

	if ( m_gameMin != curGameMin )
	{
		if ( curGameHour >= 22 || curGameHour < 4 )
		{
			DoFading( true, false );
		}
		else
		{
			DoFading( false, false );
		}
	}

	if ( bDisplayDayTime && !thePlayer.GetWeatherDisplayDisabled() ) // EternalHunt
	{
		if ( m_gameHour != curGameHour)
		{
			dayPart = GetDayPart(curGameTime);
			
			if(dayPart == EDP_Dawn)
			{
				
				currentDayTimeName = 'Dawn';
			}
			else if(dayPart == EDP_Noon)
			{
				
				currentDayTimeName = 'Noon';
			}
			else if(dayPart == EDP_Dusk)
			{
				
				currentDayTimeName = 'Dusk';
			}
			else if(dayPart == EDP_Midnight)
			{
				
				currentDayTimeName = 'Midnight'; 
			}
			else
			{
				LogAssert(false, "UpdateWeatherDisplay: unknow day part!");
			}
		}
		
		if( GetRainStrength() > 0 ) 
		{
			currentWeather = 'Rain';
		}
		else if( GetSnowStrength() > 0 )
		{
			currentWeather = 'Snow';
		}			
		
		if ( currentWeather != m_weatherType || currentDayTimeName != m_dayTimeName || m_gameHour != curGameHour || curGameMin != m_gameMin )
		{
			m_weatherType = currentWeather;
			m_dayTimeName = currentDayTimeName;
			m_gameHour = curGameHour;
			m_gameMin = curGameMin;
			m_flashValueStorage.SetFlashString('hud.worldcondition.weather',(m_dayTimeName + m_weatherType));
			RefreshTimeDisplay();
		}
	}
	else
	{
		m_weatherType = '';
		m_dayTimeName = '';
		m_flashValueStorage.SetFlashString('hud.worldcondition.weather',"");
		
		if ( m_gameHour != curGameHour || m_gameMin != curGameMin )
		{
			m_gameHour = curGameHour;
			m_gameMin = curGameMin;
		}
	}
}

@wrapMethod( CR4HudModuleMinimap2 ) function SetMinimapDuringFocusCombat(enable : bool)
{
	var hud : CR4ScriptedHud;

	if(false) 
	{
		wrappedMethod(enable);
	}
	
	minimapDuringFocusCombat = false; // EternalHunt

	if(!minimapDuringFocusCombat)
	{
		hud = (CR4ScriptedHud)theGame.GetHud();
		if ( hud )
			hud.UpdateHudConfig('Minimap2Module', true);	
	}
	else
	{
		//fadeInTimer = 5.5;
	}
}

@addMethod(CR4HudModuleMinimap2) function UpdatePosition(anchorX:float, anchorY:float) : void 
{
	var tempX, tempY, scale: float;
	var l_flashModule: CScriptedFlashSprite;

	l_flashModule = GetModuleFlash();

	scale = theGame.GetUIScale()+theGame.GetUIGamepadScaleGain();

	tempX = anchorX;

	if (!ACS_Minimap_Enabled()) 
	{
		tempX += ACS_MINIMAP_X*scale;
	}

	tempX = ( tempX - curResolutionWidth/2 ) * ( theGame.GetUIHorizontalFrameScale() ) + curResolutionWidth/2;

	l_flashModule.SetX( tempX );
	
	tempY = ( anchorY - curResolutionHeight/2 ) * (theGame.GetUIVerticalFrameScale() ) + curResolutionHeight/2;
	
	l_flashModule.SetY( tempY );

	if (!ACS_Minimap_Enabled()) 
	{
		tempX = -ACS_MINIMAP_X+ACS_CLOCK_X;
	} 
	else 
	{
		tempX = acs_clock_init_x;
	}

	tempX = ( tempX - curResolutionWidth/2 ) * ( theGame.GetUIHorizontalFrameScale() ) + curResolutionWidth/2;

	l_flashModule.GetChildFlashSprite("mcWorldCondition").SetX(tempX);
}
*/

///////////////////////////////////////////////////////////////////////////////////

/*
@addField(CR4HudModuleQuests)
const var ACS_QUESTS_Y: int; 
default ACS_QUESTS_Y = -160;

@addMethod(CR4HudModuleQuests) protected function UpdatePosition(anchorX:float, anchorY:float) : void 
{
	var tempX, tempY, scale: float;
	var l_flashModule: CScriptedFlashSprite;

	l_flashModule = GetModuleFlash();

	scale = theGame.GetUIScale()+theGame.GetUIGamepadScaleGain();

	tempX = ( anchorX - curResolutionWidth/2 ) * ( theGame.GetUIHorizontalFrameScale() ) + curResolutionWidth/2;

	l_flashModule.SetX(tempX);tempY = anchorY;

	if (!ACS_Minimap_Enabled()) 
	{
		tempY += ACS_QUESTS_Y*scale;
	}

	tempY = ( tempY - curResolutionHeight/2 ) * (theGame.GetUIVerticalFrameScale() ) + curResolutionHeight/2;

	l_flashModule.SetY(tempY);
}
*/

///////////////////////////////////////////////////////////////////////////////////

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

	if (ACS_Enabled()){overrideTicketsCount = 0;importance = ACS_AttackImportance(npc);}//EternalHunt

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
	
	if ( thePlayer.IsCameraControlDisabled( 'Finisher' ) )
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
			thePlayer.SetWalkToggle(false);
			
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
	if(false) 
	{
		wrappedMethod(weaponType);
	}
	
	ACS_Equip_Weapon( weaponType ); //EternalHunt
}

@wrapMethod( SelectingWeapon ) function EquipMeleeWeapon( weapontype : EPlayerWeapon, optional sheatheIfAlreadyEquipped : bool )
{
	var isAWeapon	: bool;
	var fists : W3PlayerWitcherStateCombatFists;
	var item : SItemUniqueId;
	var items : array<SItemUniqueId>;
	var owner : CActor; 
	
	if(false) 
	{
		wrappedMethod(weapontype, sheatheIfAlreadyEquipped);
	}
	
	if( thePlayer.GetCurrentStateName() == 'PlayerDialogScene' )
	{
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
	if ( ACS_Enabled() ) { ACS_WeaponHolsterInit(); } //EternalHunt
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

	if ( ACS_Enabled() ) { ACS_Dodge(); } //EternalHunt	

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
	
	if (ACS_Enabled() && this == thePlayer) { totalDamage = ACS_Player_Fall_Damage() * thePlayer.GetMaxHealth(); dmgPerc = 0; } //EternalHunt
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
var resetVelocity : bool;

@addMethod(CExplorationStateJump) function ACS_TickJump(dt : float) 
{
	var velocity : Vector;
	var maxSpeed : float;

	if (resetVelocity && m_ExplorationO.GetStateTimeF() > 1.0f) 
	{
		velocity = m_ExplorationO.m_MoverO.GetDisplacementLastFrame() / dt;
	} 
	else 
	{
		velocity = m_ExplorationO.m_MoverO.GetMovementVelocity();
	}
	
	resetVelocity = false;
	
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
	&& ACS_JumpExtend_Enabled() )
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
protected var ignoreFirstRelease : bool;

@addField(CExplorationStateSlide)
private var firstFrameImpulse : Vector;

@addField(CExplorationStateSlide)
private var previousDt : float;

@addField(CExplorationStateSlide)
private var ignoringOneFrameOfZeroDisplacement : bool;

@addField(CExplorationStateSlide)
private var isFirstSlideEverywhereFrame : bool;

@addField(CExplorationStateSlide)
private var lastSlideExitTime : float;

@addField(CExplorationStateSlide)
private var lastSlideRightFootForward : bool;

@addField(CExplorationStateSlide)
private var slideFrictionMultiplier : float;

@addField(CExplorationStateSlide)
private var airTime : float;

@addField(CExplorationStateSlide)
private var wantLeaveToJump : bool;

@addField(CExplorationStateSlide)
private var kneeBend : float;

@addField(CExplorationStateSlide)
private var slowEnoughToExit : bool;

@addField(CExplorationStateSlide)
private var startedManually : bool;

@addField(CExplorationStateSlide)
private var flameFxLeft : CEntity;

@addField(CExplorationStateSlide)
private var flameFxRight : CEntity;

@addField(CExplorationStateSlide)
private var boneIndexLeftFoot : int;

@addField(CExplorationStateSlide)
private var boneIndexRightFoot : int;

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
	slideFrictionMultiplier = 1.0f; //EternalHunt
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
		ignoreFirstRelease = true;

		startedManually = true;
		firstFrameImpulse = 2.5f * VecFromHeading(m_ExplorationO.m_OwnerE.GetHeading());
	}
	else
	{
		ignoreFirstRelease = false;
		startedManually = false;
		firstFrameImpulse = velocity;
	}

	slowEnoughToExit = false;
	wantLeaveToJump = false;
	m_ExplorationO.m_MoverO.SetVerticalSpeed(0.0f);
	previousDt = 1.0f;
	isFirstSlideEverywhereFrame = true;
	airTime = 0.0f;
	kneeBend = 0.0f;
	boneIndexLeftFoot = m_ExplorationO.m_OwnerE.GetBoneIndex( 'l_foot' );
	boneIndexRightFoot = m_ExplorationO.m_OwnerE.GetBoneIndex( 'r_foot' ); //EternalHunt
	
	
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
	if (theGame.GetEngineTimeAsSeconds() < lastSlideExitTime + 1.0f ) {isRightFootForward = !lastSlideRightFootForward;} //EternalHunt
	m_ExplorationO.SetBehaviorParamBool( behRightFootForwardVar, isRightFootForward );
	lastSlideRightFootForward = isRightFootForward; //EternalHunt
	
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
	
	
	if( !ignoreFirstRelease && jumpAllowed && m_ExplorationO.GetStateTimeF() >= jumpCoolDownTime ) //EternalHunt
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
	if (!ACS_SlideEverywhereCancel() && !slowEnoughToExit) {return GetStateName();} //EternalHunt
	
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
	if (ACS_SlideEverywhereCancelCommand() || (!startedManually && m_ExplorationO.GetStateTimeF() < 1.0f))
	{
		return true;
	}

	return false;
}

@addMethod(CExplorationStateSlide) function ACS_RemoveFlameFx()
{
	ACSGetCEntity('ACS_Slide_Particle_Left').Destroy();
	ACSGetCEntity('ACS_Slide_Particle_Right').Destroy();

	flameFxRight = NULL;

	flameFxLeft = NULL;
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
		m_ExplorationO.m_OwnerE.GetBoneWorldPositionAndRotationByIndex(boneIndexLeftFoot, leftPos, leftRot);
		m_ExplorationO.m_OwnerE.GetBoneWorldPositionAndRotationByIndex(boneIndexRightFoot, rightPos, rightRot);
		leftRot = VecToRotation(m_ExplorationO.m_OwnerE.GetWorldForward());
		rightRot = VecToRotation(m_ExplorationO.m_OwnerE.GetWorldForward());

		leftRot.Yaw -= 90; rightRot.Yaw -= 90;
		
		if(!flameFxLeft)
		{
			ACSGetCEntity('ACS_Slide_Particle_Left').Destroy();
			ACSGetCEntity('ACS_Slide_Particle_Right').Destroy();
			
			rangeFxTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\slide_particles.w2ent", true);
			
			flameFxLeft = theGame.CreateEntity(rangeFxTemplate, leftPos, leftRot);
			
			flameFxLeft.AddTag('ACS_Slide_Particle_Left');

			flameFxLeft.PlayEffectSingle('burn');
			
			flameFxLeft.PlayEffectSingle('burn_2');
			
			flameFxLeft.PlayEffectSingle('igni_reaction_djinn');
			
			flameFxRight = theGame.CreateEntity(rangeFxTemplate, rightPos, rightRot);
			
			flameFxRight.AddTag('ACS_Slide_Particle_Right');
			
			flameFxRight.PlayEffectSingle('burn');
			
			flameFxRight.PlayEffectSingle('burn_2');
			
			flameFxRight.PlayEffectSingle('igni_reaction_djinn');
		}
		else
		{
			flameFxLeft.TeleportWithRotation(leftPos, leftRot);
			flameFxRight.TeleportWithRotation(rightPos, rightRot);
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
		airTime = 0.0f;
	} 
	else 
	{
		airTime += _Dt;
	}

	displacementLastFrame = m_ExplorationO.m_MoverO.GetDisplacementLastFrame();
	
	expectedVelocity = m_ExplorationO.m_MoverO.GetMovementVelocity();

	expectedDisplacement = expectedVelocity * _Dt;
	
	if (ignoringOneFrameOfZeroDisplacement) 
	{
		ignoringOneFrameOfZeroDisplacement = false;
	} 
	else if (VecLengthSquared(displacementLastFrame) == 0.0f) 
	{
		displacementLastFrame = expectedDisplacement;ignoringOneFrameOfZeroDisplacement = true;
	}
	
	if (!isFirstSlideEverywhereFrame) 
	{
		collisionZ = displacementLastFrame.Z - expectedDisplacement.Z;

		kneeAbsorb = ClampF(collisionZ, -0.05f - kneeBend, 0.1f - kneeBend);

		displacementLastFrame.Z -= kneeAbsorb;kneeBend += kneeAbsorb;

		kneeBend += ClampF(-kneeBend, -0.1f * _Dt, 0.1f * _Dt);
	}
	
	ACS_UpdateFlameFx(m_ExplorationO.m_OwnerE.GetWorldRotation());

	if (_Dt > previousDt * 2.0f) 
	{
		expectedDisplacement.Z -= kneeAbsorb;velocity = expectedDisplacement / _Dt;
	} 
	else 
	{
		velocity = displacementLastFrame / _Dt;
	}
	
	previousDt = _Dt;
	
	if (isFirstSlideEverywhereFrame) 
	{
		if (startedFromRoll) 
		{
			if (VecLength(velocity) > 1.0f) 
			{
				velocity = VecNormalize(velocity) * 1.0f;
			}
		}
		
		firstFrameVelocity = velocity + firstFrameImpulse;
		
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
	
	isFirstSlideEverywhereFrame = false;
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
		
		totalFriction += terrainNormal.Z * 2.0f * slideFrictionMultiplier;
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
	
	slowEnoughToExit = VecLength(velocity) < 1.0f;
	
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

	if (ignoreFirstRelease) 
	{
		if (theInput.IsActionJustReleased( ACS_SlideEverywhereCommand() )) 
		{
			ignoreFirstRelease = false;
		}
	} 
	else 
	{
		if (theInput.IsActionJustPressed( ACS_SlideEverywhereCommand() )) 
		{
			wantLeaveToJump = true;
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
		
		stoppingFriction	= subState == SSS_Exiting || (!WantsToEnterBasic( true ) && (ACS_SlideEverywhereCancel() || slowEnoughToExit)); //EternalHunt
		
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

	lastSlideExitTime = theGame.GetEngineTimeAsSeconds();m_ExplorationO.m_MoverO.SetManualMovement( false );m_ExplorationO.m_OwnerMAC.SetGravity( true );m_ExplorationO.m_OwnerMAC.SetUseExtractedMotion(true);ACS_RemoveFlameFx(); //EternalHunt
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
	
	if (checkingForExit && airTime > 0.0f && airTime < 0.5f) {return true;} //EternalHunt
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

	if(!ACS_SlideEverywhereCancel() && !slowEnoughToExit){return false;} //EternalHunt
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

	if( subState > SSS_Entering && ACS_SlideEverywhereCancel() && !wantLeaveToJump && airTime > 0.5f) //EternalHunt
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

	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0)
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

	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0)
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

	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0)
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
	if (FactsQuerySum("ACS_Direct_Movement_Turns_Disabled") > 0)
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
	
	if (ACS_GetTargetingCastSignTowardsCameraCheck())
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
	else
	if ( useNativeTargeting )
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
		
	cameraWeight = ACS_GetTargetingCameraWeight();
	movementWeight = ACS_GetTargetingMovementWeight();
	facingWeight = ACS_GetTargetingFacingWeight();
	distanceWeight = ACS_GetTargetingDistanceWeight();
	targetHysteresis = ACS_GetTargetingHysteresis();
	targetingInfo.inFrameCheck = ACS_GetTargetingInFrameCheck();
	
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
	
	if ( IsSwimming() )
		targetingInfo.coneDist = theGame.params.MAX_THROW_RANGE;
	else
		targetingInfo.coneDist = softLockDist;
	
	if ( currentTarget && IsHardLockEnabled() && currentTarget.IsAlive() && !currentTarget.IsKnockedUnconscious() )
	{
		if ( VecDistanceSquared( playerPosition, currentTarget.GetWorldPosition() ) > ACS_GetTargetingDistanceMax() * ACS_GetTargetingDistanceMax() )
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
		
	if (ACS_GetTargetingDisableCameraLock())
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

@wrapMethod(W3PlayerAbilityManager) function OnVitalityChanged()
{
	wrappedMethod();

	if (!thePlayer.HasTag('ACS_Vitality_Changed'))
	{
		thePlayer.AddTag('ACS_Vitality_Changed');
	}

	GetACSWatcher().RemoveTimer('Vitality_Changed_Reset');
	GetACSWatcher().AddTimer('Vitality_Changed_Reset', ACS_Hud_Elements_Despawn_Delay(), false);
}

@wrapMethod(W3PlayerAbilityManager) function OnToxicityChanged()
{
	wrappedMethod();

	if (!thePlayer.HasTag('ACS_Toxicity_Changed'))
	{
		thePlayer.AddTag('ACS_Toxicity_Changed');
	}

	GetACSWatcher().RemoveTimer('Toxicity_Changed_Reset');
	GetACSWatcher().AddTimer('Toxicity_Changed_Reset', ACS_Hud_Elements_Despawn_Delay(), false);
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
		GetACSWatcher().AddTimer('Focus_Changed_Reset', ACS_Hud_Elements_Despawn_Delay(), false);
	}
	else
	{
		GetACSWatcher().RemoveTimer('Focus_Changed_Reset');
		GetACSWatcher().AddTimer('Focus_Changed_Reset', ACS_Hud_Elements_Despawn_Delay(), false);
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

@addMethod( W3PlayerWitcher ) timer function ACS_DelayedLevelUpEquipped( dt : float, id : int )
{
	ACS_LevelUpEquipped();
}

@wrapMethod( W3PlayerWitcher ) function EquipItemInGivenSlot(item : SItemUniqueId, slot : EEquipmentSlots, ignoreMounting : bool, optional toHand : bool) : bool
{
	wrappedMethod(item, slot, ignoreMounting, toHand);

	ACS_LevelUpEquipped();

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

	if (ACS_DisableItemAutoscale())
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

	if( substateManager.m_SharedDataO.IsForceHeading( targetRotation ) )
	{
		moveData.pivotRotationController.SetDesiredHeading( targetRotation.Yaw );
		moveData.pivotRotationController.SetDesiredPitch( targetRotation.Pitch );
		moveData.pivotRotationValue.Yaw		= LerpAngleF( 2.1f * dt, moveData.pivotRotationValue.Yaw, targetRotation.Yaw );
		moveData.pivotRotationValue.Pitch	= LerpAngleF( 1.0f * dt, moveData.pivotRotationValue.Pitch, targetRotation.Pitch );
		
	}
	
	if( customCameraStack.Size() > 0 )
	{
		
		
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
		
		trigger.SetScale( scale );
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
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\aard_cone_fix.w2ent"

		, true ), pos, rot );

		//ent.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.DestroyAfter(3);
	}
}

@wrapMethod(IgniCast) function OnThrowing()
{
	var ent                  				: CEntity;
	var rot                        			: EulerAngles;
    var pos									: Vector;
	var player								: CR4Player;

	player = caster.GetPlayer();

	wrappedMethod();

	if( super.OnThrowing() && player )
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\aard_cone_fix.w2ent"

		, true ), pos, rot );

		//ent.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone_old');

		ent.DestroyAfter(3);
	}
}