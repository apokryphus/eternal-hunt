// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
// Not authorized to be distributed elsewhere, unless you ask me nicely.

function ACS_Custom_Attack_Range( data : CPreAttackEventData ) : array< CGameplayEntity >
{
	var targets 					: array<CGameplayEntity>;
	var dist, ang					: float;
	var pos, targetPos				: Vector;
	var i							: int;
	
	if (!thePlayer.IsPerformingFinisher())
	{
		if ( thePlayer.IsWeaponHeld( 'fist' ) )
		{
			dist = 1.125;
			ang = 30;

			if ( thePlayer.HasTag('acs_vampire_claws_equipped') )
			{
				dist += 0.125;
				ang += 30;

				if ( thePlayer.HasBuff(EET_BlackBlood))
				{
					dist += 1.75;
					ang += 30;
				}

				if ( thePlayer.HasBuff(EET_Mutagen22))
				{
					dist += 2.75;
					ang += 60;
				}
			}
		}
		else
		{
			if ( 
			thePlayer.HasTag('acs_igni_sword_equipped_TAG') 
			|| thePlayer.HasTag('acs_igni_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	70;

				if(  thePlayer.IsDoingSpecialAttack( false ) )
				{
					ang +=	315;
				}

				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						dist += 1.1;
					}
					else if(  thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1.9;
					}
				}
			}
			else if ( thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG') 
			|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	70;

				if(  thePlayer.IsDoingSpecialAttack( false ) )
				{
					ang +=	315;
				}

				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						dist += 1.1;
					}
					else if(  thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1.9;
					}
				}
			}
			else if ( thePlayer.HasTag('acs_axii_sword_equipped') )
			{
				dist = 1.6;
				ang =	70;	

				if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					dist += 10;
					ang +=	30;
				}
			}
			else if ( thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			{
				if ( 
				ACS_GetWeaponMode() == 0
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2
				)
				{
					dist = 2.25;
					ang =	70;
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{ 
					dist = 1.75;
					ang =	70;
				}
			}
			else if ( thePlayer.HasTag('acs_aard_sword_equipped') )
			{
				dist = 2;
				ang =	75;	
			}
			else if ( thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			{
				dist = 2;
				ang = 70;
			}
			else if ( thePlayer.HasTag('acs_yrden_sword_equipped') )
			{
				if ( ACS_GetWeaponMode() == 0 )
				{
					if (ACS_GetArmigerModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 70;
					}
					else 
					{
						dist = 2;
						ang = 70;
					}
				}
				else if ( ACS_GetWeaponMode() == 1 )
				{
					if (ACS_GetFocusModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 70;
					}
					else 
					{
						dist = 2;
						ang = 70;
					}
				}
				else if ( ACS_GetWeaponMode() == 2 )
				{
					if (ACS_GetHybridModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 70;
					}
					else 
					{
						dist = 2;
						ang = 70;
					}
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{
					dist = 2.5;
					ang = 70;
				}
			}
			else if ( thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( thePlayer.HasTag('acs_quen_sword_equipped') )
			{
				dist = 1.6;
				ang =	70;

				if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
				{
					ang +=	320;
				}
			}
			else if ( thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
			{
				if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
				{
					dist = 10;
					ang =	30;
				}
				else
				{
					dist = 2.25;
					ang =	70;
				}
			}
			else 
			{
				dist = 1.25;
				ang = 30;
			}

			if (ACS_Armor_Equipped_Check())
			{
				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if( !thePlayer.IsDoingSpecialAttack( false )
					&& !thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1.5;
					}
				}
				else
				{
					dist += 1.5;
				}
			}
		}

		if ( thePlayer.GetTarget() == ACSGetCActor('ACS_Big_Boi') )
		{
			dist += 0.75;
			ang += 15;

			if (((CNewNPC)thePlayer.GetTarget()).IsFlying())
			{
				dist += 1.25;
				ang += 15;
			}
		}

		if (ACS_Player_Scale() > 1)
		{
			dist += ACS_Player_Scale() * 0.75;
		}
		else if (ACS_Player_Scale() < 1)
		{
			dist -= ACS_Player_Scale() * 0.5;
		}

		if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
		&& !thePlayer.HasTag('acs_igni_sword_equipped') 
		&& !thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
		&& !ACS_Armor_Equipped_Check())
		{
			dist += 1;
		}

		if (thePlayer.IsUsingHorse()) 
		{
			dist += 1.5;

			ang += 270;
		}

		if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
		{
			dist += 1.5;

			ang += 315;
		}

		if (thePlayer.HasTag('ACS_In_Dance_Of_Wrath'))
		{
			dist += 1.5;

			ang += 315;
		}

		if (ACS_Bear_School_Check())
		{
			dist += 0.5;
			ang +=	15;

			if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
			{
				dist += 1.5;
			}
		}

		if (ACS_Griffin_School_Check()
		&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
		{
			dist += 2;
			ang +=	15;
		}

		if (ACS_Manticore_School_Check())
		{
			dist += 0.5;

			if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
			{
				dist += 1.5;
			}
		}

		if (ACS_Viper_School_Check())
		{
			if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
			{
				dist += 1.5;
			}
		}
	}
	else 
	{
		dist = 1.125;
		ang = 30;
	}

	targets.Clear();

	pos = thePlayer.GetWorldPosition();
	pos.Z += 0.8;

	FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
	for( i = targets.Size()-1; i >= 0; i -= 1 ) 
	{	
		targetPos = targets[i].GetWorldPosition();
		if ( AbsF( targetPos.Z - pos.Z ) > 2.5 )
		{
			targets.EraseFast(i);
		}
	}	

	return targets;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Main Settings

function ACS_Load_Sound()
{
	if ( !theSound.SoundIsBankLoaded("magic_caranthil.bnk") )
	{
		theSound.SoundLoadBank( "magic_caranthil.bnk", false );
	}
		
	if ( !theSound.SoundIsBankLoaded("magic_olgierd.bnk") )
	{
		theSound.SoundLoadBank( "magic_olgierd.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_dettlaff_monster.bnk") )
	{
		theSound.SoundLoadBank( "monster_dettlaff_monster.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_bruxa.bnk") )
	{
		theSound.SoundLoadBank( "monster_bruxa.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("magic_eredin.bnk") )
	{
		theSound.SoundLoadBank( "magic_eredin.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("magic_imlerith.bnk") )
	{
		theSound.SoundLoadBank( "magic_imlerith.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_dettlaff_vampire.bnk") )
	{
		theSound.SoundLoadBank( "monster_dettlaff_vampire.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("monster_caretaker.bnk") )
	{
		theSound.SoundLoadBank( "monster_caretaker.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("grunt_vo_wild_hunt.bnk") )
	{
		theSound.SoundLoadBank( "grunt_vo_wild_hunt.bnk", false );
	}
	
	if ( !theSound.SoundIsBankLoaded("grunt_vo_sentry_male.bnk") )
	{
		theSound.SoundLoadBank( "grunt_vo_sentry_male.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_cloud_giant.bnk") )
	{
		theSound.SoundLoadBank( "monster_cloud_giant.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_knight_giant.bnk") )
	{
		theSound.SoundLoadBank( "monster_knight_giant.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_yennefer.bnk") )
	{
		theSound.SoundLoadBank( "magic_yennefer.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("fx_fire.bnk") )
	{
		theSound.SoundLoadBank( "fx_fire.bnk", true );
	}

	if ( !theSound.SoundIsBankLoaded("qu_ep1_601.bnk") )
	{
		theSound.SoundLoadBank( "qu_ep1_601.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_man_mage.bnk") )
	{
		theSound.SoundLoadBank( "magic_man_mage.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_item_olgierd_sabre.bnk") )
	{
		theSound.SoundLoadBank( "qu_item_olgierd_sabre.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_water_mage.bnk") )
	{
		theSound.SoundLoadBank( "monster_water_mage.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_dracolizard.bnk") )
	{
		theSound.SoundLoadBank( "monster_dracolizard.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_bies.bnk") )
	{
		theSound.SoundLoadBank( "monster_bies.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_him.bnk") )
	{
		theSound.SoundLoadBank( "monster_him.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_ep2_704_regis.bnk") )
	{
		theSound.SoundLoadBank( "qu_ep2_704_regis.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("sq_sk_209.bnk") )
	{
		theSound.SoundLoadBank( "sq_sk_209.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("animals_wolf.bnk") )
	{
		theSound.SoundLoadBank( "animals_wolf.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_wild_dog.bnk") )
	{
		theSound.SoundLoadBank( "monster_wild_dog.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_werewolf.bnk") )
	{
		theSound.SoundLoadBank( "monster_werewolf.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_fleder.bnk") )
	{
		theSound.SoundLoadBank( "monster_fleder.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_item_demonic_saddle.bnk") )
	{
		theSound.SoundLoadBank( "qu_item_demonic_saddle.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_sorceress.bnk") )
	{
		theSound.SoundLoadBank( "magic_sorceress.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_cyclop.bnk") )
	{
		theSound.SoundLoadBank( "monster_cyclop.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_lessun.bnk") )
	{
		theSound.SoundLoadBank( "monster_lessun.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("fx_enviro.bnk") )
	{
		theSound.SoundLoadBank( "fx_enviro.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_nml_103.bnk") )
	{
		theSound.SoundLoadBank( "qu_nml_103.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_triss.bnk") )
	{
		theSound.SoundLoadBank( "magic_triss.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_skellige_210.bnk") )
	{
		theSound.SoundLoadBank( "qu_skellige_210.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_djinn.bnk") )
	{
		theSound.SoundLoadBank( "magic_djinn.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_item_fire_eater_torch.bnk") )
	{
		theSound.SoundLoadBank( "qu_item_fire_eater_torch.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_wildhunt_minion.bnk") )
	{
		theSound.SoundLoadBank( "monster_wildhunt_minion.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_panther.bnk") )
	{
		theSound.SoundLoadBank( "monster_panther.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("qu_ep2_704_bats.bnk") )
	{
		theSound.SoundLoadBank( "qu_ep2_704_bats.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("work_voiceovers.bnk") )
	{
		theSound.SoundLoadBank( "work_voiceovers.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("music_main_menu_credits.bnk") )
	{
		theSound.SoundLoadBank( "music_main_menu_credits.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_golem.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_cockatrice.bnk") )
	{
		theSound.SoundLoadBank( "monster_cockatrice.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_harpy.bnk") )
	{
		theSound.SoundLoadBank( "monster_harpy.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("monster_griffon.bnk") )
	{
		theSound.SoundLoadBank( "monster_griffon.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("animals_crow.bnk") )
	{
		theSound.SoundLoadBank( "animals_crow.bnk", false );
	}

	if ( !theSound.SoundIsBankLoaded("magic_teleport.bnk") )
	{
		theSound.SoundLoadBank( "magic_teleport.bnk", false );
	}
}

function ACS_Enabled(): bool 
{
	if (ACS_ModEnabled() && !thePlayer.IsCiri() )
	{
		return true;
	}

	return false;
}

function ACS_Init_Attempt()
{
	if (!ACS_IsInitialized()) 
	{
      ACS_InitializeSettings();
	  ACS_Tutorial_Popup_Display(2117035665, 2117035666);
    }
	else
	{
		theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodVersionControl', ACS_GetVersion());
	}
}

function ACS_InitNotification() 
{
	theGame.GetGuiManager().ShowNotification(GetLocStringByKey("ACS_initialized"));
}

function ACSSettingsGetConfigValue(menuName, menuItemName : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue(menuName, menuItemName);

	return value;
}

function ACS_ModEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMain','EHmodEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_IsInitialized(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMain','EHmodInit');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_InitializeOverride(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMain','EHmodInitOverride');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_VersionControl(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMain','EHmodVersionControl');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return ACS_GetVersion();
	}
	
	else return configValue;
}

function ACS_InitializeSettings() 
{
	theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodEnabled', "true");

	theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodInit', "true");

	theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodVersionControl', ACS_GetVersion());

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'Minimap2Module', "false");

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'QuestsModule', "false");

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodCombatMainSettings', 3);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodParrySkillsSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodCustomFinishersSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodRageMechanicSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodSignComboSystemSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodArmigerModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodFocusModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodHybridModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodGuardAttackSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodMovementSettings', 1);
	
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodTauntSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodDamageSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodMiscSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodVisualSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodHudSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodStaminaSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodEncountersSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodEventsSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodAdditionalWorldEncountersSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodDodgeSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodJumpSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodBruxaDashSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodWraithModeSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodDarknessSettings', 0);

	theGame.SaveUserSettings();
}

function ACS_DisableAutomaticSwordSheathe_Enabled(): bool
{
	return theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'DisableAutomaticSwordSheathe');
}

// Graphics Settings

function ACS_GetHairworksMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('Graphics','Virtual_HairWorksLevel');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Combat Main Settings

function ACS_GetWeaponMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodWeaponMode');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return 3;
	}

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_OnHitEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodOnHitEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_HitLag_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodHitLag');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_ElementalRend_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodElementalRend');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_GetFistMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodFistMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetTargetMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetTargetingCameraWeight(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetCameraWeight');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1.0;
	}
	
	else return configValue;
}

function ACS_GetTargetingMovementWeight(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetMovementWeight');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.75;
	}
	
	else return configValue;
}

function ACS_GetTargetingFacingWeight(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetFacingWeight');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.25;
	}
	
	else return configValue;
}

function ACS_GetTargetingDistanceWeight(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetDistanceWeight');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1.0;
	}
	
	else return configValue;
}

function ACS_GetTargetingHysteresis(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetHysteresis');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1.05;
	}
	
	else return configValue;
}

function ACS_GetTargetingDistanceMin(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetDistanceMin');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 50;
	}
	
	else return configValue;
}

function ACS_GetTargetingDistanceMax(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetDistanceMax');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 50;
	}
	
	else return configValue;
}

function ACS_GetTargetingDistanceInteraction(): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetDistanceInteraction');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 50;
	}
	
	else return configValue;
}

function ACS_GetTargetingInFrameCheck(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodTargetInFrameCheck');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_GetTargetingDisableCameraLock(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodDisableCameraLock');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_GetTargetingCastSignTowardsCameraCheck(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTargetSettings','EHmodCastSignTowardsCameraCheck');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_ComboMode(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodComboMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_CombatStance_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodCombatStanceEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Sneaking_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodSneakingEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_DefaultMovesetCombatAnimationOverrideMode_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatMainSettings','EHmodDefaultMovesetCombatAnimationOverrideModeEnabled');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if (thePlayer.HasBuff(EET_AirDrain)
	|| thePlayer.HasBuff(EET_Choking)
	|| thePlayer.HasBuff(EET_Drowning)
	)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Armiger Mode

function ACS_GetArmigerModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Armiger_Axii_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

function ACS_Armiger_Aard_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_Armiger_Yrden_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 4;
	}
	
	else return configValue;
}

function ACS_Armiger_Quen_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Armiger_Igni_Set_Sign_Weapon_Type(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Focus Mode

function ACS_GetFocusModeSilverWeapon(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetFocusModeSteelWeapon(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetFocusModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodFocusModeSettings','EHmodFocusModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Hybrid Mode

function ACS_GetHybridModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeLightAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeLightAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeForwardLightAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeForwardLightAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeHeavyAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeHeavyAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeForwardHeavyAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeForwardHeavyAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeSpecialAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeSpecialAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeForwardSpecialAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeForwardSpecialAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_GetHybridModeCounterAttack(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHybridModeSettings','EHmodHybridModeCounterAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Counterattack/Parry Skill Settings

function ACS_ParrySkillsEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodParrySkillsSettings','EHmodParrySkillsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_ParrySkillsBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodParrySkillsSettings','EHmodParrySkillsBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_PushSkillsBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodParrySkillsSettings','EHmodPushSkillsBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_DaggerBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodParrySkillsSettings','EHmodDaggerBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 6;
	}
	
	else return configValue;
}

function ACS_GetParrySkillsBind(): ACS_ParrySkillsBind 
{
	return ACS_ParrySkillsBind();
}

function ACS_GetPushSkillsBind(): ACS_ParrySkillsBind 
{
	return ACS_PushSkillsBind();
}

function ACS_GetDaggerBind(): ACS_ParrySkillsBind 
{
	return ACS_DaggerBind();
}

enum ACS_ParrySkillsBind 
{
	ACS_ParrySkillsBind_Forward = 0,
	ACS_ParrySkillsBind_Backward = 1,
	ACS_ParrySkillsBind_Left = 2,
	ACS_ParrySkillsBind_Right = 3,
	ACS_ParrySkillsBindForwardOrBackward = 4,
	ACS_ParrySkillsBind_LeftOrRight = 5,
	ACS_ParrySkillsBind_LightAttack = 6,
	ACS_ParrySkillsBind_HeavyAttack = 7,
	ACS_ParrySkillsBind_None = 8
}

// Custom Finishers Settings

function ACS_CustomFinishersEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodCustomFinishersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_AutoFinisher_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodAutoFinisherEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_ExperimentalDismemberment_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodExperimentalDismemberment');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BurningAlwaysDismember_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodBurningAlwaysDismember');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_HeavyAttackAlwaysDismember_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodHeavyAttackAlwaysDismember');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_CustomFinisherChance(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodCustomFinisherChance');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_CustomFinishersCameraSettings(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodCustomFinishersCameraSettings');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_FinishersTorsoBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersTorsoBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_FinishersStabBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersStabBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_FinishersNeckBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersNeckBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

function ACS_FinishersHeadLeftBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersHeadLeftBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_FinishersHeadRightBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersHeadRightBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 4;
	}
	
	else return configValue;
}

function ACS_FinishersArmLeftBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersArmLeftBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_FinishersArmRightBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersArmRightBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 6;
	}
	
	else return configValue;
}

function ACS_FinishersLegLeftBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersLegLeftBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_FinishersLegRightBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCustomFinishersSettings','EHmodFinishersLegRightBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 8;
	}
	
	else return configValue;
}

function ACS_GetFinishersTorsoBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersTorsoBind();
}

function ACS_GetFinishersStabBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersStabBind();
}

function ACS_GetFinishersNeckBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersNeckBind();
}

function ACS_GetFinishersHeadLeftBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersHeadLeftBind();
}

function ACS_GetFinishersHeadRightBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersHeadRightBind();
}

function ACS_GetFinishersArmLeftBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersArmLeftBind();
}

function ACS_GetFinishersArmRightBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersArmRightBind();
}

function ACS_GetFinishersLegLeftBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersLegLeftBind();
}

function ACS_GetFinishersLegRightBind(): ACS_CustomFinisherBind 
{
	return ACS_FinishersLegRightBind();
}

enum ACS_CustomFinisherBind 
{
	ACS_CustomFinisherBind_None = 0,
	ACS_CustomFinisherBind_Forward = 1,
	ACS_CustomFinisherBind_Backward = 2,
	ACS_CustomFinisherBind_Left = 3,
	ACS_CustomFinisherBind_Right = 4,
	ACS_CustomFinisherBind_ForwardLeft = 5,
	ACS_CustomFinisherBind_ForwardRight = 6,
	ACS_CustomFinisherBind_BackwardLeft = 7,
	ACS_CustomFinisherBind_BackwardRight = 8
}

// Rage Mechanic Settings

function ACS_RageMechanic_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodRageMechanicSettings','EHmodRageMechanic');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_NumberOfEnragedEnemies(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodRageMechanicSettings','EHmodNumberOfEnragedEnemies');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

function ACS_RageMechanicCooldown(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodRageMechanicSettings','EHmodRageMechanicCooldown');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 14;
	}
	else if (configValue <= 4)
	{
		return 4;
	}
	
	else return configValue;
}

function ACS_RageMechanicRadius(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodRageMechanicSettings','EHmodRageMechanicRadius');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 10;
	}
	
	else return configValue;
}

// Sign Combo System Settings

function ACS_SignComboSystem_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodSignComboSystemSettings','EHmodSignComboSystem');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_SignComboSystemCooldown(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodSignComboSystemSettings','EHmodSignComboSystemCooldown');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 10;
	}
	
	else return configValue;
}

function ACS_SignComboSystemMaxHealthDamageWhenAboveHalfHealth(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodSignComboSystemSettings','EHmodSignComboSystemMaxHealthDamageWhenAboveHalfHealth');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.125;
	}
	
	else return configValue;
}

function ACS_SignComboSystemMissingMaxHealthDamageWhenBelowHalfHealth(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodSignComboSystemSettings','EHmodSignComboSystemMissingMaxHealthDamageWhenBelowHalfHealth');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.125;
	}
	
	else return configValue;
}


// Darkness Settings

function ACS_Darkness_HBAO_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDarknessSettings','EHmodDarknessHBAOEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Darkness_Sunset_Time(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDarknessSettings','EHmodDarknessSunsetTime');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 21;
	}
	
	else return configValue;
}

function ACS_Darkness_Sunrise_Time(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDarknessSettings','EHmodDarknessSunriseTime');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_Darkness_Intensity(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDarknessSettings','EHmodDarknessIntensity');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.7;
	}
	
	else return configValue;
}

function ACS_Darkness_BlendTime(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDarknessSettings','EHmodDarknessBlendTime');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

// Hud Settings

function ACS_Custom_Focus_Mode_Camera_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodCustomFocusModeCameraEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Focus_Mode_Toggle_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodFocusModeToggleEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Focus_Mode_Intensity(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodFocusModeIntensity');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.5;
	}
	
	else return configValue;
}

function ACS_Interaction_Module_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodInteractionModuleEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Guiding_Light_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodGuidingLightEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Guiding_Light_Distance_Marker_Show_Only_In_Witcher_Sense_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodGuidingLightDistanceMarkerShowOnlyInWitcherSenseEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Marker_Visual_Bubble_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodMarkerVisualBubbleEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Minimap_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;

	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodMinimapEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Hud_Elements_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodHudElementsDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_Compass_Mode_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodCompassModeEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Compass_Bar_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodCompassBarDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_Enemy_Marker_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodEnemyMarkerDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_Quest_Marker_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodQuestMarkerDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_Untracked_Quest_Marker_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodUntrackedQuestMarkerDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_POI_Marker_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodPOIMarkerDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_User_Pin_Marker_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodUserPinDespawnDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}


function ACS_Quest_Marker_Distance_To_Display(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodQuestMarkerDistanceToDisplay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5000;
	}
	
	else return configValue;
}

function ACS_Untracked_Quest_Marker_Distance_To_Display(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodUntrackedQuestMarkerDistanceToDisplay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 500;
	}
	
	else return configValue;
}

function ACS_POI_Quest_Marker_Distance_To_Display(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodPOIMarkerDistanceToDisplay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5000;
	}
	
	else return configValue;
}

function ACS_Enemy_Marker_Distance_To_Display(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodHudSettings','EHmodEnemyMarkerDistanceToDisplay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 50;
	}
	
	else return configValue;
}

// Misc Settings

function ACS_DisableItemAutoscale(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodDisableItemAutoscale');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AutoWinGwent_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodAutoWinGwentEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_PassiveTaunt_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodPassiveTauntEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_SwordWalk_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodSwordWalkEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	else if (ACS_Eredin_Armor_Equipped_Check()
	|| ACS_VGX_Eredin_Armor_Equipped_Check())
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_SlideEverywhere_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodSlideEverywhereEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_ForceOpenLockedDoorsWithAard_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodForceOpenLockedDoorsWithAard');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_EnhancedSigns_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodEnhancedSignsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Instant_Mount_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodInstantMountEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_UnlimitedDurability_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodUnlimitedDurabilityEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AutoRead_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodAutoReadEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Everstorm_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodEverstormEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Motion_Leaning_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodMotionLeaningEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Interaction_Buffer_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodInteractionBufferEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_VampireSoundEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodVampireSoundEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_HideVampireClaws_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodHideVampireClaws');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_MutePlayer_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodMutePlayerEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Firesources_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodFireSourcesEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_FireSourcesRange(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodFireSourcesRange');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 15;
	}
	
	else return configValue;
}

function ACS_FireSourcesEntities(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodFireSourcesEntities');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 20;
	}
	
	else return configValue;
}

function ACS_PotionAndFoodAnimation_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodPotionAndFoodAnimationEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_MaskAnimation_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodMaskAnimationEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_OverrideMeditationButton_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMiscSettings','EHmodOverrideMeditationButtonnEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Visual Settings

function ACS_FogSpawn_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodFogSpawnEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_HorseRiders_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodHorseRidersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_CrowSwarm_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodCrowSwarmEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_SpiralSkyBands_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodSpiralSkyBandsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_SpiralSkyPlanets_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodSpiralSkyPlanetsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_SpiralSkyStars_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodSpiralSkyStarsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Player_Scale(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodPlayerScale');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_AlternateScabbards_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodAlternateScabbardsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_HideSwordsheathes_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodHideSwordsheathes');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_ShowWeaponsWhileCloaked(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodShowWeaponsWhileCloaked');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_UnequipCloakWhileInCombat(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodUnequipCloakWhileInCombat');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AlwaysFurCloak(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodAlwaysFurCloak');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AdditionalArmorPiecesEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodAdditionalArmorPiecesEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_PlayerEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodPlayerEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_WearablePocketItems_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodWearablwPocketItemsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_WearablePocketItemsPositioning(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodWearablePocketItemsPositioning');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_WearableBombs_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodWearableBombsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_WearableBombsPositioning(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodWearableBombsPositioning');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_SwordsOnRoach_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodSwordsOnRoachEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_SwordsOnRoachPositioning(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodSwordsOnRoachPositioning');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_AdditionalBloodSpatters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodAdditionalBloodSpatterEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_AdditionalGore_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodGoreSpawnerEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_DisableBigCameraLights_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodDisableBigCameraLightsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_DisableSmallCameraLights_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodDisableSmallCameraLightsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_DisableAllCameraLights_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodDisableAllCameraLightsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_IconicSwordVFXOff_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodIconicSwordVFXOffEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AlternateScabbardSteel_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodAlternateScabbardSteelEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AlternateScabbardSilver_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodVisualSettings','EHmodAlternateScabbardSilverEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Taunt Settings

function ACS_TauntSystem_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTauntSettings','EHmodTauntSystemEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_IWannaPlayGwent_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTauntSettings','EHmodIWannaPlayGwentEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_EquipTaunt_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTauntSettings','EHmodEquipTauntEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_CombatTaunt_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodTauntSettings','EHmodCombatTauntEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Jump Settings

function ACS_CombatJump_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodCombatJump');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_JumpExtend_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpExtend');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_JumpExtend_Effect_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpExtendEffect');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_Normal_JumpExtend_GetHeight(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpExtendNormalHeight');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_Normal_JumpExtend_GetDistance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpExtendNormalDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 10;
	}
	
	else return configValue;
}

function ACS_Sprinting_JumpExtend_GetHeight(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpExtendSprintingHeight');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

function ACS_Sprinting_JumpExtend_GetDistance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpExtendSprintingDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 12;
	}
	
	else return configValue;
}

function ACS_JumpGlide_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpGlide');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_JumpGlideForm(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodJumpSettings','EHmodJumpGlideForm');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Bruxa Dash Settings

function ACS_BruxaDash_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodBruxaDashSettings','EHmodBruxaDash');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDashSprintOrW(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodBruxaDashSettings','EHmodBruxaDashSprintOrW');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_BruxaDashInput(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodBruxaDashSettings','EHmodBruxaDashInput');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_BruxaDash_Normal_Distance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodBruxaDashSettings','EHmodBruxaDashNormalDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 15;
	}
	
	else return configValue;
}

function ACS_BruxaDash_Combat_Distance(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodBruxaDashSettings','EHmodBruxaDashCombatDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 6;
	}
	
	else return configValue;
}

// Dodge Settings

function ACS_BruxaLeapAttack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodBruxaLeapAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeSlideBack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodBruxaDodgeSlideBack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_WildHuntBlink_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodWildHuntBlink');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_DodgeEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodDodgeEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_DodgeSlowMo_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodDodgeSlowMo');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_HoldToRoll_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodHoldToRoll');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Skate_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDodgeSettings','EHmodSkateEnabled');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Default Geralt Moveset Dodge and Roll Override Settings

function ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideDodgeEnabled');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if (thePlayer.HasBuff(EET_AirDrain)
	|| thePlayer.HasBuff(EET_Choking)
	|| thePlayer.HasBuff(EET_Drowning)
	)
	{
		return false;
	}

	else if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_DefaultGeraltMovesetOverrideModeNeutralDodgeOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}


function ACS_DefaultGeraltMovesetOverrideModeForwardDodgeOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeBackwardDodgeOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeLeftDodgeOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeRightDodgeOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideRollEnabled');
	configValue =(int) configValueString;

	if( !ACS_InitializeOverride() && FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if (thePlayer.HasBuff(EET_AirDrain)
	|| thePlayer.HasBuff(EET_Choking)
	|| thePlayer.HasBuff(EET_Drowning)
	)
	{
		return false;
	}

	else if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralRollOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}


function ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardRollOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardRollOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftRollOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

function ACS_DefaultGeraltMovesetOverrideModeRightRollOptions(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightRollOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}

// Wraith Mode Settings

function ACS_WraithMode_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWraithModeSettings','EHmodWraithMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_WraithModeSprintOrW(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWraithModeSettings','EHmodWraithModeSprintOrW');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_WraithModeInput(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWraithModeSettings','EHmodWraithModeInput');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Damage Settings

function ACS_VampireClawsDamageMaxHealthOrCurrentHealth(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodVampireClawsDamageMaxHealthOrCurrentHealth');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Human_Max_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodVampireClawsHumanMaxDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Human_Min_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodVampireClawsHumanMinDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Monster_Max_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodVampireClawsMonsterMaxDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Vampire_Claws_Monster_Min_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodVampireClawsMonsterMinDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Player_Fall_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodPlayerFallDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.2;
	}
	
	else return configValue;
}

function ACS_CrossbowDamageMaxHealthOrCurrentHealth(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodCrossbowDamageMaxHealthOrCurrentHealth');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Crossbow_Human_Max_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodCrossbowHumanMaxDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Crossbow_Human_Min_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodCrossbowHumanMinDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Crossbow_Monster_Max_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodCrossbowMonsterMaxDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Crossbow_Monster_Min_Damage(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodCrossbowMonsterMinDamage');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_Player_Damage_Multiplier(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodPlayerDamageMultiplier');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Player_DamageTaken_Multiplier(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodPlayerDamageTakenMultiplier');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Enemy_Health_Multiplier(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodDamageSettings','EHmodEnemyHealthMultiplier');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

// Stamina Settings

function ACS_StaminaBlockAction_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodStaminaBlockAction');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_StaminaCostAction_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodStaminaCostAction');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_ParryingStaminaCostAction_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodParryingStaminaCostAction');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ParryingStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodParryingStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_LightAttackStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodLightAttackStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.05;
	}
	
	else return configValue;
}

function ACS_HeavyAttackStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodHeavyAttackStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_SpecialAttackStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodSpecialAttackStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.15;
	}
	
	else return configValue;
}

function ACS_TransformationActionStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodTransformationActionStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.075;
	}
	
	else return configValue;
}

function ACS_DodgeStaminaCost(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodDodgeStaminaCost');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.05;
	}
	
	else return configValue;
}

function ACS_ParryingStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodParryingStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_LightAttackStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodLightAttackStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_HeavyAttackStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodHeavyAttackStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_SpecialAttackStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodSpecialAttackStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_DodgeStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodDodgeStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_TransformationActionStaminaRegenDelay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodStaminaSettings','EHmodTransformationActionStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

// Events Settings

function ACS_AllowSimultaneousEventSpawning_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodAllowSimultaneousEventsSpawning');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_EventDelayMinimumTimeInSeconds(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodEventDelayMinimumTimeInSeconds');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 30;
	}
	
	else return configValue;
}

function ACS_EventDelayMaximumTimeInSeconds(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodEventDelayMaximumTimeInSeconds');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 60;
	}
	
	else return configValue;
}

function ACS_ShadowsSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodShadowsSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_ShadowsSpawnDelayTimeInSeconds(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodShadowsSpawnDelayInSeconds');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 420;
	}
	
	else return configValue;
}

function ACS_WildHuntSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodWildHuntSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_WildhuntSpawnDelayTimeInSeconds(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodWildhuntSpawnDelayInSeconds');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 840;
	}
	
	else return configValue;
}

function ACS_NightStalkerSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodNightStalkerSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_NightStalkerSpawnDelayTimeInSeconds(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodNightStalkerSpawnDelayInSeconds');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 840;
	}
	
	else return configValue;
}

function ACS_ElderbloodAssassinSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodElderbloodAssassinSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_ElderbloodAssassinSpawnDelayTimeInSeconds(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEventsSettings','EHmodElderbloodAssassinSpawnDelayInSeconds');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 220;
	}
	
	else return configValue;
}

// Additional World Encounters Settings

function ACS_DraugirEncounters_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDraugirEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Forest_God_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodForestGodEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Ice_Titans_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodIceTitansEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Fire_Bear_Altar_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodFireBearAltarEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Knightmare_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodKnightmareEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_SheWhoKnows_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodSheWhoKnowsEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_BigLizard_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodBigLizardEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_RatMage_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodRatMageEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Mages_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodMagesEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_CloakedVamp_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodCloakedVampEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Chironex_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodChironexEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Dao_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDaoEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Draug_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDraugEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Berserkers_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodBerserkersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_LynxWitchers_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodLynxWitchersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_FireGargoyle_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodFireGargoyleEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Fluffy_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodFluffyEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_FogAssassin_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodFogAssassinEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_XenoTyrantEgg_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodXenoTyrantEggEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Cultists_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodCultistsEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_MelusineOfTheStorm_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodMelusineEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_PirateZombie_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodPirateZombieEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Svalblod_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodSvalblodEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Duskwraith_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDuskwraithEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_MegaWraith_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodMegaWraithEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_FireGryphon_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodFireGryphonEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Incubus_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodIncubusEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Mula_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodMulaEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_BloodHym_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodBloodHymEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_NekkerGuardian_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodNekkerGuardianEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Necrofiend_Nest_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodNecrofiendNestEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_HarpyQueen_Nest_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodHarpyQueenNestEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Heart_Of_Darkness_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodHeartOfDarknessEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Bumbakvetch_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodBumbakvetchEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Frost_Boar_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodFrostBoarEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Nimean_Panther_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodNimeanPantherEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Shadow_Pixies_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadowPixiesEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Maerolorn_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodMaerolornEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Demonic_Construct_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDemonicConstructEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Dark_Knight_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDarkKnightEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Voref_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodVorefEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Ifrit_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodIfritEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Iridescent_Sharley_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodIridescentSharleyEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Viy_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodViyEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Phooca_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodPhoocaEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Plumard_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodPlumardEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_The_Beast_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodTheBeastEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Giant_Trolls_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodGiantTrollsEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Elemental_Titans_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodElementalTitansEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesCrusadersEncounters_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesCrusadersEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesHuntersEncounters_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesHuntersEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesRoguesEncounters_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesRoguesEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesShowdownEncounters_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesShowdownEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesDancerWaxing_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesDancerWaxingEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesDancerWaning_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesDancerWaningEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Kara_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesKaraEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_ShadesNightmareIncarnate_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodShadesNightmareIncarnateEncountersEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Knocker_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodKnockerEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.75;
	}
	
	else return configValue;
}

function ACS_Nekurat_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodNekuratEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Botchling_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodBotchlingEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Vendigo_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodVendigoEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.75;
	}
	
	else return configValue;
}

function ACS_Vigilosaur_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodVigilosaurEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.75;
	}
	
	else return configValue;
}

function ACS_SwarmMother_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodSwarmMotherEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Manticore_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodManticoreEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_KnightmareLesser_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodKnightmareLesserEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Ungoliant_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodUngoliantEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_Dullahan_Enabled(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersSettings','EHmodDullahanEnabled');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SOI_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlc_050_51') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlc_050_51')
	)
	{
		return true;	
	}

	return false;
}

function ACS_Warglaives_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlc_glaives_9897') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlc_glaives_9897')
	)
	{
		return true;	
	}

	return false;
}

function ACS_SCAAR_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('scaaraiov_dlc') 
	&& theGame.GetDLCManager().IsDLCEnabled('scaaraiov_dlc')
	)
	{
		return true;	
	}

	return false;
}

function ACS_E3ARP_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('e3arp_dlc') 
	&& theGame.GetDLCManager().IsDLCEnabled('e3arp_dlc')
	)
	{
		return true;	
	}

	return false;
}

function ACS_W3EE_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('w3ee_dlc') 
	&& theGame.GetDLCManager().IsDLCEnabled('w3ee_dlc')
	)
	{
		return true;	
	}

	return false;
}

function ACS_W3EE_Redux_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('reduxw3ee_dlc') 
	&& theGame.GetDLCManager().IsDLCEnabled('reduxw3ee_dlc')
	)
	{
		return true;	
	}

	return false;
}

function ACS_MS_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('magicspells_rev') 
	&& theGame.GetDLCManager().IsDLCEnabled('magicspells_rev')
	)
	{
		return true;	
	}

	return false;
}

function ACS_GM_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlc_spectre') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlc_spectre')
	)
	{
		return true;	
	}

	return false;
}

function ACS_Ard_Bombs_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlc_056_710') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlc_056_710')
	)
	{
		return true;	
	}

	return false;
}

function ACS_New_Replacers_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlc_newreplacers') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlc_newreplacers')
	)
	{
		return true;	
	}

	return false;
}

function ACS_E3Quen_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlcquen') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlcquen')
	)
	{
		return true;	
	}

	return false;
}

function ACS_New_Replacers_Female_Active(): bool
{
	if (ACS_New_Replacers_Installed() 
	&& FactsQuerySum("nr_player_female") > 0
	
	)
	{
		return true;
	}

	return false;
}

function ACS_EH_EX_Installed(): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable('dlc_eh_ex') 
	&& theGame.GetDLCManager().IsDLCEnabled('dlc_eh_ex')
	)
	{
		return true;	
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Aerondight_Steel(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Aerondight'
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Aerondight_Silver(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Aerondight EP2'
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Aerondight_Steel_Held(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Aerondight'
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Aerondight_Silver_Held(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Aerondight EP2'
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Eredin_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'q402 Skellige sword 3'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Frostmourne'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Sinner'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Voidblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Frostmourne 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Sinner 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Voidblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Frostmourne 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Sinner 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Voidblade 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NPC Eredin Swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'q402_item__epic_swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sq304_powerful_sword'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'spirit'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'chakram'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'bajinn roh'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == '0NPC Wild Hunt sword 1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Eredin_Sword'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Pridefall'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Pridefall 1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Pridefall 2'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Olgierd_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Olgierd Sabre'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_True_Iris'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh 2'
	
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'stiletto'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sickle'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'claw sabre'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'jaggat'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'crescent'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'rapier'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'venasolak'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'wrisp'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twinkle'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sparda'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Sparda'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Crafted Ofir Steel Sword'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Hakland Sabre'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 1'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Katana_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Sakura Flower'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dragon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sorrow'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oathblade'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Thermal Katana Steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Black Unicorn Steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'catkatana'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sq701 Geralt of Rivia sword'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_MageStaff_Steel(): bool
{
	if ( 
	
	ACS_GetItem_MageStaff_Water()
	|| ACS_GetItem_MageStaff_Sand()
	|| ACS_GetItem_MageStaff_Fire()
	|| ACS_GetItem_MageStaff_Ice()

	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_MageStaff_Water(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Water_Staff'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_MageStaff_Sand(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Sand_Staff'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_MageStaff_Fire(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 

	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Fire_Staff'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_MageStaff_Ice(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Ice_Staff'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Caretaker_Shovel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_Imlerith_Mace_Equipped() : bool
{
	var sword_id_steel, sword_id_silver 		: SItemUniqueId;
	var sword 									: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id_steel);

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id_silver);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id_steel ) == 'Imlerith Macex'
	|| thePlayer.GetInventory().GetItemName( sword_id_steel ) == 'Imlerith Mace1'
	|| thePlayer.GetInventory().GetItemName( sword_id_steel ) == 'ACS_Imlerith_Mace'
	|| thePlayer.GetInventory().GetItemName( sword_id_silver ) == 'ACS_Imlerith_Mace_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id_silver ) == 'S_Imlerith Macex'
	|| thePlayer.GetInventory().GetItemName( sword_id_silver ) == 'Immace Silver'
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Imlerith_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Steel_FOR_THUNKING(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Steel_FOR_SLICING(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 

	thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Claws_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_a' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_b'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_c'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Spear_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pitchfork'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Rake'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Pitchfork'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Rake'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Shepherd_Stick'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Dullahan_Spear(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Greg_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn 1' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword3'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'orkur'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gregoire_Sword'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Axe'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Blackjack'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Leviathan' 

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Hammer_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Leviathan(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	//thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	sword_id = ACS_GetCurrentlyHeldSecondaryWeapon();

	if( thePlayer.GetInventory().GetItemName( sword_id ) == 'Leviathan'  )
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetCurrentlyHeldSecondaryWeapon() : SItemUniqueId
{
	var i	: int;
	var w	: array<SItemUniqueId>;
	
	w = thePlayer.GetInventory().GetHeldWeapons();
	
	for( i = 0 ; i < w.Size() ; i+=1 )
	{
		if( thePlayer.GetInventory().IsItemSecondaryWeapon( w[i] ) )
		{
			return w[i];
		}
	}
	
	return GetInvalidUniqueId();		
}

function ACS_GetItem_Axe_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'
	
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_One_Hand_Axe_Steel(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe01'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe02'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe03'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe04'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe05'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe06'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Mace01'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Mace02'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mace 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Axe 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dwarven Axe'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dwarven Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pickaxe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shovel'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Scythe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Fishingrodx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Q1_ZoltanAxe2hx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'smol baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Q1_ZoltanAxe2h_crafted'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Nazairi_Mace'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scoop'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Small_Blackjack'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Club'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Poker'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hatchet'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Eredin_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Frostmourne'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Sinner'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Voidblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Frostmourne 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Sinner 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Voidblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Frostmourne 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Sinner 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Voidblade 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_NPC Eredin Swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_q402_item__epic_swordx'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_sq304_powerful_sword'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'soul'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'luani'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'silver roh'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Eredin_Sword_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Pridefall'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Pridefall 1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Pridefall 2'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Olgierd_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'stiletto_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sickle_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'talon sabre'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'serrator'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'crescent_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'rapier_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'hjaven'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'skinner'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Icingdeath'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sparda'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Sparda'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Novalis'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Katana_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana 2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Thermal Katana Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Black Unicorn Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'fishkatana'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Silver_FOR_SLICING(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 

	thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Imlerith_Silver_FOR_THUNKING(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Claws_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger1_silver' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger2_silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger3_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_3'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Spear_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 1'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pitchfork'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Rake'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive_silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_Of_Destiny'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Greg_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn 1' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword1_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword2_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword3_silver'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'maltonge'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gregoire_Sword_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Axe'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pickaxe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Shovel'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Scythe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Fishingrodx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama_silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Calidus_Fire_Sword'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Hammer_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 

	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'
	
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_Axe_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1_Silver' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Demonic_Construct_Hammer'

	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

function ACS_GetItem_One_Hand_Axe_Silver(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 2'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Axe'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pickaxe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Shovel'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Scythe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Fishingrodx'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama_silver'
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}

/*
function ACS_GetItem_Aerondight(): CEntity
{
	var sword_id 		: SItemUniqueId;
	var sword 			: CEntity;

	if( 
	//thePlayer.GetInventory().GetItemName( thePlayer.GetInventory().GetCurrentlyHeldSword() ) == 'Aerondight EP2'
	thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' )
	)
	{
		sword = thePlayer.GetInventory().GetItemEntityUnsafe(sword_id);
	}

	return sword;
}
*/

function ACS_GetItem_Aerondight(): bool
{
	if( thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ))
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Iris(): bool
{
	if( thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' ))
	{
		return true;
	}

	return false;
}

function ACS_GetItem_MageStaff(): bool
{
	if( thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ))
	{
		return true;
	}

	return false;
}

function ACS_GetItem_Novalis(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'ACS_Novalis')) 
	{
		return true;
	}

	return false;
}

function ACS_DontReplaceScabbardSilver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Sabre" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoiatael" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Gregoire" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Axe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Spear" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Halberd" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pole" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hammer" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Club" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Blackjack" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Poker" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Guisarme" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Mace" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hatchet" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Staff" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Wand" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Oar" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pickaxe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Shovel" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Broom" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Paling" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pitchfork" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Rake" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoop" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scythe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Stick" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Eredin" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Giant" )
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "sabre" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoiatael" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "gregoire" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "axe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "spear" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "halberd" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pole" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hammer" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "club" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "blackjack" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "poker" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "guisarme" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "mace" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hatchet" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "staff" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "wand" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "oar" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pickaxe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "shovel" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "broom" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "paling" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pitchfork" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "rake" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoop" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scythe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "stick" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "eredin" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "giant" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "calidus" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Calidus" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Leviathan" ) 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'mod_origin_ofir') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'Ofir') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'OlgierdSabre') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'NovalisSabre') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'ironshade') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'Leviathan') 
	)
	{
		return true;
	}

	return false;
}

function ACS_DontReplaceScabbardSteel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Sabre" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoiatael" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Gregoire" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Axe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Spear" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Halberd" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pole" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hammer" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Club" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Blackjack" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Poker" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Guisarme" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Mace" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hatchet" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Staff" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Wand" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Oar" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pickaxe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Shovel" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Broom" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Paling" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pitchfork" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Rake" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoop" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scythe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Stick" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Eredin" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Giant" )
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "sabre" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoiatael" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "gregoire" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "axe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "spear" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "halberd" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pole" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hammer" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "club" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "blackjack" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "poker" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "guisarme" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "mace" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hatchet" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "staff" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "wand" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "oar" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pickaxe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "shovel" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "broom" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "paling" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pitchfork" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "rake" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoop" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scythe" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "stick" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "eredin" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "giant" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Leviathan" ) 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'mod_origin_ofir') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'Ofir') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'OlgierdSabre') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'NovalisSabre')
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'ironshade') 
	|| thePlayer.GetInventory().ItemHasTag(sword_id,'Leviathan') 
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_VampClaw(): bool
{
	if ( ACS_GetItem_VampClaw_Normal()
	|| ACS_GetItem_VampClaw_Blood()
	) 
	{
		return true;
	}

	return false;
}

function ACS_GetItem_VampClaw_Normal(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'q702_vampire_gloves')
	) 
	{
		return true;
	}

	return false;
}

function ACS_GetItem_VampClaw_Blood(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'q704_vampire_gloves')	
	) 
	{
		return true;
	}

	return false;
}

function ACS_GetItem_VampClaw_Shades(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves 2')
	) 
	{
		return true;
	}

	return false;
}

function ACS_GetItem_SorcFists(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')
	) 
	{
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Wolf_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 4')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Wolf_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Wolf_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Wolf_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Wolf_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 3')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Wolf_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 3')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Wolf_School_Check(): bool
{
	if ( ACS_GetItem_Wolf_Armor()
	&& ACS_GetItem_Wolf_Boots()
	&& ACS_GetItem_Wolf_Pants()
	&& ACS_GetItem_Wolf_Gloves()
	&& FactsQuerySum("ACS_Wolf_Style_Activate") > 0
	//&& ACS_GetItem_Wolf_Steel_Sword()
	//&& ACS_GetItem_Wolf_Silver_Sword()
	) 
	{
		return true;
	}
	return false;
}

function ACS_Wolf_School_Check_For_Item(): bool
{
	if ( ACS_GetItem_Wolf_Armor()
	&& ACS_GetItem_Wolf_Boots()
	&& ACS_GetItem_Wolf_Pants()
	&& ACS_GetItem_Wolf_Gloves()
	//&& ACS_GetItem_Wolf_Steel_Sword()
	//&& ACS_GetItem_Wolf_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_WolfSchool_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Bear_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 4')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Bear_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Bear_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Bear_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Bear_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 3')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Bear_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 3')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Bear_School_Check(): bool
{
	if ( ACS_GetItem_Bear_Armor()
	&& ACS_GetItem_Bear_Boots()
	&& ACS_GetItem_Bear_Pants()
	&& ACS_GetItem_Bear_Gloves()
	&& FactsQuerySum("ACS_Bear_Style_Activate") > 0
	//&& ACS_GetItem_Bear_Steel_Sword()
	//&& ACS_GetItem_Bear_Silver_Sword()
	) 
	{
		return true;
	}
	return false;
}

function ACS_Bear_School_Check_For_Item(): bool
{
	if ( ACS_GetItem_Bear_Armor()
	&& ACS_GetItem_Bear_Boots()
	&& ACS_GetItem_Bear_Pants()
	&& ACS_GetItem_Bear_Gloves()
	//&& ACS_GetItem_Bear_Steel_Sword()
	//&& ACS_GetItem_Bear_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_BearSchool_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Cat_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 4')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Cat_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Cat_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Cat_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Cat_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 4')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Cat_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 4')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Cat_School_Check(): bool
{
	if ( ACS_GetItem_Cat_Armor()
	&& ACS_GetItem_Cat_Boots()
	&& ACS_GetItem_Cat_Pants()
	&& ACS_GetItem_Cat_Gloves()
	&& FactsQuerySum("ACS_Cat_Style_Activate") > 0
	//&& ACS_GetItem_Cat_Steel_Sword()
	//&& ACS_GetItem_Cat_Silver_Sword()
	) 
	{
		return true;
	}
	return false;
}

function ACS_Cat_School_Check_For_Item(): bool
{
	if ( ACS_GetItem_Cat_Armor()
	&& ACS_GetItem_Cat_Boots()
	&& ACS_GetItem_Cat_Pants()
	&& ACS_GetItem_Cat_Gloves()
	//&& ACS_GetItem_Cat_Steel_Sword()
	//&& ACS_GetItem_Cat_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_CatSchool_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Griffin_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 4')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Griffin_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Griffin_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Griffin_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 5')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 5')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Griffin_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 3')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Griffin_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 3')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 3')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Griffin_School_Check(): bool
{
	if ( ACS_GetItem_Griffin_Armor()
	&& ACS_GetItem_Griffin_Boots()
	&& ACS_GetItem_Griffin_Pants()
	&& ACS_GetItem_Griffin_Gloves()
	&& FactsQuerySum("ACS_Griffin_Style_Activate") > 0
	//&& ACS_GetItem_Griffin_Steel_Sword()
	//&& ACS_GetItem_Griffin_Silver_Sword()
	) 
	{
		return true;
	}
	return false;
}

function ACS_Griffin_School_Check_For_Item(): bool
{
	if ( ACS_GetItem_Griffin_Armor()
	&& ACS_GetItem_Griffin_Boots()
	&& ACS_GetItem_Griffin_Pants()
	&& ACS_GetItem_Griffin_Gloves()
	//&& ACS_GetItem_Griffin_Steel_Sword()
	//&& ACS_GetItem_Griffin_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_GriffinSchool_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Manticore_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Armor 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Manticore_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Boots 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Manticore_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Gloves 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Manticore_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Pants 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Manticore_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School silver sword 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Manticore_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School steel sword 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Manticore_School_Check(): bool
{
	if ( ACS_GetItem_Manticore_Armor()
	&& ACS_GetItem_Manticore_Boots()
	&& ACS_GetItem_Manticore_Pants()
	&& ACS_GetItem_Manticore_Gloves()
	&& FactsQuerySum("ACS_Manticore_Style_Activate") > 0
	//&& ACS_GetItem_Manticore_Steel_Sword()
	//&& ACS_GetItem_Manticore_Silver_Sword()
	) 
	{
		return true;
	}
	return false;
}

function ACS_Manticore_School_Check_For_Item(): bool
{
	if ( ACS_GetItem_Manticore_Armor()
	&& ACS_GetItem_Manticore_Boots()
	&& ACS_GetItem_Manticore_Pants()
	&& ACS_GetItem_Manticore_Gloves()
	//&& ACS_GetItem_Manticore_Steel_Sword()
	//&& ACS_GetItem_Manticore_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_ManticoreSchool_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Viper_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Armor')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Viper_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Boots')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Viper_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Gloves')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Viper_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Pants')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Viper_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Viper School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Viper School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'EP1 Viper School silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Viper School silver sword')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Viper_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Viper School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Viper School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'EP1 Viper School steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Viper School steel sword')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Viper_School_Check(): bool
{
	if ( ACS_GetItem_Viper_Armor()
	&& ACS_GetItem_Viper_Boots()
	&& ACS_GetItem_Viper_Pants()
	&& ACS_GetItem_Viper_Gloves()
	&& FactsQuerySum("ACS_Viper_Style_Activate") > 0
	//&& ACS_GetItem_Viper_Steel_Sword()
	//&& ACS_GetItem_Viper_Silver_Sword()
	) 
	{
		return true;
	}
	return false;
}

function ACS_Viper_School_Check_For_Item(): bool
{
	if ( ACS_GetItem_Viper_Armor()
	&& ACS_GetItem_Viper_Boots()
	&& ACS_GetItem_Viper_Pants()
	&& ACS_GetItem_Viper_Gloves()
	//&& ACS_GetItem_Viper_Steel_Sword()
	//&& ACS_GetItem_Viper_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_ViperSchool_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Forgotten_Wolf_Armor(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Forgotten_Wolf_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Forgotten_Wolf_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Forgotten_Wolf_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Forgotten_Wolf_Silver_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Forgotten_Wolf_Steel_Sword(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword 2')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword 1')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword 2')
	) 
	{
		return true;
	}
	return false;
}

function ACS_Forgotten_Wolf_Check(): bool
{
	if ( ACS_GetItem_Forgotten_Wolf_Armor()
	&& ACS_GetItem_Forgotten_Wolf_Boots()
	&& ACS_GetItem_Forgotten_Wolf_Pants()
	&& ACS_GetItem_Forgotten_Wolf_Gloves()
	&& FactsQuerySum("ACS_Forgotten_Wolf_Style_Activate") > 0
	//&& ACS_GetItem_Forgotten_Wolf_Steel_Sword()
	//&& ACS_GetItem_Forgotten_Wolf_Silver_Sword()
	) 
	{
		return true;
	}
	
	return false;
}

function ACS_Forgotten_Wolf_Check_For_Item(): bool
{
	if ( ACS_GetItem_Forgotten_Wolf_Armor()
	&& ACS_GetItem_Forgotten_Wolf_Boots()
	&& ACS_GetItem_Forgotten_Wolf_Pants()
	&& ACS_GetItem_Forgotten_Wolf_Gloves()
	//&& ACS_GetItem_Forgotten_Wolf_Steel_Sword()
	//&& ACS_GetItem_Forgotten_Wolf_Silver_Sword()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_ForgottenWolfSchool_Tutorial_Shown');
		return true;
	}

	return false;
}

function ACS_Volhikar_Check_For_Item(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Armor')
	&& GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Gloves')
	&& GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Pants')
	&& GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Boots')
	//&& ACS_GetItem_Forgotten_Wolf_Steel_Sword()
	//&& ACS_GetItem_Forgotten_Wolf_Silver_Sword()
	) 
	{
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_AllBlack_Equipped_Held(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_AllBlackNecrosword' 
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}

	return false;
}

function ACS_GetItem_AllBlack_Equipped(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_AllBlackNecrosword' 
	)
	{
		ACS_Tutorial_Display_Check('ACS_AllBlack_Tutorial_Shown');
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_GetItem_Zireal_Steel(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Zireal_Sword' 
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}
	return false;
}

function ACS_GetItem_Zireal_Silver(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Silver_Zireal_Sword'
	&& thePlayer.GetInventory().IsItemHeld( sword_id )
	)
	{
		return true;
	}
	return false;
}

function ACS_Zireael_Check(): bool
{
	if ( ACS_GetItem_Zireal_Steel()
	|| ACS_GetItem_Zireal_Silver()
	) 
	{
		ACS_Tutorial_Display_Check('ACS_Zireal_Tutorial_Shown');
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_CloakCheck ( id : SItemUniqueId ) : bool
{
	if 
	(
	thePlayer.GetInventory().ItemHasTag(id,'AHW') 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cloak" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cape" ) 
	|| thePlayer.GetInventory().GetItemName(id) == 'Traveler Kontusz' 
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP Traveler Kontusz'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Armor_Omega'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Armor_Omega'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_VGX_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_VGX_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Imlerith_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Imlerith_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Caranthir_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Caranthir_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_WH_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_WH_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Artorias_Armor'
	)
	{
		return true; 
	}
	
	return false;
}

function ACS_IsItemCloak( id : SItemUniqueId ) : bool
{
	if(thePlayer.GetInventory().ItemHasTag(id,'AHW') 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cloak" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cape" ) 
	|| thePlayer.GetInventory().GetItemName(id) == 'Traveler Kontusz' 
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP Traveler Kontusz' 
	)
	{
		return true; 
	}

	return false;
}

function ACS_CloakEquippedCheck() : bool
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_CloakCheck(equippedItemsId[i])
		&& !ACS_ShowWeaponsWhileCloaked()
		)
		{
			ACS_Tutorial_Display_Check('ACS_CloakWeaponHide_Tutorial_Shown');
			return true;
		} 	
	}
	
	return false;
}

function ACS_NonItemCloakEquippedCheck() : bool
{
	if (FactsQuerySum("ACS_Cloak_Equipped") > 0
	&& !ACS_ShowWeaponsWhileCloaked()
	)
	{
		return true;
	} 	

	return false;
}

function ACS_UnequipCloak()
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_IsItemCloak(equippedItemsId[i]))
		{
			if( !thePlayer.GetInventory().ItemHasTag( equippedItemsId[i], 'Unequipped_By_ACS' ))
			{
				thePlayer.GetInventory().AddItemTag( equippedItemsId[i], 'Unequipped_By_ACS' );
			}

			thePlayer.UnequipItem(equippedItemsId[i]);
		} 	
	}
}

function ACS_EquipCloak()
{
	var itemIds 				: array<SItemUniqueId>;
	var i 						: int;
		
	itemIds = thePlayer.inv.GetItemsByTag( 'Unequipped_By_ACS' );

	if (itemIds.Size() > 0)
	{
		for( i = 0; i < itemIds.Size() ; i+=1 )
		{
			if( thePlayer.GetInventory().ItemHasTag( itemIds[i], 'Unequipped_By_ACS' ) )
			{
				thePlayer.EquipItem(itemIds[i]);

				thePlayer.GetInventory().RemoveItemTag( itemIds[i], 'Unequipped_By_ACS' );
			}
		}
	}
	else
	{
		return;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ShouldHideWeaponCheck_Steel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom' 
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'

	)
	{
		return true;
	}

	return false;
}

function ACS_ShouldHideWeaponCheck_Silver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'

	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'
	)
	{
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ShouldChangeWeaponWalkOneHandWeaponCheck_Steel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Ice_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Water_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Sand_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Fire_Staff'
	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

function ACS_ShouldChangeWeaponWalkOneHandWeaponCheck_Silver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ShouldChangeWeaponWalkTwoHandWeaponCheck_Steel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'

	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

function ACS_ShouldChangeWeaponWalkTwoHandWeaponCheck_Silver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1_Silver' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Demonic_Construct_Hammer'
	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BuffCheck() : bool
{
	if ( thePlayer.HasBuff(EET_HeavyKnockdown) 
	|| thePlayer.HasBuff( EET_Knockdown ) 
	|| thePlayer.HasBuff( EET_Ragdoll ) 
	|| thePlayer.HasBuff( EET_Stagger )
	|| thePlayer.HasBuff( EET_LongStagger )
	|| thePlayer.HasBuff( EET_Pull )
	|| thePlayer.HasBuff( EET_Immobilized )
	|| thePlayer.HasBuff( EET_Hypnotized )
	|| thePlayer.HasBuff( EET_WitchHypnotized )
	|| thePlayer.HasBuff( EET_Blindness )
	|| thePlayer.HasBuff( EET_WraithBlindness )
	|| thePlayer.HasBuff( EET_Frozen )
	|| thePlayer.HasBuff( EET_Paralyzed )
	|| thePlayer.HasBuff( EET_Confusion )
	|| thePlayer.HasBuff( EET_Tangled )
	|| thePlayer.HasBuff( EET_Tornado ) 
	)
	{
		return false;
	}

	return true;
}

/*
function ACS_DetachBehavior()
{
	thePlayer.DetachBehavior('Gameplay');
	thePlayer.DetachBehavior( 'aard_primary_beh' );
	thePlayer.DetachBehavior( 'aard_secondary_beh' );
	thePlayer.DetachBehavior( 'axii_primary_beh' );
	thePlayer.DetachBehavior( 'axii_secondary_beh' );
	thePlayer.DetachBehavior( 'yrden_primary_beh' );
	thePlayer.DetachBehavior( 'yrden_secondary_beh' );
	thePlayer.DetachBehavior( 'quen_primary_beh' );
	thePlayer.DetachBehavior( 'quen_secondary_beh' );
	thePlayer.DetachBehavior( 'claw_beh' );
	thePlayer.DetachBehavior( 'acs_bow_beh' );
	thePlayer.DetachBehavior( 'acs_crossbow_beh' );
}
*/

function ACS_Teleport_End_Early_Effects()
{
	if (thePlayer.HasTag('ACS_wildhunt_teleport_init'))
	{
		ACSGetCEntity('wh_teleportfx').CreateAttachment(thePlayer);

		thePlayer.SoundEvent("magic_canaris_teleport_short");

		ACSGetCEntity('wh_teleportfx').StopEffect('disappear');
		ACSGetCEntity('wh_teleportfx').PlayEffectSingle('disappear');

		ACSGetCEntity('wh_teleportfx').PlayEffectSingle('appear');

		ACSGetCEntity('wh_teleportfx').DestroyAfter(1);

		thePlayer.RemoveTag('ACS_wildhunt_teleport_init');
	}

	if (thePlayer.HasTag('ACS_Mage_Teleport'))
	{
		thePlayer.PlayEffectSingle('teleport_in');
		thePlayer.StopEffect('teleport_in');

		thePlayer.RemoveTag('ACS_Mage_Teleport');
	}

	if (thePlayer.HasTag('ACS_Dolphin_Teleport'))
	{
		ACSGetCEntity('acs_dolphin_fx').StopEffect('dolphin');
		ACSGetCEntity('acs_dolphin_fx').PlayEffectSingle('dolphin');

		thePlayer.SoundEvent('monster_water_mage_combat_spray');

		ACSGetCEntity('acs_dolphin_fx').DestroyAfter(5);

		thePlayer.RemoveTag('ACS_Dolphin_Teleport');
	}

	if (thePlayer.HasTag('ACS_Iris_Teleport'))
	{
		thePlayer.PlayEffectSingle('ethereal_buff');

		thePlayer.StopEffect('ethereal_buff');

		thePlayer.StopEffect('special_attack_fx');

		thePlayer.SoundEvent('magic_olgierd_tele');

		if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
		&& !thePlayer.HasTag('acs_blood_sucking')
		)
		{
			ACS_Weapon_Respawn();

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		GetACSWatcher().Marker_Smoke();

		thePlayer.RemoveTag('ACS_Iris_Teleport');
	}

	if (thePlayer.HasTag('ACS_Explosion_Teleport'))
	{
		ACSGetCEntity('acs_explosion_teleport_fx').CreateAttachment(thePlayer);

		ACSGetCEntity('acs_explosion_teleport_fx').StopEffect('smoke_explosion');
		ACSGetCEntity('acs_explosion_teleport_fx').PlayEffectSingle('smoke_explosion');

		ACSGetCEntity('acs_explosion_teleport_fx').DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Explosion_Teleport');
	}

	if (thePlayer.HasTag('ACS_Fountain_Portal_Teleport'))
	{
		ACSGetCEntity('acs_fountain_portal_teleport_fx').StopEffect('portal');
		ACSGetCEntity('acs_fountain_portal_teleport_fx').PlayEffectSingle('portal');

		thePlayer.SoundEvent('magic_geralt_teleport');

		ACSGetCEntity('acs_fountain_portal_teleport_fx').DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Fountain_Portal_Teleport');
	}

	if ( thePlayer.HasTag('ACS_Lightning_Teleport') )
	{
		ACSGetCEntity('acs_lightning_teleport_fx').CreateAttachment(thePlayer);

		GetACSWatcher().Marker_Lightning();

		//ACSGetCEntity('acs_lightning_teleport_fx').StopEffect('lightning');
		//ACSGetCEntity('acs_lightning_teleport_fx').PlayEffectSingle('lightning');

		//ACSGetCEntity('acs_lightning_teleport_fx').StopEffect('pre_lightning');
		//ACSGetCEntity('acs_lightning_teleport_fx').PlayEffectSingle('pre_lightning');

		ACS_Giant_Lightning_Strike_Mult();

		ACSGetCEntity('acs_lightning_teleport_fx').StopEffect('lighgtning');
		ACSGetCEntity('acs_lightning_teleport_fx').PlayEffectSingle('lighgtning');

		thePlayer.SoundEvent('fx_other_lightning_hit');

		thePlayer.PlayEffectSingle('hit_lightning');
		thePlayer.StopEffect('hit_lightning');

		ACSGetCEntity('acs_lightning_teleport_fx').DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Lightning_Teleport');
	}

	if (thePlayer.HasTag('ACS_Fire_Teleport'))
	{
		GetACSWatcher().Marker_Fire();

		thePlayer.PlayEffectSingle( 'lugos_vision_burning' );
		thePlayer.StopEffect( 'lugos_vision_burning' );

		thePlayer.SoundEvent('monster_dracolizard_combat_fireball_hit');

		thePlayer.RemoveTag('ACS_Fire_Teleport');
	}
}

function ACS_ThingsThatShouldBeRemoved_BASE_ALT()
{
	if (thePlayer.HasTag('ACS_ExplorationDelayTag'))
	{
		thePlayer.RemoveTag('ACS_ExplorationDelayTag');
	}

	GetACSWatcher().RemoveDefaltSwordWalkCancel();

	GetACSWatcher().RemoveMageAttackTimers();

	if (thePlayer.HasTag('ACS_IsSwordWalkingFinished'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalkingFinished');
	}

	GetWitcherPlayer().GetSignEntity(ST_Axii).OnSignAborted(true);

	GetACSWatcher().RemoveTimer( 'ACS_DelayedSheathSword' );

	thePlayer.RemoveTag('ACS_Griffin_Special_Attack');

	thePlayer.RemoveTag('ACS_Manticore_Special_Attack');

	thePlayer.RemoveTag('ACS_Bear_Special_Attack');	

	thePlayer.RemoveTag('ACS_Viper_Special_Attack');

	//GetWitcherPlayer().GetSignEntity(ST_Aard).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Yrden).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Igni).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Quen).OnSignAborted(true);

	//GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');

	/*
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}
	*/

	//thePlayer.CancelHoldAttacks();

	thePlayer.StopEffect('hand_special_fx');

	thePlayer.StopEffect('special_attack_fx');

	thePlayer.StopEffect('ethereal_debuff');

	thePlayer.StopEffect('shout');

	if (!thePlayer.HasTag('ACS_Camo_Active'))
	{
		thePlayer.StopEffect( 'shadowdash' );
	}

	ACS_Teleport_End_Early_Effects();

	ACS_RemoveStabbedEntities(); 

	//GetACSWatcher().RemoveTimer('ACS_ShootBowMoving'); 

	//GetACSWatcher().RemoveTimer('ACS_ShootBowStationary'); 

	//GetACSWatcher().RemoveTimer('ACS_ShootBowToIdle'); 

	//GetACSWatcher().PlayBowAnim_Reset();

	//GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage'); 

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');

	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);

	GetACSWatcher().RemoveTimer('ACS_shout'); 

	GetACSWatcher().RemoveTimer('ACS_Blood_Spray'); 

	GetACSWatcher().RemoveTimer('ParrySkillsDelayTimer');

	//GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

	//GetACSWatcher().RemoveTimer('ACS_dodge_timer_attack');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');

	//GetACSWatcher().RemoveTimer('ACS_dodge_timer_slideback');

	//GetACSWatcher().RemoveTimer('ACS_dodge_timer');

	//GetACSWatcher().RemoveTimer('ACS_alive_check');

	thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');

	thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

	if( thePlayer.IsAlive()) 
	{
		//thePlayer.ClearAnimationSpeedMultipliers(); 
	
		GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation'); 

		GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');
	
	}

	if ( !ACS_Transformation_Activated_Check() )
	{
		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
	}

	/*
	thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

	thePlayer.SetCanPlayHitAnim(true); 

	thePlayer.EnableCharacterCollisions(true); 
	thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
	thePlayer.SetIsCurrentlyDodging(false);
	*/

	GetACSWatcher().RemoveTimer('RollDelay');
}

function ACS_ThingsThatShouldBeRemoved_ALT()
{
	ACS_ThingsThatShouldBeRemoved_BASE_ALT();

	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); 

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
	
	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('acs_blood_sucking')
	)
	{
		if (!thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			ACS_Weapon_Respawn();
		}
		
		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}
}

function ACS_ThingsThatShouldBeRemoved_BASE()
{
	if (thePlayer.HasTag('ACS_ExplorationDelayTag'))
	{
		thePlayer.RemoveTag('ACS_ExplorationDelayTag');
	}

	GetACSWatcher().RemoveDefaltSwordWalkCancel();

	if (thePlayer.HasTag('ACS_IsSwordWalkingFinished'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalkingFinished');
	}

	GetACSWatcher().RemoveTimer( 'ACS_DelayedSheathSword' );

	GetWitcherPlayer().GetSignEntity(ST_Axii).OnSignAborted(true);

	thePlayer.RemoveTag('ACS_Griffin_Special_Attack');

	thePlayer.RemoveTag('ACS_Manticore_Special_Attack');

	thePlayer.RemoveTag('ACS_Bear_Special_Attack');

	thePlayer.RemoveTag('ACS_Viper_Special_Attack');

	thePlayer.StopEffect('hand_special_fx');

	thePlayer.StopEffect('special_attack_fx');

	thePlayer.StopEffect('ethereal_debuff');

	thePlayer.StopEffect('shout');

	GetACSWatcher().RemoveMageAttackTimers();

	if (!thePlayer.HasTag('ACS_Camo_Active'))
	{
		thePlayer.StopEffect( 'shadowdash' );
	}

	ACS_Teleport_End_Early_Effects();

	ACS_RemoveStabbedEntities(); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowMoving'); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowStationary'); 

	GetACSWatcher().RemoveTimer('ACS_ShootBowToIdle'); 

	GetACSWatcher().PlayBowAnim_Reset();

	GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage'); 

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');
	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);

	GetACSWatcher().RemoveTimer('ACS_shout'); 

	GetACSWatcher().RemoveTimer('ACS_Blood_Spray'); 

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_attack');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_slideback');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer');

	GetACSWatcher().RemoveTimer('ACS_alive_check');

	GetACSWatcher().RemoveTimer('ParrySkillsDelayTimer');

	thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');

	thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

	if( thePlayer.IsAlive()) 
	{
		thePlayer.ClearAnimationSpeedMultipliers(); 
	
		GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation'); 

		GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');
	
	}

	if ( !ACS_Transformation_Activated_Check() )
	{
		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
	}	 

	thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

	thePlayer.SetCanPlayHitAnim(true); 

	thePlayer.EnableCharacterCollisions(true); 
	thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
	thePlayer.SetIsCurrentlyDodging(false);

	GetACSWatcher().RemoveTimer('RollDelay');



	//GetWitcherPlayer().GetSignEntity(ST_Aard).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Yrden).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Igni).OnSignAborted(true);

	//GetWitcherPlayer().GetSignEntity(ST_Quen).OnSignAborted(true);

	//GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');

	/*
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}
	*/

	//thePlayer.CancelHoldAttacks();
}

function ACS_ThingsThatShouldBeRemoved()
{
	ACS_ThingsThatShouldBeRemoved_BASE();

	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); 

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
	
	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('acs_blood_sucking')
	)
	{
		if (!thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			ACS_Weapon_Respawn();
		}
		
		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}
}

function ACS_ThingsThatShouldBeRemoved_NoWeaponRespawn()
{
	ACS_ThingsThatShouldBeRemoved_BASE(); 
	
	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); 

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
}

function ACS_ThingsThatShouldBeRemoved_NoBruxaTackleOrPortableAard()
{
	ACS_ThingsThatShouldBeRemoved_BASE_ALT(); 

	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('acs_blood_sucking')
	)
	{
		if (!thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			ACS_Weapon_Respawn();
		}
		
		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}
}

function ACS_RemoveStabbedEntities()
{
	var actors		    							: array<CActor>;
	var i											: int;

	actors.Clear();

	actors = GetActorsInRange(thePlayer, 10, 10, 'ACS_Stabbed');
		
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].BreakAttachment();
		actors[i].RemoveTag('ACS_Stabbed');
	}
}

function ACS_DefaultMovesetDrainStamina(i : int)
{
	if( thePlayer.IsDoingSpecialAttack(false)
	|| thePlayer.IsDoingSpecialAttack(true)
	|| ACS_Armor_Equipped_Check()
	|| ACS_Wolf_School_Check()
	|| ACS_Bear_School_Check()
	|| ACS_Cat_School_Check()
	|| ACS_Griffin_School_Check()
	|| ACS_Manticore_School_Check()
	|| ACS_Forgotten_Wolf_Check()
	|| ACS_Viper_School_Check()
	|| ACS_DefaultMovesetCombatAnimationOverrideMode_Enabled()
	|| (ACS_GM_Installed())
	|| (ACS_W3EE_Installed())
	|| (ACS_W3EE_Redux_Installed())
	)
	{
		return;
	}

	if ((thePlayer.HasTag('acs_igni_secondary_sword_equipped')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG')
	|| thePlayer.HasTag('acs_igni_sword_equipped')
	|| thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
	&& !thePlayer.HasTag('acs_quen_sword_equipped')
	&& !thePlayer.HasTag('acs_axii_sword_equipped')
	&& !thePlayer.HasTag('acs_aard_sword_equipped')
	&& !thePlayer.HasTag('acs_yrden_sword_equipped')
	&& !thePlayer.HasTag('acs_quen_secondary_sword_equipped')
	&& !thePlayer.HasTag('acs_axii_secondary_sword_equipped')
	&& !thePlayer.HasTag('acs_aard_secondary_sword_equipped')
	&& !thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
	&& ACS_StaminaCostAction_Enabled()
	)
	{
		if (i == 1)
		{
			thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_LightAttackStaminaCost() * 0.5, ACS_LightAttackStaminaRegenDelay() * 0.5 );
		}
		else if (i == 2)
		{
			thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_HeavyAttackStaminaCost() * 0.5, ACS_HeavyAttackStaminaRegenDelay() * 0.5 );
		}
	}
}

function ACS_Pre_Attack( animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo  )
{
	var attackName     		: name;
	var targetDistance 									: Float;

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), ((CNewNPC)(thePlayer.GetTarget())).GetWorldPosition() );

	if((thePlayer.HasTag('acs_igni_sword_equipped')
	|| thePlayer.HasTag('acs_igni_sword_equipped_TAG')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
	&& thePlayer.GetStat( BCS_Focus ) == thePlayer.GetStatMax( BCS_Focus )
	&& !thePlayer.IsDoingSpecialAttack(false)
	&& !thePlayer.IsDoingSpecialAttack(true)
	&& thePlayer.IsAnyWeaponHeld()
	&& !thePlayer.IsWeaponHeld('fist')
	&& (thePlayer.IsThreatened() || thePlayer.IsInCombat())
	&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
	&& targetDistance <= 3 * 3
	&& !((CNewNPC)(thePlayer.GetTarget())).IsFlying()
	&& !thePlayer.IsDodgeTimerRunning()
	&& !thePlayer.IsCurrentlyDodging()
	&& ACS_BuffCheck()
	&& !thePlayer.IsInHitAnim() 
	)
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffect('light_trail_fx');
		ACSGetCEntity('acs_sword_trail_1').PlayEffect('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').PlayEffect('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').PlayEffect('fast_attack_buff');
		ACSGetCEntity('acs_sword_trail_1').PlayEffect('fast_attack_buff_hit');

		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('fast_attack_buff');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('fast_attack_buff_hit');
	}

	if(animEventType == AET_DurationEnd)
	{
		ACS_Phantom_Create();

		return;
	}

	attackName = data.attackName;

	if (animEventName == 'AttackLight' || data.attackName == 'attack_light' || data.attackName == 'AttackLight')
	{
		ACS_DefaultMovesetDrainStamina(1);
		ACS_Light_Attack_Trail();
	}
	else if (animEventName == 'AttackHeavy' || data.attackName == 'attack_heavy' || data.attackName == 'AttackHeavy' )
	{
		ACS_DefaultMovesetDrainStamina(2);
		ACS_Heavy_Attack_Trail();
	}

	if (ACS_GetItem_Aerondight())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack')
		&& !ACS_Armor_Equipped_Check())
		{
			GetACSWatcher().aerondight_sword_trail();
		}
	}

	if (ACS_GetItem_Iris())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack')
		&& !ACS_Armor_Equipped_Check())
		{
			GetACSWatcher().iris_sword_trail();
		}
	}

	if (ACS_Zireael_Check())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack'))
		{
			GetACSWatcher().ciri_sword_trail();

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');
			}
		}
	}

	if (thePlayer.HasTag('ACS_In_Dance_Of_Wrath'))
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('heavy_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('heavy_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
	}

	if (thePlayer.HasTag('ACS_Ghost_Stance_Active'))
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
	}

	if (ACS_Griffin_School_Check()
	&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');
	}

	if (ACS_Manticore_School_Check()
	&& thePlayer.HasTag('ACS_Manticore_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');
	}

	if (ACS_Viper_School_Check()
	&& thePlayer.HasTag('ACS_Viper_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');
	}

	if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
	{
		ACS_Light_Attack_Extended_Trail();
		//ACS_Heavy_Attack_Extended_Trail();
	}

	if ( thePlayer.GetTarget() == ACSGetCActor('ACS_Big_Boi') 
	
	&& ((CNewNPC)thePlayer.GetTarget()).IsFlying()
	
	)
	{
		if (GetWitcherPlayer().HasTag('acs_igni_sword_equipped') || GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
		{
			ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
			ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

			ACSGetEquippedSword().PlayEffectSingle('heavy_trail_extended_fx');
			ACSGetEquippedSword().StopEffect('heavy_trail_extended_fx');
		}

		ACS_Light_Attack_Extended_Trail();

		ACS_Heavy_Attack_Extended_Trail();
	}

	if(thePlayer.HasTag('acs_aard_sword_equipped'))
	{
		ACSGetEquippedSword().StopAllEffects();
	}

	if (ACS_Armor_Equipped_Check())
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack'))
		{
			//GetACSWatcher().ACS_Armor_Weapon_Whoosh();

			ACS_Armor_Cone();

			GetACSWatcher().ACS_Armor_Ether_Sword_Trail();

			//ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('fire_sparks_trail');
			//ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('special_attack_iris');
			ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('special_attack_iris');

			ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('red_fast_attack_buff');
			ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('red_fast_attack_buff');

			ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('red_fast_attack_buff_hit');
			ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('red_fast_attack_buff_hit');

			if( thePlayer.IsDoingSpecialAttack(false)
			&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
			)
			{
				GetACSWatcher().Red_Blade_Projectile_Spawner();
				
				GetACSWatcher().ACS_SlowMoAdjustable(0.6,0.6);
			}
		}
	}

	if(ACS_GetItem_MageStaff())
	{
		if (!ACSGetEquippedSword().IsEffectActive('heavy_trail_fx', false))
		{
			ACSGetEquippedSword().PlayEffectSingle( 'heavy_trail_fx' );
		}

		if (!ACSGetEquippedSword().IsEffectActive('light_trail_fx', false))
		{
			ACSGetEquippedSword().PlayEffectSingle( 'light_trail_fx' );
		}

		ACSGetEquippedSword().StopEffect( 'heavy_trail_fx' );
		ACSGetEquippedSword().StopEffect( 'light_trail_fx' );
	}

	if (thePlayer.HasTag('ACS_Ice_Giant_Mode'))
	{
		if (thePlayer.IsAnyWeaponHeld() && !thePlayer.IsWeaponHeld('fist'))
		{
			ACS_Frost_Cone();
		}
	}

	if (thePlayer.HasTag('ACS_Flammable_Oil_Enabled'))
	{
		if (thePlayer.IsAnyWeaponHeld() && !thePlayer.IsWeaponHeld('fist'))
		{
			ACSGetCEntity('ACS_Fire_Sword_Ent').StopEffect('fire_sparks_trail');
			ACSGetCEntity('ACS_Fire_Sword_Ent').PlayEffect('fire_sparks_trail');

			ACSCreateGolemGroundFireFX(thePlayer.GetWorldPosition() + thePlayer.GetWorldForward(), thePlayer.GetWorldRotation());
		}
	}
	
	ACS_GravehagTongueWeaponPlayAnim();

	ACS_BloodRootsAttach();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_PlayerHitEffects()
{
	//thePlayer.StopAllEffects(); 
	
	if ( ACS_GetWeaponMode() == 0 
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2 )
	{
		if (thePlayer.HasTag('acs_axii_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if ( thePlayer.HasTag('acs_yrden_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('black_trail');
			thePlayer.StopEffect('black_trail');
		}
		else if ( thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('hit_lightning');
			thePlayer.StopEffect('hit_lightning');
		}
		else if ( thePlayer.HasTag('acs_aard_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('acs_quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('acs_vampire_claws_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
	}
	else
	{
		if ( thePlayer.HasTag('acs_quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('acs_vampire_claws_equipped' ) )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
	}
}

function ACS_AttitudeCheck( actor : CActor ) : bool
{
	var targetDistance 										: float;

	targetDistance = VecDistanceSquared2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) ;

	if ( 
	(thePlayer.GetAttitude( actor ) == AIA_Hostile 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Hostile
	|| (actor.IsAttackableByPlayer() && actor.IsTargetableByPlayer()))
	&& actor.IsAlive()
	&& targetDistance <= 50 * 50
	)
	{
		return true;
	}
	else if ( 
	thePlayer.GetAttitude( actor ) == AIA_Friendly 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Friendly
	|| !actor.IsAlive()
	|| actor == thePlayer
	|| targetDistance > 50 * 50
	)
	{
		return false;
	}

	return false;
}

function ACS_AttitudeCheck_NoDistance( actor : CActor ) : bool
{
	if ( 
	(thePlayer.GetAttitude( actor ) == AIA_Hostile 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Hostile
	|| (actor.IsAttackableByPlayer() && actor.IsTargetableByPlayer()))
	&& actor.IsAlive()
	)
	{
		return true;
	}
	else if ( 
	thePlayer.GetAttitude( actor ) == AIA_Friendly 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Friendly
	|| !actor.IsAlive()
	|| actor == thePlayer
	)
	{
		return false;
	}

	return false;
}

function ACS_DistCheck( actor : CActor ) : bool
{
	var targetDistance 										: float;

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;

	if ( targetDistance <= 15 * 15 )
	{
		return true;
	}
	else if ( targetDistance > 15 * 15 )
	{
		return false;
	}

	return false;
}

function ACS_NoticeboardCheck (radius_check: float): bool 
{
    var entities: array<CGameplayEntity>;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 1, , FLAG_ExcludePlayer, , 'W3NoticeBoard');

    return entities.Size()>0;
}
  
function ACS_GuardCheck (radius_check: float): bool 
{
	var entities: array<CGameplayEntity>;
    var i: int;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 100, , FLAG_ExcludePlayer, , 'CNewNPC');

    for (i = 0; i<entities.Size(); i += 1) 
	{
		if (((CNewNPC)(entities[i])).GetNPCType()==ENGT_Guard) 
		{
			return true;
		}
	}

	return false;
}

function ACS_PlayerSettlementCheck (optional radius_check: float): bool 
{
	var current_area: EAreaName;

	if ( radius_check <= 0 ) 
	{
      radius_check = 50;
    }
    
    current_area = theGame.GetCommonMapManager().GetCurrentArea();

    if ( ACS_NoticeboardCheck( radius_check ) ) 
	{
      return true;
    }
    
    if ( current_area == AN_Skellige_ArdSkellig ) 
	{
      return ACS_GuardCheck( radius_check );
    }
    
    return thePlayer.IsInSettlement() || ACS_GuardCheck (radius_check);
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ExplorationDelayHack()
{
	if ( ACS_Transformation_Activated_Check() )
	{
		return;
	}
	
	if( !thePlayer.IsInCombat() )
	{
		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}

		if ( thePlayer.GetCurrentStateName() != 'Combat' )
		{
			thePlayer.GotoState('Combat');
		}

		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}
	}

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');
	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);
}

function ACS_ExplorationDelayHackForGuard()
{
	if ( ACS_Transformation_Activated_Check() )
	{
		return;
	}

	if( !thePlayer.IsInCombat() )
	{
		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}

		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}
	}

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');
	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);
}

function ACS_ExplorationDelay_actual()
{
	if (!thePlayer.IsInCombat())
	{
		if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			if (!ACS_HideVampireClaws_Enabled())
			{
				thePlayer.PlayEffectSingle('claws_effect');
				thePlayer.StopEffect('claws_effect');
			}

			GetACSWatcher().ClawDestroy();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			GetACSWatcher().SorcFistDestroy();
		}
	}

	thePlayer.RemoveTag('ACS_ExplorationDelayTag');
}

function ACS_CombatToExplorationCheck() : bool
{
	if ( thePlayer.HasTag('ACS_ExplorationDelayTag') 
	|| thePlayer.IsGuarded() 
	|| thePlayer.IsInGuardedState() 
	|| theInput.GetActionValue('LockAndGuard') > 0.5 
	|| thePlayer.IsPerformingFinisher()
	|| thePlayer.HasTag('ACS_IsPerformingFinisher')
	)
	{
		return false;
	}
	else
	{
		return true;
	}	
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Setup_Combat_Action_Light
{
    function Setup_Combat_Action_Light_Engage()
	{
		this.PushState('Setup_Combat_Action_Light_Engage');
	}
}

state Setup_Combat_Action_Light_Engage in cACS_Setup_Combat_Action_Light
{	
	event OnEnterState(prevStateName : name)
	{
		Attack_Light_Entry();
	}
	
	entry function Attack_Light_Entry()
	{
		if (thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('acs_igni_secondary_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
		{
			thePlayer.AddTag('acs_igni_sword_equipped_TAG');	
		}

		GetACSWatcher().RemoveTimer('DefaltSwordWalk');

		thePlayer.RemoveTag('ACS_IsSwordWalking');

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

statemachine class cACS_Setup_Combat_Action_Heavy
{
    function Setup_Combat_Action_Heavy_Engage()
	{
		this.PushState('Setup_Combat_Action_Heavy_Engage');
	}
}

state Setup_Combat_Action_Heavy_Engage in cACS_Setup_Combat_Action_Heavy
{	
	event OnEnterState(prevStateName : name)
	{
		Attack_Heavy_Entry();
	}

	entry function Attack_Heavy_Entry()
	{
		GetACSWatcher().RemoveTimer('DefaltSwordWalk');

		thePlayer.RemoveTag('ACS_IsSwordWalking');

		if (thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('acs_igni_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.AddTag('acs_igni_secondary_sword_equipped_TAG');	
		}

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Setup_Combat_Action_CastSign
{
    function Setup_Combat_Action_CastSign_Engage()
	{
		this.PushState('Setup_Combat_Action_CastSign_Engage');
	}
}

state Setup_Combat_Action_CastSign_Engage in cACS_Setup_Combat_Action_CastSign
{	
	event OnEnterState(prevStateName : name)
	{
		CastSign_Entry();
	}

	entry function CastSign_Entry()
	{
		GetACSWatcher().DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_CastSign, BS_Pressed );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSWatcher() : W3ACSWatcher
{
	var watcher 			 : W3ACSWatcher;
	
	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	return watcher;
}

function GetACSWatcherSecondary() : W3ACSWatcherSecondary
{
	var watcher 			 : W3ACSWatcherSecondary;
	
	watcher = (W3ACSWatcherSecondary)theGame.GetEntityByTag( 'acswatchersecondary' );

	return watcher;
}

quest function modStartACS() 
{
	var entity						: CEntity;
	var template					: CEntityTemplate;
	var ACSWatcherSpawner			: W3ACSWatcherSpawner;

	template = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\ACS_Mordor.w2ent", true);

	if ( !theGame.GetEntityByTag('acswatcherspawner') )
	{
		entity = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
	}

	ACSWatcherSpawner = (W3ACSWatcherSpawner)entity;
    ACSWatcherSpawner.ACSFactsStuff();
}

quest function modIsACSStarted() : bool
{
	return FactsQuerySum("acs_started") > 0;
}

statemachine class W3ACSWatcherSpawner extends CEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('waitForPlayer', 0.00001f , true);
	}
	
	timer function waitForPlayer( deltaTime : float , id : int)
	{	
		if ( thePlayer
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		&& !theGame.IsPaused() 
		)
		{
			if ( !GetACSWatcher() )
			{
				ACS_Watcher_Summon();
				RemoveTimer( 'waitForPlayer' );
				this.Destroy();
			}
		}
	}

	function ACS_Watcher_Summon()
	{
		var ent_1 : W3ACSWatcher;

		var ent_2 : W3ACSWatcherSecondary;

		ent_1 = (W3ACSWatcher)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\ACS_Baraddur.w2ent", true ), thePlayer.GetWorldPosition() );

		ent_2 = (W3ACSWatcherSecondary)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\ACS_Orthanc.w2ent", true ), thePlayer.GetWorldPosition() );
	}

	public function ACSFactsStuff() 
	{
    	FactsRemove("acs_started");
   		FactsAdd("acs_started", 1);
    }
}

function ACS_Phantom_Create()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos												: Vector;
	var targetDistance 									: Float;

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), ((CNewNPC)(thePlayer.GetTarget())).GetWorldPosition() );

	if((thePlayer.HasTag('acs_igni_sword_equipped')
	|| thePlayer.HasTag('acs_igni_sword_equipped_TAG')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
	&& thePlayer.GetStat( BCS_Focus ) == thePlayer.GetStatMax( BCS_Focus )
	&& !thePlayer.IsDoingSpecialAttack(false)
	&& !thePlayer.IsDoingSpecialAttack(true)
	&& thePlayer.IsAnyWeaponHeld()
	&& !thePlayer.IsWeaponHeld('fist')
	&& (thePlayer.IsThreatened() || thePlayer.IsInCombat())
	&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
	&& targetDistance <= 3 * 3
	&& !((CNewNPC)(thePlayer.GetTarget())).IsFlying()
	&& !thePlayer.IsDodgeTimerRunning()
	&& !thePlayer.IsCurrentlyDodging()
	&& ACS_BuffCheck()
	&& !thePlayer.IsInHitAnim() 
	)
	{
		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\geralt_phantom.w2ent", true ), pos, rot );
	}
}

function ACS_Armor_Cone()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos, proj_pos, targetPosition					: Vector;
	var proj_1	 										: W3ACSArmorPhysxProjectile;
	var projectileCollision 							: array< name >;

	projectileCollision.Clear();
	projectileCollision.PushBack( 'Projectile' );
	projectileCollision.PushBack( 'Door' );
	projectileCollision.PushBack( 'Static' );		
	projectileCollision.PushBack( 'ParticleCollider' ); 

	//ACSGetCEntity('ACS_Armor_Cone').Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Armor_Cone');

	ent.DestroyAfter(1);

	ent.PlayEffectSingle('acs_armor_cone_orig');
	ent.PlayEffectSingle('acs_armor_cone');


	proj_pos = thePlayer.GetWorldPosition();	
	proj_pos.Z += 0.5;		

	targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() + thePlayer.GetWorldForward() * 15;
			
	proj_1 = (W3ACSArmorPhysxProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\acs_armor_projectile.w2ent"
		
	, true ), proj_pos, rot );
					
	proj_1.Init(thePlayer);
	proj_1.SetAttackRange( theGame.GetAttackRangeForEntity( ent, 'cone' ) );
	proj_1.ShootCakeProjectileAtPosition( 60, 3.5f, 0.0f, 30.0f, targetPosition, 500, projectileCollision );		
	proj_1.DestroyAfter(1);
}

function ACS_Frost_Cone()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos												: Vector;

	//ACSGetCEntity('ACS_Frost_Cone').Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward();

	pos.Z += 1.5;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Frost_Cone');

	ent.DestroyAfter(5);

	ent.PlayEffectSingle('cone_ground_mutation_6_aard');
}

function ACS_RedBladeProjectileActual()
{
	var proj_1								: ACSBladeProjectile;
	var initpos, newpos, targetPosition		: Vector;
	var portal_ent							: CEntity;

	thePlayer.SoundEvent("fx_rune_activate_igni");

	initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetHeadingVector() * RandRangeF(2, -2)) + (GetWitcherPlayer().GetWorldRight() * RandRangeF(7, -7)) ;	
	initpos.Z += RandRangeF(7, 2.25);

	portal_ent = (CEntity)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\portal.w2ent"
		
	, true ), initpos, thePlayer.GetWorldRotation() );

	portal_ent.PlayEffectSingle('teleport');

	portal_ent.DestroyAfter(2);

	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent"
		
	, true ), initpos );
					
	proj_1.Init(thePlayer);

	if(thePlayer.IsInCombat())
	{
		if ( thePlayer.IsHardLockEnabled() )
		{
			targetPosition = ((CActor)( thePlayer.GetDisplayTarget() )).PredictWorldPosition(0.35f);
			targetPosition.Z += 0.75;
		}
		else
		{
			targetPosition = ((CActor)(thePlayer.moveTarget)).PredictWorldPosition(0.35f);
			targetPosition.Z += 0.75;
		}
	}
	else
	{
		targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 30;
		targetPosition.Z -= 5;
	}

	proj_1.ShootProjectileAtPosition( 0, RandRangeF(25,10), targetPosition, 500 );
}

function ACS_RedBladeProjectileActual_old()
{
	var proj_1								: ACSBladeProjectile;
	var initpos, newpos, targetPosition		: Vector;

	thePlayer.SoundEvent("magic_sorceress_vfx_hit_electric");

	thePlayer.SoundEvent("magic_sorceress_vfx_lightning_bolt");

	initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
	initpos.Z += 1.1;

	targetPosition = initpos + GetWitcherPlayer().GetHeadingVector() * 30;
	//targetPosition.Z += 0.25;
	
	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(thePlayer);

	proj_1.ShootProjectileAtPosition( 0, 25, targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function ACS_RedBladeProjectileActual360()
{
	var proj_1, proj_2, proj_3																				: ACSBladeProjectile;
	var initpos, targetPosition_1, targetPosition_2, targetPosition_3										: Vector;
	var temp																								: CEntityTemplate;

	thePlayer.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");

	temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

	initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
	initpos.Z += 1.1;

	targetPosition_1 = initpos + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_1.Z += 0.25;

	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_1.Init(thePlayer);

	proj_1.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );
	proj_1.DestroyAfter(10);




	targetPosition_2 = initpos  +GetWitcherPlayer().GetWorldRight() * 10 + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_2.Z += 0.25;

	proj_2 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_2.Init(thePlayer);

	proj_2.ShootProjectileAtPosition( 0, 25, targetPosition_2, 500 );
	proj_2.DestroyAfter(10);





	targetPosition_3 = initpos + GetWitcherPlayer().GetWorldRight() * -10 + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_3.Z += 0.25;

	proj_3 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_3.Init(thePlayer);

	proj_3.ShootProjectileAtPosition( 0, 25, targetPosition_3, 500 );
	proj_3.DestroyAfter(10);
}

exec function acsspawn( optional entTag: name )
{
	var ent	: CACSMonsterSpawner;

	ent = (CACSMonsterSpawner)theGame.CreateEntity( 

	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 
	
	theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 15, 

	thePlayer.GetWorldRotation() );

	if (entTag)
	{
		ent.AddTag(entTag);
	}

	ent.AddTag('ACS_MonsterSpawner_Spawn_In_Frame');
}

exec function acsspawncaranthir()
{
	GetACSWatcher().ACS_Spawn_Dark_Portal();
}

exec function acsspawneredin()
{
	GetACSWatcher().ACS_Spawn_Eredin();
}

exec function acsspawnnighthunter()
{
	GetACSWatcher().ACS_SpawnNightStalker();
}

function GetACSFluffyDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fluffy', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function acsspawnconstruct1()
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
	var animatedComponentA												: CAnimatedComponent;

	ACSGetCActor('ACS_Summoned_Construct_1').Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\detlaff_construct_summon.w2ent"

	//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\detlaff_construct.w2ent"
		
	, true );

	playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraRight() * -2 + VecFromHeading(theCamera.GetCameraHeading()) * 2;

	playerRot = thePlayer.GetWorldRotation();

	//playerRot.Yaw += 180;
	
	ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 0.8;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

	//((CNewNPC)ent).SetAttitude(thePlayer, AIA_Friendly);

	//thePlayer.SetAttitude(((CNewNPC)ent), AIA_Friendly);

	((CNewNPC)ent).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

	((CActor)ent).SetAnimationSpeedMultiplier(1);

	ent.PlayEffectSingle('dive_shape');
	ent.StopEffect('dive_shape');

	((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
	((CActor)ent).SetCanPlayHitAnim(false); 
	//((CActor)ent).AddBuffImmunity_AllNegative('ACS_Summoned_Construct_1', true); 

	((CActor)ent).AddEffectDefault( EET_AxiiGuardMe, thePlayer, 'ACS_Summoned_Construct_Buff', false );

	ent.AddTag( 'ACS_Summoned_Construct_1' );

	animatedComponentA = (CAnimatedComponent)(((CNewNPC)ent)).GetComponentByClassName( 'CAnimatedComponent' );	

	animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_resurrection', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
}

function acsspawnconstruct2()
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
	var animatedComponentA												: CAnimatedComponent;
		

	ACSGetCActor('ACS_Summoned_Construct_2').Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\detlaff_construct_summon.w2ent"

	//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\detlaff_construct.w2ent"
		
	, true );

	playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraRight() * 2 + VecFromHeading(theCamera.GetCameraHeading()) * 2;

	playerRot = thePlayer.GetWorldRotation();

	//playerRot.Yaw += 180;
	
	ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 0.8;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

	//((CNewNPC)ent).SetAttitude(thePlayer, AIA_Friendly);

	//thePlayer.SetAttitude(((CNewNPC)ent), AIA_Friendly);

	((CNewNPC)ent).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

	((CActor)ent).SetAnimationSpeedMultiplier(1);

	ent.PlayEffectSingle('dive_shape');
	ent.StopEffect('dive_shape');

	((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
	((CActor)ent).SetCanPlayHitAnim(false); 
	//((CActor)ent).AddBuffImmunity_AllNegative('ACS_Summoned_Construct_2', true); 

	((CActor)ent).AddEffectDefault( EET_AxiiGuardMe, thePlayer, 'ACS_Summoned_Construct_Buff', false );

	ent.AddTag( 'ACS_Summoned_Construct_2' );

	animatedComponentA = (CAnimatedComponent)(((CNewNPC)ent)).GetComponentByClassName( 'CAnimatedComponent' );	

	animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_resurrection', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
}

function ACS_AttackImportance(npc: CNewNPC) : float
{
	if (thePlayer.IsPerformingFinisher()
	|| thePlayer.HasTag('ACS_IsPerformingFinisher')
	|| thePlayer.HasTag('acs_blood_sucking')
	|| npc.HasTag('ACS_Final_Fear_Stack')
	|| thePlayer.HasTag('ACS_Transformation_Bruxa_Cloaked')
	|| thePlayer.HasTag('ACS_Ghost_Stance_Active')
	)
	{
		if ( thePlayer.GetAttitude( npc ) == AIA_Hostile  )
		{
			return 0;
		}
		else
		{
			return 10000;
		}
	}
	else
	{
		if (thePlayer.GetTarget() == npc
		|| thePlayer.moveTarget == npc
		)
		{
			return 10000;
		}
		else
		{
			if (npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.50)
			{
				if ( thePlayer.IsGuarded()
				|| thePlayer.IsCurrentlyDodging()
				|| (thePlayer.IsCastingSign() && !thePlayer.HasTag('acs_vampire_claws_equipped'))
				|| thePlayer.IsCurrentSignChanneled()
				)
				{
					if (theGame.GetDifficultyLevel() == EDM_Hardcore)
					{
						return 10000;
					}
					else if (theGame.GetDifficultyLevel() == EDM_Hard)
					{
						return 5000;
					}
					else if (theGame.GetDifficultyLevel() == EDM_Medium)
					{
						return 2500;
					}
					else if (theGame.GetDifficultyLevel() == EDM_Easy)
					{
						return 1000;
					}
					else
					{
						return 1000;
					}
				}
				else
				{
					if (RandF() < 0.999)
					{
						if ( thePlayer.GetAttitude( npc ) == AIA_Hostile )
						{
							return 0;
						}
						else
						{
							return 10000;
						}
					}
					else
					{
						if (theGame.GetDifficultyLevel() == EDM_Hardcore)
						{
							return 10000;
						}
						else if (theGame.GetDifficultyLevel() == EDM_Hard)
						{
							return 5000;
						}
						else if (theGame.GetDifficultyLevel() == EDM_Medium)
						{
							return 2500;
						}
						else if (theGame.GetDifficultyLevel() == EDM_Easy)
						{
							return 100;
						}
						else
						{
							return 100;
						}
					}
				}
			}
			else
			{
				if (theGame.GetDifficultyLevel() == EDM_Hardcore)
				{
					return 10000;
				}
				else if (theGame.GetDifficultyLevel() == EDM_Hard)
				{
					return 5000;
				}
				else if (theGame.GetDifficultyLevel() == EDM_Medium)
				{
					return 2500;
				}
				else if (theGame.GetDifficultyLevel() == EDM_Easy)
				{
					return 1000;
				}
				else
				{
					return 1000;
				}
			}
		}
	}
	
}

function ACS_FinisherHeal()
{
	var actors		    																											: array<CActor>;
	var i 																															: int;

	if (thePlayer.HasTag('ACS_Ghost_Stance_Active'))
	{
		return;
	}

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 30, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

	if( actors.Size() == 0 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality )) * 0.05 );

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 1/24 );
	}
	else if( actors.Size() >= 1 && actors.Size() < 2 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality ))  * 0.1 );

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 1/12 );
	}
	else if( actors.Size() >= 2 && actors.Size() < 3 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality ))  * 0.15 );

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 1/6 );
	}
	else if( actors.Size() >= 3 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality )) * 0.2 );

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus ) * 1/3 );
	}
}

function ACS_Transformation_Activated_Check() : bool
{
	if (FactsQuerySum("acs_transformation_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Werewolf_Check() : bool
{
	if (FactsQuerySum("acs_wolven_curse_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Vampiress_Check() : bool
{
	if (FactsQuerySum("acs_vampireess_transformation_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Vampire_Monster_Check() : bool
{
	if (FactsQuerySum("acs_vampire_monster_transformation_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Toad_Check() : bool
{
	if (FactsQuerySum("acs_toad_transformation_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Red_Miasmal_Check() : bool
{
	if (FactsQuerySum("acs_red_miasmal_curse_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Sharley_Check() : bool
{
	if (FactsQuerySum("acs_sharley_curse_activated") > 0)
	{
		return true;
	}

	return false;
}

function ACS_Transformation_Black_Wolf_Check() : bool
{
	if (FactsQuerySum("acs_black_wolf_curse_activated") > 0)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Omega'))
	&& GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves')
	&& GetWitcherPlayer().IsItemEquippedByName('ACS_Boots')
	&& GetWitcherPlayer().IsItemEquippedByName('ACS_Pants')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Omega'))
	&& GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves')
	&& GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots')
	&& GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants')
	)
	{
		return true;
	}

	return false;
}

function ACS_Armor_Equipped_Check() : bool
{
	if (ACS_NGP_Armor_Check()
	|| ACS_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

function ACS_Armor_Alpha_Equipped_Check() : bool
{
	if (
	(GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Alpha'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
	)
	{
		return true;
	}

	return false;
}

function ACS_Armor_Omega_Equipped_Check() : bool
{
	if (
	(GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Omega') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Omega'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
	&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_WH_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_WH_Armor'))
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_WH_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_WH_Armor'))
	)
	{
		return true;
	}

	return false;
}

function ACS_WH_Armor_Equipped_Check() : bool
{
	if (ACS_WH_Armor_Check()
	|| ACS_NGP_WH_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Eredin_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Eredin_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Eredin_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Eredin_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Eredin_Armor_Equipped_Check() : bool
{
	if (ACS_Eredin_Armor_Check()
	|| ACS_NGP_Eredin_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_VGX_Eredin_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_VGX_Eredin_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_VGX_Eredin_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_VGX_Eredin_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_VGX_Eredin_Armor_Equipped_Check() : bool
{
	if (ACS_VGX_Eredin_Armor_Check()
	|| ACS_NGP_VGX_Eredin_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Artorias_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Artorias_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Artorias_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Artorias_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Artorias_Armor_Equipped_Check() : bool
{
	if (ACS_Artorias_Armor_Check()
	|| ACS_NGP_Artorias_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Legion_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Legion_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Legion_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Legion_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Legion_Armor_Equipped_Check() : bool
{
	if (ACS_Legion_Armor_Check()
	|| ACS_NGP_Legion_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Cavalier_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Cavalier_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Cavalier_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Cavalier_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Cavalier_Armor_Equipped_Check() : bool
{
	if (ACS_Cavalier_Armor_Check()
	|| ACS_NGP_Cavalier_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Leonidas_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Leonidas_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Leonidas_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Leonidas_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Leonidas_Armor_Equipped_Check() : bool
{
	if (ACS_Leonidas_Armor_Check()
	|| ACS_NGP_Leonidas_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Centurion_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Centurion_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Centurion_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Centurion_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Centurion_Armor_Equipped_Check() : bool
{
	if (ACS_Centurion_Armor_Check()
	|| ACS_NGP_Centurion_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Templar_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('ACS_Templar_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Templar_Armor_Check() : bool
{
	if (
	GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Templar_Knight_Armor')
	)
	{
		return true;
	}

	return false;
}

function ACS_Templar_Armor_Equipped_Check() : bool
{
	if (ACS_Templar_Armor_Check()
	|| ACS_NGP_Templar_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Eredin_Skirt_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Eredin_Pants'))
	|| GetWitcherPlayer().IsItemEquippedByName('ACS_VGX_Eredin_Pants')
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Eredin_Skirt_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Eredin_Pants'))
	|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_VGX_Eredin_Pants')
	)
	{
		return true;
	}

	return false;
}

function ACS_Eredin_Skirt_Equipped_Check() : bool
{
	if (ACS_Eredin_Skirt_Check()
	|| ACS_NGP_Eredin_Skirt_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Imlerith_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Imlerith_Armor'))
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Imlerith_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Imlerith_Armor'))
	)
	{
		return true;
	}

	return false;
}

function ACS_Imlerith_Armor_Equipped_Check() : bool
{
	if (ACS_Imlerith_Armor_Check()
	|| ACS_NGP_Imlerith_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Imlerith_Skirt_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Imlerith_Pants'))
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Imlerith_Skirt_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Imlerith_Pants'))
	)
	{
		return true;
	}

	return false;
}

function ACS_Imlerith_Skirt_Equipped_Check() : bool
{
	if (ACS_Imlerith_Skirt_Check()
	|| ACS_NGP_Imlerith_Skirt_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Caranthir_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Caranthir_Armor'))
	)
	{
		return true;
	}

	return false;
}

function ACS_NGP_Caranthir_Armor_Check() : bool
{
	if ((GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Caranthir_Armor'))
	)
	{
		return true;
	}

	return false;
}

function ACS_Caranthir_Armor_Equipped_Check() : bool
{
	if (ACS_Caranthir_Armor_Check()
	|| ACS_NGP_Caranthir_Armor_Check()
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Knight_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('sq701_geralt_armor')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt A Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt A Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt A Armor 1')
	)
	{
		return true;
	}

	return false;
}

function ACS_Knight_Armor_Gold_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Toussaint Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName('Toussaint Armor 2')
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Knight_Armor_V1_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('sq701_geralt_armor')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt Armor 1')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt A Armor 1')
	)
	{
		return true;
	}

	return false;
}

//01
//04
//06
//13

function ACS_Knight_Armor_V2_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Knight Geralt Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt A Armor 2')
	)
	{
		return true;
	}

	return false;
}

//03
//04
//08
//14

function ACS_Knight_Armor_V3_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Knight Geralt Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName('Knight Geralt A Armor 3')
	)
	{
		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Witcher_Knight_Armor_V1_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Gryphon Armor 2')
	|| GetWitcherPlayer().IsItemEquippedByName('NGP Gryphon Armor 2')
	)
	{
		return true;
	}

	return false;
}

function ACS_Witcher_Knight_Armor_V2_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Gryphon Armor 3')
	|| GetWitcherPlayer().IsItemEquippedByName('NGP Gryphon Armor 3')
	)
	{
		return true;
	}

	return false;
}

function ACS_Witcher_Knight_Armor_V3_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 4')
	)
	{
		return true;
	}

	return false;
}

function ACS_Witcher_Bear_Armor_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 4')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 4')
	)
	{
		return true;
	}

	return false;
}

//05

//04

//09

//15

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Knight_Armor_Gold_V1_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Toussaint Armor 2')
	)
	{
		return true;
	}

	return false;
}

//03
//04
//08
//14

function ACS_Knight_Armor_Gold_V2_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('Toussaint Armor 3')
	)
	{
		return true;
	}

	return false;
}


//05

//04

//08

//15

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Vampire_Armor_Black_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('q702_vampire_armor')
	|| GetWitcherPlayer().IsItemEquippedByName('NGP q702_vampire_armor')
	)
	{
		return true;
	}

	return false;
}

//03
//04
//08
//14

function ACS_Vampire_Armor_Red_Check() : bool
{
	if (GetWitcherPlayer().IsItemEquippedByName('q704_vampire_armor')
	|| GetWitcherPlayer().IsItemEquippedByName('NGP q704_vampire_armor')
	)
	{
		return true;
	}

	return false;
}

//03
//04
//08
//14

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_IsNight() : bool
{
	var currentHour: int;

	currentHour = GameTimeHours(theGame.GetGameTime());
	
	if(currentHour > 20 || currentHour < 5)			
	{
		return true;
	}

	return false;
}

function ACS_IsNight_Adjustable() : bool
{
	var currentHour: int;

	currentHour = GameTimeHours(theGame.GetGameTime());
	
	if(currentHour >= ACS_Darkness_Sunset_Time() || currentHour <= ACS_Darkness_Sunrise_Time())			
	{
		return true;
	}

	return false;
}

function ACS_IsFogTime() : bool
{
	var currentHour: int;

	currentHour = GameTimeHours(theGame.GetGameTime());
	
	if(currentHour > 16 || currentHour < 11)			
	{
		return true;
	}

	return false;
}

function ACS_GetQuestPoint() : bool
{
	var i 						: int;
	var pinInstances 			: array<SCommonMapPinInstance>;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (pinInstances[i].isDiscovered || pinInstances[i].isKnown) 
		{
			if (
			theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			)
			{
				if (pinInstances[i].isHighlighted)
				{
					if (pinInstances.Size() > 0)
					return true;
				}
			}
		}
	}

	return false;
}

function ACS_GetQuestPointPosition( out pinPos : Vector ) : bool
{
	var i 						: int;
	var pinInstances 			: array<SCommonMapPinInstance>;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (pinInstances[i].isDiscovered || pinInstances[i].isKnown) 
		{
			if (
			theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			)
			{
				if (pinInstances[i].isHighlighted)
				{
					pinPos = pinInstances[i].position;
					return true;
				}
			}
		}
	}

	return false;
}

enum ACSAreaPositionType
{
	ACSAreaPos_Unknown,		
	ACSAreaPos_Invalid,		
	ACSAreaPos_Valid		
}

struct ACSQuestMapPin
{
	var tag : name;
	var questArea : EAreaName;
	var questObjective : CJournalQuestObjective;
	var position : Vector;
	var areaPosType : ACSAreaPositionType;
	var titleStringId : int;
	var descriptionStringId : int;
	var questLevel  : int;
}

enum ACSQuestDifficulty
{
	ACSQD_Unknown,
	ACSQD_Low,
	ACSQD_Normal,
	ACSQD_High,
	ACSQD_Deadly
}

function ACS_GuardForgetPlayer()
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 100, 999, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			if (((CNewNPC)actor).GetNPCType() == ENGT_Guard)
			{
				actor.ResetAttitude(thePlayer);

				actor.ResetBaseAttitudeGroup();

				((CNewNPC)actor).ForgetActor(thePlayer);
			}
		}
	}
}

function ACS_GuardCheer()
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			if (((CNewNPC)actor).GetNPCType() == ENGT_Guard)
			{
				enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
				
				if (RandF() < 0.5)
				{
					enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_stand_cheering_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_stand_cheering_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
	}
}

function ACSFixZAxis(pos : Vector) : Vector
{ 
	var z : float; 

	if(thePlayer.IsInInterior() || thePlayer.IsSwimming() || thePlayer.IsDiving())
	{
		return pos;
	}
	else
	{
		if (theGame.GetWorld().NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) 
		{ 
			pos.Z = z; 
		} 
		else if (theGame.GetWorld().PhysicsCorrectZ(pos, z)) 
		{ 
			pos.Z = z; 
		}
	}

	return pos;
}

function ACSPlayerFixZAxis(pos : Vector) : Vector
{ 
	var z : float; 

	if(thePlayer.IsInInterior() || thePlayer.IsSwimming() || thePlayer.IsDiving())
	{
		return pos;
	}
	else
	{
		if (theGame.GetWorld().NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) 
		{ 
			pos.Z = z; 
		} 
		else if (theGame.GetWorld().PhysicsCorrectZ(pos, z)) 
		{ 
			pos.Z = z; 
		}
	}

	return pos;
}

function ACS_Transformation_Camera_Destroy()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Transformation_Custom_Camera', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

function ACS_Meditation_Camera_Destroy()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Meditation_Custom_Camera', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

function ACS_Focus_Mode_Camera_Destroy()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Focus_Mode_Custom_Camera', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

function ACS_Kestral_Camera_Destroy()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Kestral_Custom_Camera', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

function ACSGetKestralCamera() : ACSKestralCamera
{
	var entity 			 : ACSKestralCamera;

	entity = (ACSKestralCamera)theGame.GetEntityByTag( 'ACS_Kestral_Custom_Camera' );

	return entity;
}

function ACS_GetPointOfInterests() : array<SEntityMapPinInfo>
{
	var poi_pins							: array<SEntityMapPinInfo>;
	var all_pins							: array<SEntityMapPinInfo>;
	var i, j								: int;

	all_pins.Clear();

	all_pins = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());

	for (i = 0; i<all_pins.Size(); i += 1) 
	{
		if 
		(
		all_pins[i].entityType=='MonsterNest' 
		|| all_pins[i].entityType=='InfestedVineyard' 
		|| all_pins[i].entityType=='BanditCamp' 
		|| all_pins[i].entityType=='BanditCampfire' 
		|| all_pins[i].entityType=='BossAndTreasure' 
		|| all_pins[i].entityType=='RescuingTown' 
		|| all_pins[i].entityType=='DungeonCrawl' 
		|| all_pins[i].entityType=='Hideout' 
		|| all_pins[i].entityType=='Plegmund' 
		|| all_pins[i].entityType=='KnightErrant' 
		|| all_pins[i].entityType=='WineContract' 
		|| all_pins[i].entityType=='SignalingStake' 
		|| all_pins[i].entityType=='TreasureHuntMappin'
		|| all_pins[i].entityType=='PlaceOfPower' 
		|| all_pins[i].entityType=='SpoilsOfWar' 
		|| all_pins[i].entityType=='Contraband' 
		|| all_pins[i].entityType=='ContrabandShip' 
		|| all_pins[i].entityType=='PointOfInterestMappin' 
		|| all_pins[i].entityType=='QuestAvailable' 
		|| all_pins[i].entityType=='QuestAvailableHoS' 
		|| all_pins[i].entityType=='QuestAvailableBaW'
		|| all_pins[i].entityType=='NotDiscoveredPOI' 
		) 
		{
			if ( !theGame.GetCommonMapManager().IsEntityMapPinDisabled(all_pins[i].entityName) )
			{
				poi_pins.PushBack(all_pins[i]);
			}
		}
	}

	return poi_pins;
}

function ACS_GetPointOfInterestLocations() : array<Vector>
{
	var poi_pins							: array<Vector>;
	var all_pins							: array<SEntityMapPinInfo>;
	var i, j								: int;
	var ents 								: array<CEntity>;

	all_pins.Clear();

	all_pins = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());

	for (i = 0; i<all_pins.Size(); i += 1) 
	{
		if 
		(
		all_pins[i].entityType=='MonsterNest' 
		|| all_pins[i].entityType=='InfestedVineyard' 
		|| all_pins[i].entityType=='BanditCamp' 
		|| all_pins[i].entityType=='BanditCampfire' 
		|| all_pins[i].entityType=='BossAndTreasure' 
		|| all_pins[i].entityType=='RescuingTown' 
		|| all_pins[i].entityType=='DungeonCrawl' 
		|| all_pins[i].entityType=='Hideout' 
		|| all_pins[i].entityType=='Plegmund' 
		|| all_pins[i].entityType=='KnightErrant' 
		|| all_pins[i].entityType=='WineContract' 
		|| all_pins[i].entityType=='SignalingStake' 
		|| all_pins[i].entityType=='TreasureHuntMappin'
		|| all_pins[i].entityType=='PlaceOfPower' 
		|| all_pins[i].entityType=='SpoilsOfWar' 
		|| all_pins[i].entityType=='Contraband' 
		|| all_pins[i].entityType=='ContrabandShip' 
		|| all_pins[i].entityType=='PointOfInterestMappin' 
		|| all_pins[i].entityType=='QuestAvailable' 
		|| all_pins[i].entityType=='QuestAvailableHoS' 
		|| all_pins[i].entityType=='QuestAvailableBaW'
		|| all_pins[i].entityType=='NotDiscoveredPOI' 
		|| all_pins[i].entityType=='MagicLamp' 
		) 
		{
			if ( !theGame.GetCommonMapManager().IsEntityMapPinDisabled(all_pins[i].entityName) )
			{
				poi_pins.PushBack(all_pins[i].entityPosition);
			}
		}
	}

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_MonsterSpawner_POI_Point', ents );	

	for( j = 0; j < ents.Size(); j += 1 )
	{
		poi_pins.PushBack(ents[j].GetWorldPosition());
	}

	return poi_pins;
}

function ACS_GetAvailableQuestPoints() : array<SCommonMapPinInstance>
{
	var i 												: int;
	var pinInstances 									: array<SCommonMapPinInstance>;
	var questPins										: array<SCommonMapPinInstance>;
	var pinPos, currentQuestPos, currentPOIPos 			: Vector;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (
		pinInstances[i].visibleType == 'QuestAvailable'
		|| pinInstances[i].visibleType=='QuestAvailableHoS' 
		|| pinInstances[i].visibleType=='QuestAvailableBaW' 
		|| pinInstances[i].visibleType=='QuestReturn' 
		|| pinInstances[i].visibleType=='MonsterQuest' 
		|| pinInstances[i].visibleType=='TreasureQuest' 
		|| pinInstances[i].visibleType=='StoryQuest' 
		|| pinInstances[i].visibleType=='ChapterQuest' 
		|| pinInstances[i].visibleType=='SideQuest' 
		|| pinInstances[i].visibleType=='QuestBelgard' 
		|| pinInstances[i].visibleType=='QuestCoronata' 
		|| pinInstances[i].visibleType=='QuestVermentino' 
		|| pinInstances[i].visibleType=='HorseRace' 
		|| pinInstances[i].visibleType=='BoatRace' 
		|| pinInstances[i].visibleType=='NoticeBoardFull' 
		|| pinInstances[i].visibleType=='RoadSign' 
		|| pinInstances[i].visibleType=='Harbor' 
		
		/*
		|| pinInstances[i].visibleType=='MonsterNest' 
		|| pinInstances[i].visibleType=='InfestedVineyard' 
		|| pinInstances[i].visibleType=='BanditCamp' 
		|| pinInstances[i].visibleType=='BanditCampfire' 
		|| pinInstances[i].visibleType=='BossAndTreasure' 
		|| pinInstances[i].visibleType=='RescuingTown' 
		|| pinInstances[i].visibleType=='DungeonCrawl' 
		|| pinInstances[i].visibleType=='Hideout' 
		|| pinInstances[i].visibleType=='Plegmund' 
		|| pinInstances[i].visibleType=='KnightErrant' 
		|| pinInstances[i].visibleType=='WineContract' 
		|| pinInstances[i].visibleType=='SignalingStake' 
		|| pinInstances[i].visibleType=='TreasureHuntMappin'
		|| pinInstances[i].visibleType=='PlaceOfPower' 
		|| pinInstances[i].visibleType=='SpoilsOfWar' 
		|| pinInstances[i].visibleType=='Contraband' 
		|| pinInstances[i].visibleType=='ContrabandShip' 
		|| pinInstances[i].visibleType=='PointOfInterestMappin' 
		|| pinInstances[i].visibleType=='NotDiscoveredPOI' 
		*/
		) 
		{
			pinPos = pinInstances[i].position;

			currentQuestPos = ACSGetCEntity('ACS_Guiding_Light_Marker').GetWorldPosition();

			currentPOIPos = ACSGetCEntity('ACS_Guiding_Light_POI_Marker').GetWorldPosition();

			if (pinPos.Z != currentQuestPos.Z
			&& pinPos.Z != currentPOIPos.Z
			)
			{
				questPins.PushBack(pinInstances[i]);
			}
		}
	}

	return questPins;
}

function ACS_GetNearbyEnemyLocations() : array<Vector>
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i								: int;
	var pos								: array<Vector>;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( ACS_Enemy_Marker_Distance_To_Display(), 50, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for (i = 0; i < actors.Size(); i += 1) 
		{
			pos.PushBack(actors[i].GetWorldPosition());
		}
	}

	return pos;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetHostilesCheck() : bool
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		return true;
	}

	return false;
}

function ACS_Return_Weapon_Type_If_Allowed(weaponType : EPlayerWeapon) : EPlayerWeapon
{
	if ( thePlayer.IsWeaponActionAllowed( weaponType ) )
	{
		return weaponType; 
	}
	else
	{
		return PW_None;
	}

	return PW_None;
}

function ACS_GetMostConvenientMeleeWeapon(targetToDrawAgainst : CActor) : EPlayerWeapon
{
	var inv : CInventoryComponent;
	var heldItems	: array<name>;
	var mountedItems	: array<name>;
	var hasPhysicalWeapon : bool;
	var i : int;
	var npc : CNewNPC;
	
	if( ACS_DisableAutomaticSwordSheathe_Enabled() )
	{
		return PW_None;
	}
	else
	{
		if( thePlayer.IsWeaponHeld( 'steelsword' ) )
		{
			return ACS_Return_Weapon_Type_If_Allowed (PW_Steel); 
		}
		else if( thePlayer.IsWeaponHeld( 'silversword' ) )
		{
			return ACS_Return_Weapon_Type_If_Allowed (PW_Silver); 
		}
		else
		{
			if (ACS_GetWeaponMode() == 0 && (ACS_GetFistMode() == 1 || ACS_GetFistMode() == 2))
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else if (ACS_GetWeaponMode() == 1 && (ACS_GetFistMode() == 1 || ACS_GetFistMode() == 2))
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else if (ACS_GetWeaponMode() == 2 && (ACS_GetFistMode() == 1 || ACS_GetFistMode() == 2))
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else if (ACS_GetWeaponMode() == 3 && (ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades() || ACS_GetItem_SorcFists()))
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}

			if (thePlayer.HasTag('acs_vampire_claws_equipped') || thePlayer.HasTag('acs_sorc_fists_equipped') || ACS_Transformation_Activated_Check() )
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else
			{
				if ( !targetToDrawAgainst )
				{
					return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
				}

				heldItems.Clear();

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
					return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
				}
				else if ( npc.IsHorse() && !npc.GetHorseComponent().IsDismounted() ) 
				{
					return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
				}
				else
				{
					if ( targetToDrawAgainst.UsesVitality() )
					{
						if (thePlayer.inv.IsThereItemOnSlot( EES_SteelSword ) )
						{
							return ACS_Return_Weapon_Type_If_Allowed (PW_Steel); 
						}
						else
						{
							if (thePlayer.inv.IsThereItemOnSlot( EES_SilverSword ) )
							{
								return ACS_Return_Weapon_Type_If_Allowed (PW_Silver); 
							}
							else
							{
								return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
							}
						}
					}
					if ( targetToDrawAgainst.UsesEssence() )
					{
						if (thePlayer.inv.IsThereItemOnSlot( EES_SilverSword ) )
						{
							return ACS_Return_Weapon_Type_If_Allowed (PW_Silver); 
						}
						else
						{
							if (thePlayer.inv.IsThereItemOnSlot( EES_SteelSword ) )
							{
								return ACS_Return_Weapon_Type_If_Allowed (PW_Steel); 
							}
							else
							{
								return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
							}
						} 
					}
				}
			}
		}
	}
	
	return PW_None;
}

function ACS_VGX_Eredin_Appearance_Mod_Installed_Check() : bool
{
	var test_ent											            : CEntity;
	var test_temp														: CEntityTemplate;
	var meshComponent 													: CMeshComponent;
	var boundingBox 													: Box;
	var boxRange														: float;

	test_temp = (CEntityTemplate)LoadResource( "characters\models\crowd_npc\wild_hunt_lvl3\arms\eredin_arms.w2ent", true );

	test_ent = (CEntity)theGame.CreateEntity( test_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );

	test_ent.DestroyAfter(0.1);

	meshComponent = (CMeshComponent)test_ent.GetComponentByClassName( 'CMeshComponent' );		

	boundingBox = meshComponent.GetBoundingBox();

	boxRange = GetBoxRange(boundingBox);
	
	if (boxRange > 0)
	{
		return true;
	}

	return false;
}

function ACSTrackedQuestsEntsDestroy()
{	
	var actors 											: array<CEntity>;
	var i												: int;
	
	actors.Clear();

	theGame.GetEntitiesByTag( 'ACS_All_Tracked_Quest_Entity', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}

	GetACSStorage().acs_deleteOnelinerByTag("ACS_Untracked_Quest_GUI_Marker");

	GetACSStorage().acs_deleteOnelinerByTag("ACS_Untracked_Quest_Distance_GUI_Marker");

	if (FactsQuerySum("ACS_Guiding_Light_Untracked_Quest_Marker_Distance_Available") > 0)
	{
		FactsRemove("ACS_Guiding_Light_Untracked_Quest_Marker_Distance_Available");
	}
}

function ACSTrackedQuestsEntsTeleportRotate()
{	
	var actors 											: array<CEntity>;
	var i												: int;
	var rot, newRot          							: EulerAngles;
	var targetDistance									: float;
	
	actors.Clear();

	theGame.GetEntitiesByTag( 'ACS_All_Tracked_Quest_Entity', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if ( theGame.IsDialogOrCutscenePlaying() 
		|| thePlayer.IsInNonGameplayCutscene() 
		|| thePlayer.IsInGameplayScene() 
		|| theGame.IsCurrentlyPlayingNonGameplayScene()
		|| theGame.IsFading()
		|| theGame.IsBlackscreen()
		|| theGame.IsPaused() 
		)
		{
			actors[i].DestroyEffect('untracked_quest_marker_small');
			actors[i].DestroyEffect('untracked_quest_marker_smaller');
			actors[i].DestroyEffect('untracked_quest_marker');
			actors[i].DestroyEffect('untracked_quest_marker_bigger');
			actors[i].DestroyEffect('untracked_quest_marker_biggest');
			actors[i].DestroyEffect('untracked_quest_marker_biggest_x2');
			actors[i].DestroyEffect('untracked_quest_marker_biggest_x4');
			actors[i].DestroyEffect('pridefall_marker');

			GetACSStorage().acs_deleteOnelinerByTag("ACS_Untracked_Quest_GUI_Marker");
			
			if (FactsQuerySum("ACS_Guiding_Light_Untracked_Quest_Marker_Distance_Available") > 0)
			{
				GetACSStorage().acs_deleteOnelinerByTag("ACS_Untracked_Quest_Distance_GUI_Marker");

				FactsRemove("ACS_Guiding_Light_Untracked_Quest_Marker_Distance_Available");
			}
		}
		else
		{
			targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actors[i].GetWorldPosition() ) ;

			if (ACS_Marker_Visual_Bubble_Enabled())
			{
				if (targetDistance <= 5 * 5)
				{
					actors[i].StopEffect('untracked_quest_marker_smaller');
					actors[i].StopEffect('untracked_quest_marker_small');
					actors[i].StopEffect('untracked_quest_marker');
					actors[i].StopEffect('untracked_quest_marker_bigger');
					actors[i].StopEffect('untracked_quest_marker_biggest');
					actors[i].StopEffect('untracked_quest_marker_biggest_x2');
					actors[i].StopEffect('untracked_quest_marker_biggest_x4');
				}
				else if (targetDistance > 5 * 5 && targetDistance <= 10 * 10)
				{
					actors[i].StopEffect('untracked_quest_marker_small');
					actors[i].StopEffect('untracked_quest_marker');
					actors[i].StopEffect('untracked_quest_marker_bigger');
					actors[i].StopEffect('untracked_quest_marker_biggest');
					actors[i].StopEffect('untracked_quest_marker_biggest_x2');
					actors[i].StopEffect('untracked_quest_marker_biggest_x4');

					if (!actors[i].IsEffectActive('untracked_quest_marker_smaller', false))
					{
						actors[i].PlayEffectSingle('untracked_quest_marker_smaller');
					}
				}
				else if (targetDistance > 10 * 10 && targetDistance <= 25 * 25)
				{
					actors[i].StopEffect('untracked_quest_marker_smaller');
					actors[i].StopEffect('untracked_quest_marker');
					actors[i].StopEffect('untracked_quest_marker_bigger');
					actors[i].StopEffect('untracked_quest_marker_biggest');
					actors[i].StopEffect('untracked_quest_marker_biggest_x2');
					actors[i].StopEffect('untracked_quest_marker_biggest_x4');

					if (!actors[i].IsEffectActive('untracked_quest_marker_small', false))
					{
						actors[i].PlayEffectSingle('untracked_quest_marker_small');
					}
				}
				else if (targetDistance > 25 * 25 && targetDistance <= 50 * 50)
				{
					actors[i].StopEffect('untracked_quest_marker_smaller');
					actors[i].StopEffect('untracked_quest_marker_small');
					actors[i].StopEffect('untracked_quest_marker_bigger');
					actors[i].StopEffect('untracked_quest_marker_biggest');
					actors[i].StopEffect('untracked_quest_marker_biggest_x2');
					actors[i].StopEffect('untracked_quest_marker_biggest_x4');

					if (!actors[i].IsEffectActive('untracked_quest_marker', false))
					{
						actors[i].PlayEffectSingle('untracked_quest_marker');
					}
				}
				else if (targetDistance > 50 * 50 && targetDistance <= 100 * 100)
				{
					actors[i].StopEffect('untracked_quest_marker_smaller');
					actors[i].StopEffect('untracked_quest_marker_small');
					actors[i].StopEffect('untracked_quest_marker');
					actors[i].StopEffect('untracked_quest_marker_biggest');
					actors[i].StopEffect('untracked_quest_marker_biggest_x2');
					actors[i].StopEffect('untracked_quest_marker_biggest_x4');

					if (!actors[i].IsEffectActive('untracked_quest_marker_bigger', false))
					{
						actors[i].PlayEffectSingle('untracked_quest_marker_bigger');
					}
				}
				else if (targetDistance > 100 * 100)
				{
					actors[i].StopEffect('untracked_quest_marker_smaller');
					actors[i].StopEffect('untracked_quest_marker_small');
					actors[i].StopEffect('untracked_quest_marker');
					actors[i].StopEffect('untracked_quest_marker_bigger');
					actors[i].StopEffect('untracked_quest_marker_biggest_x2');
					actors[i].StopEffect('untracked_quest_marker_biggest_x4');

					if (!actors[i].IsEffectActive('untracked_quest_marker_biggest', false))
					{
						actors[i].PlayEffectSingle('untracked_quest_marker_biggest');
					}
				}
			}
			else
			{
				actors[i].DestroyEffect('untracked_quest_marker_small');
				actors[i].DestroyEffect('untracked_quest_marker_smaller');
				actors[i].DestroyEffect('untracked_quest_marker');
				actors[i].DestroyEffect('untracked_quest_marker_bigger');
				actors[i].DestroyEffect('untracked_quest_marker_biggest');
				actors[i].DestroyEffect('untracked_quest_marker_biggest_x2');
				actors[i].DestroyEffect('untracked_quest_marker_biggest_x4');
				actors[i].DestroyEffect('pridefall_marker');
			}

			if (!ACS_Guiding_Light_Enabled())
			{
				actors[i].DestroyEffect('pridefall_marker');
			}
			else
			{
				if (!actors[i].IsEffectActive('pridefall_marker', false))
				{
					actors[i].PlayEffectSingle('pridefall_marker');
				}
			}

			rot = thePlayer.GetWorldRotation();

			rot.Pitch += 180;

			rot.Yaw += 180;

			newRot = VecToRotation( theCamera.GetCameraDirection() );

			newRot.Yaw += 180;

			newRot.Pitch = rot.Pitch;

			newRot.Roll = rot.Roll;

			actors[i].TeleportWithRotation(actors[i].GetWorldPosition(), newRot );
		}
	}
}

function ACS_CanSprint( speed : float ) : bool
{
	if ( !ACS_CanSprintBase( speed ) )
	{
		return false;
	}		

	if ( thePlayer.rangedWeapon && thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait' )
	{
		if ( thePlayer.GetPlayerCombatStance() ==  PCS_AlertNear )
		{
			if ( thePlayer.IsSprintActionPressed() )
			{
				thePlayer.OnRangedForceHolster( true, false );
			}
		}
		else
		{
			return false;
		}
	}
	
	if ( thePlayer.GetCurrentStateName() != 'Swimming' && thePlayer.GetStat(BCS_Stamina) <= 0 )
	{
		thePlayer.SetSprintActionPressed(false,true);

		return false;
	}
	
	return true;
}

function ACS_CanSprintBase( speed : float ) : bool
{
	if( speed <= 0.8f )
	{
		return false;
	}
	
	if ( thePlayer.GetIsSprintToggled() )
	{

	}
	
	else if (thePlayer.GetLeftStickSprint() && theInput.LastUsedGamepad())
	{		
		if (thePlayer.GetIsSprintToggled() && thePlayer.GetIsSprinting())
		{

		}
		else if (!thePlayer.GetIsSprintToggled())
		{
			return false;
		}
			
	}
	
	else if ( !thePlayer.sprintActionPressed )
	{
		return false;
	}
	else if ( !theInput.IsActionPressed('Sprint') || ( theInput.LastUsedGamepad() && thePlayer.IsInsideInteraction() && thePlayer.GetHowLongSprintButtonWasPressed() < 0.12 ) )
	{
		return false;
	}
	

	if ( !thePlayer.IsSwimming() )
	{
		if ( !thePlayer.GetIsSprinting() && !thePlayer.IsInCombat() && thePlayer.GetStatPercents(BCS_Stamina) <= 0.9 )
		{
			return false;
		}

		if( ( !thePlayer.IsCombatMusicEnabled() || thePlayer.IsInFistFightMiniGame() ) && ( !thePlayer.IsActionAllowed(EIAB_RunAndSprint) || !thePlayer.IsActionAllowed(EIAB_Sprint) )  )
		{
			return false;
		}

		if( thePlayer.IsInCombatAction() )
		{
			return false;
		}

		if( thePlayer.IsInAir() )
		{
			return false;
		}
	}
	
	return true;
}

function ACS_SpawnDeathCollision(actor : CNewNPC, pos : Vector)
{
	var ent        											: CEntity;
	var rot                        						 	: EulerAngles;
	var meshcomp											: CMeshComponent;
	var animcomp 											: CAnimatedComponent;
	var h 													: float;

	rot = actor.GetWorldRotation();

	pos.Z -= 0.125;

	/*

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"dlc\bob\data\quests\main_quests\quest_files\q702_hunt\entities\q702_kikimora_egg_collision_intact.w2ent"

	, true ), pos, rot );

	ent.DestroyAfter(999);

	*/

	if ( ((CNewNPC)actor).GetNPCType() == ENGT_Guard )
	{
		//actor.DestroyAfter(30);
	}
	else
	{
		//actor.DestroyAfter(999);
	}

	actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Tpose );


	if (actor.HasAbility('mon_siren_base') 
	|| actor.HasAbility('mon_black_spider_base')
	|| actor.HasAbility('mon_black_spider_ep2_base')
	)
	{
		actor.TurnOnRagdoll();
		actor.SetBehaviorVariable( 'Ragdoll_Weight', 0.f );
	}
	else
	{
		actor.EnableCharacterCollisions(true);

		actor.SetInteractionPriority( IP_Prio_0 );
	}
}

function ACS_RagdollOrNot(actor : CNewNPC)
{
	if (actor.HasAbility('mon_siren_base')
	|| actor.IsFlying()
	)
	{
		actor.TurnOnRagdoll();
		actor.SetBehaviorVariable( 'Ragdoll_Weight', 0.f );
	}
	else
	{
		actor.EnableCharacterCollisions(true);

		actor.SetInteractionPriority( IP_Prio_0 );
	}
}

function ACS_Rain_Check() : bool
{
	if (
	GetWeatherConditionName() == 'WT_Blizzard'
	|| GetWeatherConditionName() == 'WT_Rain' 
	|| GetWeatherConditionName() == 'WT_Rain_Storm' 
	|| GetWeatherConditionName() == 'WT_Battle' 
	|| GetWeatherConditionName() == 'WT_Battle_Forest' 
	|| GetWeatherConditionName() == 'WT_Wild_Hunt' 
	|| GetWeatherConditionName() == 'WT_q501_Blizzard' 
	|| GetWeatherConditionName() == 'WT_q501_Storm' 
	|| GetWeatherConditionName() == 'WT_q501_Blizzard2' 
	|| GetWeatherConditionName() == 'WT_q501_fight_ship_18_00' 
	|| GetWeatherConditionName() == 'WT_q501_storm_arena' 
	|| GetWeatherConditionName() == 'Spiral_Eternal_Cold' 
	|| GetWeatherConditionName() == 'Spiral_Dark_Valley'
	|| GetWeatherConditionName() == 'WT_Rain_Heavy' 
	|| GetWeatherConditionName() == 'WT_Rain_Dark' 
	)
	{
		return true;
	}

	return false;
}

function ACS_SlideEverywhereCommand() : CName
{
	return 'Jump';
}

function ACS_IsSlideEverywherePressed() : bool
{
	if (ACS_SlideEverywhere_Enabled() && theInput.IsActionPressed(ACS_SlideEverywhereCommand()))
	{
		return true;
	}
	
	return false;
}

function ACS_SlideEverywhereCancelCommand(): bool
{
	if (theInput.IsActionPressed('Sprint') || !ACS_SlideEverywhere_Enabled())
	{
		return true;
	}

	return false;
}

function ACSYrdenCircle1DestroyAll()
{	
	var actors 											: array<CEntity>;
	var i												: int;
	
	actors.Clear();

	theGame.GetEntitiesByTag( 'ACS_Yrden_Trap_1', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACS_Movement_Prevention() : bool
{
	if (thePlayer.HasTag('ACS_Movement_Prevention_Tag'))
	{
		return true;
	}

	return false;
}

function ACS_Interaction_Movement_Prevention_Delay()
{
	if (!thePlayer.HasTag('ACS_Movement_Prevention_Tag'))
	{
		thePlayer.AddTag('ACS_Movement_Prevention_Tag');
	}
	
	GetACSWatcher().RemoveTimer('MovementRestoreDelay');
	GetACSWatcher().AddTimer('MovementRestoreDelay', 10, false);
}

class W3ACSCustomWingEntity extends CActor
{
	editable var forcedAppearance : string;

	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		super.OnSpawned( spawnData );
		ApplyAppearance( forcedAppearance );

		AddTimer('OwlWingEntityCheck', 0.1, false);
	}

	timer function OwlWingEntityCheck(deltaTime : float, id : int) 
	{
		var ent									: CEntity;
		var actor								: CActor; 
		var animatedComponent 					: CAnimatedComponent;
		var meshcomp							: CComponent;
		var animcomp 							: CAnimatedComponent;
		var h 									: float;

		if (this.HasTag('ACS_Owl_Wing_Entity'))
		{
			ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\models\owl_crow\acs_owl.w2ent"

			, true ), this.GetWorldPosition(), this.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			ent.CreateAttachment( this, , Vector( 0, -0.3, 0.1 ), EulerAngles(-33.75,0,0) );

			ent.AddTag('ACS_Owl_Body');

			actor = (CActor)( ACSGetCActor('ACS_Owl_Body'));

			animatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	
		
			animatedComponent.PlaySlotAnimationAsync( 'clapping_wings', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));

			AddTimer('OwlBodyAnims', 2.5f, true);
		}
    }

	timer function OwlBodyAnims(deltaTime : float, id : int) 
	{
		var actor							: CActor; 
		var animatedComponent 				: CAnimatedComponent;
		var anim_names						: array<name>;

		actor = (CActor)( ACSGetCActor('ACS_Owl_Body'));
		
		animatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	

		anim_names.Clear();

		anim_names.PushBack('clapping_wings');

		if (RandF() < 0.5)
		{
			//anim_names.PushBack('idle01');
		}
		else
		{
			//anim_names.PushBack('idle02');
		}
		
		
		animatedComponent.PlaySlotAnimationAsync( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
	}


	event OnDestroyed()
	{
		ACSGetCActor('ACS_Owl_Body').Destroy();
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACSGetCActor(actorTag : name) : CActor
{
	var ent 			 : CActor;
	
	ent = (CActor)theGame.GetEntityByTag( actorTag );
	return ent;
}

function ACSGetCActorDestroyAll( tag: name )
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( tag , actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACSGetCEntity(entTag: name) : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( entTag );
	return ent;
}

function ACSGetCEntityDestroyAll( tag: name )
{	
	var actors 											: array<CEntity>;
	var i												: int;
	
	actors.Clear();

	theGame.GetEntitiesByTag( tag , actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACSGetCGameplayEntity(entTag: name) : CGameplayEntity
{
	var ent 				 : CGameplayEntity;
	
	ent = (CGameplayEntity)theGame.GetEntityByTag( entTag );
	return ent;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function acsswordspikes()
{
	if (!thePlayer.HasTag('ACS_BackSwords_Equipped'))
	{
		GetACSWatcher().ACS_Swordsanoo_Normal();

		thePlayer.AddTag('ACS_BackSwords_Equipped');
	}
	else if (thePlayer.HasTag('ACS_BackSwords_Equipped'))
	{
		ACS_Swordsanoo_Destroy();

		thePlayer.RemoveTag('ACS_BackSwords_Equipped');
	}
}

function ACS_Tutorial_Popup_Display( titleID : int, messageID : int ) 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(titleID);

	Message = GetLocStringById(messageID);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_PlayerMorph(ratio : float, time : float)
{
	var l_comp : array< CComponent >;
	var i, size : int;

	l_comp = thePlayer.GetComponentsByClassName( 'CMorphedMeshManagerComponent' );

	size = l_comp.Size();

	for ( i=0; i<size; i+= 1 )
	{
		((CMorphedMeshManagerComponent)l_comp[ i ]).SetMorphBlend( ratio, time );
	}
}

function ACS_MoreThanOneEnemyNearby() : bool
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 1 )
	{
		return true;
	}

	return false;
}

latent function ACS_MountedCombatAttack(speed: float, horizontalVal : float)
{
    var victims : array<CGameplayEntity>;
    var blade_temp_ent			: CItemEntity;

    GetWitcherPlayer().GetInventory().GetCurrentlyHeldSwordEntity( blade_temp_ent );

    blade_temp_ent.PlayEffectSingle('light_trail_extended_fx');

	blade_temp_ent.StopEffect('light_trail_extended_fx');

    blade_temp_ent.PlayEffectSingle('heavy_trail_extended_fx');

	blade_temp_ent.StopEffect('heavy_trail_extended_fx');

	if (ACS_GetItem_Dullahan_Spear())
	{
		ACS_DullahanSpearPlayerFireballSmall();
	}

    victims.Clear();

    if( horizontalVal == 0.0 )
    {
       FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector() + thePlayer.GetWorldForward() * 3 + thePlayer.GetWorldRight() * 30), 90, 5, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
    }
    else if( horizontalVal == 1.0 )
    {
        FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector() + thePlayer.GetWorldForward() * 3 + thePlayer.GetWorldRight() * -30), 90, 5, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
    }

    if( thePlayer.GetHorseCombatSlowMo() )
    {
        Sleep( 0.12f );

        if( victims.Size() > 0 )
        {
            ACS_Mounted_Combat_Deal_Damage( victims, speed, 100 );
        }
    }
    else
    {
        Sleep( 0.4f );
     
        if( victims.Size() > 0 )
        {
            ACS_Mounted_Combat_Deal_Damage( victims, speed, 100 );
        }
        else
        {
            Sleep( 0.2f );
      
            if( victims.Size() > 0 )
            {
                ACS_Mounted_Combat_Deal_Damage( victims, speed, 100 );
            }
        }
    }
}

latent function ACS_DullahanSpearPlayerFireballSmall() 
{
	var initpos, targetPosition_1				: Vector;
	var meteor_proj_1 							: W3ACSDullahanProjectile;

	initpos = GetWitcherPlayer().GetBoneWorldPosition('r_weapon');	

	initpos.Z += 1;			
				
	targetPosition_1 = thePlayer.GetWorldPosition();

	targetPosition_1.Z += 50;

	meteor_proj_1 = (W3ACSDullahanProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\dullahan_proj_small.w2ent", true ), initpos, thePlayer.GetWorldRotation() );

	meteor_proj_1.Init(thePlayer);
	meteor_proj_1.AddTag('ACS_Dullahan_Spear_Player_Horse_Riding_Proj');
	meteor_proj_1.ShootProjectileAtPosition( 0, 2, targetPosition_1, 500 );
	meteor_proj_1.DestroyAfter(20);
}

function ACS_Mounted_Combat_Deal_Damage(victims : array<CGameplayEntity>, speed : float, baseDamage : float )
{
    var damage : W3Action_Attack;
    var i : int;
    var actor : CActor;
    var horse : CNewNPC;
    var bloodTrailParam : CBloodTrailEffect;
    var weaponId : SItemUniqueId;
    var blade_temp_ent			: CItemEntity;

    GetWitcherPlayer().GetInventory().GetCurrentlyHeldSwordEntity( blade_temp_ent );

    blade_temp_ent.PlayEffectSingle('light_trail_extended_fx');

	blade_temp_ent.StopEffect('light_trail_extended_fx');

    blade_temp_ent.PlayEffectSingle('heavy_trail_extended_fx');

	blade_temp_ent.StopEffect('heavy_trail_extended_fx');
    
    horse = (CNewNPC)(thePlayer.GetUsedVehicle());
    damage = new W3Action_Attack in theGame;
    
    for( i = 0 ; i < victims.Size() ; i += 1 )
    {
        actor = (CActor)victims[i];
        
        if ( actor == thePlayer || actor == horse || GetAttitudeBetween( thePlayer, actor ) != AIA_Hostile )
            continue;
        
        if( actor )
        {
            actor.DrainStamina(ESAT_FixedValue, 100, 1);

            damage.Init( thePlayer, actor ,NULL, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ),'attack_heavy',thePlayer.GetName(),EHRT_Heavy, false, false, 'attack_heavy', AST_Jab, ASD_NotSet, true, false, false, false );
            if ( speed < 2 )
            {
                damage.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, baseDamage );
            } else
            {
                damage.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, baseDamage * MaxF( 1.1 + speed, 1 ) );
            }
            if( speed >= 4.0 )
                damage.AddEffectInfo( EET_KnockdownTypeApplicator );
            damage.SetSoundAttackType('wpn_slice')	;
            
            theGame.damageMgr.ProcessAction( damage );
            actor.PlayEffect( 'heavy_hit_horseriding' );
            actor.SoundEvent("cmb_play_hit_heavy");
            
            bloodTrailParam = (CBloodTrailEffect)actor.GetGameplayEntityParam( 'CBloodTrailEffect' );
            if( bloodTrailParam )
            {
                weaponId = thePlayer.inv.GetItemFromSlot( 'r_weapon' );
                thePlayer.inv.PlayItemEffect( weaponId, 'blood_trail_horseriding' );
            }
            
        }
    }
    delete damage;
}

function ACS_Correct_Oil_Used(npc: CActor) : bool
{
	if (npc.GetMovingAgentComponent().GetName() == "woman_base"
	|| npc.GetMovingAgentComponent().GetName() == "man_base"
	)
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hanged Man Venom 1') 
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hanged Man Venom 2') 
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hanged Man Venom 3') 
			)
			{
				return true;
			}
		}
		else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
		{
			if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hanged Man Venom 1')
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hanged Man Venom 2')
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hanged Man Venom 3')
			)
			{
				return true;
			}
		}
	}
	else
	{
		if 
		(
			npc.HasAbility('mon_boar_base')
			|| npc.HasAbility('mon_bear_base')
			|| npc.GetSfxTag() == 'sfx_wild_dog'
			|| npc.GetSfxTag() == 'sfx_wolf'
			|| npc.GetSfxTag() == 'sfx_bear'
			|| npc.HasAbility('mon_panther_base')
			|| npc.HasAbility('mon_q704_ft_pigs_evil')
			|| npc.HasAbility('mon_boar_ep2_base')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Beast Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Beast Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Beast Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Beast Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Beast Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Beast Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.HasAbility('mon_lycanthrope')
			|| npc.GetSfxTag() == 'sfx_werewolf'
			|| npc.HasAbility('mon_archespor_base')
			|| npc.HasAbility('mon_q704_ft_wilk')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Cursed Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Cursed Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Cursed Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Cursed Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Cursed Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Cursed Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_cockatrice'
			|| npc.HasAbility('mon_basilisk')
			|| npc.HasAbility('mon_forktail_young')
			|| npc.HasAbility('mon_forktail')
			|| npc.HasAbility('mon_forktail_mh')
			|| npc.GetSfxTag() == 'sfx_wyvern'
			|| npc.HasAbility('mon_mq7010_dracolizard')
			|| npc.HasAbility('mon_draco_base')
			|| npc.HasAbility('mon_mq7018_basilisk')
			|| npc.HasAbility('mon_basilisk')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Draconide Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Draconide Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Draconide Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Draconide Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Draconide Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Draconide Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_elemental_dao' 	
			|| npc.HasAbility('mon_arachas_armored')
			|| npc.GetSfxTag() == 'sfx_golem'
			|| npc.GetSfxTag() == 'sfx_elemental_ifryt'
			|| npc.GetSfxTag() == 'sfx_wildhunt_minion'
			|| npc.HasAbility('mon_ice_golem')
			|| npc.HasAbility('mon_gargoyle')
			|| npc.HasAbility('mon_dark_pixie_base')
			|| npc.HasAbility('mon_q704_ft_pixies')
			|| npc.HasAbility('mon_graveir')
			|| npc.HasAbility('mon_dark_pixie_base')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Magicals Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Magicals Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Magicals Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Magicals Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Magicals Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Magicals Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_gryphon'
			|| npc.HasAbility('mon_erynia')
			|| npc.GetSfxTag() == 'sfx_harpy'
			|| npc.HasAbility('mon_erynia')
			|| npc.GetSfxTag() == 'sfx_siren'
			|| npc.HasAbility('mon_erynia')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hybrid Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hybrid Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hybrid Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hybrid Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hybrid Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hybrid Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.HasAbility('mon_arachas_armored')
			|| npc.HasAbility('mon_poison_arachas')
			|| npc.HasAbility('mon_black_spider_base')
			|| npc.HasAbility('mon_arachas_armored')
			|| npc.GetSfxTag() == 'sfx_arachas'
			|| npc.GetSfxTag() == 'sfx_endriaga'
			|| npc.HasAbility('mon_endriaga_soldier_tailed')
			|| npc.HasAbility('mon_endriaga_worker')
			|| npc.HasTag('mq7023_pale_widow')
			|| npc.HasAbility('mon_scolopendromorph_base')
			|| npc.HasAbility('mon_kikimora_warrior')
			|| npc.HasAbility('mon_kikimora_worker')
			|| npc.HasAbility('mon_black_spider_ep2_base')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Insectoid Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Insectoid Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Insectoid Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Insectoid Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Insectoid Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Insectoid Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_alghoul' 
			|| npc.HasAbility('mon_greater_miscreant')
			|| npc.GetSfxTag() == 'sfx_drowner'
			|| npc.GetSfxTag() == 'sfx_fogling'
			|| npc.GetSfxTag() == 'sfx_gravehag'
			|| npc.GetSfxTag() == 'sfx_waterhag'
			|| npc.HasAbility('mon_rotfiend')
			|| npc.HasAbility('mon_rotfiend_large')
			|| npc.HasAbility('mon_gravier')
			|| npc.HasAbility('mon_wight')
			|| npc.HasAbility('mon_ghoul_lesser')
			|| npc.HasAbility('mon_ghoul')
			|| npc.HasAbility('mon_ghoul_stronger')
			|| npc.HasAbility('mon_EP2_ghouls')
			|| npc.HasAbility('ghoul_hardcore')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Necrophage Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Necrophage Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Necrophage Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Necrophage Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Necrophage Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Necrophage Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_ice_giant'
			|| npc.GetSfxTag() == 'sfx_nekker'
			|| npc.HasTag('ice_troll')
			|| npc.GetSfxTag() == 'sfx_troll_cave'
			|| npc.HasAbility('mon_cyclops')
			|| npc.HasAbility('mon_knight_giant')
			|| npc.HasAbility('mon_cloud_giant')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Ogre Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Ogre Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Ogre Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Ogre Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Ogre Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Ogre Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.HasAbility('mon_toad_base')
			|| npc.HasAbility('q604_caretaker')
			|| npc.HasAbility('mon_czart')
			|| npc.GetSfxTag() == 'sfx_bies'
			|| npc.GetSfxTag() == 'sfx_lessog'
			|| npc.HasAbility('mon_sprigan')
			|| npc.HasAbility('mon_sharley_base')
			|| npc.HasAbility('mon_fairytale_witch')
			|| npc.HasTag('witch')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Relic Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Relic Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Relic Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Relic Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Relic Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Relic Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.HasAbility('mon_nightwraith_iris')
			|| npc.HasAbility('mon_nightwraith')
			|| npc.HasAbility('mon_nightwraith_mh')
			|| npc.HasAbility('mon_noonwraith')
			|| npc.HasAbility('mon_noonwraith_doppelganger')
			|| npc.GetSfxTag() == 'sfx_wraith'
			|| npc.HasAbility('mon_panther_ghost')
			|| npc.HasAbility('mon_barghest_base')
			|| npc.HasAbility('banshee_rapunzel')
			|| npc.HasAbility('mon_nightwraith_banshee')
			|| npc.HasAbility('banshee_rapunzel')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Specter Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Specter Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Specter Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Specter Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Specter Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Specter Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_katakan'
			|| npc.HasAbility('mon_ekimma')
			|| npc.HasAbility('mon_garkain')
			|| npc.HasAbility('mon_bruxa')
			|| npc.HasAbility('mon_fleder')
			|| npc.HasAbility('q704_mon_protofleder')
			|| npc.HasAbility('mon_alp')
			|| npc.HasTag('dettlaff_vampire')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Vampire Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Vampire Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Vampire Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Vampire Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Vampire Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Vampire Oil 3')
				)
				{
					return true;
				}
			}
		}
		else 
		{
			return false;
		}
	}

	return false;
}

function ACS_RoachSteelSwordDummy_Container()
{
	var itemIds 																									: array<SItemUniqueId>;
	var i 																											: int;
	var steelid																										: SItemUniqueId; 
	var swordsteel																									: CEntity; 
	var steelcopy																									: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Sword_Dummy') )
	{
		steelcopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\weapons\swords\witcher_steel_swords\witcher_steel_sword_lvl1.w2ent"

		,true ), thePlayer.GetWorldPosition() -100, thePlayer.GetWorldRotation());

		steelcopy.AddTag('ACS_Roach_Stash_Steel_Sword_Dummy');
	}
}

function ACS_RoachSteelScabbardDummy_Container()
{
	var scabbardscomp 									: CDrawableComponent;
	var i 												: int;
	var items 											: array<SItemUniqueId>;
	var meshComponent 									: CMeshComponent;
	var ent 											: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Scabbard_Dummy') )
	{
		ent = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(
			
		"items\weapons\swords\nomansland_scabbards\nomansland_scabbard_lvl1.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		meshComponent = ( CMeshComponent ) ent.GetComponentByClassName( 'CMeshComponent' );

		meshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

		ent.AddTag('ACS_Roach_Stash_Steel_Scabbard_Dummy');
	}
}

function ACS_RoachSteelSwordAttachmentDummy_Container()
{
	var boneIndex 										: int;
	var boneName 										: name;
	var boneRotation									: EulerAngles;
	var bonePosition									: Vector;
	var dummycomp										: CEntity;
	var dummies											: array<CEntity>;
	var i : Int;
	
	theGame.GetEntitiesByTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment',dummies);
	
	for(i=0; i<dummies.Size(); i+=1)
	{
		dummies[i].Destroy();
	}
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment') )
	{
		if ( ACS_SwordsOnRoachPositioning() == 2
		)
		{
			boneName = 'spine2';
		}
		else
		{
			boneName = 'spine1';
		}	
		
		boneIndex = thePlayer.GetHorseWithInventory().GetBoneIndex( boneName );	
		thePlayer.GetHorseWithInventory().GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		dummycomp.AddTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment');

		dummycomp.CreateAttachmentAtBoneWS(thePlayer.GetHorseWithInventory(), boneName, bonePosition, boneRotation );
	}
}

function ACS_ConfigureSteelSwordAttachment_Container()
{
	var steel_pos_x,steel_pos_y,steel_pos_z   									: Float;
	var steel_scab_pos_x,steel_scab_pos_y,steel_scab_pos_z  					: Float;
	var steel_roll, steel_pitch, steel_yaw 										: Float; 
	var steel_scab_roll, steel_scab_pitch, steel_scab_yaw						: Float; 
	var steel_on_roach_position													: Vector;
	var steel_on_roach_rotation 												: EulerAngles;
	var steel_scab_on_roach_position 											: Vector;
	var steel_scab_on_roach_rotation							 				: EulerAngles;

	if (ACS_SwordsOnRoachPositioning() == 0)
	{
		steel_pos_x = -0.17; 
		steel_pos_y = 0.82; 
		steel_pos_z = 0.4; 

		steel_pitch = -62; 
		steel_roll = -1; 
		steel_yaw = 3;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 1)
	{
		steel_pos_x = 0.25; 
		steel_pos_y = 0.82; 
		steel_pos_z = 0.4; 

		steel_pitch = -110; 
		steel_roll = -1; 
		steel_yaw = 3;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 2)
	{
		steel_pos_x = -0.48; 
		steel_pos_y = -0.02; 
		steel_pos_z = 0.32; 

		steel_pitch = 180; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 3)
	{
		steel_pos_x = -0.39; 
		steel_pos_y = 0.06; 
		steel_pos_z = 0.27; 

		steel_pitch = -85; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 4)
	{
		steel_pos_x = 0.42; 
		steel_pos_y = 0.00; 
		steel_pos_z = 0.23; 

		steel_pitch = -85; 
		steel_roll = 10; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 5)
	{
		steel_pos_x = 0.40; 
		steel_pos_y = -0.2; 
		steel_pos_z = 0.25; 

		steel_pitch = -80; 
		steel_roll = 40; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 6)
	{
		steel_pos_x = -0.38; 
		steel_pos_y = 0.54; 
		steel_pos_z = 0.10; 

		steel_pitch = -85; 
		steel_roll = -66; 
		steel_yaw = -5;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}

	steel_on_roach_position.X = 0;    
	steel_on_roach_position.Y = 0;    
	steel_on_roach_position.Z = 0;     

	steel_on_roach_rotation.Pitch = 0;
	steel_on_roach_rotation.Roll = 0;
	steel_on_roach_rotation.Yaw = 0;
	
	steel_on_roach_position.X += steel_pos_y;
	steel_on_roach_position.Y -= steel_pos_z;
	steel_on_roach_position.Z -= steel_pos_x;

	steel_on_roach_rotation.Pitch += steel_pitch;
	steel_on_roach_rotation.Roll += steel_roll;
	steel_on_roach_rotation.Yaw += steel_yaw;
	
	ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment'),,steel_on_roach_position, steel_on_roach_rotation );

	steel_scab_on_roach_position.X = 0;
	steel_scab_on_roach_position.Y = 0; 
	steel_scab_on_roach_position.Z = 0;

	steel_scab_on_roach_rotation.Pitch = 0;
	steel_scab_on_roach_rotation.Roll = 0;
	steel_scab_on_roach_rotation.Yaw = 0;

	steel_scab_on_roach_position.X += 0.61;
	steel_scab_on_roach_position.Y -= 0.09; 	
	steel_scab_on_roach_position.Z -= -1.71;

	steel_scab_on_roach_rotation.Pitch += 180;       
	steel_scab_on_roach_rotation.Roll += -24.3;      
	steel_scab_on_roach_rotation.Yaw += 14.4 + 0.41;
	
	steel_scab_on_roach_position.X += steel_scab_pos_x;
	steel_scab_on_roach_position.Y -= steel_scab_pos_y;
	steel_scab_on_roach_position.Z -= steel_scab_pos_z;

	steel_scab_on_roach_rotation.Pitch += steel_scab_pitch;
	steel_scab_on_roach_rotation.Roll += steel_scab_roll; 
	steel_scab_on_roach_rotation.Yaw += steel_scab_yaw;   

	ACSGetCEntity('ACS_Roach_Stash_Steel_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy'),,steel_scab_on_roach_position, steel_scab_on_roach_rotation );
}

function ACS_RoachSilverSwordDummy_Container()
{
	var itemIds 																									: array<SItemUniqueId>;
	var i 																											: int;
	var silverid																									: SItemUniqueId; 
	var swordsilver																									: CEntity; 
	var silvercopy																									: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Sword_Dummy') )
	{
		silvercopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\cutscenes\witcher_silver_sword\silver_sword.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		silvercopy.AddTag('ACS_Roach_Stash_Silver_Sword_Dummy');
	}
}

function ACS_RoachSilverScabbardDummy_Container()
{
	var scabbardscomp_s 								: CDrawableComponent;
	var i 												: int;
	var items 											: array<SItemUniqueId>;
	var meshComponent 									: CMeshComponent;
	var ent_s 											: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Scabbard_Dummy') )
	{
		ent_s = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\bodyparts\geralt_items\scabbards\silver_scabbards\scabbard_silver_1_01.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		meshComponent = ( CMeshComponent ) ent_s.GetComponentByClassName( 'CMeshComponent' );

		meshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

		ent_s.AddTag('ACS_Roach_Stash_Silver_Scabbard_Dummy');
	}
}

function ACS_RoachSilverSwordAttachmentDummy_Container()
{
	var boneIndex 										: int;
	var boneName 										: name;
	var boneRotation									: EulerAngles;
	var bonePosition									: Vector;
	var dummycomp										: CEntity;
	var dummies											: array<CEntity>;
	var i : Int;
	
	//boneName = 'r_shoulder';
	//boneName = 'spine3';
	//boneName = 'pelvis';
	
	//boneName = 'spine2';
	//boneName = 'spine1';
	
	theGame.GetEntitiesByTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment',dummies);
	
	for(i=0; i<dummies.Size(); i+=1)
	{
		dummies[i].Destroy();
	}
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment') )
	{
		if ( ACS_SwordsOnRoachPositioning() == 2
		)
		{
			boneName = 'spine2';
		}
		else
		{
			boneName = 'spine1';
		}	
		
		boneIndex = thePlayer.GetHorseWithInventory().GetBoneIndex( boneName );	
		thePlayer.GetHorseWithInventory().GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		dummycomp.AddTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment');

		dummycomp.CreateAttachmentAtBoneWS(thePlayer.GetHorseWithInventory(), boneName, bonePosition, boneRotation );
	}
}

function ACS_ConfigureSilverSwordAttachment_Container()
{
	var silver_pos_x,silver_pos_y,silver_pos_z   								: Float;
	var silver_scab_pos_x,silver_scab_pos_y,silver_scab_pos_z  					: Float;
	var silver_roll, silver_pitch, silver_yaw 									: Float; 
	var silver_scab_roll,silver_scab_pitch,silver_scab_yaw						: Float; 
	var silver_on_roach_position												: Vector;
	var silver_on_roach_rotation 												: EulerAngles;
	var silver_scab_on_roach_position 											: Vector;
	var silver_scab_on_roach_rotation 											: EulerAngles;

	if (ACS_SwordsOnRoachPositioning() == 0)
	{
		silver_pos_x = -0.2; 
		silver_pos_y = 0.70; 
		silver_pos_z = 0.4; 

		silver_pitch = -62; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 1)
	{
		silver_pos_x = 0.3; 
		silver_pos_y = 0.70; 
		silver_pos_z = 0.4; 

		silver_pitch = -105; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 2)
	{
		silver_pos_x = -0.35; 
		silver_pos_y = 0.05; 
		silver_pos_z = 0.29; 

		silver_pitch = 180; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 3)
	{
		silver_pos_x = -0.34; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.32; 

		silver_pitch = -85; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 4)
	{
		silver_pos_x = 0.37; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.27; 

		silver_pitch = -85; 
		silver_roll = 10; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 5)
	{
		silver_pos_x = -0.36; 
		silver_pos_y = -0.18; 
		silver_pos_z = 0.30; 

		silver_pitch = -88; 
		silver_roll = 40; 
		silver_yaw = -5;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_SwordsOnRoachPositioning() == 6)
	{
		silver_pos_x = -0.36; 
		silver_pos_y = 0.53; 
		silver_pos_z = 0.00; 

		silver_pitch = -85; 
		silver_roll = -75; 
		silver_yaw = -4;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}

	silver_on_roach_position.X = 0;    
	silver_on_roach_position.Y = 0;    
	silver_on_roach_position.Z = 0;     

	silver_on_roach_rotation.Pitch = 0;
	silver_on_roach_rotation.Roll = 0;
	silver_on_roach_rotation.Yaw = 0;
	
	silver_on_roach_position.X += silver_pos_y;
	silver_on_roach_position.Y -= silver_pos_z;
	silver_on_roach_position.Z -= silver_pos_x;

	silver_on_roach_rotation.Pitch += silver_pitch;
	silver_on_roach_rotation.Roll += silver_roll;
	silver_on_roach_rotation.Yaw += silver_yaw;
	
	ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment'),,silver_on_roach_position, silver_on_roach_rotation );

	silver_scab_on_roach_position.X = 0;
	silver_scab_on_roach_position.Y = 0; 
	silver_scab_on_roach_position.Z = 0;

	silver_scab_on_roach_rotation.Pitch = 0;
	silver_scab_on_roach_rotation.Roll = 0;
	silver_scab_on_roach_rotation.Yaw = 0;

	silver_scab_on_roach_position.X += 0.61 + 0.025; 
	silver_scab_on_roach_position.Y -= 0.09 - 0.1;  
	silver_scab_on_roach_position.Z -= -1.71 + 0.07;   

	silver_scab_on_roach_rotation.Pitch += 180 - 1.5;
	silver_scab_on_roach_rotation.Roll += -24.3 - 5.5;
	silver_scab_on_roach_rotation.Yaw += 14.4 + 4;
	
	silver_scab_on_roach_position.X += silver_scab_pos_x;
	silver_scab_on_roach_position.Y -= silver_scab_pos_y;
	silver_scab_on_roach_position.Z -= silver_scab_pos_z;

	silver_scab_on_roach_rotation.Pitch += silver_scab_pitch;
	silver_scab_on_roach_rotation.Roll += silver_scab_roll; 
	silver_scab_on_roach_rotation.Yaw += silver_scab_yaw;   
	
	ACSGetCEntity('ACS_Roach_Stash_Silver_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy'),,silver_scab_on_roach_position, silver_scab_on_roach_rotation );
}

function ACS_CheckRoachContainerInventorySteel() : bool
{
	var itemIds 																									: array<SItemUniqueId>;

	itemIds = GetACSRoachStashContainerNoSpawn().GetInventory().GetItemsByTag( 'PlayerSteelWeapon' );

	if (itemIds.Size() > 0)
	{
		return true;
	}

	return false;
}

function ACS_CheckRoachContainerCheckInventorySilver() : bool
{
	var itemIds 																									: array<SItemUniqueId>;

	itemIds = GetACSRoachStashContainerNoSpawn().GetInventory().GetItemsByTag( 'PlayerSilverWeapon' );

	if (itemIds.Size() > 0)
	{
		return true;
	}

	return false;
}

function ACS_CheckRoachContainerCheckInventoryCrossbow() : bool
{
	var itemIds 																									: array<SItemUniqueId>;

	itemIds = GetACSRoachStashContainerNoSpawn().GetInventory().GetItemsByTag( 'crossbow' );

	if (itemIds.Size() > 0)
	{
		return true;
	}

	return false;
}

/*
class ACSHuntModuleDialog extends CR4HudModuleDialog
{
	
	function DialogueSliderDataPopupResult( value : float,  optional isItemReward : bool )
	{
		var current_area : EAreaName;
		
		super.DialogueSliderDataPopupResult(value ,false );
		current_area = theGame.GetCommonMapManager().GetCurrentArea();
		if(current_area == AN_Skellige_ArdSkellig )
		{
			GetACSWatcher().getMonsterHunt().setCurrentBet(value,ACSHA_skellige);
		}
		else if( current_area == AN_Velen || current_area== AN_NMLandNovigrad )
		{
			GetACSWatcher().getMonsterHunt().setCurrentBet(value,ACSHA_novigrad);
		}
		else if( current_area == (EAreaName)AN_Dlc_Bob )
		{
			GetACSWatcher().getMonsterHunt().setCurrentBet(value,ACSHA_toussaint);
		}
	}
}

enum ACSHuntArea
{
	ACSHA_none,
	ACSHA_skellige,
	ACSHA_novigrad,
	ACSHA_toussaint
}

enum ACSHuntStatus
{
	ACSHS_none,
	ACSHS_noticePosted,
	ACSHS_noticeTaken,
	ACSHS_targetSpawned,
	ACSHS_targetKilled
}

struct ACSHunt
{
	var targetTag 		: name;
	var noticeItemName 	: name;
	var maxRewardName 	: name;
	var bet 			: float;
	var spawnCenter		: Vector;
	var spawnPosition 	: Vector;
	var targetEntity 	: CEntity;
	var area 	   		: ACSHuntArea;
	var status 			: ACSHuntStatus;
	var monsterLevel	: int;
}


class ACSMonsterHuntChallenge
{
	var _huntsArray 						: array<ACSHunt>;
	var _SkelligeSpawnCenters 				: array<Vector>;
	var _NovSpawnCenters 					: array<Vector>;
	var _ToussaintSpawnCenters				: array<Vector>;
	var _skelligeBoardsArray				: array<name>;
	var _novBoardsArray 					: array<name>;
	var _toussaintBoardsArray				: array<name>;
	var _skeHunt,_novHunt,_tousHunt 		: ACSHunt;
	var _currentHuntDay 					: int;
	var betDialog 							: ACSHuntModuleDialog;	 
	

	public function init()
	{
		var i : int;
		
		//generating challenges
		_huntsArray.Clear();
		addHuntToArray('acs_monster_hunt_fogling','modEHNotice_1');
		addHuntToArray('acs_monster_hunt_hag_water','modEHNotice_2');
		addHuntToArray('acs_monster_hunt_wyvern','modEHNotice_3');
		addHuntToArray('acs_monster_hunt_archgriffin','modEHNotice_4');
		addHuntToArray('acs_monster_hunt_harpy','modEHNotice_5');
		addHuntToArray('acs_monster_hunt_ekhidna','modEHNotice_6');
		//addHuntToArray("modEHNotice_7",'mon_endriaga_soldier_spikey','modEHNotice_7','modEHNotice_med_reward');
		//addHuntToArray("modEHNotice_8",'mon_endriaga_soldier_tailed','modEHNotice_8','modEHNotice_high_reward');
		addHuntToArray('acs_monster_hunt_bies','modEHNotice_9');
		addHuntToArray('acs_monster_hunt_troll_cave','modEHNotice_10');
		addHuntToArray('acs_monster_hunt_forktail','modEHNotice_11');
		addHuntToArray('acs_monster_hunt_arachas','modEHNotice_12');
		addHuntToArray('acs_monster_hunt_gryphon','modEHNotice_13');
		addHuntToArray('acs_monster_hunt_nightwraith','modEHNotice_14');
		addHuntToArray('acs_monster_hunt_cockatrice','modEHNotice_15');		
		addHuntToArray('acs_monster_hunt_crab','modEHNotice_16');
		addHuntToArray('acs_monster_hunt_czart','modEHNotice_17');
		addHuntToArray('acs_monster_hunt_elemental','modEHNotice_18');
		addHuntToArray('acs_monster_hunt_fugas','modEHNotice_19');
		addHuntToArray('acs_monster_hunt_katakan','modEHNotice_20');
		addHuntToArray('acs_monster_hunt_lessog','modEHNotice_21');		
		addHuntToArray('acs_monster_hunt_nekker','modEHNotice_22');		
		addHuntToArray('acs_monster_hunt_noonwright','modEHNotice_23');		
		addHuntToArray('acs_monster_hunt_siren','modEHNotice_24');		
		addHuntToArray('acs_monster_hunt_him','modEHNotice_25');		


		
		//list of noticeboardes in Skellige
		_skelligeBoardsArray.Clear();
		_skelligeBoardsArray.PushBack('fyresdal_notice_board');
		_skelligeBoardsArray.PushBack('blandare_notice_board');
		_skelligeBoardsArray.PushBack('kaer_trolde_village_notice_board');
		_skelligeBoardsArray.PushBack('rannvaig_noticeboard');
		_skelligeBoardsArray.PushBack('holmstein_notice_board');
		_skelligeBoardsArray.PushBack('brokvar_notice_board');
		_skelligeBoardsArray.PushBack('larvik_notice_board');
		_skelligeBoardsArray.PushBack('arinbjorn_noticeboard');
		
		//list of noticeBoards in velen&novigrad
		_novBoardsArray.Clear();
		_novBoardsArray.PushBack('nilfgaard_camp_notice_board');
		_novBoardsArray.PushBack('borrows_notice_board');
		_novBoardsArray.PushBack('rudnik_notice_board');
		_novBoardsArray.PushBack('mouths_notice_board');
		_novBoardsArray.PushBack('barons_village_notice_board');
		_novBoardsArray.PushBack('midcotts_noticeboard');
		_novBoardsArray.PushBack('inn_crossroads_notice_board');
		_novBoardsArray.PushBack('poppystone_notice_board');
		_novBoardsArray.PushBack('whitebridge_noticeboard');
		_novBoardsArray.PushBack('fat_catch_inn_noticeboard');
		_novBoardsArray.PushBack('toderas_noticeboard');
		_novBoardsArray.PushBack('seven_cats_noticeboard');
		_novBoardsArray.PushBack('southern_farms_notice_board');
		_novBoardsArray.PushBack('farmsvillage_2_noticeboard');
		_novBoardsArray.PushBack('q602_village_noticeboard');
		_novBoardsArray.PushBack('harbor_district_noticeboard');
		_novBoardsArray.PushBack('market_noticeboard');
		_novBoardsArray.PushBack('novigrad_rich_district_noticeboard');
		
		//list of noaticeBoards in Toussaint
		_toussaintBoardsArray.Clear();
		_toussaintBoardsArray.PushBack('trappers_trading_post_noticeboard');
		_toussaintBoardsArray.PushBack('cockatrice_inn_noticeboard');
		_toussaintBoardsArray.PushBack('tufo_vineyard_noticeboard');
		_toussaintBoardsArray.PushBack('quarry_noticeboard_mp');
		_toussaintBoardsArray.PushBack('coronata_vineyard_noticeboard');
		_toussaintBoardsArray.PushBack('castel_ravello_noticeboard');
		_toussaintBoardsArray.PushBack('beauclair_city_noticeboard');
		
		//spawnPoints
		_SkelligeSpawnCenters.Clear();	
		_NovSpawnCenters.Clear();
		_ToussaintSpawnCenters.Clear();

		_NovSpawnCenters.PushBack(Vector(  1925, -435, 200 ));//TODO Water
		_NovSpawnCenters.PushBack(Vector(  1073, -55, 200 ));
		_NovSpawnCenters.PushBack(Vector(  57, 468, 200 ));
		_NovSpawnCenters.PushBack(Vector(  905, 2502, 100 ));//TODO Border
		_NovSpawnCenters.PushBack(Vector(  1300, 700, 120 ));
		_NovSpawnCenters.PushBack(Vector(  1351, -600, 300 ));
		_NovSpawnCenters.PushBack(Vector(  -469, -192, 200 ));
		_NovSpawnCenters.PushBack(Vector(  1709, -350, 150 ));
		_NovSpawnCenters.PushBack(Vector(  1591, 92, 150 ));
		_NovSpawnCenters.PushBack(Vector(  1395, 91, 150 ));
		_NovSpawnCenters.PushBack(Vector(  319, 1472, 100 ));
		_NovSpawnCenters.PushBack(Vector(  532, 1317, 100 ));
		_NovSpawnCenters.PushBack(Vector(  1101, 1516, 100 ));
		_NovSpawnCenters.PushBack(Vector(  773, 642, 100 ));
		_NovSpawnCenters.PushBack(Vector(  255, -195, 150 ));
		_NovSpawnCenters.PushBack(Vector(  2172, 1067, 200 ));
		_NovSpawnCenters.PushBack(Vector(  1865, 1872, 150 ));

		
		_SkelligeSpawnCenters.PushBack(Vector(933,-230,200));
		_SkelligeSpawnCenters.PushBack(Vector(652,-448,100));
		_SkelligeSpawnCenters.PushBack(Vector(-429,-275,100));
		_SkelligeSpawnCenters.PushBack(Vector(819,380,200));
		_SkelligeSpawnCenters.PushBack(Vector(-9,373,80));
		_SkelligeSpawnCenters.PushBack(Vector(369,-45,150));
		_SkelligeSpawnCenters.PushBack(Vector(585,-497,100));
		_SkelligeSpawnCenters.PushBack(Vector(574,619,80));
		_SkelligeSpawnCenters.PushBack(Vector(-1420,1492,80));
		_SkelligeSpawnCenters.PushBack(Vector(-1560,-706,100));

		_ToussaintSpawnCenters.PushBack(Vector(1000,-686,200));
		_ToussaintSpawnCenters.PushBack(Vector(-540,-552,150));
		_ToussaintSpawnCenters.PushBack(Vector(-215,174,150));
		_ToussaintSpawnCenters.PushBack(Vector(-290,363,150));
		_ToussaintSpawnCenters.PushBack(Vector(453,-616,150));
		_ToussaintSpawnCenters.PushBack(Vector(911,-1000,150));
		_ToussaintSpawnCenters.PushBack(Vector(484,-1500,150));
		_ToussaintSpawnCenters.PushBack(Vector(277,-1931,150));
		_ToussaintSpawnCenters.PushBack(Vector(-378,-1897,150));
		
		if(  !FactsDoesExist("ACS_Version_" + FloatToString(ACS_GetVersion())) ) 
		{	
			update();
			FactsAdd("ACS_Version_" + FloatToString(ACS_GetVersion()));
		}
	
		if( _skeHunt.status == ACSHS_targetSpawned && !_skeHunt.targetEntity)
		{
			_skeHunt.targetEntity = theGame.GetEntityByTag(_skeHunt.targetTag);
			 ((CNewNPC)_skeHunt.targetEntity).SetLevel(_skeHunt.monsterLevel);
		}
		if(_novHunt.status == ACSHS_targetSpawned && !_novHunt.targetEntity)
		{
			_novHunt.targetEntity = theGame.GetEntityByTag(_novHunt.targetTag);
			((CNewNPC)_novHunt.targetEntity).SetLevel(_novHunt.monsterLevel);
		}
		if(_tousHunt.status == ACSHS_targetSpawned && !_tousHunt.targetEntity)
		{
			_tousHunt.targetEntity = theGame.GetEntityByTag(_tousHunt.targetTag);
			((CNewNPC)_tousHunt.targetEntity).SetLevel(_tousHunt.monsterLevel);
		}
				
	}

	private function addHuntToArray(targetTag : name, noticeItemName : name,optional canFly : bool )
	{
		var hunt : ACSHunt;
		
		//hunt.locName = locName;
		hunt.targetTag = targetTag; 
		hunt.noticeItemName = noticeItemName;
		hunt.maxRewardName = 'modEHMonsterHunt_high_reward';
		hunt.area = ACSHA_none;
		hunt.status = ACSHS_none;

		_huntsArray.PushBack(hunt);
	}
	
	public function refreshHunt()
	{
		var area : EAreaName ;
		var dist : float;
		
		//refresh
		if( FactsQuerySum("ACS_Monster_Hunt_Active") <= 0 )
		{
		
			clearAll();

			//##### Skellige #####
		
			_skeHunt.spawnCenter = Vector(0,0,0);
			_skeHunt.spawnPosition = Vector(0,0,0);
			//reset bet
			_skeHunt.bet = 0;
			//add  new one
			postNewNotice(ACSHA_skellige);
			
			//##### Novigrad #####

			_novHunt.spawnCenter = Vector(0,0,0);
			_novHunt.spawnPosition = Vector(0,0,0);
			//reset bet
			_novHunt.bet = 0;
			//add  new one
			postNewNotice(ACSHA_novigrad);
			
			//##### Toussaint #####


			_tousHunt.spawnCenter = Vector(0,0,0);
			_tousHunt.spawnPosition = Vector(0,0,0);
			//reset bet
			_tousHunt.bet = 0;
			//add  new one
			postNewNotice(ACSHA_toussaint);
			
			
			_currentHuntDay = GameTimeDays(theGame.GetGameTime());
			
		}
		
		//spawn monsters if needed
		area = theGame.GetCommonMapManager().GetCurrentArea();
		
		if(area == AN_Skellige_ArdSkellig &&_skeHunt.status == ACSHS_noticeTaken )
		{
			dist = VecDistance2D(thePlayer.GetWorldPosition(),_skeHunt.spawnPosition);
			if(dist<=400)
			{
				_spawnHunt(ACSHA_skellige);
				//status changed inside the function
			}
		}
		if(area == AN_NMLandNovigrad && _novHunt.status == ACSHS_noticeTaken)
		{
			dist = VecDistance2D(thePlayer.GetWorldPosition(),_novHunt.spawnPosition);
			if(dist<=400)
			{
				_spawnHunt(ACSHA_novigrad);
				//status changed inside the function
			}
		}
		if(area == (EAreaName)AN_Dlc_Bob && _tousHunt.status == ACSHS_noticeTaken)
		{
			dist = VecDistance2D(thePlayer.GetWorldPosition(),_tousHunt.spawnPosition);
			if(dist<=400)
			{
				_spawnHunt(ACSHA_toussaint);
				//status changed inside the function
			}
		}
	
	}
	
	public function  update()
	{
		var rawHunt : ACSHunt;
	
		clearAll();

		_currentHuntDay = 0;
		_skeHunt = rawHunt;
		_novHunt = rawHunt;
		_tousHunt = rawHunt;
	}

	public function clearAll()
	{
		var i,j 	: int;
		var ents	: array<CEntity>;
		var bookFactName:  string;
		
		//notices in skellige
		clearAllNotices(ACSHA_skellige);	
		
		//notices in novigrad
		clearAllNotices(ACSHA_novigrad);
		
		//notices in toussaint
		clearAllNotices(ACSHA_toussaint);
		
		//inventory items
		thePlayer.GetInventory().RemoveItemByTag('eh_notice',-1);
		//books
		for(j=0;j<_huntsArray.Size();j+=1)
		{
			bookFactName = "BookReadState_"+_huntsArray[j].noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}
		
		//target monsters
		theGame.GetEntitiesByTag('acs_monster_hunt',ents);
		for(i=0;i<ents.Size();i+=1)
		{
			ents[i].Destroy();
		}
		
		
	}
	
	public function clearAllNotices(area : ACSHuntArea)
	{
		var i,j : int;
		
		if(area == ACSHA_skellige)
		{
			for( i=0; i< _skelligeBoardsArray.Size(); i+=1 )
			{
				for( j=0; j<_huntsArray.Size(); j+=1 )
				{
					RemoveErrandsFromNoticeboard(_skelligeBoardsArray[i],NameToString(_huntsArray[j].noticeItemName) );
				}
			}
		}
		else if(area == ACSHA_novigrad)
		{
			for( i=0; i< _novBoardsArray.Size(); i+=1 )
			{
				for( j=0; j<_huntsArray.Size(); j+=1 )
				{
					RemoveErrandsFromNoticeboard(_novBoardsArray[i],NameToString(_huntsArray[j].noticeItemName) );
				}
			}
		}
		else
		{
			for( i=0; i< _toussaintBoardsArray.Size(); i+=1 )
			{
				for( j=0; j<_huntsArray.Size(); j+=1 )
				{
					RemoveErrandsFromNoticeboard(_toussaintBoardsArray[i],NameToString(_huntsArray[j].noticeItemName) );
				}
			}
		}
	
	}

	public function noticeTaken()
	{
		//var scene : CStoryScene;
		
		theGame.GetGuiManager().GetRootMenu().CloseMenu();
		
		//scene = (CStoryScene)LoadResource( "dlc\dlc_acs\data\scenes\eh_bet_scene.w2scene", true);
		//theGame.GetStorySceneSystem().PlayScene(scene, "Input");
		startHunt();
	}

	public function startHunt()
	{
		var current_area : EAreaName;

		clearAll();

		current_area = theGame.GetCommonMapManager().GetCurrentArea();
		
		if(current_area == AN_Skellige_ArdSkellig )
		{
			_skeHunt.status = ACSHS_noticeTaken;
			thePlayer.GetInventory().AddAnItem(_skeHunt.noticeItemName,1,false);
			betDialog = new ACSHuntModuleDialog in this;
			betDialog.OpenBetPopup(_skeHunt.maxRewardName,0);
			_prepareSpawn(ACSHA_skellige);
		}
		else if( current_area == AN_Velen || current_area== AN_NMLandNovigrad )
		{
			_novHunt.status =  ACSHS_noticeTaken;
			thePlayer.GetInventory().AddAnItem(_novHunt.noticeItemName,1,false);
			betDialog = new ACSHuntModuleDialog in this;
			betDialog.OpenBetPopup(_novHunt.maxRewardName,0);
			_prepareSpawn(ACSHA_novigrad);

		}
		else if( current_area == (EAreaName)AN_Dlc_Bob )
		{
			_tousHunt.status =  ACSHS_noticeTaken;
			thePlayer.GetInventory().AddAnItem(_tousHunt.noticeItemName,1,false);
			betDialog = new ACSHuntModuleDialog in this;
			betDialog.OpenBetPopup(_tousHunt.maxRewardName,0);
			_prepareSpawn(ACSHA_toussaint);

		}
			
		theSound.SoundEvent("gui_ingame_quest_active");

		if ( FactsQuerySum("ACS_Monster_Hunt_Active") <= 0 )
		{
			FactsAdd("ACS_Monster_Hunt_Active", 1, -1);
		}
	}
	
	public function npcKilled( npc : CNewNPC )
	{
		if( ( _skeHunt.status != ACSHS_targetSpawned ) && (_novHunt.status != ACSHS_targetSpawned ) && (_tousHunt.status != ACSHS_targetSpawned) )
		 return;
		 
		if( ! npc.HasTag('acs_monster_hunt'))
		 return;

		if(  _skeHunt.status == ACSHS_targetSpawned && npc.HasTag(_skeHunt.targetTag) )
		{ 
			
			_skeHunt.status = ACSHS_targetKilled;
			removeCurrentItem(ACSHA_skellige);//TODO change this
			
			//giveReward
			if(_skeHunt.bet != 0)
			{
				thePlayer.GetInventory().AddMoney(RoundF(_skeHunt.bet * 2));
			}
			
			thePlayer.DisplayHudMessage(GetLocStringByKeyExt("modACSMonsterHuntChallenge_success"));
			theSound.SoundEvent("gui_ingame_quest_success");
			theGame.GetGuiManager().ShowNotification("+ "+FloatToString(_skeHunt.bet * 2)+" Gold");

			
		}
		else if(_novHunt.status == ACSHS_targetSpawned && npc.HasTag(_novHunt.targetTag))
		{
			_novHunt.status = ACSHS_targetKilled;
			removeCurrentItem(ACSHA_novigrad);
			
			if(_novHunt.bet != 0)
			{
				thePlayer.GetInventory().AddMoney(RoundF(_novHunt.bet * 2));
			}
			
			thePlayer.DisplayHudMessage(GetLocStringByKeyExt("modACSMonsterHuntChallenge_success"));
			theSound.SoundEvent("gui_ingame_quest_success");
			theGame.GetGuiManager().ShowNotification("+ "+FloatToString(_novHunt.bet * 2)+" Gold");
		
		}
		else if(  _tousHunt.status == ACSHS_targetSpawned && npc.HasTag(_tousHunt.targetTag) )
		{ 
			
			_tousHunt.status = ACSHS_targetKilled;
			removeCurrentItem(ACSHA_toussaint);
			
			if(_tousHunt.bet != 0)
			{
				thePlayer.GetInventory().AddMoney(RoundF(_tousHunt.bet * 2));
			}
			
			thePlayer.DisplayHudMessage(GetLocStringByKeyExt("modACSMonsterHuntChallenge_success"));
			theSound.SoundEvent("gui_ingame_quest_success");
			theGame.GetGuiManager().ShowNotification("+ "+FloatToString(_tousHunt.bet * 2)+" Gold");

			
		}

		if (FactsQuerySum("ACS_Monster_Hunt_Active") > 0)
		{
			FactsRemove("ACS_Monster_Hunt_Active");
		}
	}
	
	private function getNewHunt() : ACSHunt
	{
		var rand : int;
		
		rand = RandRange(_huntsArray.Size(),0);
		return _huntsArray[rand];
	}
	
	private function newErrandList(errandLocName : string) :  array < ErrandDetailsList >
	{
		var errandDetails : array < ErrandDetailsList >;
		var details : ErrandDetailsList;
		
		
		details.errandStringKey = errandLocName;
		details.newQuestFact = "ACS_Version_" + FloatToString(ACS_GetVersion());
		details.errandPosition = 0;
		errandDetails.PushBack( details);
		
		return errandDetails;
	}

	private function postNewNotice(area : ACSHuntArea)
	{
		var newHunt 			: ACSHunt;
		var errandDetails 		: array < ErrandDetailsList >;
		var i 					: int;
		
		if(area == ACSHA_skellige)
		{
			newHunt = getNewHunt();

			while
			(	
				newHunt.targetTag == _skeHunt.targetTag 
				|| 	newHunt.targetTag == _novHunt.targetTag
				||	newHunt.targetTag == _tousHunt.targetTag
			)
			{
				newHunt = getNewHunt();
			}
			
			
			_skeHunt = newHunt;
			_skeHunt.status = ACSHS_noticePosted;
			_skeHunt.area = ACSHA_skellige;
			errandDetails = newErrandList(_skeHunt.noticeItemName);

			for( i=0; i< _skelligeBoardsArray.Size(); i+=1 )
			{
				AddErrandsToTheNoticeBoard(_skelligeBoardsArray[i],errandDetails, true );
			}
		}
		else if(area == ACSHA_novigrad )
		{
			newHunt = getNewHunt();

			while
			(	
				newHunt.targetTag == _skeHunt.targetTag 
				|| 	newHunt.targetTag == _novHunt.targetTag
				||	newHunt.targetTag == _tousHunt.targetTag
			)
			{
				newHunt = getNewHunt();
			}

			
			_novHunt = newHunt;
			_novHunt.status = ACSHS_noticePosted;
			_novHunt.area = ACSHA_novigrad;
			errandDetails = newErrandList(_novHunt.noticeItemName);

			for( i=0; i< _novBoardsArray.Size(); i+=1 )
			{
				AddErrandsToTheNoticeBoard(_novBoardsArray[i],errandDetails, true );
			}
		}	
		else
		{
			
			newHunt = getNewHunt();
			while
			(	
				newHunt.targetTag == _skeHunt.targetTag 
				|| 	newHunt.targetTag == _novHunt.targetTag
				||	newHunt.targetTag == _tousHunt.targetTag
			)
			{
				newHunt = getNewHunt();
			}
			
			
			_tousHunt = newHunt;
			_tousHunt.status = ACSHS_noticePosted;
			_tousHunt.area = ACSHA_toussaint;
			errandDetails = newErrandList(_tousHunt.noticeItemName);

			for( i=0; i< _toussaintBoardsArray.Size(); i+=1 )
			{
				AddErrandsToTheNoticeBoard(_toussaintBoardsArray[i],errandDetails, true );
			}
		}
			
	}
	
	private function _calculateSpawnPositon(area : ACSHuntArea) : Vector
	{
		var SpawnPointsArray : array<Vector>;
		var spawnPoint : Vector;
		var rand : int;
		
		if(area == ACSHA_skellige )
			SpawnPointsArray = _SkelligeSpawnCenters;	
		
		if(area == ACSHA_novigrad )
			SpawnPointsArray = _NovSpawnCenters;	
		if(area == ACSHA_toussaint )
			SpawnPointsArray = _ToussaintSpawnCenters;
		
		rand = RandRange(SpawnPointsArray.Size());
		
		if(area == ACSHA_skellige)
		{
			_skeHunt.spawnCenter = SpawnPointsArray[rand];
			return getRandomPositionInRadius(_skeHunt.spawnCenter,RoundF(_skeHunt.spawnCenter.Z) );
		}
		else if(area == ACSHA_novigrad)
		{
			_novHunt.spawnCenter = SpawnPointsArray[rand];
			return getRandomPositionInRadius(_novHunt.spawnCenter ,RoundF(_novHunt.spawnCenter.Z) );
		}else
		{
			_tousHunt.spawnCenter = SpawnPointsArray[rand];
			return getRandomPositionInRadius(_tousHunt.spawnCenter ,RoundF(_tousHunt.spawnCenter.Z) );
		}
	}
	
	private function _calculateSpawnLevel() : int
	{
		var pLevel,lvl : int;
		
		pLevel = thePlayer.GetLevel();
		
		return RandRange(pLevel+5,pLevel);
	}
	
	private function _getTemplateFromTarget(targetTag : name) : CEntityTemplate
	{
		var path : string;
		
		path = "dlc/dlc_acs/data/entities/monsters/"+ NameToString(targetTag) + ".w2ent";

		return (CEntityTemplate)LoadResource(path,true);
	}
	
	private function getRandomPositionInRadius(Center : Vector , Radius : int):Vector
	{
		var pos : Vector;
		
		pos.X  = Center.X + RandRange(Radius/2,-Radius/2);
		pos.Y  = Center.Y + RandRange(Radius/2,-Radius/2);
		pos.Z  = 0;
		return pos;
	}
	
	private function _prepareSpawn(area : ACSHuntArea)
	{
		var spawnedEntity : CEntity;
		var npc	:	CNewNPC;
		var spawnPosition : Vector;
		var SpawnLevel  : int;
		var template : CEntityTemplate;

		if(area == ACSHA_skellige)
		{
			_skeHunt.spawnPosition = _calculateSpawnPositon(area);
		}
		else if (area == ACSHA_novigrad)
		{
			_novHunt.spawnPosition = _calculateSpawnPositon(area);
		}
		else
		{
			_tousHunt.spawnPosition = _calculateSpawnPositon(area);		
		}
		
	}
	
	private function _spawnHunt(area : ACSHuntArea )
	{
		var spawnedEntity : CEntity;
		var npc	:	CNewNPC;
		var spawnPosition : Vector;
		var SpawnLevel  : int;
		var template : CEntityTemplate;
		
		if( area == ACSHA_skellige)
		{
			template = _getTemplateFromTarget(_skeHunt.targetTag);
			spawnPosition = _skeHunt.spawnPosition;

		}
		else if(area == ACSHA_novigrad)
		{
			template = _getTemplateFromTarget(_novHunt.targetTag);
			spawnPosition = _novHunt.spawnPosition;
		}
		else
		{
			template = _getTemplateFromTarget(_tousHunt.targetTag);
			spawnPosition = _tousHunt.spawnPosition;
		}

		SpawnLevel = _calculateSpawnLevel();
		
		if(!theGame.GetWorld().NavigationComputeZ(spawnPosition,spawnPosition.Z-100,spawnPosition.Z+100,spawnPosition.Z) )
		{
			return;
		}
		
		spawnedEntity = theGame.CreateEntity(template,spawnPosition, EulerAngles(0,0,0));
		npc = (CNewNPC)spawnedEntity;
		npc.SetLevel(SpawnLevel);
		npc.AddTag('acs_monster_hunt');

		
		if(area == ACSHA_skellige)
		{
			_skeHunt.status = ACSHS_targetSpawned;
			_skeHunt.targetEntity = spawnedEntity;
			_skeHunt.monsterLevel = SpawnLevel;
		}
		else if(area == ACSHA_novigrad)
		{
			_novHunt.status = ACSHS_targetSpawned;
			_novHunt.targetEntity = spawnedEntity;
			_novHunt.monsterLevel = SpawnLevel;
		}
		else
		{
			_tousHunt.status = ACSHS_targetSpawned;
			_tousHunt.targetEntity = spawnedEntity;
			_tousHunt.monsterLevel = SpawnLevel;
		}

		
	}
	
	private function _despawnMonster(area : ACSHuntArea)
	{
		if(area == ACSHA_skellige )
		{
			_skeHunt.targetEntity.Destroy();
		}
		else if(area == ACSHA_novigrad )
		{
			_novHunt.targetEntity.Destroy();
		}
		else
		{
			_tousHunt.targetEntity.Destroy();
		}

	}
	
	public function removeCurrentItem(area : ACSHuntArea)
	{
		var bookFactName		: string;
		if( area == ACSHA_skellige )
		{
			thePlayer.GetInventory().RemoveItemByName(_skeHunt.noticeItemName,1);
			bookFactName = "BookReadState_"+_skeHunt.noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}
		else if( area == ACSHA_novigrad )
		{
			thePlayer.GetInventory().RemoveItemByName(_novHunt.noticeItemName,1);
			bookFactName = "BookReadState_"+_novHunt.noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}	
		else
		{
			thePlayer.GetInventory().RemoveItemByName(_tousHunt.noticeItemName,1);
			bookFactName = "BookReadState_"+_tousHunt.noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}
	}
	
	public function setCurrentBet(value : float,area : ACSHuntArea)
	{
		if( area == ACSHA_skellige)
		{
			_skeHunt.bet = value;	
		}
		else if( area == ACSHA_novigrad )
		{
			_novHunt.bet = value;	
		}
		else
		{
			_tousHunt.bet = value;
		}
	}
	
	public function getcurrentSpawn(area : ACSHuntArea): CEntity
	{
		if(area == ACSHA_skellige )
		{
			return _skeHunt.targetEntity;
		}
		else if(area == ACSHA_novigrad)
		{
			return _novHunt.targetEntity;
		}
		else
		{
			return _tousHunt.targetEntity;
		}
	}
	
	 
	public function _getCurrentHuntStatus(where : ACSHuntArea) : ACSHuntStatus
	{
		if(where == ACSHA_skellige)
		{
			return _skeHunt.status;
		}
		else if(where == ACSHA_novigrad)
		{
			return _novHunt.status;
		}
		else
		{
			return _tousHunt.status;
		}

	}
	
	public function _getCurrentCenter(where : ACSHuntArea) : Vector
	{
		if(where == ACSHA_skellige )
		{
			return _skeHunt.spawnCenter;
		}
		else if(where == ACSHA_novigrad)
		{
			return _novHunt.spawnCenter;
		}
		else
		{
			return _tousHunt.spawnCenter;
		}
	}
	
	public function _getCurrentPos(where : ACSHuntArea) : Vector
	{
		if(where == ACSHA_skellige )
		{
			return _skeHunt.spawnPosition;
		}
		else if(where == ACSHA_novigrad)
		{
			return _novHunt.spawnPosition;
		}	
		else
		{
			return _tousHunt.spawnPosition;
		}		
	}
	
	public function getCurrentHunt(area : ACSHuntArea) : ACSHunt
	{
		switch (area)
		{
			case ACSHA_skellige: return _skeHunt;
			case ACSHA_novigrad: return _novHunt ;
			case ACSHA_toussaint: return _tousHunt;
			default : return _novHunt ;
		}
		
	}
}

storyscene function acs_monster_hunt_beginHunt(player: CStoryScenePlayer)
{
	GetACSWatcher().getMonsterHunt().startHunt();
}
*/