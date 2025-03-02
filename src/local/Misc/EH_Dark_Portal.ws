statemachine class CACSDarkPortal extends CGameplayEntity
{
	var pos : Vector;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		pos = this.GetWorldPosition();

		this.AddTag('ACS_Dark_Portal');
		this.PushState( 'PortalRun' );

		AddTimer('DetectLife', 0.0001, true);
	}
	
	timer function DetectLife( time : float, optional id : int)
	{
		var actors    														: array<CGameplayEntity>;
		var i																: int;
		var actor															: CActor;

		actors.Clear();

		FindGameplayEntitiesInSphere( actors, this.GetWorldPosition(), 5, 99, , FLAG_OnlyAliveActors, ,);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			if( actors.Size() > 0 )
			{
				actor = (CActor) actors[i];

				if (actor && actor == thePlayer)
				{
					this.PushState( 'PortalSummon' );

					RemoveTimer('DetectLife');
				}
			}
		}
	}
}

state PortalRun in CACSDarkPortal 
{
	var playerRot, adjustedRot				: EulerAngles;
	var portalEntity						: CEntity;

	event OnEnterState(prevStateName : name)
	{
		PortalRun_Entry();
	}
	
	entry function PortalRun_Entry()
	{	
		PortalRun_Latent();
	}

	latent function PortalRun_Latent()
	{
		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		portalEntity = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\dark_portal.w2ent"
			
		, true ), ACSPlayerFixZAxis(parent.pos), adjustedRot);

		portalEntity.PlayEffectSingle('teleport_fx');

		portalEntity.AddTag('ACS_Dark_Portal_Ent');

		portalEntity.DestroyAfter(30);
	}
}

state PortalSummon in CACSDarkPortal 
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, portalEntity, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Caranthir_Summon();
	}
	
	entry function Caranthir_Summon()
	{
		Caranthir_Summon_Latent();
	}
	
	latent function Caranthir_Summon_Latent()
	{
		ACSGetCActor('ACS_Canaris').Destroy();

		ACSGetCEntity('ACS_Canaris_Melee_Effect').Destroy();

		ACSGetCEntity('ACS_Dark_Portal_Ent').DestroyAfter(3);

		parent.DestroyAfter(3);

		if (FactsQuerySum("q501_canaris_died") > 0)
		{
			temp = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\mages\canaris_alt.w2ent"
				
			, true );
		}
		else
		{
			temp = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\mages\canaris.w2ent"
				
			, true );
		}


		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;




		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CNewNPC)ent).SetCanPlayHitAnim(false); 

		((CNewNPC)ent).SetVisibility(false);


		GetACSWatcher().AddTimer('ACS_Caranthir_Set_Visibility', 1, false);


		GetACSWatcher().AddTimer('ACS_Caranthir_Weapon_FX_Attach', 1, false);



		ent.AddTag( 'ACS_Canaris' );

		ent.AddTag( 'ACS_Custom_Monster' );

		ent.AddTag('ACS_Dark_Portal_Canaris');
	}	
}