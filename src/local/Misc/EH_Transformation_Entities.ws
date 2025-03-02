statemachine class CACSTransformationBlackWolf extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationBruxa extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{

	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationGiant extends CNewNPC
{
	private var vACS_Spawn_Transformation_Giant  						: cACS_Spawn_Transformation_Giant;

	private var back_weapon_ent, helm, helm_omen            			: CEntity;

	private function GetGiantStatemachine() : cACS_Spawn_Transformation_Giant
	{
		vACS_Spawn_Transformation_Giant = new cACS_Spawn_Transformation_Giant in this;

		return vACS_Spawn_Transformation_Giant;
	}

	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		var attach_rot                        						 	: EulerAngles;
    	var attach_vec													: Vector;
		var meshcomp 													: CComponent;
		var h 															: float;
	

		super.OnSpawned( spawnData );

		SetVisibility(false);

		GetACSWatcher().AddTimer('TransformationGiantReveal', 0.125, false);

		PlayEffect('death');

		PlayEffect('demonic_possession');

		back_weapon_ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\transformation_giant\arena_spot\arena_spot.w2ent"

		, true ), GetWorldPosition() );

		back_weapon_ent.AddTag('ACS_Transformation_Giant_Back_Weapons');

		//back_weapon_ent.PlayEffect('lightning_hit');

		//back_weapon_ent.PlayEffect('charge');

		//back_weapon_ent.PlayEffect('discharge');

		attach_rot.Roll = -75;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 90;

		attach_vec.X = 0;
		attach_vec.Y = 0.25;
		attach_vec.Z = 0;

		back_weapon_ent.CreateAttachment(this, 'weapon_slot', attach_vec, attach_rot);


		helm = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\hellbride.w2ent", true ), GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp = helm.GetComponentByClassName('CMeshComponent');
		h = 2.875;
		meshcomp.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = -15;
		attach_vec.X = -4.375;
		attach_vec.Y = 1;
		attach_vec.Z = 0;	
		
		helm.CreateAttachment( this, 'head', attach_vec, attach_rot );

		helm_omen = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\omen_helm.w2ent", true ), GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp = helm_omen.GetComponentByClassName('CMeshComponent');
		h = 3;
		meshcomp.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = -15;
		attach_vec.X = -5;
		attach_vec.Y = 1.25;
		attach_vec.Z = 0;	
		
		helm_omen.CreateAttachment( this, 'head', attach_vec, attach_rot );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		super.OnTakeDamage(action);
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);

		if(animEventType == AET_DurationStart)
		{
			SoundEvent('monster_cloud_giant_weapon_whoosh_slow');

			if (!this.HasTag('ACS_Transformation_Giant_Weapon_Mode'))
			{
				GetMovingAgentComponent().SetAnimationSpeedMultiplier(1.5); 
			}
		}

		if(animEventType == AET_DurationEnd)
		{
			GetMovingAgentComponent().SetAnimationSpeedMultiplier(1); 
		}

		if (this.HasTag('ACS_Transformation_Giant_Weapon_Mode'))
		{
			if (data.rangeName == 'anchor')
			{
				if(animEventType == AET_DurationStart)
				{
					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit_stone_wheel');

					//ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').DestroyEffect('trail_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('force_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_hit_stone_wheel');

					GiantDealDamage(12.5, 135, 'anchor');

				}

				if(animEventType == AET_DurationEnd)
				{
					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit_stone_wheel');


					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('force_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_hit_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('force_stone_wheel');

					GetGiantStatemachine().TransformationGiantAnchorProjectiles_Engage();
				}
			}
			else if (data.rangeName == 'anchor_far')
			{
				if(animEventType == AET_DurationStart)
				{
					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit_stone_wheel');

					//ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').DestroyEffect('trail_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('force_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_hit_stone_wheel');

				}

				if(animEventType == AET_DurationEnd)
				{
					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit_stone_wheel');


					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('ground_hit_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').StopEffect('force_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('ground_hit_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').PlayEffectSingle('force_stone_wheel');

					GetGiantStatemachine().TransformationGiantAnchorFarProjectiles_Engage();

					GiantDealDamage(15, 90, 'anchor_far');
				}
			}
			else if (data.rangeName == 'l_attack')
			{
				if(animEventType == AET_DurationStart)
				{

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_hit_stone_wheel');


					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_hit_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('force_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').PlayEffectSingle('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').PlayEffectSingle('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').PlayEffectSingle('trail_360_stone_wheel');
				}

				if(animEventType == AET_DurationEnd)
				{
					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_drag');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_hit');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_drag_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('ground_hit_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('trail_360_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').StopEffect('force_stone_wheel');

					ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').PlayEffectSingle('ground_hit_stone_wheel');

					GiantDealDamage(10, 90, 'anchor');
				}
			}
			else if (data.rangeName == 'stomp_heavy')
			{
				if(animEventType == AET_DurationStart)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					PlayEffectSingle('ground_hit_cloud_giant');

					PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					GetGiantStatemachine().TransformationGiantStompHeavyProjectiles_Engage();

					GiantDealDamage(10, 360, 'stomp_heavy');
				}

				if(animEventType == AET_DurationEnd)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					StopEffect('ground_hit_cloud_giant');

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');
				}
			}
			else if (data.rangeName == 'stomp')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					StopEffect('ground_hit_cloud_giant');

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('ground_hit_cloud_giant');

					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

					GetGiantStatemachine().TransformationGiantKickProjectiles_Engage();

					GiantDealDamage(7.5, 360, 'electric_blast');
				}
			}
			else if (data.rangeName == 'kick')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					StopEffect('earthquake_fx');
					
					GetGiantStatemachine().TransformationGiantKickProjectiles_Engage();

					GiantDealDamage(4, 60, 'kick');
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					PlayEffectSingle('earthquake_fx');
				}
			}
			else if (data.rangeName == 'dig')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					

					PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(10, 360, 'electric_blast');
					}
					else
					{
						GiantDealDamage(7.5, 360, 'normal_damage_aoe');
					}
				}
			}
			else
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					

					PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(10, 360, 'electric_blast');
					}
					else
					{
						GiantDealDamage(5, 360, 'normal_damage_aoe');
					}
				}
			}
		}
		else
		{
			if (data.rangeName == 'l_attack')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						DestroyEffect('l_hand_trail_ascended');

						PlayEffectSingle('l_hand_trail_ascended');

						StopEffect('l_hand_trail_ascended');
					}
					else
					{
						DestroyEffect('l_hand_trail');

						PlayEffectSingle('l_hand_trail');

						StopEffect('l_hand_trail');
					}
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('earthquake_fx');

					PlayEffectSingle('force_stone_wheel');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(7.5, 360, 'electric_fist');
					}
					else
					{
						GiantDealDamage(4, 90, 'fist');
					}
				}
			}
			else if (data.rangeName == 'r_attack')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						DestroyEffect('r_hand_trail_ascended');

						PlayEffectSingle('r_hand_trail_ascended');

						StopEffect('r_hand_trail_ascended');
					}
					else
					{
						DestroyEffect('r_hand_trail');

						PlayEffectSingle('r_hand_trail');

						StopEffect('r_hand_trail');
					}
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('earthquake_fx');

					PlayEffectSingle('force_stone_wheel');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(7.5, 360, 'electric_fist');
					}
					else
					{
						GiantDealDamage(4, 90, 'fist');
					}
				}
			}
			else if (data.rangeName == 'charge_attack')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('earthquake_fx');

					if (!IsEffectActive('ground_drag_stone_wheel', false))
					{
						PlayEffectSingle('ground_drag_stone_wheel');
					}

					if (!IsEffectActive('trail_360_stone_wheel_r', false))
					{
						PlayEffectSingle('trail_360_stone_wheel_r');
					}

					if (!IsEffectActive('trail_360_stone_wheel_l', false))
					{
						PlayEffectSingle('trail_360_stone_wheel_l');
					}

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						DestroyEffect('r_hand_trail_ascended');

						DestroyEffect('l_hand_trail_ascended');

						PlayEffectSingle('r_hand_trail_ascended');

						PlayEffectSingle('l_hand_trail_ascended');

						StopEffect('r_hand_trail_ascended');

						StopEffect('l_hand_trail_ascended');
					}
					else
					{
						DestroyEffect('r_hand_trail');

						DestroyEffect('l_hand_trail');

						PlayEffectSingle('r_hand_trail');

						PlayEffectSingle('l_hand_trail');

						StopEffect('r_hand_trail');

						StopEffect('l_hand_trail');
					}
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('earthquake_fx');

					StopEffect('ground_drag_stone_wheel');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(7.5, 360, 'electric_blast');
					}
					else
					{
						GiantDealDamage(5, 360, 'normal_damage_aoe');
					}
				}
			}
			else if (data.rangeName == 'stomp')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						DestroyEffect('r_hand_trail');

						DestroyEffect('l_hand_trail');

						PlayEffectSingle('r_hand_trail_ascended');

						PlayEffectSingle('l_hand_trail_ascended');

						StopEffect('r_hand_trail_ascended');

						StopEffect('l_hand_trail_ascended');
					}
					else
					{
						DestroyEffect('r_hand_trail');

						DestroyEffect('l_hand_trail');

						PlayEffectSingle('r_hand_trail');

						PlayEffectSingle('l_hand_trail');

						StopEffect('r_hand_trail');

						StopEffect('l_hand_trail');
					}
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					

					PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(15, 360, 'electric_blast');
					}
					else
					{
						GiantDealDamage(10, 360, 'stomp');
					}
				}
			}
			else if (data.rangeName == 'dig')
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					

					StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					

					PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(10, 360, 'electric_blast');
					}
					else
					{
						GiantDealDamage(7.5, 360, 'normal_damage_aoe');
					}
				}
			}
			else
			{
				if(animEventType == AET_DurationStart)
				{
					StopEffect('force_stone_wheel');

					StopEffect('ground_hit_stone_wheel');

					

					//StopEffect('anchor_fx');

					StopEffect('anchor_smash_fx2');

					StopEffect('anchor_smash_fx3');

					StopEffect('earthquake_fx');
				}

				if(animEventType == AET_DurationEnd)
				{
					PlayEffectSingle('force_stone_wheel');

					PlayEffectSingle('ground_hit_stone_wheel');

					

					//PlayEffectSingle('anchor_fx');

					PlayEffectSingle('anchor_smash_fx2');

					PlayEffectSingle('anchor_smash_fx3');

					PlayEffectSingle('earthquake_fx');

					if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
					{
						GetGiantStatemachine().TransformationGiantElectricBlast_Engage();

						GiantDealDamage(10, 360, 'electric_blast');
					}
					else
					{
						GiantDealDamage(5, 360, 'normal_damage_aoe');
					}
				}
			}
		}
	}

	function GiantDealDamage( range, angle : float, damagetype : CName)
	{
		var collidedActor 																														: CActor;
		var actors 																																: array< CActor >;
		var dmg 																																: W3DamageAction;
		var maxTargetVitality, maxTargetEssence, damageMax, damageMin																			: float;
		var i 																																	: int;

		actors.Clear();

		actors.Remove( this );

		actors = this.GetNPCsAndPlayersInCone(range, VecHeading(this.GetHeadingVector()), angle, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				collidedActor = (CActor)actors[i];

				if (collidedActor == this
				|| collidedActor.HasTag('acs_snow_entity')
				|| collidedActor.HasTag('smokeman') 
				|| collidedActor.HasTag('ACS_Tentacle_1') 
				|| collidedActor.HasTag('ACS_Tentacle_2') 
				|| collidedActor.HasTag('ACS_Tentacle_3') 
				|| collidedActor.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| collidedActor.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| collidedActor.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| collidedActor.HasTag('ACS_Necrofiend_Tentacle_6')
				|| collidedActor.HasTag('ACS_Necrofiend_Tentacle_5')
				|| collidedActor.HasTag('ACS_Necrofiend_Tentacle_4')
				|| collidedActor.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| collidedActor.HasTag('ACS_Chaos_Cloud') 
				)
				continue;


				dmg = new W3DamageAction in theGame.damageMgr;
				
				dmg.Initialize(thePlayer, collidedActor, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetIgnoreImmortalityMode(false);

				dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				if (collidedActor.UsesVitality()) 
				{ 
					maxTargetVitality = collidedActor.GetStatMax( BCS_Vitality );

					if ( collidedActor.GetStat( BCS_Vitality ) >= maxTargetVitality * 0.5 )
					{
						damageMax = collidedActor.GetStat( BCS_Vitality ) * 0.125; 

						damageMin = collidedActor.GetStat( BCS_Vitality ) * 0.0625; 
					}
					else if ( collidedActor.GetStat( BCS_Vitality ) < maxTargetVitality * 0.5 )
					{
						damageMax = ( maxTargetVitality - collidedActor.GetStat( BCS_Vitality ) ) * 0.125; 

						damageMin = ( maxTargetVitality - collidedActor.GetStat( BCS_Vitality ) ) * 0.0625; 
					}
				} 
				else if (collidedActor.UsesEssence()) 
				{ 
					maxTargetEssence = collidedActor.GetStatMax( BCS_Essence );

					if (((CMovingPhysicalAgentComponent)(collidedActor.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
					|| collidedActor.GetRadius() >= 0.7
					)
					{
						if ( collidedActor.GetStat( BCS_Essence ) >= maxTargetEssence * 0.5 )
						{
							damageMax = collidedActor.GetStat( BCS_Essence ) * 0.0625; 

							damageMin = collidedActor.GetStat( BCS_Essence ) * 0.03125; 
						}
						else if ( collidedActor.GetStat( BCS_Essence ) < maxTargetEssence * 0.5 )
						{
							damageMax = ( maxTargetEssence - collidedActor.GetStat( BCS_Essence ) ) * 0.0625; 

							damageMin = ( maxTargetEssence - collidedActor.GetStat( BCS_Essence ) ) * 0.03125; 
						}
					}
					else
					{
						if ( collidedActor.GetStat( BCS_Essence ) >= maxTargetEssence * 0.5 )
						{
							damageMax = collidedActor.GetStat( BCS_Essence ) * 0.125; 

							damageMin = collidedActor.GetStat( BCS_Essence ) * 0.0625; 
						}
						else if ( collidedActor.GetStat( BCS_Essence ) < maxTargetEssence * 0.5 )
						{
							damageMax = ( maxTargetEssence - collidedActor.GetStat( BCS_Essence ) ) * 0.125; 

							damageMin = ( maxTargetEssence - collidedActor.GetStat( BCS_Essence ) ) * 0.0625; 
						}
					}
				}

				thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus ) * 0.025 );  

				collidedActor.PlayEffectSingle('blood');
				collidedActor.StopEffect('blood');

				collidedActor.PlayEffectSingle('death_blood');
				collidedActor.StopEffect('death_blood');

				collidedActor.PlayEffectSingle('heavy_hit');
				collidedActor.StopEffect('heavy_hit');

				collidedActor.PlayEffectSingle('light_hit');
				collidedActor.StopEffect('light_hit');

				collidedActor.PlayEffectSingle('blood_spill');
				collidedActor.StopEffect('blood_spill');

				dmg.SetHitReactionType( EHRT_Heavy, true);

				if (damagetype == 'anchor')
				{
					collidedActor.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add", 'head');

					dmg.AddEffectInfo( EET_Burning, 7 );

					dmg.AddEffectInfo( EET_Knockdown, 1 );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, RandRangeF(50+ damageMax * 0.5,50 + damageMin * 0.5) );
				}
				else if (damagetype == 'anchor_far')
				{
					collidedActor.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add", 'head');

					dmg.AddEffectInfo( EET_Burning, 7 );

					dmg.AddEffectInfo( EET_HeavyKnockdown, 3 );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, RandRangeF(50+ damageMax * 0.5,50 + damageMin * 0.5) );
				}
				else if (damagetype == 'l_attack_small')
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddEffectInfo( EET_Paralyzed, 1 );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SHOCK, RandRangeF(50+ damageMax * 0.25,50 + damageMin * 0.25) );
				}
				else if (damagetype == 'stomp_heavy') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddEffectInfo( EET_Knockdown, 3 );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(50+ damageMax * 0.75,50 + damageMin * 0.75) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(50+ damageMax * 0.75,50 + damageMin * 0.75) );
				}
				else if (damagetype == 'kick') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddEffectInfo( EET_Knockdown, 1 );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(50+ damageMax * 0.25,50 + damageMin * 0.25) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(50+ damageMax * 0.25,50 + damageMin * 0.25) );
				}
				else if (damagetype == 'electric_blast') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SHOCK, RandRangeF(50+ damageMax * 0.5,50 + damageMin * 0.5) );

					dmg.AddEffectInfo( EET_Paralyzed, 7 );

					dmg.AddEffectInfo( EET_Knockdown, 1 );
				}
				else if (damagetype == 'normal_damage_aoe') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(25+ damageMax * 0.125,25 + damageMin * 0.125) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(25+ damageMax * 0.125,25 + damageMin * 0.125) );

					dmg.AddEffectInfo( EET_Knockdown, 1 );
				}
				else if (damagetype == 'electric_fist') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SHOCK, RandRangeF(25+ damageMax * 0.25,25 + damageMin * 0.25) );

					dmg.AddEffectInfo( EET_Paralyzed, 1 );
				}
				else if (damagetype == 'fist') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(25+ damageMax * 0.125,25 + damageMin * 0.125) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(25+ damageMax * 0.125,25 + damageMin * 0.125) );

					dmg.AddEffectInfo( EET_Bleeding, 1 );
				}
				else if (damagetype == 'stomp') 
				{
					collidedActor.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');

					dmg.AddEffectInfo( EET_Knockdown, 1 );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(25+ damageMax * 0.25,25 + damageMin * 0.25) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(25+ damageMax * 0.25,25 + damageMin * 0.25) );
				}
				
				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMin * 0.5 );
					
				dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	
			}
		}
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		back_weapon_ent.Destroy();

		helm.Destroy();

		helm_omen.Destroy();

		ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_R').Destroy();

		ACSGetCEntity('ACS_Transformation_Giant_Weapon_Secondary_R').Destroy();

		ACSGetCEntity('ACS_Transformation_Giant_Weapon_Primary_L').Destroy();

		ACSGetCEntity('ACS_Transformation_Giant_Weapon_Secondary_L').Destroy();

		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationLilith extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationRedMiasmal extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationSharley extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationToad extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationVampireMonster extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}

statemachine class CACSTransformationWerewolf extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	

		super.OnSpawned( spawnData );
	}

	event OnTakeDamage( action : W3DamageAction )
	{
		
	}

	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{
		super.OnPreAttackEvent(animEventName, animEventType, data, animInfo);
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath(damageAction);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
	}

	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo ) 
	{
		super.OnEnumAnimEvent( animEventName, variant, animEventType, animEventDuration, animInfo );

	}
}