function ACS_Weapon_Respawn()
{
	var vACS_Weapon_Respawn : cACS_Weapon_Respawn;
	vACS_Weapon_Respawn = new cACS_Weapon_Respawn in theGame;
	
	if (ACS_Enabled())
	{	
		vACS_Weapon_Respawn.ACS_Weapon_Respawn_Engage();
	}
}

statemachine class cACS_Weapon_Respawn
{
    function ACS_Weapon_Respawn_Engage()
	{
		this.PushState('ACS_Weapon_Respawn_Engage');
	}
}
 
state ACS_Weapon_Respawn_Engage in cACS_Weapon_Respawn
{
	private var steelID, silverID 																																											: SItemUniqueId;
	private var steelsword, silversword, scabbard_steel, scabbard_silver																																	: CDrawableComponent;
	private var attach_vec, bone_vec																																										: Vector;
	private var attach_rot, bone_rot																																										: EulerAngles;
	private var anchor_temp, blade_temp, claw_temp, head_temp, trail_temp 																																	: CEntityTemplate;
	private var r_blade1, r_blade2, r_blade3, r_blade4, l_blade1, l_blade2, l_blade3, l_blade4, r_anchor, l_anchor, sword1, sword2, sword3, sword4, sword5, sword6, sword7, sword8, blade_temp_ent			: CEntity;
	private var sword_trail_1, sword_trail_2, sword_trail_3, sword_trail_4, sword_trail_5, sword_trail_6, sword_trail_7, sword_trail_8 																		: CEntity;
	private var p_comp 																																														: CComponent;
	private var p_actor 																																													: CActor;
	private var steelswordentity, silverswordentity 																																						: CEntity;
	private var scabbards_steel, scabbards_silver 																																							: array<SItemUniqueId>;
	private var i 																																															: int;
	private var physicalComponent 																																											: CMeshComponent;
	
	event OnEnterState(prevStateName : name)
	{
		Weapon_Respawn();
	}

	entry function Weapon_Respawn()
	{
		if (!GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			if (GetWitcherPlayer().IsAnyWeaponHeld())
			{
				//GetWitcherPlayer().PlayEffectSingle('claws_effect');
				//GetWitcherPlayer().StopEffect('claws_effect');
			}

			ClawDestroy_Latent_OnDodge();
		}

		if ( ACS_GetWeaponMode() == 0 )
		{	
			if (GetWitcherPlayer().HasTag('igni_sword_equipped'))
			{
				IgniSword();
			}
			else if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				ArmigerModeQuenSword();	
			}
			else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
			{
				ArmigerModeAxiiSword();		
			}
			else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				ArmigerModeAardSword();			
			}
			else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
			{
				ArmigerModeYrdenSword();	
			}
			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
			{
				IgniSword();	
			}
			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
			{
				ArmigerModeQuenSecondarySword();	
			}
			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
			{
				ArmigerModeAxiiSecondarySword();	
			}
			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
			{
				ArmigerModeAardSecondarySword();	
			}
			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
			{
				ArmigerModeYrdenSecondarySword();	
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 1)
		{
			if 
			(
				GetWitcherPlayer().HasTag('igni_sword_equipped') 
			)
			{
				IgniSword();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('axii_sword_equipped')
			)
			{
				FocusModeAxiiSword();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('aard_sword_equipped') 
			)
			{
				FocusModeAardSword();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('yrden_sword_equipped') 
			)
			{
				FocusModeYrdenSword();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('quen_sword_equipped') 
			)
			{
				FocusModeQuenSword();
			}

			else if 
			(
				GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') 
			)
			{
				IgniSword();
			}

			else if 
			(
				GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') 
			)
			{
				FocusModeAxiiSecondarySword();
			}

			else if 
			(
				GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') 
			)
			{
				FocusModeAardSecondarySword();
			}

			else if 
			(
				GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') 
			)
			{
				FocusModeYrdenSecondarySword();
			}

			else if 
			(
				GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') 
			)
			{
				FocusModeQuenSecondarySword();
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 2)
		{
			if (GetWitcherPlayer().HasTag('igni_sword_equipped') )
			{
				IgniSword();
			}	

			else if (GetWitcherPlayer().HasTag('axii_sword_equipped') )
			{
				HybridModeAxiiSword();	
			}
			
			else if (GetWitcherPlayer().HasTag('aard_sword_equipped') )
			{
				HybridModeAardSword();
			}

			else if (GetWitcherPlayer().HasTag('yrden_sword_equipped') )
			{
				HybridModeYrdenSword();	
			}

			else if (GetWitcherPlayer().HasTag('quen_sword_equipped') )
			{
				HybridModeQuenSword();
			}

			else if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') )
			{
				IgniSword();
			}

			else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
			{
				HybridModeAxiiSecondarySword();
			}

			else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
			{
				HybridModeAardSecondarySword();
			}

			else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
			{
				HybridModeYrdenSecondarySword();
			}

			else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
			{
				HybridModeQuenSecondarySword();
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 3)
		{	
			if (GetWitcherPlayer().HasTag('aard_sword_equipped') )
			{
				EquipmentModeAardSword();
			}
			else
			{
				IgniSword();
			}
			
			//Sleep(0.125);

			if (!GetWitcherPlayer().HasTag('blood_sucking'))
			{
				if ( GetWitcherPlayer().HasTag('aard_sword_equipped') 
				&& !GetWitcherPlayer().HasTag('aard_sword_effect_played'))
				{
					//aard_sword_summon();

					GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

					GetWitcherPlayer().AddTag('aard_sword_effect_played');
				}
				else
				{
					igni_sword_summon();

					GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);
				}
			}
		}
	}

	latent function ClawDestroy_Latent_OnDodge()
	{
		p_actor = GetWitcherPlayer();
		p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
			
		if (ACS_Armor_Equipped_Check())
		{
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	
		}
		else
		{
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	
		}

		head_temp = (CEntityTemplate)LoadResource("dlc\bob\data\items\cutscenes\cs704_dettlaff_transformation\cs704_dettlaff_transformation_extra_arms.w2ent", true);	

		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(head_temp);

		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);
	}

	latent function WeaponSummonEffect()
	{
		GetACSWatcher().RemoveTimer('ACS_Weapon_Summon_Delay');

		if (GetWitcherPlayer().HasTag('igni_sword_equipped')
		&& !GetWitcherPlayer().HasTag('igni_sword_effect_played'))
		{
			if (!GetWitcherPlayer().HasTag('blood_sucking'))
			{
				igni_sword_summon();

				GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);
			}
			
			GetWitcherPlayer().AddTag('igni_sword_effect_played');
			GetWitcherPlayer().AddTag('igni_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped')
		&& !GetWitcherPlayer().HasTag('axii_sword_effect_played'))
		{
			igni_sword_summon();

			//axii_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('axii_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped')
		&& !GetWitcherPlayer().HasTag('aard_sword_effect_played'))
		{
			//aard_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('aard_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped')
		&& !GetWitcherPlayer().HasTag('yrden_sword_effect_played'))
		{
			igni_sword_summon();

			//yrden_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('yrden_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('quen_sword_equipped')
		&& !GetWitcherPlayer().HasTag('quen_sword_effect_played'))
		{
			igni_sword_summon();

			//quen_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('quen_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('axii_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//axii_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('axii_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('aard_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//aard_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('aard_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('yrden_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//yrden_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('yrden_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('quen_secondary_sword_effect_played'))
		{
			igni_sword_summon();
			
			//quen_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('quen_secondary_sword_effect_played');
		}
	}
	
	latent function IgniSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		ACS_StartAerondightEffectInit();
		
		if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
		{
			if (!ACS_Armor_Equipped_Check())
			{
				steelsword.SetVisible(true);

				steelswordentity = GetWitcherPlayer().inv.GetItemEntityUnsafe(steelID);
				steelswordentity.SetHideInGame(false); 
			}

			if (!ACS_HideSwordsheathes_Enabled())
			{
				scabbards_steel.Clear();

				scabbards_steel = GetWitcherPlayer().inv.GetItemsByCategory('steel_scabbards');

				for ( i=0; i < scabbards_steel.Size() ; i+=1 )
				{
					scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().inv.GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
					//scabbard_steel.SetVisible(true);
				}
			}
		}
		else if( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
		{
			if (!ACS_Armor_Equipped_Check())
			{
				silversword.SetVisible(true);
			
				silverswordentity = GetWitcherPlayer().inv.GetItemEntityUnsafe(silverID);
				silverswordentity.SetHideInGame(false); 
			}

			if (!ACS_HideSwordsheathes_Enabled())
			{
				scabbards_silver.Clear();

				scabbards_silver = GetWitcherPlayer().inv.GetItemsByCategory('silver_scabbards');

				for ( i=0; i < scabbards_silver.Size() ; i+=1 )
				{
					scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().inv.GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
					//scabbard_silver.SetVisible(true);
				}
			}
		}

		if (!GetACSArmorEtherSword() 
		&& (thePlayer.HasTag('igni_secondary_sword_equipped')
		|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
		|| thePlayer.HasTag('igni_sword_equipped')
		|| thePlayer.HasTag('igni_sword_equipped_TAG'))
		&& thePlayer.IsAnyWeaponHeld()
		)
		{
			GetACSWatcher().Ether_Sword_Summon();
		}
	}

	latent function ArmigerModeAxiiSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiSwordStatic();
		}
	}

	latent function FocusModeAxiiSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AxiiSwordStatic();
		}
	}

	latent function HybridModeAxiiSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0)
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1)
		{
			AxiiSwordStatic();
		}
	}

	latent function AxiiSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
			
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0.25;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.01;
					attach_vec.Y = 0;
					attach_vec.Z = 0.35;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0.25;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.01;
					attach_vec.Y = 0;
					attach_vec.Z = 0.35;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('axii_sword_5');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
			
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.045;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.045;
					
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('axii_sword_5');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
			}
		}
	}

	latent function AxiiSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_StartAerondightEffectInit();

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\unique\eredin_sword.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.1;
				
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.16;
				
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('axii_sword_2');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\unique\eredin_sword.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.1;
				
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.16;
				
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('axii_sword_2');
		}
	}

	latent function ArmigerModeAardSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}
	}

	latent function FocusModeAardSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}
	}

	latent function HybridModeAardSword()
	{	
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}
	}

	latent function EquipmentModeAardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );
		
		ACS_StopAerondightEffectInit();

		ACS_HideSword();
		
		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
		}
				
		r_blade1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		r_blade2 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade2 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		r_blade3 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade3 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		r_blade4 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade4 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = 0.1025;
					
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = 0.0325;
					
		l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = -0.0375;
				
		l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = -0.1025;
					
		l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = 0.1025;
					
		r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = 0.0325;
					
		r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.05;
		attach_vec.Z = -0.0375;
				
		r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
		//////////////////////////////////////////////////////////////////////////////////////////
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = 0;
		attach_vec.Y = -0.0;
		attach_vec.Z = -0.1025;
					
		r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function AardSwordEvolving()
	{
		ACS_StopAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() && ACS_Warglaives_Installed() && ACS_Warglaives_Enabled() )
		{
			Warglaives_AardSword();
		}
		else if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			SOI_AardSword();
		}
		else
		{
			Normal_AardSword();
		}
	}

	latent function Warglaives_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\azinoth9897\data\parts\gla_black_01.w2ent"

				, true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function SOI_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function Normal_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{	
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );		
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl4.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl4.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl4.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl4.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}

	latent function AardSwordStatic()
	{
		ACS_StopAerondightEffectInit();

		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\azinoth9897\data\parts\gla_black_01.w2ent"

				, true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );	
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\lionhunter\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\rakuyo\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
					
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
					
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				blade_temp = (CEntityTemplate)LoadResource( "items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl4.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
					
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
					
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
				//////////////////////////////////////////////////////////////////////////////////////////
					
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
					
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');
	}
	
	latent function ArmigerModeYrdenSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}
	}

	latent function FocusModeYrdenSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}
	}

	latent function HybridModeYrdenSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}
	}
	
	latent function YrdenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');	
					*/

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');	
					*/

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
		}
	}

	latent function YrdenSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_StartAerondightEffectInit();

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			// YRDEN SILVER SWORD PATH

			"dlc\dlc_acs\data\entities\swords\imlerith_mace.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.1;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			// YRDEN STEEL SWORD PATH

			"dlc\dlc_acs\data\entities\swords\caretaker_shovel.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.1;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_sword_1');
		}
	}

	latent function ArmigerModeQuenSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	}

	latent function FocusModeQuenSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	}

	latent function HybridModeQuenSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	}

	latent function QuenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
	
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"

					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');	

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"

					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
			}
		}
	}

	latent function QuenSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_StartAerondightEffectInit();

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
						
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_sword_1');

			sword1.AddTag('quen_sword_upgraded_1');	
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"
			
			, true), GetWitcherPlayer().GetWorldPosition() );
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_sword_1');	

			sword1.AddTag('quen_sword_upgraded_1');	
		}
	}

	latent function ArmigerModeAxiiSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiSecondarySwordStatic();
		}
	}

	latent function FocusModeAxiiSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AxiiSecondarySwordStatic();
		}
	}

	latent function HybridModeAxiiSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0)
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1)
		{
			AxiiSecondarySwordStatic();
		}
	}

	latent function AxiiSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		 
		
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
		}
	}

	latent function AxiiSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		 
		
		ACS_StartAerondightEffectInit();

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.05;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_secondary_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.05;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_secondary_sword_1');
		}
	}

	latent function ArmigerModeAardSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}
	}

	latent function FocusModeAardSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0  )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}
	}

	latent function HybridModeAardSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}
	}	

	latent function AardSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		 
		
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
		}
	}

	latent function AardSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		 
		
		ACS_StartAerondightEffectInit();

		
		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );	
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;
	
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('aard_secondary_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );	
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;
	
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('aard_secondary_sword_1');
		}
	}

	latent function ArmigerModeYrdenSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}
	}

	latent function FocusModeYrdenSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}
	}

	latent function HybridModeYrdenSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}
	}

	latent function YrdenSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		 
		
		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
		}
	}

	latent function YrdenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		 
		
		ACS_StartAerondightEffectInit();

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.525;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_secondary_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\anchor_01__giant_weapon.w2ent"
			
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 2.0;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('yrden_secondary_sword_1');
		}
	}
	
	latent function ArmigerModeQuenSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}
	}

	latent function FocusModeQuenSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}
	}

	latent function HybridModeQuenSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}
	}

	latent function QuenSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_StartAerondightEffectInit();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
						
					////////////////////////////////////////////////////////////////////////////
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');

					////////////////////////////////////////////////////////////////////////////
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.2;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(steelID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.2;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.2;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.7;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');

					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.7;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\guisarme_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_01.w2ent"

					//"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(steelID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.004;
					attach_vec.Y = 0;
					attach_vec.Z = 0.75;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.004;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.004;
					attach_vec.Y = 0;
					attach_vec.Z = 0.75;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.004;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.004;
					attach_vec.Y = 0;
					attach_vec.Z = 0.75;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.004;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
		}
	}

	latent function QuenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		ACS_StartAerondightEffectInit();

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.6;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_secondary_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.8;
					
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('quen_secondary_sword_2');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.004;
			attach_vec.Y = 0;
			attach_vec.Z = -0.6;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_secondary_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0.004;
			attach_vec.Y = 0;
			attach_vec.Z = 0.75;
					
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('quen_secondary_sword_2');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.