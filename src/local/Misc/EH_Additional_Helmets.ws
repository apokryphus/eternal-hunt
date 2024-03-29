///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Hood
{
    function ACS_Hood_Enable_Engage()
	{
		this.PushState('ACS_Hood_Enable_Engage');
	}
	
	function ACS_Hood_Disable_Engage()
	{
		this.PushState('ACS_Hood_Disable_Engage');
	}
}

state ACS_Hood_Enable_Engage in cACS_Hood
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Hood_Enable_Entry();
	}
	
	entry function Hood_Enable_Entry()
	{
		Hood_Enable_Latent();
		Hair_Thing();
	}
	
	latent function Hood_Enable_Latent()
	{
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );	

		if (ACS_Eredin_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Eredin_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Eredin_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Include_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_eredin_armor\acs_eredin_helmet.w2ent", true);	
		}
		else if (ACS_Imlerith_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Imlerith_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Imlerith_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_imlerith_armor\acs_imlerith_helmet.w2ent", true);		
		}
		else if (ACS_Caranthir_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Caranthir_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Caranthir_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_caranthir_armor\acs_caranthir_helmet.w2ent", true);		
		}
		else if (ACS_VGX_Eredin_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_VGX_Eredin_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_VGX_Eredin_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Include_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_vgx_eredin_arrmor\acs_vgx_eredin_helmet.w2ent", true);	
		}
		else if (ACS_Legion_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Legion_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Legion_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\alien\acs_alien_helm.w2ent", true);	
		}
		else if (ACS_Cavalier_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Cavalier_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Cavalier_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\cava\acs_cava_helm.w2ent", true);	
		}
		else if (ACS_Leonidas_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Leonidas_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Leonidas_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\leo\acs_leo_helm.w2ent", true);	
		}
		else if (ACS_Centurion_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Centurion_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Centurion_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Include_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\rome\acs_rome_helm.w2ent", true);	
		}
		else if (ACS_Templar_Armor_Equipped_Check())
		{
			if ( FactsQuerySum("ACS_Templar_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Templar_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\templar\acs_templar_helm.w2ent", true);	
		}
		else if (ACS_Knight_Armor_Check())
		{
			if ( FactsQuerySum("ACS_Knight_Helm_Equipped") <= 0 )
			{
				FactsAdd("ACS_Knight_Helm_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\acs_knight_helmet_05.w2ent", true);	
		}
		else if (ACS_Knight_Armor_Gold_Check())
		{
			if ( FactsQuerySum("ACS_Knight_Helm_Gold_Equipped") <= 0 )
			{
				FactsAdd("ACS_Knight_Helm_Gold_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\gold\gold_acs_knight_helmet_05.w2ent", true);	
		}
		else if (ACS_Vampire_Armor_Black_Check())
		{
			if ( FactsQuerySum("ACS_Vampire_Helm_Black_Equipped") <= 0 )
			{
				FactsAdd("ACS_Vampire_Helm_Black_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\black\black_acs_knight_helmet_05.w2ent", true);	
		}
		else if (ACS_Vampire_Armor_Red_Check())
		{
			if ( FactsQuerySum("ACS_Vampire_Helm_Red_Equipped") <= 0 )
			{
				FactsAdd("ACS_Vampire_Helm_Red_Equipped", 1, -1);
			}

			GetACSWatcher().Facegear_Exclude_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\red\red_acs_knight_helmet_05.w2ent", true);	
		}
		/*
		else if (ACS_Artorias_Armor_Equipped_Check())
		{
			GetACSWatcher().Facegear_Include_No_Anim();

			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\artorias_armor\acs_artorias_helmet.w2ent", true);	
		}
		*/
		else
		{
			if ( FactsQuerySum("ACS_Hood_Normal_Equipped") <= 0 )
			{
				FactsAdd("ACS_Hood_Normal_Equipped", 1, -1);
			}

			temp_1 = (CEntityTemplate)LoadResource("dlc\ep1\data\characters\models\main_npc\ewald_borsody\ewald_borsody_hood_01.w2ent", true);		
		}

		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);
	}

	latent function Hair_Thing()
	{
		var inv : CInventoryComponent;
		var witcher : W3PlayerWitcher;
		var ids : array<SItemUniqueId>;
		var size : int;
		var i : int;

		witcher = GetWitcherPlayer();
		inv = witcher.GetInventory();
		
		ids = inv.GetItemsByCategory( 'hair' );
		size = ids.Size();
			
		if( size > 0 )
		{					
			for( i = 0; i < size; i+=1 )
			{
				if(inv.IsItemMounted( ids[i] ) )
				inv.DespawnItem(ids[i]);
			}				
		}		

		ids.Clear();
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Hood_Disable_Engage in cACS_Hood
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
	private var inv 																											: CInventoryComponent;
	private var witcher 																										: W3PlayerWitcher;
	private var ids 																											: array<SItemUniqueId>;
	private var size 																											: int;
	private var i 																												: int;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Hood_Disable_Entry();
	}
	
	entry function Hood_Disable_Entry()
	{
		Hood_Disable_Latent();
	}
	
	latent function Hood_Disable_Latent()
	{
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		if ( FactsQuerySum("ACS_Hood_Normal_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\ep1\data\characters\models\main_npc\ewald_borsody\ewald_borsody_hood_01.w2ent", true);		
		
			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Hood_Normal_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Eredin_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_eredin_armor\acs_eredin_helmet.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Eredin_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Imlerith_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_imlerith_armor\acs_imlerith_helmet.w2ent", true);		

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Imlerith_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Caranthir_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_caranthir_armor\acs_caranthir_helmet.w2ent", true);		

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Caranthir_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_VGX_Eredin_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\wh_armors\acs_vgx_eredin_arrmor\acs_vgx_eredin_helmet.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_VGX_Eredin_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Legion_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\alien\acs_alien_helm.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Legion_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Cavalier_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\cava\acs_cava_helm.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Cavalier_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Leonidas_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\leo\acs_leo_helm.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Leonidas_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Centurion_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\rome\acs_rome_helm.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Centurion_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Templar_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors\entities\templar\acs_templar_helm.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Templar_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Knight_Helm_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\acs_knight_helmet_05.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Knight_Helm_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Knight_Helm_Gold_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\gold\gold_acs_knight_helmet_05.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Knight_Helm_Gold_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Vampire_Helm_Black_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\black\black_acs_knight_helmet_05.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Vampire_Helm_Black_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if ( FactsQuerySum("ACS_Vampire_Helm_Red_Equipped") > 0 )
		{
			temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\knight_armors_errant\entities\helms\red\red_acs_knight_helmet_05.w2ent", true);	

			((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

			FactsRemove("ACS_Vampire_Helm_Red_Equipped");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		//temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\models\artorias_armor\acs_artorias_helmet.w2ent", true);	

		//((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);


		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		inv = thePlayer.GetInventory();
    
		ids = inv.GetItemsByCategory( 'hair' );
		size = ids.Size();
		
		if( size > 0 )
		{					
			for( i = 0; i < size; i+=1 )
			{
				if(inv.IsItemMounted( ids[i] ) )
				{
					inv.MountItem(ids[i],,true);
				}
			}	
		}			
		ids.Clear();

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Facegear_Include
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Facegear_Include
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Facegear_Include();
	}
	
	entry function Facegear_Include()
	{
		Facegear_Include_Start();
	}
	
	latent function Facegear_Include_Start()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\face_mask.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Facegear_Exclude
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Facegear_Exclude
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Facegear_Exclude();
	}
	
	entry function Facegear_Exclude()
	{
		Facegear_Exclude_Start();
	}
	
	latent function Facegear_Exclude_Start()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\face_mask.w2ent", true);		
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Wildhunt_Additional_Pieces
{
    function AttachEredinSkirt()
	{
		this.PushState('AttachEredinSkirt');
	}

	function AttachEredinCloak()
	{
		this.PushState('AttachEredinCloak');
	}

	function AttachVGXEredinCloak()
	{
		this.PushState('AttachVGXEredinCloak');
	}

	function AttachImlerithSkirt()
	{
		this.PushState('AttachImlerithSkirt');
	}
}

state AttachEredinSkirt in cACS_Wildhunt_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		AttachEredinSkirt_Entry();
	}
	
	entry function AttachEredinSkirt_Entry()
	{
		AttachEredinSkirt_Latent();
	}
	
	latent function AttachEredinSkirt_Latent()
	{	
		var ent, anchor											            : CEntity;
		var rot, attach_rot, bone_rot                        				: EulerAngles;
		var pos, attach_vec, bone_vec										: Vector;
		var h 																: float;
		var anchor_temp														: CEntityTemplate;

		GetACSEredinSkirt().Destroy();
		GetACSEredinSkirtAnchor().Destroy();

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );


		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'pelvis' ), bone_vec, bone_rot );

		anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		anchor.AddTag('ACS_Eredin_Skirt_Anchor');

		anchor.CreateAttachmentAtBoneWS( thePlayer, 'pelvis', bone_vec, bone_rot );

		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();




		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\models\wh_armors\acs_eredin_armor\acs_eredin_skirt.w2ent"

		, true ), pos, rot );

		ent.AddTag('ACS_Eredin_Skirt');

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = -90;
		attach_vec.X = -0.05;
		attach_vec.Y = 1;
		attach_vec.Z = 0;

		ent.CreateAttachment( anchor, , attach_vec, attach_rot );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state AttachEredinCloak in cACS_Wildhunt_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		AttachEredinCloak_Entry();
	}
	
	entry function AttachEredinCloak_Entry()
	{
		AttachEredinCloak_Latent();
	}
	
	latent function AttachEredinCloak_Latent()
	{	
		var ent, anchor											            : CEntity;
		var rot, attach_rot, bone_rot                        				: EulerAngles;
		var pos, attach_vec, bone_vec										: Vector;
		var h 																: float;
		var anchor_temp														: CEntityTemplate;


		GetACSEredinCloak().Destroy();
		GetACSEredinCloakAnchor().Destroy();



		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );


		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

		anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		anchor.AddTag('ACS_Eredin_Cloak_Anchor');

		anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bone_vec, bone_rot );

		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();




		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\models\wh_armors\acs_eredin_armor\acs_eredin_cloak.w2ent"

		, true ), pos, rot );

		ent.AddTag('ACS_Eredin_Cloak');

		attach_rot.Roll = 168.75;
		attach_rot.Pitch = 22.5;
		attach_rot.Yaw = 168.75;

		//left/right
		//- left + right
		attach_vec.X = 0.45;

		//forward/backward
		//+ back - forward
		attach_vec.Y = 0.5475;

		//up/down
		attach_vec.Z = 1.5;

		ent.CreateAttachment( anchor, , attach_vec, attach_rot );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state AttachVGXEredinCloak in cACS_Wildhunt_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		AttachVGXEredinCloak_Entry();
	}
	
	entry function AttachVGXEredinCloak_Entry()
	{
		AttachVGXEredinCloak_Latent();
	}
	
	latent function AttachVGXEredinCloak_Latent()
	{	
		var ent, anchor											            : CEntity;
		var rot, attach_rot, bone_rot                        				: EulerAngles;
		var pos, attach_vec, bone_vec										: Vector;
		var h 																: float;
		var anchor_temp														: CEntityTemplate;


		GetACSVGXEredinCloak().Destroy();
		GetACSVGXEredinCloakAnchor().Destroy();



		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );


		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

		anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		anchor.AddTag('ACS_VGX_Eredin_Cloak_Anchor');

		anchor.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bone_vec, bone_rot );

		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();




		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\models\wh_armors\acs_eredin_armor\acs_eredin_cloak.w2ent"

		, true ), pos, rot );

		ent.AddTag('ACS_VGX_Eredin_Cloak');

		attach_rot.Roll = 168.75;
		attach_rot.Pitch = 22.5;
		attach_rot.Yaw = 168.75;

		//left/right
		//- left + right
		attach_vec.X = 0.45;

		//forward/backward
		//+ back - forward
		attach_vec.Y = 0.6125;

		//up/down
		attach_vec.Z = 1.5;

		ent.CreateAttachment( anchor, , attach_vec, attach_rot );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state AttachImlerithSkirt in cACS_Wildhunt_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		AttachImlerithSkirt_Entry();
	}
	
	entry function AttachImlerithSkirt_Entry()
	{
		AttachImlerithSkirt_Latent();
	}
	
	latent function AttachImlerithSkirt_Latent()
	{	
		var ent, anchor											            : CEntity;
		var rot, attach_rot, bone_rot                        				: EulerAngles;
		var pos, attach_vec, bone_vec										: Vector;
		var h 																: float;
		var anchor_temp														: CEntityTemplate;


		GetACSImlerithSkirt().Destroy();
		GetACSImlerithSkirtAnchor().Destroy();



		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );


		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'pelvis' ), bone_vec, bone_rot );

		anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );

		anchor.AddTag('ACS_Imlerith_Skirt_Anchor');

		anchor.CreateAttachmentAtBoneWS( thePlayer, 'pelvis', bone_vec, bone_rot );

		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();




		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\models\wh_armors\acs_imlerith_armor\acs_imlerith_skirt.w2ent"

		, true ), pos, rot );

		ent.AddTag('ACS_Imlerith_Skirt');

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = -90;
		attach_vec.X = -0.025;
		attach_vec.Y = 0.975;
		attach_vec.Z = 0;

		ent.CreateAttachment( anchor, , attach_vec, attach_rot );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Knight_Additional_Pieces
{
    function ACS_Knight_Armor_V1_Pieces_Include()
	{
		this.PushState('ACS_Knight_Armor_V1_Pieces_Include');
	}

	function ACS_Knight_Armor_V2_Pieces_Include()
	{
		this.PushState('ACS_Knight_Armor_V2_Pieces_Include');
	}

	function ACS_Knight_Armor_V3_Pieces_Include()
	{
		this.PushState('ACS_Knight_Armor_V3_Pieces_Include');
	}

	function ACS_Knight_Armor_Gold_V1_Pieces_Include()
	{
		this.PushState('ACS_Knight_Armor_Gold_V1_Pieces_Include');
	}

	function ACS_Knight_Armor_Gold_V2_Pieces_Include()
	{
		this.PushState('ACS_Knight_Armor_Gold_V2_Pieces_Include');
	}

	 function ACS_Vampire_Armor_Black_Pieces_Include()
	{
		this.PushState('ACS_Vampire_Armor_Black_Pieces_Include');
	}

	function ACS_Vampire_Armor_Red_Pieces_Include()
	{
		this.PushState('ACS_Vampire_Armor_Red_Pieces_Include');
	}

	function ACS_Knight_Armor_V1_Pieces_Exclude()
	{
		this.PushState('ACS_Knight_Armor_V1_Pieces_Exclude');
	}

	function ACS_Knight_Armor_V2_Pieces_Exclude()
	{
		this.PushState('ACS_Knight_Armor_V2_Pieces_Exclude');
	}

	function ACS_Knight_Armor_V3_Pieces_Exclude()
	{
		this.PushState('ACS_Knight_Armor_V3_Pieces_Exclude');
	}

	function ACS_Knight_Armor_Gold_V1_Pieces_Exclude()
	{
		this.PushState('ACS_Knight_Armor_Gold_V1_Pieces_Exclude');
	}

	function ACS_Knight_Armor_Gold_V2_Pieces_Exclude()
	{
		this.PushState('ACS_Knight_Armor_Gold_V2_Pieces_Exclude');
	}

	 function ACS_Vampire_Armor_Black_Pieces_Exclude()
	{
		this.PushState('ACS_Vampire_Armor_Black_Pieces_Exclude');
	}

	function ACS_Vampire_Armor_Red_Pieces_Exclude()
	{
		this.PushState('ACS_Vampire_Armor_Red_Pieces_Exclude');
	}


	function ACS_Witcher_Knight_Armor_V1_Pieces_Include()
	{
		this.PushState('ACS_Witcher_Knight_Armor_V1_Pieces_Include');
	}

	function ACS_Witcher_Knight_Armor_V2_Pieces_Include()
	{
		this.PushState('ACS_Witcher_Knight_Armor_V2_Pieces_Include');
	}

	function ACS_Witcher_Knight_Armor_V3_Pieces_Include()
	{
		this.PushState('ACS_Witcher_Knight_Armor_V3_Pieces_Include');
	}

	function ACS_Witcher_Knight_Armor_V1_Pieces_Exclude()
	{
		this.PushState('ACS_Witcher_Knight_Armor_V1_Pieces_Exclude');
	}

	function ACS_Witcher_Knight_Armor_V2_Pieces_Exclude()
	{
		this.PushState('ACS_Witcher_Knight_Armor_V2_Pieces_Exclude');
	}

	function ACS_Witcher_Knight_Armor_V3_Pieces_Exclude()
	{
		this.PushState('ACS_Witcher_Knight_Armor_V3_Pieces_Exclude');
	}

	function ACS_Witcher_Bear_Armor_Fur_Include()
	{
		this.PushState('ACS_Witcher_Bear_Armor_Fur_Include');
	}

	function ACS_Witcher_Bear_Armor_Fur_Exclude()
	{
		this.PushState('ACS_Witcher_Bear_Armor_Fur_Exclude');
	}

}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Witcher_Bear_Armor_Fur_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Bear_Armor_Fur_Include_Entry();
	}
	
	entry function ACS_Witcher_Bear_Armor_Fur_Include_Entry()
	{
		ACS_Witcher_Bear_Armor_Fur_Include_Latent();
	}
	
	latent function ACS_Witcher_Bear_Armor_Fur_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\wh_armors\acs_caranthir_armor\i_01_mw__wild_hunt.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_15.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
		
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Witcher_Bear_Armor_Fur_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Bear_Armor_Fur_Exclude_Entry();
	}
	
	entry function ACS_Witcher_Bear_Armor_Fur_Exclude_Entry()
	{
		ACS_Witcher_Bear_Armor_Fur_Exclude_Latent();
	}
	
	latent function ACS_Witcher_Bear_Armor_Fur_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\wh_armors\acs_caranthir_armor\i_01_mw__wild_hunt.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_15.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
		
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Knight_Armor_V1_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_V1_Pieces_Include_Entry();
	}
	
	entry function ACS_Knight_Armor_V1_Pieces_Include_Entry()
	{
		ACS_Knight_Armor_V1_Pieces_Include_Latent();
	}
	
	latent function ACS_Knight_Armor_V1_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_01.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_06.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_13.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Knight_Armor_V1_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_V1_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Knight_Armor_V1_Pieces_Exclude_Entry()
	{
		ACS_Knight_Armor_V1_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Knight_Armor_V1_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_01.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_06.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_13.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Knight_Armor_V2_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_V2_Pieces_Include_Entry();
	}
	
	entry function ACS_Knight_Armor_V2_Pieces_Include_Entry()
	{
		ACS_Knight_Armor_V2_Pieces_Include_Latent();
	}
	
	latent function ACS_Knight_Armor_V2_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Knight_Armor_V2_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_V2_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Knight_Armor_V2_Pieces_Exclude_Entry()
	{
		ACS_Knight_Armor_V2_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Knight_Armor_V2_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Knight_Armor_V3_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_V3_Pieces_Include_Entry();
	}
	
	entry function ACS_Knight_Armor_V3_Pieces_Include_Entry()
	{
		ACS_Knight_Armor_V3_Pieces_Include_Latent();
	}
	
	latent function ACS_Knight_Armor_V3_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_05.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_09.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);



		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_15.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Knight_Armor_V3_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_V3_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Knight_Armor_V3_Pieces_Exclude_Entry()
	{
		ACS_Knight_Armor_V3_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Knight_Armor_V3_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_05.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_09.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_15.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Witcher_Knight_Armor_V1_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Knight_Armor_V1_Pieces_Include_Entry();
	}
	
	entry function ACS_Witcher_Knight_Armor_V1_Pieces_Include_Entry()
	{
		ACS_Witcher_Knight_Armor_V1_Pieces_Include_Latent();
	}
	
	latent function ACS_Witcher_Knight_Armor_V1_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_01.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_06.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Witcher_Knight_Armor_V1_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Knight_Armor_V1_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Witcher_Knight_Armor_V1_Pieces_Exclude_Entry()
	{
		ACS_Witcher_Knight_Armor_V1_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Witcher_Knight_Armor_V1_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_01.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);



		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_06.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Witcher_Knight_Armor_V2_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Knight_Armor_V2_Pieces_Include_Entry();
	}
	
	entry function ACS_Witcher_Knight_Armor_V2_Pieces_Include_Entry()
	{
		ACS_Witcher_Knight_Armor_V2_Pieces_Include_Latent();
	}
	
	latent function ACS_Witcher_Knight_Armor_V2_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

	
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Witcher_Knight_Armor_V2_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Knight_Armor_V2_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Witcher_Knight_Armor_V2_Pieces_Exclude_Entry()
	{
		ACS_Witcher_Knight_Armor_V2_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Witcher_Knight_Armor_V2_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

	
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Witcher_Knight_Armor_V3_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Knight_Armor_V3_Pieces_Include_Entry();
	}
	
	entry function ACS_Witcher_Knight_Armor_V3_Pieces_Include_Entry()
	{
		ACS_Witcher_Knight_Armor_V3_Pieces_Include_Latent();
	}
	
	latent function ACS_Witcher_Knight_Armor_V3_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_05.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_09.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Witcher_Knight_Armor_V3_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Witcher_Knight_Armor_V3_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Witcher_Knight_Armor_V3_Pieces_Exclude_Entry()
	{
		ACS_Witcher_Knight_Armor_V3_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Witcher_Knight_Armor_V3_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_05.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\acs_knight_item_09.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Knight_Armor_Gold_V1_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_Gold_V1_Pieces_Include_Entry();
	}
	
	entry function ACS_Knight_Armor_Gold_V1_Pieces_Include_Entry()
	{
		ACS_Knight_Armor_Gold_V1_Pieces_Include_Latent();
	}
	
	latent function ACS_Knight_Armor_Gold_V1_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Knight_Armor_Gold_V1_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_Gold_V1_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Knight_Armor_Gold_V1_Pieces_Exclude_Entry()
	{
		ACS_Knight_Armor_Gold_V1_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Knight_Armor_Gold_V1_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Knight_Armor_Gold_V2_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_Gold_V2_Pieces_Include_Entry();
	}
	
	entry function ACS_Knight_Armor_Gold_V2_Pieces_Include_Entry()
	{
		ACS_Knight_Armor_Gold_V2_Pieces_Include_Latent();
	}
	
	latent function ACS_Knight_Armor_Gold_V2_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_05.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_09.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_15.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Knight_Armor_Gold_V2_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Knight_Armor_Gold_V2_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Knight_Armor_Gold_V2_Pieces_Exclude_Entry()
	{
		ACS_Knight_Armor_Gold_V2_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Knight_Armor_Gold_V2_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_05.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_09.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\gold\gold_acs_knight_item_15.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Vampire_Armor_Black_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Vampire_Armor_Black_Pieces_Include_Entry();
	}
	
	entry function ACS_Vampire_Armor_Black_Pieces_Include_Entry()
	{
		ACS_Vampire_Armor_Black_Pieces_Include_Latent();
	}
	
	latent function ACS_Vampire_Armor_Black_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Vampire_Armor_Black_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Vampire_Armor_Black_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Vampire_Armor_Black_Pieces_Exclude_Entry()
	{
		ACS_Vampire_Armor_Black_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Vampire_Armor_Black_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
		
		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\black\black_acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Vampire_Armor_Red_Pieces_Include in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Vampire_Armor_Red_Pieces_Include_Entry();
	}
	
	entry function ACS_Vampire_Armor_Red_Pieces_Include_Entry()
	{
		ACS_Vampire_Armor_Red_Pieces_Include_Latent();
	}
	
	latent function ACS_Vampire_Armor_Red_Pieces_Include_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		
	
		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Vampire_Armor_Red_Pieces_Exclude in cACS_Knight_Additional_Pieces
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Vampire_Armor_Red_Pieces_Exclude_Entry();
	}
	
	entry function ACS_Vampire_Armor_Red_Pieces_Exclude_Entry()
	{
		ACS_Vampire_Armor_Red_Pieces_Exclude_Latent();
	}
	
	latent function ACS_Vampire_Armor_Red_Pieces_Exclude_Latent()
	{	
		var p_comp				: CComponent;
		var temp				: CEntityTemplate;

		p_comp = thePlayer.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_03.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_04.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_08.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_14.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);


		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_17.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		temp = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\models\knight_armors_errant\items\red\red_acs_knight_item_18.w2ent"
		
		, true);
		
		((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Crach_Cape_Include
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Crach_Cape_Include
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Crach_Cape_Include();
	}
	
	entry function Crach_Cape_Include()
	{
		Crach_Cape_Include_Start();
	}
	
	latent function Crach_Cape_Include_Start()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("characters\models\crowd_npc\skellige_villager\items\i_06_mb__skellige_villager_px.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Crach_Cape_Exclude
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Crach_Cape_Exclude
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Crach_Cape_Exclude();
	}
	
	entry function Crach_Cape_Exclude()
	{
		Crach_Cape_Exclude_Start();
	}
	
	latent function Crach_Cape_Exclude_Start()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("characters\models\crowd_npc\skellige_villager\items\i_06_mb__skellige_villager_px.w2ent", true);		
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Warden_Tail_Include
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Warden_Tail_Include
{
	private var temp_1, temp_2, temp_3																							: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Warden_Tail_Include();
	}
	
	entry function Warden_Tail_Include()
	{
		Warden_Tail_Include_Start();
	}
	
	latent function Warden_Tail_Include_Start()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden_alt.w2ent", true);		
		temp_2 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden.w2ent", true);	

		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_2);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Warden_Tail_Exclude
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Warden_Tail_Exclude
{
	private var temp_1, temp_2																									: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Warden_Tail_Exclude();
	}
	
	entry function Warden_Tail_Exclude()
	{
		Warden_Tail_Exclude_Start();
	}
	
	latent function Warden_Tail_Exclude_Start()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden_alt.w2ent", true);		
		temp_2 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden.w2ent", true);	

		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_2);

		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Additional_Helmets
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Additional_Helmets
{
	private var anchor_temp, helm_temp_1, helm_temp_2, helm_temp_3, helm_temp_4, helm_temp_5, helm_temp_6, helm_temp_7						: CEntityTemplate;
	private var bonePosition, attach_vec																									: Vector;
	private var boneRotation, attach_rot																									: EulerAngles;
	private var anchor, helm_1, helm_2, helm_3, helm_4																						: CEntity;
	private var l_actor 																													: CActor;
	private var l_comp, meshcomp1, meshcomp2, meshcomp3 																								: CComponent;
	private var h 	: float;
	private var inv : CInventoryComponent;
	private var witcher : W3PlayerWitcher;
	private var ids : array<SItemUniqueId>;
	private var size : int;
	private var i : int;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Additional_Helmets();
	}
	
	entry function Additional_Helmets()
	{
		GetACSWatcher().Additional_Helmets_Destroy();

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled())
		{
			Helmets_Attach_Shades();
		}
		else
		{
			Helmets_Attach();
		}
	}
	
	latent function Helmets_Attach_Shades()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );
		
		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		helm_temp_1 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\omen_helm.w2ent", true );

		helm_temp_2 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\hellbride.w2ent", true );

		//helm_temp_3 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\warden_no_hair.w2ent", true );

		helm_temp_4 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\c_01_mw__eredin.w2ent", true );

		if (ACS_Armor_Alpha_Equipped_Check())
		{
			helm_temp_5 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden_alt.w2ent", true);	
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			helm_temp_5 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden.w2ent", true);	
		}

		helm_temp_6 = (CEntityTemplate)LoadResource("dlc\bob\data\characters\models\crowd_npc\bob_knight\caps\c_03_mb__bob_knights_f4.w2ent", true);	

		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(helm_temp_5);

		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(helm_temp_6);

		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bonePosition, boneRotation );
		anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bonePosition, boneRotation );
		anchor.AddTag('acs_helm_anchor');

		/*
		helm_temp_1 = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\armour\berserker\h_01_berserker.w2ent", true );
				
		helm_1 = (CEntity)theGame.CreateEntity( helm_temp_1, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp1 = helm_1.GetComponentByClassName('CMeshComponent');
		h = 5;
		meshcomp1.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		//attach_vec.X = -2.07;
		attach_vec.X = -8.0775;
		attach_vec.Y = 0.0375;
		//attach_vec.Y = 0.08;
		attach_vec.Z = 0;
				
		helm_1.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_1.AddTag('helm_1');
		*/
				
		helm_1 = (CEntity)theGame.CreateEntity( helm_temp_1, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp1 = helm_1.GetComponentByClassName('CMeshComponent');
		h = 1;
		meshcomp1.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		//attach_vec.X = -2.07;
		//attach_vec.X = -2.0775;
		attach_vec.X = -1.725;
		//attach_vec.Y = 0.0375;
		attach_vec.Y = 0.065;
		attach_vec.Z = 0;
				
		helm_1.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_1.AddTag('acs_helm_1');
				
		helm_2 = (CEntity)theGame.CreateEntity( helm_temp_2, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp2 = helm_2.GetComponentByClassName('CMeshComponent');
		h = 0.875;
		meshcomp2.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 16.875;
		//attach_vec.X = -1.53;
		attach_vec.X = -1.33;
		//attach_vec.Y = -0.4625;
		//attach_vec.Y = -0.365;
		//attach_vec.Y = -0.362;
		attach_vec.Y = -0.375;
		attach_vec.Z = 0;	
		
		helm_2.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_2.AddTag('acs_helm_2');
				
		//helm_3 = (CEntity)theGame.CreateEntity( helm_temp_3, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
		//attach_rot.Roll = 90;
		//attach_rot.Pitch = 0;
		//attach_rot.Yaw = 0;
		//attach_vec.X = -1.625;
		//attach_vec.Y = -0.025;
		//attach_vec.Z = 0;
		
		//helm_3.CreateAttachment( anchor, , attach_vec, attach_rot );
		//helm_3.AddTag('helm_3');
				
		helm_4 = (CEntity)theGame.CreateEntity( helm_temp_4, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp3 = helm_4.GetComponentByClassName('CMeshComponent');
		h = 0.75;
		meshcomp3.SetScale(Vector(h,h,h,1));	
				
		attach_rot.Roll = 90;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		//attach_vec.X = -1.624;
		//attach_vec.X = -2.065;
		attach_vec.X = -1.525;
		attach_vec.Y = -0.025;
		attach_vec.Z = 0;
		
		helm_4.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_4.AddTag('acs_helm_4');
	}

	latent function Helmets_Attach()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );
		
		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		helm_temp_1 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\omen_helm_test.w2ent", true );

		helm_temp_2 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\hellbride_test.w2ent", true );

		//helm_temp_3 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden_no_hair_test.w2ent", true);		

		helm_temp_4 = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\armor\old_stuff\c_01_mw__eredin.w2ent", true );

		helm_temp_5 = (CEntityTemplate)LoadResource("dlc\bob\data\characters\models\crowd_npc\bob_knight\caps\c_03_mb__bob_knights_f4.w2ent", true);		

		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(helm_temp_5);
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bonePosition, boneRotation );
		anchor = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		anchor.CreateAttachmentAtBoneWS( thePlayer, 'head', bonePosition, boneRotation );
		anchor.PlayEffectSingle('eye_glow');
		anchor.AddTag('acs_helm_anchor');

		/*
		helm_temp_1 = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\armour\berserker\h_01_berserker.w2ent", true );
				
		helm_1 = (CEntity)theGame.CreateEntity( helm_temp_1, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp1 = helm_1.GetComponentByClassName('CMeshComponent');
		h = 5;
		meshcomp1.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		//attach_vec.X = -2.07;
		attach_vec.X = -8.0775;
		attach_vec.Y = 0.0375;
		//attach_vec.Y = 0.08;
		attach_vec.Z = 0;
				
		helm_1.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_1.AddTag('helm_1');
		*/
				
		helm_1 = (CEntity)theGame.CreateEntity( helm_temp_1, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp1 = helm_1.GetComponentByClassName('CMeshComponent');
		h = 1;
		meshcomp1.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		//attach_vec.X = -2.07;
		//attach_vec.X = -2.0775;
		attach_vec.X = -1.725;
		//attach_vec.Y = 0.0375;
		attach_vec.Y = 0.065;
		attach_vec.Z = 0;
				
		helm_1.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_1.AddTag('acs_helm_1');
				
		helm_2 = (CEntity)theGame.CreateEntity( helm_temp_2, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp2 = helm_2.GetComponentByClassName('CMeshComponent');
		h = 0.875;
		meshcomp2.SetScale(Vector(h,h,h,1));	

		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 16.875;
		//attach_vec.X = -1.53;
		attach_vec.X = -1.33;
		//attach_vec.Y = -0.4625;
		//attach_vec.Y = -0.365;
		//attach_vec.Y = -0.362;
		attach_vec.Y = -0.375;
		attach_vec.Z = 0;	
		
		helm_2.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_2.AddTag('acs_helm_2');

		//helm_3 = (CEntity)theGame.CreateEntity( helm_temp_3, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
		//attach_rot.Roll = 90;
		//attach_rot.Pitch = 0;
		//attach_rot.Yaw = 0;
		//attach_vec.X = -1.625;
		//attach_vec.Y = -0.025;
		//attach_vec.Z = 0;
		
		//helm_3.CreateAttachment( anchor, , attach_vec, attach_rot );
		//helm_3.AddTag('helm_3');
				
		helm_4 = (CEntity)theGame.CreateEntity( helm_temp_4, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp3 = helm_4.GetComponentByClassName('CMeshComponent');
		h = 0.75;
		meshcomp3.SetScale(Vector(h,h,h,1));	
				
		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		//attach_vec.X = -1.624;
		//attach_vec.X = -2.025;
		attach_vec.X = -1.5125;
		attach_vec.Y = 0.04;
		attach_vec.Z = 0;
		
		helm_4.CreateAttachment( anchor, , attach_vec, attach_rot );
		helm_4.AddTag('acs_helm_4');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSHelm1() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_helm_1' );
	return entity;
}

function GetACSHelm2() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_helm_2' );
	return entity;
}

function GetACSHelm3() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_helm_3' );
	return entity;
}

function GetACSHelm4() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_helm_4' );
	return entity;
}

function GetACSHelmAnchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_helm_anchor' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Additional_Helmet_Appearance_Destroy
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Additional_Helmet_Appearance_Destroy
{
	private var helm_temp_1, helm_temp_2, helm_temp_3, helm_temp_4																: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
	private var inv : CInventoryComponent;
	private var witcher : W3PlayerWitcher;
	private var ids : array<SItemUniqueId>;
	private var size : int;
	private var i : int;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Additional_Helmet_Appearance();
	}
	
	entry function Additional_Helmet_Appearance()
	{
		if ( ACS_SOI_Installed() && ACS_SOI_Enabled())
		{
			Helmet_Appearance_Exclude_Shades();
		}
		else
		{
			Helmet_Appearance_Exclude();
		}
	}
	
	latent function Helmet_Appearance_Exclude_Shades()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		helm_temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden_alt.w2ent", true);	

		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(helm_temp_1);

		helm_temp_2 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden.w2ent", true);	

		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(helm_temp_2);
		
		helm_temp_3 = (CEntityTemplate)LoadResource("dlc\bob\data\characters\models\crowd_npc\bob_knight\caps\c_03_mb__bob_knights_f4.w2ent", true);		

		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(helm_temp_3);

		inv = thePlayer.GetInventory();
    
		ids = inv.GetItemsByCategory( 'hair' );
		size = ids.Size();
		
		if( size > 0 )
		{					
			for( i = 0; i < size; i+=1 )
			{
				if(inv.IsItemMounted( ids[i] ) )
				{
					inv.MountItem(ids[i],,true);
				}
			}	
		}			
		ids.Clear();
	}

	latent function Helmet_Appearance_Exclude()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		//helm_temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\warden_alt.w2ent", true);		
		//helm_temp_1 = (CEntityTemplate)LoadResource("dlc\ep1\data\characters\models\main_npc\ewald_borsody\ewald_borsody_hood_01.w2ent", true);	
		helm_temp_1 = (CEntityTemplate)LoadResource("dlc\bob\data\characters\models\crowd_npc\bob_knight\caps\c_03_mb__bob_knights_f4.w2ent", true);			
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(helm_temp_1);

		inv = thePlayer.GetInventory();
    
		ids = inv.GetItemsByCategory( 'hair' );
		size = ids.Size();
		
		if( size > 0 )
		{					
			for( i = 0; i < size; i+=1 )
			{
				if(inv.IsItemMounted( ids[i] ) )
				{
					inv.MountItem(ids[i],,true);
				}
			}	
		}			
		ids.Clear();
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Shoulder_Armor_Toggle_On()
{
	var vACS_Shoulder_Armor_Toggle_On : cACS_Shoulder_Armor_Toggle_On;
	vACS_Shoulder_Armor_Toggle_On = new cACS_Shoulder_Armor_Toggle_On in theGame;
			
	vACS_Shoulder_Armor_Toggle_On.Engage();
}

statemachine class cACS_Shoulder_Armor_Toggle_On
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Shoulder_Armor_Toggle_On
{
	private var temp_1, temp_2, temp_3, temp_4, temp_5																			: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Shoulder_Armor_Toggle_On();
	}
	
	entry function Shoulder_Armor_Toggle_On()
	{
		Toggle_On();
	}
	
	latent function Toggle_On()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\berserkercape.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);

		temp_3 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\imlerith_arms.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_3);

		temp_5 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\wild_hunt_arm_cloth.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_5);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Shoulder_Armor_Toggle_Off()
{
	var vACS_Shoulder_Armor_Toggle_Off : cACS_Shoulder_Armor_Toggle_Off;
	vACS_Shoulder_Armor_Toggle_Off = new cACS_Shoulder_Armor_Toggle_Off in theGame;
			
	vACS_Shoulder_Armor_Toggle_Off.Engage();
}

statemachine class cACS_Shoulder_Armor_Toggle_Off
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Shoulder_Armor_Toggle_Off
{
	private var temp_1, temp_2, temp_3, temp_4, temp_5																			: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Shoulder_Armor_Toggle_Off();
	}
	
	entry function Shoulder_Armor_Toggle_Off()
	{
		Toggle_Off();
	}
	
	latent function Toggle_Off()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\berserkercape.w2ent", true);
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

		temp_3 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\imlerith_arms.w2ent", true);	
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_3);

		temp_5 = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\armor\old_stuff\wild_hunt_arm_cloth.w2ent", true);		
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_5);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Fur_Toggle_On()
{
	var vACS_Fur_Toggle_On : cACS_Fur_Toggle_On;
	vACS_Fur_Toggle_On = new cACS_Fur_Toggle_On in theGame;
			
	vACS_Fur_Toggle_On.Engage();
}

statemachine class cACS_Fur_Toggle_On
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Fur_Toggle_On
{
	private var temp_1, temp_2																									: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Fur_Toggle_On();
	}
	
	entry function Fur_Toggle_On()
	{
		Toggle_On();
	}
	
	latent function Toggle_On()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\modtemplates\batman\data\caranthir_fur.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);

		temp_2 = (CEntityTemplate)LoadResource("dlc\modtemplates\batman\data\fur\red_fur_black.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_2);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Fur_Toggle_Off()
{
	var vACS_Fur_Toggle_Off : cACS_Fur_Toggle_Off;
	vACS_Fur_Toggle_Off = new cACS_Fur_Toggle_Off in theGame;
			
	vACS_Fur_Toggle_Off.Engage();
}

statemachine class cACS_Fur_Toggle_Off
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Fur_Toggle_Off
{
	private var temp_1, temp_2																									: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Fur_Toggle_Off();
	}
	
	entry function Fur_Toggle_Off()
	{
		Toggle_Off();
	}
	
	latent function Toggle_Off()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\modtemplates\batman\data\caranthir_fur.w2ent", true);		
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);

		temp_2 = (CEntityTemplate)LoadResource("dlc\modtemplates\batman\data\fur\red_fur_black.w2ent", true);		
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_2);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Cape_Toggle_On()
{
	var vACS_Cape_Toggle_On : cACS_Cape_Toggle_On;
	vACS_Cape_Toggle_On = new cACS_Cape_Toggle_On in theGame;
			
	vACS_Cape_Toggle_On.Engage();
}

statemachine class cACS_Cape_Toggle_On
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Cape_Toggle_On
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Cape_Toggle_On();
	}
	
	entry function Cape_Toggle_On()
	{
		Toggle_On();
	}
	
	latent function Toggle_On()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\modtemplates\batman\data\berserkercape.w2ent", true);		
		((CAppearanceComponent)l_comp).IncludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Cape_Toggle_Off()
{
	var vACS_Cape_Toggle_Off : cACS_Cape_Toggle_Off;
	vACS_Cape_Toggle_Off = new cACS_Cape_Toggle_Off in theGame;
			
	vACS_Cape_Toggle_Off.Engage();
}

statemachine class cACS_Cape_Toggle_Off
{
    function Engage()
	{
		this.PushState('Engage');
	}
}

state Engage in cACS_Cape_Toggle_Off
{
	private var temp_1																											: CEntityTemplate;
	private var l_actor 																										: CActor;
	private var l_comp, meshcomp 																								: CComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Cape_Toggle_Off();
	}
	
	entry function Cape_Toggle_Off()
	{
		Toggle_Off();
	}
	
	latent function Toggle_Off()
	{	
		l_actor = thePlayer;
		l_comp = l_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp_1 = (CEntityTemplate)LoadResource("dlc\modtemplates\batman\data\berserkercape.w2ent", true);		
		((CAppearanceComponent)l_comp).ExcludeAppearanceTemplate(temp_1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Swordsanoo_Destroy()
{	
	var torso_anchor_1, torso_anchor_2, torso_anchor_3, torso_sword_1, torso_sword_2, torso_sword_3, r_bicep_anchor_1, l_bicep_anchor_1, r_bicep_sword_1, l_bicep_sword_1, r_bicep_sword_2, l_bicep_sword_2, r_shoulder_anchor_1, l_shoulder_anchor_1, r_shoulder_sword_1, l_shoulder_sword_1, r_shoulder_sword_2, l_shoulder_sword_2	: CEntity;	
	
	thePlayer.PlayEffectSingle('ethereal_appear');
	thePlayer.StopEffect('ethereal_appear');

	thePlayer.PlayEffectSingle('special_attack_only_black_fx');
	thePlayer.StopEffect('special_attack_only_black_fx');

	/*
	r_bicep_anchor_1 = (CEntity)theGame.GetEntityByTag( 'r_bicep_anchor_1' );
	r_bicep_anchor_1.BreakAttachment();
	r_bicep_anchor_1.Destroy();
				
	l_bicep_anchor_1 = (CEntity)theGame.GetEntityByTag( 'l_bicep_anchor_1' );
	l_bicep_anchor_1.BreakAttachment();
	l_bicep_anchor_1.Destroy();
				
	r_bicep_sword_1 = (CEntity)theGame.GetEntityByTag( 'r_bicep_sword_1' );
	r_bicep_sword_1.BreakAttachment();
	r_bicep_sword_1.Destroy();
				
	l_bicep_sword_1 = (CEntity)theGame.GetEntityByTag( 'l_bicep_sword_1' );
	l_bicep_sword_1.BreakAttachment();
	l_bicep_sword_1.Destroy();
	
	r_bicep_sword_2 = (CEntity)theGame.GetEntityByTag( 'r_bicep_sword_2' );
	r_bicep_sword_2.BreakAttachment();
	r_bicep_sword_2.Destroy();
				
	l_bicep_sword_2 = (CEntity)theGame.GetEntityByTag( 'l_bicep_sword_2' );
	l_bicep_sword_2.BreakAttachment();
	l_bicep_sword_2.Destroy();
	*/
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	r_shoulder_anchor_1 = (CEntity)theGame.GetEntityByTag( 'acs_r_shoulder_anchor_1' );
	r_shoulder_anchor_1.BreakAttachment();
	r_shoulder_anchor_1.Destroy();
				
	l_shoulder_anchor_1 = (CEntity)theGame.GetEntityByTag( 'acs_l_shoulder_anchor_1' );
	l_shoulder_anchor_1.BreakAttachment();
	l_shoulder_anchor_1.Destroy();
				
	r_shoulder_sword_1 = (CEntity)theGame.GetEntityByTag( 'acs_r_shoulder_sword_1' );
	r_shoulder_sword_1.BreakAttachment();
	r_shoulder_sword_1.Destroy();
				
	l_shoulder_sword_1 = (CEntity)theGame.GetEntityByTag( 'acs_l_shoulder_sword_1' );
	l_shoulder_sword_1.BreakAttachment();
	l_shoulder_sword_1.Destroy();
	
	r_shoulder_sword_2 = (CEntity)theGame.GetEntityByTag( 'acs_r_shoulder_sword_2' );
	r_shoulder_sword_2.BreakAttachment();
	r_shoulder_sword_2.Destroy();
				
	l_shoulder_sword_2 = (CEntity)theGame.GetEntityByTag( 'acs_l_shoulder_sword_2' );
	l_shoulder_sword_2.BreakAttachment();
	l_shoulder_sword_2.Destroy();
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	torso_anchor_1 = (CEntity)theGame.GetEntityByTag( 'acs_torso_anchor_1' );
	torso_anchor_1.BreakAttachment();
	torso_anchor_1.Destroy();
				
	torso_anchor_2 = (CEntity)theGame.GetEntityByTag( 'acs_torso_anchor_2' );
	torso_anchor_2.BreakAttachment();
	torso_anchor_2.Destroy();
	
	torso_anchor_3 = (CEntity)theGame.GetEntityByTag( 'acs_torso_anchor_3' );
	torso_anchor_3.BreakAttachment();
	torso_anchor_3.Destroy();
				
	torso_sword_1 = (CEntity)theGame.GetEntityByTag( 'acs_torso_sword_1' );
	torso_sword_1.BreakAttachment();
	torso_sword_1.Destroy();
				
	torso_sword_2 = (CEntity)theGame.GetEntityByTag( 'acs_torso_sword_2' );
	torso_sword_2.BreakAttachment();
	torso_sword_2.Destroy();
	
	torso_sword_3 = (CEntity)theGame.GetEntityByTag( 'acs_torso_sword_3' );
	torso_sword_3.BreakAttachment();
	torso_sword_3.Destroy();
}

statemachine class cACS_Swordsanoo extends CGameplayEntity
{
    function Normal()
	{
		this.PushState('Normal');
	}

	function Energy()
	{
		this.PushState('Energy');
	}
}

state Normal in cACS_Swordsanoo
{	
	private var anchor_temp, sword_temp																																										: CEntityTemplate;
	private var bonePosition, attach_vec																																										: Vector;
	private var boneRotation, attach_rot																																										: EulerAngles;
	private var torso_anchor_1, torso_anchor_2, torso_anchor_3, torso_sword_1, torso_sword_2, torso_sword_3, r_bicep_anchor_1, l_bicep_anchor_1, r_bicep_sword_1, l_bicep_sword_1, r_bicep_sword_2, l_bicep_sword_2, r_shoulder_anchor_1, l_shoulder_anchor_1, r_shoulder_sword_1, l_shoulder_sword_1, r_shoulder_sword_2, l_shoulder_sword_2																	: CEntity;	
	private var meshcomp1, meshcomp2, meshcomp3, meshcomp4, meshcomp5, meshcomp6, meshcomp7 																								: CComponent;
	private var h 	: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Swordsanoo_Normal_Entry();
	}
	
	entry function Swordsanoo_Normal_Entry()
	{
		Swordsanoo_Normal_Attach();
	}
	
	latent function Swordsanoo_Normal_Attach()
	{	
		ACS_Swordsanoo_Destroy();
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		anchor_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent", true );
		
		//sword_temp = (CEntityTemplate)LoadResourceAsync( "items\weapons\unique\eredin_sword.w2ent", true );
		//sword_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_shadesofiron\data\items\weapons\silverknife\zerri.w2ent", true );
		sword_temp = (CEntityTemplate)LoadResourceAsync( 
		//"dlc\bob\data\items\cutscenes\cs704_dettlaff_transformation\cs704_dettlaff_transformation_extra_arms.w2ent"
		//"dlc\bob\data\environment\decorations\gameplay\flags_banners\q705_flags\q705_flag_black_a.w2ent"
		"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent"
		, true );
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		//BICEP ANCHORS
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_bicep2' ), bonePosition, boneRotation );
		r_bicep_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		r_bicep_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'r_bicep2', bonePosition, boneRotation );
		r_bicep_anchor_1.AddTag('r_bicep_anchor_1');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_bicep2' ), bonePosition, boneRotation );
		l_bicep_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_bicep_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'l_bicep2', bonePosition, boneRotation );
		l_bicep_anchor_1.AddTag('l_bicep_anchor_1');
		*/
		//ShOULDER ANCHORS
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bonePosition, boneRotation );
		r_shoulder_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		r_shoulder_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bonePosition, boneRotation );
		r_shoulder_anchor_1.AddTag('r_shoulder_anchor_1');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_shoulder' ), bonePosition, boneRotation );
		l_shoulder_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_shoulder_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'l_shoulder', bonePosition, boneRotation );
		l_shoulder_anchor_1.AddTag('l_shoulder_anchor_1');
		
		//TORSO ANCHORS
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso3' ), bonePosition, boneRotation );
		torso_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		torso_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'torso3', bonePosition, boneRotation );
		torso_anchor_1.AddTag('acs_torso_anchor_1');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso2' ), bonePosition, boneRotation );
		torso_anchor_2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		torso_anchor_2.CreateAttachmentAtBoneWS( thePlayer, 'torso2', bonePosition, boneRotation );
		torso_anchor_2.AddTag('acs_torso_anchor_2');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso' ), bonePosition, boneRotation );
		torso_anchor_3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		torso_anchor_3.CreateAttachmentAtBoneWS( thePlayer, 'torso', bonePosition, boneRotation );
		torso_anchor_3.AddTag('acs_torso_anchor_3');
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*			
		r_bicep_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_bicep_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		r_bicep_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_bicep_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0.25;
		
		//-Forward/+Backward
		attach_vec.Y = 0;
		
		//+Left/-Right
		attach_vec.Z = -0.5;
		
		r_bicep_sword_1.CreateAttachment( r_bicep_anchor_1, , attach_vec, attach_rot );
		r_bicep_sword_1.AddTag('r_bicep_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0.25;
		
		//-Forward/+Backward
		attach_vec.Y = 0;
		
		//+Left/-Right
		attach_vec.Z = 0.5;
				
		l_bicep_sword_1.CreateAttachment( l_bicep_anchor_1, , attach_vec, attach_rot );
		l_bicep_sword_1.AddTag('l_bicep_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 65;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = 0.15;
		
		//+Left/-Right
		attach_vec.Z = -0.5;
		
		r_bicep_sword_2.CreateAttachment( r_bicep_anchor_1, , attach_vec, attach_rot );
		r_bicep_sword_2.AddTag('r_bicep_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 65;
		attach_rot.Pitch = 270;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = 0.15;
		
		//+Left/-Right
		attach_vec.Z = 0.5;
				
		l_bicep_sword_2.CreateAttachment( l_bicep_anchor_1, , attach_vec, attach_rot );
		l_bicep_sword_2.AddTag('l_bicep_sword_2');
		*/
		
		//SHOULDER//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		h = 1;	

		r_shoulder_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp1 = r_shoulder_sword_1.GetComponentByClassName('CMeshComponent');
		meshcomp1.SetScale(Vector(h,h,h,1));	

		l_shoulder_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp2 = l_shoulder_sword_1.GetComponentByClassName('CMeshComponent');
		meshcomp2.SetScale(Vector(h,h,h,1));

		r_shoulder_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp3 = r_shoulder_sword_2.GetComponentByClassName('CMeshComponent');
		meshcomp3.SetScale(Vector(h,h,h,1));

		l_shoulder_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp4 = l_shoulder_sword_2.GetComponentByClassName('CMeshComponent');
		meshcomp4.SetScale(Vector(h,h,h,1));
			
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		attach_rot.Roll = 75;
		attach_rot.Pitch = 135;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.1;
		
		//+Left/-Right
		attach_vec.Z = -0.25;
		
		r_shoulder_sword_1.CreateAttachment( torso_anchor_1, , attach_vec, attach_rot );
		r_shoulder_sword_1.AddTag('acs_r_shoulder_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 75;
		attach_rot.Pitch = 45;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.1;
		
		//+Left/-Right
		attach_vec.Z = 0.25;
				
		l_shoulder_sword_1.CreateAttachment( torso_anchor_1, , attach_vec, attach_rot );
		l_shoulder_sword_1.AddTag('acs_l_shoulder_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 35;
		attach_rot.Pitch = 115;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.1;
		
		//+Left/-Right
		attach_vec.Z = 0;
		
		r_shoulder_sword_2.CreateAttachment( torso_anchor_2, , attach_vec, attach_rot );
		r_shoulder_sword_2.AddTag('acs_r_shoulder_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 35;
		attach_rot.Pitch = 65;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.1;
		
		//+Left/-Right
		attach_vec.Z = 0;
				
		l_shoulder_sword_2.CreateAttachment( torso_anchor_2, , attach_vec, attach_rot );
		l_shoulder_sword_2.AddTag('acs_l_shoulder_sword_2');
		
		//TORSO//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		torso_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp5 = torso_sword_1.GetComponentByClassName('CMeshComponent');
		meshcomp5.SetScale(Vector(h,h,h,1));

		torso_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp6 = torso_sword_2.GetComponentByClassName('CMeshComponent');
		meshcomp6.SetScale(Vector(h,h,h,1));

		torso_sword_3 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp7 = torso_sword_3.GetComponentByClassName('CMeshComponent');
		meshcomp7.SetScale(Vector(h,h,h,1));
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		
		attach_rot.Roll = 75;
		attach_rot.Pitch = 90;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.1;
		
		//+Left/-Right
		attach_vec.Z = 0;
		
		torso_sword_1.CreateAttachment( torso_anchor_1, , attach_vec, attach_rot );
		torso_sword_1.AddTag('acs_torso_sword_1');

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 35;
		attach_rot.Pitch = 90;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.1;
		
		//+Left/-Right
		attach_vec.Z = 0;
				
		torso_sword_2.CreateAttachment( torso_anchor_2, , attach_vec, attach_rot );
		torso_sword_2.AddTag('acs_torso_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 15;
		attach_rot.Pitch = 90;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.15;
		
		//+Left/-Right
		attach_vec.Z = 0;
				
		torso_sword_3.CreateAttachment( torso_anchor_3, , attach_vec, attach_rot );
		torso_sword_3.AddTag('acs_torso_sword_3');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Energy in cACS_Swordsanoo
{	
	private var anchor_temp, sword_temp																																										: CEntityTemplate;
	private var bonePosition, attach_vec																																										: Vector;
	private var boneRotation, attach_rot																																										: EulerAngles;
	private var torso_anchor_1, torso_anchor_2, torso_anchor_3, torso_sword_1, torso_sword_2, torso_sword_3, r_bicep_anchor_1, l_bicep_anchor_1, r_bicep_sword_1, l_bicep_sword_1, r_bicep_sword_2, l_bicep_sword_2, r_shoulder_anchor_1, l_shoulder_anchor_1, r_shoulder_sword_1, l_shoulder_sword_1, r_shoulder_sword_2, l_shoulder_sword_2																	: CEntity;	
	private var meshcomp1, meshcomp2, meshcomp3, meshcomp4, meshcomp5, meshcomp6, meshcomp7 																								: CComponent;
	private var h 	: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Swordsanoo_Energy_Entry();
	}
	
	entry function Swordsanoo_Energy_Entry()
	{
		Swordsanoo_Energy_Attach();
	}
	
	latent function Swordsanoo_Energy_Attach()
	{	
		ACS_Swordsanoo_Destroy();
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		//sword_temp = (CEntityTemplate)LoadResource( "items\weapons\unique\eredin_sword.w2ent", true );
		//sword_temp = (CEntityTemplate)LoadResource( "dlc\dlc_shadesofiron\data\items\weapons\silverknife\zerri.w2ent", true );
		sword_temp = (CEntityTemplate)LoadResource( 
		//"dlc\bob\data\items\cutscenes\cs704_dettlaff_transformation\cs704_dettlaff_transformation_extra_arms.w2ent"
		"dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent"
		//"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent"

		//"items\weapons\unique\eredin_sword.w2ent"
		, true );
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		//BICEP ANCHORS
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_bicep2' ), bonePosition, boneRotation );
		r_bicep_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		r_bicep_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'r_bicep2', bonePosition, boneRotation );
		r_bicep_anchor_1.AddTag('r_bicep_anchor_1');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_bicep2' ), bonePosition, boneRotation );
		l_bicep_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_bicep_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'l_bicep2', bonePosition, boneRotation );
		l_bicep_anchor_1.AddTag('l_bicep_anchor_1');
		*/
		//ShOULDER ANCHORS
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_shoulder' ), bonePosition, boneRotation );
		r_shoulder_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		r_shoulder_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'r_shoulder', bonePosition, boneRotation );
		r_shoulder_anchor_1.AddTag('r_shoulder_anchor_1');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_shoulder' ), bonePosition, boneRotation );
		l_shoulder_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_shoulder_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'l_shoulder', bonePosition, boneRotation );
		l_shoulder_anchor_1.AddTag('l_shoulder_anchor_1');
		
		//TORSO ANCHORS
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso3' ), bonePosition, boneRotation );
		torso_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		torso_anchor_1.CreateAttachmentAtBoneWS( thePlayer, 'torso3', bonePosition, boneRotation );
		torso_anchor_1.AddTag('acs_torso_anchor_1');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso2' ), bonePosition, boneRotation );
		torso_anchor_2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		torso_anchor_2.CreateAttachmentAtBoneWS( thePlayer, 'torso2', bonePosition, boneRotation );
		torso_anchor_2.AddTag('acs_torso_anchor_2');
		
		thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'torso' ), bonePosition, boneRotation );
		torso_anchor_3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		torso_anchor_3.CreateAttachmentAtBoneWS( thePlayer, 'torso', bonePosition, boneRotation );
		torso_anchor_3.AddTag('acs_torso_anchor_3');
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*			
		r_bicep_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_bicep_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		r_bicep_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		l_bicep_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
				
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0.25;
		
		//-Forward/+Backward
		attach_vec.Y = 0;
		
		//+Left/-Right
		attach_vec.Z = -0.5;
		
		r_bicep_sword_1.CreateAttachment( r_bicep_anchor_1, , attach_vec, attach_rot );
		r_bicep_sword_1.AddTag('r_bicep_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0.25;
		
		//-Forward/+Backward
		attach_vec.Y = 0;
		
		//+Left/-Right
		attach_vec.Z = 0.5;
				
		l_bicep_sword_1.CreateAttachment( l_bicep_anchor_1, , attach_vec, attach_rot );
		l_bicep_sword_1.AddTag('l_bicep_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 65;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = 0.15;
		
		//+Left/-Right
		attach_vec.Z = -0.5;
		
		r_bicep_sword_2.CreateAttachment( r_bicep_anchor_1, , attach_vec, attach_rot );
		r_bicep_sword_2.AddTag('r_bicep_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 65;
		attach_rot.Pitch = 270;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = 0.15;
		
		//+Left/-Right
		attach_vec.Z = 0.5;
				
		l_bicep_sword_2.CreateAttachment( l_bicep_anchor_1, , attach_vec, attach_rot );
		l_bicep_sword_2.AddTag('l_bicep_sword_2');
		*/
		
		//SHOULDER//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		h = 1;	

		r_shoulder_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp1 = r_shoulder_sword_1.GetComponentByClassName('CMeshComponent');
		meshcomp1.SetScale(Vector(h,h,h,1));	

		l_shoulder_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp2 = l_shoulder_sword_1.GetComponentByClassName('CMeshComponent');
		meshcomp2.SetScale(Vector(h,h,h,1));

		r_shoulder_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp3 = r_shoulder_sword_2.GetComponentByClassName('CMeshComponent');
		meshcomp3.SetScale(Vector(h,h,h,1));

		l_shoulder_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp4 = l_shoulder_sword_2.GetComponentByClassName('CMeshComponent');
		meshcomp4.SetScale(Vector(h,h,h,1));
			
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		attach_rot.Roll = 75;
		attach_rot.Pitch = 135;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -1;
		
		//-Forward/+Backward
		attach_vec.Y = 0.125;
		
		//+Left/-Right
		attach_vec.Z = 0;
		
		r_shoulder_sword_1.CreateAttachment( torso_anchor_1, , attach_vec, attach_rot );
		r_shoulder_sword_1.AddTag('acs_r_shoulder_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 75;
		attach_rot.Pitch = 45;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -1;
		
		//-Forward/+Backward
		attach_vec.Y = 0.125;
		
		//+Left/-Right
		attach_vec.Z = 0;
				
		l_shoulder_sword_1.CreateAttachment( torso_anchor_1, , attach_vec, attach_rot );
		l_shoulder_sword_1.AddTag('acs_l_shoulder_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 35;
		attach_rot.Pitch = 115;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -0.5;
		
		//-Forward/+Backward
		attach_vec.Y = 0.75;
		
		//+Left/-Right
		attach_vec.Z = 0.25;
		
		r_shoulder_sword_2.CreateAttachment( torso_anchor_2, , attach_vec, attach_rot );
		r_shoulder_sword_2.AddTag('acs_r_shoulder_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 35;
		attach_rot.Pitch = 65;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -0.5;
		
		//-Forward/+Backward
		attach_vec.Y = 0.75;
		
		//+Left/-Right
		attach_vec.Z = -0.25;
				
		l_shoulder_sword_2.CreateAttachment( torso_anchor_2, , attach_vec, attach_rot );
		l_shoulder_sword_2.AddTag('acs_l_shoulder_sword_2');
		
		//TORSO//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		torso_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp5 = torso_sword_1.GetComponentByClassName('CMeshComponent');
		meshcomp5.SetScale(Vector(h,h,h,1));

		torso_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp6 = torso_sword_2.GetComponentByClassName('CMeshComponent');
		meshcomp6.SetScale(Vector(h,h,h,1));

		torso_sword_3 = (CEntity)theGame.CreateEntity( sword_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -10 ) );
		meshcomp7 = torso_sword_3.GetComponentByClassName('CMeshComponent');
		meshcomp7.SetScale(Vector(h,h,h,1));
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		
		attach_rot.Roll = 75;
		attach_rot.Pitch = 90;
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -1.5;
		
		//-Forward/+Backward
		attach_vec.Y = 0.25;
		
		//+Left/-Right
		attach_vec.Z = 0;
		
		torso_sword_1.CreateAttachment( torso_anchor_1, , attach_vec, attach_rot );
		torso_sword_1.AddTag('acs_torso_sword_1');

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 35;
		attach_rot.Pitch = 90;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -0.75;
		
		//-Forward/+Backward
		attach_vec.Y = 0.25;
		
		//+Left/-Right
		attach_vec.Z = 0;
				
		torso_sword_2.CreateAttachment( torso_anchor_2, , attach_vec, attach_rot );
		torso_sword_2.AddTag('acs_torso_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		attach_rot.Roll = 15;
		attach_rot.Pitch = 90;
		
		attach_rot.Yaw = 0;
		
		//-Up/+Down
		attach_vec.X = -0.5;
		
		//-Forward/+Backward
		attach_vec.Y = -0.45;
		
		//+Left/-Right
		attach_vec.Z = 0;
				
		torso_sword_3.CreateAttachment( torso_anchor_3, , attach_vec, attach_rot );
		torso_sword_3.AddTag('acs_torso_sword_3');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function torso_anchor_1() : CEntity
{
	var anchor 			 : CEntity;
	
	anchor = (CEntity)theGame.GetEntityByTag( 'acs_torso_anchor_1' );
	return anchor;
}

function torso_anchor_2() : CEntity
{
	var anchor 			 : CEntity;
	
	anchor = (CEntity)theGame.GetEntityByTag( 'acs_torso_anchor_2' );
	return anchor;
}

function torso_anchor_3() : CEntity
{
	var anchor 			 : CEntity;
	
	anchor = (CEntity)theGame.GetEntityByTag( 'acs_torso_anchor_3' );
	return anchor;
}