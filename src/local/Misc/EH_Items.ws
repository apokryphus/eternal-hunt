class W3ACSWolvenFangItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );

				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_wolven_curse_activated") <= 0
			)
			{
				ACS_TransformationWerewolf_Tutorial();

				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableWerewolfStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_wolven_curse_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Werewolf();

				//GetACSWatcher().TransformationCustomCamera();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 		'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,					'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_wolven_curse_activated") > 0
			)
			{
				GetACSWatcher().DisableWerewolf_Actual();
			}
		}		
	}
}

class W3ACSVampireRingItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );
				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_vampire_monster_transformation_activated") <= 0
			)
			{
				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableTransformationVampireMonsterStart');

				GetWitcherPlayer().StopAllEffects();

				//GetACSWatcher().Activate_Painting_Env();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_vampire_monster_transformation_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Vampire_Monster();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 	'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,			'ACS_Transformation');
				//GetWitcherPlayer().BlockAction(EIAB_Jump,				'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,	'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');

				ACS_Vampire_Ring_Tutorial();
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
			)
			{
				GetACSWatcher().DisableTransformationVampireMonster_Actual();
			}
		}		
	}
}

class W3ACSVampireNecklaceItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			/*
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}
			*/

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );
				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_vampireess_transformation_activated") <= 0
			)
			{
				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableVampiressStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_vampireess_transformation_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Vampiress();

				//GetACSWatcher().TransformationCustomCamera();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 		'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,					'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');

				ACS_Vampire_Necklace_Tutorial();
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_vampireess_transformation_activated") > 0
			)
			{
				GetACSWatcher().DisableVampiress_Actual();
			}
		}		
	}
}

class W3ACSBruxaFangItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			/*
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}
			*/

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );
				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_vampireess_transformation_activated") <= 0
			)
			{
				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableVampiressStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_vampireess_transformation_activated", 1, -1);
				
				//GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				//GetWitcherPlayer().StopEffect('smoke_explosion');

				//GetWitcherPlayer().PlayEffectSingle('teleport');
				//GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Bruxa();

				//GetACSWatcher().TransformationCustomCamera();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 		'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,					'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');

				ACS_Bruxa_Fang_Tutorial();
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_vampireess_transformation_activated") > 0
			)
			{
				GetACSWatcher().DisableVampiress_Actual();
			}
		}		
	}
}

class W3ACSToadSlimeItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			/*
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}
			*/

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );
				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_toad_transformation_activated") <= 0
			)
			{
				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableToadStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_toad_transformation_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Toad();

				//GetACSWatcher().TransformationCustomCamera();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 		'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,					'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');

				ACS_Toad_Prince_Venom_Tutorial();
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_toad_transformation_activated") > 0
			)
			{
				GetACSWatcher().DisableTransformationToad_Actual();
			}
		}		
	}
}

class W3ACSRedMiasmalFragmentItem extends W3QuestUsableItem
{
	private var playerAnimcomp : CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		playerAnimcomp = (CAnimatedComponent)GetWitcherPlayer().GetComponentByClassName('CAnimatedComponent');
		
		if ( usedBy == GetWitcherPlayer() )
		{
			if ( GetWitcherPlayer().IsInInterior() )
			{
				GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt( "menu_cannot_perform_action_here" ));
				return false;
			}

			if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
			{
				GetWitcherPlayer().DisplayHudMessage( "Weapon must be sheathed." );

				thePlayer.OnMeleeForceHolster( true );
				thePlayer.OnRangedForceHolster( true );

				return false;
			}

			if (!GetACSWatcher())
			{
				return false;
			}
			
			if (
			FactsQuerySum("acs_transformation_activated") <= 0
			&& FactsQuerySum("acs_red_miasmal_curse_activated") <= 0
			)
			{
				ACS_Red_Miasmal_Fragment_Tutorial();

				GetACSWatcher().ACS_Transformation_Create_Savelock();

				GetACSWatcher().RemoveTimer('DisableRedMiasmalStart');

				GetWitcherPlayer().StopAllEffects();

				FactsAdd("acs_transformation_activated", 1, -1);

				FactsAdd("acs_red_miasmal_curse_activated", 1, -1);
				
				GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
				GetWitcherPlayer().StopEffect('smoke_explosion');

				GetWitcherPlayer().PlayEffectSingle('teleport');
				GetWitcherPlayer().StopEffect('teleport');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative', true); 
				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical', true); 

				GetACSWatcher().Spawn_Transformation_Red_Miasmal();

				//GetACSWatcher().TransformationCustomCamera();

				GetACSWatcher().AddTimer('Transformation_Werewolf_Fear', 0.5, true);

				playerAnimcomp.FreezePose();

				GetWitcherPlayer().BlockAction(EIAB_CallHorse,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_DrawWeapon, 			'ACS_Transformation'); 
				GetWitcherPlayer().BlockAction(EIAB_FastTravel, 			'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_InteractionAction, 		'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Crossbow,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_UsableItem,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_ThrowBomb,				'ACS_Transformation');
				GetWitcherPlayer().BlockAction(EIAB_Jump,					'ACS_Transformation');

				GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Transformation');
				GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Transformation');
			}
			else if (
			FactsQuerySum("acs_transformation_activated") > 0
			&& FactsQuerySum("acs_red_miasmal_curse_activated") > 0
			)
			{
				GetACSWatcher().DisableRedMiasmal_Actual();
			}
		}		
	}
}

class W3ACSWisp extends W3QuestUsableItem 
{
    private var wispCurrentRotationCircleAngle 								: float; 
    private var wispCurrentRotation 												: EulerAngles; 
    private var wispCurrentPosition 													: Vector;
    private var wispCurrentVelocity 													: Vector;
    private var wispCurrentAcceleration 											: Vector;
	
	private var wispGoalPosition 														: Vector;
    private var wispGoalPositionOffset 												: Vector;
    private var wispGoalPositionOffset_regenerateInSeconds 				: float;
   
    private var entity                          											:  CEntity;
    private var entityTemplate                  										:  CEntityTemplate;
    private var resourcePath                   											:  string;
    
    private var active 																		: bool;
   
	var wispPos 																		: Vector;

    event OnUsed(usedBy : CEntity) 
	{
		super.OnUsed(usedBy);

		resourcePath = "dlc\dlc_acs\data\entities\items\acs_wisp.w2ent";
 
        entityTemplate = (CEntityTemplate)LoadResource(resourcePath,true);

		if(usedBy == GetWitcherPlayer()) 
		{
			if (FactsQuerySum("ACS_Wisp_Released") <= 0)
			{
				ACSWispDestroySingle();

				ACSDestroyWispEnts();

				entity = (W3ACSWisp)theGame.CreateEntity(entityTemplate, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

				((CActor)entity).EnableCollisions(false);
				((CActor)entity).EnableCharacterCollisions(false);

				entity.AddTag('ACS_Wisp');

				entity.PlayEffectSingle('wisp_fx');

				FactsAdd("ACS_Wisp_Released", 1, -1);
			}
			else if (FactsQuerySum("ACS_Wisp_Released") > 0)
			{
				this.RemoveTimer('FollowPlayer');

				this.RemoveTimer('GatlingGunTimer');

				this.StopAllEffects();

				ACSWispDestroySingle();

				ACSDestroyWispEnts();

				FactsRemove("ACS_Wisp_Released");
			}
		}
    }
	
	event OnDestroyed() 
	{	
			
	}

	event OnSpawned(spawnData : SEntitySpawnData) 
	{
		var bonePos : Vector;

		wispPos = this.GetWorldPosition();
		
		//get position of left hand (boneindex for l_hand is 24)
		bonePos = MatrixGetTranslation(thePlayer.GetBoneWorldMatrixByIndex(24));

		this.AddTimer('FollowPlayer', 0.0001, true);

		this.AddTimer('GatlingGunTimer', 0.00000001, true);

		wispCurrentPosition = bonePos + Vector(0,0,0.1);

        wispCurrentVelocity = Vector(3,0,0);

		wispCurrentAcceleration = Vector(0,0,0);
	}

	timer function GatlingGunTimer(deltaTime : float, id : int) 
	{
		ACS_Wisp_Gatling_Gun();
	}	

    timer function FollowPlayer(deltaTime : float, id : int) 
	{
		var target : CEntity;
		var targetPosition : Vector;
		var targetRotation : EulerAngles;
		
                       
        var playerPosition : Vector;
        var playerRotation : EulerAngles;      
        
        var goalAcceleration : Vector;
        var navigationComputeZReturn : float;  
 
        // DEFAULT CONFIG start //
 
        var rotationCircleRadius : float;
        var rotationCircleMovementSpeed : float;
        var selfRotationSpeed : float;
        var maxAcceleration : float;      
        var accelerationMultiplier : float;
        var maxVelocity : float;
        var velocityDampeningFactor : float;

		var lookatents										: array<CGameplayEntity>;
		var i, j											: int;

		var gameLightComp, gameInteractComp 				: CComponent;

		var pos, lookatentsPos								 : Vector;
 
        rotationCircleMovementSpeed = 50;
        rotationCircleRadius = 1;
        selfRotationSpeed = 2.2;
        maxAcceleration = 200;
        accelerationMultiplier = 50;
        maxVelocity = 100;
        velocityDampeningFactor = 0.9;
 
        // DEFAULT CONFIG end //
		
		
		// Player is in Interior (buildings, caves etc.)
		// INTERIOR CONFIG start //
		if(thePlayer.IsInInterior()) 
		{
			rotationCircleMovementSpeed = 50;
			rotationCircleRadius = 0.5;
			selfRotationSpeed = 0.6;
			maxAcceleration = 100;
			accelerationMultiplier = 20;
			maxVelocity = 20;
			velocityDampeningFactor = 0.9;
		
		}
		// INTERIOR CONFIG end //
       
        // increase current angle in the circle around player
        wispCurrentRotationCircleAngle += deltaTime * rotationCircleMovementSpeed;
 
        // if rotation increased over 360 degrees make sure its under 360
        while(wispCurrentRotationCircleAngle > 360) 
		{          
            wispCurrentRotationCircleAngle -= 360;                        
        }

		pos = thePlayer.GetWorldPosition();
		pos.Z += 0.8;
       
	   // get current target
	   if (thePlayer.IsInCombat())
	   {
		 target = thePlayer.GetTarget();
	   }
	   else 
	   {
			lookatents.Clear();

			//FindGameplayEntitiesInRange(lookatents, thePlayer, 25, 1, ,FLAG_ExcludePlayer, ,);

			FindGameplayEntitiesInCone( lookatents, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection(), VecHeading( theCamera.GetCameraDirection() ), 120, 120, 1, , FLAG_ExcludePlayer );

			for(i = 0; i < lookatents.Size(); i += 1)
			{
				if 
				( 
				lookatents[i] == GetWitcherPlayer() 
				|| lookatents[i] == GetACSWatcher()
				|| lookatents[i] == theCamera
				)
				{
					continue;
				}

				for( j = lookatents.Size()-1; j >= 0; j -= 1 ) 
				{	
					lookatentsPos = lookatents[j].GetWorldPosition();
					
					if ( AbsF( lookatentsPos.Z - pos.Z ) > 2.5 )
					{
						lookatents.EraseFast(j);
					}

					if (lookatents.Size() > 0)
					{
						if ( lookatents[j] = thePlayer.GetDisplayTarget())
						{
							target = thePlayer.GetDisplayTarget();
						}
						else
						{
							gameLightComp = lookatents[j].GetComponentByClassName('CGameplayLightComponent');

							gameInteractComp = lookatents[j].GetComponentByClassName('CInteractionComponent');

							if(
							(CNewNPC)lookatents[j]
							|| (COilBarrelEntity)lookatents[j]
							|| gameLightComp
							|| gameInteractComp
							|| (W3AnimationInteractionEntity)lookatents[j]
							|| (CInteractiveEntity)lookatents[j]
							|| (W3NoticeBoard)lookatents[j]
							|| (W3FastTravelEntity)lookatents[j]
							|| (W3SmartObject)lookatents[j]
							|| (W3ItemRepairObject)lookatents[j]
							|| (W3AlchemyTable)lookatents[j]
							|| (W3Stables)lookatents[j]
							|| (W3LockableEntity)lookatents[j] 
							|| (W3Poster)lookatents[j]
							|| (W3LadderInteraction)lookatents[j]
							)
							{
								target = lookatents[j];
							}
						}
					}
				}	
			}
	   }

	   //get current player position
		if (thePlayer.IsInInterior())
		{
			playerPosition = thePlayer.GetWorldPosition();
			targetPosition = target.GetWorldPosition();
		}
		else
		{
			playerPosition = TraceFloor(thePlayer.GetWorldPosition());
			targetPosition = TraceFloor(target.GetWorldPosition());
		}
		
		//get current player rotation
		playerRotation = thePlayer.GetWorldRotation();

		targetRotation = target.GetWorldRotation();
       
        // calculate wisp Goal position
		

		// if player has target and is in focusmode (right mouse button), change some of the wisps config values to adjust movement around target	
		if(target 
		&& (theGame.IsFocusModeActive() 

		|| (thePlayer.IsInCombat() 
		|| thePlayer.IsThreatened()) 
		&& thePlayer.IsHardLockEnabled())
		
		) 
		{	
			rotationCircleMovementSpeed -= 25;	
			rotationCircleRadius -= 0.25;

			wispGoalPosition = targetPosition;

			if (!this.IsEffectActive('wisp_fx_combat', false))
			{
				this.PlayEffectSingle('wisp_fx_combat');
			}

			if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
			{
				if (FactsQuerySum("ACS_Wisp_Attack_Enable") > 0)
				{
					if ( thePlayer.GetEquippedSign() == ST_Igni )
					{	
						if (thePlayer.GetLevel() < 10)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_red', false))
							{
								this.PlayEffectSingle('wisp_fx_red');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Axii )
					{
						if (thePlayer.GetLevel() < 20)
						{

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_green', false))
							{
								this.PlayEffectSingle('wisp_fx_green');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Aard )
					{
						if (thePlayer.GetLevel() < 5)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_blue', false))
							{
								this.PlayEffectSingle('wisp_fx_blue');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Quen )
					{	
						if (thePlayer.GetLevel() < 25)
						{
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_gold', false))
							{
								this.PlayEffectSingle('wisp_fx_gold');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Yrden )
					{
						if (thePlayer.GetLevel() < 15)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx_purple', false))
							{
								this.PlayEffectSingle('wisp_fx_purple');
							}
						}
					}
				}
				else
				{
					this.StopEffect('wisp_fx_gold');
					this.StopEffect('wisp_fx_blue');
					this.StopEffect('wisp_fx_green');
					this.StopEffect('wisp_fx_red');
					this.StopEffect('wisp_fx_purple');
					
					if (!this.IsEffectActive('wisp_fx', false))
					{
						this.PlayEffectSingle('wisp_fx');
					}
				}
			}
			else
			{
				this.StopEffect('wisp_fx_gold');
				this.StopEffect('wisp_fx_blue');
				this.StopEffect('wisp_fx_green');
				this.StopEffect('wisp_fx_red');
				this.StopEffect('wisp_fx_purple');
				
				if (!this.IsEffectActive('wisp_fx', false))
				{
					this.PlayEffectSingle('wisp_fx');
				}
			}
		} 
		else 
		{
			this.StopEffect('wisp_fx_combat');

			if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
			{
				if (FactsQuerySum("ACS_Wisp_Attack_Enable") > 0)
				{
					if ( thePlayer.GetEquippedSign() == ST_Igni )
					{	
						if (thePlayer.GetLevel() < 10)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_red', false))
							{
								this.PlayEffectSingle('wisp_fx_red');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Axii )
					{
						if (thePlayer.GetLevel() < 20)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_green', false))
							{
								this.PlayEffectSingle('wisp_fx_green');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Aard )
					{
						if (thePlayer.GetLevel() < 5)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}

						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_combat');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_blue', false))
							{
								this.PlayEffectSingle('wisp_fx_blue');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Quen )
					{	
						if (thePlayer.GetLevel() < 25)
						{
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}

						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_gold', false))
							{
								this.PlayEffectSingle('wisp_fx_gold');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Yrden )
					{
						if (thePlayer.GetLevel() < 15)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx_purple', false))
							{
								this.PlayEffectSingle('wisp_fx_purple');
							}
						}
					}
				}
				else
				{
					this.StopEffect('wisp_fx_gold');
					this.StopEffect('wisp_fx_blue');
					this.StopEffect('wisp_fx_green');
					this.StopEffect('wisp_fx_red');
					this.StopEffect('wisp_fx_purple');
					
					if (!this.IsEffectActive('wisp_fx', false))
					{
						this.PlayEffectSingle('wisp_fx');
					}
				}
			}
			else
			{
				this.StopEffect('wisp_fx_gold');
				this.StopEffect('wisp_fx_blue');
				this.StopEffect('wisp_fx_green');
				this.StopEffect('wisp_fx_red');
				this.StopEffect('wisp_fx_purple');

				if (
				theGame.IsDialogOrCutscenePlaying() 
				|| thePlayer.IsInNonGameplayCutscene() 
				|| thePlayer.IsInGameplayScene()
				|| theGame.IsCurrentlyPlayingNonGameplayScene()
				|| theGame.IsFading()
				|| theGame.IsBlackscreen()
				)
				{
					this.StopEffect('wisp_fx');

					if (!this.IsEffectActive('wisp_fx_cutscene', false))
					{
						this.PlayEffectSingle('wisp_fx_cutscene');
					}
				}
				else
				{
					this.StopEffect('wisp_fx_cutscene');

					if (!this.IsEffectActive('wisp_fx', false))
					{
						this.PlayEffectSingle('wisp_fx');
					}
				}
			}

			//if no target and no focusmode, stick to player and use default config values	
			wispGoalPosition = playerPosition;
		
		}
		
	    wispGoalPosition += wispGoalPositionOffset;
        wispGoalPosition.X += CosF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;
        wispGoalPosition.Y += SinF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;

		if ((thePlayer.IsInCombat() 
		|| thePlayer.IsThreatened()) 
		&& thePlayer.IsHardLockEnabled())
		{
       		wispGoalPosition.Z += 3;
		}
		else
		{
			wispGoalPosition.Z += 2.5;
		}
       
        // see if we can set new random wisp position offset
        wispGoalPositionOffset_regenerateInSeconds -= deltaTime;
        if(wispGoalPositionOffset_regenerateInSeconds < 0) {
            wispGoalPositionOffset_regenerateInSeconds = RandRangeF(1, 0.1);
            wispGoalPositionOffset = VecRand() * rotationCircleRadius * 0.25;
        }
 
        // accelerate towards goal position
        wispCurrentAcceleration = (wispGoalPosition - wispCurrentPosition) * accelerationMultiplier;
 
        // clamp wisp acceleration, so its not too fast
        if(VecLength(wispCurrentAcceleration) > maxAcceleration) {
            wispCurrentAcceleration = VecNormalize(wispCurrentAcceleration) * maxAcceleration;
        }
 
        // simulate acceleration and velocity for more natural movement
        wispCurrentVelocity += wispCurrentAcceleration * deltaTime;
 
        // dampen velocity
        wispCurrentVelocity *= velocityDampeningFactor;
 
        // clamp wisp velocity, so its not too fast
        if(VecLength(wispCurrentVelocity) > maxVelocity) {
            wispCurrentVelocity = VecNormalize(wispCurrentVelocity) * maxVelocity;
        }
 
        // get the height
        if (theGame.GetWorld().NavigationComputeZ( wispCurrentPosition, wispCurrentPosition.Z - 2, wispCurrentPosition.Z + 2, navigationComputeZReturn ) )
        {
            // if wisp is too close to collision, bounce off it and loose some velocity
            if(AbsF(wispCurrentPosition.Z - navigationComputeZReturn) < 0.1) 
			{
                wispCurrentVelocity.Z *= -0.9;
            }
        }
 
        // simulate acceleration and velocity for more natural movement
        wispCurrentPosition += wispCurrentVelocity * deltaTime;
 
        // if wisp is too far away, just teleport it back to player
        if(VecDistance(wispCurrentPosition, wispGoalPosition) > 100) {
            wispCurrentPosition = wispGoalPosition;
            wispCurrentVelocity = Vector(0,0,0);
            wispCurrentAcceleration = Vector(0,0,0);
        }
 
        // rotate wisp it self over time
        wispCurrentRotation.Pitch += deltaTime * selfRotationSpeed;
		wispCurrentRotation.Roll += deltaTime * selfRotationSpeed;
		wispCurrentRotation.Yaw += deltaTime * selfRotationSpeed;
 
        // finall set the wisp position and rotation				
		this.TeleportWithRotation(wispCurrentPosition, wispCurrentRotation); 
    }   
}

function ACS_WispCheck()
{
	var entity                          										:  CEntity;
	var entityTemplate                  										:  CEntityTemplate;
	var resourcePath                   											:  string;

	if (FactsQuerySum("ACS_Wisp_Released") > 0 && thePlayer.inv.HasItem('acs_wisp'))
	{
		ACSWispDestroySingle();

		ACSDestroyWispEnts();

		if (thePlayer.inv.HasItem('acs_wisp'))
		{
			resourcePath = "dlc\dlc_acs\data\entities\items\acs_wisp.w2ent";

			entityTemplate = (CEntityTemplate)LoadResource(resourcePath,true);

			entity = (W3ACSWisp)theGame.CreateEntity(entityTemplate, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

			((CActor)entity).EnableCollisions(false);
			((CActor)entity).EnableCharacterCollisions(false);

			entity.AddTag('ACS_Wisp');

			entity.PlayEffectSingle('wisp_fx');
		}
		else
		{
			FactsRemove("ACS_Wisp_Released");
		}
	}
}

function ACSWispDestroySingle()
{
	var entity 			 : W3ACSWisp;
	
	entity = (W3ACSWisp)theGame.GetEntityByTag( 'ACS_Wisp' );
	entity.Destroy();
}

function ACSDestroyWispEnts()
{	
	var ents 											: array<CEntity>;
	var i												: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Wisp', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACSDestroyWispEntsDelay()
{	
	var ents 											: array<CEntity>;
	var i												: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Wisp', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].DestroyAfter(1);
	}
}

class W3ACSWolfHeartItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			ACS_Wolf_Heart_Tutorial();
			
			if (
			FactsQuerySum("acs_wolf_companion_summoned") <= 0
			)
			{
				GetACSWatcher().ManageFollower();

				FactsAdd("acs_wolf_companion_summoned", 1, -1);
			}
			else  if (
			FactsQuerySum("acs_wolf_companion_summoned") > 0
			)
			{
				if (
				FactsQuerySum("acs_wolf_companion_command_stay") <= 0
				)
				{
					GetACSWatcher().ManageFollower();

					FactsAdd("acs_wolf_companion_command_stay", 1, -1);
				}
				else  if (
				FactsQuerySum("acs_wolf_companion_command_stay") > 0
				)
				{ 
					GetACSWatcher().DestroyFollower();

					FactsRemove("acs_wolf_companion_command_stay");

					FactsRemove("acs_wolf_companion_summoned");
				}
			}
		}		
	}
}

function ACS_WolfCompanionCheck()
{
	if (
	FactsQuerySum("acs_wolf_companion_summoned") > 0
	)
	{
		GetACSWatcher().ManageFollower();

		if (
		FactsQuerySum("acs_wolf_companion_command_stay") > 0
		)
		{ 
			FactsRemove("acs_wolf_companion_command_stay");
		}
	}
}

class W3ACSKillCountBookItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);

		ACS_Create_Book();
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			GetACSWatcher().RemoveTimer('KillCountMenuDisplayDelay');

			GetACSWatcher().AddTimer('KillCountMenuDisplayDelay', 0.5, false);
		}		
	}

	event OnHidden( hiddenBy : CEntity )
	{
		super.OnHidden(hiddenBy);

		if ( hiddenBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			GetACSWatcher().RemoveTimer('KillCountMenuDisplayDelay');

			GetACSBook().BreakAttachment();

			GetACSBook().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );

			GetACSBook().DestroyAfter(0.00125);
		}
	}
}

function ACS_Create_Book()
{
	var item 															: SItemUniqueId;
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var attach_vec														: Vector;
	var attach_rot														: EulerAngles;
	var timeToDestroy, h												: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;

	GetACSBook().Destroy();

	temp = (CEntityTemplate)LoadResource(

	//"items\readable_books\readable_books_source\elven_sages_full.w2ent"

	"items\readable_books\readable_books_source\basics_of_magic_full.w2ent"

	, true );

	ent = theGame.CreateEntity( temp, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

	attach_rot.Roll = 0;
	attach_rot.Pitch = 90;
	attach_rot.Yaw = -45;
	attach_vec.X = 0.05;
	attach_vec.Y = -0.075;
	attach_vec.Z = 0;

	ent.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );

	ent.AddTag('ACS_Book');
}

function GetACSBook() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Book' );
	return entity;
}

class W3ACSSchoolMedallionItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			if (ACS_Wolf_School_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Wolf_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Wolf_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Wolf_Style_Activate") > 0)
				{
					FactsRemove("ACS_Wolf_Style_Activate");
				} 
			}
			else if (ACS_Bear_School_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Bear_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Bear_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Bear_Style_Activate") > 0)
				{
					FactsRemove("ACS_Bear_Style_Activate");
				} 
			}
			else if (ACS_Cat_School_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Cat_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Cat_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Cat_Style_Activate") > 0)
				{
					FactsRemove("ACS_Cat_Style_Activate");
				} 
			}
			else if (ACS_Griffin_School_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Griffin_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Griffin_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Griffin_Style_Activate") > 0)
				{
					FactsRemove("ACS_Griffin_Style_Activate");
				} 
			}
			else if (ACS_Manticore_School_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Manticore_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Manticore_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Manticore_Style_Activate") > 0)
				{
					FactsRemove("ACS_Manticore_Style_Activate");
				}
			}
			else if (ACS_Forgotten_Wolf_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Forgotten_Wolf_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Forgotten_Wolf_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Forgotten_Wolf_Style_Activate") > 0)
				{
					FactsRemove("ACS_Forgotten_Wolf_Style_Activate");
				}
			}
			else if (ACS_Viper_School_Check_For_Item())
			{
				if ( FactsQuerySum("ACS_Viper_Style_Activate") <= 0 )
				{
					FactsAdd("ACS_Viper_Style_Activate", 1, -1);
				}
				else if (FactsQuerySum("ACS_Viper_Style_Activate") > 0)
				{
					FactsRemove("ACS_Viper_Style_Activate");
				}
			}
		}		
	}
}

class W3ACSPirateAmuletItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			ACS_Pirate_Amulet_Tutorial();
			
			if (RandF() < 0.5)
			{
				if (GetWeatherConditionName() != 'WT_Clear')
				{
					RequestWeatherChangeTo('WT_Clear', 1.0, false);
				}
			}
			else
			{
				if (!GetACSMelusine()
				|| !GetACSMelusine().IsAlive())
				{
					if (GetWeatherConditionName() != 'WT_Rain_Storm')
					{
						RequestWeatherChangeTo('WT_Rain_Storm', 5.0, false);
					}

					ACS_Lightning_Strike_No_Condition();

					GetACSWatcher().RemoveTimer('MelusineSpawnDelay');
					GetACSWatcher().AddTimer('MelusineSpawnDelay', RandRangeF(10,5), false);
				}
				else
				{
					if (GetWeatherConditionName() != 'WT_Rain_Storm')
					{
						RequestWeatherChangeTo('WT_Rain_Storm', 1.0, false);
					}
				}
			}
		}		
	}
}