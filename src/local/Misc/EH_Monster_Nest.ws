/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/

struct SACSMonsterNestUpdateDefinition
{
	editable saved var isRebuilding					: bool; 
	editable saved  var defaultPhaseToActivate 		: name;
	editable saved var bossPhaseToActivate 			: name;
	editable var hasBoss							: bool; 
	editable var bossSpawnDelay						: float; 
	editable inlined var nestRebuildSchedule    	: GameTimeWrapper;
	
	default defaultPhaseToActivate = 'default';
	default bossPhaseToActivate = 'boss';
}

statemachine class CACSMonsterNestEntity extends CInteractiveEntity
{
	editable var bombActivators 							: array<name>;
	editable var lootOnNestDestroyed						: CEntityTemplate;
	editable var interactionOnly							: bool; default interactionOnly = true;
	editable var desiredPlayerToEntityDistance				: float; default desiredPlayerToEntityDistance = -1;
	editable var matchPlayerHeadingWithHeadingOfTheEntity	: bool;	default matchPlayerHeadingWithHeadingOfTheEntity = true;		
	editable var settingExplosivesTime 						: float;
	editable var shouldPlayFXOnExplosion					: bool;
	editable var appearanceChangeDelayAfterExplosion		: float;
	editable var shouldDealDamageOnExplosion				: bool;
	editable var factSetAfterFindingNest 					: string;
	editable var factSetAfterSuccessfulDestruction 			: string;
	editable var linkingMode								: bool;
	editable var linkedEncounterHandle 						: EntityHandle;
	editable var linkedEncounterTag							: name;
	editable var setDestructionFactImmediately 				: bool;
	editable var expOnNestDestroyed							: int; default expOnNestDestroyed = 20;
	editable var bonusExpOnBossKilled						: int; default expOnNestDestroyed = 100;
	editable var addExpOnlyOnce								: bool; default addExpOnlyOnce = false;
	editable saved var nestUpdateDefintion					: SACSMonsterNestUpdateDefinition;
	editable var monsterNestType							: ENestType; 
	editable var regionType									: EEP2PoiType;
	editable var entityType									: EMonsterNestType; default entityType = EMNT_Regular;
	
		hint desiredPlayerToEntityDistance = "if set to < 0 player will stay in position where interaction was pressed";
		hint setDestructionFactImmediately = "if set then destrution fact is added immediately on destruction";
	
	var explodeAfter 			: float;
	var nestBurnedAfter 		: float;
	var playerInventory 		: CInventoryComponent;
	var usedBomb 				: SItemUniqueId;
	var encounter 				: CEncounter;
	saved var nestFound 		: bool;
	var messageTimestamp 		: float;
	var bossKilled				: bool;
	var container				: W3Container;
	var bossKilledCounter 		: int;
	saved var expWasAdded		: bool;
	var bombEntity				: CEntity;
	var bombEntityTemplate		: CEntityTemplate;
	var bombName				: name;
	var actionBlockingExceptions : array<EInputActionBlock>;
	var saveLockIdx				: int;
	saved var voicesetTime		: float;
	saved var voicesetPlayed 	: bool;
	saved var canPlayVset		: bool;
	saved var l_enginetime		: float;
	
	 var airDmg			: bool;
	
	
	autobind interactionComponent 		: CInteractionComponent 	= "CInteractionComponent0";
	
	saved var wasExploded : bool;	default wasExploded = false;
	
	default shouldPlayFXOnExplosion = true;
	default shouldDealDamageOnExplosion = true;
	default linkingMode = true;
	default settingExplosivesTime = 3.0;
	default explodeAfter = 4.0;
	default nestBurnedAfter = 4.0;
	default nestFound = false;
	default messageTimestamp = 0.0;
	default autoState = 'CACSMonsterNestIntact';
	default bossKilled = false;
	default bombName = 'petard';
	default voicesetPlayed = false;
	default canPlayVset = true;
	default monsterNestType = EN_None;
		
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		
		if ( spawnData.restored )
		{
			SetMappinOnLoad ();
			if ( wasExploded )
			{
				SetFocusModeVisibility(0);
				
				if ( IsBossProtectingNest() )
				{
					ApplyAppearance( 'nest_destroyed' );
					GotoState( 'CACSMonsterNestNestDestroyedBoss' );
				}
				else
				{
					ApplyAppearance( 'nest_destroyed' );
					GotoState( 'CACSMonsterNestNestDestroyed' );
				}
			}
			else
			{
				SetFocusModeVisibility(FMV_Interactive);
				GotoStateAuto();
			}
		}
		
		else
		{
			GotoStateAuto();
			
			SetFocusModeVisibility(FMV_Interactive);
		}
	}
		
		
	event OnFireHit(source : CGameplayEntity)
	{
		if ( !interactionOnly && !wasExploded )
		{
			GetEncounter();
			wasExploded = true;
			
			interactionComponent.SetEnabled( false );
			airDmg = false;
			GotoState( 'CACSMonsterNestExplosion' );	
		}
	}
	
	event OnAardHit( sign : W3AardProjectile)
	{
		if ( !interactionOnly && !wasExploded )
		{
			GetEncounter();
			wasExploded = true;
			interactionComponent.SetEnabled( false );
			airDmg = true;
			GotoState( 'CACSMonsterNestExplosion' );	
		}
	}
	
	event OnInteractionActivationTest( interactionComponentName : string, activator : CEntity )
	{
		
	}
	
	event OnInteractionActivated( interactionComponentName : string, activator : CEntity )
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		if ( !wasExploded && !interactionComponent.IsEnabled() && interactionComponent  )
		{
			interactionComponent.SetEnabled( true );
		}	
		if( !nestFound )
		{
			if( interactionComponentName != "triggerQuestArea" )
				return false;
			FactsAdd( factSetAfterFindingNest, 1 );
			
			commonMapManager.SetEntityMapPinDiscoveredScript( false, entityName, true );
			
			nestFound = true;
		}
	}
	
	event OnInteraction( actionName : string, activator : CEntity )
	{
		if ( activator != thePlayer || !thePlayer.CanPerformPlayerAction())
		{
			return false;
		}
	
		if( interactionComponent && wasExploded && interactionComponent.IsEnabled() )
		{
			interactionComponent.SetEnabled( false );
		}
		
		if( PlayerHasBombActivator() )
		{
			if( interactionComponent && interactionComponent.IsEnabled() )
			{
				theGame.CreateNoSaveLock( 'nestSettingExplosives', saveLockIdx );
				wasExploded = true;
				GetEncounter();
				interactionComponent.SetEnabled( false );
				GotoState( 'CACSMonsterNestSettingExplosives' );
			}
			return true;
		}
		else
		{
			GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt( "panel_hud_message_destroy_nest_bomb_lacking" ) );
			messageTimestamp = theGame.GetEngineTimeAsSeconds();
		}
		return false;
	}
	
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		if ( area == (CTriggerAreaComponent)this.GetComponent( "VoiceSetTrigger" ) && CanPlayVoiceSet() )
		{ 
			l_enginetime = theGame.GetEngineTimeAsSeconds();
			
			if ( !voicesetPlayed || ( l_enginetime > voicesetTime + 60.0f ) )
			{
				thePlayer.PlayVoiceset( 90, GetVoicesetName( monsterNestType ) );
				voicesetTime = theGame.GetEngineTimeAsSeconds();
				voicesetPlayed = true;
			}
			
		}
	}
	
	
	public function GetRegionType() : int
	{
		return (int) regionType;
	}

	
	public function GetEntityType() : int
	{
		return (int) entityType;
	}

	function CanPlayVoiceSet() : bool
	{
		return !thePlayer.IsSpeaking() && !thePlayer.IsInNonGameplayCutscene() && !thePlayer.IsCombatMusicEnabled() && canPlayVset && !wasExploded;
	}
	
	function GetVoicesetName( val : ENestType ) : name
	{
		switch ( val )
		{
			case EN_Drowner 		: return 'MonsterNestDrowners';
			case EN_Draconid 		: return 'MonsterNestDraconids';
			case EN_Endriaga 		: return 'MonsterNestEndriags';
			case EN_Ghoul 			: return 'MonsterNestGhuls';
			case EN_Harpy 			: return 'MonsterNestHarpies';
			case EN_Nekker 			: return 'MonsterNestNekkers';
			case EN_Rotfiend 		: return 'MonsterNestRorfiends';
			case EN_Siren 			: return 'MonsterNestSirens';
			case EN_Wyvern	 		: return 'MonsterNestWiwerns';
			case EN_BlackSpider		: return 'DetectNestArachnomorphs';
			case EN_Kikimora		: return 'MonsterNestKikimoras';
			case EN_Archespore		: return 'MonsterNestArchespores';
			case EN_Scolopendromorph: return 'MonsterNestScolopendromorps';
			default					: return ''; 				
		}
		
	}
	private function SetMappinOnLoad ()
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		if ( wasExploded || expWasAdded )
		{
			commonMapManager.SetEntityMapPinDisabled( entityName, true );
		}
		else if ( nestFound )
		{
			commonMapManager.SetEntityMapPinDiscoveredScript( false, entityName, true );
		}
	}
	function PlayerHasBombActivator() : bool
	{
		var i,j : int;
		var items : array<SItemUniqueId>;
		
		playerInventory = thePlayer.GetInventory();
		
		for( i = 0; i < bombActivators.Size(); i += 1 )
		{
			
			if( playerInventory.HasItem( bombActivators[i] ))
			{
				items.Clear();
				items = playerInventory.GetItemsByName(bombActivators[i]);				
				for(j=0; j<items.Size(); j+=1)
				{
					
					if( playerInventory.SingletonItemGetAmmo(items[j]) > 0 )
					{
						usedBomb = items[j];
						return true;
					}
				}
			}
		}
		return false;
	}
	
	
	event OnAnimEvent_Custom( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
			
		if ( animEventName == 'AttachBomb' && IsNameValid( bombName ))
		{
			bombEntityTemplate = ( CEntityTemplate )LoadResource( bombName );
			bombEntity = theGame.CreateEntity( bombEntityTemplate, thePlayer.GetWorldPosition() );
			bombEntity.CreateAttachment( thePlayer, 'l_weapon');
		}
		else if ( animEventName == 'DetachBomb' )
		{
			bombEntity.DestroyAfter( 0.5 );
			bombEntity.BreakAttachment();
			this.PlayEffect('deploy');
		}
	}
	
	event OnAnimEvent_AttachBomb( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		if( animEventType == AET_DurationEnd &&IsNameValid( bombName ))
		{
			bombEntityTemplate = ( CEntityTemplate )LoadResource( bombName );
			bombEntity = theGame.CreateEntity( bombEntityTemplate, thePlayer.GetWorldPosition() );
			bombEntity.CreateAttachment( thePlayer, 'l_weapon');
			thePlayer.RemoveAnimEventChildCallback(this,'AttachBomb');
		}
	}
	event OnAnimEvent_DetachBomb( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		if ( animEventType == AET_DurationEnd )
		{
			bombEntity.DestroyAfter( 0.5 );
			bombEntity.BreakAttachment();
			this.PlayEffect('deploy');
			thePlayer.BlockAllActions( 'DestroyNest', false );
			thePlayer.RemoveAnimEventChildCallback(this,'DetachBomb');
			
		}
	}
	
	function AddExp ()
	{
		if ( addExpOnlyOnce && expWasAdded )
		{
			return;
		}
		
		expWasAdded = true;
		GetWitcherPlayer().AddPoints(EExperiencePoint, expOnNestDestroyed, true );
		
	}
	
	function BlockPlayerNestInteraction()
	{
		actionBlockingExceptions.PushBack(EIAB_RunAndSprint);
		actionBlockingExceptions.PushBack(EIAB_Sprint);
		thePlayer.BlockAllActions( 'DestroyNest', true, actionBlockingExceptions );
	}
	
	function AddBonusExp ()
	{
		GetWitcherPlayer().AddPoints(EExperiencePoint, bonusExpOnBossKilled, true );
	}
	
	function GetEncounter()
	{
		if ( linkingMode )
		{
			encounter = ( CEncounter )EntityHandleGet( linkedEncounterHandle );
		}
		else
		{
			encounter = ( CEncounter )theGame.GetEntityByTag( linkedEncounterTag );
		}

		if( !encounter )
			LogChannel( 'Error', "Encounter not connected with " + this.GetName() );
	}
	
	
	
	public function SetBossKilled ( killed : bool )
	{
		if ( !encounter )
		{
			GetEncounter();
		}
		bossKilled = killed;
		encounter.EnableEncounter ( false );
		AddBonusExp ();
	}
	public function SetRebuild ( isRebuilding : bool )
	{
		nestUpdateDefintion.isRebuilding = isRebuilding;
	}
	
	public function IncrementBossKilledCounter ()
	{
		bossKilledCounter += 1;
	}
	
	public function GetBossKilledCounter () : int
	{
		return bossKilledCounter;
	}
		
	timer function ProcessRebuildingSchedule( timeDelta : GameTime, id : int )
	{
		
		if ( nestUpdateDefintion.isRebuilding )
		{
			if ( encounter )
			{
				if ( !encounter.IsPlayerInEncounterArea() )
				{				
					GotoState( 'CACSMonsterNestNestRebuild' );			
				}
				else
				{	
					AddGameTimeTimer( 'ProcessRebuildingSchedule', GameTimeCreate( 0,2,0,0 ), false , , , true, true );	
				}
			}
			else 
			{
				if ( VecDistance2D ( GetWorldPosition(), thePlayer.GetWorldPosition() ) > 30.0 )
				{
					GotoState( 'CACSMonsterNestNestRebuild' );	
				}
				else
				{	
					AddGameTimeTimer( 'ProcessRebuildingSchedule', GameTimeCreate( 0,2,0,0 ), false , , , true, true );				
				}
			}
		}
	}
	
	timer function SpawnBoss ( time : float , id : int)
	{
		encounter.SetSpawnPhase ( nestUpdateDefintion.bossPhaseToActivate );
	}
	

    function IsBossProtectingNest () : bool
	{
		if (nestUpdateDefintion.hasBoss && !bossKilled )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public function RebuildNest ()
	{
		 AddGameTimeTimer( 'ProcessRebuildingSchedule', nestUpdateDefintion.nestRebuildSchedule.gameTime, false , , , true, true );				
	}
	
	public function IsSetDestructionFactImmediately() : bool
	{
		return setDestructionFactImmediately;
	}
}

state CACSMonsterNestIntact in CACSMonsterNestEntity
{
	event OnEnterState( prevStateName : name )
	{
		parent.canPlayVset = true;
		super.OnEnterState( prevStateName );
		parent.ApplyAppearance( 'nest_intact' );
	}
}

state CACSMonsterNestSettingExplosives in CACSMonsterNestEntity
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		
		if(ShouldProcessTutorial('TutorialMonsterNest'))
			FactsAdd("tut_nest_blown");
		
		PlayAnimationAndSetExplosives();
	}
	
	
	
	entry function PlayAnimationAndSetExplosives()
	{	
		var movementAdjustor 				: CMovementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		var ticket 							: SMovementAdjustmentRequestTicket = movementAdjustor.CreateNewRequest( 'InteractionEntity' );
		
		thePlayer.OnHolsterLeftHandItem();		
		thePlayer.AddAnimEventChildCallback(parent,'AttachBomb','OnAnimEvent_AttachBomb');
		thePlayer.AddAnimEventChildCallback(parent,'DetachBomb','OnAnimEvent_DetachBomb');
		
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		if ( parent.matchPlayerHeadingWithHeadingOfTheEntity )
			movementAdjustor.RotateTowards( ticket, parent );
		if ( parent.desiredPlayerToEntityDistance >= 0 )
			movementAdjustor.SlideTowards( ticket, parent, parent.desiredPlayerToEntityDistance );
		
		
		thePlayer.PlayerStartAction( PEA_SetBomb );
		
		
		parent.BlockPlayerNestInteraction();
			
		Sleep( parent.settingExplosivesTime );
		
		parent.playerInventory.SingletonItemRemoveAmmo(parent.usedBomb, 1);
			
		if ( parent.IsBossProtectingNest() )
		{
			parent.AddTimer('SpawnBoss', parent.nestUpdateDefintion.bossSpawnDelay, false, , , true );
		}
		
		Sleep( parent.explodeAfter );
		
		parent.GotoState( 'CACSMonsterNestExplosion' );
	}
}

state CACSMonsterNestExplosion in CACSMonsterNestEntity
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		parent.canPlayVset = false;
		
		theGame.ReleaseNoSaveLock( parent.saveLockIdx );
		
		Explosion();
	}
	
	entry function Explosion()
	{
		var wasDestroyed : bool;
		var parentEntity : CR4MapPinEntity;
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		var l_pos			: Vector;
		
		ProcessExplosion();
		
		SleepOneFrame();
		if ( parent.appearanceChangeDelayAfterExplosion > 0 )
		{
			Sleep( parent.appearanceChangeDelayAfterExplosion );
		}
		
		parent.ApplyAppearance( 'nest_destroyed' );
		
		if( parent.lootOnNestDestroyed )
		{
			l_pos = parent.GetWorldPosition();
			l_pos.Z += 0.5;
			parent.container = (W3Container)theGame.CreateEntity( parent.lootOnNestDestroyed, l_pos, parent.GetWorldRotation() );
		}
		
		
		parent.SetFocusModeVisibility(0);
		
		
		if(parent.IsSetDestructionFactImmediately())
			FactsAdd( parent.factSetAfterSuccessfulDestruction, 1 );
			
		
		wasDestroyed = parent.HasTag('WasDestroyed');
		parent.AddTag('WasDestroyed');
			
		
		parentEntity = ( CR4MapPinEntity )parent;
		if ( parentEntity )
		{
			
			if(FactsQuerySum(parentEntity.entityName + "_nest_destr") == 0)
			{
				FactsAdd(parentEntity.entityName + "_nest_destr");		
				ACSCheckNestDestructionAchievement();	
			}
		}
		
		
		if(!wasDestroyed && !parent.HasTag('AchievementFireInTheHoleExcluded'))
		{
			theGame.GetGamerProfile().IncStat(ES_DestroyedNests);
		}
		
		
		
		commonMapManager.SetEntityMapPinDisabled( parent.entityName, true );
		parent.AddExp();
		
		if ( !parent.airDmg )
		{
			parent.PlayEffect( 'fire' );
		}
		else
		{
			parent.PlayEffect( 'dust' );
		}
		
		if( parent.nestBurnedAfter != 0 )
		{
						
			Sleep( parent.nestBurnedAfter );
		}
		
		
		if(!parent.IsSetDestructionFactImmediately())
			FactsAdd( parent.factSetAfterSuccessfulDestruction, 1 );
		
		if ( parent.IsBossProtectingNest() )
		{
			parent.GotoState( 'NestDestroyedBoss' );
		}
		else
		{
			parent.GotoState( 'NestDestroyed' );
		}
	}
		
	private function ProcessExplosion()
	{
		ProcessExplosionEffects();
		
		if( parent.shouldDealDamageOnExplosion )
			ProcessExplosionDamage();
	}
	
	private function ProcessExplosionEffects()
	{
		if( parent.shouldPlayFXOnExplosion && !parent.airDmg )
		{
			parent.PlayEffect( 'explosion' );
		}
		GCameraShake( 0.5, true, parent.GetWorldPosition(), 1.0f );
		
		parent.StopEffect('deploy');
	}
	
	private function ProcessExplosionDamage()
	{
		var damage : W3DamageAction;
		var entitiesInRange : array<CGameplayEntity>;
		var explosionRadius : float = 3.0;
		var damageVal : float = 50.0;
		var i : int;
		
		FindGameplayEntitiesInSphere( entitiesInRange, parent.GetWorldPosition(), explosionRadius, 100 );	
		entitiesInRange.Remove( parent );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			if( entitiesInRange[ i ] == thePlayer && thePlayer.CanUseSkill( S_Perk_16 ) )
			{
				continue;
			}
			
			if( (CActor)entitiesInRange[i] )
			{
				damage = new W3DamageAction in parent;
				
				damage.Initialize( parent, entitiesInRange[i], NULL, parent, EHRT_None, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageVal );
				damage.AddEffectInfo( EET_Burning );
				damage.AddEffectInfo( EET_Stagger );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
			else
			{
				entitiesInRange[i].OnFireHit( parent );
			}
		}
	}
}

state CACSMonsterNestNestRebuilding in CACSMonsterNestEntity
{
	event OnEnterState( prevStateName : name )
	{	
		super.OnEnterState( prevStateName );
		parent.RebuildNest ();
	}
}

state CACSMonsterNestNestRebuild in CACSMonsterNestEntity
{
	event OnEnterState( prevStateName : name )
	{	
		
		super.OnEnterState( prevStateName );
		Rebuild ();		
	}
	entry function Rebuild ()
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		Sleep ( 3.0 );
		parent.encounter.EnableEncounter( true );
		parent.encounter.SetSpawnPhase( parent.nestUpdateDefintion.defaultPhaseToActivate );
		
		parent.wasExploded = false;
		if( parent.interactionComponent )
		{
			parent.interactionComponent.SetEnabled( true );
		}
		
		if ( !parent.expWasAdded )
		{
			commonMapManager.SetEntityMapPinDisabled( parent.entityName, false );
		}
		if ( parent.container )
		{
			parent.container.Destroy();
		}
		
		parent.GotoState( 'CACSMonsterNestIntact' );
	}
}

state CACSMonsterNestNestDestroyedBoss in CACSMonsterNestEntity
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h, j 															: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;	
	var ent_1, ent_4, ent_5, ent_6, ent_7    							: CEntity;

	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		parent.StopAllEffects();		

		Necrofiend_Spawn_Entry();
		
		if ( parent.nestUpdateDefintion.isRebuilding )
		{
			parent.GotoState( 'NestRebuilding' );
		}
	}

	entry function Necrofiend_Spawn_Entry()
	{	
		if (parent.monsterNestType == EN_Rotfiend)
		{
			Necrofiend_Spawn_Latent();
		}

		if (parent.monsterNestType == EN_Harpy)
		{
			Harpy_Queen_Spawn_Latent();
		}

	}

	latent function Necrofiend_Spawn_Latent()
	{
		ACSGetCActor('ACS_Necrofiend_Tentacle_1').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_2').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_3').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_4').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_5').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_6').Destroy();

		ACSGetCEntity('acs_necrofiend_tentacle_anchor').Destroy();

		ACSGetCActor('ACS_Necrofiend').Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\gravier_zombie.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.75;
		j = 1.75;
		animcomp.SetScale(Vector(j,j,h,1));
		meshcomp.SetScale(Vector(j,j,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.75);

		ACS_GlyphAndRune_Add(((CActor)ent), 3);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		//((CActor)ent).RemoveAbility('Venom');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('smoke');

		ent.PlayEffect('spike');

		ent.PlayEffect('spikes_explode_after');

		ent.AddTag( 'ACS_Necrofiend' );

		ent.AddTag( 'ACS_Custom_Monster' );

		//((CActor)ent).EnableCharacterCollisions(false);
		((CActor)ent).SetInteractionPriority( IP_Prio_10 );
	}

	latent function Harpy_Queen_Spawn_Latent()
	{
		ACSGetCActor('ACS_Harpy_Queen').Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\harpy_queen.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\harpy_praetorian.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerPos.Z += 2;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.85);

		ACS_GlyphAndRune_Add(((CActor)ent), 3);

		//((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Ragdoll , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('mon_harpy_base');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Harpy_Queen' );

		ent.AddTag( 'ACS_Custom_Monster' );
		
		count = 5;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent_2 = theGame.CreateEntity( temp_2, spawnPos, playerRot );

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).SetCanPlayHitAnim(false);

			((CActor)ent_2).AddTag( 'ContractTarget' );

			((CActor)ent_2).AddTag('IsBoss');

			((CActor)ent_2).AddAbility('Boss');

			((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

			ent_2.AddTag('NoBestiaryEntry');

			ent_2.AddTag( 'ACS_Harpy_Praetorian' );

			ent_2.AddTag( 'ACS_Custom_Monster' );
		}
	}

}

state CACSMonsterNestNestDestroyed in CACSMonsterNestEntity
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h, j 															: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;	
	var ent_1, ent_4, ent_5, ent_6, ent_7    							: CEntity;

	event OnEnterState( prevStateName : name )
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		super.OnEnterState( prevStateName );
		parent.StopAllEffects();

		Necrofiend_Spawn_Entry_1();
		
		parent.encounter.EnableEncounter( false );
		
		if ( parent.nestUpdateDefintion.isRebuilding )
		{
			parent.GotoState( 'NestRebuilding' );
		}
	}

	entry function Necrofiend_Spawn_Entry_1()
	{	
		if (parent.monsterNestType == EN_Rotfiend)
		{
			Necrofiend_Spawn_Latent_1();
		}

		if (parent.monsterNestType == EN_Harpy)
		{
			Harpy_Queen_Spawn_Latent_1();
		}
	}
	
	latent function Necrofiend_Spawn_Latent_1()
	{
		ACSGetCActor('ACS_Necrofiend_Tentacle_1').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_2').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_3').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_4').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_5').Destroy();

		ACSGetCActor('ACS_Necrofiend_Tentacle_6').Destroy();

		ACSGetCEntity('acs_necrofiend_tentacle_anchor').Destroy();

		ACSGetCActor('ACS_Necrofiend').Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\gravier_zombie.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.75;
		j = 1.75;
		animcomp.SetScale(Vector(j,j,h,1));
		meshcomp.SetScale(Vector(j,j,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.75);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		//((CActor)ent).RemoveAbility('Venom');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('smoke');

		ent.PlayEffect('spike');

		ent.PlayEffect('spikes_explode_after');

		ent.AddTag( 'ACS_Necrofiend' );

		ent.AddTag( 'ACS_Custom_Monster' );

		//((CActor)ent).EnableCharacterCollisions(false);
		((CActor)ent).SetInteractionPriority( IP_Prio_10 );
	}

	latent function Harpy_Queen_Spawn_Latent_1()
	{
		ACSGetCActor('ACS_Harpy_Queen').Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\harpy_queen.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\harpy_praetorian.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerPos.Z += 2;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, playerPos, playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.85);

		//((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Ragdoll , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('mon_harpy_base');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Harpy_Queen' );

		ent.AddTag( 'ACS_Custom_Monster' );
		
		count = 5;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent_2 = theGame.CreateEntity( temp_2, spawnPos, playerRot );

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).SetCanPlayHitAnim(false);

			((CActor)ent_2).AddTag( 'ContractTarget' );

			((CActor)ent_2).AddTag('IsBoss');

			((CActor)ent_2).AddAbility('Boss');

			((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

			ent_2.AddTag('NoBestiaryEntry');

			ent_2.AddTag( 'ACS_Harpy_Praetorian' );

			ent_2.AddTag( 'ACS_Custom_Monster' );
		}
	}
}

function ACSCheckNestDestructionAchievement(optional debugLog : bool)
{
	var entityMapPins : array< SEntityMapPinInfo >;
	var i : int;
	var totalNests : int;
	var doneNests : int;
	var depotPath : string;
	var missesSomeNest : bool;
	
	
	depotPath = theGame.GetWorld().GetDepotPath();
	
	
	
	if(StrFindFirst(depotPath, "novigrad") < 0)
	{
		if(StrFindFirst(depotPath, "skellige") < 0)
		{
			return;
		}
	}	
		
	
	
	entityMapPins = theGame.GetCommonMapManager().GetEntityMapPins(depotPath);
	
	
	
	if(debugLog)
	{
		LogAchievements("");
		LogAchievements("Printing test results for " + EA_PestControl + " achievement");
		LogAchievements("");
	}
	
	totalNests = 0;
	doneNests = 0;
	missesSomeNest = false;
	for(i=0; i<entityMapPins.Size(); i+=1)
	{
		
		if(entityMapPins[i].entityType == 'MonsterNest')
		{
			totalNests+=1;
			
			
			if(FactsQuerySum(entityMapPins[i].entityName + "_nest_destr") < 1)
			{
				missesSomeNest = true;
				
				if(debugLog)
				{
					LogAchievements(EA_PestControl + ": not destroyed nest at: X=" + entityMapPins[i].entityPosition.X + ", Y= " + entityMapPins[i].entityPosition.Y + ", Z= " + entityMapPins[i].entityPosition.Z);
				}
			}
			else
			{
				doneNests+=1;
			}
		}
	}
		
	if(missesSomeNest)
	{
		theGame.GetGamerProfile().NoticeAchievementProgress(EA_PestControl, doneNests, totalNests);
	}
	else
	{
		theGame.GetGamerProfile().AddAchievement(EA_PestControl);
		
		if(debugLog)
		{
			LogAchievements("All nests in region are destroyed");
		}
	}
	
	if(debugLog)
	{
		LogAchievements("");
	}
}


function ACSProcessVelen(out entityMapPins : array<SEntityMapPinInfo>)
{
	var i : int;
	var velen, isPinVelen : bool;
	var playerPos : Vector;
	
	
	
	playerPos = thePlayer.GetWorldPosition();
	velen = (playerPos.Y < 1350 );
	
	for(i=entityMapPins.Size()-1; i>=0; i-=1)
	{
		
		if(entityMapPins[i].entityType != 'MonsterNest')
		{
			entityMapPins.EraseFast(i);
			continue;
		}				
		
		isPinVelen = (entityMapPins[i].entityPosition.Y < 1350);
		
		if(velen != isPinVelen)
			entityMapPins.EraseFast(i);
	}
}