class SwordProjectile extends W3AdvancedProjectile
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
	private var giant_sword	 																																				: SwordProjectileGiant;
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
					
					giant_sword = (SwordProjectileGiant)theGame.CreateEntity( 
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
			
			dmg.Initialize(GetWitcherPlayer(), victim, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_SpellPower, true, false, false, false);
			
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

class SwordProjectileGiant extends W3AdvancedProjectile
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

			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);

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
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);
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
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
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
	}

	timer function attack ( dt : float, optional id : int)
	{
		var entities	 		: array<CGameplayEntity>;
		var i					: int;
		
		FindGameplayEntitiesInSphere( entities, GetWorldPosition(), 5, 50 );
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
			&& victimtarget != GetACSSummonedConstruct_1()
			&& victimtarget != GetACSSummonedConstruct_2()
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
		else
		{
			if ( victimtarget && victimtarget.IsAlive() 
			&& victimtarget != GetACSHeartOfDarkness() 
			&& victimtarget != GetACSHeartOfDarknessGuardianBloodHymSmall() 
			&& victimtarget != GetACSHeartOfDarknessGuardianBloodHymLarge() 
			) 
			{
				if( VecDistance( GetACSHeartOfDarknessArenaAppearance_01().GetWorldPosition(), victimtarget.GetWorldPosition() ) > 15.0f )
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
				action.Initialize(GetACSHeartOfDarkness(),victimtarget,this,GetACSHeartOfDarkness().GetName(),EHRT_Heavy,CPS_Undefined,false, false, true, false );
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

			if (victim == GetACSCanaris())
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

			CreateKnife();

			RemoveTimer('playredtrail');
			
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
		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) && victim != ACSFireBear() )
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

		if ( victim && !hitCollisionsGroups.Contains( 'Static' ) && !projectileHitGround && !collidedEntities.Contains(victim) && victim != ACSFireBear() )
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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
		
		if ( victim == GetWitcherPlayer() )
		{
			projDMG = projDMG - (projDMG * decreasePlayerDmgBy);
		}
		else if ( victim == ACSFireBear() )
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

		if (ACSFireBear())
		{
			if (ACSFireBear().IsAlive())
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

		if (ACSFireBear())
		{
			if (ACSFireBear().IsAlive())
			{
				RemoveTimer('firebearteleport');

				ACSFireBear().EnableCharacterCollisions(true); 

				ACSFireBear().EnableCollisions(true);

				//ACSFireBear().TeleportWithRotation( this.GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

				ACSFireBear().SetVisibility(true);

				animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.UnfreezePose();

				movementAdjustorNPC = ACSFireBear().GetMovingAgentComponent().GetMovementAdjustor();

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Spawn_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Spawn_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Spawn_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				animatedComponentA.PlaySlotAnimationAsync ( 'bear_special_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				ACSFireBear().PlayEffect('burning_body');
				ACSFireBear().PlayEffect('flames');
				ACSFireBear().PlayEffect('critical_burning');
				ACSFireBear().PlayEffect('demonic_possession');

				ACSFireBear().AddEffectDefault( EET_FireAura, ACSFireBear(), 'acs_fire_bear_fire_aura' );

				((CNewNPC)ACSFireBear()).NoticeActor(GetWitcherPlayer());

				((CActor)ACSFireBear()).ActionMoveToNodeWithHeadingAsync(GetWitcherPlayer());

				GetACSWatcher().SetFireBearMeteorProcess(false);

				if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
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

		ACSFireBear().Destroy();

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

		ACSFireBear().TeleportWithRotation(pos, ACSFireBear().GetWorldRotation());
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

		if (ACSFireBear().IsAlive())
		{
			//pos = GetWitcherPlayer().GetWorldPosition();

			//pos.Z += 150;

			//ACSFireBear().TeleportWithRotation(pos, GetWitcherPlayer().GetWorldRotation());

			AddTimer('firebearteleport', 0.000001, true);

			//AddTimer('firebearinvis', 1.5, false);

			GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');

			GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');

			ACSFireBear().StopAllEffects();

			ACSFireBear().RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');

			ACSFireBear().SetVisibility(false);

			animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );

			animatedComponentA.FreezePose();

			AddTimer('meteortrackingdelay', 1, false);
		}
	}

	timer function firebearteleport( deltaTime : float , id : int)
	{
		var pos																: Vector;

		pos = this.GetWorldPosition();

		pos.Z += 3;

		//ACSFireBear().TeleportWithRotation(pos, ACSFireBear().GetWorldRotation());

		ACSFireBear().Teleport(pos);
	}

	timer function firebearinvis( deltaTime : float , id : int)
	{
		ACSFireBear().SetVisibility(false);

		ACSFireBear().StopAllEffects();

		ACSFireBear().RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');
	}

	timer function meteortracking_first( deltaTime : float , id : int)
	{
		var pos 															: Vector;

		pos = ACSFireBear().GetHeadingVector() + ACSFireBear().GetWorldForward() * -100;

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

		pos = ACSFireBear().GetHeadingVector() + ACSFireBear().GetWorldForward() * 200;

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
			
			if ( l_actor == ACSFireBear() ) continue;
			
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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);

		if ( victim == GetACSCanaris() 
		|| victim == GetACSCanarisMinion()
		|| victim == GetACSCanarisGolem()
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
	
	default explodeAfter = 2.0;
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
			if( actor 
			&& actor != GetACSCanaris()
			&& actor != GetACSCanarisMinion()
			&& actor != GetACSCanarisGolem()
			&& actor != GetACSIceBoar()
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
			if( actor 
			&& actor != GetACSIceBoar()
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( GetACSIceBoar(), entitiesInRange[i], NULL, this, EHRT_Light, CPS_Undefined, false, false, false, true );
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
			if( actor 
			&& actor != GetACSCanaris()
			&& actor != GetACSCanarisMinion()
			&& actor != GetACSCanarisGolem()
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_Snowstorm, effectDuration );
				damage.AddEffectInfo( EET_Stagger, effectDuration );
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
			if( actor 
			&& actor != GetACSCanaris()
			&& actor != GetACSCanarisMinion()
			&& actor != GetACSCanarisGolem()
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_Snowstorm, effectDuration );
				damage.AddEffectInfo( EET_Stagger, effectDuration );
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
			if( actor 
			&& actor != GetACSCanaris()
			&& actor != GetACSCanarisMinion()
			&& actor != GetACSCanarisGolem()
			)
			{
				damage = new W3DamageAction in this;
				damage.Initialize( this, entitiesInRange[i], NULL, this, EHRT_Heavy, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FROST, damageVal );
				damage.AddEffectInfo( EET_Snowstorm, effectDuration );
				damage.AddEffectInfo( EET_Stagger, effectDuration );
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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
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


			((CNewNPC)ent).SetAttitude(((CNewNPC)GetACSNecrofiend()), AIA_Friendly);

			((CNewNPC)GetACSNecrofiend()).SetAttitude(((CActor)ent), AIA_Friendly);


			((CNewNPC)GetACSNecrofiendTentacle_1()).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CNewNPC)ent).SetAttitude(((CActor)GetACSNecrofiendTentacle_1()), AIA_Friendly);

			((CNewNPC)GetACSNecrofiendTentacle_2()).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CNewNPC)ent).SetAttitude(((CActor)GetACSNecrofiendTentacle_2()), AIA_Friendly);

			((CNewNPC)GetACSNecrofiendTentacle_3()).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CNewNPC)ent).SetAttitude(((CActor)GetACSNecrofiendTentacle_3()), AIA_Friendly);


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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
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
				action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_SpellPower, false, true, false, false );
			}
			else
			{
				action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_None, CPS_SpellPower, false, true, false, false );
			}

			if (((CActor)victim).UsesEssence())
			{
				if (((CActor)victim).GetCurrentHealth() <= ((CActor)victim).GetMaxHealth() * 0.01)
				{
					damage = ((CActor)victim).GetStatMax( BCS_Essence );
				}
				else
				{
					damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.0125;
				}
			}
			else if (((CActor)victim).UsesVitality())
			{
				if (((CActor)victim).GetCurrentHealth() <= ((CActor)victim).GetMaxHealth() * 0.01)
				{
					damage = ((CActor)victim).GetStatMax( BCS_Vitality );
				}
				else
				{
					damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0125;
				}
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
			action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_SpellPower, false, true, false, false );

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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_SpellPower,false,true,false,false);
		
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
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);
		}
		else
		{
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_SpellPower,false,true,false,false);
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
				if (((CActor)victim).GetCurrentHealth() <= ((CActor)victim).GetMaxHealth() * 0.01)
				{
					damage = ((CActor)victim).GetStatMax( BCS_Essence );
				}
				else
				{
					damage = ((CActor)victim).GetStat( BCS_Essence ) * 0.0125;
				}
			}
			else if (((CActor)victim).UsesVitality())
			{
				if (((CActor)victim).GetCurrentHealth() <= ((CActor)victim).GetMaxHealth() * 0.01)
				{
					damage = ((CActor)victim).GetStatMax( BCS_Vitality );
				}
				else
				{
					damage = ((CActor)victim).GetStat( BCS_Vitality ) * 0.0125;
				}
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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);

		if ( victim == thePlayer
		|| victim == GetACSTransformationVampiress()
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

function GetACSChaosTornadoAppearance() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Chaos_Tornado_Appearance' );
	return entity;
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
		GetACSChaosTornadoAppearance().PlayEffectSingle('explode');
		GetACSChaosTornadoAppearance().StopEffect('explode');

		explode();

		GetACSChaosTornadoAppearance().DestroyEffect('swarm_attack');

		RemoveTimer('destroy_app_effect');

		AddTimer('destroy_app_effect', 3 );

		RemoveTimer('target_check');

		SoundEvent("magic_man_tornado_loop_stop");
	}

    timer function destroy_app_effect(deltaTime : float, id : int) 
	{
		GetACSChaosTornadoAppearance().Destroy();
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
		entities_trap.Remove( GetACSTransformationVampiress() );
		entities_trap.Remove( ((CGameplayEntity)GetACSChaosTornadoAppearance()) );
		
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
						|| victim == GetACSTransformationVampiress()
						//|| victim == GetACSChaosTornadoAppearance()
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
						|| victim == GetACSTransformationVampiress()
						//|| victim == GetACSChaosTornadoAppearance()
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
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Heavy,CPS_SpellPower,false,true,false,false);
		}
		else
		{
			action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_None,CPS_SpellPower,false,true,false,false);
		}

		if ( projEfect != EET_Undefined )
		{
			action.AddEffectInfo(projEfect);
		}
		
		if ( victim == thePlayer
		|| victim == GetACSTransformationVampiress()
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
	
	default explodeAfter = 2.0;
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
			&& actor != GetACSTransformationVampiress()
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
		entities_trap.Remove( GetACSTransformationVampiress() );
		
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
						|| victim == GetACSTransformationVampiress()
						//|| victim == GetACSChaosTornadoAppearance()
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
			&& actor != GetACSTransformationVampiress()
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

		action.Initialize( ( CGameplayEntity)caster, victim, this, caster.GetName(), EHRT_Light, CPS_SpellPower, false, true, false, false );

		if ( ((CActor)victim) == thePlayer
		|| ((CActor)victim) == GetACSTransformationVampiress()
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
		entities_trap.Remove( GetACSTransformationVampiress() );
		
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
						|| victim == GetACSTransformationVampiress()
						//|| victim == GetACSChaosTornadoAppearance()
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

function GetACSChaosArenaAppearance_01() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Chaos_Arena_Appearance_01' );
	return entity;
}

function GetACSChaosArenaAppearance_02() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Chaos_Arena_Appearance_02' );
	return entity;
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
		GetACSChaosArenaAppearance_01().PlayEffectSingle('arena_start');
		GetACSChaosArenaAppearance_02().PlayEffectSingle('growing');
	}
	
	timer function clear_hits(deltaTime : float, id : int) 
	{
		aard_hit_ents.Clear();
	}
	
    timer function destroy_arena(deltaTime : float, id : int) 
	{
		GetACSChaosArenaAppearance_01().StopEffect('arena_start');
		GetACSChaosArenaAppearance_01().PlayEffectSingle('arena_end');

		GetACSChaosArenaAppearance_02().StopEffect('growing');
		GetACSChaosArenaAppearance_02().PlayEffectSingle('disappearing');

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
		GetACSChaosArenaAppearance_01().Destroy();

		GetACSChaosArenaAppearance_02().Destroy();

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

		entities_trap.Remove( GetACSTransformationVampiress() );
		
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
					|| victim == GetACSTransformationVampiress()
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
		&& victim != GetACSTransformationToad())
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
		&& victim != GetACSTransformationToad()
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
		action.Initialize((CGameplayEntity)caster,victim,this,caster.GetName(),EHRT_Light,CPS_SpellPower,false,true,false,false);
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