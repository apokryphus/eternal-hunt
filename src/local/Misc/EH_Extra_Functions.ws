// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
// Not authorized to be distributed elsewhere, unless you ask me nicely.

function ACS_Custom_Attack_Range( data : CPreAttackEventData ) : array< CGameplayEntity >
{
	var targets 					: array<CGameplayEntity>;
	var dist, ang					: float;
	var pos, targetPos				: Vector;
	var i							: int;
	
	pos = thePlayer.GetWorldPosition();
	pos.Z += 0.8;
	
	targets.Clear();
	
	if (!thePlayer.IsPerformingFinisher())
	{
		if ( thePlayer.IsWeaponHeld( 'fist' ) )
		{
			if ( thePlayer.HasTag('vampire_claws_equipped') )
			{
				if ( thePlayer.HasBuff(EET_BlackBlood) )
				{
					dist = 2;
					ang = 90;
				}
				else	
				{
					dist = 1.25;
					ang = 60;
				}
			}
			else 
			{
				dist = 1.25;
				ang = 30;
			}
		}
		else
		{
			if ( 
			thePlayer.HasTag('igni_sword_equipped_TAG') 
			|| thePlayer.HasTag('igni_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	55;

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
			else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
			|| thePlayer.HasTag('igni_secondary_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	55;

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
			else if ( thePlayer.HasTag('axii_sword_equipped') )
			{
				dist = 1.6;
				ang =	55;	

				if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					dist += 10;
					ang +=	30;
				}
			}
			else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
			{
				if ( 
				ACS_GetWeaponMode() == 0
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2
				)
				{
					dist = 2.25;
					ang =	55;
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{ 
					dist = 1.75;
					ang =	55;
				}
			}
			else if ( thePlayer.HasTag('aard_sword_equipped') )
			{
				dist = 2;
				ang =	75;	
			}
			else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
			{
				dist = 2;
				ang = 45;
			}
			else if ( thePlayer.HasTag('yrden_sword_equipped') )
			{
				if ( ACS_GetWeaponMode() == 0 )
				{
					if (ACS_GetArmigerModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 60;
					}
					else 
					{
						dist = 2;
						ang = 30;
					}
				}
				else if ( ACS_GetWeaponMode() == 1 )
				{
					if (ACS_GetFocusModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 60;
					}
					else 
					{
						dist = 2;
						ang = 30;
					}
				}
				else if ( ACS_GetWeaponMode() == 2 )
				{
					if (ACS_GetHybridModeWeaponType() == 0)
					{
						dist = 2.5;
						ang = 60;
					}
					else 
					{
						dist = 2;
						ang = 30;
					}
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{
					dist = 2.5;
					ang = 60;
				}
			}
			else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( thePlayer.HasTag('quen_sword_equipped') )
			{
				dist = 1.6;
				ang =	55;

				if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
				{
					ang +=	320;
				}
			}
			else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
			{
				if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
				{
					dist = 10;
					ang =	30;
				}
				else
				{
					dist = 2.25;
					ang =	55;
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
						dist += 1;
					}
				}
				else
				{
					dist += 1;
				}
			}
		}

		if ( thePlayer.GetTarget() == ACS_Big_Boi() )
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
		&& !thePlayer.HasTag('igni_sword_equipped') 
		&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
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
		dist = 1;
		ang = 30;
	}

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
	  ACS_DisplayWelcomeMessage();
    }
	else
	{
		theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodVersionControl', ACS_GetVersion());
	}

	if (!ACS_SizeIsInitialized())
	{
		theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodSizeInit', "1");

		theGame.GetInGameConfigWrapper().SetVarValue('EHmodVisualSettings', 'EHmodPlayerScale', "1");

		theGame.SaveUserSettings();
	}
}

function ACS_InitNotification() 
{
	theGame.GetGuiManager().ShowNotification(GetLocStringByKey("ACS_initialized"));
}

function ACS_DisplayWelcomeMessage() 
{
	var msg						: W3TutorialPopupData;
	var WelcomeTitle			: string;
	var WelcomeMessage			: string;
	var ImagePath				: string;

	WelcomeTitle = GetLocStringById(2117035665);

	WelcomeMessage = GetLocStringById(2117035666);

	ImagePath = "";

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = WelcomeTitle;

	msg.imagePath = ImagePath;

	msg.messageText = WelcomeMessage;

	msg.enableGlossoryLink = false;

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

function ACSMainSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodMain', nam);

	return value;
}

function ACS_ModEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('EHmodEnabled');
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
	
	configValueString = ACSMainSettingsGetConfigValue('EHmodInit');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACS_SizeIsInitialized(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('EHmodSizeInit');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_VersionControl(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSMainSettingsGetConfigValue('EHmodVersionControl');
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

	theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodSizeInit', "true");

	theGame.GetInGameConfigWrapper().SetVarValue('EHmodMain', 'EHmodVersionControl', ACS_GetVersion());

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'Minimap2Module', "false");

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'QuestsModule', "false");

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodCombatMainSettings', 3);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodParrySkillsSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodCustomFinishersSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodRageMechanicSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodArmigerModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodFocusModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodHybridModeSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodGuardAttackSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodMovementSettings', 1);
	
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodTauntSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodSpecialAbilitiesSettings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodDamageSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodMiscSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodVisualSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodHudSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodStaminaSettings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('EHmodEncountersSettings', 0);

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

function ACSGraphicsSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('Graphics', nam);

	return value;
}

function ACS_GetHairworksMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSGraphicsSettingsGetConfigValue('Virtual_HairWorksLevel');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Combat Main Settings

function ACSCombatMainSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodCombatMainSettings', nam);

	return value;
}

function ACS_GetWeaponMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodWeaponMode');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
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
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodOnHitEffects');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_ElementalRend_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodElementalRend');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_MeleeSpecialCooldown(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodMeleeSpecialCooldown');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7.5;
	}
	
	else return configValue;
}

function ACS_SignCooldown(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodSignCooldown');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5;
	}
	
	else return configValue;
}

function ACS_GetFistMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodFistMode');
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
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodTargetMode');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_ComboMode(): int
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodComboMode');
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
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodCombatStanceEnabled');
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
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodSneakingEnabled');
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
	
	configValueString = ACSCombatMainSettingsGetConfigValue('EHmodDefaultMovesetCombatAnimationOverrideModeEnabled');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
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

function ACSArmigerModeSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodArmigerModeSettings', nam);

	return value;
}

function ACS_GetArmigerModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('EHmodArmigerModeWeaponType');
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
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('EHmodArmigerAxiiSignWeapon');
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
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('EHmodArmigerAardSignWeapon');
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
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('EHmodArmigerYrdenSignWeapon');
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
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('EHmodArmigerQuenSignWeapon');
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
	
	configValueString = ACSArmigerModeSettingsGetConfigValue('EHmodArmigerIgniSignWeapon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Focus Mode

function ACSFocusModeGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodFocusModeSettings', nam);

	return value;
}

function ACS_GetFocusModeSilverWeapon(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSFocusModeGetConfigValue('EHmodFocusModeSilverWeapon');
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
	
	configValueString = ACSFocusModeGetConfigValue('EHmodFocusModeSteelWeapon');
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
	
	configValueString = ACSFocusModeGetConfigValue('EHmodFocusModeWeaponType');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Hybrid Mode

function ACSHybridModeGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodHybridModeSettings', nam);

	return value;
}

function ACS_GetHybridModeWeaponType(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeWeaponType');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeLightAttack');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeForwardLightAttack');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeHeavyAttack');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeForwardHeavyAttack');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeSpecialAttack');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeForwardSpecialAttack');
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
	
	configValueString = ACSHybridModeGetConfigValue('EHmodHybridModeCounterAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Counterattack/Parry Skill Settings

function ACSParrySkillsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodParrySkillsSettings', nam);

	return value;
}

function ACS_ParrySkillsEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSParrySkillsGetConfigValue('EHmodParrySkillsEnabled');
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
	
	configValueString = ACSParrySkillsGetConfigValue('EHmodParrySkillsBind');
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
	
	configValueString = ACSParrySkillsGetConfigValue('EHmodPushSkillsBind');
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
	
	configValueString = ACSParrySkillsGetConfigValue('EHmodDaggerBind');
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

function ACSCustomFinishersGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodCustomFinishersSettings', nam);

	return value;
}

function ACS_CustomFinishersEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodCustomFinishersEnabled');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodAutoFinisherEnabled');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodExperimentalDismemberment');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodCustomFinisherChance');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodCustomFinishersCameraSettings');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersTorsoBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_FinishersStabBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersStabBind');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

function ACS_FinishersNeckBind(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersNeckBind');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersHeadLeftBind');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersHeadRightBind');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersArmLeftBind');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersArmRightBind');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersLegLeftBind');
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
	
	configValueString = ACSCustomFinishersGetConfigValue('EHmodFinishersLegRightBind');
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

function ACSRageMechanicGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodRageMechanicSettings', nam);

	return value;
}

function ACS_RageMechanic_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSRageMechanicGetConfigValue('EHmodRageMechanic');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
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
	
	configValueString = ACSRageMechanicGetConfigValue('EHmodNumberOfEnragedEnemies');
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
	
	configValueString = ACSRageMechanicGetConfigValue('EHmodRageMechanicCooldown');
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
	
	configValueString = ACSRageMechanicGetConfigValue('EHmodRageMechanicRadius');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 10;
	}
	
	else return configValue;
}


// Darkness Settings

function ACSDarknessSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodDarknessSettings', nam);

	return value;
}

function ACS_Darkness_HBAO_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDarknessSettingsGetConfigValue('EHmodDarknessHBAOEnabled');
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
	
	configValueString = ACSDarknessSettingsGetConfigValue('EHmodDarknessSunsetTime');
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
	
	configValueString = ACSDarknessSettingsGetConfigValue('EHmodDarknessSunriseTime');
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
	
	configValueString = ACSDarknessSettingsGetConfigValue('EHmodDarknessIntensity');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.85;
	}
	
	else return configValue;
}

function ACS_Darkness_BlendTime(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSDarknessSettingsGetConfigValue('EHmodDarknessBlendTime');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 7;
	}
	
	else return configValue;
}

// Hud Settings

function ACSHudSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodHudSettings', nam);

	return value;
}

function ACS_Custom_Focus_Mode_Camera_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodCustomFocusModeCameraEnabled');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodFocusModeToggleEnabled');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodFocusModeIntensity');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodInteractionModuleEnabled');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodGuidingLightEnabled');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodGuidingLightDistanceMarkerShowOnlyInWitcherSenseEnabled');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodMarkerVisualBubbleEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_Quest_Marker_Despawn_Delay(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodQuestMarkerDespawnDelay');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodUntrackedQuestMarkerDespawnDelay');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodPOIMarkerDespawnDelay');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodUserPinDespawnDelay');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodQuestMarkerDistanceToDisplay');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodUntrackedQuestMarkerDistanceToDisplay');
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
	
	configValueString = ACSHudSettingsGetConfigValue('EHmodPOIMarkerDistanceToDisplay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 5000;
	}
	
	else return configValue;
}

// Misc Settings

function ACSMiscSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodMiscSettings', nam);

	return value;
}

function ACS_DisableItemAutoscale(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodDisableItemAutoscale');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_AutoWinGwent_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodAutoWinGwentEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodPassiveTauntEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodSwordWalkEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodSlideEverywhereEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodEnhancedSignsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_UnlimitedDurability_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodUnlimitedDurabilityEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodAutoReadEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodVampireSoundEffects');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodHideVampireClaws');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodMutePlayerEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodFireSourcesEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodFireSourcesRange');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodFireSourcesEntities');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodPotionAndFoodAnimationEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodMaskAnimationEnabled');
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
	
	configValueString = ACSMiscSettingsGetConfigValue('EHmodOverrideMeditationButtonnEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Visual Settings

function ACSVisualSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodVisualSettings', nam);

	return value;
}

function ACS_FogSpawn_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodFogSpawnEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodHorseRidersEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodSpiralSkyBandsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodSpiralSkyPlanetsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodSpiralSkyStarsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodPlayerScale');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodAlternateScabbardsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodHideSwordsheathes');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodShowWeaponsWhileCloaked');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodUnequipCloakWhileInCombat');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodAlwaysFurCloak');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_PlayerEffects_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodPlayerEffects');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodWearablwPocketItemsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodWearablePocketItemsPositioning');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodWearableBombsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodWearableBombsPositioning');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

function ACS_AdditionalBloodSpatters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodAdditionalBloodSpatterEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodGoreSpawnerEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodDisableBigCameraLightsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodDisableSmallCameraLightsEnabled');
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
	
	configValueString = ACSVisualSettingsGetConfigValue('EHmodDisableAllCameraLightsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Taunt Settings

function ACSTauntSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodTauntSettings', nam);

	return value;
}

function ACS_TauntSystem_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTauntSettingsGetConfigValue('EHmodTauntSystemEnabled');
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
	
	configValueString = ACSTauntSettingsGetConfigValue('EHmodIWannaPlayGwentEnabled');
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
	
	configValueString = ACSTauntSettingsGetConfigValue('EHmodCombatTauntEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Movement Settings

function ACSMovementSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodMovementSettings', nam);

	return value;
}



// Jump Settings

function ACSJumpSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodJumpSettings', nam);

	return value;
}


function ACS_CombatJump_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodCombatJump');
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
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodJumpExtend');
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
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodJumpExtendEffect');
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
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodJumpExtendNormalHeight');
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
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodJumpExtendNormalDistance');
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
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodJumpExtendSprintingHeight');
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
	
	configValueString = ACSJumpSettingsGetConfigValue('EHmodJumpExtendSprintingDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 12;
	}
	
	else return configValue;
}


// Bruxa Dash Settings

function ACSBruxaDashSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodBruxaDashSettings', nam);

	return value;
}

function ACS_BruxaDash_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('EHmodBruxaDash');
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
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('EHmodBruxaDashSprintOrW');
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
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('EHmodBruxaDashInput');
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
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('EHmodBruxaDashNormalDistance');
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
	
	configValueString = ACSBruxaDashSettingsGetConfigValue('EHmodBruxaDashCombatDistance');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 6;
	}
	
	else return configValue;
}

// Dodge Settings

function ACSDodgeSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodDodgeSettings', nam);

	return value;
}

function ACS_BruxaLeapAttack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodBruxaLeapAttack');
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
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodBruxaDodgeSlideBack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeCenter_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodBruxaDodgeCenter');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeLeft_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodBruxaDodgeLeft');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaDodgeRight_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodBruxaDodgeRight');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_WildHuntBlink_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodWildHuntBlink');
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
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodDodgeEffects');
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
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodDodgeSlowMo');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
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
	
	configValueString = ACSDodgeSettingsGetConfigValue('EHmodHoldToRoll');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Default Geralt Moveset Dodge and Roll Override Settings

function ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings', nam);

	return value;
}









function ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideDodgeEnabled');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeNeutralDodgeOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeForwardDodgeOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeBackwardDodgeOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeLeftDodgeOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeRightDodgeOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideRollEnabled');
	configValue =(int) configValueString;

	if( FactsQuerySum("q001_nightmare_ended") <= 0)
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeNeutralRollOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeForwardRollOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeBackwardRollOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeLeftRollOptions');
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
	
	configValueString = ACSDefaultGeraltMovesetDodgeAndRollOverrideSettingsGetConfigValue('EHmodDefaultMovesetOverrideModeRightRollOptions');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 2;
	}
	
	else return configValue;
}


// Wraith Mode Settings

function ACSWraithModeSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodWraithModeSettings', nam);

	return value;
}

function ACS_WraithMode_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWraithModeSettingsGetConfigValue('EHmodWraithMode');
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
	
	configValueString = ACSWraithModeSettingsGetConfigValue('EHmodWraithModeSprintOrW');
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
	
	configValueString = ACSWraithModeSettingsGetConfigValue('EHmodWraithModeInput');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0;
	}
	
	else return configValue;
}

// Special Abilities Settings

function ACSSpecialAbilitiesSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodSpecialAbilitiesSettings', nam);

	return value;
}

function ACS_SummonedShades_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodSummonedShades');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BeamAttack_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodBeamAttack');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_SwordArray_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodSwordArray');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_ShieldEntity_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodShieldEntity');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_QuenMonsterSummon_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodQuenMonsterSummon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_YrdenSkeleSummon_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodYrdenSkeleSummon');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_AardPull_Enabled(): bool
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodAardPull');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaCamoDecoy_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodBruxaCamoDecoy');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

function ACS_BruxaBite_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialAbilitiesSettingsGetConfigValue('EHmodBruxaBite');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	
	else return (bool)configValueString;
}

// Damage Settings

function ACSDamageSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodDamageSettings', nam);

	return value;
}

function ACS_VampireClawsDamageMaxHealthOrCurrentHealth(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodVampireClawsDamageMaxHealthOrCurrentHealth');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodVampireClawsHumanMaxDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodVampireClawsHumanMinDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodVampireClawsMonsterMaxDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodVampireClawsMonsterMinDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodPlayerFallDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodCrossbowDamageMaxHealthOrCurrentHealth');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodCrossbowHumanMaxDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodCrossbowHumanMinDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodCrossbowMonsterMaxDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodCrossbowMonsterMinDamage');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodPlayerDamageMultiplier');
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
	
	configValueString = ACSDamageSettingsGetConfigValue('EHmodPlayerDamageTakenMultiplier');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

// Stamina Settings

function ACSStaminaSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodStaminaSettings', nam);

	return value;
}

function ACS_StaminaBlockAction_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodStaminaBlockAction');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodStaminaCostAction');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodParryingStaminaCostAction');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodParryingStaminaCost');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodLightAttackStaminaCost');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodHeavyAttackStaminaCost');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodSpecialAttackStaminaCost');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodTransformationActionStaminaCost');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodDodgeStaminaCost');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodParryingStaminaRegenDelay');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodLightAttackStaminaRegenDelay');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodHeavyAttackStaminaRegenDelay');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodSpecialAttackStaminaRegenDelay');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodDodgeStaminaRegenDelay');
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
	
	configValueString = ACSStaminaSettingsGetConfigValue('EHmodTransformationActionStaminaRegenDelay');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 1;
	}
	
	else return configValue;
}

// Encounters Settings

function ACSEncountersSettingsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodEncountersSettings', nam);

	return value;
}

function ACS_ShadowsSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadowsSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_WildHuntSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodWildHuntSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_NightStalkerSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodNightStalkerSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_ElderbloodAssassinSpawnChancesNormal(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodElderbloodAssassinSpawnChancesNormal');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 0.1;
	}
	
	else return configValue;
}

function ACS_DraugirEncounters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodDraugirEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Forest_God_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodForestGodEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Ice_Titans_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodIceTitansEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Fire_Bear_Altar_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodFireBearAltarEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Knightmare_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodKnightmareEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_SheWhoKnows_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodSheWhoKnowsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_BigLizard_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodBigLizardEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_RatMage_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodRatMageEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Mages_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodMagesEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_CloakedVamp_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodCloakedVampEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Draug_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodDraugEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Berserkers_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodBerserkersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_LynxWitchers_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodLynxWitchersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_FireGargoyle_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodFireGargoyleEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Fluffy_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodFluffyEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_FogAssassin_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodFogAssassinEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_XenoTyrantEgg_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodXenoTyrantEggEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Cultists_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodCultistsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_MelusineOfTheStorm_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodMelusineEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_PirateZombie_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodPirateZombieEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Svalblod_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodSvalblodEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Duskwraith_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodDuskwraithEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_MegaWraith_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodMegaWraithEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_FireGryphon_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodFireGryphonEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Incubus_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodIncubusEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Mula_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodMulaEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_BloodHym_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodBloodHymEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_NekkerGuardian_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodNekkerGuardianEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Necrofiend_Nest_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodNecrofiendNestEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_HarpyQueen_Nest_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodHarpyQueenNestEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Heart_Of_Darkness_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodHeartOfDarknessEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Bumbakvetch_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodBumbakvetchEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Frost_Boar_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodFrostBoarEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Nimean_Panther_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodNimeanPantherEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Shadow_Pixies_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadowPixiesEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Maerolorn_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodMaerolornEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Demonic_Construct_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodDemonicConstructEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Dark_Knight_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodDarkKnightEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Voref_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodVorefEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Ifrit_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodIfritEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Viy_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodViyEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Phooca_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodPhoocaEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Plumard_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodPlumardEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_The_Beast_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodTheBeastEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Giant_Trolls_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodGiantTrollsEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Elemental_Titans_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodElementalTitansEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesCrusadersEncounters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesCrusadersEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesHuntersEncounters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesHuntersEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesRoguesEncounters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesRoguesEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesShowdownEncounters_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesShowdownEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesDancerWaxing_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesDancerWaxingEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesDancerWaning_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesDancerWaningEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_Kara_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesKaraEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

function ACS_ShadesNightmareIncarnate_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEncountersSettingsGetConfigValue('EHmodShadesNightmareIncarnateEncountersEnabled');
	configValue =(int) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return true;
	}

	else return (bool)configValueString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SOI_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_050_51');	
}

function ACS_SOI_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_050_51');		
}

function ACS_Warglaives_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_glaives_9897');	
}

function ACS_Warglaives_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_glaives_9897');		
}

function ACS_SCAAR_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('scaaraiov_dlc');	
}

function ACS_SCAAR_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('scaaraiov_dlc');		
}

function ACS_E3ARP_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('e3arp_dlc');	
}

function ACS_E3ARP_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('e3arp_dlc');		
}

function ACS_W3EE_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('w3ee_dlc');	
}

function ACS_W3EE_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('w3ee_dlc');		
}

function ACS_W3EE_Redux_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('reduxw3ee_dlc');	
}

function ACS_W3EE_Redux_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('reduxw3ee_dlc');		
}

function ACS_MS_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('magicspells_rev');	
}

function ACS_MS_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('magicspells_rev');		
}

function ACS_GM_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_gm');	
}

function ACS_GM_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_gm');		
}

function ACS_Ard_Bombs_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_056_710');	
}

function ACS_Ard_Bombs_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_056_710');		
}

function ACS_New_Replacers_Installed(): bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_newreplacers');	
}

function ACS_New_Replacers_Enabled(): bool
{
	return theGame.GetDLCManager().IsDLCEnabled('dlc_newreplacers');		
}

function ACS_New_Replacers_Female_Active(): bool
{
	if (ACS_New_Replacers_Installed() && ACS_New_Replacers_Enabled() && FactsQuerySum("nr_player_female") > 0)
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
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Caranthir_Staff'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Shepherd_Stick'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'

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
	else
	{
		return false;
	}
}

function ACS_GetItem_Iris(): bool
{
	if( thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' ))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_VampClaw(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'q702_vampire_gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'q704_vampire_gloves')	
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_WolfSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_BearSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_CatSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_GriffinSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_ManticoreSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Boots(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Boots')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Boots')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Gloves(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Gloves')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Gloves')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

function ACS_GetItem_Viper_Pants(): bool
{
	if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Pants')
	|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Pants')
	) 
	{
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_ViperSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
		ACS_ForgottenWolfSchool_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
}

function ACS_GetItem_AllBlack_Equipped(): bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_AllBlackNecrosword' 
	)
	{
		ACS_AllBlack_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
}

function ACS_Zireael_Check(): bool
{
	if ( ACS_GetItem_Zireal_Steel()
	|| ACS_GetItem_Zireal_Silver()
	) 
	{
		ACS_Zireal_Tutorial();
		return true;
	}
	else
	{
		return false;
	}
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
			ACS_CloakWeaponHide_Tutorial();
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
	//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Caranthir_Staff'
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
	else
	{
		return false;
	}
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
	else
	{
		return false;
	}
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
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Caranthir_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'

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
		ACS_wh_teleport_entity().CreateAttachment(thePlayer);

		thePlayer.SoundEvent("magic_canaris_teleport_short");

		ACS_wh_teleport_entity().StopEffect('disappear');
		ACS_wh_teleport_entity().PlayEffectSingle('disappear');

		ACS_wh_teleport_entity().PlayEffectSingle('appear');

		ACS_wh_teleport_entity().DestroyAfter(1);

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
		ACS_dolphin_teleport_entity().StopEffect('dolphin');
		ACS_dolphin_teleport_entity().PlayEffectSingle('dolphin');

		thePlayer.SoundEvent('monster_water_mage_combat_spray');

		ACS_dolphin_teleport_entity().DestroyAfter(5);

		thePlayer.RemoveTag('ACS_Dolphin_Teleport');
	}

	if (thePlayer.HasTag('ACS_Iris_Teleport'))
	{
		thePlayer.PlayEffectSingle('ethereal_buff');

		thePlayer.StopEffect('ethereal_buff');

		thePlayer.StopEffect('special_attack_fx');

		thePlayer.SoundEvent('magic_olgierd_tele');

		if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
		&& !thePlayer.HasTag('blood_sucking')
		)
		{
			ACS_Weapon_Respawn();

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		ACS_Marker_Smoke();

		thePlayer.RemoveTag('ACS_Iris_Teleport');
	}

	if (thePlayer.HasTag('ACS_Explosion_Teleport'))
	{
		ACS_explosion_teleport_entity().CreateAttachment(thePlayer);

		ACS_explosion_teleport_entity().StopEffect('smoke_explosion');
		ACS_explosion_teleport_entity().PlayEffectSingle('smoke_explosion');

		ACS_explosion_teleport_entity().DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Explosion_Teleport');
	}

	if (thePlayer.HasTag('ACS_Fountain_Portal_Teleport'))
	{
		ACS_fountain_portal_teleport_entity().StopEffect('portal');
		ACS_fountain_portal_teleport_entity().PlayEffectSingle('portal');

		thePlayer.SoundEvent('magic_geralt_teleport');

		ACS_fountain_portal_teleport_entity().DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Fountain_Portal_Teleport');
	}

	if ( thePlayer.HasTag('ACS_Lightning_Teleport') )
	{
		ACS_lightning_teleport_entity().CreateAttachment(thePlayer);

		ACS_Marker_Lightning();

		//ACS_lightning_teleport_entity().StopEffect('lightning');
		//ACS_lightning_teleport_entity().PlayEffectSingle('lightning');

		//ACS_lightning_teleport_entity().StopEffect('pre_lightning');
		//ACS_lightning_teleport_entity().PlayEffectSingle('pre_lightning');

		ACS_Giant_Lightning_Strike_Mult();

		ACS_lightning_teleport_entity().StopEffect('lighgtning');
		ACS_lightning_teleport_entity().PlayEffectSingle('lighgtning');

		thePlayer.SoundEvent('fx_other_lightning_hit');

		thePlayer.PlayEffectSingle('hit_lightning');
		thePlayer.StopEffect('hit_lightning');

		ACS_lightning_teleport_entity().DestroyAfter(2);

		thePlayer.RemoveTag('ACS_Lightning_Teleport');
	}

	if (thePlayer.HasTag('ACS_Fire_Teleport'))
	{
		ACS_Marker_Fire();

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
	//&& !thePlayer.HasTag('blood_sucking')
	)
	{
		if (!thePlayer.HasTag('aard_sword_equipped'))
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
}

function ACS_ThingsThatShouldBeRemoved()
{
	ACS_ThingsThatShouldBeRemoved_BASE();

	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); 

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
	
	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('blood_sucking')
	)
	{
		if (!thePlayer.HasTag('aard_sword_equipped'))
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
	//&& !thePlayer.HasTag('blood_sucking')
	)
	{
		if (!thePlayer.HasTag('aard_sword_equipped'))
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
	|| (ACS_GM_Installed() && ACS_GM_Enabled())
	|| (ACS_W3EE_Installed() && ACS_W3EE_Enabled())
	|| (ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled())
	)
	{
		return;
	}

	if ((thePlayer.HasTag('igni_secondary_sword_equipped')
	|| thePlayer.HasTag('igni_secondary_sword_equipped_TAG')
	|| thePlayer.HasTag('igni_sword_equipped')
	|| thePlayer.HasTag('igni_sword_equipped_TAG'))
	&& !thePlayer.HasTag('quen_sword_equipped')
	&& !thePlayer.HasTag('axii_sword_equipped')
	&& !thePlayer.HasTag('aard_sword_equipped')
	&& !thePlayer.HasTag('yrden_sword_equipped')
	&& !thePlayer.HasTag('quen_secondary_sword_equipped')
	&& !thePlayer.HasTag('axii_secondary_sword_equipped')
	&& !thePlayer.HasTag('aard_secondary_sword_equipped')
	&& !thePlayer.HasTag('yrden_secondary_sword_equipped')
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

	if(thePlayer.HasTag('quen_sword_equipped'))
	{
		//thePlayer.SoundEvent('g_clothes_step_hard');
		//thePlayer.SoundEvent('grunt_vo_attack_medium');
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
				ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
				ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');
			}
		}
	}

	if (ACS_Griffin_School_Check()
	&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
		ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');

		ACS_Sword_Trail_1().PlayEffectSingle('wraith_trail');
		ACS_Sword_Trail_1().StopEffect('wraith_trail');
	}

	if (ACS_Manticore_School_Check()
	&& thePlayer.HasTag('ACS_Manticore_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
		ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');

		ACS_Sword_Trail_1().PlayEffectSingle('wraith_trail');
		ACS_Sword_Trail_1().StopEffect('wraith_trail');
	}

	if (ACS_Viper_School_Check()
	&& thePlayer.HasTag('ACS_Viper_Special_Attack'))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACS_Sword_Trail_1().PlayEffectSingle('light_trail_extended_fx');
		ACS_Sword_Trail_1().StopEffect('light_trail_extended_fx');

		ACS_Sword_Trail_1().PlayEffectSingle('wraith_trail');
		ACS_Sword_Trail_1().StopEffect('wraith_trail');
	}

	if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
	{
		ACS_Light_Attack_Extended_Trail();
		//ACS_Heavy_Attack_Extended_Trail();
	}

	if ( thePlayer.GetTarget() == ACS_Big_Boi() 
	
	&& ((CNewNPC)thePlayer.GetTarget()).IsFlying()
	
	)
	{
		if (GetWitcherPlayer().HasTag('igni_sword_equipped') || GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
		{
			ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
			ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

			ACSGetEquippedSword().PlayEffectSingle('heavy_trail_extended_fx');
			ACSGetEquippedSword().StopEffect('heavy_trail_extended_fx');
		}

		ACS_Light_Attack_Extended_Trail();

		ACS_Heavy_Attack_Extended_Trail();
	}

	if(thePlayer.HasTag('aard_sword_equipped'))
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

			//GetACSArmorEtherSword().StopEffect('fire_sparks_trail');
			//GetACSArmorEtherSword().PlayEffectSingle('fire_sparks_trail');

			GetACSArmorEtherSword().StopEffect('special_attack_iris');
			GetACSArmorEtherSword().PlayEffectSingle('special_attack_iris');

			GetACSArmorEtherSword().StopEffect('red_fast_attack_buff');
			GetACSArmorEtherSword().PlayEffectSingle('red_fast_attack_buff');

			GetACSArmorEtherSword().StopEffect('red_fast_attack_buff_hit');
			GetACSArmorEtherSword().PlayEffectSingle('red_fast_attack_buff_hit');

			if( thePlayer.IsDoingSpecialAttack(false)
			&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
			)
			{
				GetACSWatcher().Red_Blade_Projectile_Spawner();
				
				GetACSWatcher().ACS_SlowMo();
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_PlayerHitEffects()
{
	//thePlayer.StopAllEffects(); 
	
	if ( ACS_GetWeaponMode() == 0 
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2 )
	{
		if (thePlayer.HasTag('axii_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if ( thePlayer.HasTag('yrden_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('black_trail');
			thePlayer.StopEffect('black_trail');
		}
		else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('hit_lightning');
			thePlayer.StopEffect('hit_lightning');
		}
		else if ( thePlayer.HasTag('aard_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
	}
	else
	{
		if ( thePlayer.HasTag('quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('vampire_claws_equipped' ) )
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
	&& targetDistance <= 15 * 15
	)
	{
		return true;
	}
	else if ( 
	thePlayer.GetAttitude( actor ) == AIA_Friendly 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Friendly
	|| !actor.IsAlive()
	|| actor == thePlayer
	|| targetDistance > 15 * 15
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

function ACS_StartAerondightEffectInit()
{
	var vStartAerondightEffect : cStartAerondightEffect;
	vStartAerondightEffect = new cStartAerondightEffect in theGame;
			
	vStartAerondightEffect.Engage();
}

statemachine class cStartAerondightEffect
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cStartAerondightEffect
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		StartAerondightEffects();
	}
	
	entry function StartAerondightEffects()
	{
		var l_aerondightEnt			: CItemEntity;
		var l_effectComponent		: W3AerondightFXComponent;
		var l_newChargingEffect		: name;
		var m_maxCount					: int;
		
		thePlayer.GetInventory().GetCurrentlyHeldSwordEntity( l_aerondightEnt );
		
		if (!thePlayer.HasTag('aard_sword_equipped'))
		{
			l_newChargingEffect = l_effectComponent.m_visualEffects[ m_maxCount - 1 ];
			
			l_aerondightEnt.PlayEffectSingle( l_newChargingEffect );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_SCAAR_1_Installed()
{
	return;
}

function ACS_SCAAR_2_Installed()
{
	return;
}

function ACS_SCAAR_3_Installed()
{
	return;
}

function ACS_Theft_Prevention_7()
{
	return;
}

function ACS_StopAerondightEffectInit()
{
	var vStopAerondightEffect : cStopAerondightEffect;
	vStopAerondightEffect = new cStopAerondightEffect in theGame;
			
	vStopAerondightEffect.Engage();
}

statemachine class cStopAerondightEffect
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cStopAerondightEffect
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		StopAerondightEffects();
	}
	
	entry function StopAerondightEffects()
	{
		var l_aerondightEnt			: CItemEntity;
		var l_effectComponent		: W3AerondightFXComponent;
		
		thePlayer.GetInventory().GetCurrentlyHeldSwordEntity( l_aerondightEnt );	

		l_effectComponent = (W3AerondightFXComponent)l_aerondightEnt.GetComponentByClassName( 'W3AerondightFXComponent' );
		
		if (thePlayer.HasTag('aard_sword_equipped'))
		{
			l_aerondightEnt.StopAllEffects();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_SCAAR_4_Installed()
{
	return;
}

function ACS_SCAAR_5_Installed()
{
	return;
}

function ACS_SCAAR_6_Installed()
{
	return;
}

function ACS_Theft_Prevention_6()
{
	return;
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
	if (!thePlayer.IsInCombat() && thePlayer.HasTag('vampire_claws_equipped'))
	{
		thePlayer.PlayEffectSingle('claws_effect');
		thePlayer.StopEffect('claws_effect');

		ClawDestroy();
	}

	thePlayer.RemoveTag('ACS_ExplorationDelayTag');
}

function ACS_CombatToExplorationCheck() : bool
{
	if ( thePlayer.HasTag('ACS_ExplorationDelayTag') || thePlayer.IsGuarded() || thePlayer.IsInGuardedState() || theInput.GetActionValue('LockAndGuard') > 0.5 )
	{
		return false;
	}
	else
	{
		return true;
	}	
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Setup_Combat_Action_Light()
{
	if (thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
	{
		thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
	}
	
	if (!thePlayer.HasTag('igni_sword_equipped_TAG'))
	{
		thePlayer.AddTag('igni_sword_equipped_TAG');	
	}
	
	thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
}

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
		Attack_Light_Latent();
	}
	
	latent function Attack_Light_Latent()
	{
		if (thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			thePlayer.AddTag('igni_sword_equipped_TAG');	
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


function ACS_Setup_Combat_Action_Heavy()
{
	if (thePlayer.HasTag('igni_sword_equipped_TAG'))
	{
		thePlayer.RemoveTag('igni_sword_equipped_TAG');	
	}
	
	if (!thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
	{
		thePlayer.AddTag('igni_secondary_sword_equipped_TAG');	
	}

	thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
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
		Attack_Heavy_Latent();
	}
	
	latent function Attack_Heavy_Latent()
	{
		GetACSWatcher().RemoveTimer('DefaltSwordWalk');

		thePlayer.RemoveTag('ACS_IsSwordWalking');

		if (thePlayer.HasTag('igni_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('igni_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.AddTag('igni_secondary_sword_equipped_TAG');	
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
		CastSign_Latent();
	}
	
	latent function CastSign_Latent()
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

struct ACS_Manual_Sword_Drawing_Check 
{
	var manual_sword_drawing	: int;
}

function ACS_Manual_Sword_Drawing_Check_Actual(): int 
{
	var property: ACS_Manual_Sword_Drawing_Check;

	property = GetACSWatcher().vACS_Manual_Sword_Drawing_Check;

	return property.manual_sword_drawing;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSWatcher() : W3ACSWatcher
{
	var watcher 			 : W3ACSWatcher;
	
	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

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
		CreateAttachment ( thePlayer );
	}
	
	timer function waitForPlayer( deltaTime : float , id : int)
	{	
		if ( thePlayer )
		{
			if ( !GetACSWatcher() )
			{
				ACS_Watcher_Summon();
				RemoveTimer( 'waitForPlayer' );
				this.Destroy();
			}
		}
	}

	public function ACSFactsStuff() 
	{
    	FactsRemove("acs_started");
   		FactsAdd("acs_started", 1);
    }
}

function ACS_Watcher_Summon()
{
	var ent : W3ACSWatcher;

	ent = (W3ACSWatcher)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\ACS_Baraddur.w2ent", true ), thePlayer.GetWorldPosition() );
}

function GetACSLookatEntity() : CEntity
{
	var ent 							 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'acs_lookat_entity' );
	return ent;
}

function GetACSTestEnt() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Test_Ent' );
	return ent;
}

function GetACSTestEnt_Array() : array<CEntity>
{
	var ents 											: array<CEntity>;
	
	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	return ents;
}

function GetACSTestEnt_Array_Destroy()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function GetACSTestEnt_Array_StopEffects()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Test_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].StopAllEffects();
		ents[i].DestroyAfter(1);
	}

	thePlayer.SoundEvent("magic_man_tornado_loop_stop");
}

function GetACSArmorCone() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Armor_Cone' );
	return entity;
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

	GetACSArmorCone().Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Armor_Cone');

	ent.DestroyAfter(1);

	if (thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
	&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina))
	{
		ent.PlayEffectSingle('acs_armor_cone_orig');
	}
	else
	{
		ent.PlayEffectSingle('acs_armor_cone');
	}


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

function ACSTentacleTestDestroy()
{
	var skeleton 											: array<CActor>;
	var i													: int;
	
	skeleton.Clear();

	theGame.GetActorsByTag( 'ACS_Test_Tentacle', skeleton );	
	
	for( i = 0; i < skeleton.Size(); i += 1 )
	{
		skeleton[i].Destroy();
	}
}

function ACSTentacleTestAnchorDestroy()
{
	var skeleton 											: array<CEntity>;
	var i													: int;
	
	skeleton.Clear();

	theGame.GetEntitiesByTag( 'acs_tentacle_test_anchor', skeleton );	
	
	for( i = 0; i < skeleton.Size(); i += 1 )
	{
		skeleton[i].Destroy();
	}
}

exec function acsspawn( optional entTag: name )
{
	var ent	: CACSMonsterSpawner;

	ent = (CACSMonsterSpawner)theGame.CreateEntity( 

	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 
	
	theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10, 

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

exec function acsspawnunseenblade()
{
	ACS_Blade_Of_The_Unseen().Destroy();

	GetACSStorage().Number_Of_Bruxae_Slain_Reset();

	GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
	GetACSWatcher().RemoveTimer('unseen_blade_hunt_delay');

	ACS_Unseen_Blade_Summon_Start();
}

exec function acsspawnunseenmonster()
{
	ACS_Blade_Of_The_Unseen().Destroy();

	GetACSStorage().Unseen_Blade_Death_Count_Reset();
		
	ACS_Unseen_Monster_Summon_Start();
}

function GetACSNaglfar() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Naglfar' );
	return entity;
}

function GetACSNaglfarPortal() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Naglfar_Portal' );
	return entity;
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

	GetACSSummonedConstruct_1().Destroy();

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
		

	GetACSSummonedConstruct_2().Destroy();

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
	|| thePlayer.HasTag('blood_sucking')
	|| npc.HasTag('ACS_Final_Fear_Stack')
	|| thePlayer.HasTag('ACS_Transformation_Bruxa_Cloaked')
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
				|| (thePlayer.IsCastingSign() && !thePlayer.HasTag('vampire_claws_equipped'))
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

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

	if( actors.Size() == 0 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality )) * 0.05 );
	}
	else if( actors.Size() >= 1 && actors.Size() < 2 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality ))  * 0.1 );
	}
	else if( actors.Size() >= 2 && actors.Size() < 3 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality ))  * 0.15 );
	}
	else if( actors.Size() >= 3 )
	{
		thePlayer.GainStat( BCS_Vitality, (thePlayer.GetStatMax( BCS_Vitality ) - thePlayer.GetStat( BCS_Vitality )) * 0.2 );
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

function acslynxwitchertargetable( b : bool )
{	
	var actors 											: array<CActor>;
	var i												: int;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Lynx_Witcher', actors );	
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CActor)actors[i]).SetTatgetableByPlayer(b);
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

			currentQuestPos = GetACSGuidingLightMarker().GetWorldPosition();

			currentPOIPos = GetACSGuidingLightPOIMarker().GetWorldPosition();

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
			if (ACS_GetWeaponMode() == 0 && ACS_GetFistMode() == 1)
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else if (ACS_GetWeaponMode() == 1 && ACS_GetFistMode() == 1)
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else if (ACS_GetWeaponMode() == 2 && ACS_GetFistMode() == 1)
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}
			else if (ACS_GetWeaponMode() == 3 && (ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()))
			{
				return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
			}

			if (thePlayer.HasTag('vampire_claws_equipped') || ACS_Transformation_Activated_Check())
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

function GetACSEredinSkirtAnchor() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Eredin_Skirt_Anchor' );
	return ent;
}

function GetACSEredinSkirt() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Eredin_Skirt' );
	return ent;
}


function GetACSEredinCloakAnchor() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Eredin_Cloak_Anchor' );
	return ent;
}

function GetACSEredinCloak() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Eredin_Cloak' );
	return ent;
}

function GetACSVGXEredinCloakAnchor() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_VGX_Eredin_Cloak_Anchor' );
	return ent;
}

function GetACSVGXEredinCloak() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_VGX_Eredin_Cloak' );
	return ent;
}



function GetACSImlerithSkirtAnchor() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Imlerith_Skirt_Anchor' );
	return ent;
}

function GetACSImlerithSkirt() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Imlerith_Skirt' );
	return ent;
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

function GetACSTestModule() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Test_Module' );
	return entity;
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

	GetACSWatcher().ACS_Guiding_Light_Untracked_Quest_Marker_Remove();

	GetACSWatcher().ACS_Guiding_Light_Untracked_Marker_Distance_Remove();

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

			GetACSWatcher().ACS_Guiding_Light_Untracked_Quest_Marker_Remove();

			if (FactsQuerySum("ACS_Guiding_Light_Untracked_Quest_Marker_Distance_Available") > 0)
			{
				GetACSWatcher().ACS_Guiding_Light_Untracked_Marker_Distance_Remove();

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
	
	if ( thePlayer.HasBuff( EET_OverEncumbered ) )
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

		if( thePlayer.IsTerrainTooSteepToRunUp() )
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


	if (actor.HasAbility('mon_siren_base'))
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

function GetACSSlideParticleLeft() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Slide_Particle_Left' );
	return entity;
}

function GetACSSlideParticleRight() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Slide_Particle_Right' );
	return entity;
}

function ACS_SlideEverywhereCommand() : CName
{
	return 'Jump';
}

function ACS_IsSlideEverywherePressed() : bool
{
	if (ACS_SlideEverywhere_Enabled())
	{
		return theInput.IsActionPressed(ACS_SlideEverywhereCommand());
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

function ACSVampireClawsEquippedCheck() : bool
{
	if (ACS_GetWeaponMode() == 0 && ACS_GetFistMode() == 1)
	{
		return true;
	}
	else if (ACS_GetWeaponMode() == 1 && ACS_GetFistMode() == 1)
	{
		return true;
	}
	else if (ACS_GetWeaponMode() == 2 && ACS_GetFistMode() == 1)
	{
		return true;
	}
	else if (ACS_GetWeaponMode() == 3)
	{
		if (ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades())
		{
			return true;
		}
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

statemachine class W3ACSGuidingLightMarkerEntity extends CActor
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
	}

	event OnTakeDamage( action : W3DamageAction )
	{
	}

	event OnDeath( damageData : W3DamageAction )
	{
	}
}

function ACS_IsVanillaTargetCloseEnough( target : CEntity ) : bool
{
	var VISIBILITY_DISTANCE : float;	
	
	VISIBILITY_DISTANCE = 45; 

	return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
}

function ACS_IsQuestMarkerTrackedCloseEnough( target : CEntity ) : bool
{
	var VISIBILITY_DISTANCE : float;	
	
	VISIBILITY_DISTANCE = ACS_Quest_Marker_Distance_To_Display(); 

	return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
}

function ACS_IsQuestMarkerUntrackedCloseEnough( target : CEntity ) : bool
{
	var VISIBILITY_DISTANCE : float;	
	
	VISIBILITY_DISTANCE = ACS_Untracked_Quest_Marker_Distance_To_Display(); 

	return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
}

function ACS_IsPOIMarkerCloseEnough( target : CEntity ) : bool
{
	var VISIBILITY_DISTANCE : float;	
	
	VISIBILITY_DISTANCE = ACS_POI_Quest_Marker_Distance_To_Display(); 

	return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
}

function ACS_HUD_Marker_Manager( target : CEntity, mcOneliner : CScriptedFlashSprite)
{
	var screenPos			: Vector;

	if ( target.HasTag('ACS_Guiding_Light_Marker'))
	{
		if ( target && ACS_IsQuestMarkerTrackedCloseEnough(target))
		{
			if ( GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
			{
				screenPos.Y -= 45;
				mcOneliner.SetPosition( screenPos.X, screenPos.Y );
				mcOneliner.SetVisible( true );
			}
			else
			{
				mcOneliner.SetVisible( false );
			}
		}
		else
		{
			mcOneliner.SetVisible( false );
		}
	}
	else if ( target.HasTag('ACS_All_Tracked_Quest_Entity')
	|| target.HasTag('ACS_Guiding_Light_Available_Quest_Marker'))
	{
		if ( target && ACS_IsQuestMarkerUntrackedCloseEnough(target))
		{
			if ( GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
			{
				screenPos.Y -= 45;
				mcOneliner.SetPosition( screenPos.X, screenPos.Y );
				mcOneliner.SetVisible( true );
			}
			else
			{
				mcOneliner.SetVisible( false );
			}
		}
		else
		{
			mcOneliner.SetVisible( false );
		}
	}
	else if ( target.HasTag('ACS_Guiding_Light_POI_Marker'))
	{
		if ( target && ACS_IsPOIMarkerCloseEnough(target))
		{
			if ( GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
			{
				screenPos.Y -= 45;
				mcOneliner.SetPosition( screenPos.X, screenPos.Y );
				mcOneliner.SetVisible( true );
			}
			else
			{
				mcOneliner.SetVisible( false );
			}
		}
		else
		{
			mcOneliner.SetVisible( false );
		}
	}
	else
	{
		if ( target )
		{
			if ( GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
			{
				screenPos.Y -= 45;
				mcOneliner.SetPosition( screenPos.X, screenPos.Y );
				mcOneliner.SetVisible( true );
			}
			else
			{
				mcOneliner.SetVisible( false );
			}
		}
		else
		{
			mcOneliner.SetVisible( false );
		}
	}
}