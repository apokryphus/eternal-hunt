// Tutorials

function ACSRageTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodRageTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWeaponArtsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodWeaponArtsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDynamicEnemyBehaviorSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodDynamicEnemyBehaviorSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGuardsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodGuardsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSTransformationWerewolfTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodTransformationWerewolfTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGlideTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMovementTutorials','EHmodGlideTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBruxaDashTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMovementTutorials','EHmodBruxaDashTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWraithModeTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMovementTutorials','EHmodWraithModeTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLightsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodLightsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSQuickMeditationTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodQuickMeditationTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPerfectDodgesCountersTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodPerfectDodgesCountersTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSArmorSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodArmorSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSElementalComboSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodElementalComboSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSQuestTrackingSwapTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodQuestTrackingSwapTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCloakWeaponHideTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodCloakWeaponHideTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWitcherSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodWitcherSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWolfSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodWolfSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBearSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodBearSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCatSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodCatSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSViperSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodViperSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGriffinSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodGriffinSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSManticoreSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodManticoreSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSForgottenWolfSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWitcherSchoolTutorials','EHmodForgottenWolfSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSZirealTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodZirealTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSMaskTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodMaskTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDurabilityTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodDurabilityTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSwordsOnRoachTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodSwordsOnRoachTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSReadingAllItemsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodReadingAllItemsyTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLightningTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodLightningTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSAllBlackTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodAllBlackTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFinisherTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodFinisherTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWispTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel05TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWispLevel05TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel10TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWispLevel10TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel15TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWispLevel15TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel20TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWispLevel20TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel25TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWispLevel25TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWolfHeartTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodWolfHeartTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSVampireNecklaceTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodVampireNecklaceTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSPirateAmuletTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodPirateAmuletTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSHoodAndMaskTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodHoodAndMaskTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSParryTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodParryTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSHitLagEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodHitLagTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSBruxaFangTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodBruxaFangTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVampireRingTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodVampireRingTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSneakingTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodSneakingTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBowOfArtemisTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodBowOfArtemisTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCrossbowOfArtemisTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodCrossbowOfArtemisTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSToadPrinceVenomTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodToadPrinceVenomTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBlackWolfPeltTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodBlackWolfPeltTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSHoldToRollTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodMovementTutorials','EHmodHoldToRollTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSRedMiasmalFragmentTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodRedMiasmalFragmentTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNightVisionTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalFeaturesTutorials','EHmodNightVisionTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSharleyShardTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodSharleyShardTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSignComboSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodCombatTutorials','EHmodSignComboSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKestralSkullTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodKestralSkullTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPhoenixAshesTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodItemTutorials','EHmodPhoenixAshesTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSUmbralSlashTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodUmbralSlashTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSparagmosTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodSparagmosTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVampireBatSwarmTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodVampireBatSwarmTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCaressingMoonTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodCaressingMoonTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSStormSpearTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodStormSpearTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSJudgementTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodJudgementTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWaterPulseTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodWaterPulseTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSEarthShakerTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodEarthShakerTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBruxaScreamTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodBruxaScreamTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWayOfTheFlameTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodWayOfTheFlameTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSHeavenlyStrikeTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodHeavenlyStrikeTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDanceOfWrathTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodDanceOfWrathTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGwynbleiddStanceTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodWeaponArtsTutorials','EHmodGwynbleiddStanceTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Tutorial_Display_Check(tutorial : name)
{
	switch( tutorial )
	{
		case 'ACS_Rage_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Rage_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035359, 2117035360);

			FactsAdd("ACS_Rage_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035361, 2117035362);

			FactsAdd("ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Guards_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Guards_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035363, 2117035364);

			FactsAdd("ACS_Guards_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Werewolf_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Werewolf_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035365, 2117035366);

			FactsAdd("ACS_Werewolf_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Glide_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Glide_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035367, 2117035368);

			FactsAdd("ACS_Glide_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Bruxa_Dash_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Bruxa_Dash_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035369, 2117035370);

			FactsAdd("ACS_Bruxa_Dash_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wraith_Mode_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wraith_Mode_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035371, 2117035372);

			FactsAdd("ACS_Wraith_Mode_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Lights_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Lights_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035447, 2117035448);

			FactsAdd("ACS_Lights_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_QuickMeditation_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_QuickMeditation_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035449, 2117035450);

			FactsAdd("ACS_QuickMeditation_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_PerfectDodgesCounters_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_PerfectDodgesCounters_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035451, 2117035452);

			FactsAdd("ACS_PerfectDodgesCounters_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_ArmorSystem_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_ArmorSystem_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035453, 2117035454);

			FactsAdd("ACS_ArmorSystem_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_ElementalComboSystem_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_ElementalComboSystem_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035474, 2117035475);

			FactsAdd("ACS_ElementalComboSystem_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_QuestTrackingSwap_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_QuestTrackingSwap_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035476, 2117035477);

			FactsAdd("ACS_QuestTrackingSwap_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_CloakWeaponHide_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_CloakWeaponHide_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035478, 2117035479);

			FactsAdd("ACS_CloakWeaponHide_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_WitcherSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_WitcherSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035484, 2117035485);

			FactsAdd("ACS_WitcherSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_WolfSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_WolfSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035498, 2117035499);

			FactsAdd("ACS_WolfSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_BearSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_BearSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035486, 2117035487);

			FactsAdd("ACS_BearSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_CatSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_CatSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035488, 2117035489);

			FactsAdd("ACS_CatSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_ViperSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_ViperSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035496, 2117035497);

			FactsAdd("ACS_ViperSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_GriffinSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_GriffinSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035492, 2117035493);

			FactsAdd("ACS_GriffinSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_ManticoreSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_ManticoreSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035494, 2117035495);

			FactsAdd("ACS_ManticoreSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_ForgottenWolfSchool_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_ForgottenWolfSchool_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035490, 2117035491);

			FactsAdd("ACS_ForgottenWolfSchool_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Zireal_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Zireal_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035500, 2117035501);

			FactsAdd("ACS_Zireal_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Mask_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Mask_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035508, 2117035509);

			FactsAdd("ACS_Mask_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Durability_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Durability_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035511, 2117035512);

			FactsAdd("ACS_Durability_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Reading_All_Items_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Reading_All_Items_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035513, 2117035514);

			FactsAdd("ACS_Reading_All_Items_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Lightning_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Lightning_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035515, 2117035516);

			FactsAdd("ACS_Lightning_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_AllBlack_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_AllBlack_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035520, 2117035521);

			FactsAdd("ACS_AllBlack_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Finisher_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Finisher_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035536, 2117035537);

			FactsAdd("ACS_Finisher_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wisp_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wisp_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035540, 2117035541);

			FactsAdd("ACS_Wisp_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wisp_Level_05_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wisp_Level_05_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035551, 2117035552);

			FactsAdd("ACS_Wisp_Level_05_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wisp_Level_10_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wisp_Level_10_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035553, 2117035554);

			FactsAdd("ACS_Wisp_Level_10_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wisp_Level_15_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wisp_Level_15_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035555, 2117035556);
			
			FactsAdd("ACS_Wisp_Level_15_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wisp_Level_20_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wisp_Level_20_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035557, 2117035558);
			
			FactsAdd("ACS_Wisp_Level_20_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wisp_Level_25_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wisp_Level_25_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035559, 2117035560);
			
			FactsAdd("ACS_Wisp_Level_25_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Wolf_Heart_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Wolf_Heart_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035568, 2117035569);
			
			FactsAdd("ACS_Wolf_Heart_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Vampire_Necklace_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Vampire_Necklace_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035661, 2117035662);
			
			FactsAdd("ACS_Vampire_Necklace_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Pirate_Amulet_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Pirate_Amulet_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035663, 2117035664);
			
			FactsAdd("ACS_Pirate_Amulet_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Hood_And_Mask_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Hood_And_Mask_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035705, 2117035706);
			
			FactsAdd("ACS_Hood_And_Mask_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Parry_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Parry_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035746, 2117035747);
			
			FactsAdd("ACS_Parry_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Weapon_Arts_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Weapon_Arts_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035855, 2117035856);
			
			FactsAdd("ACS_Weapon_Arts_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Bruxa_Fang_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Bruxa_Fang_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035891, 2117035892);
			
			FactsAdd("ACS_Bruxa_Fang_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Vampire_Ring_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Vampire_Ring_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035893, 2117035894);
			
			FactsAdd("ACS_Vampire_Ring_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Sneaking_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Sneaking_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2117035926, 2117035927);
			
			FactsAdd("ACS_Sneaking_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Bow_Of_Artemis_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Bow_Of_Artemis_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449049, 2118449050);
			
			FactsAdd("ACS_Bow_Of_Artemis_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Crossbow_Of_Artemis_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Crossbow_Of_Artemis_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449051, 2118449052);
			
			FactsAdd("ACS_Crossbow_Of_Artemis_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Toad_Prince_Venom_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Toad_Prince_Venom_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449053, 2118449054);
			
			FactsAdd("ACS_Toad_Prince_Venom_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Hold_To_Roll_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Hold_To_Roll_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449074, 2118449075);
			
			FactsAdd("ACS_Hold_To_Roll_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Red_Miasmal_Fragment_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Red_Miasmal_Fragment_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449104, 2118449105);
			
			FactsAdd("ACS_Red_Miasmal_Fragment_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Night_Vision_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Night_Vision_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449126, 2118449127);
			
			FactsAdd("ACS_Night_Vision_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Sharley_Shard_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Sharley_Shard_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449140, 2118449141);
			
			FactsAdd("ACS_Sharley_Shard_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Black_Wolf_Pelt_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Black_Wolf_Pelt_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449332, 2118449333);
			
			FactsAdd("ACS_Black_Wolf_Pelt_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Sign_Combo_System_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Sign_Combo_System_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449161, 2118449162);
			
			FactsAdd("ACS_Sign_Combo_System_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Kestral_Skull_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Kestral_Skull_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449184, 2118449185);
			
			FactsAdd("ACS_Kestral_Skull_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Phoenix_Ashes_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Phoenix_Ashes_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449224, 2118449225);
			
			FactsAdd("ACS_Phoenix_Ashes_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Swords_On_Roach_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Swords_On_Roach_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449293, 2118449294);
			
			FactsAdd("ACS_Swords_On_Roach_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Hit_Lag_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Hit_Lag_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449295, 2118449296);
			
			FactsAdd("ACS_Hit_Lag_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Umbral_Slash_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Umbral_Slash_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449302, 2118449303);
			
			FactsAdd("ACS_Umbral_Slash_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Sparagmos_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Sparagmos_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449304, 2118449305);
			
			FactsAdd("ACS_Sparagmos_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Vampire_Bat_Swarm_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Vampire_Bat_Swarm_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449306, 2118449307);
			
			FactsAdd("ACS_Vampire_Bat_Swarm_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Caressing_Moon_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Caressing_Moon_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449308, 2118449309);
			
			FactsAdd("ACS_Caressing_Moon_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Storm_Spear_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Storm_Spear_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449310, 2118449311);
			
			FactsAdd("ACS_Storm_Spear_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Judgement_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Judgement_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449312, 2118449313);
			
			FactsAdd("ACS_Judgement_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Water_Pulse_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Water_Pulse_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449314, 2118449315);
			
			FactsAdd("ACS_Water_Pulse_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Earthshaker_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Earthshaker_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449316, 2118449317);
			
			FactsAdd("ACS_Earthshaker_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Sonic_Scream_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Sonic_Scream_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449318, 2118449319);
			
			FactsAdd("ACS_Sonic_Scream_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Way_Of_The_Flame_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Way_Of_The_Flame_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449320, 2118449321);
			
			FactsAdd("ACS_Way_Of_The_Flame_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Heavenly_Strike_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Heavenly_Strike_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449322, 2118449323);
			
			FactsAdd("ACS_Heavenly_Strike_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Dance_Of_Wrath_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Dance_Of_Wrath_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449324, 2118449325);
			
			FactsAdd("ACS_Dance_Of_Wrath_Tutorial_Shown", 1, -1);
		}
		break;

		case 'ACS_Gwynbleidd_Stance_Tutorial_Shown': 	
		if (FactsQuerySum("ACS_Gwynbleidd_Stance_Tutorial_Shown") <= 0)
		{
			ACS_Tutorial_Popup_Display(2118449326, 2118449327);
			
			FactsAdd("ACS_Gwynbleidd_Stance_Tutorial_Shown", 1, -1);
		}
		break;

		default:
		break;
	}
}