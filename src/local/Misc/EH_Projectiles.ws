class W3ACSSwordProjectile extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos		: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= 15;
		rot.Yaw += 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) 
		|| hitCollisionsGroups.Contains( 'Water' )
		) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class W3ACSKnifeProjectile extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos, pos	: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;
	private var damage									: float;
	private var action									: W3DamageAction;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= RandRange(45, -45);
		rot.Yaw += 90;
		comp.SetRotation( rot );

		//pos = comp.GetLocalPosition();
		//pos.Y += 0.25;
		//comp.SetPosition( pos );

		AddTimer('playredtrail', 0.0001, true);
	}

	timer function playredtrail( dt : float , optional id : int)
	{
		StopEffect('red_trail');
		PlayEffectSingle('red_trail');
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * -0.125f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						actor.GetInventory().AddAnItem('ACS_Knife', 1);
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * -0.125f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);

						actor.GetInventory().AddAnItem('ACS_Knife', 1);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );

						actor.GetInventory().AddAnItem('ACS_Knife', 1);
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}

						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );

				RemoveTimer('playredtrail');
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) 
		|| hitCollisionsGroups.Contains( 'Water' )
		) 
		&& !stopped )
		{
			StopProjectile();
			DestroyAfter(0.4);
			
			this.SoundEvent("cmb_arrow_impact_dirt");

			RemoveTimer('playredtrail');

			CreateKnife();
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
			RemoveTimer('playredtrail');
		}
	}

	function CreateKnife()
	{
		var knife_temp							: CEntityTemplate;
		var knife 								: CEntity;

		knife_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_knife_loot_old.w2ent", true );

		knife = (CEntity)theGame.CreateEntity( knife_temp, this.GetWorldPosition() );

		((W3AnimatedContainer)(knife)).GetInventory().AddAnItem( 'ACS_Knife' , 1 );
	}

	/*
	function CreateKnife()
	{
		var knife_temp							: CEntityTemplate;
		var knife 								: CEntity;
		var droppeditemID 						: SItemUniqueId;

		knife_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_guiding_light.w2ent", true );

		knife = (CEntity)theGame.CreateEntity( knife_temp, this.GetWorldPosition() );

		((CNewNPC)knife).EnableCharacterCollisions(false);
		((CNewNPC)knife).EnableCollisions(false);

		((CActor)knife).AddBuffImmunity_AllNegative('ACS_Knife_Entity', true);

		((CActor)knife).AddBuffImmunity_AllCritical('ACS_Knife_Entity', true);

		((CActor)knife).SetUnpushableTarget(thePlayer);

		((CActor)knife).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		((CActor)knife).SetCanPlayHitAnim(false); 

		((CNewNPC)knife).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CActor)(knife)).GetInventory().RemoveAllItems();

		((CActor)(knife)).GetInventory().AddAnItem( 'ACS_Knife' , 1 );

		droppeditemID = ((CActor)(knife)).GetInventory().GetItemId('ACS_Knife');

		((CActor)(knife)).GetInventory().DropItemInBag(droppeditemID, 1);

		knife.DestroyAfter(0.5);
	}
	*/
}

function GetACSLeviathan() : W3ACSLeviathanProjectile
{
	var entity 			 : W3ACSLeviathanProjectile;
	
	entity = (W3ACSLeviathanProjectile)theGame.GetEntityByTag( 'ACS_Leviathan_Projectile' );
	return entity;
}

function GetACSLeviathanContainer() : W3LeviathanContainer
{
	var entity 			 : W3LeviathanContainer;
	
	entity = (W3LeviathanContainer)theGame.GetEntityByTag( 'ACS_Leviathan_Container' );
	return entity;
}

function GetACSLeviathanTemporaryStorageUnit() : W3AnimatedContainer
{
	var entity 			 : W3AnimatedContainer;
	
	entity = (W3AnimatedContainer)theGame.GetEntityByTag( 'ACS_Leviathan_Temporary_Storage_Unit' );
	return entity;
}


class W3ACSLeviathanProjectile extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot, attach_rot					: EulerAngles;
	private var res, stopped 							: bool;
	private var arrowHitPos, arrowSize, bone_pos, pos, attach_vec	: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;
	private var damage									: float;
	private var action									: W3DamageAction;
	public var random_return_pitch 						: float;
	public var return_yaw 								: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		random_return_pitch = RandRangeF(67, 0);
	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();

		rot.Roll += 90;
		//rot.Pitch -= RandRange(45, -45);
		rot.Yaw += 90;

		return_yaw = rot.Yaw;

		return_yaw += 180;

		comp.SetRotation( rot );

		//pos = comp.GetLocalPosition();
		//pos.Y += 0.25;
		//comp.SetPosition( pos );

		AddTimer('trail', 0.00000000000000000000001, true);

		if (this.HasTag('ACS_Leviathan_Projectile_Guarantee_Freeze'))
		{
			DestroyEffect('glow');
			PlayEffectSingle('glow');
		}

		DealDamageProj();

		this.SoundEvent('magic_eredin_icespike_tell_loop_start');
	}

	var last_spin_time : float;

	function Can_Spin(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_spin_time > 0.25;
	}

	function Refresh_Spin_Cooldown() 
	{
		last_spin_time = theGame.GetEngineTimeAsSeconds();
	}

	timer function trail( dt : float , optional id : int)
	{
		//StopEffect('blue_trail');
		PlayEffectSingle('blue_trail');

		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		
		if (FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
		{
			rot.Roll -= 7.5;

			if (rot.Pitch != random_return_pitch)
			{
				if (random_return_pitch > 0)
				{
					rot.Pitch += 0.125;
				}
				else if (random_return_pitch < 0)
				{
					rot.Pitch -= 0.125;
				}
				else 
				{
					rot.Pitch = random_return_pitch;
				}
			}
			else 
			{
				rot.Pitch = random_return_pitch;
			}

			if (rot.Yaw != return_yaw)
			{
				rot.Yaw += 90;
			}
			else
			{
				rot.Yaw = return_yaw;
			}
		}
		else
		{
			rot.Roll += 7.5;
		}
			
		comp.SetRotation( rot );

		if (Can_Spin())
		{
			Refresh_Spin_Cooldown();

			DealDamageProj();
		}

		if (FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
		{
			PlayerDistanceCheck();
		}
		else
		{
			GetACSStorage().acs_recordLeviathanPosition(this.GetWorldPosition());

		}
	}

	var curvature_reached : bool;

	function PlayerDistanceCheck()
	{
		var targetDistance																						: float;
		var targetPosition																						: Vector;
		var ent 																								: CEntity;
		var itemIds 																							: array<SItemUniqueId>;
		var i 																									: int;

		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), GetWitcherPlayer().GetBoneWorldPosition('r_hand') );

		if (targetDistance <= 1 * 1)
		{
			this.SoundEvent("cmb_arrow_impact_dirt");
			this.SoundEvent('magic_eredin_icespike_tell_loop_stop');
			RemoveTimers();
			StopProjectile();
			PlayEffect('disappear');
			DestroyAfter(0.4);

			this.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

			if (!thePlayer.inv.HasItem('Leviathan'))
			{
				//thePlayer.inv.AddAnItem('Leviathan', 1);
			}

			itemIds = GetACSLeviathanTemporaryStorageUnit().GetInventory().GetItemsByTag( 'ACS_Designated_Leviathan' );

			if (itemIds.Size() > 0)
			{
				for( i = 0; i < itemIds.Size() ; i+=1 )
				{
					if( GetACSLeviathanTemporaryStorageUnit().GetInventory().ItemHasTag( itemIds[i], 'ACS_Designated_Leviathan' ) )
					{
						GetACSLeviathanTemporaryStorageUnit().GetInventory().RemoveItemTag( itemIds[i], 'ACS_Designated_Leviathan' );

						GetACSLeviathanTemporaryStorageUnit().GetInventory().GiveItemTo( thePlayer.GetInventory(), itemIds[i], 1, false, true, false);
					}
				}
			}

			GetACSLeviathanTemporaryStorageUnit().Destroy();

			if (FactsQuerySum("ACS_Leviathan_Axe_Thrown") > 0)
			{
				FactsRemove("ACS_Leviathan_Axe_Thrown");
			}

			if (FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
			{
				FactsRemove("ACS_Leviathan_Axe_Returning");
			}

			if (FactsQuerySum("ACS_Leviathan_Axe_Returning_Anim_Played") > 0)
			{
				FactsRemove("ACS_Leviathan_Axe_Returning_Anim_Played");
			}

			thePlayer.EquipItem( thePlayer.inv.GetItemId('Leviathan'));

			if ( thePlayer.IsActionAllowed(EIAB_DrawWeapon) && thePlayer.GetBIsInputAllowed() && thePlayer.GetWeaponHolster().IsMeleeWeaponReady() )
			{
				thePlayer.GetInventory().MountItem( thePlayer.inv.GetItemId('Leviathan'), true );  

				thePlayer.GetWeaponHolster().OnWeaponDrawReady();
			}

			GetACSWatcher().ACS_Leviathan_Release_Savelock();

			return;
		}

		//targetPosition = GetWitcherPlayer().GetWorldPosition();

		//targetPosition.Z += 1.25;

		if (targetDistance <= 5 * 5)
		{
			if (FactsQuerySum("ACS_Leviathan_Axe_Returning_Anim_Played") <= 0)
			{
				thePlayer.RaiseEvent('LootHerb');

				FactsAdd("ACS_Leviathan_Axe_Returning_Anim_Played", 1, -1);
			}

			targetPosition = GetWitcherPlayer().GetBoneWorldPosition('r_hand');
		}
		else if (targetDistance > 5 * 5 && targetDistance <= 10 * 10)
		{
			targetPosition = GetWitcherPlayer().GetBoneWorldPosition('r_hand') + GetWitcherPlayer().GetWorldRight() * 5;

			targetPosition.Z += 1;
		}
		else if (targetDistance > 10 * 10)
		{
			targetPosition = GetWitcherPlayer().GetBoneWorldPosition('r_hand');
		} 

		this.ShootProjectileAtPosition( 0, 30, targetPosition, 500 );
	}
	
	function DealDamageProj()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 1.25, 100 );

		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTarget( entities[i], effType, crit );
		}
	}

	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		var ent : CEntity;

		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			this.SoundEvent('magic_eredin_icespike_tell_sparks');
			this.SoundEvent("cmb_play_hit_heavy");
			this.SoundEvent("magic_eredin_frost_projectile");
			this.SoundEvent("cmb_play_dismemberment_gore");

			ent = theGame.CreateEntity( 
			
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
			TraceFloor(actortarget.GetWorldPosition()), thePlayer.GetWorldRotation() );

			ent.PlayEffect('ice_spikes');
			ent.PlayEffect('cone_ground_mutation_6_aard');

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( actortarget.GetWorldPosition() ), 1.f, 5, 1.f, 20.f, 0);

			action = new W3DamageAction in this;

			action.Initialize(GetWitcherPlayer(),victim,this,GetWitcherPlayer(),EHRT_Heavy,CPS_Undefined,false,true,false,false);

			action.AddEffectInfo( EET_SlowdownFrost, 5 );

			if (FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
			{
				if (this.HasTag('ACS_Leviathan_Projectile_Guarantee_Freeze'))
				{
					if (actortarget.UsesEssence())
					{
						damage = actortarget.GetStatMax( BCS_Essence ) * 0.25;
					}
					else if (actortarget.UsesVitality())
					{
						damage = actortarget.GetStatMax( BCS_Vitality ) * 0.25;
					}

					action.AddEffectInfo( EET_Frozen, 3 );

					action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, damage );
				}
				else
				{
					if (actortarget.UsesEssence())
					{
						damage = actortarget.GetStatMax( BCS_Essence ) * 0.125;
					}
					else if (actortarget.UsesVitality())
					{
						damage = actortarget.GetStatMax( BCS_Vitality ) * 0.125;
					}

					action.AddDamage(theGame.params.DAMAGE_NAME_FROST, damage );
				}

				action.SetForceExplosionDismemberment();
			}
			else
			{
				if (this.HasTag('ACS_Leviathan_Projectile_Guarantee_Freeze'))
				{
					if (actortarget.UsesEssence())
					{
						damage = actortarget.GetStatMax( BCS_Essence ) * 0.125;
					}
					else if (actortarget.UsesVitality())
					{
						damage = actortarget.GetStatMax( BCS_Vitality ) * 0.125;
					}

					action.AddEffectInfo( EET_Frozen, 3 );

					ent.PlayEffect('ice_line');

					ent.PlayEffect('cone_ground_mutation_6_aard');

					ent.PlayEffect('blast_ground_mutation_6_aard');

					action.SetForceExplosionDismemberment();

					this.SoundEvent("magic_eredin_icespike_tell_explosion");

					action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, damage );
				}
				else
				{
					if (actortarget.UsesEssence())
					{
						damage = actortarget.GetStatMax( BCS_Essence ) * 0.0625;
					}
					else if (actortarget.UsesVitality())
					{
						damage = actortarget.GetStatMax( BCS_Vitality ) * 0.0625;
					}

					action.AddDamage(theGame.params.DAMAGE_NAME_FROST, damage );
				}
			}

			ent.DestroyAfter(10);

			action.SetCanPlayHitParticle(true);

			theGame.damageMgr.ProcessAction( action );

			delete action;
		}
	}

	function FreezeAura( victim : CGameplayEntity )
	{
		var ent : CEntity;

		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			action = new W3DamageAction in this;

			action.Initialize(GetWitcherPlayer(),victim,this,GetWitcherPlayer(),EHRT_None,CPS_Undefined,false,true,false,false);

			action.AddDamage(theGame.params.DAMAGE_NAME_FROST, actortarget.GetCurrentHealth() * 0.0000001 );

			action.AddEffectInfo( EET_SlowdownFrost, 5 );

			action.SetCanPlayHitParticle(false);

			action.SetSuppressHitSounds(true);

			theGame.damageMgr.ProcessAction( action );

			delete action;
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if (FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
		{
			if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
			{
				if ( victim 
				&& !collidedEntities.Contains(victim) 
				&& victim != GetWitcherPlayer() 
				&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
				&& victim.IsAlive() )
				{
					actor = (CActor)victim;
					
					collidedEntities.PushBack(victim);
					
					DealDamageProj();

					theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 1.f, 20, 1.f, 20.f, 0);
				}
			}
			else
			if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
			|| hitCollisionsGroups.Contains( 'Static' ) 
			|| hitCollisionsGroups.Contains( 'Foliage' ) 
			|| hitCollisionsGroups.Contains( 'Water' )
			) )
			{
				DealDamageProj();

				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 1.f, 20, 1.f, 20.f, 0);
			}
		}
		else
		{
			if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
			{		
				if ( victim 
				&& !collidedEntities.Contains(victim) 
				&& victim != GetWitcherPlayer() 
				&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
				&& victim.IsAlive() )
				{
					actor = (CActor)victim;
					
					collidedEntities.PushBack(victim);
					
					if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
					{
						bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
						
						if ((StrContains(StrLower(NameToString(bone)), "head" )))
						{
							comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
							rot = comp.GetLocalRotation();
							rot.Roll = RandRangeF(90, 45);
							comp.SetRotation( rot );

							arrowHitPos = pos;
							arrowHitPos += RotForward(  this.GetWorldRotation() ) * 0.125f; 
							
							stopped = true;
							this.SoundEvent('magic_eredin_icespike_tell_loop_stop');
							StopProjectile();
							RemoveTimer('trail');
						
							res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());

							AttachIceFX();

							if ( !actor.HasBuff( EET_Knockdown ) 
							&& !actor.HasBuff( EET_HeavyKnockdown ) 
							&& !actor.GetIsRecoveringFromKnockdown() 
							&& !actor.HasBuff( EET_Ragdoll ) )
							{
								effType = EET_HeavyKnockdown;
							}
												
							crit = true;
						}
						else if ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )			
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						) 
						{
							comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
							rot = comp.GetLocalRotation();
							rot.Roll = RandRangeF(90, 45);
							comp.SetRotation( rot );

							arrowHitPos = pos;
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * -0.125f; 
							
							stopped = true;

							this.SoundEvent('magic_eredin_icespike_tell_loop_stop');
							StopProjectile();

							RemoveTimer('trail');

							res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());

							AttachIceFX();

							effType = EET_LongStagger;
							
							crit = false;
						}
						else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
						{
							actor.DropItemFromSlot( 'r_weapon', true );
						}
						else
						{
							effType = EET_LongStagger;

							crit = false;
						}
					}
					else
					{
						comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
						rot = comp.GetLocalRotation();
						rot.Roll = RandRangeF(90, 45);
						comp.SetRotation( rot );

						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * -0.125f; 
						
						stopped = true;
						this.SoundEvent('magic_eredin_icespike_tell_loop_stop');
						StopProjectile();
						RemoveTimer('trail');

						if ( actor.GetBoneIndex('head') != -1 )
						{
							res = this.CreateAttachmentAtBoneWS(actor, 'head', arrowHitPos, this.GetWorldRotation());
						}
						else
						{
							res = this.CreateAttachmentAtBoneWS(actor, 'k_head_g', arrowHitPos, this.GetWorldRotation());
						}

						AttachIceFX();
					}

					DealDamageToTarget( victim, effType, crit );
				}
			}
			else
			if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
			|| hitCollisionsGroups.Contains( 'Static' ) 
			|| hitCollisionsGroups.Contains( 'Foliage' ) 
			|| hitCollisionsGroups.Contains( 'Water' )
			) 
			&& !stopped )
			{
				this.SoundEvent('magic_eredin_icespike_tell_loop_stop');
				StopProjectile();
				//DestroyAfter(0.4);
				
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_icespike_tell_sparks');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');
				this.SoundEvent('magic_eredin_frost_projectile');


				RemoveTimer('trail');

				CreateLeviathan();

				comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
				rot = comp.GetLocalRotation();
				
				rot.Roll = RandRangeF(180, 90);

				comp.SetRotation( rot );
				
				arrowHitPos = pos;
				arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.25f; 
				meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
				if( meshComponent )
				{
					boundingBox = meshComponent.GetBoundingBox();
					arrowSize = boundingBox.Max - boundingBox.Min;
				}
				Teleport( arrowHitPos );
				
				res = true;
			}	
			else 
			{
				return false;
			}
		}
	}

	timer function freeze_aura( dt : float , optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 1.5, 100 );

		for( i = 0; i < entities.Size(); i += 1 )
		{
			FreezeAura( entities[i] );
		}
	}

	function AttachIceFX()
	{
		var ent 							: CEntity;

		ent = theGame.CreateEntity( 
			
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
		TraceFloor( this.GetWorldPosition() ), thePlayer.GetWorldRotation() );

		ent.PlayEffect('ice_spike_appear_bigger');

		ent.PlayEffect('ice_spike_tell_bigger');

		AddTimer('freeze_aura', 1, true);

		ent.CreateAttachment(GetACSLeviathan(),'trail_point', Vector (0,0,0.7));

		ent.AddTag('ACS_Leviathan_Additional_FX');
	}

	function CreateLeviathan()
	{
		var knife_temp							: CEntityTemplate;
		var knife, ent 							: CEntity;

		knife_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_leviathan_loot.w2ent", true );

		knife = (CEntity)theGame.CreateEntity( knife_temp, this.GetWorldPosition() );

		((W3LeviathanContainer)(knife)).GetInventory().AddAnItem( 'Leviathan' , 1 );

		GetACSStorage().acs_recordLeviathanPosition(this.GetWorldPosition());

		knife.AddTag('ACS_Leviathan_Container');

	
		ent = theGame.CreateEntity( 
			
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
		TraceFloor( this.GetWorldPosition() ), thePlayer.GetWorldRotation() );

		ent.PlayEffect('ice_spikes');

		ent.PlayEffect('cone_ground_mutation_6_aard');

		if (this.HasTag('ACS_Leviathan_Projectile_Guarantee_Freeze'))
		{
			ent.PlayEffect('blast_ground_mutation_6_aard');
			this.SoundEvent("magic_eredin_icespike_tell_explosion");
		}

		ent.DestroyAfter(10);

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ), 1.f, 20, 1.f, 20.f, 0);

		AttachIceFX();
	}
}

class W3LeviathanContainer extends W3Container
{
	editable var animationForAllInteractions 	: bool;							default animationForAllInteractions = true;
	editable var interactionName				: string;						default interactionName = "Container";
	editable var holsterWeaponAtTheBeginning	: bool;							default holsterWeaponAtTheBeginning = true;
	editable var interactionAnim				: EPlayerExplorationAction;		default interactionAnim	= PEA_None;
	editable var slotAnimName 					: name;							default slotAnimName = '';
	editable var interactionAnimTime			: float;						default interactionAnimTime	= 4.0f;
	
	
	editable var desiredPlayerToEntityDistance	: float;						default desiredPlayerToEntityDistance = -1;
	editable var matchPlayerHeadingWithHeadingOfTheEntity	: bool;				default matchPlayerHeadingWithHeadingOfTheEntity = true;
	
	editable var attachThisObjectOnAnimEvent	: bool;							default attachThisObjectOnAnimEvent = false;
	editable var attachSlotName					: name; 						default attachSlotName = 'r_weapon';
	editable var attachAnimName 				: name; 						default attachAnimName = 'attach_item';
	editable var detachAnimName 				: name; 						default detachAnimName = 'detach_item';
	
	
	
	hint interactionAnim = "Name of the animation played on interaction.";
	hint interactionAnimTime = "Duration of the animation played on interaction.";
	hint animationForAllInteractions = "Should the animation be played only for interaction with Examine action assigned.";
	hint attachThisObjectOnAnimEvent = "";
	hint desiredPlayerToEntityDistance = "if set to < 0 palyer will stay in position where interaction was pressed";

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned( spawnData );

		AddTimer( 'ACS_Leviathan_Container_Destroy', 0.00001, true );		
	}
	
	event OnDetaching()
	{
		if ( isPlayingInteractionAnim )
		{
			OnPlayerActionEnd();
		}		
	}	
	
	event OnInteraction( actionName : string, activator : CEntity  )
	{
		var itemIds 																							: array<SItemUniqueId>;
		var i 																									: int;

		super.OnInteraction( actionName, activator );
		
		if ( activator == thePlayer && thePlayer.IsActionAllowed( EIAB_InteractionAction ) && thePlayer.CanPerformPlayerAction(true))
		{
			if( ( animationForAllInteractions == true || actionName == interactionName ) && !lockedByKey )
			{
				PlayInteractionAnimation();
			}

			itemIds = GetACSLeviathanTemporaryStorageUnit().GetInventory().GetItemsByTag( 'ACS_Designated_Leviathan' );

			if (itemIds.Size() > 0)
			{
				for( i = 0; i < itemIds.Size() ; i+=1 )
				{
					if( GetACSLeviathanTemporaryStorageUnit().GetInventory().ItemHasTag( itemIds[i], 'ACS_Designated_Leviathan' ) )
					{
						GetACSLeviathanTemporaryStorageUnit().GetInventory().RemoveItemTag( itemIds[i], 'ACS_Designated_Leviathan' );

						GetACSLeviathanTemporaryStorageUnit().GetInventory().GiveItemTo( thePlayer.GetInventory(), itemIds[i], 1, false, true, false);
					}
				}
			}

			GetACSLeviathanTemporaryStorageUnit().Destroy();

			thePlayer.EquipItem( thePlayer.inv.GetItemId('Leviathan'));

			if ( thePlayer.IsActionAllowed(EIAB_DrawWeapon) && thePlayer.GetBIsInputAllowed() && thePlayer.GetWeaponHolster().IsMeleeWeaponReady() )
			{
				thePlayer.GetInventory().MountItem( thePlayer.inv.GetItemId('Leviathan'), true );  

				thePlayer.GetWeaponHolster().OnWeaponDrawReady();
			}

			if (FactsQuerySum("ACS_Leviathan_Axe_Thrown") > 0)
			{
				FactsRemove("ACS_Leviathan_Axe_Thrown");
			}

			if (FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
			{
				FactsRemove("ACS_Leviathan_Axe_Returning");
			}

			thePlayer.RaiseEvent('LootHerb');

			ACSGetCEntity('ACS_Leviathan_Additional_FX').StopAllEffects();

			ACSGetCEntity('ACS_Leviathan_Additional_FX').BreakAttachment();

			ACSGetCEntity('ACS_Leviathan_Additional_FX').DestroyAfter(2);

			ACSGetCEntity('ACS_Leviathan_Additional_FX').RemoveTag('ACS_Leviathan_Additional_FX');

			GetACSLeviathan().SoundEvent("cmb_arrow_impact_dirt");

			GetACSLeviathan().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

			GetACSLeviathan().PlayEffect('disappear');
			
			GetACSLeviathan().DestroyAfter(0.4);
		}
		
	}
	
	function ProcessLoot ()
	{
	
	}
	
	event OnStreamIn()
	{
		super.OnStreamIn();
	}	
	
	public function OnContainerClosed()
	{
		var effectName : name;

		if ( !HasQuestItem() )
		{
			StopEffect( 'quest_highlight_fx' );	
		}

		if ( isPlayingInteractionAnim )
		{
			thePlayer.PlayerStopAction( interactionAnim );	
		}
		
		effectName = this.GetAutoEffect();
		if ( effectName != '' )
		{
			this.StopEffect( effectName );
		}

		super.OnContainerClosed();
	}
	
	function PlayInteractionAnimation()
	{
		if ( interactionAnim == PEA_SlotAnimation && !IsNameValid(slotAnimName) )
		{
			super.ProcessLoot();
				
			return;
		}
		
		if ( interactionAnim != PEA_None )
		{
			if ( this.attachThisObjectOnAnimEvent )
			{
				thePlayer.AddAnimEventChildCallback(this,attachAnimName,'OnAnimEvent_Custom');
				thePlayer.AddAnimEventChildCallback(this,detachAnimName,'OnAnimEvent_Custom');
			}
				
			thePlayer.RegisterForPlayerAction(this, false);
			
			if ( ShouldBlockGameplayActionsOnInteraction() )
			{
				BlockGameplayActions(true);
			}
			
			if ( !GetToPointAndStartAction() )
				OnPlayerActionEnd();
			
			isPlayingInteractionAnim = true;
			
			if ( interactionAnim == PEA_SlotAnimation )
				return;
			
			if ( interactionAnimTime < 1.0f )
			{
				interactionAnimTime = 1.0f;
			}
			if(skipInventoryPanel)
			{
				AddTimer( 'TimerDeactivateAnimation', interactionAnimTime, false );			
			}
			
		}
		else
		{
			super.ProcessLoot();
		}
	}
	
	function BlockGameplayActions( lock : bool )
	{
		var exceptions : array< EInputActionBlock >;		
		exceptions.PushBack( EIAB_ExplorationFocus );
	
		if ( lock && holsterWeaponAtTheBeginning )
			thePlayer.OnEquipMeleeWeapon(PW_None,true);
			
		if ( lock )
			thePlayer.BlockAllActions('W3AnimationInteractionEntity', true, exceptions);
		else
			thePlayer.BlockAllActions('W3AnimationInteractionEntity', false);
	}
	
	function ShouldBlockGameplayActionsOnInteraction() : bool
	{
		return true;
	}
	
	function GetToPointAndStartAction() : bool
	{
		var movementAdjustor 				: CMovementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		var ticket 							: SMovementAdjustmentRequestTicket = movementAdjustor.CreateNewRequest( 'InteractionEntity' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		if ( matchPlayerHeadingWithHeadingOfTheEntity )
			movementAdjustor.RotateTowards( ticket, this );
		if ( desiredPlayerToEntityDistance >= 0 )
			movementAdjustor.SlideTowards( ticket, this, desiredPlayerToEntityDistance );
		
		return thePlayer.PlayerStartAction( interactionAnim, slotAnimName );
	}
	
	private var objectAttached : bool;
	private var objectCachedPos : Vector;
	private var objectCachedRot	: EulerAngles;
	
	private function AttachObject()
	{
		if ( objectAttached )
			return;
			
		objectCachedPos = this.GetWorldPosition();
		objectCachedRot = this.GetWorldRotation();
		this.CreateAttachment(thePlayer,attachSlotName);
		objectAttached = true;
	}
	
	private function DetachObject()
	{
		if ( !objectAttached )
			return;
			
		this.BreakAttachment();
		this.TeleportWithRotation(objectCachedPos,objectCachedRot);
		objectAttached = false;
	}
	
	
	
	
	event OnPlayerActionStartFinished()
	{
		if ( !skipInventoryPanel )
		{
			ShowLoot();
		}
	}
	
	
	event OnPlayerActionEnd()
	{
		isPlayingInteractionAnim = false;
		thePlayer.UnregisterForPlayerAction(this, false);
		
		thePlayer.RemoveAnimEventChildCallback(this,attachAnimName);
		thePlayer.RemoveAnimEventChildCallback(this,detachAnimName);
		
		if ( ShouldBlockGameplayActionsOnInteraction() )
		{
			BlockGameplayActions(false);
		}
		DetachObject();
	}
	
	event OnAnimEvent_Custom( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		if ( animEventName == attachAnimName && attachThisObjectOnAnimEvent )
		{
			AttachObject();
		}
		else if ( animEventName == detachAnimName )
		{
			DetachObject();
		}
	}
	
	
	
	
	timer function TimerDeactivateAnimation( td : float , id : int)
	{
		TakeAllItems();
		OnContainerClosed();		
	}

	timer function ACS_Leviathan_Container_Destroy( td : float , id : int)
	{
		if (thePlayer.inv.HasItem('Leviathan')
		|| FactsQuerySum("ACS_Leviathan_Axe_Returning") > 0)
		{		
			this.Destroy();
		}
		
	}
}

class ACSBladeProjectile extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot, chain_rot 									: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;
	private var eff_names													: array<CName>;
	private var chain_ent, marker_ent										: CEntity;
	private var chain_temp, marker_temp										: CEntityTemplate;
	private var animatedComponentA											: CAnimatedComponent;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= RandRange(90, -90);
		rot.Yaw += 90;
		comp.SetRotation( rot );

		if (ACS_Armor_Alpha_Equipped_Check())
		{
			if (RandF() < 0.5)
			{
				this.SoundEvent("monster_cyclop_chain_move_heavy");
			}
			else
			{
				this.SoundEvent("monster_cyclop_chain_move_light");
			}

			AddTimer('chain_attach', 0.04, true);

			//PlayEffect('chain_glow_1');

			PlayEffect('hellspire_head_projectile_glow');
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			fill_effects_array();

			PlayEffectSingle('red_fast_attack_buff');
			PlayEffectSingle('red_fast_attack_buff_hit');

			PlayEffectSingle('red_trail');

			PlayEffectSingle('red_runeword_igni_1');
			PlayEffectSingle('red_runeword_igni_2');

			PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

			this.SoundEvent("monster_dracolizard_combat_fireball_flyby");
		}
	}

	timer function chain_attach( dt : float , optional id : int)
	{
		if (RandF() < 0.5)
		{
			this.SoundEvent("monster_cyclop_chain_move_heavy");
		}
		else
		{
			this.SoundEvent("monster_cyclop_chain_move_light");
		}

		chain_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

		chain_rot = this.GetWorldRotation();
		//chain_rot.Roll += 90;
		chain_rot.Pitch += 90;
		//chain_rot.Yaw += 90;

		chain_ent = (CEntity)theGame.CreateEntity( chain_temp, this.GetWorldPosition(), chain_rot );

		chain_ent.PlayEffect('chain_glow_1');

		chain_ent.DestroyAfter(7);
	}
	
	timer function sword_explode( dt : float , optional id : int)
	{
		RemoveTimers();

		DealDamageProjOmega();

		DestroyEffect('explode');
		PlayEffect('explode');
		this.SoundEvent("bomb_glue_explo");

		AddTimer('sword_destroy', 0.5);
	}

	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();

		DestroyEffect('red_runeword_igni_1');
		DestroyEffect('red_runeword_igni_2');

		DestroyEffect('red_trail');

		DestroyEffect('red_fast_attack_buff');
		DestroyEffect('red_fast_attack_buff_hit');

		PlayEffect('red_fast_attack_buff');
		PlayEffect('red_fast_attack_buff_hit');

		DestroyAfter(0.25);
	}

	function fill_effects_array()
	{
		eff_names.Clear();

		eff_names.PushBack('war_sword_projectile_glow');
		eff_names.PushBack('andurial_projectile_glow');
		eff_names.PushBack('doom_sword_projectile_glow');
		eff_names.PushBack('dsd_projectile_glow');
		eff_names.PushBack('pridefall_projectile_glow');
	}
	
	function DealDamageToTargetOmega( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		if (actortarget.UsesVitality()) 
		{ 
			maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

			damageMax = maxTargetVitality * 0.125; 
		} 
		else if (actortarget.UsesEssence()) 
		{ 
			maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
			
			damageMax = maxTargetEssence * 0.125; 
		} 
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			dmg = new W3DamageAction in theGame.damageMgr;

			dmg.Initialize(GetWitcherPlayer(), actortarget, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Heavy, true);

			if (actortarget.UsesVitality()) 
			{
				if(actortarget.GetHealth() > actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetVitality = actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * RandRangeF(0.25, 0.06125); 
				}
				else if(actortarget.GetHealth() <= actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * RandRangeF(0.25, 0.06125); 
				}
			} 
			else if (actortarget.UsesEssence()) 
			{
				if(actortarget.GetHealth() > actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetEssence = actortarget.GetStat( BCS_Essence );
				
					damageMax = maxTargetEssence * RandRangeF(0.25, 0.06125); 
				}
				else if(actortarget.GetHealth() <= actortarget.GetMaxHealth() * 0.5)
				{
					maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
				
					damageMax = maxTargetEssence * RandRangeF(0.25, 0.06125); 
				}
			}

			GetWitcherPlayer().SoundEvent("cmb_play_hit_light");

			dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

			dmg.AddEffectInfo( EET_Burning, 0.1 );

			dmg.SetForceExplosionDismemberment();

			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;
		}
	}

	function DealDamageToTargetAlpha( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			dmg = new W3DamageAction in theGame.damageMgr;

			dmg.Initialize(GetWitcherPlayer(), actortarget, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Heavy, true);

			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}

			if (actortarget.UsesVitality()) 
			{
				maxTargetVitality = actortarget.GetStat( BCS_Vitality );

				damageMax = maxTargetVitality * 0.030625; 
			} 
			else if (actortarget.UsesEssence()) 
			{
				maxTargetEssence = actortarget.GetStat( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.030625; 
			} 

			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

			dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;

			GetWitcherPlayer().SoundEvent("cmb_play_hit_light");

			animatedComponentA = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );

			if (!animatedComponentA.HasFrozenPose())
			{
				marker_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\philippa_hit_marker.w2ent", true );

				marker_ent = (CEntity)theGame.CreateEntity( marker_temp, actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );

				marker_ent.DestroyEffect('marker');

				marker_ent.PlayEffect('marker_red');

				marker_ent.DestroyAfter(7);
			}

			animatedComponentA.FreezePoseFadeIn(1.0f);

			animatedComponentA.UnfreezePoseFadeOut(7.f);
		}
	}

	function DealDamageProjOmega()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 2.5, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTargetOmega( entities[i], effType, crit );
		}
	}

	function DealDamageProjAlpha()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 1, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTargetAlpha( entities[i], effType, crit );
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if (ACS_Armor_Alpha_Equipped_Check())
		{
			if(collidingComponent)
			{
				victim = (CGameplayEntity)collidingComponent.GetEntity();
			}
			
			if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
			{		
				if ( victim 
				&& !collidedEntities.Contains(victim) 
				&& victim != GetWitcherPlayer() 
				&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
				&& victim.IsAlive() )
				{
					actor = (CActor)victim;
					
					collidedEntities.PushBack(victim);
					
					if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
					{
						DealDamageProjAlpha();
					}
				}
			}
			if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
			|| hitCollisionsGroups.Contains( 'Static' ) 
			|| hitCollisionsGroups.Contains( 'Foliage' ) 
			) 
			&& !stopped )
			{
				DealDamageProjAlpha();
				StopProjectile();

				RemoveTimer('chain_attach');
				AddTimer('sword_destroy', 7);

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( this.GetWorldPosition() ), 0.5f, 7.0f, 0.5f, 5.f, 1);
				
				arrowHitPos = pos;
				arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 1.25f; 

				meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
				if( meshComponent )
				{
					boundingBox = meshComponent.GetBoundingBox();
					arrowSize = boundingBox.Max - boundingBox.Min;
				}
				Teleport( arrowHitPos );
				
				res = true;
			}	
			else 
			{
				return false;
			}
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			if(collidingComponent)
			{
				victim = (CGameplayEntity)collidingComponent.GetEntity();
			}
			
			if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
			{		
				if ( victim 
				&& !collidedEntities.Contains(victim) 
				&& victim != GetWitcherPlayer() 
				&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
				&& victim.IsAlive() )
				{
					actor = (CActor)victim;
					
					collidedEntities.PushBack(victim);
					
					if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
					{
						bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);

						theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( this.GetWorldPosition() ), 0.5f, 7.0f, 0.5f, 5.f, 1);
						
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 1.25f; 
						
						stopped = true;

						DealDamageProjOmega();
						StopProjectile();
						PlayEffect('explode');
						this.SoundEvent("bomb_glue_explo");
						AddTimer('sword_explode', 7);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
					}
				}
			}
			else if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
			|| hitCollisionsGroups.Contains( 'Static' ) 
			|| hitCollisionsGroups.Contains( 'Foliage' ) 
			) 
			&& !stopped )
			{
				DealDamageProjOmega();
				StopProjectile();
				PlayEffect('explode');
				this.SoundEvent("bomb_glue_explo");
				AddTimer('sword_explode', 7);

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( this.GetWorldPosition() ), 0.5f, 7.0f, 0.5f, 5.f, 1);
				
				arrowHitPos = pos;
				arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 1.25f; 

				meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
				if( meshComponent )
				{
					boundingBox = meshComponent.GetBoundingBox();
					arrowSize = boundingBox.Max - boundingBox.Min;
				}
				Teleport( arrowHitPos );
				
				res = true;
			}	
			else 
			{
				return false;
			}
		} 
	}
}

class ACSBowProjectile extends W3AdvancedProjectile
{
	private var bone 																																						: name;
	private var actor, actortarget, displaytarget																															: CActor;
	private var target																																						: CNewNPC;	
	private var i	 																																						: int;
	private var victims																																						: array<CGameplayEntity>;
	private var comp, meshComponent																																			: CMeshComponent;
	private var rot, bone_rot 																																				: EulerAngles;
	private var res, stopped 																																				: bool;
	private var attAction																																					: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos, initpos, targetPosition, initpos_split, targetPosition_split, spawnPos, initpos_rain, targetPosition_rain,finalpos 		: Vector;
	private var boundingBox																																					: Box;
	private var rotMat																																						: Matrix;
	private var effType																																						: EEffectType;
	private var crit																																						: bool;
	private var giant_sword	 																																				: W3ACSSwordProjectileGiant;
	private var split_arrow																																					: ACSBowProjectileSplit;
	private var meshcomp 																																					: CComponent;
	private var h 																																							: float;
	private var vfxEnt_1, vfxEnt_2 																																			: CEntity;
	private var actors																																						: array<CActor>;
	private var rain_arrow																																					: ACSBowProjectileRain;
	private var randAngle, randRange																																		: float;
	private var targetPositionNPC																																			: Vector;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		AddTimer('tracking_delay', 0.06, false);
	}

	timer function tracking_delay( deltaTime : float , id : int)
	{
		displaytarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		if (displaytarget)
		{
			AddTimer('tracking', 0.1, true);
		}
	}

	timer function tracking( deltaTime : float , id : int)
	{
		var pos 															: Vector;

		displaytarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

		if (displaytarget)
		{
			if ( displaytarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = displaytarget.GetBoneWorldPosition('head');
				//targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
			else
			{
				if ( displaytarget.GetBoneIndex('k_head_g') != -1 )
				{
					targetPositionNPC = displaytarget.GetBoneWorldPosition('k_head_g');
					//targetPositionNPC.Z += RandRangeF(0.1,-0.1);
					targetPositionNPC.X += RandRangeF(0.1,-0.1);
				}
				else
				{
					targetPositionNPC = displaytarget.GetWorldPosition();
					targetPositionNPC.Z += 1.1;
					targetPositionNPC.X += RandRangeF(0.1,-0.1);
				}
			}

			this.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPositionNPC, 500  );
		}
		else
		{
			RemoveTimer('tracking');
		}
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}

	timer function arrow_rain( dt : float , optional id : int)
	{
		arrow_rain_actual();
	}

	timer function arrow_rain_stop( dt : float , optional id : int)
	{
		RemoveTimer('arrow_rain');
		RemoveTimer('arrow_rain_stop');
	}

	function arrow_rain_actual()
	{
		actortarget = (CActor)victim;

		initpos_rain = actortarget.PredictWorldPosition(0.7);	
		initpos_rain.Z += 50;

		targetPosition_rain = actortarget.PredictWorldPosition(0.7);
		targetPosition_rain.Z += 1.1;

		for( i = 0; i < 3; i += 1 )
		{
			randRange = 2 + 2 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initpos_rain.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initpos_rain.Y;
			spawnPos.Z = initpos_rain.Z;

			finalpos = spawnPos;
			finalpos.Z -= 13;
			
			rain_arrow = (ACSBowProjectileRain)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_rain.w2ent", true ), spawnPos );

			rain_arrow.Init(GetWitcherPlayer());

			rain_arrow.PlayEffect('glow');
			rain_arrow.PlayEffect('arrow_trail_fire');
			rain_arrow.ShootProjectileAtPosition( 0, 45+RandRange(20,1), targetPosition_rain, 500 );
			rain_arrow.DestroyAfter(5);
		}

		for( i = 0; i < 3; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initpos_rain.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initpos_rain.Y;
			spawnPos.Z = initpos_rain.Z;
			
			rain_arrow = (ACSBowProjectileRain)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_rain.w2ent", true ), spawnPos );

			rain_arrow.Init(GetWitcherPlayer());

			rain_arrow.PlayEffect('glow');
			rain_arrow.PlayEffect('arrow_trail_fire');
			rain_arrow.ShootProjectileAtPosition( 0, 45+RandRange(20,1), targetPosition_rain, 500 );
			rain_arrow.DestroyAfter(5);
		}
	}

	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			((CActor)victim).AddAbility( 'DisableFinishers', true );

			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			if ( !GetWitcherPlayer().IsInInterior() )
			{
				AddTimer('arrow_rain', 0.25, true);

				AddTimer('arrow_rain_stop', 3, false);
			}
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;

			((CActor)victim).RemoveAbility( 'DisableFinishers' );

			collidedEntities.PushBack(victim);
		}
	}
	
	/*
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );

			initpos = actortarget.GetWorldPosition();	
			initpos.Z += 20;

			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPosition = actortarget.GetBoneWorldPosition('head');

			}
			else
			{
				targetPosition = actortarget.GetBoneWorldPosition('k_head_g');
			}
			
			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPosition );
				vfxEnt_1.PlayEffect('mutation_2_igni');
				vfxEnt_1.DestroyAfter(1.5);

				vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), targetPosition );
				vfxEnt_2.PlayEffect('explode');
				vfxEnt_2.DestroyAfter(2.5);

				attAction.AddEffectInfo( EET_Burning, 1 );

				attAction.AddEffectInfo( EET_HeavyKnockdown, 1 );
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			{
				actors = actortarget.GetNPCsAndPlayersInRange( 10, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

				if( actors.Size() > 0 )
				{
					initpos_split = actors[i].GetWorldPosition();	

					for( i = 0; i < actors.Size(); i += 1 )
					{
						if ( GetAttitudeBetween( actors[i], GetWitcherPlayer() ) == AIA_Hostile && actors[i].IsAlive() )
						{
							targetPosition_split = actors[i].PredictWorldPosition(0.1);
							targetPosition_split.Z += 1.1;

							split_arrow = (ACSBowProjectileSplit)theGame.CreateEntity( 
							(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\bow_projectile_split.w2ent", true ), initpos_split );

							split_arrow.Init(GetWitcherPlayer());
							split_arrow.PlayEffect('glow');
							split_arrow.ShootProjectileAtPosition( 0, 15+RandRange(5,1), targetPosition_split, 500 );
							split_arrow.DestroyAfter(31);
						}
					}
				}
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			{
				for( i = 0; i < 3; i += 1 )
				{
					randRange = 2.5 + 2.5 * RandF();
					randAngle = 2 * Pi() * RandF();
					
					spawnPos.X = randRange * CosF( randAngle ) + initpos.X;
					spawnPos.Y = randRange * SinF( randAngle ) + initpos.Y;
					spawnPos.Z = initpos.Z;
					
					giant_sword = (W3ACSSwordProjectileGiant)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_giant.w2ent", true ), initpos );

					meshcomp = giant_sword.GetComponentByClassName('CMeshComponent');
					h = 3;
					meshcomp.SetScale(Vector(h,h,h,1));	

					giant_sword.Init(GetWitcherPlayer());

					giant_sword.PlayEffect('glow');
					giant_sword.ShootProjectileAtPosition( 0, 40, this.GetWorldPosition(), 500 );
					giant_sword.DestroyAfter(3);
				}
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			{
				AddTimer('arrow_rain', 0.25, true);

				AddTimer('arrow_rain_stop', 3, false);
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			{
				ACS_Giant_Lightning_Strike_Single();

				attAction.AddEffectInfo( EET_Paralyzed, 1 );
			}

			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			collidedEntities.PushBack(victim);
		}
	}
	*/


	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.5 ) 
					{
						if(victim.GetBoneIndex('torso') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('torso');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
					else
					{
						if(victim.GetBoneIndex('torso3') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('torso3');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						if(victim.GetBoneIndex('torso2') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('torso2');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
					else
					{
						if(victim.GetBoneIndex('pelvis') != -1)
						{			
							arrowHitPos = victim.GetBoneWorldPosition('pelvis');
							arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
							res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

							stopped = true;
							StopProjectile();
							AddTimer('sword_destroy', 30);
						}
					}
				}

				thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) );

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}

			RemoveTimer('tracking_delay');
			RemoveTimer('tracking');
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			RemoveTimer('tracking_delay');
			RemoveTimer('tracking');

			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBowProjectileMoving extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;
	private var displaytarget												: CActor;
	private var targetPositionNPC											: Vector;
	var projectileSpeed : float;
	default projectileSpeed = 0;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		PlayEffect( 'arrow_trail' );

		PlayEffect( 'arrow_trail_underwater' );

		PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );

		AddTimer('tracking_delay', 0.25, false);
	}

	timer function tracking_delay( deltaTime : float , id : int)
	{
		AddTimer('tracking', 0.001, true);
	}

	timer function tracking( deltaTime : float , id : int)
	{
		var pos, movetargetposition 										: Vector;
		var playerMoveTarget 												: CActor;
		var targetDistance													: float;
	

		displaytarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

		playerMoveTarget = thePlayer.moveTarget;	

		movetargetposition = playerMoveTarget.GetWorldPosition();

		movetargetposition.Z += 1.1;

		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), displaytarget.GetWorldPosition() ) ;


		if (displaytarget)
		{
			projectileSpeed += 1;

			if( targetDistance <= 3 * 3 ) 
			{
				if ( displaytarget.GetBoneIndex('head') != -1 )
				{
					targetPositionNPC = displaytarget.GetBoneWorldPosition('head');
					//targetPositionNPC.Z += RandRangeF(0,-0.1);
					targetPositionNPC.X += RandRangeF(0.1,-0.1);
				}
				else
				{
					if ( displaytarget.GetBoneIndex('k_head_g') != -1 )
					{
						targetPositionNPC = displaytarget.GetBoneWorldPosition('k_head_g');
						//targetPositionNPC.Z += RandRangeF(0.1,-0.1);
						targetPositionNPC.X += RandRangeF(0.1,-0.1);
					}
					else
					{
						targetPositionNPC = displaytarget.GetWorldPosition();
						targetPositionNPC.Z += 1.5;
						targetPositionNPC.X += RandRangeF(0.1,-0.1);
					}
				}
			}
			else if( targetDistance > 3 * 3 && targetDistance <= 7.5*7.5 ) 
			{
				if ( displaytarget.GetBoneIndex('head') != -1 )
				{
					targetPositionNPC = displaytarget.GetBoneWorldPosition('head');
					targetPositionNPC.Z += RandRangeF(0,-0.25);
					targetPositionNPC.X += RandRangeF(0.15,-0.15);
				}
				else
				{
					if ( displaytarget.GetBoneIndex('k_head_g') != -1 )
					{
						targetPositionNPC = displaytarget.GetBoneWorldPosition('k_head_g');
						targetPositionNPC.Z += RandRangeF(0,-0.25);
						targetPositionNPC.X += RandRangeF(0.15,-0.15);
					}
					else
					{
						targetPositionNPC = displaytarget.GetWorldPosition();
						targetPositionNPC.Z += RandRangeF(0,-0.25);
						targetPositionNPC.X += RandRangeF(0.15,-0.15);
					}
				}
			}
			else if( targetDistance > 7.5 * 7.5 ) 
			{
				if ( displaytarget.GetBoneIndex('head') != -1 )
				{
					targetPositionNPC = displaytarget.GetBoneWorldPosition('head');
					targetPositionNPC.Z += RandRangeF(0,-0.5);
					targetPositionNPC.X += RandRangeF(0.25,-0.25);
				}
				else
				{
					if ( displaytarget.GetBoneIndex('k_head_g') != -1 )
					{
						targetPositionNPC = displaytarget.GetBoneWorldPosition('k_head_g');
						targetPositionNPC.Z += RandRangeF(0,-0.5);
						targetPositionNPC.X += RandRangeF(0.25,-0.25);
					}
					else
					{
						targetPositionNPC = displaytarget.GetWorldPosition();
						targetPositionNPC.Z += RandRangeF(0,-0.5);
						targetPositionNPC.X += RandRangeF(0.25,-0.25);
					}
				}
			}

			if ( displaytarget.HasTag('ACS_second_bow_moving_projectile'))
			{
				this.ShootProjectileAtPosition( 0, 10+(projectileSpeed*2), targetPositionNPC, 500  );

				if (!this.IsEffectActive('arrow_trail_fire', false))
				{
					PlayEffectSingle('arrow_trail_fire');
				}
			}
			else
			{
				this.ShootProjectileAtPosition( 0, 10+projectileSpeed, targetPositionNPC, 500  );

				if (this.IsEffectActive('arrow_trail_fire', false))
				{
					StopEffect('arrow_trail_fire');
				}
			}
		}
		else
		{
			if (this.IsEffectActive('arrow_trail_fire', false))
			{
				StopEffect('arrow_trail_fire');
			}

			RemoveTimer('tracking');
		}
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		((CActor)victim).AddAbility( 'DisableFinishers', true );
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.025; 
				
				damageMin = maxTargetVitality * 0.01; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
				
				damageMin = maxTargetEssence * 0.025; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
			dmg.SetHitReactionType( EHRT_Light );

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 2 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 2 );

			if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
			{ 
				//dmg.AddEffectInfo( EET_Stagger, 0.1 );
			}

			if (
			!actortarget.HasTag('ACS_first_bow_moving_projectile')
			&& !actortarget.HasTag('ACS_second_bow_moving_projectile')
			)
			{
				actortarget.AddTag('ACS_first_bow_moving_projectile'); 
			}
			else if (
			actortarget.HasTag('ACS_first_bow_moving_projectile') 
			)
			{
				actortarget.RemoveTag('ACS_first_bow_moving_projectile'); 
				actortarget.AddTag('ACS_second_bow_moving_projectile');
			}
			else if (
			actortarget.HasTag('ACS_second_bow_moving_projectile')
			)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					dmg.AddEffectInfo( EET_Burning, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					dmg.AddEffectInfo( EET_Frozen, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{
					dmg.AddEffectInfo( EET_Slowdown, 1 );
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					dmg.AddEffectInfo( EET_Paralyzed, 1 );
				}

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) * 2.5 );

				dmg.SetHitReactionType( EHRT_Light );

				dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				actortarget.RemoveTag('ACS_second_bow_moving_projectile'); 
			}

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}

			((CActor)victim).RemoveAbility( 'DisableFinishers' );
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
				}

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.1 );

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );

				StopEffect( 'arrow_trail' );

				StopEffect( 'arrow_trail_underwater' );

				StopEffect( 'arrow_trail_red' );
			}

			RemoveTimer('tracking_delay');
			RemoveTimer('tracking');
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			RemoveTimer('tracking_delay');
			RemoveTimer('tracking');

			StopEffect( 'arrow_trail' );

			StopEffect( 'arrow_trail_underwater' );

			StopEffect( 'arrow_trail_red' );

			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSCrossbowProjectile extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;
	private var displaytarget												: CActor;
	private var targetPositionNPC											: Vector;
	var projectileSpeed : float;
	default projectileSpeed = 0;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		PlayEffect( 'arrow_trail' );

		PlayEffect( 'arrow_trail_underwater' );

		PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );

		AddTimer('tracking_delay', 0.125, false);
	}

	timer function tracking_delay( deltaTime : float , id : int)
	{
		AddTimer('tracking', 0.001, true);
	}

	timer function tracking( deltaTime : float , id : int)
	{
		var pos, movetargetposition 										: Vector;
		var playerMoveTarget 												: CActor;
		var targetDistance													: float;
	

		displaytarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

		//playerMoveTarget = thePlayer.moveTarget;	

		//movetargetposition = playerMoveTarget.GetWorldPosition();

		//movetargetposition.Z += 1.1;

		targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), displaytarget.GetWorldPosition() ) ;


		if (displaytarget)
		{
			projectileSpeed += 1;

			if ( displaytarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = displaytarget.GetBoneWorldPosition('head');
				//targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
			else
			{
				if ( displaytarget.GetBoneIndex('k_head_g') != -1 )
				{
					targetPositionNPC = displaytarget.GetBoneWorldPosition('k_head_g');
					//targetPositionNPC.Z += RandRangeF(0.1,-0.1);
					targetPositionNPC.X += RandRangeF(0.1,-0.1);
				}
				else
				{
					targetPositionNPC = displaytarget.GetWorldPosition();
					targetPositionNPC.Z += 1.5;
					targetPositionNPC.X += RandRangeF(0.1,-0.1);
				}
			}

			this.ShootProjectileAtPosition( 0, 10+projectileSpeed, targetPositionNPC, 500  );

			if (this.IsEffectActive('arrow_trail_fire', false))
			{
				StopEffect('arrow_trail_fire');
			}
		}
		else
		{
			if (this.IsEffectActive('arrow_trail_fire', false))
			{
				StopEffect('arrow_trail_fire');
			}

			RemoveTimer('tracking');
		}
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		((CActor)victim).AddAbility( 'DisableFinishers', true );
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.025; 
				
				damageMin = maxTargetVitality * 0.01; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
				
				damageMin = maxTargetEssence * 0.025; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, true, false, false, false);
			
			dmg.SetHitReactionType( EHRT_Light );

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 8 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 8 );

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}

			((CActor)victim).RemoveAbility( 'DisableFinishers' );
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
				}

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.1 );

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );

				StopEffect( 'arrow_trail' );

				StopEffect( 'arrow_trail_underwater' );

				StopEffect( 'arrow_trail_red' );
			}

			RemoveTimer('tracking_delay');
			RemoveTimer('tracking');
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			RemoveTimer('tracking_delay');
			RemoveTimer('tracking');

			StopEffect( 'arrow_trail' );

			StopEffect( 'arrow_trail_underwater' );

			StopEffect( 'arrow_trail_red' );

			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}
/*
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos		: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}
*/

class ACSCrossbowProjectileMoving extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos		: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( eff, 3 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
			
			//this.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class W3ACSSwordProjectileGiant extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var attAction													: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');

		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch += 90;
		rot.Yaw += 90;
		comp.SetRotation( rot );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;

		if (actortarget.UsesVitality()) 
		{ 
			maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

			damageMax = maxTargetVitality * 0.35; 
		} 
		else if (actortarget.UsesEssence()) 
		{ 
			maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
			
			damageMax = maxTargetEssence * 0.35; 
		} 
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			attAction = new W3Action_Attack in theGame.damageMgr;
			attAction.Init( GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Light);
			attAction.SetHitAnimationPlayType(EAHA_Default);
			
			attAction.SetSoundAttackType( 'wpn_slice' );

			attAction.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );
			
			attAction.AddEffectInfo( EET_HeavyKnockdown, 1 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
	
			delete attAction;
		}
	}

	function DealDamageProj()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 3, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToTarget( entities[i], effType, crit );
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			DealDamageProj();
			StopProjectile();
			AddTimer('sword_destroy', 2);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 2.5f; 
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBowProjectileSplit extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		PlayEffect( 'arrow_trail' );

		PlayEffect( 'arrow_trail_underwater' );

		PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.025; 
				
				damageMin = maxTargetVitality * 0.01; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
				
				damageMin = maxTargetEssence * 0.025; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_AttackPower, true, false, false, false);
			
			//dmg.SetHitReactionType( EHRT_Light );

			//dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			//dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 2 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 2 );

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
			
			if ( ( (CNewNPC)victim).IsShielded( NULL ) )
			{
				( (CNewNPC)victim).ProcessShieldDestruction();
			}
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 30);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 30);
							}
						}
					}
				}

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}

			StopEffect( 'arrow_trail' );

			StopEffect( 'arrow_trail_underwater' );

			StopEffect( 'arrow_trail_red' );
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopEffect( 'arrow_trail' );

			StopEffect( 'arrow_trail_underwater' );

			StopEffect( 'arrow_trail_red' );

			StopProjectile();
			AddTimer('sword_destroy', 30);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class ACSBowProjectileRain extends W3AdvancedProjectile
{
	private var bone 														: name;
	private var actor, actortarget											: CActor;
	private var target														: CNewNPC;	
	private var i	 														: int;
	private var victims														: array<CGameplayEntity>;
	private var comp, meshComponent											: CMeshComponent;
	private var rot, bone_rot 												: EulerAngles;
	private var res, stopped 												: bool;
	private var dmg															: W3DamageAction;
	private var arrowHitPos, arrowSize, bone_pos							: Vector;
	private var boundingBox													: Box;
	private var rotMat														: Matrix;
	private var effType														: EEffectType;
	private var crit														: bool;
	private var maxTargetVitality, maxTargetEssence, damageMax, damageMin	: float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Yaw -= 90;
		comp.SetRotation( rot );

		this.SoundEvent( "cmb_arrow_swoosh" );

		PlayEffect( 'arrow_trail' );

		PlayEffect( 'arrow_trail_underwater' );

		PlayEffect( 'arrow_trail_red' );

		//PlayEffect( 'arrow_trail_fire' );

		//PlayEffect( 'fire' );

		//PlayEffect( 'lightning_hit' );
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		StopEffect('glow');
		PlayEffect('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		if ( actortarget 
		&& actortarget != GetWitcherPlayer() 
		&& GetAttitudeBetween( actortarget, GetWitcherPlayer() ) == AIA_Hostile 
		&& actortarget.IsAlive() ) 
		{
			((CActor)victim).AddAbility( 'DisableFinishers', true );

			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.125; 
				
				damageMin = maxTargetVitality * 0.05; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.125; 
				
				damageMin = maxTargetEssence * 0.05; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, true, false, false, false);
			
			dmg.SetHitReactionType( EHRT_Light );

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			//dmg.SetProcessBuffsIfNoDamage(true);

			//dmg.SetForceExplosionDismemberment();
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) / 4 );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) / 4 );

			//dmg.AddEffectInfo( effType, 3 );

			dmg.CanBeParried();

			dmg.CanBeDodged();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	

			((CActor)victim).RemoveAbility( 'DisableFinishers' );
			
			collidedEntities.PushBack(victim);
		}
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent 
		&& !hitCollisionsGroups.Contains( 'Static' ) 
		)
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim != GetWitcherPlayer() 
			&& ( GetAttitudeBetween( victim, GetWitcherPlayer() ) == AIA_Hostile) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 5);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_HeavyKnockdown;
						}
											
						crit = true;

						res = true;
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						AddTimer('sword_destroy', 5);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;

						res = true;
					}
					else if ((StrContains(StrLower(NameToString(bone)), "r_hand" )))
					{
						actor.DropItemFromSlot( 'r_weapon', true );
					}
					else
					{
						if ( !actor.HasBuff( EET_Knockdown ) 
						&& !actor.HasBuff( EET_HeavyKnockdown ) 
						&& !actor.GetIsRecoveringFromKnockdown() 
						&& !actor.HasBuff( EET_Ragdoll ) )
						{
							effType = EET_LongStagger;
						}
						crit = false;
					}
				}
				else
				{	
					if( RandF() < 0.5 ) 
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
						else
						{
							if(victim.GetBoneIndex('torso3') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso3');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso3', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
					}
					else
					{
						if( RandF() < 0.5 ) 
						{
							if(victim.GetBoneIndex('torso2') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('torso2');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'torso2', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
						else
						{
							if(victim.GetBoneIndex('pelvis') != -1)
							{			
								arrowHitPos = victim.GetBoneWorldPosition('pelvis');
								arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
								res = this.CreateAttachmentAtBoneWS(actor, 'pelvis', arrowHitPos, this.GetWorldRotation());

								stopped = true;
								StopProjectile();
								AddTimer('sword_destroy', 5);
							}
						}
					}
				}

				DealDamageToTarget( victim, effType, crit );

				this.SoundEvent( "cmb_arrow_impact_body" );
			}

			StopEffect( 'arrow_trail' );

			StopEffect( 'arrow_trail_underwater' );

			StopEffect( 'arrow_trail_red' );

			StopEffect( 'arrow_trail_fire' );
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopped )
		{
			StopEffect( 'arrow_trail' );

			StopEffect( 'arrow_trail_underwater' );

			StopEffect( 'arrow_trail_red' );

			StopEffect( 'arrow_trail_fire' );

			StopProjectile();
			AddTimer('sword_destroy', 5);
			
			this.SoundEvent("cmb_arrow_impact_dirt");
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}
}

class W3BatSwarmGather extends W3AdvancedProjectile
{
	var damage 						: Float; 
	var effect						: CEntity;
	var victims						: array<CGameplayEntity>;
	var comp						: CMeshComponent;
	var range						: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{		
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		comp.SetScale( Vector ( 0.f, 0.f, 0.f ) );
		
		range = 3;
	}
	
	event OnProjectileInit()
	{

	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( IsStopped() )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;

		
		if ( victim && victim.IsAlive() && !victims.Contains(victim) && victim != GetWitcherPlayer() )
		{
			DealDamageProj();
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) || hitCollisionsGroups.Contains( 'Water' ) || hitCollisionsGroups.Contains( 'Foliage' ) )
		{
			DealDamageProj();
		}
	}
	
	function DealDamageProj()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		var surface				: CGameplayFXSurfacePost;
		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), range, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictimProj( entities[i] );
		}
		StopProjectile();
		StopAllEffects();
		//PlayEffect('explode');
	}
	
	function DealDamageToVictimProj( victim : CGameplayEntity )
	{
		//var action 								: W3DamageAction;
		var damage_action 							: W3Action_Attack;
		var victimtarget						: CActor;
		var templatename 				: string;
		var targetpos		: Vector;
		var rotation		: EulerAngles;
		
		if ( !victim.HasTag('spells_custom_projs') )
		{
			victim.OnAardHit( NULL );
		}
		victimtarget = (CActor)victim;
		
		templatename = "dlc\magicspellsrev\data\entities\assassin_dodge.w2ent";
		
		if ( victimtarget && victimtarget != GetWitcherPlayer() && GetAttitudeBetween( victimtarget, GetWitcherPlayer() ) == AIA_Hostile && victimtarget.IsAlive() ) 
		{
			
		}
		victims.PushBack(victim);
	}
}

class W3BatSwarmAttack extends CProjectileTrajectory
{
	var damage 						: Float; 
	var effect						: CEntity;
	var victims						: array<CGameplayEntity>;
	var comp						: CMeshComponent;
	var range						: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{		
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		comp.SetScale( Vector ( 0.f, 0.f, 0.f ) );
		
		range = 3;
	}
	
	event OnProjectileInit()
	{

	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( IsStopped() )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;

		
		if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) || hitCollisionsGroups.Contains( 'Water' ) || hitCollisionsGroups.Contains( 'Foliage' ) )
		{
			DealDamageProj();
		}
	}
	
	function DealDamageProj()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		var surface				: CGameplayFXSurfacePost;
		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), range, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictimProj( entities[i] );
		}

		StopProjectile();

		StopAllEffects();

		PlayEffectSingle('venom');

		if (!this.HasTag('ACS_Transformation_Vampire_Monster_Gatling_Proj'))
		{
			PlayEffectSingle('venom_hit');
		}
	}
	
	function DealDamageToVictimProj( victim : CGameplayEntity )
	{
		var victimtarget								: CActor;
		var paramsKnockdown, paramsDrunkEffect 			: SCustomEffectParams;
		var action 										: W3DamageAction;
		var projDMG										: float;

		victimtarget = (CActor)victim;
		
		if ( victimtarget == GetWitcherPlayer() ) 
		{
			if(victimtarget.IsAlive()){victimtarget.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

			victimtarget.AddEffectDefault(EET_Stagger, victimtarget, 'console');

			victimtarget.DrainVitality((victimtarget.GetStat(BCS_Vitality) * 0.1) + 25);
			
			if (!this.HasTag('ACS_Transformation_Vampire_Monster_Gatling_Proj'))
			{
				PlayEffectSingle('venom_hit');
			}
		}
		else
		{
			action = new W3DamageAction in this;

			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);

			action.SetForceExplosionDismemberment();

			if (((CActor)victim).UsesVitality()) 
			{ 
				if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.25; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.25; 
				}
			} 
			else if (((CActor)victim).UsesEssence()) 
			{ 
				if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| ((CActor)victim).GetRadius() >= 0.7
				)
				{
					if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.125; 
					}
					else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.125; 
					}
				}
				else
				{
					if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.25; 
					}
					else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.25; 
					}
				}
			}

			if (this.HasTag('ACS_Transformation_Vampire_Monster_Gatling_Proj'))
			{
				action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, projDMG/8 );
			}
			else
			{
				action.AddEffectInfo( EET_Knockdown, 1.0 );
				action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, projDMG*2 );
			}

			action.SetCanPlayHitParticle(true);

			theGame.damageMgr.ProcessAction( action );

			delete action;

			if (!this.HasTag('ACS_Transformation_Vampire_Monster_Gatling_Proj'))
			{
				PlayEffectSingle('venom_hit');
			}
		}

		victims.PushBack(victim);
	}
}

class W3ACSEredinFrostLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
			
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);
			action.AddDamage(theGame.params.DAMAGE_NAME_FROST, damage );
			action.AddEffectInfo( EET_SlowdownFrost, 2.0 );
			action.SetCanPlayHitParticle(false);
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			/*
			if ( deactivateOnCollisionWithVictim )
			{
				isActive = false;
			}
			*/

			delete action;
		}
	}
}

class W3ACSFireLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_Undefined,false,true,false,false);
			action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, damage );		
			action.AddEffectInfo(EET_Burning, 1.0);
			action.SetCanPlayHitParticle(false);
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			/*
			if ( deactivateOnCollisionWithVictim )
			{
				isActive = false;
			}
			*/

			delete action;
		}
	}
}

class W3ACSViyBaseEffectFireLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim 
		&& !collidedEntities.Contains(victim) 
		&& victim != ACSGetCActor('ACS_Viy_Of_Maribor')
		)
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_Undefined,false,true,false,false);
			action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, damage );		
			action.AddEffectInfo(EET_Burning, 1.0);
			action.SetCanPlayHitParticle(false);
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			/*
			if ( deactivateOnCollisionWithVictim )
			{
				isActive = false;
			}
			*/

			delete action;
		}
	}
}

class W3ACSRockLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, damage );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			delete action;
		}
	}
}

class W3ACSGiantShockwave extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, damage );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			delete action;
		}
	}
}

class W3ACSSharleyShockwave extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, damage );	
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			delete action;
		}
	}
}

class W3ACSRootAttack extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		PlayEffect('ground_fx');
		AddTimer('effect', 0.3);
		AddTimer('attack', 0.4);
		AddTimer('stop_effect', 1.f);
	}

	timer function effect ( dt : float, optional id : int)
	{
		PlayEffect('attack_fx1');
	}

	timer function stop_effect ( dt : float, optional id : int)
	{
		StopEffect('ground_fx');
	}

	timer function attack ( dt : float, optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 5, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			deal_damage( (CActor)entities[i] );
		}
	}
	
	function deal_damage( victimtarget : CActor )
	{
		var action 			: W3DamageAction;
		var damage 			: float;
		
		if ( victimtarget && victimtarget.IsAlive() && victimtarget != GetWitcherPlayer() ) 
		{
			if (((CActor)victimtarget).UsesEssence())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victimtarget).UsesVitality())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Vitality ) * 0.125;
			}

			if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
			{
				damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
			}
			
			action = new W3DamageAction in theGame.damageMgr;
			action.Initialize(GetWitcherPlayer(),victimtarget,this,GetWitcherPlayer().GetName(),EHRT_Heavy,CPS_Undefined,false, false, true, false );
			action.SetProcessBuffsIfNoDamage(true);
			action.SetCanPlayHitParticle( true );
			
			action.AddEffectInfo( EET_Bleeding, 3 );

			action.AddEffectInfo( EET_LongStagger );

			action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
			
			theGame.damageMgr.ProcessAction( action );
			delete action;
		}
	}
}

class W3ACSBloodTentacles extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		if ( !theSound.SoundIsBankLoaded("mq_nml_1060.bnk") )
		{
			theSound.SoundLoadBank( "mq_nml_1060.bnk", false );
		}

		if (this.HasTag('ACS_Transformation_Red_Miasmal_Ability')
		|| this.HasTag('ACS_Transformation_Red_Miasmal_Ability_Small')
		)
		{
			PlayEffect('ground_fx_red');
		}

		PlayEffect('ground_fx');
		
		AddTimer('effect', 1.3);
		AddTimer('attack', 1.4);
		AddTimer('stop_effect', 2.f);
	}

	timer function effect ( dt : float, optional id : int)
	{
		PlayEffect('attack_fx1');
	}

	timer function stop_effect ( dt : float, optional id : int)
	{
		StopEffect('ground_fx');
		StopEffect('ground_fx_red');
	}

	timer function attack ( dt : float, optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;

		entities.Clear();

		if (this.HasTag('ACS_Transformation_Red_Miasmal_Ability')
		)
		{
			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() ),  0.3,  5,  2 ,  1,  1 );
			PlayEffect('attack_fx1_red');
		}
		
		if ( this.HasTag('ACS_Transformation_Red_Miasmal_Ability_Small')
		)
		{
			FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 2, 50 );
		}
		else
		{
			FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 4, 50 );
		}

		for( i = 0; i < entities.Size(); i += 1 )
		{
			deal_damage( (CActor)entities[i] );
		}
	}
	
	function deal_damage( victimtarget : CActor )
	{
		var action 			: W3DamageAction;
		var damage 			: float;

		if (this.HasTag('ACS_Necrosword_Ability'))
		{
			if ( victimtarget 
			&& victimtarget.IsAlive() 
			&& victimtarget != GetWitcherPlayer()
			&& victimtarget != ACSGetCActor('ACS_Summoned_Construct_1')
			&& victimtarget != ACSGetCActor('ACS_Summoned_Construct_2')
			) 
			{
				if (((CActor)victimtarget).UsesEssence())
				{
					damage = ((CActor)victimtarget).GetStatMax( BCS_Essence ) * 0.125;
				}
				else if (((CActor)victimtarget).UsesVitality())
				{
					damage = ((CActor)victimtarget).GetStatMax( BCS_Vitality ) * 0.125;
				}

				if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
				{
					damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
				}
				
				action = new W3DamageAction in theGame.damageMgr;
				action.Initialize(thePlayer, victimtarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				action.SetProcessBuffsIfNoDamage(true);
				action.SetCanPlayHitParticle( true );
				
				action.AddEffectInfo( EET_Bleeding, 3 );

				action.AddEffectInfo( EET_LongStagger );

				action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
				
				theGame.damageMgr.ProcessAction( action );
				delete action;
			}
		}
		else if (this.HasTag('ACS_Transformation_Red_Miasmal_Ability')
		|| this.HasTag('ACS_Transformation_Red_Miasmal_Ability_Small')
		)
		{
			if ( victimtarget 
			&& victimtarget.IsAlive() 
			&& victimtarget != GetWitcherPlayer()
			&& victimtarget != ACSGetCActor('ACS_Transformation_Red_Miasmal')
			) 
			{
				if (((CActor)victimtarget).UsesEssence())
				{
					damage = ((CActor)victimtarget).GetStatMax( BCS_Essence ) * 0.125;
				}
				else if (((CActor)victimtarget).UsesVitality())
				{
					damage = ((CActor)victimtarget).GetStatMax( BCS_Vitality ) * 0.125;
				}

				if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
				{
					damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
				}
				
				action = new W3DamageAction in theGame.damageMgr;

				action.Initialize(thePlayer, victimtarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				action.SetProcessBuffsIfNoDamage(true);
				action.SetCanPlayHitParticle( true );
				
				action.AddEffectInfo( EET_Poison, 3 );

				action.AddEffectInfo( EET_Bleeding, 3 );

				action.AddEffectInfo( EET_LongStagger );

				action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
				
				theGame.damageMgr.ProcessAction( action );
				delete action;
			}
		}
		else
		{
			if ( victimtarget && victimtarget.IsAlive() 
			&& victimtarget != ACSGetCEntity('ACS_Heart_Of_Darknness') 
			&& victimtarget != ACSGetCActor('ACS_Guardian_Blood_Hym_Small') 
			&& victimtarget != ACSGetCActor('ACS_Guardian_Blood_Hym_Large') 
			) 
			{
				if( VecDistance( ACSGetCEntity('ACS_Heart_Of_Darkness_Arena_Appearance_01').GetWorldPosition(), victimtarget.GetWorldPosition() ) > 15.0f )
				{
					if (((CActor)victimtarget).UsesEssence())
					{
						damage = ((CActor)victimtarget).GetStat( BCS_Essence ) * 0.06125;
					}
					else if (((CActor)victimtarget).UsesVitality())
					{
						damage = ((CActor)victimtarget).GetStat( BCS_Vitality ) * 0.06125;
					}
				}
				else
				{
					if (((CActor)victimtarget).UsesEssence())
					{
						damage = ((CActor)victimtarget).GetStatMax( BCS_Essence ) * 0.125;
					}
					else if (((CActor)victimtarget).UsesVitality())
					{
						damage = ((CActor)victimtarget).GetStatMax( BCS_Vitality ) * 0.125;
					}
				}

				if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
				{
					damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
				}
				
				action = new W3DamageAction in theGame.damageMgr;
				action.Initialize(ACSGetCGameplayEntity('ACS_Heart_Of_Darknness'),victimtarget,this,ACSGetCGameplayEntity('ACS_Heart_Of_Darknness').GetName(),EHRT_Heavy,CPS_Undefined,false, false, true, false );
				action.SetProcessBuffsIfNoDamage(true);
				action.SetCanPlayHitParticle( true );
				
				action.AddEffectInfo( EET_Bleeding, 3 );

				//action.AddEffectInfo( EET_LongStagger );

				action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
				
				theGame.damageMgr.ProcessAction( action );
				delete action;
			}
		}
	}
}

class W3WHMinionProjectile extends W3TraceGroundProjectile
{
	private var action : W3DamageAction;

	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{

		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_AttackPower,false,true,false,false);
			action.AddEffectInfo(EET_Knockdown);
			action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, 200.f );	

			if (victim == ACSGetCActor('ACS_Canaris'))
			{
				action.ClearDamage();
			}

			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);
			
			delete action;
		}
	}
}

class W3ACSEnemyKnifeProjectile extends W3AdvancedProjectile
{
	private var bone 									: name;
	private var actor, actortarget						: CActor;
	private var target									: CNewNPC;	
	private var i	 									: int;
	private var victims									: array<CGameplayEntity>;
	private var comp, meshComponent						: CMeshComponent;
	private var rot, bone_rot 							: EulerAngles;
	private var res, stopped 							: bool;
	private var attAction								: W3Action_Attack;
	private var arrowHitPos, arrowSize, bone_pos, pos	: Vector;
	private var boundingBox								: Box;
	private var rotMat									: Matrix;
	private var effType									: EEffectType;
	private var crit									: bool;
	private var damage									: float;
	private var action									: W3DamageAction;

	event OnSpawned( spawnData : SEntitySpawnData )
	{

	}
	
	event OnProjectileInit()
	{	
		comp = (CMeshComponent)this.GetComponentByClassName('CMeshComponent');
		rot = comp.GetLocalRotation();
		rot.Roll += 90;
		rot.Pitch -= RandRange(45, -45);
		rot.Yaw += 90;
		comp.SetRotation( rot );

		pos = comp.GetLocalPosition();
		pos.Y += 0.25;
		comp.SetPosition( pos );

		AddTimer('playredtrail', 0.0001, true);
	}

	timer function playredtrail( dt : float , optional id : int)
	{
		StopEffect('red_trail');
		PlayEffectSingle('red_trail');
	}
	
	timer function sword_destroy( dt : float , optional id : int)
	{
		RemoveTimers();
		PlayEffectSingle('disappear');
		DestroyAfter(0.4);
	}
	
	function DealDamageToTarget( victim : CGameplayEntity, eff : EEffectType, crit : bool )
	{
		actortarget = (CActor)victim;
		
		attAction = new W3Action_Attack in theGame.damageMgr;
		attAction.Init( ((CGameplayEntity)caster), victim, caster, ((CActor)caster).GetInventory().GetItemFromSlot( 'r_weapon' ), 
		theGame.params.ATTACK_NAME_LIGHT, caster.GetName(), EHRT_None, false, false, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
		attAction.SetHitReactionType(EHRT_Heavy);
		attAction.SetHitAnimationPlayType(EAHA_Default);
		
		attAction.SetSoundAttackType( 'wpn_slice' );
		
		theGame.damageMgr.ProcessAction( attAction );	
		
		delete attAction;
		
		collidedEntities.PushBack(victim);
	}
		
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		
		if( collidingComponent && !hitCollisionsGroups.Contains( 'Static' ) )
		{		
			if ( victim 
			&& !collidedEntities.Contains(victim) 
			&& victim.IsAlive() )
			{
				actor = (CActor)victim;
				
				collidedEntities.PushBack(victim);
				
				if ( hitCollisionsGroups.Contains( 'Ragdoll' ) )
				{
					bone = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetRagdollBoneName(actorIndex);
					
					if ((StrContains(StrLower(NameToString(bone)), "head" )))
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						DestroyAfter(0.4);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
					}
					else if ( ( 
						StrContains( StrLower( NameToString( bone ) ), "torso" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "neck" ) 
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_leg" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearm" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso2" )
						|| StrContains( StrLower( NameToString( bone ) ), "torso3" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine1" )
						|| StrContains( StrLower( NameToString( bone ) ), "spine2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2" )				
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky0_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb_roll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shin_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_toe_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_foot_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_kneeRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shin_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "hroll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "pelvis_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thigh_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "torso3_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "torso2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_forearmRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulder_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_shoulderRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_bicep_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_legRoll2_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "neck_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_elbowRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_forearmRoll2_ncl1_1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "hroll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "head_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb1_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_handRoll_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_hand_ncl1_1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle_knuckleRoll" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky0" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_ring2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_pinky2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "r_thumb_roll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_pinky_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index_knuckleRoll" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_thumb3" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_index1" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_middle2" )		
						|| StrContains( StrLower( NameToString( bone ) ), "l_ring1" )	
						|| StrContains( StrLower( NameToString( bone ) ), "l_hand" )		
						) )
					
					{
						arrowHitPos = pos;
						arrowHitPos -= RotForward(  this.GetWorldRotation() ) * 0.5f; 
						
						stopped = true;
						StopProjectile();
						DestroyAfter(0.4);
					
						res = this.CreateAttachmentAtBoneWS(actor, bone, arrowHitPos, this.GetWorldRotation());
						
						effType = EET_LongStagger;
						
						crit = false;
					}
					else
					{
						crit = false;
					}
				}
				
				DealDamageToTarget( victim, effType, crit );

				RemoveTimer('redtrail');
			}
		}
		else
		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) 
		|| hitCollisionsGroups.Contains( 'Water' )
		) 
		&& !stopped )
		{
			StopProjectile();
			DestroyAfter(0.4);
			
			this.SoundEvent("cmb_arrow_impact_dirt");

			CreateKnife();

			RemoveTimer('redtrail');
			
			arrowHitPos = pos;
			meshComponent = (CMeshComponent)GetComponentByClassName('CMeshComponent');
			if( meshComponent )
			{
				boundingBox = meshComponent.GetBoundingBox();
				arrowSize = boundingBox.Max - boundingBox.Min;
			}
			Teleport( arrowHitPos );
			
			res = true;
		}	
		else 
		{
			return false;
		}
	}

	function CreateKnife()
	{
		var knife_temp							: CEntityTemplate;
		var knife 								: CEntity;

		knife_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_knife_loot_old.w2ent", true );

		knife = (CEntity)theGame.CreateEntity( knife_temp, this.GetWorldPosition() );

		((W3AnimatedContainer)(knife)).GetInventory().AddAnItem( 'ACS_Knife' , 1 );
	}

	/*
	function CreateKnife()
	{
		var knife_temp							: CEntityTemplate;
		var knife 								: CEntity;
		var droppeditemID 						: SItemUniqueId;

		knife_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_guiding_light.w2ent", true );

		knife = (CEntity)theGame.CreateEntity( knife_temp, this.GetWorldPosition() );

		((CNewNPC)knife).EnableCharacterCollisions(false);
		((CNewNPC)knife).EnableCollisions(false);

		((CActor)knife).AddBuffImmunity_AllNegative('ACS_Knife_Entity', true);

		((CActor)knife).AddBuffImmunity_AllCritical('ACS_Knife_Entity', true);

		((CActor)knife).SetUnpushableTarget(thePlayer);

		((CActor)knife).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		((CActor)knife).SetCanPlayHitAnim(false); 

		((CNewNPC)knife).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CActor)(knife)).GetInventory().RemoveAllItems();

		((CActor)(knife)).GetInventory().AddAnItem( 'ACS_Knife' , 1 );

		droppeditemID = ((CActor)(knife)).GetInventory().GetItemId('ACS_Knife');

		((CActor)(knife)).GetInventory().DropItemInBag(droppeditemID, 1);

		knife.DestroyAfter(0.5);
	}
	*/
}

class W3ACSBearFireball extends W3AdvancedProjectile
{
	editable var initFxName 			: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityTemplate 	: CEntityTemplate;
	editable var decreasePlayerDmgBy	: float; default decreasePlayerDmgBy = 0.f;

	private var projectileHitGround : bool;
	
	default projDMG = 200.f;
	default projEfect = EET_Burning;

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}

		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		/*
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) && victim != ACSGetCActor('ACS_Fire_Bear') )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
		*/

		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) && victim != ACSGetCActor('ACS_Fire_Bear') )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}

	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		DealDamageToVictim(victim);
		DeactivateProjectile(victim);
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_Undefined,false,true,false,false);
		
		if ( victim == GetWitcherPlayer() )
		{
			projDMG = projDMG - (projDMG * decreasePlayerDmgBy);
		}
		else if ( victim == ACSGetCActor('ACS_Fire_Bear') )
		{
			projDMG = 0;
		}
	
		action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, projDMG );
		action.AddEffectInfo(EET_Burning, 2.0);
		action.AddEffectInfo(EET_HeavyKnockdown, 2);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity )
	{
		if ( victim == GetWitcherPlayer() && GetWitcherPlayer().GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)GetWitcherPlayer()).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity )
	{
		isActive = false;
		this.StopEffect(initFxName);
		this.DestroyAfter(0.25);
		PlayCollisionEffect ( victim );
	}
	
	protected function ProjectileHitGround()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var actorsAround	 	: array<CActor>;
		var i					: int;
		
		if ( spawnEntityTemplate )
		{
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				projectileHitGround = true;
			}
		}
		
		else
		{
			actorsAround = GetActorsInRange( this, 2, , , true );
			for( i = 0; i < actorsAround.Size(); i += 1 )
			{
				DealDamageToVictim( actorsAround[i] );
			}
		}
		DeactivateProjectile();

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( this.GetWorldPosition() ), 1.f, 60, 2.f, 30.f, 1);
	}
	
	event OnRangeReached()
	{
		this.DestroyAfter(2.f);
	}
	
	function SetProjectileHitGround( b : bool )
	{
		projectileHitGround = b;
	}
}

class W3BearSummonMeteorProjectile extends W3ACSBearFireball
{
	editable var explosionRadius 		: float;
	editable var markerEntityTemplate	: CEntityTemplate;
	editable var destroyMarkerAfter		: float;

	var markerEntity 			: CEntity;
	
	default projSpeed = 10;
	default projAngle = 0;
	
	default explosionRadius = 2;
	default destroyMarkerAfter = 2.f;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var createEntityHelper 												: W3BearSummonMeteorProjectile_CreateMarkerEntityHelper;
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	
		//super.OnProjectileShot(targetCurrentPosition, target);
		
		//createEntityHelper = new W3BearSummonMeteorProjectile_CreateMarkerEntityHelper in theGame;
		//createEntityHelper.owner = this;
		//createEntityHelper.SetPostAttachedCallback( createEntityHelper, 'OnEntityCreated' );

		//theGame.CreateEntityAsync( createEntityHelper, markerEntityTemplate, ACSPlayerFixZAxis(targetCurrentPosition), EulerAngles(0,0,0) );

		if (ACSGetCActor('ACS_Fire_Bear'))
		{
			if (ACSGetCActor('ACS_Fire_Bear').IsAlive())
			{
				AddTimer('firebearteleport', 0.000001, true);

				//AddTimer('meteortrackingdelay', 1.75, false);
			}
		}

		AddTimer('meteortrackingdelay', 1.75, false);
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity)
	{
		if ( !isActive )
			return;
		
		Explode();
		
		
		if ( markerEntity )
		{
			markerEntity.StopAllEffects();
			markerEntity.DestroyAfter( destroyMarkerAfter );
		}
		
		super.DeactivateProjectile(victim);

		RemoveTimer('meteortracking');
	}
	
	protected function Explode()
	{
		var entities 														: array<CGameplayEntity>;
		var i																: int;
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 

		RemoveTimer('meteortracking');
		
		FindGameplayEntitiesInCylinder( entities, this.GetWorldPosition(), explosionRadius, 2.f, 99 ,'',FLAG_ExcludeTarget, this );
		
		for( i = 0; i < entities.Size(); i += 1 )
		{
			if ( !collidedEntities.Contains(entities[i]) )
			{
				DealDamageToVictim(entities[i]);
			}
		}
		
		GCameraShake( 3, 5, GetWorldPosition() );

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( this.GetWorldPosition() ), 1.f, 60, 2.f, 30.f, 1);

		if (ACSGetCActor('ACS_Fire_Bear'))
		{
			if (ACSGetCActor('ACS_Fire_Bear').IsAlive())
			{
				RemoveTimer('firebearteleport');

				ACSGetCActor('ACS_Fire_Bear').EnableCharacterCollisions(true); 

				ACSGetCActor('ACS_Fire_Bear').EnableCollisions(true);

				//ACSGetCActor('ACS_Fire_Bear').TeleportWithRotation( this.GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

				ACSGetCActor('ACS_Fire_Bear').SetVisibility(true);

				animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSGetCActor('ACS_Fire_Bear')).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.UnfreezePose();

				movementAdjustorNPC = ACSGetCActor('ACS_Fire_Bear').GetMovingAgentComponent().GetMovementAdjustor();

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Spawn_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Spawn_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Spawn_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				animatedComponentA.PlaySlotAnimationAsync ( 'bear_special_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				ACSGetCActor('ACS_Fire_Bear').PlayEffect('burning_body');
				ACSGetCActor('ACS_Fire_Bear').PlayEffect('flames');
				ACSGetCActor('ACS_Fire_Bear').PlayEffect('critical_burning');
				ACSGetCActor('ACS_Fire_Bear').PlayEffect('demonic_possession');

				ACSGetCActor('ACS_Fire_Bear').AddEffectDefault( EET_FireAura, ACSGetCActor('ACS_Fire_Bear'), 'acs_fire_bear_fire_aura' );

				((CNewNPC)ACSGetCActor('ACS_Fire_Bear')).NoticeActor(GetWitcherPlayer());

				((CActor)ACSGetCActor('ACS_Fire_Bear')).ActionMoveToNodeWithHeadingAsync(GetWitcherPlayer());

				GetACSWatcher().SetFireBearMeteorProcess(false);

				if (ACSGetCActor('ACS_Fire_Bear').GetStat(BCS_Essence) <= ACSGetCActor('ACS_Fire_Bear').GetStatMax(BCS_Essence)/2)
				{
					GetACSWatcher().RemoveTimer('DropBearMeteorStart');
					GetACSWatcher().AddTimer('DropBearMeteorStart', 15, true);
				}
				else
				{
					GetACSWatcher().RemoveTimer('DropBearMeteorStart');
					GetACSWatcher().AddTimer('DropBearMeteorStart', RandRangeF(30,15), true);
				}

				//SpawnStonePillarCircle_3();
			}
			else
			{
				acsfirebearspawntemp();

				SpawnStonePillarCircle_1();

				SpawnStonePillarCircle_2();

				GetACSWatcher().RemoveTimer('DropBearMeteorStart');
				GetACSWatcher().AddTimer('DropBearMeteorStart', RandRangeF(30,15), true);
			}
		}
		else
		{
			acsfirebearspawntemp();

			SpawnStonePillarCircle_1();

			SpawnStonePillarCircle_2();

			GetACSWatcher().RemoveTimer('DropBearMeteorStart');
			GetACSWatcher().AddTimer('DropBearMeteorStart', RandRangeF(30,15), true);
		}
	}
	
	protected function acsfirebearspawntemp()
	{
		var temp, temp_2, ent_1_temp, blade_temp							: CEntityTemplate;
		var ent, ent_2, ent_1, r_anchor, l_anchor, r_blade1, l_blade1		: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot										: EulerAngles;
		var playerRot														: EulerAngles;
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 

		ACSGetCActor('ACS_Fire_Bear').Destroy();

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\entities\monsters\fire_bear.w2ent"
		
		, true );

		playerRot = EulerAngles(0,0,0);

		playerRot.Roll = 0;
		playerRot.Pitch = 0;
		playerRot.Yaw = 180;
		
		ent = theGame.CreateEntity( temp, this.GetWorldPosition(), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).NoticeActor(GetWitcherPlayer());

		((CActor)ent).ActionMoveToNodeWithHeadingAsync(GetWitcherPlayer());

		//ent.PlayEffect('ice');

		//ent.PlayEffectSingle('appear');
		//ent.StopEffect('appear');
		//ent.PlayEffectSingle('shadow_form');
		//ent.PlayEffectSingle('demonic_possession');

		//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
		//((CActor)ent).AddAbility( 'EtherealActive' );

		//((CActor)ent).RemoveBuffImmunity( EET_Stagger );
		//((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

		ent.PlayEffect('burning_body');
		ent.PlayEffect('flames');
		ent.PlayEffect('critical_burning');
		ent.PlayEffect('demonic_possession');

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel() + 10);

		((CActor)ent).AddEffectDefault( EET_FireAura, ((CActor)ent), 'acs_fire_bear_fire_aura' );

		((CActor)ent).AddEffectDefault( EET_AutoEssenceRegen, ((CActor)ent), 'acs_fire_bear_essence_regen_buff' );

		((CActor)ent).AddEffectDefault( EET_AutoMoraleRegen, ((CActor)ent), 'acs_fire_bear_morale_regen_buff' );

		((CActor)ent).AddEffectDefault( EET_AutoStaminaRegen, ((CActor)ent), 'acs_fire_bear_stamina_regen_buff' );

		((CActor)ent).AddEffectDefault( EET_AutoPanicRegen, ((CActor)ent), 'acs_fire_bear_panic_regen_buff' );

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

		((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

		//((CActor)ent).AddBuffImmunity	( EET_Stagger,				'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_LongStagger,			'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_Knockdown,			'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_Ragdoll,				'acs_fire_bear_buff', false);
		//((CActor)ent).AddBuffImmunity	( EET_HeavyKnockdown,		'acs_fire_bear_buff', false);
		((CActor)ent).AddBuffImmunity	( EET_Burning,				'acs_fire_bear_buff', false);
		((CActor)ent).AddBuffImmunity	( EET_Frozen,				'acs_fire_bear_buff', false);
		((CActor)ent).AddBuffImmunity	( EET_SlowdownFrost,		'acs_fire_bear_buff', false);

		ent.AddTag( 'ACS_Fire_Bear' );
		ent.AddTag( 'ACS_Big_Boi' );
		ent.AddTag( 'ContractTarget' );
		ent.AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		movementAdjustorNPC = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Spawn_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Spawn_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Spawn_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

		animatedComponentA = (CAnimatedComponent)((CNewNPC)ent).GetComponentByClassName( 'CAnimatedComponent' );	

		animatedComponentA.PlaySlotAnimationAsync ( 'bear_taunt02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1));
	}
	
	protected function ProjectileHitGround()
	{
		var entities 		: array<CGameplayEntity>;
		var i				: int;
		var landPos			: Vector;
		
		landPos = this.GetWorldPosition();

		entities.Clear();
		
		FindGameplayEntitiesInSphere( entities, this.GetWorldPosition(), 4, 10, '', FLAG_ExcludeTarget, this );
		
		for( i = 0; i < entities.Size(); i += 1 )
		{
			entities[i].ApplyAppearance( "hole" );			
			if( theGame.GetWorld().GetWaterLevel( landPos ) > landPos.Z )
			{
				entities[i].StopEffect('explosion_water');	
				entities[i].PlayEffect('explosion_water');			
			}
			else
			{
				entities[i].StopEffect('explosion');
				entities[i].PlayEffect('explosion');
			}
		}
		
		super.ProjectileHitGround();
	}

	function SpawnStonePillarCircle_1()
	{
		var temp															: CEntityTemplate;
		var ent																: W3ACSStonePillar;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var targetRotationNPC												: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\elemental_dao_pillar_arena.w2ent"
		
		, true );

		playerPos = this.GetWorldPosition();

		playerPos = ACSPlayerFixZAxis(playerPos);
		
		count = 50;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 10 + 10 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			targetRotationNPC = EulerAngles(0,0,0);
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			ent = (W3ACSStonePillar)theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), targetRotationNPC );

			ent.DestroyAfter(30.5);

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( spawnPos ), 1.f, 60, 2.f, 5.f, 1);
		}
	}

	function SpawnStonePillarCircle_2()
	{
		var temp															: CEntityTemplate;
		var ent																: W3ACSStonePillar;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var targetRotationNPC												: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\elemental_dao_pillar_arena.w2ent"
		
		, true );

		playerPos = this.GetWorldPosition();

		playerPos = ACSPlayerFixZAxis(playerPos);
		
		count = 25;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 7.5 + 7.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			targetRotationNPC = EulerAngles(0,0,0);
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			ent = (W3ACSStonePillar)theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), targetRotationNPC );

			ent.DestroyAfter(30.5);

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( spawnPos ), 1.f, 60, 2.f, 5.f, 1);
		}
	}

	function SpawnStonePillarCircle_3()
	{
		var temp															: CEntityTemplate;
		var ent																: W3ACSStonePillar;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var targetRotationNPC												: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\elemental_dao_pillar_arena.w2ent"
		
		, true );

		playerPos = this.GetWorldPosition();

		playerPos = ACSPlayerFixZAxis(playerPos);
		
		count = 25;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 10 + 10 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			targetRotationNPC = EulerAngles(0,0,0);
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			ent = (W3ACSStonePillar)theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), targetRotationNPC );

			ent.DestroyAfter(30.5);

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( spawnPos ), 1.f, 60, 2.f, 5.f, 1);
		}
	}

	timer function firebearteleport( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = this.GetWorldPosition();

		pos.Z += 0.5;

		pos.Y -= 2;

		ACSGetCActor('ACS_Fire_Bear').TeleportWithRotation(pos, ACSGetCActor('ACS_Fire_Bear').GetWorldRotation());
	}

	timer function meteortracking( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z -= 1;

		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			this.ShootProjectileAtPosition(projAngle,projSpeed*0.75,pos);
		}
	}

	timer function meteortrackingdelay( deltaTime : float , id : int)
	{
		AddTimer('meteortracking', 0.25, true);
	}
	
	event OnProjectileShot( targetCurrentPosition : Vector, optional target : CNode )
	{
		var createEntityHelper 												: W3BearSummonMeteorProjectile_CreateMarkerEntityHelper;
	
		super.OnProjectileShot(targetCurrentPosition, target);
		
		createEntityHelper = new W3BearSummonMeteorProjectile_CreateMarkerEntityHelper in theGame;
		createEntityHelper.owner = this;
		createEntityHelper.SetPostAttachedCallback( createEntityHelper, 'OnEntityCreated' );

		theGame.CreateEntityAsync( createEntityHelper, markerEntityTemplate, ACSPlayerFixZAxis(targetCurrentPosition), EulerAngles(0,0,0) );
	}
}

class W3BearSummonMeteorProjectile_CreateMarkerEntityHelper extends CCreateEntityHelper
{
	var owner : W3BearSummonMeteorProjectile;
	
	event OnEntityCreated( entity : CEntity )
	{
		/*
		if ( owner )
		{
			owner.markerEntity = entity;
			theGame.GetBehTreeReactionManager().CreateReactionEvent( owner, 'MeteorMarker', owner.destroyMarkerAfter, owner.explosionRadius, 0.1f, 999, true );
			owner = NULL;
		}
		else
		{
			entity.StopAllEffects();
			entity.DestroyAfter(2.f);
		}
		*/
		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			entity.DestroyAfter(5);
		}
		else
		{
			entity.Destroy();
		}
	}
}

class W3BearDespawnMeteorProjectile extends W3ACSBearFireball
{	
	default projSpeed = 10;
	default projAngle = 0;

	private saved var angleIncrement	: int;

	default angleIncrement = 0;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var animatedComponentA												: CAnimatedComponent;
		var movementAdjustorNPC												: CMovementAdjustor; 
		var ticketNPC 														: SMovementAdjustmentRequestTicket; 

		var pos																: Vector;
	
		//super.OnProjectileShot(targetCurrentPosition, target);

		if (ACSGetCActor('ACS_Fire_Bear').IsAlive())
		{
			//pos = GetWitcherPlayer().GetWorldPosition();

			//pos.Z += 150;

			//ACSGetCActor('ACS_Fire_Bear').TeleportWithRotation(pos, GetWitcherPlayer().GetWorldRotation());

			AddTimer('firebearteleport', 0.000001, true);

			//AddTimer('firebearinvis', 1.5, false);

			GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');

			ACSGetCActor('ACS_Fire_Bear').StopAllEffects();

			ACSGetCActor('ACS_Fire_Bear').RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');

			ACSGetCActor('ACS_Fire_Bear').SetVisibility(false);

			animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSGetCActor('ACS_Fire_Bear')).GetComponentByClassName( 'CAnimatedComponent' );

			animatedComponentA.FreezePose();

			AddTimer('meteortrackingdelay', 1, false);
		}
	}

	timer function firebearteleport( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = this.GetWorldPosition();

		pos.Z += 3;

		//ACSGetCActor('ACS_Fire_Bear').TeleportWithRotation(pos, ACSGetCActor('ACS_Fire_Bear').GetWorldRotation());

		ACSGetCActor('ACS_Fire_Bear').Teleport(pos);
	}

	timer function firebearinvis( deltaTime : float , id : int)
	{
		ACSGetCActor('ACS_Fire_Bear').SetVisibility(false);

		ACSGetCActor('ACS_Fire_Bear').StopAllEffects();

		ACSGetCActor('ACS_Fire_Bear').RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');
	}

	timer function meteortracking_first( deltaTime : float , id : int)
	{
		var pos 															: Vector;

		pos = ACSGetCActor('ACS_Fire_Bear').GetHeadingVector() + ACSGetCActor('ACS_Fire_Bear').GetWorldForward() * -100;

		pos.Z += 200;

		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			this.ShootProjectileAtPosition(projAngle,projSpeed,pos);
		}
	}

	timer function meteortracking_second( deltaTime : float , id : int)
	{
		var pos 															: Vector;

		pos = ACSGetCActor('ACS_Fire_Bear').GetHeadingVector() + ACSGetCActor('ACS_Fire_Bear').GetWorldForward() * 200;

		pos.Z += 100;

		if(GetWitcherPlayer().IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		)
		{
			this.ShootProjectileAtPosition(projAngle,projSpeed,pos);
		}
	}

	timer function meteortrackingswitch( deltaTime : float , id : int)
	{
		RemoveTimer('meteortracking_first');

		AddTimer('meteortracking_second', 0.0001, true);
	}

	timer function meteortrackingdelay( deltaTime : float , id : int)
	{
		AddTimer('meteortracking_first', 0.0001, true);

		AddTimer('meteortrackingswitch', 1.5, false);
	}
	
	event OnProjectileShot( targetCurrentPosition : Vector, optional target : CNode )
	{
		//AddTimer('meteortrackingdelay', 1, false);
	}

	event OnDestroyed()
	{
		RemoveTimer('meteortracking_second');
		RemoveTimer('firebearteleport');
	}
}

class W3ACSStonePillar extends W3DurationObstacle
{
	private editable var 		damageValue 			: float; 		default damageValue = 100;
	
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		super.OnSpawned( spawnData );
		
		AddTimer( 'Appear', 0.5f );
	}
	
	
	private timer function Appear( _Delta : float, optional id : int)
	{
		var i						: int;
		var l_entitiesInRange		: array <CGameplayEntity>;
		var l_range					: float;
		var l_actor					: CActor;
		var none					: SAbilityAttributeValue;
		var l_damage				: W3DamageAction;
		var l_summonedEntityComp 	: W3SummonedEntityComponent;
		var	l_summoner				: CActor;	
		
		l_summonedEntityComp = (W3SummonedEntityComponent) GetComponentByClassName('W3SummonedEntityComponent');
		
		if( !l_summonedEntityComp )
		{
			return;
		}
		
		l_summoner = l_summonedEntityComp.GetSummoner();
		
		l_range = 1;
		
		PlayEffect('circle_stone');

		l_entitiesInRange.Clear();
		
		FindGameplayEntitiesInRange( l_entitiesInRange, this, l_range, 1000);
		
		for	( i = 0; i < l_entitiesInRange.Size(); i += 1 )
		{
			l_actor = (CActor) l_entitiesInRange[i];
			if( !l_actor ) continue;
			
			if ( l_actor == ACSGetCActor('ACS_Fire_Bear') ) continue;
			
			//l_damage = new W3DamageAction in this;
			//l_damage.Initialize( l_summoner, l_actor, l_summoner, l_summoner.GetName(), EHRT_Heavy, CPS_Undefined, false, false, false, true );
			//l_damage.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageValue );
			//l_damage.AddEffectInfo( EET_KnockdownTypeApplicator, 1);
			//theGame.damageMgr.ProcessAction( l_damage );
			//delete l_damage;
		}
	}
}

class W3ACSRedPlagueProjectile extends W3ACSLeshyRootProjectile
{
	default projExpired = false;
	default collisions = 0;
	
	var surface : CGameplayFXSurfacePost;
	
	private var damageAction 			: W3DamageAction;
	
	event OnSpawned(spawnData : SEntitySpawnData)
	{
		surface = theGame.GetSurfacePostFX();
	
		super.OnSpawned(spawnData);
		AddTimer('SurfacePostFXTimer', 0.01f, true);
	}	

	timer function SurfacePostFXTimer( deltaTime : float, id : int )
	{
		var z : float;
		var position : Vector;
		
		position = this.GetWorldPosition();
		theGame.GetWorld().NavigationComputeZ( position, -5.0, 5.0, z );
		position.Z = z + 0.3;
		this.Teleport(position);
	
		surface.AddSurfacePostFXGroup(this.GetWorldPosition(),  0.3,  5,  2 ,  1,  1 );	
		this.PlayEffect('line_fx');
	}

	function SetOwner( actor : CActor )
	{
		owner = actor;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		var victim 			: CGameplayEntity;
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		if ( victim && victim == ((CActor)caster).GetTarget() )
		{
			collisions += 1;
			
			if ( collisions == 1 )
			{
				this.StopEffect( 'ground_fx' );
				projPos = this.GetWorldPosition();
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				projRot = this.GetWorldRotation();
				fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
				fxEntity.PlayEffect( 'attack_fx1', fxEntity );
				fxEntity.DestroyAfter( 10.0 );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
				DelayDamage( 0.01 );
				AddTimer('TimeDestroyNew', 5.0, false);
				projExpired = true;

				surface.AddSurfacePostFXGroup(fxEntity.GetWorldPosition(),  0.3,  5,  2 ,  2,  1 );
			}
		}
		RemoveTimer('SurfacePostFXTimer');
		
		delete damageAction;
	}
	
	function DelayDamage( time : float )
	{
		AddTimer('DelayDamageTimerNew',time,false);
	}
	
	timer function DelayDamageTimerNew( delta : float , id : int)
	{
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		rootDmg = MaxF( RandRangeF(300,200) , CalculateAttributeValue(((CActor)caster).GetAttributeValue(attributeName)) + 200.0  );
		
		damageAction = new W3DamageAction in this;
		damageAction.SetHitAnimationPlayType(EAHA_ForceYes);
		damageAction.attacker = owner;

		victims.Clear();
		
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					damageAction.Initialize( (CGameplayEntity)caster, victims[i], this, caster.GetName()+"_"+"root_projectile", EHRT_Light, CPS_AttackPower, false, true, false, false);
					damageAction.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, rootDmg );
					theGame.damageMgr.ProcessAction( damageAction );
					victims[i].OnRootHit();
				}
			}
		}
		
		delete damageAction;
	}
	
	event OnRangeReached()
	{
		var normal : Vector;
		
		StopAllEffects();
		StopProjectile();
		
		if( !projExpired )
		{
			projExpired = true;
			projPos = this.GetWorldPosition();
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			projRot = this.GetWorldRotation();
			fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
			fxEntity.PlayEffect( 'attack_fx1', fxEntity );
			GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
			DelayDamage( 0.3 );
			fxEntity.DestroyAfter( 10.0 );
			AddTimer('TimeDestroyNew', 5.0, false);

			surface.AddSurfacePostFXGroup(fxEntity.GetWorldPosition(),  0.3,  5,  2 ,  2,  1 );	
		}
		RemoveTimer('SurfacePostFXTimer');
	}
	
	function Expired() : bool
	{
		return projExpired;
	}
	
	timer function TimeDestroyNew( deltaTime : float, id : int )
	{
		Destroy();
	}
}

class W3ACSTransformationRedMiasmalRedPlagueProjectile extends W3ACSLeshyRootProjectile
{
	
	default projExpired = false;
	default collisions = 0;
	
	var surface : CGameplayFXSurfacePost;
	
	private var damageAction 			: W3DamageAction;
	
	event OnSpawned(spawnData : SEntitySpawnData)
	{
		surface = theGame.GetSurfacePostFX();
	
		super.OnSpawned(spawnData);
		AddTimer('SurfacePostFXTimer', 0.01f, true);
	}	

	timer function SurfacePostFXTimer( deltaTime : float, id : int )
	{
		var z : float;
		var position : Vector;
		
		position = this.GetWorldPosition();
		theGame.GetWorld().NavigationComputeZ( position, -5.0, 5.0, z );
		position.Z = z + 0.3;
		this.Teleport(position);
	
		surface.AddSurfacePostFXGroup(this.GetWorldPosition(),  0.3,  5,  2 ,  1,  1 );	
		this.PlayEffect('line_fx');
	}

	function SetOwner( actor : CActor )
	{
		owner = actor;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		var victim 			: CGameplayEntity;
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		if ( victim && victim == ((CActor)caster).GetTarget() )
		{
			collisions += 1;
			
			if ( collisions == 1 )
			{
				this.StopEffect( 'ground_fx' );
				projPos = this.GetWorldPosition();
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				projRot = this.GetWorldRotation();
				fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
				fxEntity.PlayEffect( 'attack_fx1', fxEntity );
				fxEntity.DestroyAfter( 10.0 );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
				DelayDamage( 0.01 );
				AddTimer('TimeDestroyNew', 5.0, false);
				projExpired = true;

				surface.AddSurfacePostFXGroup(fxEntity.GetWorldPosition(),  0.3,  5,  2 ,  2,  1 );
			}
		}
		RemoveTimer('SurfacePostFXTimer');
		
		delete damageAction;
	}
	
	function DelayDamage( time : float )
	{
		AddTimer('DelayDamageTimerNew',time,false);
	}
	
	timer function DelayDamageTimerNew( delta : float , id : int)
	{
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		rootDmg = MaxF( RandRangeF(300,200) , CalculateAttributeValue(((CActor)caster).GetAttributeValue(attributeName)) + 200.0  );
		
		damageAction = new W3DamageAction in this;
		damageAction.SetHitAnimationPlayType(EAHA_ForceYes);
		damageAction.attacker = owner;
		
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					damageAction.Initialize( (CGameplayEntity)caster, victims[i], this, caster.GetName()+"_"+"root_projectile", EHRT_Light, CPS_AttackPower, false, true, false, false);
					damageAction.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, rootDmg );
					theGame.damageMgr.ProcessAction( damageAction );
					victims[i].OnRootHit();
				}
			}
		}
		
		delete damageAction;
	}
	
	event OnRangeReached()
	{
		var normal : Vector;
		
		StopAllEffects();
		StopProjectile();
		
		if( !projExpired )
		{
			projExpired = true;
			projPos = this.GetWorldPosition();
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			projRot = this.GetWorldRotation();
			fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
			fxEntity.PlayEffect( 'attack_fx1', fxEntity );
			GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
			DelayDamage( 0.3 );
			fxEntity.DestroyAfter( 10.0 );
			AddTimer('TimeDestroyNew', 5.0, false);

			surface.AddSurfacePostFXGroup(fxEntity.GetWorldPosition(),  0.3,  5,  2 ,  2,  1 );	
		}
		RemoveTimer('SurfacePostFXTimer');
	}
	
	function Expired() : bool
	{
		return projExpired;
	}
	
	timer function TimeDestroyNew( deltaTime : float, id : int )
	{
		Destroy();
	}
}

class W3ACSLeshyRootProjectile extends CProjectileTrajectory
{
	editable var fxEntityTemplate 	: CEntityTemplate;
	protected var fxEntity 			: CEntity;
	
	
	private var action 				: W3Action_Attack;
	
	protected var owner 				: CActor;
	protected var projPos 			: Vector;
	protected var projRot 			: EulerAngles;
	protected var projExpired 		: bool;
	var collisions 					: int;
	
	default projExpired = false;
	default collisions = 0;
	
	function SetOwner( actor : CActor )
	{
		owner = actor;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{	
		var victim 			: CGameplayEntity;
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		if ( victim && victim == ((CActor)caster).GetTarget() )
		{
			collisions += 1;
			
			if ( collisions == 1 )
			{
				this.StopEffect( 'ground_fx' );
				projPos = this.GetWorldPosition();
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				projRot = this.GetWorldRotation();
				fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
				fxEntity.PlayEffect( 'attack_fx1', fxEntity );
				fxEntity.DestroyAfter( 10.0 );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
				DelayDamage( 0.3 );
				AddTimer('TimeDestroy', 5.0, false);
				projExpired = true;
			}
		}
		delete action;
	}
	
	function DelayDamage( time : float )
	{
		AddTimer('DelayDamageTimer',time,false);
	}
	
	timer function DelayDamageTimer( delta : float , id : int)
	{
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		rootDmg = CalculateAttributeValue(((CActor)caster).GetAttributeValue(attributeName));
		
		
		action = new W3Action_Attack in theGame.damageMgr;

		victims.Clear();
		
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					
					action.Init( (CGameplayEntity)caster, victims[i], NULL, ((CGameplayEntity)caster).GetInventory().GetItemFromSlot( 'r_weapon' ), 'attack_heavy', ((CGameplayEntity)caster).GetName(), EHRT_Heavy, false, true, 'attack_heavy', AST_Jab, ASD_DownUp, false, false, false, true );
					theGame.damageMgr.ProcessAction( action );
					
					
					victims[i].OnRootHit();
				}
			}
		}
		
		delete action;
	}
	
	event OnRangeReached()
	{
		var normal : Vector;
		
		StopAllEffects();
		StopProjectile();
		
		if( !projExpired )
		{
			projExpired = true;
			projPos = this.GetWorldPosition();
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			projRot = this.GetWorldRotation();
			fxEntity = theGame.CreateEntity( fxEntityTemplate, projPos, projRot );
			fxEntity.PlayEffect( 'attack_fx1', fxEntity );
			GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
			DelayDamage( 0.3 );
			fxEntity.DestroyAfter( 10.0 );
			AddTimer('TimeDestroy', 5.0, false);
		}
	}
	
	function Expired() : bool
	{
		return projExpired;
	}
	
	timer function TimeDestroy( deltaTime : float, id : int )
	{
		Destroy();
	}
}

class W3ACSArmorPhysxProjectile extends W3AardProjectile
{
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		var projectileVictim : CProjectileTrajectory;
		
		projectileVictim = (CProjectileTrajectory)collidingComponent.GetEntity();
		
		if( projectileVictim )
		{
			projectileVictim.OnAardHit( this );
		}
		
		super.OnProjectileCollision( pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex );
	}
	
	protected function ProcessCollision( collider : CGameplayEntity, pos, normal : Vector )
	{
		var dmgVal : float;
		var sp : SAbilityAttributeValue;
		var isMutation6 : bool;
		var victimNPC : CNewNPC;
	
		
		if ( hitEntities.FindFirst( collider ) != -1 )
		{
			return;
		}
		
		hitEntities.PushBack( collider );
	
		super.ProcessCollision( collider, pos, normal );
		
		victimNPC = (CNewNPC) collider;
		
		
		theGame.damageMgr.ProcessAction( action );
		
		collider.OnAardHit( this );
		
	}
	
	event OnAttackRangeHit( entity : CGameplayEntity )
	{
		entity.OnAardHit( this );
	}
}

statemachine class CACSCanarisMeteoriteStormEntity extends CGameplayEntity
{		
	editable var resourceName : name;
	editable var timeBetweenSpawn : float;
	editable var minDistFromTarget : float;
	editable var maxDistFromTarget : float;
	editable var minDistFromEachOther : float;
	
	var victim : CActor;
	var entityTemplate : CEntityTemplate;
	
	default timeBetweenSpawn = 1;
	default minDistFromTarget = 1.5;
	default maxDistFromTarget = 8.0;
	default minDistFromEachOther = 3;
	
	default autoState = 'Idle';
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		entityTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_meteorite.w2ent", true );
		GotoStateAuto();
	}
	
	public function Execute( actor : CActor )
	{
		victim = actor;
		GotoState( 'Storm' );
	}
}

state Idle in CACSCanarisMeteoriteStormEntity
{
}

state Storm in CACSCanarisMeteoriteStormEntity
{
	var usedPos : array<Vector>;
	
	event OnEnterState( prevStateName : name )
	{	
		Run();
	}
	
	event OnLeaveState( nextStateName : name )
	{
	}
	
	entry function Run()
	{
		var pos : Vector;
		var i : int;
		
		usedPos.Clear();
		
		while( VecDistance2D( parent.victim.GetWorldPosition(), parent.GetWorldPosition() ) < 100.0 )
		{
			pos = FindPosition();
			
			while( !IsPositionValid( pos ) )
			{
				SleepOneFrame();
				pos = FindPosition();
			}
			
			Spawn( pos );
			usedPos.PushBack( pos );
			if( usedPos.Size() > 5 )
				usedPos.Clear();
			Sleep( parent.timeBetweenSpawn );
		}
	}
	
	function Spawn( position : Vector )
	{
		var entity : CEntity;
		var meteorite : W3MeteorProjectile;
		var spawnPos : Vector;
		var randY : float;
		var rotation : EulerAngles;
		var collisionGroups : array<name>;
		
		if( parent.entityTemplate )
		{
			collisionGroups.PushBack( 'Terrain' );
			collisionGroups.PushBack( 'Static' );
		
			randY = RandRangeF( 30.0, 20.0 );
			spawnPos = position;
			spawnPos.Y += randY;
			spawnPos.Z += 50;
			
			entity = theGame.CreateEntity( parent.entityTemplate, spawnPos, rotation );
			meteorite = (W3MeteorProjectile)entity;
			if( meteorite )
			{
				meteorite.Init( NULL );
				meteorite.ShootProjectileAtPosition( meteorite.projAngle, meteorite.projSpeed, position, 500, collisionGroups );
			}
		}
	}
	
	function FindPosition() : Vector
	{
		var randVec : Vector = Vector( 0.f, 0.f, 0.f );
		var targetPos : Vector;
		var outPos : Vector;
		
		targetPos = parent.victim.GetWorldPosition();
		randVec = VecRingRand( parent.minDistFromTarget, parent.maxDistFromTarget );
		
		outPos = targetPos + randVec;
		
		return outPos;
	}
	
	protected function IsPositionValid( out whereTo : Vector ) : bool
	{
		var newPos : Vector;
		var radius : float;
		var z : float;
		var i : int;

		radius = parent.victim.GetRadius();
		
		if( !theGame.GetWorld().NavigationFindSafeSpot( whereTo, radius, radius*3, newPos ) )
		{
			if( theGame.GetWorld().NavigationComputeZ( whereTo, whereTo.Z - 5.0, whereTo.Z + 5.0, z ) )
			{
				whereTo.Z = z;
				if( !theGame.GetWorld().NavigationFindSafeSpot( whereTo, radius, radius*3, newPos ) )
					return false;
			}
			return false;
		}
		
		for( i = 0; i < usedPos.Size(); i += 1 )
		{
			if( VecDistance2D( newPos, usedPos[i] ) < parent.minDistFromEachOther )
				return false;
		}
		

		whereTo = newPos;
		
		return true;
	}
}

class W3ACSCaranthirIceMeteorProjectile extends W3MeteorProjectile
{
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);

		if ( victim == ACSGetCActor('ACS_Canaris') 
		|| victim == ACSGetCActor('ACS_Canaris_Minion')
		|| victim == ACSGetCActor('ACS_Canaris_Golem')
		)
		{
			projDMG = 0;
		}

		action.AddDamage(theGame.params.DAMAGE_NAME_FROST, projDMG );
		action.AddEffectInfo(EET_SlowdownFrost, 2.0);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
}

class W3ACSCaranthirIceSpike extends W3DurationObstacle
{
	editable var explodeAfter : float;
	editable var damageRadius : float;
	editable var damageVal : float;
	editable var effectDuration : float;
	
	var meshComp : CMeshComponent;
	var destructionComp	: CDestructionSystemComponent;
	var entitiesInRange : array< CGameplayEntity >;
	
	default explodeAfter = 10.0;
	default damageRadius = 2.5;
	default damageVal = 50;
	default effectDuration = 4.0;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		destructionComp = (CDestructionSystemComponent)GetComponentByClassName( 'CDestructionSystemComponent' );
		meshComp = (CMeshComponent)GetComponentByClassName( 'CMeshComponent' );
		if( meshComp )
		{
			meshComp.SetVisible( false );
		}
	}
	
	public function Appear()
	{
		meshComp.SetVisible( true );
		PlayEffect( 'appear' );
		PlayEffect( 'tell' );

		if(this.HasTag('ACS_Spawned_From_Minion_Death'))
		{
			AddTimer( 'Explode_Minion_Death', 3 );
			DestroyAfter( 6 );
		}
		if(this.HasTag('ACS_Ice_Boar_Explode'))
		{
			AddTimer( 'Ice_Boar_Explode', 1 );
			DestroyAfter( 3 );
		}
		else
		{
			AddTimer( 'Explode_1', explodeAfter );
			AddTimer( 'Explode_2', explodeAfter + 1 );
			AddTimer( 'Explode_3', explodeAfter + 2 );
			DestroyAfter( explodeAfter + 7.0 );
		}
	}

	timer function Explode_Minion_Death( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;

		StopAllEffects();
		PlayEffect( 'explosion' );
		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, 1.5, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor == thePlayer
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Light, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_SlowdownFrost, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}
	}

	timer function Ice_Boar_Explode( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;

		StopAllEffects();
		PlayEffect( 'explosion' );
		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, 1.5, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor == thePlayer
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( ACSGetCActor('ACS_Ice_Boar'), entitiesInRange[i], NULL, this, EHRT_Light, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_SlowdownFrost, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}
	}
	
	timer function Explode_1( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;

		StopAllEffects();
		PlayEffect( 'explosion' );
		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, damageRadius, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor == thePlayer
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_SlowdownFrost, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}
	}

	timer function Explode_2( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;

		StopAllEffects();
		PlayEffect( 'explosion' );
		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, damageRadius, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor == thePlayer
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_SlowdownFrost, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}
	}

	timer function Explode_3( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;

		StopAllEffects();
		PlayEffect( 'explosion' );
		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, damageRadius, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor == thePlayer
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_SlowdownFrost, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}
	}
}

class W3ACSZombieSpawnerProjectile extends W3AdvancedProjectile
{
	editable var initFxName				: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityOnGround	: bool;
	editable var spawnEntityTemplate 	: CEntityTemplate;

	
	var projectileHitGround : bool;
	
	default projDMG = 40.f;
	default projEfect = EET_Poison;

	
	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
				
		if ( victim && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		//DealDamageToVictim(victim);
		//PlayCollisionEffect(victim);
		//SpawnEntity( spawnEntityOnGround );
		//DeactivateProjectile();
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		var actorCaster, actorVictim : CActor;
		var damage : float;
		
		actorCaster = (CActor)caster;
		actorVictim = (CActor)victim;
		
		if( actorCaster && actorVictim && GetAttitudeBetween( actorCaster, actorVictim ) != AIA_Hostile )
		{
			return;
		}

		if (((CActor)victim).UsesEssence())
		{
			damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
		}
		else if (((CActor)victim).UsesVitality())
		{
			damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
		}
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_Undefined,false,true,false,false);
		action.AddDamage(theGame.params.DAMAGE_NAME_POISON, damage );
		action.AddEffectInfo(EET_Poison, 2.0);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity)
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile()
	{
		isActive = false;
		if( !persistFxAfterCollision )
		{
			this.StopEffect(initFxName);	
		}
		this.DestroyAfter(10.f);
	}
	
	protected function ProjectileHitGround()
	{
		SpawnEntity( spawnEntityOnGround );
		SpawnNecrofiendAdds();
		this.PlayEffect(onCollisionFxName);
		DeactivateProjectile();
	}

	function SpawnNecrofiendAdds()
	{
		var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
		var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
		var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
		var l_aiTree														: CAIMoveToAction;	
		
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\gravier_zombie_spawn.w2ent"
			
		, true );

		playerPos = this.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();
		
		count = RandRange(5,3);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 1.5 + 1.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			playerRot.Yaw += RandRangeF(360,0);

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1.5);

			//((CNewNPC)ent).SignalGameplayEvent('LastBreath');

			((CActor)ent).SetCanPlayHitAnim(false);


			((CNewNPC)ent).SetAttitude(((CNewNPC)ACSGetCActor('ACS_Necrofiend')), AIA_Friendly);

			((CNewNPC)ACSGetCActor('ACS_Necrofiend')).SetAttitude(((CActor)ent), AIA_Friendly);


			((CNewNPC)ACSGetCActor('ACS_Necrofiend_Tentacle_1')).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CNewNPC)ent).SetAttitude(((CActor)ACSGetCActor('ACS_Necrofiend_Tentacle_1')), AIA_Friendly);

			((CNewNPC)ACSGetCActor('ACS_Necrofiend_Tentacle_2')).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CNewNPC)ent).SetAttitude(((CActor)ACSGetCActor('ACS_Necrofiend_Tentacle_2')), AIA_Friendly);

			((CNewNPC)ACSGetCActor('ACS_Necrofiend_Tentacle_3')).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CNewNPC)ent).SetAttitude(((CActor)ACSGetCActor('ACS_Necrofiend_Tentacle_3')), AIA_Friendly);


			ent.AddTag( 'ACS_Necrofiend_Adds' );
		}

		RemoveTimer('NecrofiendAddsExplode');
		AddTimer('NecrofiendAddsExplode', 0.75, false);
	}

	timer function NecrofiendAddsExplode( dt : float , optional id : int)
	{
		var actors 											: array<CActor>;
		var i												: int;
		
		actors.Clear();

		theGame.GetActorsByTag( 'ACS_Necrofiend_Adds', actors );	

		if (actors.Size() <= 0)
		{
			return;
		}
		
		for( i = 0; i < actors.Size(); i += 1 )
		{
			if (!actors[i].HasTag('ACS_Necrofiend_Adds_Last_Breath_Activated'))
			{
				actors[i].SignalGameplayEvent('LastBreath');

				actors[i].AddTag('ACS_Necrofiend_Adds_Last_Breath_Activated');
			}
		}
	}
	
	function SpawnEntity( onGround : bool )
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		var entPos, normal : Vector;
		
		if ( spawnEntityTemplate )
		{
			entPos = this.GetWorldPosition();
			if ( onGround )
				theGame.GetWorld().StaticTrace( entPos + Vector(0,0,3), entPos - Vector(0,0,3), entPos, normal );
			ent = theGame.CreateEntity( spawnEntityTemplate, entPos, this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect(initFxName);
				projectileHitGround = true;
			}
		}
	}
	
	event OnRangeReached()
	{
		
		
		
		this.DestroyAfter(10.0f);
	}
}

class W3ACSPoisonProjectile extends W3AdvancedProjectile
{
	editable var initFxName				: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityOnGround	: bool;
	editable var spawnEntityTemplate 	: CEntityTemplate;

	
	var projectileHitGround : bool;
	
	default projDMG = 40.f;
	default projEfect = EET_Poison;

	
	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
				
		if ( victim && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		DealDamageToVictim(victim);
		PlayCollisionEffect(victim);
		SpawnEntity( spawnEntityOnGround );
		DeactivateProjectile();
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		var actorCaster, actorVictim : CActor;
		var damage : float;
		
		actorCaster = (CActor)caster;
		actorVictim = (CActor)victim;
		
		if( actorCaster && actorVictim && GetAttitudeBetween( actorCaster, actorVictim ) != AIA_Hostile )
		{
			return;
		}

		if (((CActor)victim).UsesEssence())
		{
			damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
		}
		else if (((CActor)victim).UsesVitality())
		{
			damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
		}
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_Undefined,false,true,false,false);
		action.AddDamage(theGame.params.DAMAGE_NAME_POISON, damage );
		action.AddEffectInfo(EET_Poison, 2.0);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity)
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile()
	{
		isActive = false;
		if( !persistFxAfterCollision )
		{
			this.StopEffect(initFxName);	
		}
		this.DestroyAfter(1.f);
	}
	
	protected function ProjectileHitGround()
	{
		SpawnEntity( spawnEntityOnGround );
		this.PlayEffect(onCollisionFxName);
		DeactivateProjectile();
	}
	
	function SpawnEntity( onGround : bool )
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		var entPos, normal : Vector;
		
		if ( spawnEntityTemplate )
		{
			entPos = this.GetWorldPosition();
			if ( onGround )
				theGame.GetWorld().StaticTrace( entPos + Vector(0,0,3), entPos - Vector(0,0,3), entPos, normal );
			ent = theGame.CreateEntity( spawnEntityTemplate, entPos, this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect(initFxName);
				projectileHitGround = true;
			}
		}
	}
	
	event OnRangeReached()
	{
		
		
		
		this.DestroyAfter(5.0f);
	}
}

class W3ACSIceSpearProjectile extends W3AdvancedProjectile
{
	editable var initFxName 				: name;
	editable var onCollisionFxName 			: name;
	editable var spawnEntityTemplate 		: CEntityTemplate;
	editable var customDuration				: float;
	editable var onCollisionVictimFxName	: name;
	editable var immediatelyStopVictimFX	: bool;
	
	private var projectileHitGround : bool;
	
	default projDMG = 40.f;
	default projEfect = EET_SlowdownFrost;
	default customDuration = 2.0;
		

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if ( collidingComponent )
			victim = ( CGameplayEntity )collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision( pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex );
		
		if ( victim && !projectileHitGround && !collidedEntities.Contains( victim ) )
		{
			VictimCollision();
		}
		else if ( !victim && !ignore ) 
		{
			ProjectileHitGround();
		}
	}
	
	protected function DestroyRequest()
	{
		StopEffect( initFxName );
		PlayEffect( onCollisionFxName );
		DestroyAfter( 2.f );
	}
	
	protected function PlayCollisionEffect()
	{
		PlayEffect(onCollisionFxName);
	}
	
	protected function VictimCollision()
	{
		DealDamageToVictim();
		PlayCollisionEffect();
		DeactivateProjectile();
	}
	
	protected function DealDamageToVictim()
	{
		var targetSlowdown 	: CActor;		
		var action : W3DamageAction;
		var damage : float;
		
		action = new W3DamageAction in this;

		if (this.HasTag('ACS_Shot_From_Wisp'))
		{
			if ( victim == thePlayer )
			{
				return;
			}

			if(RandF() < 0.25)
			{
				action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_Undefined, false, true, false, false );
			}
			else
			{
				action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_None, CPS_Undefined, false, true, false, false );
			}

			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.0125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0125;
			}

			GetACSWatcher().Wisp_Hit_Counter_Increment();

			if (this.HasTag('ACS_Wisp_Projectile_Add_Freeze'))
			{
				action.AddEffectInfo( EET_Frozen, 0.5 );
			}
			else if (this.HasTag('ACS_Wisp_Projectile_Add_Slow'))
			{
				action.AddEffectInfo( EET_Slowdown, 0.5 );
			}
			else if (this.HasTag('ACS_Wisp_Projectile_Add_Fire'))
			{
				action.AddEffectInfo( EET_Burning, 0.5 );
			}
		}
		else
		{
			action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_Undefined, false, true, false, false );

			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}
		}

		action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL , damage );
		
		if ( projEfect != EET_Undefined )
		{
			if ( customDuration > 0 )
				action.AddEffectInfo( projEfect, customDuration );
			else
				action.AddEffectInfo( projEfect );
		}

		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;	
		
		if ( IsNameValid( onCollisionVictimFxName ) )
			victim.PlayEffect( onCollisionVictimFxName );
		if ( immediatelyStopVictimFX )
			victim.StopEffect( onCollisionVictimFxName );
	}
	
	protected function DeactivateProjectile()
	{
		isActive = false;
		this.StopEffect( initFxName );
		this.DestroyAfter( 5.f );
	}
	
	protected function ProjectileHitGround()
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		
		this.PlayEffect( onCollisionFxName );
		if ( spawnEntityTemplate )
		{
			
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect( initFxName );
				projectileHitGround = true;
			}
		}
		DeactivateProjectile();
	}
}

class W3ACSFireballProjectile extends W3AdvancedProjectile
{
	editable var initFxName 			: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityTemplate 	: CEntityTemplate;
	editable var decreasePlayerDmgBy	: float; default decreasePlayerDmgBy = 0.f;

	private var projectileHitGround : bool;
	
	default projDMG = 200.f;
	default projEfect = EET_Burning;

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		DealDamageToVictim(victim);
		DeactivateProjectile(victim);
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_Undefined,false,true,false,false);
		
		if ( victim == thePlayer )
		{
			projDMG = projDMG - (projDMG * decreasePlayerDmgBy);
		}
		
		action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, projDMG );
		action.AddEffectInfo(EET_Burning, 2.0);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity )
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity )
	{
		isActive = false;
		this.StopEffect(initFxName);
		this.DestroyAfter(5.0);
		PlayCollisionEffect ( victim );
	}
	
	protected function ProjectileHitGround()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var actorsAround	 	: array<CActor>;
		var i					: int;
		
		if ( spawnEntityTemplate )
		{
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				projectileHitGround = true;
			}
		}
		
		else
		{
			actorsAround = GetActorsInRange( this, 2, , , true );
			for( i = 0; i < actorsAround.Size(); i += 1 )
			{
				DealDamageToVictim( actorsAround[i] );
			}
		}
		DeactivateProjectile();
	}
	
	event OnRangeReached()
	{
		
		
		
		this.DestroyAfter(5.f);
	}
	
	function SetProjectileHitGround( b : bool )
	{
		projectileHitGround = b;
	}
}

class W3ACSFireball extends W3AdvancedProjectile
{
	editable var initFxName 			: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityTemplate 	: CEntityTemplate;
	editable var decreasePlayerDmgBy	: float; default decreasePlayerDmgBy = 0.f;

	private var projectileHitGround : bool;
	
	default projDMG = 200.f;
	default projEfect = EET_Burning;

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		DealDamageToVictim(victim);
		DeactivateProjectile(victim);
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_Undefined,false,true,false,false);
		
		if ( victim == thePlayer )
		{
			projDMG = projDMG - (projDMG * decreasePlayerDmgBy);
		}
		
		action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, projDMG );
		action.AddEffectInfo(EET_Burning, 2.0);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity )
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity )
	{
		isActive = false;
		this.StopEffect(initFxName);
		this.DestroyAfter(5.0);
		PlayCollisionEffect ( victim );
	}
	
	protected function ProjectileHitGround()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var actorsAround	 	: array<CActor>;
		var i					: int;
		
		if ( spawnEntityTemplate )
		{
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				projectileHitGround = true;
			}
		}
		
		else
		{
			actorsAround = GetActorsInRange( this, 2, , , true );
			for( i = 0; i < actorsAround.Size(); i += 1 )
			{
				DealDamageToVictim( actorsAround[i] );
			}
		}
		DeactivateProjectile();
	}
	
	event OnRangeReached()
	{
		
		
		
		this.DestroyAfter(5.f);
	}
	
	function SetProjectileHitGround( b : bool )
	{
		projectileHitGround = b;
	}
}

class W3ACSBoulderProjectile extends W3AdvancedProjectile
{
	editable var initFxName 					: name;
	editable var onCollisionFxName 				: name;
	editable var spawnEntityTemplate 			: CEntityTemplate;
	editable var onCollisionAppearanceName 		: name;
	
	private var projectileHitGround 			: bool;

	private var damage 							: float;
	
	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;

		AddTimer('ProjectileTrackingDelay', 1, false);

		AddTimer('playredtrail', 0.1, true);
	}

	timer function playredtrail( dt : float , optional id : int)
	{
		StopEffect('red_trail');
		PlayEffectSingle('red_trail');
	}

	timer function ProjectileTrackingDelay( deltaTime : float , id : int)
	{
		AddTimer('ProjectileTracking', 0.00001, true);
	}

	timer function ProjectileTracking( deltaTime : float , id : int)
	{
		var actortarget																																					: CActor;
		var actors    																																					: array<CActor>;
		var i         																																					: int;
		var rock_pillar_temp																																			: CEntityTemplate;
		var proj_1	 																																					: W3ACSIceSpearProjectile;
		var proj_2																																						: W3ACSBoulderProjectile;
		var initpos, targetPositionNPC, targetPositionRandom																											: Vector;
		var initrot, targetRotationNPC																																	: EulerAngles;

		if (!thePlayer.IsInCombat() && !thePlayer.IsThreatened())
		{
			return;
		}

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			if (thePlayer.IsHardLockEnabled())
			{
				actortarget = (CActor)(thePlayer.GetDisplayTarget());
			}
			else
			{
				actortarget = (CActor)actors[i];
			}

			if (!actortarget)
			{
				RemoveTimer('ProjectileTracking');
				return;
			}
				
			initpos = this.GetWorldPosition();		

			initrot = this.GetWorldRotation();
			initrot.Pitch += RandRangeF(360, 0);
			initrot.Roll += RandRangeF(360, 0);
			initrot.Yaw += RandRangeF(360, 0);

			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				targetPositionNPC.Z += RandRangeF(0,-0.5);
				targetPositionNPC.X += RandRangeF(0.125,-0.125);
			}
			else
			{
				if ( actortarget.GetBoneIndex('k_head_g') != -1 )
				{
					targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
					targetPositionNPC.Z += RandRangeF(0,-0.5);
					targetPositionNPC.X += RandRangeF(0.125,-0.125);
				}
				else
				{
					targetPositionNPC = actortarget.GetWorldPosition();
					targetPositionNPC.Z += RandRangeF(0,-0.5);
					targetPositionNPC.X += RandRangeF(0.125,-0.125);
				}
			}

			if (this.HasTag('ACS_Wisp_Wood_Projectile'))
			{
				this.ShootProjectileAtPosition( 0, RandRangeF(25,10), targetPositionNPC, 500 );
			}
			else if (this.HasTag('ACS_Wisp_Rock_Projectile'))
			{
				this.ShootProjectileAtPosition( 0, RandRangeF(20,10), targetPositionNPC, 500 );
			}
			else 
			{
				this.ShootProjectileAtPosition( 0, 10, targetPositionNPC, 500 );
			}
		}
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		
		
		
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}

		RemoveTimer('ProjectileTracking');

		RemoveTimer('playredtrail');
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{	
		if (this.HasTag('ACS_Wisp_Rock_Projectile'))
		{
			DealDamageProjRockProjectile();
		}
		else
		{
			DealDamageToVictim(victim);
		}
		
		DeactivateProjectile(victim);

		RemoveTimer('ProjectileTracking');

		RemoveTimer('playredtrail');
	}

	function DealDamageProjRockProjectile()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 1.5, 20 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictim( entities[i] );
		}
	}

	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;

		
		action = new W3DamageAction in this;

		if(RandF() < 0.5)
		{
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);
		}
		else
		{
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_Undefined,false,true,false,false);
		}

		if ( projEfect != EET_Undefined )
		{
			action.AddEffectInfo(projEfect);
		}
		
		if (this.HasTag('ACS_Shot_From_Wisp'))
		{
			if ( victim == thePlayer )
			{
				action.ClearDamage();
				return;
			}

			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.0125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0125;
			}

			//GetACSWatcher().Wisp_Hit_Counter_Increment();
		}
		else
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
			}
		}
		
		action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage ); 
		
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);

		RemoveTimer('ProjectileTracking');

		RemoveTimer('playredtrail');
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity )
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity )
	{
		this.StopEffect(initFxName);
		if ( IsNameValid( onCollisionAppearanceName ))
		{
			this.ApplyAppearance( onCollisionAppearanceName );
		}
		PlayCollisionEffect ( victim );
		isActive = false;
		this.DestroyAfter(5.0);

		RemoveTimer('ProjectileTracking');

		RemoveTimer('playredtrail');
	}
	
	protected function ProjectileHitGround()
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		
		if ( spawnEntityTemplate )
		{
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect(initFxName);
				projectileHitGround = true;
			}
		}
		DeactivateProjectile();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


statemachine class CACSChaosMeteoriteStormEntity extends CGameplayEntity
{		
	editable var resourceName : name;
	editable var timeBetweenSpawn : float;
	editable var minDistFromTarget : float;
	editable var maxDistFromTarget : float;
	editable var minDistFromEachOther : float;
	
	var victim : CActor;
	var entityTemplate : CEntityTemplate;
	
	default timeBetweenSpawn = 0.5;
	default minDistFromTarget = 0.5;
	default maxDistFromTarget = 4.0;
	default minDistFromEachOther = 2.5;
	
	default autoState = 'Idle';
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		entityTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meteorite.w2ent", true );
		GotoStateAuto();
	}
	
	public function Execute( actor : CActor )
	{
		victim = actor;
		GotoState( 'Storm' );
	}
}

state Idle in CACSChaosMeteoriteStormEntity
{
}

state Storm in CACSChaosMeteoriteStormEntity
{
	var usedPos : array<Vector>;
	
	event OnEnterState( prevStateName : name )
	{	
		Run();
	}
	
	event OnLeaveState( nextStateName : name )
	{
	}
	
	entry function Run()
	{
		var pos : Vector;
		var i : int;
		
		usedPos.Clear();
		
		while( VecDistance2D( parent.victim.PredictWorldPosition(0.7), parent.GetWorldPosition() ) < 100.0 )
		{
			pos = FindPosition();
			
			while( !IsPositionValid( pos ) )
			{
				SleepOneFrame();
				pos = FindPosition();
			}
			
			Spawn( pos );
			usedPos.PushBack( pos );
			if( usedPos.Size() > 5 )
				usedPos.Clear();
			Sleep( parent.timeBetweenSpawn );
		}
	}
	
	function Spawn( position : Vector )
	{
		var entity : CEntity;
		var meteorite : W3MeteorProjectile;
		var spawnPos : Vector;
		var randY : float;
		var rotation : EulerAngles;
		var collisionGroups : array<name>;
		
		if( parent.entityTemplate )
		{
			collisionGroups.PushBack( 'Terrain' );
			collisionGroups.PushBack( 'Static' );
		
			randY = RandRangeF( 30.0, 20.0 );
			spawnPos = position;
			spawnPos.Y += randY;
			spawnPos.Z += 50;
			
			entity = theGame.CreateEntity( parent.entityTemplate, spawnPos, rotation );
			meteorite = (W3MeteorProjectile)entity;
			if( meteorite )
			{
				meteorite.Init( NULL );
				meteorite.ShootProjectileAtPosition( meteorite.projAngle, meteorite.projSpeed, position, 500, collisionGroups );
			}
		}
	}
	
	function FindPosition() : Vector
	{
		var randVec : Vector = Vector( 0.f, 0.f, 0.f );
		var targetPos : Vector;
		var outPos : Vector;
		
		targetPos = parent.victim.PredictWorldPosition(0.7);
		randVec = VecRingRand( parent.minDistFromTarget, parent.maxDistFromTarget );
		
		outPos = targetPos + randVec;
		
		return outPos;
	}
	
	protected function IsPositionValid( out whereTo : Vector ) : bool
	{
		var newPos : Vector;
		var radius : float;
		var z : float;
		var i : int;

		radius = parent.victim.GetRadius();
		
		if( !theGame.GetWorld().NavigationFindSafeSpot( whereTo, radius, radius*3, newPos ) )
		{
			if( theGame.GetWorld().NavigationComputeZ( whereTo, whereTo.Z - 5.0, whereTo.Z + 5.0, z ) )
			{
				whereTo.Z = z;
				if( !theGame.GetWorld().NavigationFindSafeSpot( whereTo, radius, radius*3, newPos ) )
					return false;
			}
			return false;
		}
		
		for( i = 0; i < usedPos.Size(); i += 1 )
		{
			if( VecDistance2D( newPos, usedPos[i] ) < parent.minDistFromEachOther )
				return false;
		}
		

		whereTo = newPos;
		
		return true;
	}
}

class W3ACSChaosMeteorProjectile extends W3MeteorProjectile
{
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);

		if ( victim == thePlayer
		|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
		)
		{
			projDMG = 0;

			return;
		}
		else
		{
			if (((CActor)victim).UsesVitality()) 
			{ 
				if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.25; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.25; 
				}
			} 
			else if (((CActor)victim).UsesEssence()) 
			{ 
				if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| ((CActor)victim).GetRadius() >= 0.7
				)
				{
					if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.125; 
					}
					else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.125; 
					}
				}
				else
				{
					if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.25; 
					}
					else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.25; 
					}
				}
			}
		}

		action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, projDMG );

		action.AddEffectInfo(EET_Burning, 2.0);

		action.SetForceExplosionDismemberment();

		theGame.damageMgr.ProcessAction( action );

		delete action;

		//thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.05 );
		
		collidedEntities.PushBack(victim);
	}
}

function GetACSChaosTornado() : W3ACSChaosTornado
{
	var entity 			 : W3ACSChaosTornado;
	
	entity = (W3ACSChaosTornado)theGame.GetEntityByTag( 'ACS_Chaos_Tornado' );
	return entity;
}

statemachine class W3ACSChaosTornado extends CGameplayEntity 
{	
	var i 																		: int;
	var victims 																: array< CActor >;
	var fxEntities                                                              : array< CEntity >;
	var aard_hit_ents															: array< CEntity >;
	var damage_action 															: W3DamageAction;
	var ticket 																	: SMovementAdjustmentRequestTicket;
	var movementAdjustor														: CMovementAdjustor;
	var movingAgent																: CMovingAgentComponent;
	var damage_value															: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('target_check', 0.1, true);

		AddTimer('clear_hits', 1.0f, true);

		explode();

		SoundEvent("magic_man_tornado_loop_start");
	}
	
	timer function clear_hits(deltaTime : float, id : int) 
	{
		aard_hit_ents.Clear();
	}
	
    timer function destroy_tornado(deltaTime : float, id : int) 
	{
		ACSGetCEntity('ACS_Chaos_Tornado_Appearance').PlayEffectSingle('explode');
		ACSGetCEntity('ACS_Chaos_Tornado_Appearance').StopEffect('explode');

		explode();

		ACSGetCEntity('ACS_Chaos_Tornado_Appearance').DestroyEffect('swarm_attack');

		RemoveTimer('destroy_app_effect');

		AddTimer('destroy_app_effect', 3 );

		RemoveTimer('target_check');

		SoundEvent("magic_man_tornado_loop_stop");
	}

    timer function destroy_app_effect(deltaTime : float, id : int) 
	{
		ACSGetCEntity('ACS_Chaos_Tornado_Appearance').Destroy();
		this.Destroy();
	}
	
	event OnDestroyed()
	{
	}

	timer function target_check(deltaTime : float, id : int) 
	{
		var entities_trap		: array< CGameplayEntity >;
		var victim 				: CActor;
		var fxEntity			: CEntity;
		var actors				: array< CActor >;
		var actor				: CActor;
		var projDMG				: float;

		entities_trap.Clear();

		FindGameplayEntitiesInRange(entities_trap, this, 20, 200 );
		entities_trap.Remove( this );
		entities_trap.Remove( ACSGetCActor('ACS_Transformation_Vampiress') );
		entities_trap.Remove( ((CGameplayEntity)ACSGetCEntity('ACS_Chaos_Tornado_Appearance')) );
		
		if( entities_trap.Size()>0 )
		{
			for ( i = 0; i <= entities_trap.Size(); i+=1 )
			{
				if ( VecDistanceSquared2D( entities_trap[i].GetWorldPosition(), this.GetWorldPosition() ) <= 15 * 15 )
				{
					if ( !aard_hit_ents.Contains( entities_trap[i] ) )
					{
						entities_trap[i].OnAardHit( NULL );
						aard_hit_ents.PushBack( entities_trap[i] );
					}
				
					victim = (CActor)entities_trap[i];

					if ( ACS_AttitudeCheck_NoDistance( victim )  )
					{
						if ( victim == thePlayer
						|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
						//|| victim == ACSGetCEntity('ACS_Chaos_Tornado_Appearance')
						)
						{
							projDMG = 0;

							return;
						}

						movingAgent = ((CActor)victim).GetMovingAgentComponent();

						movementAdjustor = ((CActor)victim).GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Chaos_Tornado_Pull');

						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 3 );
						
						movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 3 );

						movementAdjustor.Continuous( ticket );

						movementAdjustor.KeepActiveFor( ticket, deltaTime );

						movementAdjustor.SlideTowards( ticket, this );

						if( VecDistance( ((CActor)victim).GetWorldPosition(), this.GetWorldPosition() ) <= 1 )
						{	
							movementAdjustor.Cancel( ticket ); 	
						}


						damage_action =  new W3DamageAction in this;

						damage_action.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);

						if (((CActor)victim).UsesVitality()) 
						{ 
							if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0153125; 
							}
							else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.0153125; 
							}
						} 
						else if (((CActor)victim).UsesEssence()) 
						{ 
							if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| ((CActor)victim).GetRadius() >= 0.7
							)
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.00765625; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.00765625; 
								}
							}
							else
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.0153125; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.0153125; 
								}
							}
						}

						damage_action.AddDamage( theGame.params.DAMAGE_NAME_FIRE, projDMG );
						damage_action.SetHitAnimationPlayType(EAHA_ForceNo);
						damage_action.SetSuppressHitSounds(true);

						if (!((CActor)victim).HasBuff( EET_Burning ) && RandF() < 0.05 )
						{
							damage_action.AddEffectInfo(EET_Burning, 0.5);
						}
						
						damage_action.SetForceExplosionDismemberment();
						
						theGame.damageMgr.ProcessAction( damage_action );
						
						delete damage_action;
					}
				}
			}
		}
	}

	timer function explode_timer(deltaTime : float, id : int) 
	{
		explode();

		RemoveTimer('explode_timer');
	}

	function explode()
	{
		var entities_trap		: array< CGameplayEntity >;
		var victim 				: CActor;
		var projDMG				: float;

		entities_trap.Clear();
		
		FindGameplayEntitiesInRange(entities_trap, this, 15, 100 );
		
		if( entities_trap.Size()>0 )
		{
			for ( i = 0; i <= entities_trap.Size(); i+=1 )
			{
				if ( VecDistance( entities_trap[i].GetWorldPosition(), this.GetWorldPosition() ) <= 15 )
				{
					if ( !aard_hit_ents.Contains( entities_trap[i] ) )
					{
						entities_trap[i].OnAardHit( NULL );
						aard_hit_ents.PushBack( entities_trap[i] );
					}
				
					victim = (CActor)entities_trap[i];
					if ( ACS_AttitudeCheck( victim )  )
					{
						if ( victim == thePlayer
						|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
						//|| victim == ACSGetCEntity('ACS_Chaos_Tornado_Appearance')
						)
						{
							projDMG = 0;

							return;
						}

						damage_action =  new W3DamageAction in this;

						damage_action.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);

						if (((CActor)victim).UsesVitality()) 
						{ 
							if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125; 
							}
							else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.125; 
							}
						} 
						else if (((CActor)victim).UsesEssence()) 
						{ 
							if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| ((CActor)victim).GetRadius() >= 0.7
							)
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.06125; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.06125; 
								}
							}
							else
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.125; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.125; 
								}
							}
						}

						damage_action.AddDamage( theGame.params.DAMAGE_NAME_FIRE, projDMG );
						damage_action.SetHitAnimationPlayType(EAHA_ForceYes);
						damage_action.SetSuppressHitSounds(true);

						damage_action.AddEffectInfo(EET_HeavyKnockdown, 2);
	
						damage_action.SetForceExplosionDismemberment();
						
						theGame.damageMgr.ProcessAction( damage_action );
						
						delete damage_action;
					}
				}
			}
		}
	}
}

class W3ACSChaosWoodProjectile extends W3AdvancedProjectile
{
	editable var initFxName 					: name;
	editable var onCollisionFxName 				: name;
	editable var spawnEntityTemplate 			: CEntityTemplate;
	editable var onCollisionAppearanceName 		: name;
	
	private var projectileHitGround : bool;
	
	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{	
		DealDamageToVictim(victim);
		DeactivateProjectile(victim);
	}

	protected function DealDamageProjOmega()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 3, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictim( entities[i] );
		}
	}

	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		var damage : float;

		
		action = new W3DamageAction in this;

		if(RandF() < 0.5)
		{
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);
		}
		else
		{
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_Undefined,false,true,false,false);
		}

		if ( projEfect != EET_Undefined )
		{
			action.AddEffectInfo(projEfect);
		}
		
		if ( victim == thePlayer
		|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
		 )
		{
			action.ClearDamage();
			return;
		}

		if (((CActor)victim).UsesVitality()) 
		{ 
			if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125; 
			}
			else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
			{
				damage = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.125; 
			}
		} 
		else if (((CActor)victim).UsesEssence()) 
		{ 
			if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
			|| ((CActor)victim).GetRadius() >= 0.7
			)
			{
				if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.06125; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.06125; 
				}
			}
			else
			{
				if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.125; 
				}
			}
		}

		CreateCage(((CActor)victim).GetWorldPosition());
		
		action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage ); 

		action.AddEffectInfo(EET_Stagger, 5);
		
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}

	function CreateCage( pos : Vector )
	{
		var ent           										: CEntity;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"fx\monsters\witches\cage.w2ent"

		, true ), ACSPlayerFixZAxis(pos), thePlayer.GetWorldRotation() );

		ent.PlayEffectSingle('trap');

		this.SoundEvent("fx_spike_trap");
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity )
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile( optional victim : CGameplayEntity )
	{
		this.StopEffect(initFxName);
		if ( IsNameValid( onCollisionAppearanceName ))
		{
			this.ApplyAppearance( onCollisionAppearanceName );
		}

		PlayCollisionEffect ( victim );

		CreateCage(this.GetWorldPosition());

		isActive = false;

		this.DestroyAfter(5.0);
	}
	
	protected function ProjectileHitGround()
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		
		if ( spawnEntityTemplate )
		{
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect(initFxName);
				projectileHitGround = true;
			}
		}

		DealDamageProjOmega();

		DeactivateProjectile();
	}
}

class W3ChaosIceExplosion extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		PlayEffect('appear');
		PlayEffect('spikes');
		AddTimer('effect', 0.3);
		AddTimer('attack', 0.4);
	}

	timer function effect ( dt : float, optional id : int)
	{
		PlayEffect('ice_explode');

		thePlayer.SoundEvent("monster_wildhunt_minion_ice_spike_out");
		thePlayer.SoundEvent("monster_wildhunt_minion_ice_spike_back");
		thePlayer.SoundEvent("magic_eredin_icespike_tell_explosion");
		thePlayer.SoundEvent("monster_wildhunt_minion_ice_spike_attack_hands");

		thePlayer.SoundEvent("magic_eredin_icespike_tell_sparks");
	}

	timer function attack ( dt : float, optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 5, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			deal_damage( (CActor)entities[i] );
		}
	}
	
	function deal_damage( victimtarget : CActor )
	{
		var action 			: W3DamageAction;
		var damage 			: float;
		
		if ( victimtarget && victimtarget.IsAlive() && victimtarget != GetWitcherPlayer() ) 
		{
			if (((CActor)victimtarget).UsesEssence())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victimtarget).UsesVitality())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Vitality ) * 0.125;
			}

			if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
			{
				damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
			}
			
			action = new W3DamageAction in theGame.damageMgr;
			action.Initialize(GetWitcherPlayer(),victimtarget,this,GetWitcherPlayer().GetName(),EHRT_Heavy,CPS_Undefined,false, false, true, false );
			action.SetProcessBuffsIfNoDamage(true);
			action.SetCanPlayHitParticle( true );
			
			action.AddEffectInfo( EET_Frozen, 3 );

			action.AddEffectInfo( EET_SlowdownFrost, 7 );

			action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
			
			theGame.damageMgr.ProcessAction( action );
			delete action;
		}
	}
}

class W3ACSChasoVacuumOrb extends W3DurationObstacle
{
	editable var explodeAfter : float;
	editable var damageRadius : float;
	editable var damageVal : float;
	editable var effectDuration : float;
	
	var meshComp : CMeshComponent;
	var destructionComp	: CDestructionSystemComponent;
	var entitiesInRange : array< CGameplayEntity >;
	var victims 																: array< CActor >;
	var fxEntities                                                              : array< CEntity >;
	var aard_hit_ents															: array< CEntity >;
	var damage_action 															: W3DamageAction;
	var ticket 																	: SMovementAdjustmentRequestTicket;
	var movementAdjustor														: CMovementAdjustor;
	var movingAgent																: CMovingAgentComponent;
	var damage_value															: float;

	var h 					: float;
	default h				= 1;
	
	default explodeAfter = 10.0;
	default damageRadius = 5;
	default damageVal = 50;
	default effectDuration = 4.0;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		destructionComp = (CDestructionSystemComponent)GetComponentByClassName( 'CDestructionSystemComponent' );
		meshComp = (CMeshComponent)GetComponentByClassName( 'CMeshComponent' );
		if( meshComp )
		{
			meshComp.SetVisible( false );
		}
	}

	timer function clear_hits(deltaTime : float, id : int) 
	{
		aard_hit_ents.Clear();
	}
	
	public function Appear()
	{
		meshComp.SetVisible( true );

		PlayEffectSingle( 'appear' );
		PlayEffectSingle( 'tell' );
		PlayEffectSingle('marker_yrden');

		AddTimer( 'Explode_1', explodeAfter );
		DestroyAfter( explodeAfter + 15 );
	}

	timer function Explode_1( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;

		this.SoundEvent("magic_triss_fx_push");

		StopAllEffects();

		PlayEffectSingle( 'appear' );
		PlayEffectSingle( 'tell' );
		PlayEffectSingle('marker_yrden');

		PlayEffectSingle( 'blast' );

		PlayEffectSingle( 'default' );

		PlayEffectSingle( 'aard_reaction' );

		PlayEffectSingle( 'weak' );

		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, damageRadius, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor 
			&& actor != thePlayer
			&& actor != ACSGetCActor('ACS_Transformation_Vampiress')
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageVal );
				damage.AddEffectInfo( EET_Slowdown, effectDuration );
				damage.AddEffectInfo( EET_Stagger, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}

		this.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_start");

		AddTimer( 'Vacuum', 0.1, true );

		AddTimer('clear_hits', 1.0f, true);

		AddTimer( 'Shrink', 10 );
	}

	timer function Vacuum( deltaTime : float, optional id : int )
	{
		var entities_trap		: array< CGameplayEntity >;
		var victim 				: CActor;
		var fxEntity			: CEntity;
		var actors				: array< CActor >;
		var actor				: CActor;
		var projDMG				: float;
		var i 					: int;
		var meshcomp			: CComponent;
		var animcomp 			: CAnimatedComponent;

		this.SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
		this.SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

		Lightning_Tesla();

		entities_trap.Clear();

		FindGameplayEntitiesInRange(entities_trap, this, 20, 200 );
		entities_trap.Remove( this );
		entities_trap.Remove( ACSGetCActor('ACS_Transformation_Vampiress') );
		
		if( entities_trap.Size()>0 )
		{
			for ( i = 0; i <= entities_trap.Size(); i+=1 )
			{
				if ( VecDistanceSquared2D( entities_trap[i].GetWorldPosition(), this.GetWorldPosition() ) <= 20 * 20 )
				{
					if ( !aard_hit_ents.Contains( entities_trap[i] ) )
					{
						entities_trap[i].OnAardHit( NULL );
						aard_hit_ents.PushBack( entities_trap[i] );
					}

					victim = (CActor)entities_trap[i];

					if ( ACS_AttitudeCheck_NoDistance( victim )  )
					{
						if ( victim == thePlayer
						|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
						//|| victim == ACSGetCEntity('ACS_Chaos_Tornado_Appearance')
						)
						{
							projDMG = 0;

							return;
						}

						movingAgent = ((CActor)victim).GetMovingAgentComponent();

						movementAdjustor = ((CActor)victim).GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Chaos_Vacuum_Pull');

						movementAdjustor.AdjustLocationVertically( ticket, true );

						movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
						
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 3 );
						
						movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 3 );

						movementAdjustor.Continuous( ticket );

						movementAdjustor.KeepActiveFor( ticket, deltaTime );

						movementAdjustor.SlideTowards( ticket, this );

						if( VecDistance( ((CActor)victim).GetWorldPosition(), this.GetWorldPosition() ) <= 1 )
						{	
							movementAdjustor.Cancel( ticket ); 	
						}

						if (h <= 0)
						{
							h = 0;
						}
						else
						{
							h -= 0.0005;
						}

						animcomp = (CAnimatedComponent)((CActor)victim).GetComponentByClassName('CAnimatedComponent');
						meshcomp = ((CActor)victim).GetComponentByClassName('CMeshComponent');

						animcomp.SetScale(Vector( h, h, h, 1 ));

						meshcomp.SetScale(Vector( h, h, h, 1 ));	

						animcomp.FreezePose();

						((CActor)victim).EnableCharacterCollisions(false);

						damage_action =  new W3DamageAction in this;

						damage_action.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);

						if (((CActor)victim).UsesVitality()) 
						{ 
							if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0153125; 
							}
							else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.0153125; 
							}
						} 
						else if (((CActor)victim).UsesEssence()) 
						{ 
							if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| ((CActor)victim).GetRadius() >= 0.7
							)
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.00765625; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.00765625; 
								}
							}
							else
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.0153125; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.0153125; 
								}
							}
						}

						damage_action.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, projDMG );
						damage_action.SetHitAnimationPlayType(EAHA_ForceYes);
						damage_action.SetSuppressHitSounds(true);
						
						damage_action.SetForceExplosionDismemberment();
						
						theGame.damageMgr.ProcessAction( damage_action );
						
						delete damage_action;
					}
				}
			}
		}
	}

	function Lightning_Tesla()
	{
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResource( 

		"gameplay\abilities\sorceresses\fx_dummy_entity.w2ent"
			
		, true );

		playerPos = this.GetWorldPosition();

		playerRot = this.GetWorldRotation();
		
		count = RandRange(5,3);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), playerRot );

			ent.PlayEffectSingle('hit_electric');

			ent.AddTag( 'ACS_Black_Hole_Tesla_FX_Dummy' );

			ent.DestroyAfter(1);

			this.StopEffect('lightning_tesla');	
			this.PlayEffectSingle('lightning_tesla', ent);
			this.StopEffect('lightning_tesla');	
		}
	}

	timer function Shrink( deltaTime : float, optional id : int )
	{
		this.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");

		RemoveTimer('Vacuum');

		StopAllEffects();
		PlayEffectSingle( 'appear' );
		PlayEffectSingle( 'tell' );
		PlayEffectSingle('marker_yrden');

		PlayEffect( 'yrden_decr_sphere' );

		AddTimer( 'Explode_2', 2 );
	}

	timer function Explode_2( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;
		var meshcomp			: CComponent;
		var animcomp 			: CAnimatedComponent;

		StopAllEffects();
		PlayEffect( 'blast' );

		this.SoundEvent("magic_triss_fx_push");

		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		entitiesInRange.Clear();

		FindGameplayEntitiesInRange( entitiesInRange, this, damageRadius, 1000 );	
		entitiesInRange.Remove( this );
		for( i = 0; i < entitiesInRange.Size(); i += 1 )
		{
			actor = (CActor)entitiesInRange[i];
			if( actor 
			&& actor != thePlayer
			&& actor != ACSGetCActor('ACS_Transformation_Vampiress')
			)
			{
				animcomp = (CAnimatedComponent)(entitiesInRange[i]).GetComponentByClassName('CAnimatedComponent');
				meshcomp = (entitiesInRange[i]).GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 1, 1, 1, 1 ));

				meshcomp.SetScale(Vector( 1, 1, 1, 1 ));	

				animcomp.UnfreezePose();

				((CActor)entitiesInRange[i]).EnableCharacterCollisions(true);

				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_Slowdown, effectDuration );
				damage.AddEffectInfo( EET_Stagger, effectDuration );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
		}

		DestroyAfter( 3 );
	}
}

class W3ACSChaosOrbSmall extends W3AdvancedProjectile
{
	editable var initFxName 				: name;
	editable var onCollisionFxName 			: name;
	editable var spawnEntityTemplate 		: CEntityTemplate;
	editable var customDuration				: float;
	editable var onCollisionVictimFxName	: name;
	editable var immediatelyStopVictimFX	: bool;
	
	private var projectileHitGround : bool;
	var aard_hit_ents															: array< CEntity >;
	var ticket 																	: SMovementAdjustmentRequestTicket;
	var movementAdjustor														: CMovementAdjustor;
	var movingAgent																: CMovingAgentComponent;
	var damage_action 															: W3DamageAction;
	
	default projDMG = 40.f;
	default projEfect = EET_SlowdownFrost;
	default customDuration = 2.0;
		

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;

		this.PlayEffect('marker_yrden');

		AddTimer( 'Vacuum', 0.1, true );

		AddTimer('clear_hits', 1.0f, true);
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if ( collidingComponent )
			victim = ( CGameplayEntity )collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision( pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex );
		
		if ( victim && !projectileHitGround && !collidedEntities.Contains( victim ) )
		{
			VictimCollision();
		}
		else if ( !victim && !ignore ) 
		{
			ProjectileHitGround();
		}
	}
	
	protected function DestroyRequest()
	{
		StopEffect( initFxName );
		PlayEffect( onCollisionFxName );
		DestroyAfter( 2.f );
	}
	
	protected function PlayCollisionEffect()
	{
		PlayEffect(onCollisionFxName);
	}
	
	protected function VictimCollision()
	{
		//DealDamageProj();

		PlayCollisionEffect();
		//DeactivateProjectile();
	}

	function DealDamageProj()
	{
		var ent 				: CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		var surface				: CGameplayFXSurfacePost;

		this.PlayEffect('blast');
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 3, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictim( entities[i] );
		}
	}
	
	protected function DealDamageToVictim(victim : CGameplayEntity)
	{
		var targetSlowdown 	: CActor;		
		var action : W3DamageAction;
		var damage : float;
		
		action = new W3DamageAction in this;

		action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_Undefined, false, true, false, false );

		if ( ((CActor)victim) == thePlayer
		|| ((CActor)victim) == ACSGetCActor('ACS_Transformation_Vampiress')
		)
		{
			projDMG = 0;

			return;
		}

		if (((CActor)victim).UsesVitality()) 
		{ 
			if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125; 
			}
			else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
			{
				damage = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.125; 
			}
		} 
		else if (((CActor)victim).UsesEssence()) 
		{ 
			if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
			|| ((CActor)victim).GetRadius() >= 0.7
			)
			{
				if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.06125; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.06125; 
				}
			}
			else
			{
				if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
				{
					damage = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.125; 
				}
			}
		}

		action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL , damage );
		
		action.AddEffectInfo( EET_Slowdown );

		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;	
	}

	timer function clear_hits(deltaTime : float, id : int) 
	{
		aard_hit_ents.Clear();
	}

	timer function Vacuum( deltaTime : float, optional id : int )
	{
		var entities_trap		: array< CGameplayEntity >;
		var victim 				: CActor;
		var fxEntity			: CEntity;
		var actors				: array< CActor >;
		var actor				: CActor;
		var projDMG				: float;
		var i 					: int;
		var meshcomp			: CComponent;
		var animcomp 			: CAnimatedComponent;

		this.SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
		this.SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

		entities_trap.Clear();

		FindGameplayEntitiesInRange(entities_trap, this, 5, 200 );
		entities_trap.Remove( this );
		entities_trap.Remove( ACSGetCActor('ACS_Transformation_Vampiress') );
		
		if( entities_trap.Size()>0 )
		{
			for ( i = 0; i <= entities_trap.Size(); i+=1 )
			{
				if ( VecDistanceSquared2D( entities_trap[i].GetWorldPosition(), this.GetWorldPosition() ) <= 5 * 5 )
				{
					if ( !aard_hit_ents.Contains( entities_trap[i] ) )
					{
						entities_trap[i].OnAardHit( NULL );
						aard_hit_ents.PushBack( entities_trap[i] );
					}

					victim = (CActor)entities_trap[i];

					if ( ACS_AttitudeCheck_NoDistance( victim )  )
					{
						if ( victim == thePlayer
						|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
						//|| victim == ACSGetCEntity('ACS_Chaos_Tornado_Appearance')
						)
						{
							projDMG = 0;

							return;
						}

						movingAgent = ((CActor)victim).GetMovingAgentComponent();

						movementAdjustor = ((CActor)victim).GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Chaos_Vacuum_Pull');

						movementAdjustor.AdjustLocationVertically( ticket, true );

						movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
						
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 3 );
						
						movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 3 );

						movementAdjustor.Continuous( ticket );

						movementAdjustor.KeepActiveFor( ticket, deltaTime );

						movementAdjustor.SlideTowards( ticket, this );

						damage_action =  new W3DamageAction in this;

						damage_action.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);

						if (((CActor)victim).UsesVitality()) 
						{ 
							if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0153125; 
							}
							else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
							{
								projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.0153125; 
							}
						} 
						else if (((CActor)victim).UsesEssence()) 
						{ 
							if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| ((CActor)victim).GetRadius() >= 0.7
							)
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.00765625; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.00765625; 
								}
							}
							else
							{
								if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.0153125; 
								}
								else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
								{
									projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.0153125; 
								}
							}
						}

						damage_action.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, projDMG );
						damage_action.SetHitAnimationPlayType(EAHA_ForceYes);
						damage_action.SetSuppressHitSounds(true);
						
						damage_action.SetForceExplosionDismemberment();
						
						theGame.damageMgr.ProcessAction( damage_action );
						
						delete damage_action;
					}
				}
			}
		}
	}
	
	protected function DeactivateProjectile()
	{
		RemoveTimer( 'Vacuum' );

		RemoveTimer('clear_hits');

		isActive = false;
		this.StopEffect( initFxName );
		this.DestroyAfter( 5.f );
	}
	
	protected function ProjectileHitGround()
	{
		this.PlayEffect( onCollisionFxName );

		this.PlayEffect('yrden_decr_sphere');

		DealDamageProj();

		DeactivateProjectile();
	}
}

function GetACSChaosArena() : W3ACSChaosArena
{
	var entity 			 : W3ACSChaosArena;
	
	entity = (W3ACSChaosArena)theGame.GetEntityByTag( 'ACS_Chaos_Arena' );
	return entity;
}

statemachine class W3ACSChaosArena extends CGameplayEntity 
{	
	var i 																		: int;
	var victims 																: array< CActor >;
	var fxEntities                                                              : array< CEntity >;
	var aard_hit_ents															: array< CEntity >;
	var damage_action 															: W3DamageAction;
	var ticket 																	: SMovementAdjustmentRequestTicket;
	var movementAdjustor														: CMovementAdjustor;
	var movingAgent																: CMovingAgentComponent;
	var damage_value															: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('target_check_delay', 3);

		AddTimer('apply_appearance', 0.5f);
	}

	timer function target_check_delay(deltaTime : float, id : int) 
	{
		AddTimer('target_check', 0.00001, true);

		AddTimer('clear_hits', 1.0f, true);
	}

	timer function apply_appearance(deltaTime : float, id : int) 
	{
		ACSGetCEntity('ACS_Chaos_Arena_Appearance_01').PlayEffectSingle('arena_start');
		ACSGetCEntity('ACS_Chaos_Arena_Appearance_02').PlayEffectSingle('growing');
	}
	
	timer function clear_hits(deltaTime : float, id : int) 
	{
		aard_hit_ents.Clear();
	}
	
    timer function destroy_arena(deltaTime : float, id : int) 
	{
		ACSGetCEntity('ACS_Chaos_Arena_Appearance_01').StopEffect('arena_start');
		ACSGetCEntity('ACS_Chaos_Arena_Appearance_01').PlayEffectSingle('arena_end');

		ACSGetCEntity('ACS_Chaos_Arena_Appearance_02').StopEffect('growing');
		ACSGetCEntity('ACS_Chaos_Arena_Appearance_02').PlayEffectSingle('disappearing');

		RemoveTimer('target_check_remove_delay');

		AddTimer('target_check_remove_delay', 3 );

		RemoveTimer('destroy_app_effect');

		AddTimer('destroy_app_effect', 15 );
	}

	timer function target_check_remove_delay(deltaTime : float, id : int) 
	{
		RemoveTimer('target_check');
	}

    timer function destroy_app_effect(deltaTime : float, id : int) 
	{
		ACSGetCEntity('ACS_Chaos_Arena_Appearance_01').Destroy();

		ACSGetCEntity('ACS_Chaos_Arena_Appearance_02').Destroy();

		this.Destroy();
	}
	
	event OnDestroyed()
	{
	}

	function ArenaGetNPCsAndPlayersInRange(range : float, optional maxResults : int, optional tag : name, optional queryFlags : int) : array <CActor>
	{
		var i : int;
		var actors : array<CActor>;
		var entities : array<CGameplayEntity>;
		var actorEnt : CActor;
	
		
		if((queryFlags & FLAG_Attitude_Neutral) == 0 && (queryFlags & FLAG_Attitude_Hostile) == 0 && (queryFlags & FLAG_Attitude_Friendly) == 0)
			queryFlags = queryFlags | FLAG_Attitude_Neutral | FLAG_Attitude_Hostile | FLAG_Attitude_Friendly;

		
		if(maxResults <= 0)
			maxResults = 1000000;
			
		entities.Clear();
		FindGameplayEntitiesInSphere(entities, GetWorldPosition(), range, maxResults, tag, queryFlags, this);
		
		
		for(i=0; i<entities.Size(); i+=1)
		{
			actorEnt = (CActor)entities[i];
			if(actorEnt)
				actors.PushBack(actorEnt);
		}
		
		return actors;
	}

	timer function target_check(deltaTime : float, id : int) 
	{
		var entities_trap		: array< CActor >;
		var victim 				: CActor;
		var fxEntity			: CEntity;
		var actors				: array< CActor >;
		var actor				: CActor;
		var projDMG				: float;

		//FindGameplayEntitiesInRange(entities_trap, this, 100, 5000 );

		entities_trap.Clear();

		entities_trap = this.ArenaGetNPCsAndPlayersInRange( 14, 50, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		entities_trap.Remove( ACSGetCActor('ACS_Transformation_Vampiress') );
		
		if( entities_trap.Size()>0 )
		{
			for ( i = 0; i <= entities_trap.Size(); i+=1 )
			{
				if ( !aard_hit_ents.Contains( entities_trap[i] ) )
				{
					entities_trap[i].OnAardHit( NULL );
					aard_hit_ents.PushBack( entities_trap[i] );
				}
			
				victim = (CActor)entities_trap[i];

				if ( ACS_AttitudeCheck_NoDistance( victim )  )
				{
					if ( victim == thePlayer
					|| victim == ACSGetCActor('ACS_Transformation_Vampiress')
					)
					{
						projDMG = 0;

						return;
					}

					if (!((CActor)victim).HasBuff( EET_Swarm ) && RandF() < 0.125 )
					{
						((CActor)victim).AddEffectDefault(EET_Swarm, thePlayer, 'ACS_Chaos_Arena_Buff ');
					}

					if( 
					VecDistanceSquared2D( ((CActor)victim).GetWorldPosition(), this.GetWorldPosition() ) >= 12 * 12
					)
					{
						movingAgent = ((CActor)victim).GetMovingAgentComponent();

						movementAdjustor = ((CActor)victim).GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Chaos_Arena_Pull');

						movementAdjustor.AdjustmentDuration( ticket, 0.125 );

						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 300000 );
						
						movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 300000 );

						movementAdjustor.MaxLocationAdjustmentDistance(ticket, true, 0.5);

						//movementAdjustor.Continuous( ticket );

						//movementAdjustor.KeepActiveFor( ticket, deltaTime );

						movementAdjustor.SlideTowards( ticket, this );
					}

					/*

					damage_action =  new W3DamageAction in this;

					damage_action.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);

					if (((CActor)victim).UsesVitality()) 
					{ 
						if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
						{
							projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0153125; 
						}
						else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.25 )
						{
							projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.0153125; 
						}
					} 
					else if (((CActor)victim).UsesEssence()) 
					{ 
						if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| ((CActor)victim).GetRadius() >= 0.7
						)
						{
							if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.00765625; 
							}
							else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.00765625; 
							}
						}
						else
						{
							if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.0153125; 
							}
							else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.0153125; 
							}
						}
					}

					//damage_action.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, projDMG );
					damage_action.SetHitAnimationPlayType(EAHA_ForceNo);
					damage_action.SetSuppressHitSounds(true);

					if (!((CActor)victim).HasBuff( EET_Confusion ) )
					{
						damage_action.AddEffectInfo(EET_Confusion, 1);
					}
					
					damage_action.SetForceExplosionDismemberment();
					
					theGame.damageMgr.ProcessAction( damage_action );
					
					delete damage_action;
					*/
				}
			}
		}
	}
}

class CACSTransformationToadAcidPool extends CInteractiveEntity
{
	editable var poisonDamage		: SAbilityAttributeValue;
	editable var fxOnSpawn			: name;
	editable var immunityFact  		: string;
	editable var despawnTimer		: float;
	editable var damageVal			: float;
	editable var explosionRange		: float;
	editable var destroyTimer		: float;
	
	var settled 	: bool;
	var victim 		: CActor;
	var victims 	: array< CActor >;
	var poisonArea 	: CTriggerAreaComponent;
	var buffParams 	: SCustomEffectParams;
	var damage : W3DamageAction;
	var entitiesInRange : array< CGameplayEntity >;
	var targetEntity : CActor;
	var fxStartTime		: float;
	private var hasExploded : bool;

	
	default fxOnSpawn = 'toxic_gas';
	default despawnTimer = 5.0;
	default destroyTimer = 0.1;
	default fxStartTime = 0.5;
	default hasExploded = false;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		poisonArea = (CTriggerAreaComponent)GetComponent( 'PoisonArea' );	
		Enable( true );
	}
	
	final function Enable( flag : bool )
	{
		PlayEffect( fxOnSpawn );
		AddTimer( 'EnablePoison', fxStartTime );
		Spawn( flag );
	}
	
	final function Spawn( flag : bool )
	{
		if( flag ) 
		{
			AddTimer( 'Despawn', despawnTimer, );
		}
		else
		{
			StopEffect( fxOnSpawn );
		}
	}
	

	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		victim = (CActor)activator.GetEntity();	

		if ( victim 
		&& victim != thePlayer 
		&& victim != ACSGetCActor('ACS_Transformation_Toad'))
		{
			victims.PushBack( victim );
			
			if ( victims.Size() == 1 )
			{	
				if( buffParams.effectType == EET_Undefined )
				{						
					buffParams.effectType = EET_Poison;
					buffParams.creator = this;
					buffParams.creator = this;
					buffParams.duration = 1.0;
					buffParams.effectValue = poisonDamage;
					buffParams.sourceName = "ToadAcidPool";
				}
				AddTimer( 'PoisonVictim', 0.1, true );
			}
		}
	}
	
	event OnAreaExit( area : CTriggerAreaComponent, activator : CComponent )
	{
		victim = (CActor)activator.GetEntity();
		if ( victim 
		&& victims.Contains( victim )
		&& victim != thePlayer 
		&& victim != ACSGetCActor('ACS_Transformation_Toad')
		)
		{
			victims.Remove( victim );
			if ( victims.Size() == 0 )
				RemoveTimer( 'PoisonVictim' );
		}
	}
	
	
	timer function PoisonVictim( deltaTime : float , id : int)
	{
		var i : int;
		for ( i = 0; i < victims.Size(); i += 1 )
			victims[i].AddEffectCustom( buffParams );
	}
	
		
	timer function Despawn( deltaTime : float , id : int)
	{
		poisonArea.SetEnabled( false );
		this.StopAllEffects();
		this.DestroyAfter(2.0);
	}

	timer function EnablePoison( deltaTime : float , id : int)
	{
		if( poisonArea ) 
		{
			poisonArea.SetEnabled( true );
		}
	}
}

class CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile extends CACSTransformationToadPoisonProjectile
{
	editable var numberOfSpawns			: int;
	editable var minDistFromTarget		: int;
	editable var maxDistFromTarget		: int;
	
	function SpawnEntity( onGround : bool )
	{
		var ent : CEntity;
		var damageAreaEntity 	: CDamageAreaEntity;
		var entPos, normal 				: Vector;
		var i					: int;
		
		if ( spawnEntityTemplate )
		{
			for( i=0; i<numberOfSpawns; i+=1 )
			{
				entPos = this.GetWorldPosition();
				if ( onGround )
					theGame.GetWorld().StaticTrace( entPos + Vector(0,0,3), entPos - Vector(0,0,3), entPos, normal );
				ent = theGame.CreateEntity( spawnEntityTemplate, FindRandomPosition(entPos), this.GetWorldRotation() );
				damageAreaEntity = (CDamageAreaEntity)ent;
				
				if ( damageAreaEntity )
				{
					damageAreaEntity.owner = (CActor)caster;
					this.StopEffect(initFxName);
					projectileHitGround = true;
				}
			}
		}
		
	}
	
	function FindRandomPosition( pos : Vector ) : Vector
	{
		var randVec : Vector = Vector( 0.f, 0.f, 0.f );
		var outPos : Vector;
		
		randVec = VecRingRand( minDistFromTarget, maxDistFromTarget );
		outPos = pos + randVec;
		
		return outPos;
	}
}

class CACSTransformationToadPoisonProjectile extends W3AdvancedProjectile
{
	editable var initFxName				: name;
	editable var onCollisionFxName 		: name;
	editable var spawnEntityOnGround	: bool;
	editable var spawnEntityTemplate 	: CEntityTemplate;

	
	var projectileHitGround : bool;
	
	default projDMG = 40.f;
	default projEfect = EET_Poison;

	
	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
				
		if ( victim && !projectileHitGround && !collidedEntities.Contains(victim) )
		{
			VictimCollision(victim);
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			ProjectileHitGround();
		}
		else if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			ProjectileHitGround();
		}
	}
	
	protected function VictimCollision( victim : CGameplayEntity )
	{
		DealDamageProj();
		SpawnEntity( spawnEntityOnGround );
		DeactivateProjectile();
	}

	function DealDamageProj()
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;

		entities.Clear();
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 4, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			DealDamageToVictim( entities[i] );

			PlayCollisionEffect(entities[i]);
		}
	}
	
	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		var actorCaster, actorVictim : CActor;
		
		actorCaster = (CActor)caster;
		actorVictim = (CActor)victim;
		
		if( actorCaster 
		&& actorVictim 
		&& GetAttitudeBetween( actorCaster, actorVictim ) != AIA_Hostile )
		{
			return;
		}
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_Undefined,false,true,false,false);
		action.AddDamage(theGame.params.DAMAGE_NAME_POISON, projDMG * 0.25 );
		action.AddEffectInfo(EET_Poison, 2.0);
		action.AddEffectInfo(EET_Stagger, 2.0);
		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;
		
		collidedEntities.PushBack(victim);
	}
	
	protected function PlayCollisionEffect( optional victim : CGameplayEntity)
	{
		if ( victim == thePlayer && thePlayer.GetCurrentlyCastSign() == ST_Quen && ((W3PlayerWitcher)thePlayer).IsCurrentSignChanneled() )
		{}
		else
			this.PlayEffect(onCollisionFxName);
	}
	
	protected function DeactivateProjectile()
	{
		isActive = false;
		if( !persistFxAfterCollision )
		{
			this.StopEffect(initFxName);	
		}
		this.DestroyAfter(1.f);
	}
	
	protected function ProjectileHitGround()
	{
		DealDamageProj();
		SpawnEntity( spawnEntityOnGround );
		this.PlayEffect(onCollisionFxName);
		DeactivateProjectile();
	}
	
	function SpawnEntity( onGround : bool )
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		var entPos, normal : Vector;
		
		if ( spawnEntityTemplate )
		{
			entPos = this.GetWorldPosition();
			if ( onGround )
				theGame.GetWorld().StaticTrace( entPos + Vector(0,0,3), entPos - Vector(0,0,3), entPos, normal );
			ent = theGame.CreateEntity( spawnEntityTemplate, entPos, this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect(initFxName);
				projectileHitGround = true;
			}
		}
	}
	
	event OnRangeReached()
	{
		
		
		
		this.DestroyAfter(5.0f);
	}
}

class CACSTransformationToadDebuffProjectile extends W3AdvancedProjectile
{
	editable var debuffType 					: EEffectType;
	editable var hitReactionType 				: EHitReactionType;
	editable var damageTypeName 				: name;
	editable var destroyQuen 					: bool;
	editable var customDuration					: float;
	editable var initFxName 					: name;
	editable var onCollisionFxName 				: name;
	editable var specialFxOnVictimName 			: name;
	editable var applyDebuffIfNoDmgWasDealt 	: bool;
	editable var bounceOnVictimHit 				: bool;
	editable var signalDamageInstigatedEvent	: bool;
	editable var destroyAfterFloat				: float;
	editable var stopProjectileAfterCollision	: bool;
	editable var sendGameplayEventToVicitm 		: name;

	
	default customDuration = 3;
	default hitReactionType = EHRT_Light;
	default destroyAfterFloat = 5.0f;
	default stopProjectileAfterCollision = true;
	default dealDamageEvenIfDodging = false;
	
	
	
	hint specialFxOnVictimName = "will be played on collision when applyDebuffIfNoDmgWasDealt is set to true";
	
	event OnProjectileInit()
	{
		this.PlayEffect( initFxName );
		if ( !IsNameValid( damageTypeName ) )
			damageTypeName = theGame.params.DAMAGE_NAME_PIERCING;
		isActive = true;
	}
	
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		var action : W3DamageAction;
		var params : SCustomEffectParams;
		
		
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CActor)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if( stopProjectileAfterCollision )
			{
				this.StopProjectile();
			}
			this.DestroyAfter( destroyAfterFloat );
			if( !persistFxAfterCollision )
			{
				this.StopEffect( initFxName );
			}
			this.PlayEffect(onCollisionFxName);
			
			if ( IsNameValid( sendGameplayEventToVicitm ) )
			{
				( (CActor)victim ).SignalGameplayEvent( sendGameplayEventToVicitm );
			}
			
			
			
			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),hitReactionType,CPS_AttackPower, false, true, false, false);
			if ( this.projDMG > 0 )
			{
				
				if ( ((CActor)victim).UsesEssence() )
				{
					
				}
				
				else
				{
					action.SetIgnoreArmor( ignoreArmor );
				}
				action.AddDamage(damageTypeName, projDMG );
				
				
				if ( !DamageHitsEssence( damageTypeName ) )
				{
					action.AddDamage(theGame.params.DAMAGE_NAME_RENDING, projDMG );
				}
				
			}
			
			if ( customDuration > 0 && (CActor)victim )
			{
				params.effectType = debuffType;
				params.creator = NULL;
				params.sourceName = "debuff_projectile";
				params.duration = customDuration;
				
				((CActor)victim).AddEffectCustom(params);
			}
			else
			{
				action.AddEffectInfo(debuffType);
				action.SetProcessBuffsIfNoDamage(applyDebuffIfNoDmgWasDealt);
			}
			
			action.SetCanPlayHitParticle(false);

			theGame.damageMgr.ProcessAction( action );
			
			delete action;
			
			
			if ( applyDebuffIfNoDmgWasDealt )
				victim.PlayEffect(specialFxOnVictimName);
			
			if ( bounceOnVictimHit )
			{
				this.BounceOff(normal,pos);
				this.Init(victim);				
				return true;
			}
			
			collidedEntities.PushBack(victim);
			isActive = false;
		}
		else if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) || hitCollisionsGroups.Contains( 'Water' ) )
		{
			if( stopProjectileAfterCollision )
			{
				this.StopProjectile();
			}
			this.DestroyAfter( destroyAfterFloat );
			if( !persistFxAfterCollision )
			{
				this.StopEffect( initFxName );
			}
			this.PlayEffect(onCollisionFxName);
			isActive = false;
		}
		
		return false;
	}
	
	event OnRangeReached()
	{
		isActive = false;
		this.StopEffect( initFxName );
		this.DestroyAfter(1.f);
	}
}

statemachine class CACSEverstormLightning extends CGameplayEntity
{
	var pos : Vector;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		pos = this.GetWorldPosition();

		PlayEffect('lightning_area');
		PlayEffect('pre_lightning');

		AddTimer('lightning_strike', 3.f);
	}

	timer function lightning_strike ( dt : float, optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;

		StopEffect('lightning_area');
		StopEffect('pre_lightning');

		this.PushState('Lightning_Strike_Engage');
		
		entities.Clear();

		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 5, 100 );
		for( i = 0; i < entities.Size(); i += 1 )
		{
			deal_damage( (CActor)entities[i] );
		}
	}
	
	function deal_damage( victimtarget : CActor )
	{
		var action 			: W3DamageAction;
		var damage 			: float;
		
		if ( victimtarget && victimtarget.IsAlive() ) 
		{
			if (((CActor)victimtarget).UsesEssence())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Essence ) * 0.125;
			}
			else if (((CActor)victimtarget).UsesVitality())
			{
				damage = ((CActor)victimtarget).GetStat( BCS_Vitality ) * 0.125;
			}

			if ( VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) > 0.5 )
			{
				damage -= damage * VecDistance2D( this.GetWorldPosition(), victimtarget.GetWorldPosition() ) * 0.1;
			}
			
			action = new W3DamageAction in theGame.damageMgr;
			action.Initialize((CGameplayEntity)this,victimtarget,this,this.GetName(),EHRT_Heavy,CPS_Undefined,false,false,true,false);
			action.SetProcessBuffsIfNoDamage(true);
			action.SetCanPlayHitParticle( true );

			action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damage  );
			
			theGame.damageMgr.ProcessAction( action );
			delete action;
		}
	}
}

state Lightning_Strike_Engage in CACSEverstormLightning
{
	var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
	var i, count, count_2, j, k													: int;
	var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
	var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
	var adjustedRot, playerRot2													: EulerAngles;
	var actors    																: array<CActor>;
	var actor    																: CActor;
	var dmg																		: W3DamageAction;
	var world																	: CWorld;
	var l_groundZ																: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Lightning_Strike_Entry();
	}
	
	entry function Lightning_Strike_Entry()
	{
		var currentGameTime : GameTime;
		var hours : int;

		Lightning_Strike_Latent();

		if (RandF() < 0.125)
		{
			currentGameTime = theGame.CalculateTimePlayed();
			hours = GameTimeDays(currentGameTime) * 24 + GameTimeHours(currentGameTime);

			if( !theGame.IsDialogOrCutscenePlaying() 
			&& !thePlayer.IsInNonGameplayCutscene() 
			&& !thePlayer.IsInGameplayScene()
			&& !ACS_PlayerSettlementCheck(50)
			&& thePlayer.IsOnGround()
			&& !thePlayer.IsInInterior()
			&& !ACS_GetHostilesCheck()
			&& !thePlayer.IsCiri()
			&& !thePlayer.GetIsHorseRacing()
			&& hours >= 10
			)
			{
				spawn_thunderclast();
			}
		}
	}
	
	latent function Lightning_Strike_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike_secondary.w2ent"
			
		, true );

		if (parent.HasTag('ACS_Active_Lightning'))
		{
			temp_3 = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\fx\everstorm_lightning_lights.w2ent"
				
			, true );
		}

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_ground_fire.w2ent"
			
		, true );

		playerPos = ACSPlayerFixZAxis(parent.pos);

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = RandRangeF(360,1);
		adjustedRot.Pitch = RandRangeF(22.5,-22.5);

		playerRot2 = EulerAngles(0,0,0);
		playerRot2.Yaw = RandRangeF(360,1);

		if (parent.HasTag('ACS_Active_Lightning'))
		{
			ent = theGame.CreateEntity( temp_3, playerPos, EulerAngles(0,0,0) );

			ent.PlayEffectSingle('lights');

			ent.DestroyAfter(1);
		}
			
		posAdjusted = ACSPlayerFixZAxis(parent.pos);

		ent_1 = theGame.CreateEntity( temp, posAdjusted, adjustedRot );

		ent_1.PlayEffectSingle('pre_lightning');
		ent_1.PlayEffectSingle('lightning');

		ent_1.DestroyAfter(10);


		ent_2 = theGame.CreateEntity( temp_2, posAdjusted, playerRot2 );

		ent_2.PlayEffectSingle('lighgtning');

		ent_2.DestroyAfter(10);

		if (parent.HasTag('ACS_Active_Lightning'))
		{
			ent_3 = theGame.CreateEntity( temp_2, posAdjusted, adjustedRot );

			ent_3.PlayEffectSingle('lighgtning');

			ent_3.DestroyAfter(10);
		}


		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( posAdjusted, 0.5f, 10.5f, 0.5f, 7.f, 1);


		count_2 = 12;

		for( j = 0; j < count_2; j += 1 )
		{
			randRange_2 = 2 + 2 * RandF();
			randAngle_2 = 2 * Pi() * RandF();
			
			spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + posAdjusted.X;
			spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + posAdjusted.Y;
			//spawnPos2.Z = posAdjusted.Z;

			posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

			ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, EulerAngles(0,0,0) );

			if (RandF() < 0.5)
			{
				ent_4.PlayEffectSingle('explosion');
				ent_4.StopEffect('explosion');
			}
			else
			{
				if (RandF() < 0.5)
				{
					ent_4.PlayEffectSingle('explosion_big');
					ent_4.StopEffect('explosion_big');
				}
				else
				{
					ent_4.PlayEffectSingle('explosion_medium');
					ent_4.StopEffect('explosion_medium');
				}
			}

			ent_4.DestroyAfter(20);
		}
		
		if (parent.HasTag('ACS_Active_Lightning'))
		{
			thePlayer.SoundEvent( "fx_amb_thunder_close" );

			thePlayer.SoundEvent( "qu_nml_103_lightning" );
		}
	}

	latent function spawn_thunderclast()
	{
		var ent	: CACSMonsterSpawner;

		ent = (CACSMonsterSpawner)theGame.CreateEntity( 

		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 
		
		parent.pos, 

		thePlayer.GetWorldRotation() );

		ent.AddTag('ACS_MonsterSpawner_Thunderclast');

		ent.AddTag('ACS_MonsterSpawner_Spawn_In_Frame');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

class W3ACSIceStaffIceLineSpikesProjectile extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;

	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_Undefined,false,true,false,false);
			action.AddEffectInfo(EET_SlowdownFrost);

			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.00625;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.00625;
			}

			action.AddDamage(theGame.params.DAMAGE_NAME_FROST, damage );	

			if (victim == thePlayer)
			{
				action.ClearDamage();
			}

			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);
			
			delete action;
		}
	}
}

class W3ACSIceStaffFrostLine extends W3TraceGroundProjectile
{
	private var action 						: W3DamageAction;
	private var damage						: float;
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if(collidingComponent)
		{
			victim = (CGameplayEntity)collidingComponent.GetEntity();
		}
		else
		{
			victim = NULL;
		}

		if (victim = thePlayer)
		{
			return false;
		}
			
		super.OnProjectileCollision(pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex);
		
		if ( victim && !collidedEntities.Contains(victim) )
		{
			if (((CActor)victim).UsesEssence())
			{
				damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.0125;
			}
			else if (((CActor)victim).UsesVitality())
			{
				damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0125;
			}

			action = new W3DamageAction in this;
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);
			action.AddDamage(theGame.params.DAMAGE_NAME_FROST, damage );
			action.AddEffectInfo( EET_SlowdownFrost, 2.0 );
			action.SetCanPlayHitParticle(false);
			theGame.damageMgr.ProcessAction( action );
			collidedEntities.PushBack(victim);

			/*
			if ( deactivateOnCollisionWithVictim )
			{
				isActive = false;
			}
			*/

			delete action;
		}
	}
}

class W3ACSIceStaffIceSpearProjectile extends W3AdvancedProjectile
{
	editable var initFxName 				: name;
	editable var onCollisionFxName 			: name;
	editable var spawnEntityTemplate 		: CEntityTemplate;
	editable var customDuration				: float;
	editable var onCollisionVictimFxName	: name;
	editable var immediatelyStopVictimFX	: bool;
	
	private var projectileHitGround : bool;
	
	default projDMG = 40.f;
	default projEfect = EET_SlowdownFrost;
	default customDuration = 2.0;
		

	event OnProjectileInit()
	{
		this.PlayEffect(initFxName);
		projectileHitGround = false;
		isActive = true;
	}
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		if ( !isActive )
		{
			return true;
		}
		
		if ( collidingComponent )
			victim = ( CGameplayEntity )collidingComponent.GetEntity();
		else
			victim = NULL;
		
		super.OnProjectileCollision( pos, normal, collidingComponent, hitCollisionsGroups, actorIndex, shapeIndex );
		
		if ( victim && !projectileHitGround && !collidedEntities.Contains( victim ) )
		{
			VictimCollision();
		}
		else if ( !victim && !ignore ) 
		{
			ProjectileHitGround();
		}
	}
	
	protected function DestroyRequest()
	{
		StopEffect( initFxName );
		PlayEffect( onCollisionFxName );
		DestroyAfter( 2.f );
	}
	
	protected function PlayCollisionEffect()
	{
		PlayEffect(onCollisionFxName);
	}
	
	protected function VictimCollision()
	{
		DealDamageToVictim();
		PlayCollisionEffect();
		DeactivateProjectile();
	}
	
	protected function DealDamageToVictim()
	{
		var targetSlowdown 	: CActor;		
		var action : W3DamageAction;
		var damage : float;
		
		action = new W3DamageAction in this;

		if ( victim == thePlayer )
		{
			return;
		}

		if(RandF() < 0.25)
		{
			action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_Undefined, false, true, false, false );
		}
		else
		{
			action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_None, CPS_Undefined, false, true, false, false );
		}

		if (((CActor)victim).UsesEssence())
		{
			damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.125;
		}
		else if (((CActor)victim).UsesVitality())
		{
			damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.125;
		}

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.0125 );

		action.AddEffectInfo( EET_Frozen, 0.5 );

		action.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL , damage );
		
		if ( projEfect != EET_Undefined )
		{
			if ( customDuration > 0 )
				action.AddEffectInfo( projEfect, customDuration );
			else
				action.AddEffectInfo( projEfect );
		}

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.05 );

		action.SetCanPlayHitParticle(false);
		theGame.damageMgr.ProcessAction( action );
		delete action;	
		
		if ( IsNameValid( onCollisionVictimFxName ) )
			victim.PlayEffect( onCollisionVictimFxName );
		if ( immediatelyStopVictimFX )
			victim.StopEffect( onCollisionVictimFxName );
	}
	
	protected function DeactivateProjectile()
	{
		isActive = false;
		this.StopEffect( initFxName );
		this.DestroyAfter( 5.f );
	}
	
	protected function ProjectileHitGround()
	{
		var ent : CEntity;
		var damageAreaEntity : CDamageAreaEntity;
		
		this.PlayEffect( onCollisionFxName );
		if ( spawnEntityTemplate )
		{
			
			ent = theGame.CreateEntity( spawnEntityTemplate, this.GetWorldPosition(), this.GetWorldRotation() );
			damageAreaEntity = (CDamageAreaEntity)ent;
			if ( damageAreaEntity )
			{
				damageAreaEntity.owner = (CActor)caster;
				this.StopEffect( initFxName );
				projectileHitGround = true;
			}
		}
		DeactivateProjectile();
	}
}

class W3ACSIceStaffIceSpike extends W3DurationObstacle
{
	editable var explodeAfter : float;
	editable var damageRadius : float;
	editable var damageVal : float;
	editable var effectDuration : float;
	
	var meshComp : CMeshComponent;
	var destructionComp	: CDestructionSystemComponent;
	var entitiesInRange : array< CGameplayEntity >;
	
	default explodeAfter = 10.0;
	default damageRadius = 4;
	default damageVal = 50;
	default effectDuration = 4.0;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		destructionComp = (CDestructionSystemComponent)GetComponentByClassName( 'CDestructionSystemComponent' );
		meshComp = (CMeshComponent)GetComponentByClassName( 'CMeshComponent' );
		if( meshComp )
		{
			meshComp.SetVisible( false );
		}

		Appear();
	}
	
	function Appear()
	{
		meshComp.SetVisible( true );
		PlayEffect( 'appear' );
		PlayEffect( 'tell' );

		if (GetWitcherPlayer().IsItemEquippedByName('acs_ice_bats_item'))
		{
			AddTimer( 'Explode', 0.5, false );

			DestroyAfter( 5 );
		}
		else
		{
			AddTimer( 'Explode', 1.5, false );

			DestroyAfter( 5 );
		}
	}

	function IceSpikeGetNPCsAndPlayersInRange(range : float, optional maxResults : int, optional tag : name, optional queryFlags : int) : array <CActor>
	{
		var i : int;
		var actors : array<CActor>;
		var entities : array<CGameplayEntity>;
		var actorEnt : CActor;
	
		
		if((queryFlags & FLAG_Attitude_Neutral) == 0 && (queryFlags & FLAG_Attitude_Hostile) == 0 && (queryFlags & FLAG_Attitude_Friendly) == 0)
			queryFlags = queryFlags | FLAG_Attitude_Neutral | FLAG_Attitude_Hostile | FLAG_Attitude_Friendly;

		
		if(maxResults <= 0)
			maxResults = 1000000;
			
		entities.Clear();
		FindGameplayEntitiesInSphere(entities, GetWorldPosition(), range, maxResults, tag, FLAG_ExcludePlayer + queryFlags);
		entities.Remove( this );
		entities.Remove( thePlayer );
		
		for(i=0; i<entities.Size(); i+=1)
		{
			actorEnt = (CActor)entities[i];

			if(!actorEnt)
			{
				entities.Remove( actorEnt );
			}
			else
			{
				actors.PushBack(actorEnt);
			}	
		}
		
		return actors;
	}

	timer function Explode( deltaTime : float, optional id : int )
	{
		var damage : W3DamageAction;
		var i : int;
		var actor : CActor;
		var actors : array<CActor>;

		StopAllEffects();
		PlayEffect( 'explosion' );
		meshComp.SetVisible( false );
		
		GCameraShake( 0.5, true, GetWorldPosition(), 20.0f );

		actors.Clear();

		actors = IceSpikeGetNPCsAndPlayersInRange( 4, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			damage = new W3DamageAction in this;
			damage.Initialize( thePlayer, actors[i], NULL, this, EHRT_Light, CPS_Undefined, false, false, false, true );

			if (((CActor) actors[i]).UsesVitality()) 
			{ 
				if ( ((CActor) actors[i]).GetStat( BCS_Vitality ) >= ((CActor) actors[i]).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					damageVal = ((CActor) actors[i]).GetStat( BCS_Vitality ) * 0.125; 
				}
				else if ( ((CActor)actors[i]).GetStat( BCS_Vitality ) < ((CActor)actors[i]).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					damageVal = ( ((CActor) actors[i]).GetStatMax( BCS_Vitality ) - ((CActor)actors[i]).GetStat( BCS_Vitality ) ) * 0.125; 
				}
			} 
			else if (((CActor) actors[i]).UsesEssence()) 
			{ 
				if (((CMovingPhysicalAgentComponent)(((CActor) actors[i]).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| ((CActor) actors[i]).GetRadius() >= 0.7
				)
				{
					if ( ((CActor) actors[i]).GetStat( BCS_Essence ) >= ((CActor) actors[i]).GetStatMax( BCS_Essence ) * 0.5 )
					{
						damageVal = ((CActor) actors[i]).GetStat( BCS_Essence ) * 0.125; 
					}
					else if ( ((CActor) actors[i]).GetStat( BCS_Essence ) < ((CActor) actors[i]).GetStatMax( BCS_Essence ) * 0.5 )
					{
						damageVal = ( ((CActor) actors[i]).GetStatMax( BCS_Essence ) - ((CActor) actors[i]).GetStat( BCS_Essence ) ) * 0.125; 
					}
				}
				else
				{
					if ( ((CActor) actors[i]).GetStat( BCS_Essence ) >= ((CActor) actors[i]).GetStatMax( BCS_Essence ) * 0.5 )
					{
						damageVal = ((CActor) actors[i]).GetStat( BCS_Essence ) * 0.125; 
					}
					else if ( ((CActor)actors[i]).GetStat( BCS_Essence ) < ((CActor)actors[i]).GetStatMax( BCS_Essence ) * 0.5 )
					{
						damageVal = ( ((CActor) actors[i]).GetStatMax( BCS_Essence ) - ((CActor) actors[i]).GetStat( BCS_Essence ) ) * 0.125; 
					}
				}
			}

			damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );

			damage.AddEffectInfo( EET_Frozen, 2 );
			
			theGame.damageMgr.ProcessAction( damage );

			delete damage;
		}
	}
}

class W3ACSIceStaffIceMeteorProjectile extends W3MeteorProjectile
{
	var damage : float;

	protected function DealDamageToVictim( victim : CGameplayEntity )
	{
		var action : W3DamageAction;
		
		action = new W3DamageAction in theGame;
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_Undefined,false,true,false,false);

		if ( victim == thePlayer
		)
		{
			projDMG = 0;

			return;
		}
		else
		{
			if (((CActor)victim).UsesVitality()) 
			{ 
				if ( ((CActor)victim).GetStat( BCS_Vitality ) >= ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					projDMG = ((CActor)victim).GetStat( BCS_Vitality ) * 0.25; 
				}
				else if ( ((CActor)victim).GetStat( BCS_Vitality ) < ((CActor)victim).GetStatMax( BCS_Vitality ) * 0.5 )
				{
					projDMG = ( ((CActor)victim).GetStatMax( BCS_Vitality ) - ((CActor)victim).GetStat( BCS_Vitality ) ) * 0.25; 
				}
			} 
			else if (((CActor)victim).UsesEssence()) 
			{ 
				if (((CMovingPhysicalAgentComponent)(((CActor)victim).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| ((CActor)victim).GetRadius() >= 0.7
				)
				{
					if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.25; 
					}
					else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.25; 
					}
				}
				else
				{
					if ( ((CActor)victim).GetStat( BCS_Essence ) >= ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ((CActor)victim).GetStat( BCS_Essence ) * 0.25; 
					}
					else if ( ((CActor)victim).GetStat( BCS_Essence ) < ((CActor)victim).GetStatMax( BCS_Essence ) * 0.5 )
					{
						projDMG = ( ((CActor)victim).GetStatMax( BCS_Essence ) - ((CActor)victim).GetStat( BCS_Essence ) ) * 0.25; 
					}
				}
			}
		}

		action.AddDamage(theGame.params.DAMAGE_NAME_FROST, projDMG );

		action.AddEffectInfo(EET_Frozen, 2);

		action.SetForceExplosionDismemberment();

		theGame.damageMgr.ProcessAction( action );

		delete action;
		
		collidedEntities.PushBack(victim);
	}
}

statemachine class W3ACSMageAttacks extends CGameplayEntity
{
	var pos : Vector;
	var rot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ice.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ice.bnk", false );
		}

		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}

		pos = this.GetWorldPosition();
		rot = this.GetWorldRotation();

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		AddTimer('tag_check', 0.0001, true);
	}

	timer function tag_check( dt : float , optional id : int)
	{
		if (!this.HasTag('ACS_Mage_Attack_Activated'))
		{
			if (this.HasTag('ACS_Mage_Attack_Cone'))
			{
				this.PushState('ACS_Mage_Attack_Cone');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Coil'))
			{
				this.PushState('ACS_Mage_Attack_Coil');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Coil_With_Cone'))
			{
				this.PushState('ACS_Mage_Attack_Coil_With_Cone');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Blast_1'))
			{
				this.PushState('ACS_Mage_Attack_Blast_1');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Blast_2'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_l_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_l_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_l_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_l_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Blast_2');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Blast_3'))
			{
				this.PushState('ACS_Mage_Attack_Blast_3');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Gust_Left'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Gust_Left');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Gust_Right'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Gust_Right');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Gust_Up'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Gust_Up');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Mega_Gust'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Mega_Gust');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Quicksand'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

					thePlayer.StopEffect( 'hand_sand_fx_water_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_l_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

					thePlayer.StopEffect( 'hand_sand_fx_sand_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_l_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

					thePlayer.StopEffect( 'hand_sand_fx_fire_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_l_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

					thePlayer.StopEffect( 'hand_sand_fx_ice_l_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_l_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_l_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Quicksand');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_SandCage'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
				}

				this.PushState('ACS_Mage_Attack_SandCage');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Mage_Attack_Tornado'))
			{
				if (ACS_GetItem_MageStaff_Water())
				{
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
					thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
					thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
				}

				this.PushState('ACS_Mage_Attack_Tornado');
				stop_tag_check();
				return;
			}

		}
	}

	function MageAttackGetNPCsAndPlayersInRange(range : float, optional maxResults : int, optional tag : name, optional queryFlags : int) : array <CActor>
	{
		var i : int;
		var actors : array<CActor>;
		var entities : array<CGameplayEntity>;
		var actorEnt : CActor;
	
		
		if((queryFlags & FLAG_Attitude_Neutral) == 0 && (queryFlags & FLAG_Attitude_Hostile) == 0 && (queryFlags & FLAG_Attitude_Friendly) == 0)
			queryFlags = queryFlags | FLAG_Attitude_Neutral | FLAG_Attitude_Hostile | FLAG_Attitude_Friendly;

		
		if(maxResults <= 0)
			maxResults = 1000000;
			
		entities.Clear();
		FindGameplayEntitiesInSphere(entities, GetWorldPosition(), range, maxResults, tag, FLAG_ExcludePlayer + queryFlags);
		entities.Remove( this );
		entities.Remove( thePlayer );
		
		for(i=0; i<entities.Size(); i+=1)
		{
			actorEnt = (CActor)entities[i];

			if(!actorEnt)
			{
				entities.Remove( actorEnt );
			}
			else
			{
				actors.PushBack(actorEnt);
			}	
		}
		
		return actors;
	}

	timer function ice_rift_stop_sound(deltaTime : float, id : int) 
	{
		thePlayer.SoundEvent("magic_caranthil_teleport_fx_stop");
	}

	timer function tornado_target_check(deltaTime : float, id : int) 
	{
		var i, j 																	: int;
		var victims 																: array< CActor >;
		var fxEntities                                                              : array< CEntity >;
		var aard_hit_ents															: array< CEntity >;
		var damage_action 															: W3DamageAction;
		var ticket 																	: SMovementAdjustmentRequestTicket;
		var movementAdjustor														: CMovementAdjustor;
		var movingAgent																: CMovingAgentComponent;
		var damage_value															: float;
		var entities_trap															: array< CGameplayEntity >;
		var victim, victim_erase													: CActor;
		var actors																	: array< CActor >;
		var actor																	: CActor;
		var projDMG																	: float;

		entities_trap.Clear();

		FindGameplayEntitiesInRange(entities_trap, this, 20, 200 );
		entities_trap.Remove( this );
		entities_trap.Remove( thePlayer );

		if( entities_trap.Size()>0 )
		{	
			for( j=entities_trap.Size()-1; j>=0; j-=1 )
			{
				victim_erase = (CActor)entities_trap[j];

				if (!victim_erase)
				{
					entities_trap.EraseFast( j );
				}
			}

			for ( i = 0; i <= entities_trap.Size(); i+=1 )
			{
				if ( VecDistanceSquared2D( entities_trap[i].GetWorldPosition(), this.GetWorldPosition() ) <= 15 * 15 )
				{
					if ( !aard_hit_ents.Contains( entities_trap[i] ) )
					{
						entities_trap[i].OnAardHit( NULL );
						aard_hit_ents.PushBack( entities_trap[i] );
					}
				
					victim = (CActor)entities_trap[i];
					
					if ( ACS_AttitudeCheck_NoDistance( victim )  )
					{
						if ( victim == thePlayer
						)
						{
							continue;
						}

						movingAgent = ((CActor)victim).GetMovingAgentComponent();

						movementAdjustor = ((CActor)victim).GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Mage_Tornado_Pull');

						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 3 );
						
						movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 3 );

						movementAdjustor.Continuous( ticket );

						movementAdjustor.KeepActiveFor( ticket, deltaTime );

						movementAdjustor.SlideTowards( ticket, this );

						if( VecDistance( ((CActor)victim).GetWorldPosition(), this.GetWorldPosition() ) <= 1 )
						{	
							movementAdjustor.Cancel( ticket ); 	
						}


						damage_action =  new W3DamageAction in this;

						damage_action.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);

						damage_action.SetHitAnimationPlayType(EAHA_ForceNo);

						damage_action.SetSuppressHitSounds(true);

						if (ACS_GetItem_MageStaff_Water())
						{
							if (!((CActor)victim).HasBuff( EET_Confusion ))
							{
								damage_action.AddEffectInfo( EET_Confusion, 3 );
							}
						}
						else if (ACS_GetItem_MageStaff_Sand())
						{
							if (!((CActor)victim).HasBuff( EET_Bleeding )  )
							{
								damage_action.AddEffectInfo( EET_Bleeding, 3 );
							}
						}
						else if (ACS_GetItem_MageStaff_Fire())
						{
							if (!((CActor)victim).HasBuff( EET_Burning ) )
							{
								damage_action.AddEffectInfo( EET_Burning, 3 );
							}
						}
						else if (ACS_GetItem_MageStaff_Ice())
						{
							if (!((CActor)victim).HasBuff( EET_Frozen ) )
							{
								damage_action.AddEffectInfo( EET_Frozen, 3 );
							}
						}
						
						damage_action.SetForceExplosionDismemberment();
						
						theGame.damageMgr.ProcessAction( damage_action );
						
						delete damage_action;
					}
				}
			}
		}
	}

	function stop_tag_check()
	{
		RemoveTimer('tag_check');
		this.AddTag('ACS_Mage_Attack_Activated');
	}
}

state ACS_Mage_Attack_Cone in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;

	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Cone_Entry();
	}

	entry function ACS_Mage_Attack_Cone_Entry()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			parent.PlayEffect('cone_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('cone_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('cone_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.PlayEffect('cone_cs_mq1060_aard');
			parent.PlayEffect('cone_ground_mutation_6_aard');
		}

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(7.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 90, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Cone_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.025; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.025; 
				} 

				dmg.SetForceExplosionDismemberment();

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.025 );

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_water_ACS');
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_sand_ACS');
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('warning_up_fire_ACS');
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					ent.PlayEffect('ice_spikes');
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Coil in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var proj_1, proj_2, proj_3, proj_4, proj_5, proj_6, proj_7																											: W3ACSIceStaffIceSpearProjectile;
	private var initpos_1, initpos_2, initpos_3, initpos_4, initpos_5, initpos_6, initpos_7, targetPositionNPC																	: Vector;


	event OnEnterState(prevStateName : name)
	{
		if (ACS_GetItem_MageStaff_Ice())
		{
			ACS_Mage_Attack_Ice_Staff_Ice_Spear_Latent();
		}
		else
		{
			ACS_Mage_Attack_Coil_Latent();
		}
	}

	entry function ACS_Mage_Attack_Ice_Staff_Ice_Spear_Latent()
	{
		parent.PlayEffect('cone_ground_mutation_6_aard');

		initpos_1 = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 3;			
		initpos_1.Z += 2;

		initpos_2 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1 + thePlayer.GetWorldForward() * 3;			
		initpos_2.Z += 1.5;

		initpos_3 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1 + thePlayer.GetWorldForward() * 3;			
		initpos_3.Z += 1.5;

		initpos_4 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * 1 + thePlayer.GetWorldForward() * 3;			
		initpos_4.Z += 2.5;

		initpos_5 = thePlayer.GetWorldPosition() + thePlayer.GetWorldRight() * -1 + thePlayer.GetWorldForward() * 3;			
		initpos_5.Z += 2.5;

		initpos_6 = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 3;					
		initpos_6.Z += 1;

		initpos_7 = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 3;				
		initpos_7.Z += 3;
				
		targetPositionNPC = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 50;

		targetPositionNPC.Z += 1.5;
				
		proj_1 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_1 );
						
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_fx');
		proj_1.PlayEffectSingle('explode');
		proj_1.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_1.DestroyAfter(5);

		proj_2 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_2 );
						
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_fx');
		proj_2.PlayEffectSingle('explode');
		proj_2.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_2.DestroyAfter(5);

		proj_3 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_3 );
						
		proj_3.Init(GetWitcherPlayer());
		proj_3.PlayEffectSingle('fire_fx');
		proj_3.PlayEffectSingle('explode');
		proj_3.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_3.DestroyAfter(5);

		proj_4 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_4 );
						
		proj_4.Init(GetWitcherPlayer());
		proj_4.PlayEffectSingle('fire_fx');
		proj_4.PlayEffectSingle('explode');
		proj_4.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_4.DestroyAfter(5);

		proj_5 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_5 );
						
		proj_5.Init(GetWitcherPlayer());
		proj_5.PlayEffectSingle('fire_fx');
		proj_5.PlayEffectSingle('explode');
		proj_5.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_5.DestroyAfter(5);

		proj_6 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_6 );
						
		proj_6.Init(GetWitcherPlayer());
		proj_6.PlayEffectSingle('fire_fx');
		proj_6.PlayEffectSingle('explode');
		proj_6.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_6.DestroyAfter(5);

		proj_7 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_7 );
						
		proj_7.Init(GetWitcherPlayer());
		proj_7.PlayEffectSingle('fire_fx');
		proj_7.PlayEffectSingle('explode');
		proj_7.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_7.DestroyAfter(5);



		parent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Coil_Latent()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			parent.PlayEffect('san_fx1_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('san_fx1_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('san_fx1_fire_ACS');
		}

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 30, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Coil_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.025 );

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('warning_up_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Coil_With_Cone in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var proj_1, proj_2, proj_3, proj_4, proj_5																															: W3ACSIceStaffIceSpearProjectile;
	private var initpos, targetPositionNPC																																		: Vector;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_GetItem_MageStaff_Ice())
		{
			ACS_Mage_Attack_Ice_Staff_Ice_Spear_Rapid_Fire_Latent();
		}
		else
		{
			ACS_Mage_Attack_Coil_With_Cone_Latent();
		}
	}

	entry function ACS_Mage_Attack_Ice_Staff_Ice_Spear_Rapid_Fire_Latent()
	{
		parent.PlayEffect('cone_ground_mutation_6_aard');

		initpos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 3;			
		initpos.Z += 1.5;

		targetPositionNPC = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 50;
		
		targetPositionNPC.Z += 1.5;
				
		proj_1 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos );
						
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_fx');
		proj_1.PlayEffectSingle('explode');
		proj_1.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_1.DestroyAfter(5);

		Sleep(0.15);

		proj_2 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos );
						
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_fx');
		proj_2.PlayEffectSingle('explode');
		proj_2.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_2.DestroyAfter(5);

		Sleep(0.15);

		proj_3 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos );
						
		proj_3.Init(GetWitcherPlayer());
		proj_3.PlayEffectSingle('fire_fx');
		proj_3.PlayEffectSingle('explode');
		proj_3.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_3.DestroyAfter(5);

		Sleep(0.15);

		proj_4 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos );
						
		proj_4.Init(GetWitcherPlayer());
		proj_4.PlayEffectSingle('fire_fx');
		proj_4.PlayEffectSingle('explode');
		proj_4.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_4.DestroyAfter(5);

		Sleep(0.15);

		proj_5 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos );
						
		proj_5.Init(GetWitcherPlayer());
		proj_5.PlayEffectSingle('fire_fx');
		proj_5.PlayEffectSingle('explode');
		proj_5.ShootProjectileAtPosition( 0, 15, targetPositionNPC, 500 );
		proj_5.DestroyAfter(5);

		parent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Coil_With_Cone_Latent()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			parent.PlayEffect('san_fx1_water_ACS');
			parent.PlayEffect('cone_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('san_fx1_sand_ACS');
			parent.PlayEffect('cone_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('san_fx1_fire_ACS');
			parent.PlayEffect('cone_fire_ACS');
		}

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 30, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Coil_With_Cone_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.055; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.055; 
				} 

				dmg.SetForceExplosionDismemberment();

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.025 );

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('warning_up_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Blast_1 in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;


	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Blast_1_Entry();
	}
	
	latent function dolphin_spawn_blast_v1_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v1_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v1_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v1_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Blast_1_Entry()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_blast_v1_1();
			dolphin_spawn_blast_v1_2();
			dolphin_spawn_blast_v1_3();
			dolphin_spawn_blast_v1_4();

			parent.PlayEffect('attack_fx1_water_ACS');

			parent.PlayEffect('blast_water_aard');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('attack_fx1_sand_ACS');

			parent.PlayEffect('blast_ground_aard');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('attack_fx1_fire_ACS');

			parent.PlayEffect('blast_lv1_aard_fire');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.PlayEffect('blast_ground_mutation_6_aard');

			parent.PlayEffect('blast_lv1_aard');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Blast_1_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_water_ACS');

					ent.PlayEffect('blood_up_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_sand_ACS');

					ent.PlayEffect('blood_up_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('warning_up_fire_ACS');

					ent.PlayEffect('blood_up_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					actortarget.SoundEvent("cmb_play_hit_heavy");
					GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

					ent.PlayEffect('ice_line');

					ent.PlayEffect('ice_spikes');

					ent.PlayEffect('blast_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 0.5 );
					}
				}

				ent.DestroyAfter(10);


					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Blast_2 in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;

	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Blast_2_Entry();
	}

	latent function dolphin_spawn_blast_v2_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v2_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v2_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v2_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Blast_2_Entry()
	{	
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_blast_v2_1();
			dolphin_spawn_blast_v2_2();
			dolphin_spawn_blast_v2_3();
			dolphin_spawn_blast_v2_4();

			parent.PlayEffect('attack_special_water_ACS');

			parent.PlayEffect('blast_water_aard');

			parent.PlayEffect('blast_lv1_damage_aard');

			parent.PlayEffect('blast_lv1_power_aard');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('attack_special_sand_ACS');

			parent.PlayEffect('blast_ground_aard');

			parent.PlayEffect('leaf_fx_aard');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('attack_special_fire_ACS');

			parent.PlayEffect('blast_lv2_aard_fire');

			parent.PlayEffect('leaf_fx_aard_fire');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.PlayEffect('blast_lv2_aard');

			parent.PlayEffect('blast_ground_mutation_6_aard');

			parent.PlayEffect('blast_lv2_damage_aard');

			parent.PlayEffect('blast_lv2_power_aard');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 6, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);
		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Blast_2_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.07; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.07; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_water_ACS');

					ent.PlayEffect('blood_up_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_sand_ACS');

					ent.PlayEffect('blood_up_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('warning_up_fire_ACS');

					ent.PlayEffect('blood_up_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					actortarget.SoundEvent("cmb_play_hit_heavy");
					GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					ent.PlayEffect('ice_line');

					ent.PlayEffect('ice_spikes');

					ent.PlayEffect('cone_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 0.5 );
					}
				}

				ent.DestroyAfter(10);



					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Blast_3 in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var proj, proj_1, proj_2, proj_3, proj_4, proj_5, proj_6	 																										: W3ACSIceStaffFrostLine;
	private var initpos, targetPositionNPC, targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, targetPosition_6							: Vector;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_GetItem_MageStaff_Ice())
		{
			ACS_Mage_Attack_Ice_Staff_Frost_Line_Latent();
		}
		else
		{
			ACS_Mage_Attack_Blast_3_Latent();
		}
	}

	latent function dolphin_spawn_blast_v3_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v3_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v3_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_blast_v3_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Ice_Staff_Frost_Line_Latent()
	{
		parent.Teleport(parent.GetWorldPosition() + Vector(0,0,-1));

		parent.PlayEffect('blast_lv3_aard');

		parent.PlayEffect('blast_ground_mutation_6_aard');

		parent.PlayEffect('ice_spikes');

		parent.PlayEffect('ice_line');

		initpos = parent.GetWorldPosition();		

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 7, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Blast_3_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.1; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.1; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

				actortarget.SoundEvent("cmb_play_hit_heavy");
				GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");
				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				ent.PlayEffect('ice_line');

				ent.PlayEffect('ice_spikes');

				ent.PlayEffect('cone_ground_mutation_6_aard');

				if (!actortarget.HasBuff(EET_Frozen))
				{
					dmg.AddEffectInfo( EET_Frozen, 0.5 );
				}

				ent.DestroyAfter(10);


					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
				
				
			}
		}

		targetPosition_1 = parent.GetWorldPosition() + parent.GetWorldForward() * 50;

		targetPosition_2 = parent.GetWorldPosition() + parent.GetWorldForward() * -50;

		targetPosition_3 = parent.GetWorldPosition() + parent.GetWorldRight() * 50 + parent.GetWorldForward() * 50;

		targetPosition_4 = parent.GetWorldPosition() + parent.GetWorldRight() * -50 + parent.GetWorldForward() * 50;

		targetPosition_5 = parent.GetWorldPosition() + parent.GetWorldRight() * 50 + parent.GetWorldForward() * -50;

		targetPosition_6 = parent.GetWorldPosition() + parent.GetWorldRight() * -50 + parent.GetWorldForward() * -50;

		proj_1 = (W3ACSIceStaffFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_frost_line.w2ent", true ), initpos );
						
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line_big');
		proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 10 );
		proj_1.DestroyAfter(5);


		proj_2 = (W3ACSIceStaffFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_frost_line.w2ent", true ), initpos );
						
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_line_big');
		proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 10 );
		proj_2.DestroyAfter(5);


		proj_3 = (W3ACSIceStaffFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_frost_line.w2ent", true ), initpos );
						
		proj_3.Init(GetWitcherPlayer());
		proj_3.PlayEffectSingle('fire_line_big');
		proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 10 );
		proj_3.DestroyAfter(5);


		proj_4 = (W3ACSIceStaffFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_frost_line.w2ent", true ), initpos );
						
		proj_4.Init(GetWitcherPlayer());
		proj_4.PlayEffectSingle('fire_line_big');
		proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 10 );
		proj_4.DestroyAfter(5);


		proj_5 = (W3ACSIceStaffFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_frost_line.w2ent", true ), initpos );
						
		proj_5.Init(GetWitcherPlayer());
		proj_5.PlayEffectSingle('fire_line_big');
		proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 10 );
		proj_5.DestroyAfter(5);


		proj_6 = (W3ACSIceStaffFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_frost_line.w2ent", true ), initpos );
						
		proj_6.Init(GetWitcherPlayer());
		proj_6.PlayEffectSingle('fire_line_big');
		proj_6.ShootProjectileAtPosition(0,	20, targetPosition_6, 10 );
		proj_6.DestroyAfter(5);
				
		parent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Blast_3_Latent()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_blast_v3_1();
			dolphin_spawn_blast_v3_2();
			dolphin_spawn_blast_v3_3();
			dolphin_spawn_blast_v3_4();

			parent.PlayEffect('teleport_in_water_ACS');
			parent.PlayEffect('teleport_out_water_ACS');
			parent.PlayEffect('blast_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('teleport_in_sand_ACS');
			parent.PlayEffect('teleport_out_sand_ACS');
			parent.PlayEffect('blast_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('teleport_in_fire_ACS');
			parent.PlayEffect('teleport_out_fire_ACS');
			parent.PlayEffect('blast_fire_ACS');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 7, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Blast_3_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.1; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.1; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_water_ACS');

					ent.PlayEffect('blood_up_water_ACS');

					ent.PlayEffect('teleport_in_water_ACS');

					ent.PlayEffect('teleport_out_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('warning_up_sand_ACS');

					ent.PlayEffect('blood_up_sand_ACS');

					ent.PlayEffect('teleport_in_sand_ACS');
					
					ent.PlayEffect('teleport_out_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('warning_up_fire_ACS');

					ent.PlayEffect('blood_up_fire_ACS');

					ent.PlayEffect('teleport_in_fire_ACS');
					
					ent.PlayEffect('teleport_out_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}

				ent.DestroyAfter(10);


					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Gust_Left in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var proj_1	 																																						: W3ACSIceStaffIceLineSpikesProjectile;
	private var initpos, targetPositionNPC																																		: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Gust_Left_Entry();
	}

	latent function dolphin_spawn_left()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 90;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Gust_Left_Entry()
	{	
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_left();
			parent.PlayEffect('warning_up_left_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('warning_up_left_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('warning_up_left_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');
		}

		Sleep(0.5);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('diagonal_up_left_water_ACS');
			parent.PlayEffect('blood_diagonal_up_left_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('diagonal_up_left_sand_ACS');
			parent.PlayEffect('blood_diagonal_up_left_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('diagonal_up_left_fire_ACS');
			parent.PlayEffect('blood_diagonal_up_left_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 7.5, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Gust_Left_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.07; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.07; 
				} 

				dmg.SetForceExplosionDismemberment();

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.025 );

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('diagonal_up_left_water_ACS');
					ent.PlayEffect('blood_diagonal_up_left_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('diagonal_up_left_sand_ACS');
					ent.PlayEffect('blood_diagonal_up_left_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('diagonal_up_left_fire_ACS');
					ent.PlayEffect('blood_diagonal_up_left_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					ent.PlayEffect('ice_spikes');
					ent.PlayEffect('ice_line');
					ent.PlayEffect('cone_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 0.5 );
					}

					initpos = actortarget.GetWorldPosition() + thePlayer.GetWorldRight() * 5;			
							
					targetPositionNPC = actortarget.GetWorldPosition() + thePlayer.GetWorldRight() * -5;

					proj_1 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes.w2ent", true ), initpos );
									
					proj_1.Init(GetWitcherPlayer());
					proj_1.PlayEffectSingle('fire_line_big');
					proj_1.ShootProjectileAtPosition(0,	15, targetPositionNPC, 10 );
					proj_1.DestroyAfter(5);
				}

				ent.DestroyAfter(10);


					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Gust_Right in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var proj_1	 																																						: W3ACSIceStaffIceLineSpikesProjectile;
	private var initpos, targetPositionNPC																																		: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Gust_Right_Entry();
	}

	latent function dolphin_spawn_right()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 90;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Gust_Right_Entry()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_right();
			parent.PlayEffect('warning_up_right_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('warning_up_right_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('warning_up_right_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');
		}

		Sleep(0.5);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('diagonal_up_right_water_ACS');
			parent.PlayEffect('blood_diagonal_up_right_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('diagonal_up_right_sand_ACS');
			parent.PlayEffect('blood_diagonal_up_right_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('diagonal_up_right_fire_ACS');
			parent.PlayEffect('blood_diagonal_up_right_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 7.5, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Gust_Right_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.07; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.07; 
				} 

				dmg.SetForceExplosionDismemberment();

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.025 );


				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('diagonal_up_right_water_ACS');
					ent.PlayEffect('blood_diagonal_up_right_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('diagonal_up_right_sand_ACS');
					ent.PlayEffect('blood_diagonal_up_right_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('diagonal_up_right_fire_ACS');
					ent.PlayEffect('blood_diagonal_up_right_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					ent.PlayEffect('ice_spikes');
					ent.PlayEffect('ice_line');
					ent.PlayEffect('cone_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 0.5 );
					}

					initpos = actortarget.GetWorldPosition() + thePlayer.GetWorldRight() * -5;			
							
					targetPositionNPC = actortarget.GetWorldPosition() + thePlayer.GetWorldRight() * 5;

					proj_1 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes.w2ent", true ), initpos );
									
					proj_1.Init(GetWitcherPlayer());
					proj_1.PlayEffectSingle('fire_line_big');
					proj_1.ShootProjectileAtPosition(0,	15, targetPositionNPC, 10 );
					proj_1.DestroyAfter(5);
				}

				ent.DestroyAfter(10);

					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Gust_Up in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var proj, proj_1, proj_2, proj_3, proj_4, proj_5, proj_6	 																										: W3ACSIceStaffIceLineSpikesProjectile;
	private var initpos_1, initpos_2, initpos_3, initpos_4, initpos_5, initpos_6, targetPositionNPC																				: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Gust_Up_Entry();
	}

	latent function dolphin_spawn_up_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 90;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_up_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 90;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Gust_Up_Entry()
	{	
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_up_1();
			dolphin_spawn_up_2();
			parent.PlayEffect('warning_up_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('warning_up_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('warning_up_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');
		}

		Sleep(0.5);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('up_water_ACS');
			parent.PlayEffect('blood_up_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('up_sand_ACS');
			parent.PlayEffect('blood_up_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('up_fire_ACS');
			parent.PlayEffect('blood_up_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

			targetPositionNPC = parent.GetWorldPosition();

			initpos_1 = parent.GetWorldPosition() + parent.GetWorldForward() * 5.5;

			initpos_2 = parent.GetWorldPosition() + parent.GetWorldForward() * -5.5;

			initpos_3 = parent.GetWorldPosition() + parent.GetWorldRight() * 5.5 + parent.GetWorldForward() * 5.5;

			initpos_4 = parent.GetWorldPosition() + parent.GetWorldRight() * -5.5 + parent.GetWorldForward() * 5.5;

			initpos_5 = parent.GetWorldPosition() + parent.GetWorldRight() * 5.5 + parent.GetWorldForward() * -5.5;

			initpos_6 = parent.GetWorldPosition() + parent.GetWorldRight() * -5.5 + parent.GetWorldForward() * -5.5;

			proj_1 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes_big.w2ent", true ), initpos_1 );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	15, targetPositionNPC, 5.5 );
			proj_1.DestroyAfter(5);


			proj_2 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes_big.w2ent", true ), initpos_2 );
							
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	15, targetPositionNPC, 5.5 );
			proj_2.DestroyAfter(5);


			proj_3 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes_big.w2ent", true ), initpos_3 );
							
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	15, targetPositionNPC, 5.5 );
			proj_3.DestroyAfter(5);


			proj_4 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes_big.w2ent", true ), initpos_4 );
							
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	15, targetPositionNPC, 5.5 );
			proj_4.DestroyAfter(5);


			proj_5 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes_big.w2ent", true ), initpos_5 );
							
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	15, targetPositionNPC, 5.5 );
			proj_5.DestroyAfter(5);


			proj_6 = (W3ACSIceStaffIceLineSpikesProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_line_spikes_big.w2ent", true ), initpos_6 );
							
			proj_6.Init(GetWitcherPlayer());
			proj_6.PlayEffectSingle('fire_line');
			proj_6.ShootProjectileAtPosition(0,	15, targetPositionNPC, 5.5 );
			proj_6.DestroyAfter(5);
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 7.5, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Gust_Up_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.1; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.1; 
				} 

				dmg.SetForceExplosionDismemberment();

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.025 );

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('up_water_ACS');
					ent.PlayEffect('blood_up_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('up_sand_ACS');
					ent.PlayEffect('blood_up_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('up_fire_ACS');
					ent.PlayEffect('blood_up_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					ent.PlayEffect('ice_spikes');
					ent.PlayEffect('ice_line');

					ent.PlayEffect('blast_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 0.5 );
					}
				}

				ent.DestroyAfter(10);


					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;

			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Mega_Gust in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var entity : CEntity;
	private var iceSpike : W3ACSIceStaffIceSpike;
	private var pos : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Mega_Gust_Entry();
	}

	latent function dolphin_spawn_mega_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		
		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_mega_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_mega_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_mega_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Mega_Gust_Entry()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_mega_1();
			dolphin_spawn_mega_2();
			dolphin_spawn_mega_3();
			dolphin_spawn_mega_4();

			parent.PlayEffect('warning_up_water_ACS');
			parent.PlayEffect('warning_up_left_water_ACS');
			parent.PlayEffect('warning_up_right_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('warning_up_sand_ACS');
			parent.PlayEffect('warning_up_left_sand_ACS');
			parent.PlayEffect('warning_up_right_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('warning_up_fire_ACS');
			parent.PlayEffect('warning_up_left_fire_ACS');
			parent.PlayEffect('warning_up_right_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.Teleport(parent.GetWorldPosition() + Vector(0,0,-0.5));

			parent.PlayEffect('ice_line');

			parent.PlayEffect('ice_spikes');

			parent.PlayEffect('ice_marker_fx');
		}

		Sleep(1.5);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('teleport_in_water_ACS');
			parent.PlayEffect('teleport_out_water_ACS');
			parent.PlayEffect('quicksand_yrden_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('teleport_in_sand_ACS');
			parent.PlayEffect('teleport_out_sand_ACS');
			parent.PlayEffect('quicksand_yrden_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('teleport_in_fire_ACS');
			parent.PlayEffect('teleport_out_fire_ACS');
			parent.PlayEffect('quicksand_yrden_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');

			parent.PlayEffect('blast_lv3_aard');

			parent.PlayEffect('blast_lv3_damage_aard');

			parent.PlayEffect('blast_lv3_power_aard');

			parent.PlayEffect('blast_ground_aard');

			parent.PlayEffect('blast_ground_mutation_6_aard');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Mega_Gust_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.1; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.1; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('teleport_in_water_ACS');

					ent.PlayEffect('teleport_out_water_ACS');

					ent.PlayEffect('quicksand_yrden_water_ACS');

					if (!actortarget.HasBuff(EET_Confusion))
					{
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('teleport_in_sand_ACS');

					ent.PlayEffect('teleport_out_sand_ACS');

					ent.PlayEffect('quicksand_yrden_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('teleport_in_fire_ACS');

					ent.PlayEffect('teleport_out_fire_ACS');

					ent.PlayEffect('quicksand_yrden_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					GetWitcherPlayer().SoundEvent("magic_eredin_icespike_tell_explosion");

					ent.PlayEffect('ice_line');

					ent.PlayEffect('ice_spikes');

					ent.PlayEffect('ice_explode');

					ent.PlayEffect('ice_explode_2');

					ent.PlayEffect('blast_ground_mutation_6_aard');

					ent.PlayEffect('cone_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 0.5 );
					}
				}

				ent.DestroyAfter(10);
				
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Quicksand in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var animcomp 																																						: CAnimatedComponent;
	private var proj_1																																							: W3ACSIceStaffIceMeteorProjectile;
	private var initpos, targetPositionNPC																																		: Vector;
	private var entity, entity_2 : CEntity;
	private var iceSpike, iceSpike_2 : W3ACSIceStaffIceSpike;
	private var pos, pos_2 : Vector;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_GetItem_MageStaff_Ice())
		{
			ACS_Mage_Attack_Ice_Spikes_Latent();
		}
		else
		{
			ACS_Mage_Attack_Quicksand_Latent();
		}
	}

	latent function dolphin_spawn_quicksand_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	latent function dolphin_spawn_quicksand_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	latent function dolphin_spawn_quicksand_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	latent function dolphin_spawn_quicksand_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	entry function ACS_Mage_Attack_Ice_Spikes_Latent()
	{
		parent.PlayEffect('ice_appear');

		parent.PlayEffect('ice_disappear');

		parent.PlayEffect('blast_ground_mutation_6_aard');

		parent.PlayEffect('cone_ground_mutation_6_aard');

		parent.PlayEffect('ice_marker_fx');

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 15, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				pos_2 = actortarget.GetWorldPosition();
				pos_2.Z += 1.1;

				entity_2 = (W3ACSIceStaffIceSpike)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spike.w2ent", true ), pos_2, actortarget.GetWorldRotation() );

				ent.PlayEffect('ice_disappear');

				ent.PlayEffect('ice_appear');

				ent.PlayEffect('ice_line');

				ent.PlayEffect('ice_spikes');

				ent.DestroyAfter(10);
			}
		}

		Sleep(2);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_cast' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_cast' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_cast' );

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		parent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Quicksand_Latent()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_quicksand_1();
			dolphin_spawn_quicksand_2();
			dolphin_spawn_quicksand_3();
			dolphin_spawn_quicksand_4();

			parent.PlayEffect('trap_pre_2_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('trap_pre_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('trap_pre_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.Teleport(parent.GetWorldPosition() + Vector(0,0,-1));

			parent.PlayEffect('ice_line');

			parent.PlayEffect('ice_spikes');
		}

		Sleep(1);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_cast' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_cast' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_cast' );

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('quicksand_water_ACS');
			parent.StopEffect('quicksand_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('quicksand_sand_ACS');
			parent.StopEffect('quicksand_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('quicksand_fire_ACS');
			parent.StopEffect('quicksand_fire_ACS');
		}


		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 15, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				animcomp = (CAnimatedComponent)actortarget.GetComponentByClassName('CAnimatedComponent');

				animcomp.FreezePoseFadeIn(0.5f);

				animcomp.UnfreezePoseFadeOut(30.f);

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Quicksand_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('trap_pre_2_water_ACS');
					ent.PlayEffect('quicksand_water_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 3 );
					}
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('trap_pre_sand_ACS');
					ent.PlayEffect('quicksand_sand_ACS');

					if (!actortarget.HasBuff(EET_Bleeding))
					{
						dmg.AddEffectInfo( EET_Bleeding, 3 );
					}
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('trap_pre_fire_ACS');
					ent.PlayEffect('quicksand_fire_ACS');

					if (!actortarget.HasBuff(EET_Burning))
					{
						dmg.AddEffectInfo( EET_Burning, 3 );
					}
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					initpos = actortarget.GetWorldPosition();			
					initpos.Z += 20;
							
					targetPositionNPC = actortarget.GetWorldPosition();
					//targetPositionNPC.Z += 1.1;
							
					proj_1 = (W3ACSIceStaffIceMeteorProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_meteorite.w2ent", true ), initpos );
									
					proj_1.Init(GetWitcherPlayer());
					proj_1.PlayEffectSingle('smoke');
					proj_1.ShootProjectileAtPosition( 0, 20, targetPositionNPC, 500 );
					proj_1.DestroyAfter(10);

					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax * 0.125 );

					ent.PlayEffect('ice_line');

					ent.PlayEffect('ice_spikes');

					ent.PlayEffect('ice_marker_2');

					ent.PlayEffect('blast_ground_mutation_6_aard');

					ent.PlayEffect('cone_ground_mutation_6_aard');

					if (!actortarget.HasBuff(EET_Frozen))
					{
						dmg.AddEffectInfo( EET_Frozen, 3 );
					}
				}

				ent.DestroyAfter(30);
				
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(30);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_SandCage in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var animcomp 																																						: CAnimatedComponent;
	private var entity, entity_2 : CEntity;
	private var iceSpike, iceSpike_2 : W3ACSIceStaffIceSpike;
	private var pos, pos_2 : Vector;
	private var proj_1																																							: W3ACSIceStaffIceMeteorProjectile;
	private var initpos, targetPositionNPC																																		: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		if (ACS_GetItem_MageStaff_Ice())
		{
			ACS_Mage_Attack_Ice_Meteors_Latent();
		}
		else
		{
			ACS_Mage_Attack_SandCage_Latent();
		}
	}

	latent function dolphin_spawn_sandcage_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_sandcage_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_sandcage_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	latent function dolphin_spawn_sandcage_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(10);
	}

	entry function ACS_Mage_Attack_Ice_Meteors_Latent()
	{
		parent.Teleport(parent.GetWorldPosition() + Vector(0,0,-1));

		parent.PlayEffect('ice_line');

		parent.PlayEffect('ice_spikes');

		parent.PlayEffect('blast_ground_mutation_6_aard');

		parent.PlayEffect('cone_ground_mutation_6_aard');

		parent.PlayEffect('ice_marker_fx');

		Sleep(1);

		thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
		thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
		thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_cast' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_cast' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_cast' );

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		parent.PlayEffect('ice_appear');

		parent.PlayEffect('ice_disappear');

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 15, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				animcomp = (CAnimatedComponent)actortarget.GetComponentByClassName('CAnimatedComponent');

				animcomp.FreezePoseFadeIn(0.5f);

				animcomp.UnfreezePoseFadeOut(30.f);

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Ice_Meteor_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				initpos = actortarget.GetWorldPosition();			
				initpos.Z += 20;
						
				targetPositionNPC = actortarget.GetWorldPosition();
				//targetPositionNPC.Z += 1.1;
						
				proj_1 = (W3ACSIceStaffIceMeteorProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\ice_staff_meteorite.w2ent", true ), initpos );
								
				proj_1.Init(GetWitcherPlayer());
				proj_1.PlayEffectSingle('smoke');
				proj_1.ShootProjectileAtPosition( 0, 20, targetPositionNPC, 500 );
				proj_1.DestroyAfter(10);

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax * 0.0125 );

				ent.PlayEffect('ice_line');

				ent.PlayEffect('ice_spikes');

				ent.PlayEffect('ice_marker_2');

				ent.PlayEffect('blast_ground_mutation_6_aard');

				ent.PlayEffect('cone_ground_mutation_6_aard');

				if (!actortarget.HasBuff(EET_Frozen))
				{
					dmg.AddEffectInfo( EET_Frozen, 3 );
				}

				ent.DestroyAfter(30);
				
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(30);
	}

	entry function ACS_Mage_Attack_SandCage_Latent()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_sandcage_1();
			dolphin_spawn_sandcage_2();
			dolphin_spawn_sandcage_3();
			dolphin_spawn_sandcage_4();

			parent.PlayEffect('trap_pre_2_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('trap_pre_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('trap_pre_fire_ACS');
		}

		Sleep(2);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_cast' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_cast' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_cast' );

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('trap_explode_2_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('trap_explode_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('trap_explode_fire_ACS');
		}

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 15, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		//actors.Clear();

		//actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(12.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Sand_Cage_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.25; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.25; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('trap_explode_2_water_ACS');

					ent.PlayEffect('trap_pre_2_water_ACS');
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('trap_explode_sand_ACS');

					ent.PlayEffect('trap_pre_sand_ACS');

				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('trap_explode_fire_ACS');

					ent.PlayEffect('trap_pre_fire_ACS');
				}

				ent.DestroyAfter(10);

				if (!actortarget.HasBuff(EET_Knockdown))
				{
					dmg.AddEffectInfo( EET_Knockdown, 2 );
				}
				
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Mage_Attack_Tornado in W3ACSMageAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent,ent_2 																																							: CEntity;

	event OnEnterState(prevStateName : name)
	{
		ACS_Mage_Attack_Tornado_Entry();
	}

	latent function dolphin_spawn_tornado_1()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	latent function dolphin_spawn_tornado_2()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 45;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	latent function dolphin_spawn_tornado_3()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * 5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	latent function dolphin_spawn_tornado_4()
	{
		var actor															: CActor; 
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot														: EulerAngles;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\animals\dolphin.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition() + parent.GetWorldRight() * -5 + parent.GetWorldForward() * -5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 225;
		
		ent = theGame.CreateEntity( temp, TraceFloor(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		animcomp.PlaySlotAnimationAsync( 'q703_sorcerer_water_show_magic_to_dolphins_left_to_right_v2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		ent.AddTag('ACS_Mage_Staff_Dolphin');

		ent.DestroyAfter(20);
	}

	entry function ACS_Mage_Attack_Tornado_Entry()
	{
		if (ACS_GetItem_MageStaff_Water())
		{
			dolphin_spawn_tornado_1();
			dolphin_spawn_tornado_2();
			dolphin_spawn_tornado_3();
			dolphin_spawn_tornado_4();

			parent.PlayEffect('trap_pre_2_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			parent.PlayEffect('trap_pre_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('trap_pre_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			parent.PlayEffect('trap_pre_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			parent.Teleport(parent.GetWorldPosition() + Vector(0,0,-1));

			parent.PlayEffect('ice_line');

			parent.PlayEffect('ice_spikes');

			parent.PlayEffect('blast_ground_mutation_6_aard');

			parent.PlayEffect('cone_ground_mutation_6_aard');
		}

		Sleep(2);

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_cast' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_cast' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_cast' );

		ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
		ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
		ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

		if (ACS_GetItem_MageStaff_Water())
		{
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

			parent.PlayEffect('tornado_water_ACS');
			parent.PlayEffect('quicksand_water_ACS');
		}
		else if (ACS_GetItem_MageStaff_Sand())
		{
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

			parent.PlayEffect('tornado_sand_ACS');
			parent.PlayEffect('quicksand_sand_ACS');
		}
		else if (ACS_GetItem_MageStaff_Fire())
		{
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

			parent.PlayEffect('tornado_fire_ACS');
			parent.PlayEffect('quicksand_fire_ACS');
		}
		else if (ACS_GetItem_MageStaff_Ice())
		{
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );
			thePlayer.PlayEffectSingle( 'hand_sand_fx_ice_ACS' );
			thePlayer.StopEffect( 'hand_sand_fx_ice_ACS' );

			parent.PlayEffect('ice_appear');
			parent.PlayEffect('ice_disappear');

			ent.PlayEffect('blast_ground_mutation_6_aard');

			ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\fx\test_rift.w2ent"
				
			, true ), parent.GetWorldPosition() + Vector(0,0,10) );

			ent_2.PlayEffect('test_rift_2');

			ent_2.DestroyAfter(20);

			thePlayer.SoundEvent("magic_caranthil_teleport_fx_stop");

			thePlayer.SoundEvent("magic_caranthil_teleport_fx_start");

			parent.AddTimer('ice_rift_stop_sound', 19, false);
		}

		parent.AddTimer('tornado_target_check', 0.1, true);

		actors.Clear();

		actors = parent.MageAttackGetNPCsAndPlayersInRange( 15, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);
		
		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Mage_Tornado_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.25; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.25; 
				} 

				dmg.SetForceExplosionDismemberment();

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actortarget.GetWorldPosition(), thePlayer.GetWorldRotation() );

				if (ACS_GetItem_MageStaff_Water())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('teleport_in_water_ACS');
					ent.PlayEffect('teleport_out_water_ACS');
					ent.PlayEffect('quicksand_yrden_water_ACS');
					ent.PlayEffect('quicksand_water_ACS');
					ent.PlayEffect('trap_pre_2_water_ACS');
				}
				else if (ACS_GetItem_MageStaff_Sand())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_ELEMENTAL, damageMax );

					ent.PlayEffect('teleport_in_sand_ACS');
					ent.PlayEffect('teleport_out_sand_ACS');
					ent.PlayEffect('quicksand_yrden_sand_ACS');
					ent.PlayEffect('quicksand_sand_ACS');
					ent.PlayEffect('trap_pre_sand_ACS');
				}
				else if (ACS_GetItem_MageStaff_Fire())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

					ent.PlayEffect('teleport_in_fire_ACS');
					ent.PlayEffect('teleport_out_fire_ACS');
					ent.PlayEffect('quicksand_yrden_fire_ACS');
					ent.PlayEffect('quicksand_fire_ACS');
					ent.PlayEffect('trap_pre_fire_ACS');
				}
				else if (ACS_GetItem_MageStaff_Ice())
				{
					dmg.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageMax );

					ent.PlayEffect('ice_disappear');
					ent.PlayEffect('ice_appear');
					ent.PlayEffect('ice_line');
					ent.PlayEffect('ice_spikes');
				}

				ent.DestroyAfter(10);

				if (!actortarget.HasBuff(EET_Knockdown))
				{
					dmg.AddEffectInfo( EET_Knockdown, 2 );
				}
				
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(20);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

statemachine class CACSSorcFistAttacks extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);

		AddTimer('tag_check', 0.0001, true);
	}

	private timer function tag_check( dt : float , optional id : int)
	{
		if (!this.HasTag('ACS_Sorc_Attack_Activated'))
		{
			if (this.HasTag('ACS_Sorc_Slash_Left'))
			{
				this.PushState('ACS_Sorc_Slash_Left');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Slash_Right'))
			{
				this.PushState('ACS_Sorc_Slash_Right');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Lightning'))
			{
				this.PushState('ACS_Sorc_Lightning');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Lightning_Chain'))
			{
				this.PushState('ACS_Sorc_Lightning_Chain');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Fireball'))
			{
				this.PushState('ACS_Sorc_Fireball');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Meteor_Small'))
			{
				this.PushState('ACS_Sorc_Meteor_Small');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Fire_Line_Right'))
			{
				this.PushState('ACS_Sorc_Fire_Line_Right');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Fire_Line_Left'))
			{
				this.PushState('ACS_Sorc_Fire_Line_Left');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Frost_Line_Right'))
			{
				this.PushState('ACS_Sorc_Frost_Line_Right');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Frost_Line_Left'))
			{
				this.PushState('ACS_Sorc_Frost_Line_Left');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Fire_Double_Line'))
			{
				this.PushState('ACS_Sorc_Fire_Double_Line');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Frost_Double_Line'))
			{
				this.PushState('ACS_Sorc_Frost_Double_Line');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Fire_Blast'))
			{
				this.PushState('ACS_Sorc_Fire_Blast');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Lightning_Strike'))
			{
				this.PushState('ACS_Sorc_Lightning_Strike');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Lightning_Strike_Mult'))
			{
				this.PushState('ACS_Sorc_Lightning_Strike_Mult');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Lightning_Storm'))
			{
				this.PushState('ACS_Sorc_Lightning_Storm');
				stop_tag_check();
				return;
			}

			if (this.HasTag('ACS_Sorc_Fire_Repel'))
			{
				this.PushState('ACS_Sorc_Fire_Repel');
				stop_tag_check();
				return;
			}

		}
	}

	private function stop_tag_check()
	{
		RemoveTimer('tag_check');
		this.AddTag('ACS_Sorc_Attack_Activated');

		this.DestroyAfter(20);
	}

	function SorcAttackGetNPCsAndPlayersInRange(range : float, optional maxResults : int, optional tag : name, optional queryFlags : int) : array <CActor>
	{
		var i : int;
		var actors : array<CActor>;
		var entities : array<CGameplayEntity>;
		var actorEnt : CActor;
	
		
		if((queryFlags & FLAG_Attitude_Neutral) == 0 && (queryFlags & FLAG_Attitude_Hostile) == 0 && (queryFlags & FLAG_Attitude_Friendly) == 0)
			queryFlags = queryFlags | FLAG_Attitude_Neutral | FLAG_Attitude_Hostile | FLAG_Attitude_Friendly;

		
		if(maxResults <= 0)
			maxResults = 1000000;
			
		entities.Clear();
		FindGameplayEntitiesInSphere(entities, GetWorldPosition(), range, maxResults, tag, FLAG_ExcludePlayer + queryFlags);
		entities.Remove( this );
		entities.Remove( thePlayer );
		
		for(i=0; i<entities.Size(); i+=1)
		{
			actorEnt = (CActor)entities[i];

			if(!actorEnt)
			{
				entities.Remove( actorEnt );
			}
			else
			{
				actors.PushBack(actorEnt);
			}	
		}
		
		return actors;
	}
}

state ACS_Sorc_Slash_Left in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Slash_Left_Entry();
	}

	entry function ACS_Sorc_Slash_Left_Entry()
	{
		Sleep(1);

		parent.PlayEffect('diagonal_up_right');

		parent.PlayEffect('diagonal_down_right');

		parent.PlayEffect('right');

		parent.SoundEvent("magic_sorceress_vfx_arcane_explode");

		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 5, 2, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Left_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('diagonal_up_right');

				ent.PlayEffect('diagonal_down_right');

				ent.PlayEffect('right');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Slash_Right in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Slash_Right_Entry();
	}

	entry function ACS_Sorc_Slash_Right_Entry()
	{
		Sleep(1);

		parent.PlayEffect('diagonal_up_left');

		parent.PlayEffect('diagonal_down_left');

		parent.PlayEffect('left');

		parent.SoundEvent("magic_sorceress_vfx_arcane_explode");
		
		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 5, 2, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Right_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('diagonal_up_left');

				ent.PlayEffect('diagonal_down_left');

				ent.PlayEffect('left');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Lightning in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Lightning_Entry();
	}

	entry function ACS_Sorc_Lightning_Entry()
	{
		Sleep(1);

		parent.PlayEffect('diagonal_up_left');

		parent.PlayEffect('diagonal_down_left');

		parent.PlayEffect('left');

		parent.PlayEffect('diagonal_up_right');

		parent.PlayEffect('diagonal_down_right');

		parent.PlayEffect('right');

		parent.PlayEffect('down');

		parent.PlayEffect('up');

		ACSGetCEntity('ACS_Sorc_Fist_Fx_1').PlayEffectSingle('lightning_red', parent );
		ACSGetCEntity('ACS_Sorc_Fist_Fx_1').StopEffect('lightning_red');

		parent.SoundEvent("magic_sorceress_vfx_arcane_explode");
		
		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 5, 3, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Right_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('diagonal_up_left');

				ent.PlayEffect('diagonal_down_left');

				ent.PlayEffect('left');

				ent.PlayEffect('diagonal_up_right');

				ent.PlayEffect('diagonal_down_right');

				ent.PlayEffect('right');

				ent.PlayEffect('down');

				ent.PlayEffect('up');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Lightning_Chain in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Lightning_Chain_Entry();
	}

	entry function ACS_Sorc_Lightning_Chain_Entry()
	{
		Sleep(1.75);

		parent.PlayEffect('diagonal_up_left');

		parent.PlayEffect('diagonal_down_left');

		parent.PlayEffect('left');

		parent.PlayEffect('diagonal_up_right');

		parent.PlayEffect('diagonal_down_right');

		parent.PlayEffect('right');

		parent.PlayEffect('down');

		parent.PlayEffect('up');

		ACSGetCEntity('ACS_Sorc_Fist_Fx_1').PlayEffectSingle('lightning_red', parent );
		ACSGetCEntity('ACS_Sorc_Fist_Fx_1').StopEffect('lightning_red');

		ACSGetCEntity('ACS_Sorc_Fist_Fx_2').PlayEffectSingle('lightning_red', parent );
		ACSGetCEntity('ACS_Sorc_Fist_Fx_2').StopEffect('lightning_red');

		parent.SoundEvent("magic_sorceress_vfx_arcane_explode");
		
		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Right_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				parent.PlayEffectSingle('lightning_red', ent );
				parent.StopEffect('lightning_red');

				//ACSGetCEntity('ACS_Sorc_Fist_Fx_1').PlayEffectSingle('lightning_red', ent );
				//ACSGetCEntity('ACS_Sorc_Fist_Fx_1').StopEffect('lightning_red');

				//ACSGetCEntity('ACS_Sorc_Fist_Fx_2').PlayEffectSingle('lightning_red', ent );
				//ACSGetCEntity('ACS_Sorc_Fist_Fx_2').StopEffect('lightning_red');

				ent.PlayEffect('diagonal_up_left');

				ent.PlayEffect('diagonal_down_left');

				ent.PlayEffect('left');

				ent.PlayEffect('diagonal_up_right');

				ent.PlayEffect('diagonal_down_right');

				ent.PlayEffect('right');

				ent.PlayEffect('down');

				ent.PlayEffect('up');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Fireball in CACSSorcFistAttacks
{
	private var targetPositionArray : array<Vector>;
	private var sizeProjectileArray, idx : int;
	private var proj_1 : W3ACSFireball;
	private var initpos, targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5 : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Fireball_Entry();
	}

	entry function ACS_Sorc_Fireball_Entry()
	{
		Sleep(1);

		targetPosition_1 = parent.GetWorldPosition();

		targetPosition_1.Z -= 1;

		targetPosition_2 = parent.GetWorldPosition() + parent.GetWorldRight() * 2.5;

		targetPosition_2.Z -= 1;

		targetPosition_3 = parent.GetWorldPosition() + parent.GetWorldRight() * -2.5;

		targetPosition_3.Z -= 1;

		targetPosition_4 = parent.GetWorldPosition() + parent.GetWorldRight() * 5;

		targetPosition_4.Z -= 1;

		targetPosition_5 = parent.GetWorldPosition() + parent.GetWorldRight() * -5;

		targetPosition_5.Z -= 1;


		initpos = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() + thePlayer.GetWorldForward() * 2;	

		initpos.Z += 1.25;


		targetPositionArray.Clear();

		targetPositionArray.PushBack(targetPosition_1);
		targetPositionArray.PushBack(targetPosition_2);
		targetPositionArray.PushBack(targetPosition_3);
		targetPositionArray.PushBack(targetPosition_4);
		targetPositionArray.PushBack(targetPosition_5);

		sizeProjectileArray = targetPositionArray.Size();

		for(idx = 0; idx < sizeProjectileArray; idx += 1)
		{
			proj_1 = (W3ACSFireball)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\elemental_fireball_red_proj.w2ent", true ), initpos );

			proj_1.Init(thePlayer);
			proj_1.PlayEffectSingle('fire_fx');

			proj_1.ShootProjectileAtPosition( 0, 15, targetPositionArray[idx], 500 );
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Meteor_Small in CACSSorcFistAttacks
{
	private var proj_1 : W3ACSChaosMeteorProjectile;
	private var initpos, targetPosition : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Meteor_Small_Entry();
	}

	entry function ACS_Sorc_Meteor_Small_Entry()
	{
		Sleep(1);

		targetPosition = parent.GetWorldPosition();

		targetPosition.Z -= 1;

		initpos = thePlayer.GetBoneWorldPosition('r_weapon');	

		//initpos.Y += 1.5;
				
		proj_1 = (W3ACSChaosMeteorProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meteorite_small.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_fx');

		proj_1.ShootProjectileAtPosition( 0, 30, targetPosition, 500 );

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Fire_Line_Right in CACSSorcFistAttacks
{
	private var proj_prep, proj_1 : W3ACSFireLine;
	private var initpos, targetPosition : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Fire_Line_Right_Entry();
	}

	entry function ACS_Sorc_Fire_Line_Right_Entry()
	{
		targetPosition = parent.GetWorldPosition();

		initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1)  + (GetWitcherPlayer().GetWorldRight() * 1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	
				
		proj_1 = (W3ACSFireLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_fire_line_proj.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_line');
		proj_1.DestroyAfter(5);
		
		Sleep(1.5);

		proj_1.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Fire_Line_Left in CACSSorcFistAttacks
{
	private var proj_prep, proj_1 : W3ACSFireLine;
	private var initpos, targetPosition : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Fire_Line_Left_Entry();
	}

	entry function ACS_Sorc_Fire_Line_Left_Entry()
	{
		targetPosition = parent.GetWorldPosition();

		initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1)  + (GetWitcherPlayer().GetWorldRight() * -1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	
				
		proj_1 = (W3ACSFireLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_fire_line_proj.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_line');
		proj_1.DestroyAfter(5);

		Sleep(1.5);

		proj_1.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Frost_Line_Right in CACSSorcFistAttacks
{
	private var proj_prep, proj_1 : W3ACSEredinFrostLine;
	private var initpos, targetPosition : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Frost_Line_Right_Entry();
	}

	entry function ACS_Sorc_Frost_Line_Right_Entry()
	{
		targetPosition = parent.GetWorldPosition();

		initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1)  + (GetWitcherPlayer().GetWorldRight() * 1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	
				
		proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_ice_line_proj.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_line');
		proj_1.DestroyAfter(5);

		Sleep(1.5);

		proj_1.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Frost_Line_Left in CACSSorcFistAttacks
{
	private var proj_prep, proj_1 : W3ACSEredinFrostLine;
	private var initpos, targetPosition : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Frost_Line_Left_Entry();
	}

	entry function ACS_Sorc_Frost_Line_Left_Entry()
	{
		targetPosition = parent.GetWorldPosition();

		initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1)  + (GetWitcherPlayer().GetWorldRight() * -1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	
				
		proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_ice_line_proj.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_line');
		proj_1.DestroyAfter(5);

		Sleep(1.5);

		proj_1.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Fire_Double_Line in CACSSorcFistAttacks
{
	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Fire_Double_Line_Entry_1();

		parent.DestroyAfter(10);
	}

	entry function ACS_Sorc_Fire_Double_Line_Entry_1()
	{
		var proj_1, proj_2 : W3ACSFireLine;
		var initpos_1, initpos_2, targetPosition : Vector;

		targetPosition = parent.GetWorldPosition();

		initpos_1 = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + (GetWitcherPlayer().GetWorldRight() * 1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	

		initpos_2 = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + (GetWitcherPlayer().GetWorldRight() * -1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	
				
		proj_1 = (W3ACSFireLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_fire_line_proj.w2ent", true ), initpos_1 );

		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_line');
		proj_1.DestroyAfter(5);

		proj_2 = (W3ACSFireLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_fire_line_proj.w2ent", true ), initpos_2 );

		proj_2.Init(thePlayer);
		proj_2.PlayEffectSingle('fire_line');
		proj_2.DestroyAfter(5);

		Sleep(1.5);

		proj_1.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

		proj_2.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Frost_Double_Line in CACSSorcFistAttacks
{
	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Frost_Double_Line_Entry_1();

		parent.DestroyAfter(10);
	}

	entry function ACS_Sorc_Frost_Double_Line_Entry_1()
	{
		var proj_1, proj_2 : W3ACSEredinFrostLine;
		var initpos_1, initpos_2, targetPosition : Vector;

		targetPosition = parent.GetWorldPosition();

		initpos_1 = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + (GetWitcherPlayer().GetWorldRight() * 1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	

		initpos_2 = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + (GetWitcherPlayer().GetWorldRight() * -1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;	
				
		proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_ice_line_proj.w2ent", true ), initpos_1 );

		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_line');
		proj_1.DestroyAfter(5);


		proj_2 = (W3ACSEredinFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_armor_ice_line_proj.w2ent", true ), initpos_2 );

		proj_2.Init(thePlayer);
		proj_2.PlayEffectSingle('fire_line');
		proj_2.DestroyAfter(5);

		Sleep(1.5);

		proj_1.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

		proj_2.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Fire_Blast in CACSSorcFistAttacks
{
	private var proj_1 : W3ACSChaosMeteorProjectile;
	private var initpos, targetPosition : Vector;

	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Fire_Blast_Entry();
	}

	entry function ACS_Sorc_Fire_Blast_Entry()
	{
		Sleep(1.25);

		targetPosition = parent.GetWorldPosition();

		targetPosition.Z -= 1;

		initpos = thePlayer.GetBoneWorldPosition('r_weapon');	

		//initpos.Y += 1.5;
				
		proj_1 = (W3ACSChaosMeteorProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meteorite.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_fx');

		proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Lightning_Strike in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Lightning_Strike_Entry();
	}

	entry function ACS_Sorc_Lightning_Strike_Entry()
	{
		var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
		var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
		var i, count, count_2, j, k													: int;
		var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
		var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
		var adjustedRot, playerRot2													: EulerAngles;
		var params 																	: SCustomEffectParams;


		Sleep(1.5);

		parent.PlayEffect('diagonal_up_left');

		parent.PlayEffect('diagonal_down_left');

		parent.PlayEffect('left');

		parent.PlayEffect('diagonal_up_right');

		parent.PlayEffect('diagonal_down_right');

		parent.PlayEffect('right');

		parent.PlayEffect('down');

		parent.PlayEffect('up');



		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike_secondary.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_ground_fire.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = RandRangeF(360,1);
		adjustedRot.Pitch = RandRangeF(22.5,-22.5);

		playerRot2 = EulerAngles(0,0,0);
		playerRot2.Yaw = RandRangeF(360,1);

			
		posAdjusted = ACSPlayerFixZAxis(playerPos);

		ent_1 = theGame.CreateEntity( temp, posAdjusted, adjustedRot );

		ent_1.PlayEffectSingle('pre_lightning');
		ent_1.PlayEffectSingle('lightning');

		ent_1.DestroyAfter(10);


		ent_2 = theGame.CreateEntity( temp_2, posAdjusted, playerRot2 );

		ent_2.PlayEffectSingle('lighgtning');

		ent_2.DestroyAfter(10);

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( posAdjusted, 0.5f, 10.5f, 0.5f, 7.f, 1);

		count_2 = 12;

		for( j = 0; j < count_2; j += 1 )
		{
			randRange_2 = 2 + 2 * RandF();
			randAngle_2 = 2 * Pi() * RandF();
			
			spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + posAdjusted.X;
			spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + posAdjusted.Y;
			//spawnPos2.Z = posAdjusted.Z;

			posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

			ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, EulerAngles(0,0,0) );

			if (RandF() < 0.5)
			{
				ent_4.PlayEffectSingle('explosion');
				ent_4.StopEffect('explosion');
			}
			else
			{
				if (RandF() < 0.5)
				{
					ent_4.PlayEffectSingle('explosion_big');
					ent_4.StopEffect('explosion_big');
				}
				else
				{
					ent_4.PlayEffectSingle('explosion_medium');
					ent_4.StopEffect('explosion_medium');
				}
			}

			ent_4.DestroyAfter(20);
		}
		
		parent.SoundEvent( "fx_amb_thunder_close" );

		parent.SoundEvent( "qu_nml_103_lightning" );



		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 5, 4, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Left_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.25; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.25; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('diagonal_up_left');

				ent.PlayEffect('diagonal_down_left');

				ent.PlayEffect('left');

				ent.PlayEffect('diagonal_up_right');

				ent.PlayEffect('diagonal_down_right');

				ent.PlayEffect('right');

				ent.PlayEffect('down');

				ent.PlayEffect('up');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Lightning_Strike_Mult in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Lightning_Strike_Mult_Entry();
	}

	entry function ACS_Sorc_Lightning_Strike_Mult_Entry()
	{
		var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
		var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
		var i, count, count_2, j, k													: int;
		var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
		var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
		var adjustedRot, playerRot2													: EulerAngles;
		var params 																	: SCustomEffectParams;

		Sleep(1.5);

		parent.PlayEffect('diagonal_up_left');

		parent.PlayEffect('diagonal_down_left');

		parent.PlayEffect('left');

		parent.PlayEffect('diagonal_up_right');

		parent.PlayEffect('diagonal_down_right');

		parent.PlayEffect('right');

		parent.PlayEffect('down');

		parent.PlayEffect('up');

		parent.SoundEvent( "fx_amb_thunder_close" );

		parent.SoundEvent( "qu_nml_103_lightning" );

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike_secondary.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_ground_fire.w2ent"
			
		, true );

		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Left_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.125; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.125; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('diagonal_up_left');

				ent.PlayEffect('diagonal_down_left');

				ent.PlayEffect('left');

				ent.PlayEffect('diagonal_up_right');

				ent.PlayEffect('diagonal_down_right');

				ent.PlayEffect('right');

				ent.PlayEffect('down');

				ent.PlayEffect('up');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);

				playerPos = actortarget.GetWorldPosition();

				adjustedRot = EulerAngles(0,0,0);

				adjustedRot.Yaw = RandRangeF(360,1);
				adjustedRot.Pitch = RandRangeF(22.5,-22.5);

				playerRot2 = EulerAngles(0,0,0);
				playerRot2.Yaw = RandRangeF(360,1);

					
				posAdjusted = ACSPlayerFixZAxis(playerPos);

				ent_1 = theGame.CreateEntity( temp, posAdjusted, adjustedRot );

				ent_1.PlayEffectSingle('pre_lightning');
				ent_1.PlayEffectSingle('lightning');

				ent_1.DestroyAfter(10);


				ent_2 = theGame.CreateEntity( temp_2, posAdjusted, playerRot2 );

				ent_2.PlayEffectSingle('lighgtning');

				ent_2.DestroyAfter(10);

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( posAdjusted, 0.5f, 10.5f, 0.5f, 7.f, 1);

				count_2 = 12;

				for( j = 0; j < count_2; j += 1 )
				{
					randRange_2 = 2 + 2 * RandF();
					randAngle_2 = 2 * Pi() * RandF();
					
					spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + posAdjusted.X;
					spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + posAdjusted.Y;
					//spawnPos2.Z = posAdjusted.Z;

					posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

					ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, EulerAngles(0,0,0) );

					if (RandF() < 0.5)
					{
						ent_4.PlayEffectSingle('explosion');
						ent_4.StopEffect('explosion');
					}
					else
					{
						if (RandF() < 0.5)
						{
							ent_4.PlayEffectSingle('explosion_big');
							ent_4.StopEffect('explosion_big');
						}
						else
						{
							ent_4.PlayEffectSingle('explosion_medium');
							ent_4.StopEffect('explosion_medium');
						}
					}

					ent_4.DestroyAfter(20);
				}
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Lightning_Storm in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent 																																							: CEntity;
	private var actorpos 																																						: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Lightning_Storm_Entry();
	}

	entry function ACS_Sorc_Lightning_Storm_Entry()
	{
		var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
		var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
		var i, count, count_2, j, k													: int;
		var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
		var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
		var adjustedRot, playerRot2													: EulerAngles;
		var params 																	: SCustomEffectParams;


		Sleep(2);

		parent.PlayEffect('diagonal_up_left');

		parent.PlayEffect('diagonal_down_left');

		parent.PlayEffect('left');

		parent.PlayEffect('diagonal_up_right');

		parent.PlayEffect('diagonal_down_right');

		parent.PlayEffect('right');

		parent.PlayEffect('down');

		parent.PlayEffect('up');



		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_lightning_strike_secondary.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\everstorm_ground_fire.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = RandRangeF(360,1);
		adjustedRot.Pitch = RandRangeF(22.5,-22.5);

		playerRot2 = EulerAngles(0,0,0);
		playerRot2.Yaw = RandRangeF(360,1);

			
		posAdjusted = ACSPlayerFixZAxis(playerPos);

		ent_1 = theGame.CreateEntity( temp, posAdjusted, adjustedRot );

		ent_1.PlayEffectSingle('pre_lightning');
		ent_1.PlayEffectSingle('lightning');

		ent_1.DestroyAfter(10);


		ent_2 = theGame.CreateEntity( temp_2, posAdjusted, playerRot2 );

		ent_2.PlayEffectSingle('lighgtning');

		ent_2.DestroyAfter(10);

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( posAdjusted, 0.5f, 10.5f, 0.5f, 7.f, 1);

		count_2 = 12;

		for( j = 0; j < count_2; j += 1 )
		{
			randRange_2 = 2 + 2 * RandF();
			randAngle_2 = 2 * Pi() * RandF();
			
			spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + posAdjusted.X;
			spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + posAdjusted.Y;
			//spawnPos2.Z = posAdjusted.Z;

			posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

			ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, EulerAngles(0,0,0) );

			if (RandF() < 0.5)
			{
				ent_4.PlayEffectSingle('explosion');
				ent_4.StopEffect('explosion');
			}
			else
			{
				if (RandF() < 0.5)
				{
					ent_4.PlayEffectSingle('explosion_big');
					ent_4.StopEffect('explosion_big');
				}
				else
				{
					ent_4.PlayEffectSingle('explosion_medium');
					ent_4.StopEffect('explosion_medium');
				}
			}

			ent_4.DestroyAfter(20);
		}
		
		parent.SoundEvent( "fx_amb_thunder_close" );

		parent.SoundEvent( "qu_nml_103_lightning" );



		actors.Clear();

		actors = parent.SorcAttackGetNPCsAndPlayersInRange( 5, 4, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		actors.Remove(thePlayer);

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Left_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.25; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.25; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('diagonal_up_left');

				ent.PlayEffect('diagonal_down_left');

				ent.PlayEffect('left');

				ent.PlayEffect('diagonal_up_right');

				ent.PlayEffect('diagonal_down_right');

				ent.PlayEffect('right');

				ent.PlayEffect('down');

				ent.PlayEffect('up');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		GetACSWatcher().red_lightning_storm();

		parent.DestroyAfter(20);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sorc_Fire_Repel in CACSSorcFistAttacks
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent, ent_1, ent_2, ent_3 																																							: CEntity;
	private var actorpos 																																						: Vector;


	event OnEnterState(prevStateName : name)
	{
		ACS_Sorc_Fire_Repel_Entry();
	}

	entry function ACS_Sorc_Fire_Repel_Entry()
	{
		Sleep(0.125);

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\pc_igni_mq1060.w2ent"
		, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		ent_1.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,90,0) );

		ent_1.PlayEffectSingle('cone_1_red');
		ent_1.PlayEffectSingle('cone_power_2_red');

		ent_1.StopEffect('cone_1_red');
		ent_1.StopEffect('cone_power_2_red');


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent"
		, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		ent_2.CreateAttachment( thePlayer, , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		ent_2.PlayEffect('cone');

		ent_2.DestroyAfter(5);


		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\knightmare_scream_attack.w2ent"
		, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		ent_3.CreateAttachment( thePlayer, , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent_3.PlayEffect('cone');

		ent_3.PlayEffect('fx_push');

		ent_3.DestroyAfter(1);


		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInCone(6, VecHeading(thePlayer.GetHeadingVector()), 100, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus) * 0.05 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Mage_Staff_Dolphin') 
				|| actortarget == thePlayer
				)
				continue;

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Sorc_Slash_Left_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality )) * 0.05; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = (actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence )) * 0.05; 
				} 

				dmg.SetForceExplosionDismemberment();

				actorpos = actortarget.GetWorldPosition();

				actorpos.Z += 1.25;

				ent = theGame.CreateEntity( 
			
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), 
				
				actorpos, thePlayer.GetWorldRotation() );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				ent.PlayEffect('left');

				ent.PlayEffect('right');

				ent.PlayEffect('down');

				ent.PlayEffect('up');

				if (!actortarget.HasBuff(EET_Burning))
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}

				ent.DestroyAfter(10);
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}

		parent.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}